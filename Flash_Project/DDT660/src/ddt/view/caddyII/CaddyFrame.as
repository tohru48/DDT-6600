package ddt.view.caddyII
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
   import ddt.manager.ChatManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.RouletteManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.view.caddyII.badLuck.BadLuckView;
   import ddt.view.caddyII.badLuck.BlessLuckView;
   import ddt.view.caddyII.card.CardViewII;
   import ddt.view.caddyII.reader.CaddyUpdate;
   import flash.display.DisplayObject;
   import flash.events.Event;
   
   public class CaddyFrame extends Frame
   {
      
      public static const VerticalOffset:int = -50;
      
      private var _bg:ScaleBitmapImage;
      
      private var _view:RightView;
      
      private var _bag:CaddyBagView;
      
      private var _reader:CaddyUpdate;
      
      private var _moveSprite:MoveSprite;
      
      private var _closeAble:Boolean = true;
      
      private var _itemInfo:ItemTemplateInfo;
      
      private var _type:int;
      
      private var _caddyAwardCount:int = 0;
      
      private var _closed:Boolean = false;
      
      private var _selectInfo:InventoryItemInfo;
      
      public function CaddyFrame(type:int, itemInfo:ItemTemplateInfo = null)
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
         CardViewII.instance.setCard(id,place);
      }
      
      private function initView(type:int) : void
      {
         CaddyModel.instance.setup(type);
         this._bg = ComponentFactory.Instance.creatComponentByStylename("asset.caddyFrame.bg");
         addToContent(this._bg);
         this._bag = ComponentFactory.Instance.creatCustomObject("caddy.CaddyBagView");
         addToContent(this._bag);
         if(this._type == CaddyModel.BEAD_TYPE || this._type == CaddyModel.MYSTICAL_CARDBOX || this._type == CaddyModel.CADDY_TYPE || this._type == CaddyModel.OFFER_PACKET || this._type == CaddyModel.BOMB_KING_BLESS || this._type == CaddyModel.CELEBRATION_BOX)
         {
            this._reader = CaddyModel.instance.readView;
            addToContent(this._reader as DisplayObject);
         }
         else
         {
            this._bg.width = 602;
         }
         this._view = CaddyModel.instance.rightView;
         this._view.item = this._itemInfo;
         addToContent(this._view);
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
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.UPDATE_PRIVATE_INFO,this.__updateInfo);
         ChatManager.Instance.addEventListener(CrazyTankSocketEvent.BUY_BEAD,this.__buyBeads);
      }
      
      private function __updateInfo(e:CrazyTankSocketEvent) : void
      {
         if(this._reader is BadLuckView)
         {
            this._reader.update();
         }
         else if(this._reader is BlessLuckView)
         {
            this._reader.update();
         }
      }
      
      private function __lotteryOpen(event:CrazyTankSocketEvent) : void
      {
         if(Boolean(this._itemInfo) && (this._itemInfo.TemplateID == EquipType.CADDY || this._itemInfo.TemplateID == EquipType.BOMB_KING_BLESS))
         {
            this._caddyAwardCount = event.pkg.readInt();
         }
      }
      
      private function __buyBeads(event:Event) : void
      {
         var newBeadID:int = 0;
         if(EquipType.isBeadFromSmeltByID(CaddyModel.instance.beadType))
         {
            ObjectUtils.disposeObject(this);
            newBeadID = this.getOpenBeadType(CaddyModel.instance.beadType);
            if(newBeadID >= 0)
            {
               RouletteManager.instance.useBead(newBeadID);
            }
         }
      }
      
      private function getOpenBeadType(id:int) : int
      {
         if(EquipType.isAttackBeadFromSmeltByID(id))
         {
            return CaddyModel.Bead_Attack;
         }
         if(EquipType.isDefenceBeadFromSmeltByID(id))
         {
            return CaddyModel.Bead_Defense;
         }
         if(EquipType.isAttributeBeadFromSmeltByID(id))
         {
            return CaddyModel.Bead_Attribute;
         }
         return -1;
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
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.UPDATE_PRIVATE_INFO,this.__updateInfo);
         ChatManager.Instance.removeEventListener(CrazyTankSocketEvent.BUY_BEAD,this.__buyBeads);
      }
      
      private function _response(evt:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         if(!this._view.openBtnEnable)
         {
            MessageTipManager.getInstance().show(CaddyModel.instance.dontClose);
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
            if(Boolean(this._bag.getAllBtn))
            {
               this._bag.getAllBtn.enable = true;
            }
         }
         this.closeAble = true;
         if(Boolean(this._itemInfo) && this._itemInfo.TemplateID == EquipType.CADDY)
         {
            if(this._caddyAwardCount == CaddyAwardModel.getInstance().silverAwardCount || this._caddyAwardCount % 10 == CaddyAwardModel.getInstance().silverAwardCount)
            {
               if(this._caddyAwardCount % 100 != 96)
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.daddy.SilverAward"));
               }
            }
            else if(this._caddyAwardCount == CaddyAwardModel.getInstance().goldAwardCount || this._caddyAwardCount % 10 == CaddyAwardModel.getInstance().goldAwardCount)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.daddy.GoldAward"));
            }
         }
         if(Boolean(this._itemInfo) && this._itemInfo.TemplateID == EquipType.BOMB_KING_BLESS)
         {
            if(this._caddyAwardCount == CaddyAwardModel.getInstance().silverAwardCount || this._caddyAwardCount % 10 == CaddyAwardModel.getInstance().silverAwardCount)
            {
               if(this._caddyAwardCount % 100 != 96)
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.daddy.SilverBless"));
               }
            }
            else if(this._caddyAwardCount == CaddyAwardModel.getInstance().goldAwardCount || this._caddyAwardCount % 10 == CaddyAwardModel.getInstance().goldAwardCount)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.daddy.GoldBless"));
            }
         }
      }
      
      private function _startTurn(e:CaddyEvent) : void
      {
         this._moveSprite.setInfo(e.info);
         this._bag.sellBtn.enable = false;
         this.closeAble = false;
      }
      
      public function turnComplete(e:Event) : void
      {
         this._moveSprite;
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
         if(this._type == CaddyModel.BEAD_TYPE || this._type == CaddyModel.MYSTICAL_CARDBOX || this._type == CaddyModel.MY_CARDBOX)
         {
            this._view.setType(CaddyModel.instance.beadType);
         }
         else if(this._type == CaddyModel.CADDY_TYPE)
         {
            this._view.setType(CaddyModel.CADDY_TYPE);
         }
         else if(this._type == CaddyModel.BOMB_KING_BLESS)
         {
            this._view.setType(CaddyModel.BOMB_KING_BLESS);
         }
         titleText = CaddyModel.instance.CaddyFrameTitle;
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
         if(Boolean(this._reader))
         {
            ObjectUtils.disposeObject(this._reader);
         }
         this._reader = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
         super.dispose();
      }
   }
}

