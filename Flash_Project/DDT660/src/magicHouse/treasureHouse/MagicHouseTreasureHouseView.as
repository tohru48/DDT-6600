package magicHouse.treasureHouse
{
   import bagAndInfo.bag.BagView;
   import bagAndInfo.bag.CellMenu;
   import bagAndInfo.cell.BagCell;
   import baglocked.BaglockedManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.image.MutipleImage;
   import com.pickgliss.utils.ObjectUtils;
   import consortion.ConsortionModelControl;
   import ddt.data.BagInfo;
   import ddt.data.EquipType;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.data.player.SelfInfo;
   import ddt.events.CellEvent;
   import ddt.events.PlayerPropertyEvent;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import magicHouse.MagicHouseManager;
   import playerDress.PlayerDressManager;
   import playerDress.components.DressModel;
   import playerDress.components.DressUtils;
   import playerDress.data.DressVo;
   
   public class MagicHouseTreasureHouseView extends BagView
   {
      
      private var _bagListBg:MutipleImage;
      
      private var _bagTipBitmap:Bitmap;
      
      private var _treasureBagListView:MagicHouseTreasureBagListView;
      
      private var _changeToConsortion:SimpleBitmapButton;
      
      public function MagicHouseTreasureHouseView()
      {
         super();
      }
      
      override protected function init() : void
      {
         super.init();
         this._bagListBg = ComponentFactory.Instance.creatComponentByStylename("magicHouse.treasureHouseView.bagList.bg");
         this._bagTipBitmap = ComponentFactory.Instance.creatBitmap("magichouse.treasure.bagtip");
         this._changeToConsortion = ComponentFactory.Instance.creatComponentByStylename("magicHouse.treasureView.stateChangeBtn");
         addChild(this._bagListBg);
         setChildIndex(this._bagListBg,0);
         addChild(this._bagTipBitmap);
         addChild(this._changeToConsortion);
         this.setInit();
         this.setData(PlayerManager.Instance.Self);
      }
      
      private function setInit() : void
      {
         _tabBtn3.buttonMode = false;
         _tabBtn3.mouseEnabled = false;
         _tabBtn3.mouseChildren = false;
         _bagLockBtn.visible = false;
      }
      
      public function setData($info:SelfInfo) : void
      {
         _equiplist.setData($info.Bag);
         _proplist.setData($info.PropBag);
         this._treasureBagListView.setData($info.MagicHouseBag);
      }
      
      override protected function __cellClick(evt:CellEvent) : void
      {
         var cell:BagCell = null;
         var info:InventoryItemInfo = null;
         var pos:Point = null;
         if(!_sellBtn.isActive)
         {
            evt.stopImmediatePropagation();
            cell = evt.data as BagCell;
            if(Boolean(cell))
            {
               info = cell.info as InventoryItemInfo;
            }
            if(info == null)
            {
               return;
            }
            if(!cell.locked)
            {
               SoundManager.instance.play("008");
               if(!DressUtils.isDress(info) && (info.getRemainDate() <= 0 && !EquipType.isProp(info) || EquipType.isPackage(info) || info.getRemainDate() <= 0 && info.TemplateID == 10200 || EquipType.canBeUsed(info)))
               {
                  pos = localToGlobal(new Point(cell.x,cell.y));
                  CellMenu.instance.show(cell,pos.x + 35,pos.y + 77);
               }
               else
               {
                  if(this.checkDressSaved(info))
                  {
                     MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("playerDress.cannotStore"));
                     return;
                  }
                  cell.dragStart();
               }
            }
         }
      }
      
      override protected function initEvent() : void
      {
         super.initEvent();
         this._treasureBagListView.addEventListener(CellEvent.ITEM_CLICK,this.__bankCellClick);
         this._treasureBagListView.addEventListener(CellEvent.DOUBLE_CLICK,this.__bankCellDoubleClick);
         addEventListener(Event.ADDED_TO_STAGE,this.__addToStageHandler);
         _proplist.addEventListener(CellEvent.DOUBLE_CLICK,this.__cellDoubleClick);
         _equiplist.addEventListener(Event.CHANGE,this.__listChange);
         _proplist.addEventListener(Event.CHANGE,this.__listChange);
         this._changeToConsortion.addEventListener(MouseEvent.CLICK,this.__jumpToConsortion);
         PlayerManager.Instance.Self.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__upMagicHouseStroeLevel);
         MagicHouseManager.instance.addEventListener("MAGICHOUSE_UPDATA",this.__messageUpdate);
      }
      
      override protected function removeEvents() : void
      {
         this._treasureBagListView.removeEventListener(CellEvent.ITEM_CLICK,this.__bankCellClick);
         this._treasureBagListView.removeEventListener(CellEvent.DOUBLE_CLICK,this.__bankCellDoubleClick);
         removeEventListener(Event.ADDED_TO_STAGE,this.__addToStageHandler);
         _proplist.removeEventListener(CellEvent.DOUBLE_CLICK,this.__cellDoubleClick);
         _equiplist.removeEventListener(Event.CHANGE,this.__listChange);
         _proplist.removeEventListener(Event.CHANGE,this.__listChange);
         this._changeToConsortion.removeEventListener(MouseEvent.CLICK,this.__jumpToConsortion);
         PlayerManager.Instance.Self.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__upMagicHouseStroeLevel);
         MagicHouseManager.instance.removeEventListener("MAGICHOUSE_UPDATA",this.__messageUpdate);
         super.removeEvents();
      }
      
      override protected function initBackGround() : void
      {
         super.initBackGround();
         this._treasureBagListView = new MagicHouseTreasureBagListView(BagInfo.MAGICHOUSE,MagicHouseManager.instance.depotCount);
         PositionUtils.setPos(this._treasureBagListView,"magicHouse.TreasureBag.Pos");
         addChild(this._treasureBagListView);
      }
      
      override protected function __listChange(evt:Event) : void
      {
         if(Boolean(_dressbagView) && _dressbagView.visible == true)
         {
            return;
         }
         if(evt.currentTarget == _equiplist)
         {
            setBagType(BagInfo.EQUIPBAG);
         }
         else
         {
            setBagType(BagInfo.PROPBAG);
         }
      }
      
      private function __jumpToConsortion(e:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.ConsortiaID != 0)
         {
            MagicHouseManager.instance.closeMagicHouseView();
            ConsortionModelControl.Instance.alertBankFrame();
         }
         else
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("magichouse.treasureView.noConsortion"));
         }
      }
      
      private function __messageUpdate(e:Event) : void
      {
         this._treasureBagListView.addDepot(MagicHouseManager.instance.depotCount);
      }
      
      private function __upMagicHouseStroeLevel(evt:PlayerPropertyEvent) : void
      {
         if(Boolean(evt.changedProperties["StoreLevel"]))
         {
            this.__addToStageHandler(null);
         }
      }
      
      private function __addToStageHandler(evt:Event) : void
      {
         this._treasureBagListView.addDepot(MagicHouseManager.instance.depotCount);
      }
      
      override protected function __cellDoubleClick(evt:CellEvent) : void
      {
         SoundManager.instance.play("008");
         var checkNum:int = this._treasureBagListView.checkMagicHouseStoreCell();
         if(checkNum == 0)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("magichouse.treasureView.bagFull"));
            return;
         }
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         evt.stopImmediatePropagation();
         var cell:BagCell = evt.data as BagCell;
         var info:InventoryItemInfo = cell.info as InventoryItemInfo;
         if(this.checkDressSaved(info))
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("playerDress.cannotStore"));
            return;
         }
         var templeteInfo:ItemTemplateInfo = ItemManager.Instance.getTemplateById(info.TemplateID);
         var playerSex:int = PlayerManager.Instance.Self.Sex ? 1 : 2;
         if(!cell.locked)
         {
            SocketManager.Instance.out.sendMoveGoods(info.BagType,info.Place,BagInfo.MAGICHOUSE,-1);
         }
      }
      
      override protected function __sortBagClick(evt:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         var bagInfo:BagInfo = PlayerManager.Instance.Self.getBag(BagInfo.MAGICHOUSE);
         PlayerManager.Instance.Self.PropBag.sortBag(MAGICHOUSE,bagInfo,0,100,_bagArrangeSprite.arrangeAdd);
      }
      
      private function __bankCellClick(evt:CellEvent) : void
      {
         var cell:BagCell = null;
         var info:InventoryItemInfo = null;
         if(!_sellBtn.isActive)
         {
            evt.stopImmediatePropagation();
            cell = evt.data as BagCell;
            if(Boolean(cell))
            {
               info = cell.info as InventoryItemInfo;
            }
            if(info == null)
            {
               return;
            }
            if(!cell.locked)
            {
               SoundManager.instance.play("008");
               cell.dragStart();
            }
         }
      }
      
      private function __bankCellDoubleClick(evt:CellEvent) : void
      {
         SoundManager.instance.play("008");
         evt.stopImmediatePropagation();
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         var cell:BagCell = evt.data as BagCell;
         var info:InventoryItemInfo = cell.itemInfo;
         SocketManager.Instance.out.sendMoveGoods(info.BagType,info.Place,this.getItemBagType(info),-1,info.Count);
      }
      
      private function getItemBagType(info:InventoryItemInfo) : int
      {
         if(EquipType.isBelongToPropBag(info))
         {
            return BagInfo.PROPBAG;
         }
         return BagInfo.EQUIPBAG;
      }
      
      private function checkDressSaved(info:InventoryItemInfo) : Boolean
      {
         var item:InventoryItemInfo = null;
         var dressArr:Array = null;
         var k:int = 0;
         var vo:DressVo = null;
         if(!DressUtils.isDress(info))
         {
            return false;
         }
         var bag:BagInfo = PlayerManager.Instance.Self.Bag;
         for(var i:int = 0; i <= DressModel.DRESS_LEN - 1; i++)
         {
            item = bag.items[DressUtils.getBagItems(i)];
            if(Boolean(item) && info.ItemID == item.ItemID)
            {
               return true;
            }
         }
         var modelArr:Array = PlayerDressManager.instance.modelArr;
         for(var j:int = 0; j <= modelArr.length - 1; j++)
         {
            dressArr = modelArr[j];
            if(Boolean(dressArr))
            {
               for(k = 0; k <= dressArr.length - 1; k++)
               {
                  vo = dressArr[k];
                  if(info.ItemID == vo.itemId)
                  {
                     return true;
                  }
               }
            }
         }
         return false;
      }
      
      override public function dispose() : void
      {
         super.dispose();
         if(Boolean(this._bagListBg))
         {
            ObjectUtils.disposeObject(this._bagListBg);
         }
         this._bagListBg = null;
         if(Boolean(this._changeToConsortion))
         {
            ObjectUtils.disposeObject(this._changeToConsortion);
         }
         this._changeToConsortion = null;
         if(Boolean(this._bagTipBitmap))
         {
            ObjectUtils.disposeObject(this._bagTipBitmap);
         }
         this._bagTipBitmap = null;
         if(Boolean(this._treasureBagListView))
         {
            ObjectUtils.disposeObject(this._treasureBagListView);
         }
         this._treasureBagListView = null;
      }
   }
}

