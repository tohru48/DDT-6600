package consortion.view.selfConsortia
{
   import bagAndInfo.bag.BagView;
   import bagAndInfo.bag.CellMenu;
   import bagAndInfo.cell.BagCell;
   import baglocked.BaglockedManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.text.FilterFrameText;
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
   
   public class ConsortionBankBagView extends BagView
   {
      
      private static var LIST_WIDTH:int = 330;
      
      private static var LIST_HEIGHT:int = 320;
      
      private var _bank:ConsortionBankListView;
      
      private var _titleBitmap:Bitmap;
      
      private var _titleText2:FilterFrameText;
      
      private var _changeToConsortion:SimpleBitmapButton;
      
      private const MAX_HEIGHT:int = 455;
      
      public function ConsortionBankBagView()
      {
         super();
      }
      
      override protected function init() : void
      {
         super.init();
         this._changeToConsortion = ComponentFactory.Instance.creatComponentByStylename("consortion.bankView.stateChangeBtn");
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
      
      override public function setBagType(type:int) : void
      {
         super.setBagType(type);
      }
      
      override protected function set_breakBtn_enable() : void
      {
         if(Boolean(_keySortBtn) && _isSkillCanUse())
         {
            _keySortBtn.enable = true;
         }
      }
      
      override protected function initEvent() : void
      {
         super.initEvent();
         this._bank.addEventListener(CellEvent.ITEM_CLICK,this.__bankCellClick);
         this._bank.addEventListener(CellEvent.DOUBLE_CLICK,this.__bankCellDoubleClick);
         addEventListener(Event.ADDED_TO_STAGE,this.__addToStageHandler);
         _proplist.addEventListener(CellEvent.DOUBLE_CLICK,this.__cellDoubleClick);
         _equiplist.addEventListener(Event.CHANGE,this.__listChange);
         _proplist.addEventListener(Event.CHANGE,this.__listChange);
         PlayerManager.Instance.Self.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__upConsortiaStroeLevel);
         this._changeToConsortion.addEventListener(MouseEvent.CLICK,this.__jumpToMagicHouse);
      }
      
      override protected function removeEvents() : void
      {
         super.removeEvents();
         this._bank.removeEventListener(CellEvent.ITEM_CLICK,this.__bankCellClick);
         this._bank.removeEventListener(CellEvent.DOUBLE_CLICK,this.__bankCellDoubleClick);
         removeEventListener(Event.ADDED_TO_STAGE,this.__addToStageHandler);
         _proplist.removeEventListener(CellEvent.DOUBLE_CLICK,this.__cellDoubleClick);
         _equiplist.removeEventListener(Event.CHANGE,this.__listChange);
         _proplist.removeEventListener(Event.CHANGE,this.__listChange);
         PlayerManager.Instance.Self.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__upConsortiaStroeLevel);
         this._changeToConsortion.removeEventListener(MouseEvent.CLICK,this.__jumpToMagicHouse);
      }
      
      override protected function initBackGround() : void
      {
         super.initBackGround();
         this._bank = new ConsortionBankListView(11,PlayerManager.Instance.Self.consortiaInfo.StoreLevel);
         PositionUtils.setPos(this._bank,"consortion.bank.Pos");
         this._titleBitmap = ComponentFactory.Instance.creatBitmap("asset.consortiaii.bag.bagTitle");
         this._titleText2 = ComponentFactory.Instance.creatComponentByStylename("consortion.bankBagView.titleText2");
         this._titleText2.text = LanguageMgr.GetTranslation("consortion.bankBagView.titleText2");
         addChild(this._bank);
      }
      
      override protected function __listChange(evt:Event) : void
      {
         if(Boolean(_dressbagView) && _dressbagView.visible == true)
         {
            return;
         }
         if(evt.currentTarget == _equiplist)
         {
            this.setBagType(BagInfo.EQUIPBAG);
         }
         else
         {
            this.setBagType(BagInfo.PROPBAG);
         }
      }
      
      override protected function __cellDoubleClick(evt:CellEvent) : void
      {
         SoundManager.instance.play("008");
         var checkNum:int = this._bank.checkConsortiaStoreCell();
         if(checkNum > 0)
         {
            if(checkNum == 1)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.consortia.club.ConsortiaClubView.cellDoubleClick"));
            }
            else if(checkNum == 2 || checkNum == 3)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.consortia.club.ConsortiaClubView.cellDoubleClick.msg"));
            }
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
            SocketManager.Instance.out.sendMoveGoods(info.BagType,info.Place,BagInfo.CONSORTIA,-1);
         }
      }
      
      private function __jumpToMagicHouse(e:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.Grade >= 40)
         {
            ConsortionModelControl.Instance.hideBankFrame();
            MagicHouseManager.instance.show(1);
         }
         else
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.functionLimitTip",40));
         }
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
      
      private function __upConsortiaStroeLevel(evt:PlayerPropertyEvent) : void
      {
         if(Boolean(evt.changedProperties["StoreLevel"]))
         {
            this.__addToStageHandler(null);
         }
      }
      
      private function __addToStageHandler(evt:Event) : void
      {
         this._bank.upLevel(PlayerManager.Instance.Self.consortiaInfo.StoreLevel);
      }
      
      public function setData($info:SelfInfo) : void
      {
         _equiplist.setData($info.Bag);
         _proplist.setData($info.PropBag);
         this._bank.setData($info.ConsortiaBag);
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
      
      override protected function __cellMove(evt:Event) : void
      {
         var cell:BagCell = CellMenu.instance.cell;
         var info:InventoryItemInfo = cell.info as InventoryItemInfo;
         if(this.checkDressSaved(info))
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("playerDress.cannotStore"));
            return;
         }
         super.__cellMove(evt);
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
      
      override protected function __sortBagClick(evt:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         var bagInfo:BagInfo = PlayerManager.Instance.Self.getBag(BagInfo.CONSORTIA);
         PlayerManager.Instance.Self.PropBag.sortBag(CONSORTION,bagInfo,0,100,_bagArrangeSprite.arrangeAdd);
         if(_bagType != BEAD)
         {
            PlayerManager.Instance.Self.PropBag.sortBag(_bagType,PlayerManager.Instance.Self.getBag(_bagType),0,48,_bagArrangeSprite.arrangeAdd);
         }
         else
         {
            PlayerManager.Instance.Self.PropBag.sortBag(_bagType,PlayerManager.Instance.Self.getBag(_bagType),32,178,true);
         }
      }
      
      override public function dispose() : void
      {
         super.dispose();
         if(Boolean(this._bank))
         {
            this._bank.dispose();
         }
         this._bank = null;
         if(Boolean(this._titleBitmap))
         {
            ObjectUtils.disposeObject(this._titleBitmap);
         }
         this._titleBitmap = null;
         if(Boolean(this._titleText2))
         {
            ObjectUtils.disposeObject(this._titleText2);
         }
         this._titleText2 = null;
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
   }
}

