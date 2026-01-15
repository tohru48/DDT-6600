package ddt.view.caddyII
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.controls.container.SimpleTileList;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.MovieImage;
   import com.pickgliss.ui.image.MutipleImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.BagInfo;
   import ddt.data.EquipType;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.events.BagEvent;
   import ddt.events.CellEvent;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.events.PlayerPropertyEvent;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.utils.Dictionary;
   import road7th.comm.PackageIn;
   
   public class CaddyBagView extends Sprite implements Disposeable
   {
      
      public static const NUMBER:int = 5;
      
      public static const SUM_NUMBER:int = 30;
      
      public static const NULL_CELL_POINT:String = "send_nullCell_poing";
      
      public static const GET_GOODSINFO:String = "caddy_get_goodsinfo";
      
      private var _bg:MutipleImage;
      
      private var _list:SimpleTileList;
      
      protected var _sellAllBtn:BaseButton;
      
      protected var _getAllBtn:BaseButton;
      
      private var _openAll:SimpleBitmapButton;
      
      private var _convertedBtn:BaseButton;
      
      private var _exchangeBtn:SimpleBitmapButton;
      
      private var _exchangeTxt:FilterFrameText;
      
      private var _CaddyInfo:CaddyInfo;
      
      private var isConver:Boolean = false;
      
      private var isAlert:Boolean = false;
      
      private var _selectPlace:int = 0;
      
      private var _bg2:MovieImage;
      
      private var _selectedGoodsInfo:InventoryItemInfo;
      
      private var _items:Vector.<CaddyCell>;
      
      public function CaddyBagView()
      {
         super();
         this.initView();
         this.initEvents();
      }
      
      protected function initView() : void
      {
         var j:uint = 0;
         var item1:CaddyCell = null;
         var n:uint = 0;
         var item3:CaddyCell = null;
         this._bg = ComponentFactory.Instance.creatComponentByStylename("caddy.LeftBG");
         addChild(this._bg);
         this._bg2 = ComponentFactory.Instance.creatComponentByStylename("ddtCaddbagView");
         addChild(this._bg2);
         this._list = ComponentFactory.Instance.creatCustomObject("caddy.SimpleTileList",[NUMBER]);
         addChild(this._list);
         this._CaddyInfo = new CaddyInfo();
         if(CaddyModel.instance.type == CaddyModel.MYSTICAL_CARDBOX || CaddyModel.instance.type == CaddyModel.MY_CARDBOX)
         {
            this._openAll = ComponentFactory.Instance.creatComponentByStylename("CaddyCardBoxBag.openAllBtn");
            addChild(this._openAll);
         }
         if(CaddyModel.instance.type == CaddyModel.BEAD_TYPE || CaddyModel.instance.type == CaddyModel.OFFER_PACKET || CaddyModel.instance.type == CaddyModel.CADDY_TYPE || CaddyModel.instance.type == CaddyModel.VIP_TYPE)
         {
            this._list = ComponentFactory.Instance.creatCustomObject("caddy.SimpleTileList",[NUMBER]);
            addChild(this._list);
            this._items = new Vector.<CaddyCell>();
            this._list.beginChanges();
            for(j = 0; j < 30; j++)
            {
               item1 = new CaddyCell(j);
               this._items.push(item1);
               item1.addEventListener(CellEvent.ITEM_CLICK,this.__itemClick);
               this._list.addChild(item1);
            }
            this._list.commitChanges();
            this._sellAllBtn = ComponentFactory.Instance.creatComponentByStylename("caddy.sellAllBtn");
            addChild(this._sellAllBtn);
            this._exchangeTxt = ComponentFactory.Instance.creatComponentByStylename("asset.caddy.exchangeTxt1");
            this._exchangeTxt.text = LanguageMgr.GetTranslation("tank.littlegame.exchange");
            this._getAllBtn = ComponentFactory.Instance.creatComponentByStylename("caddy.getAllBtn");
            addChild(this._getAllBtn);
         }
         if(CaddyModel.instance.type == CaddyModel.CELEBRATION_BOX)
         {
            this._bg2.height = 61;
            this._bg2.x = 13;
            this._bg2.y = 296;
            this._list = ComponentFactory.Instance.creatCustomObject("caddy.SimpleTileList",[NUMBER]);
            addChild(this._list);
            this._items = new Vector.<CaddyCell>();
            this._list.beginChanges();
            for(n = 0; n < 30; n++)
            {
               item3 = new CaddyCell(n);
               this._items.push(item3);
               item3.addEventListener(CellEvent.ITEM_CLICK,this.__itemClick);
               this._list.addChild(item3);
            }
            this._list.commitChanges();
            this._sellAllBtn = ComponentFactory.Instance.creatComponentByStylename("caddy.sellAllBtn");
            this._sellAllBtn.x = 185;
            addChild(this._sellAllBtn);
            this._getAllBtn = ComponentFactory.Instance.creatComponentByStylename("caddy.getAllBtn");
            addChild(this._getAllBtn);
         }
      }
      
      protected function initEvents() : void
      {
         if(CaddyModel.instance.type == CaddyModel.CADDY_TYPE || CaddyModel.instance.type == CaddyModel.BOMB_KING_BLESS)
         {
            SocketManager.Instance.out.sendconverted(this.isConver);
         }
         SocketManager.Instance.out.sendQequestBadLuck();
         if(Boolean(this._sellAllBtn))
         {
            this._sellAllBtn.addEventListener(MouseEvent.CLICK,this._sellAll);
         }
         if(Boolean(this._getAllBtn))
         {
            this._getAllBtn.addEventListener(MouseEvent.CLICK,this._getAll);
         }
         if(Boolean(this._openAll))
         {
            this._openAll.addEventListener(MouseEvent.CLICK,this.__openAllHandler);
         }
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.CADDY_GET_CONVERTED,this._getConverteds);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.CADDY_GET_EXCHANGEALL,this._getexchange);
         CaddyModel.instance.bagInfo.addEventListener(BagEvent.UPDATE,this._update);
         PlayerManager.Instance.Self.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__changeBadLuckNumber);
      }
      
      private function _getConverteds(event:CrazyTankSocketEvent) : void
      {
         var alert:BaseAlerFrame = null;
         var pkg:PackageIn = event.pkg;
         if(pkg.bytesAvailable == 0)
         {
            return;
         }
         this._CaddyInfo = new CaddyInfo();
         this._CaddyInfo.isConver = pkg.readBoolean();
         this._CaddyInfo.totalSorce = pkg.readInt();
         this._CaddyInfo.lotteryScore = pkg.readInt();
         pkg.clear();
         if(this._CaddyInfo.totalSorce != 0 && !this._CaddyInfo.isConver && this.isAlert)
         {
            this.isAlert = false;
            alert = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("tank.view.caddy.convertedAll",this._CaddyInfo.totalSorce),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,true,true,LayerManager.ALPHA_BLOCKGOUND);
            alert.mouseEnabled = false;
            alert.addEventListener(FrameEvent.RESPONSE,this._responseII);
         }
      }
      
      private function _getexchange(event:CrazyTankSocketEvent) : void
      {
         var pkg:PackageIn = event.pkg;
         this._CaddyInfo.lotteryScore = pkg.readInt();
      }
      
      private function _responseII(event:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         (event.currentTarget as BaseAlerFrame).removeEventListener(FrameEvent.RESPONSE,this._responseII);
         if(event.responseCode == FrameEvent.ENTER_CLICK || event.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            SocketManager.Instance.out.sendconverted(true);
         }
         ObjectUtils.disposeObject(event.currentTarget);
      }
      
      private function _exchangeHandler(event:MouseEvent) : void
      {
         var alert:BaseAlerFrame = null;
         SoundManager.instance.play("008");
         if(this._CaddyInfo.lotteryScore < 30)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.caddy.exchangeText1"));
         }
         else
         {
            alert = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("tank.view.caddy.exchangeAll",Math.floor(this._CaddyInfo.lotteryScore / 30)),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,true,true,LayerManager.ALPHA_BLOCKGOUND);
            alert.mouseEnabled = false;
            alert.addEventListener(FrameEvent.RESPONSE,this._responseIII);
         }
      }
      
      private function _convertedHandler(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         SocketManager.Instance.out.sendconverted(this.isConver);
         this.isAlert = true;
      }
      
      private function _responseIII(event:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         (event.currentTarget as BaseAlerFrame).removeEventListener(FrameEvent.RESPONSE,this._responseIII);
         if(event.responseCode == FrameEvent.ENTER_CLICK || event.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            SocketManager.Instance.out.sendExchange();
         }
         ObjectUtils.disposeObject(event.currentTarget);
      }
      
      protected function __openAllHandler(event:MouseEvent) : void
      {
         var alert:BaseAlerFrame = null;
         SoundManager.instance.play("008");
         if(CaddyModel.instance.bagInfo.itemNumber > 0)
         {
            alert = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("tank.view.caddy.opennAll"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,true,true,LayerManager.ALPHA_BLOCKGOUND);
            alert.moveEnable = false;
            alert.addEventListener(FrameEvent.RESPONSE,this._responseIV);
         }
      }
      
      private function _responseIV(event:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         (event.currentTarget as BaseAlerFrame).removeEventListener(FrameEvent.RESPONSE,this._responseI);
         if(event.responseCode == FrameEvent.ENTER_CLICK || event.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            SocketManager.Instance.out.sendOpenAll();
         }
         ObjectUtils.disposeObject(event.currentTarget);
      }
      
      protected function removeEvents() : void
      {
         if(Boolean(this._sellAllBtn))
         {
            this._sellAllBtn.removeEventListener(MouseEvent.CLICK,this._sellAll);
         }
         if(Boolean(this._openAll))
         {
            this._openAll.removeEventListener(MouseEvent.CLICK,this.__openAllHandler);
         }
         CaddyModel.instance.bagInfo.removeEventListener(BagEvent.UPDATE,this._update);
         PlayerManager.Instance.Self.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__changeBadLuckNumber);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.CADDY_GET_CONVERTED,this._getConverteds);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.CADDY_GET_EXCHANGEALL,this._getexchange);
      }
      
      private function __changeBadLuckNumber(event:PlayerPropertyEvent) : void
      {
         var itemInfo:InventoryItemInfo = null;
         var evt:CaddyEvent = null;
         if(Boolean(event.changedProperties["BadLuckNumber"]))
         {
            if(PlayerManager.Instance.Self.badLuckNumber == 0)
            {
               return;
            }
            itemInfo = new InventoryItemInfo();
            itemInfo.TemplateID = EquipType.BADLUCK_STONE;
            ItemManager.fill(itemInfo);
            evt = new CaddyEvent(GET_GOODSINFO);
            evt.info = this._selectedGoodsInfo = itemInfo;
            dispatchEvent(evt);
         }
      }
      
      private function _getAll(e:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(CaddyModel.instance.bagInfo.itemNumber > 0)
         {
            SocketManager.Instance.out.sendFinishRoulette();
         }
      }
      
      private function _sellAll(e:MouseEvent) : void
      {
         var alert:BaseAlerFrame = null;
         SoundManager.instance.play("008");
         if(CaddyModel.instance.bagInfo.itemNumber > 0)
         {
            alert = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("tank.view.caddy.sellAllNode") + this.getSellAllPriceString(),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,true,true,LayerManager.ALPHA_BLOCKGOUND);
            alert.moveEnable = false;
            alert.addEventListener(FrameEvent.RESPONSE,this._responseI);
         }
      }
      
      public function getSellAllPriceString() : String
      {
         var info:InventoryItemInfo = null;
         var gold:Number = 0;
         var gift:Number = 0;
         for each(info in CaddyModel.instance.bagInfo.items)
         {
            if(info.ReclaimType == 1)
            {
               gold += info.ReclaimValue * info.Count;
            }
            else if(info.ReclaimType == 2)
            {
               gift += info.ReclaimValue * info.Count;
            }
         }
         return (gold > 0 ? gold + LanguageMgr.GetTranslation("tank.hotSpring.gold") : "") + (gold > 0 && gift > 0 ? "," : "") + (gift > 0 ? gift + LanguageMgr.GetTranslation("tank.gameover.takecard.gifttoken") : "");
      }
      
      private function _responseI(e:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         (e.currentTarget as BaseAlerFrame).removeEventListener(FrameEvent.RESPONSE,this._responseI);
         if(e.responseCode == FrameEvent.ENTER_CLICK || e.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            SocketManager.Instance.out.sendSellAll();
         }
         ObjectUtils.disposeObject(e.currentTarget);
      }
      
      public function _update(e:BagEvent) : void
      {
         var i:String = null;
         var c:InventoryItemInfo = null;
         var evt:CaddyEvent = null;
         var data:Dictionary = e.changedSlots;
         for(i in data)
         {
            c = CaddyModel.instance.bagInfo.getItemAt(int(i));
            if(Boolean(c))
            {
               this._selectedGoodsInfo = c;
               this._selectPlace = c.Place;
               evt = new CaddyEvent(GET_GOODSINFO);
               evt.info = this._selectedGoodsInfo;
               dispatchEvent(evt);
            }
            else
            {
               this._items[i].info = null;
            }
         }
      }
      
      public function __itemClick(event:CellEvent) : void
      {
         SoundManager.instance.play("008");
         var item:CaddyCell = event.data as CaddyCell;
         var count:int = (item.info as InventoryItemInfo).Count;
         var bagType:int = this._getBagType(item.info as InventoryItemInfo);
         SocketManager.Instance.out.sendMoveGoods(BagInfo.CADDYBAG,item.place,bagType,-1,count);
      }
      
      private function _getBagType(info:InventoryItemInfo) : int
      {
         var type:int = 0;
         switch(info.CategoryID)
         {
            case EquipType.UNFRIGHTPROP:
               if(info.Property1 == "31")
               {
                  type = BagInfo.BEADBAG;
               }
               else
               {
                  type = BagInfo.PROPBAG;
               }
               break;
            case EquipType.FRIGHTPROP:
            case EquipType.TASK:
            case EquipType.TEXP:
            case EquipType.TEXP_TASK:
            case EquipType.ACTIVE_TASK:
            case EquipType.FOOD:
            case EquipType.PET_EGG:
            case EquipType.VEGETABLE:
               type = BagInfo.PROPBAG;
               break;
            case EquipType.SEED:
            case EquipType.MANURE:
               type = BagInfo.FARM;
            default:
               type = BagInfo.EQUIPBAG;
         }
         return type;
      }
      
      public function findCell() : void
      {
         var point:Point = null;
         if(this._selectedGoodsInfo.TemplateID == EquipType.BADLUCK_STONE)
         {
            point = localToGlobal(new Point(685,285));
         }
         else
         {
            point = localToGlobal(new Point(this._items[this._selectPlace].x,this._items[this._selectPlace].y));
         }
         var evt:CaddyEvent = new CaddyEvent(NULL_CELL_POINT);
         evt.point = point;
         dispatchEvent(evt);
      }
      
      public function addCell() : void
      {
         if(this._selectedGoodsInfo.TemplateID != EquipType.BADLUCK_STONE)
         {
            this._items[this._selectPlace].info = this._selectedGoodsInfo;
         }
      }
      
      public function checkCell() : Boolean
      {
         for(var i:int = 0; i < this._items.length; i++)
         {
            if(this._items[i].info != null)
            {
               return true;
            }
         }
         return false;
      }
      
      public function get sellBtn() : BaseButton
      {
         if(Boolean(this._sellAllBtn))
         {
            return this._sellAllBtn;
         }
         if(Boolean(this._openAll))
         {
            return this._openAll;
         }
         return null;
      }
      
      public function get getAllBtn() : BaseButton
      {
         return this._getAllBtn;
      }
      
      public function dispose() : void
      {
         this.removeEvents();
         if(Boolean(this._bg))
         {
            ObjectUtils.disposeObject(this._bg);
         }
         this._bg = null;
         if(Boolean(this._list))
         {
            ObjectUtils.disposeObject(this._list);
         }
         this._list = null;
         if(Boolean(this._sellAllBtn))
         {
            ObjectUtils.disposeObject(this._sellAllBtn);
         }
         this._sellAllBtn = null;
         if(Boolean(this._getAllBtn))
         {
            ObjectUtils.disposeObject(this._getAllBtn);
         }
         this._getAllBtn = null;
         if(Boolean(this._openAll))
         {
            ObjectUtils.disposeObject(this._openAll);
         }
         this._openAll = null;
         for(var i:int = 0; i < this._items.length; i++)
         {
            ObjectUtils.disposeObject(this._items[i]);
         }
         this._items = null;
         this._selectedGoodsInfo = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

