package petsBag.view
{
   import bagAndInfo.cell.BagCell;
   import bagAndInfo.info.PersonalInfoDragInArea;
   import bagAndInfo.info.PlayerInfoViewControl;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.events.CellEvent;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.SocketManager;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   import flash.events.Event;
   import pet.date.PetInfo;
   import pet.sprite.PetSpriteController;
   import petsBag.controller.PetBagController;
   import petsBag.view.item.PetBigItem;
   import petsBag.view.item.PetEquipItem;
   import petsBag.view.item.StarBar;
   
   public class ShowPet extends Sprite implements Disposeable
   {
      
      public static var isPetEquip:Boolean;
      
      private var _starBar:StarBar;
      
      private var _petBigItem:PetBigItem;
      
      private var _equipLockBitmapData:BitmapData;
      
      private var _vbox:VBox;
      
      private var _equipList:Array;
      
      private var _currentPetIndex:int;
      
      private var _dragDropArea:PersonalInfoDragInArea;
      
      public function ShowPet()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         var item:PetEquipItem = null;
         this._dragDropArea = new PersonalInfoDragInArea();
         this._equipList = new Array();
         this._vbox = ComponentFactory.Instance.creatCustomObject("petsBag.showPet.vbox");
         for(var i:int = 0; i < 3; i++)
         {
            item = new PetEquipItem(i);
            item.id = i;
            item.addEventListener(CellEvent.DOUBLE_CLICK,this.doubleClickHander);
            item.addEventListener(CellEvent.ITEM_CLICK,this.onClickHander);
            this._vbox.addChild(item);
            this._equipList.push(item);
         }
         this._starBar = new StarBar();
         this._starBar.x = this._vbox.x + this._vbox.width;
         addChild(this._starBar);
         this._petBigItem = ComponentFactory.Instance.creat("petsBag.petBigItem");
         this._petBigItem.initTips();
         addChild(this._dragDropArea);
         addChild(this._petBigItem);
         addChild(this._vbox);
      }
      
      private function initEvent() : void
      {
         PetSpriteController.Instance.addEventListener(PetSpriteController.SHOWPET_TIP,this.__showPetTip);
      }
      
      private function __showPetTip(e:Event) : void
      {
         if(isPetEquip == true)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ShowPet.Tip"));
         }
      }
      
      private function onClickHander(e:CellEvent) : void
      {
         var cell:BagCell = null;
         if(PlayerInfoViewControl.isOpenFromBag)
         {
            cell = e.data as BagCell;
            PetBagController.instance().isEquip = true;
            cell.dragStart();
         }
      }
      
      private function doubleClickHander(e:CellEvent) : void
      {
         if(PlayerInfoViewControl.isOpenFromBag)
         {
            SocketManager.Instance.out.delPetEquip(PetBagController.instance().petModel.currentPetInfo.Place,e.currentTarget.id);
         }
      }
      
      public function addPetEquip(date:InventoryItemInfo) : void
      {
         this.getBagCell(date.Place).initBagCell(date);
      }
      
      public function getBagCell(type:int) : PetEquipItem
      {
         return this._equipList[type] as PetEquipItem;
      }
      
      public function delPetEquip(id:int) : void
      {
         if(Boolean(this.getBagCell(id)))
         {
            this.getBagCell(id).clearBagCell();
         }
      }
      
      public function update() : void
      {
         var data:InventoryItemInfo = null;
         var newInfo:InventoryItemInfo = null;
         this.clearCell();
         var currentPet:PetInfo = PetBagController.instance().petModel.currentPetInfo;
         if(!currentPet)
         {
            this._starBar.starNum(Boolean(currentPet) ? currentPet.StarLevel : 0);
            this._petBigItem.info = currentPet;
            return;
         }
         this._starBar.starNum(Boolean(currentPet) ? currentPet.StarLevel : 0);
         this._petBigItem.info = currentPet;
         for(var i:int = 0; i < 3; i++)
         {
            data = currentPet.equipList[i];
            if(Boolean(data))
            {
               newInfo = ItemManager.fill(data) as InventoryItemInfo;
               this.addPetEquip(data);
            }
         }
      }
      
      public function update2(currentPet2:PetInfo) : void
      {
         var data:InventoryItemInfo = null;
         var newInfo:InventoryItemInfo = null;
         this.clearCell();
         var currentPet:PetInfo = currentPet2;
         if(!currentPet)
         {
            this._starBar.starNum(Boolean(currentPet) ? currentPet.StarLevel : 0);
            this._petBigItem.info = currentPet;
            return;
         }
         this._starBar.starNum(Boolean(currentPet) ? currentPet.StarLevel : 0);
         this._petBigItem.info = currentPet;
         for(var i:int = 0; i < 3; i++)
         {
            data = currentPet.equipList[i];
            if(Boolean(data))
            {
               newInfo = ItemManager.fill(data) as InventoryItemInfo;
               this.addPetEquip(data);
            }
         }
      }
      
      private function removeEvent() : void
      {
         var len:int = int(this._equipList.length);
         for(var i:int = 0; i < len; i++)
         {
            this.getBagCell(this._equipList[i]).removeEventListener(CellEvent.DOUBLE_CLICK,this.doubleClickHander);
         }
         PetSpriteController.Instance.removeEventListener(PetSpriteController.SHOWPET_TIP,this.__showPetTip);
      }
      
      private function clearCell() : void
      {
         for(var i:int = 0; i < 3; i++)
         {
            this.delPetEquip(i);
         }
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         if(Boolean(this._petBigItem))
         {
            ObjectUtils.disposeObject(this._petBigItem);
            this._petBigItem = null;
         }
         if(Boolean(this._equipLockBitmapData))
         {
            ObjectUtils.disposeObject(this._equipLockBitmapData);
            this._equipLockBitmapData = null;
         }
         if(Boolean(this._vbox))
         {
            ObjectUtils.disposeAllChildren(this._vbox);
            ObjectUtils.disposeObject(this._vbox);
            this._vbox = null;
         }
         if(Boolean(this._starBar))
         {
            ObjectUtils.disposeObject(this._starBar);
            this._starBar = null;
         }
         ObjectUtils.disposeAllChildren(this);
      }
   }
}

