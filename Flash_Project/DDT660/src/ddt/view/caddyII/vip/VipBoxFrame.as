package ddt.view.caddyII.vip
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.EquipType;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.events.BagEvent;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.view.caddyII.CaddyBagView;
   import ddt.view.caddyII.CaddyEvent;
   import ddt.view.caddyII.CaddyModel;
   import ddt.view.caddyII.MoveSprite;
   import ddt.view.caddyII.RightView;
   import flash.events.Event;
   
   public class VipBoxFrame extends Frame
   {
      
      public static const VerticalOffset:int = -50;
      
      private var _bg:ScaleBitmapImage;
      
      private var _view:VipViewII;
      
      private var _bag:CaddyBagView;
      
      private var _moveSprite:MoveSprite;
      
      private var _closeAble:Boolean = true;
      
      private var _itemInfo:ItemTemplateInfo;
      
      private var _type:int;
      
      private var _caddyAwardCount:int = 0;
      
      private var _closed:Boolean = false;
      
      private var _selectInfo:InventoryItemInfo;
      
      public function VipBoxFrame(type:int, itemInfo:ItemTemplateInfo = null)
      {
         super();
         this._itemInfo = itemInfo;
         this._type = type;
         this.initView(type);
         this.initEvents();
      }
      
      public function setCaddyType(id:int) : void
      {
         CaddyModel.instance.caddyType = id;
      }
      
      public function setBeadType(id:int) : void
      {
         CaddyModel.instance.beadType = id;
      }
      
      public function setOfferType(id:int) : void
      {
         CaddyModel.instance.offerType = id;
      }
      
      public function setCardType(id:int, place:int) : void
      {
         this._view.setCard(id,place);
      }
      
      private function initView(type:int) : void
      {
         CaddyModel.instance.setup(type);
         this._bg = ComponentFactory.Instance.creatComponentByStylename("asset.vipFrame.bg");
         addToContent(this._bg);
         this._view = ComponentFactory.Instance.creatCustomObject("caddy.VipViewII");
         this._view.item = this._itemInfo;
         addToContent(this._view);
         this._bag = ComponentFactory.Instance.creatCustomObject("caddy.CaddyBagView");
         addToContent(this._bag);
         this._moveSprite = ComponentFactory.Instance.creatCustomObject("caddy.MoveSprite",[this._itemInfo]);
         addToContent(this._moveSprite);
      }
      
      private function initEvents() : void
      {
         addEventListener(FrameEvent.RESPONSE,this._response);
         this._view.addEventListener(RightView.START_TURN,this._startTurn);
         this._view.addEventListener(RightView.START_MOVE_AFTER_TURN,this._turnComplete);
         this._bag.addEventListener(CaddyBagView.NULL_CELL_POINT,this._getCellPoint);
         this._bag.addEventListener(CaddyBagView.GET_GOODSINFO,this._getGoodsInfo);
         this._moveSprite.addEventListener(MoveSprite.QUEST_CELL_POINT,this._questCellPoint);
         this._moveSprite.addEventListener(MoveSprite.MOVE_COMPLETE,this._moveComplete);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.LOTTERY_OPNE,this.__lotteryOpen);
      }
      
      private function __lotteryOpen(event:CrazyTankSocketEvent) : void
      {
         if(Boolean(this._itemInfo) && (this._itemInfo.TemplateID == EquipType.CADDY || this._itemInfo.TemplateID == EquipType.BOMB_KING_BLESS))
         {
            this._caddyAwardCount = event.pkg.readInt();
         }
      }
      
      private function removeEvents() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this._response);
         this._view.removeEventListener(RightView.START_TURN,this._startTurn);
         this._view.removeEventListener(RightView.START_MOVE_AFTER_TURN,this._turnComplete);
         this._bag.removeEventListener(CaddyBagView.NULL_CELL_POINT,this._getCellPoint);
         this._bag.removeEventListener(CaddyBagView.GET_GOODSINFO,this._getGoodsInfo);
         this._moveSprite.removeEventListener(MoveSprite.QUEST_CELL_POINT,this._questCellPoint);
         this._moveSprite.removeEventListener(MoveSprite.MOVE_COMPLETE,this._moveComplete);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.LOTTERY_OPNE,this.__lotteryOpen);
      }
      
      private function _response(evt:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         if(!this._view.openBtnEnable)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.caddy.VipClose"));
            return;
         }
         if(evt.responseCode == FrameEvent.CLOSE_CLICK || evt.responseCode == FrameEvent.ESC_CLICK)
         {
            if(this._bag.checkCell())
            {
               this._showCloseAlert();
            }
            else
            {
               ObjectUtils.disposeObject(this);
            }
         }
      }
      
      private function _responseII(e:FrameEvent) : void
      {
         var alert:BaseAlerFrame = null;
         SoundManager.instance.play("008");
         (e.currentTarget as BaseAlerFrame).removeEventListener(FrameEvent.RESPONSE,this._responseII);
         switch(e.responseCode)
         {
            case FrameEvent.CANCEL_CLICK:
               alert = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("tank.view.caddy.sellAllNode") + this._bag.getSellAllPriceString(),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,true,true,LayerManager.ALPHA_BLOCKGOUND);
               alert.moveEnable = false;
               alert.addEventListener(FrameEvent.RESPONSE,this._responseI);
               ObjectUtils.disposeObject(e.currentTarget);
               break;
            case FrameEvent.ESC_CLICK:
            case FrameEvent.CLOSE_CLICK:
               ObjectUtils.disposeObject(e.currentTarget);
               break;
            case FrameEvent.SUBMIT_CLICK:
            case FrameEvent.ENTER_CLICK:
               ObjectUtils.disposeObject(e.currentTarget);
               ObjectUtils.disposeObject(this);
               if(this._type == CaddyModel.BEAD_TYPE)
               {
                  PlayerManager.Instance.Self.dispatchEvent(new BagEvent(BagEvent.SHOW_BEAD,null));
               }
         }
      }
      
      private function _responseI(e:FrameEvent) : void
      {
         (e.currentTarget as BaseAlerFrame).removeEventListener(FrameEvent.RESPONSE,this._responseI);
         if(e.responseCode == FrameEvent.ENTER_CLICK || e.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            SocketManager.Instance.out.sendSellAll();
         }
         else
         {
            this._showCloseAlert();
         }
         ObjectUtils.disposeObject(e.currentTarget);
      }
      
      private function _showCloseAlert() : void
      {
         var alert:BaseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("tank.view.caddy.closeNode"),LanguageMgr.GetTranslation("tank.view.caddy.putInBag"),LanguageMgr.GetTranslation("tank.view.caddy.sellAll"),false,false,false,LayerManager.ALPHA_BLOCKGOUND);
         alert.addEventListener(FrameEvent.RESPONSE,this._responseII);
      }
      
      private function _questCellPoint(e:Event) : void
      {
         this._bag.findCell();
      }
      
      private function _turnComplete(e:Event) : void
      {
         if(this._selectInfo.TemplateID == EquipType.BADLUCK_STONE)
         {
            this._startMove(null);
         }
         else
         {
            this._moveComplete(null);
         }
      }
      
      private function _moveComplete(e:Event) : void
      {
         if(this._closed)
         {
            return;
         }
         this._bag.addCell();
         this._view.again();
         if(this._view.openBtnEnable)
         {
            this._bag.sellBtn.enable = true;
         }
         this.closeAble = true;
      }
      
      private function _startTurn(e:CaddyEvent) : void
      {
         this._moveSprite.setInfo(e.info);
         this._bag.sellBtn.enable = false;
         this.closeAble = false;
      }
      
      public function turnComplete(e:Event) : void
      {
      }
      
      private function _startMove(e:Event) : void
      {
         this._moveSprite.startMove();
      }
      
      private function _getCellPoint(e:CaddyEvent) : void
      {
         this._moveSprite.setMovePoint(e.point);
      }
      
      private function _getGoodsInfo(e:CaddyEvent) : void
      {
         this._selectInfo = e.info;
         if(!this._closed)
         {
            this._view.setSelectGoodsInfo(e.info);
         }
      }
      
      public function show() : void
      {
         this._view.setType(CaddyModel.VIP_TYPE);
         titleText = LanguageMgr.GetTranslation("tank.view.vip.title");
         escEnable = true;
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
         y += VerticalOffset;
      }
      
      public function set closeAble(value:Boolean) : void
      {
         this._closeAble = value;
      }
      
      public function get closeAble() : Boolean
      {
         return this._closeAble;
      }
      
      override public function dispose() : void
      {
         this.removeEvents();
         SocketManager.Instance.out.sendFinishRoulette();
         this._closed = true;
         if(Boolean(this._view))
         {
            ObjectUtils.disposeObject(this._view);
         }
         this._view = null;
         if(Boolean(this._bag))
         {
            ObjectUtils.disposeObject(this._bag);
         }
         this._bag = null;
         if(Boolean(this._moveSprite))
         {
            ObjectUtils.disposeObject(this._moveSprite);
         }
         this._moveSprite = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
         super.dispose();
      }
   }
}

