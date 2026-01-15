package tryonSystem
{
   import ddt.data.EquipType;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.player.PlayerInfo;
   import ddt.manager.PlayerManager;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import road7th.data.DictionaryData;
   
   public class TryonModel extends EventDispatcher
   {
      
      private var _playerInfo:PlayerInfo;
      
      private var _selectedItem:InventoryItemInfo;
      
      private var _items:Array;
      
      private var _bagItems:DictionaryData;
      
      public function TryonModel($items:Array)
      {
         var item:InventoryItemInfo = null;
         super();
         this._items = $items;
         var _self:PlayerInfo = PlayerManager.Instance.Self;
         this._playerInfo = new PlayerInfo();
         this._playerInfo.updateStyle(_self.Sex,_self.Hide,_self.getPrivateStyle(),_self.Colors,_self.getSkinColor());
         this._bagItems = new DictionaryData();
         for each(item in _self.Bag.items)
         {
            if(item.Place <= 30)
            {
               this._bagItems.add(item.Place,item);
            }
         }
      }
      
      public function set selectedItem(item:InventoryItemInfo) : void
      {
         if(item == this._selectedItem)
         {
            return;
         }
         this._selectedItem = item;
         if(EquipType.isAvatar(item.CategoryID))
         {
            this._playerInfo.setPartStyle(item.CategoryID,item.NeedSex,item.TemplateID);
            if(item.CategoryID == EquipType.FACE)
            {
               this._playerInfo.setSkinColor(item.Skin);
            }
            this._bagItems.add(EquipType.CategeryIdToPlace(this._selectedItem.CategoryID)[0],this._selectedItem);
         }
         dispatchEvent(new Event(Event.CHANGE));
      }
      
      public function get bagItems() : DictionaryData
      {
         return this._bagItems;
      }
      
      public function get items() : Array
      {
         return this._items;
      }
      
      public function get playerInfo() : PlayerInfo
      {
         return this._playerInfo;
      }
      
      public function get selectedItem() : InventoryItemInfo
      {
         return this._selectedItem;
      }
      
      public function dispose() : void
      {
         this._selectedItem = null;
         this._items = null;
         this._playerInfo = null;
         this._bagItems = null;
      }
   }
}

