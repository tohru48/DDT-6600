package changeColor
{
   import ddt.data.BagInfo;
   import ddt.data.EquipType;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.player.SelfInfo;
   import ddt.events.BagEvent;
   import ddt.manager.PlayerManager;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.utils.Dictionary;
   import road7th.data.DictionaryData;
   
   public class ChangeColorModel extends EventDispatcher
   {
      
      private var _colorEditableThings:DictionaryData;
      
      private var _self:SelfInfo;
      
      private var _currentItem:InventoryItemInfo;
      
      private var _oldHideHat:Boolean;
      
      private var _oldHideGlass:Boolean;
      
      private var _oldHideSuit:Boolean;
      
      private var _changed:Boolean = false;
      
      private var _tempColor:String = "";
      
      private var _tempSkin:String = "";
      
      private var _equipBag:BagInfo;
      
      public var place:int = -1;
      
      public var colorEditableBag:BagInfo;
      
      public var initColor:String;
      
      public var initSkinColor:String;
      
      public function ChangeColorModel()
      {
         super();
         this.init();
      }
      
      private function init() : void
      {
         this._self = new SelfInfo();
         this._self.beginChanges();
         this._self.Sex = PlayerManager.Instance.Self.Sex;
         this._self.Hide = PlayerManager.Instance.Self.Hide;
         this._self.Style = PlayerManager.Instance.Self.getPrivateStyle();
         this._self.Colors = PlayerManager.Instance.Self.Colors;
         this._self.Skin = PlayerManager.Instance.Self.Skin;
         this._self.commitChanges();
         this._oldHideHat = this._self.getHatHide();
         this._oldHideGlass = this._self.getGlassHide();
         this._oldHideSuit = this._self.getSuitesHide();
         this._equipBag = PlayerManager.Instance.Self.Bag;
         this.colorEditableBag = new BagInfo(BagInfo.EQUIPBAG,76);
         this._colorEditableThings = new DictionaryData();
         this.colorEditableBag.items = this._colorEditableThings;
         this.initEvents();
      }
      
      private function initEvents() : void
      {
         this._equipBag.addEventListener(BagEvent.UPDATE,this.__updateItem);
      }
      
      private function removeEvents() : void
      {
         this._equipBag.removeEventListener(BagEvent.UPDATE,this.__updateItem);
      }
      
      private function __updateItem(evt:BagEvent) : void
      {
         var changedSlots:Dictionary = evt.changedSlots;
         evt.stopImmediatePropagation();
         this.colorEditableBag.dispatchEvent(new BagEvent(BagEvent.UPDATE,changedSlots));
      }
      
      public function getColorEditableThings() : void
      {
         var item:InventoryItemInfo = null;
         var i:int = 0;
         for each(item in this._equipBag.items)
         {
            if(item.Place > BagInfo.PERSONAL_EQUIP_COUNT)
            {
               if(EquipType.isEditable(item) && item.getRemainDate() > 0)
               {
                  this._colorEditableThings.add(i++,item);
               }
            }
         }
      }
      
      public function setOnlyOneEditableThing(item:InventoryItemInfo) : void
      {
         this._colorEditableThings.add(0,item);
      }
      
      public function savaItemInfo() : void
      {
         this._tempColor = this._currentItem.Color;
         this._tempSkin = this._currentItem.Skin;
      }
      
      public function restoreItem() : void
      {
         if(Boolean(this._currentItem))
         {
            this._currentItem.Color = this._tempColor;
            this._currentItem.Skin = this._tempSkin;
         }
      }
      
      public function get colorEditableThings() : DictionaryData
      {
         return this._colorEditableThings;
      }
      
      public function set self(value:SelfInfo) : void
      {
      }
      
      public function get self() : SelfInfo
      {
         return this._self;
      }
      
      public function set currentItem(value:InventoryItemInfo) : void
      {
         this._currentItem = value;
      }
      
      public function findBodyThingByCategoryID(id:int) : InventoryItemInfo
      {
         return this._equipBag.findFirstItem(id);
      }
      
      public function get currentItem() : InventoryItemInfo
      {
         return this._currentItem;
      }
      
      public function set changed(value:Boolean) : void
      {
         this._changed = value;
         dispatchEvent(new Event(ChangeColorCellEvent.SETCOLOR));
      }
      
      public function get changed() : Boolean
      {
         return this._changed;
      }
      
      public function get oldHideHat() : Boolean
      {
         return this._oldHideHat;
      }
      
      public function get oldHideGlass() : Boolean
      {
         return this._oldHideGlass;
      }
      
      public function get oldHideSuit() : Boolean
      {
         return this._oldHideSuit;
      }
      
      public function unlockAll() : void
      {
         this._equipBag.unLockAll();
      }
      
      public function clear() : void
      {
         this.restoreItem();
         this.removeEvents();
         this._colorEditableThings = null;
         this._equipBag = null;
         this._self = null;
         this.initColor = null;
         this.initSkinColor = null;
      }
   }
}

