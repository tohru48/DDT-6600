package bagAndInfo.bag
{
   import bagAndInfo.cell.BagCell;
   import bagAndInfo.cell.BaseCell;
   import ddt.data.BagInfo;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.events.BagEvent;
   import flash.events.Event;
   import flash.utils.Dictionary;
   import road7th.data.DictionaryData;
   
   public class PetBagListView extends BagListView
   {
      
      public static const PET_BAG_CAPABILITY:int = 49;
      
      private var _allBagData:BagInfo;
      
      public function PetBagListView(bagType:int, columnNum:int = 7)
      {
         super(bagType,columnNum,PET_BAG_CAPABILITY);
      }
      
      override public function setData(bag:BagInfo) : void
      {
         if(_bagdata == bag)
         {
            return;
         }
         if(_bagdata != null)
         {
            _bagdata.removeEventListener(BagEvent.UPDATE,this.__updateGoods);
         }
         _bagdata = bag;
         this._allBagData = bag;
         _bagdata.addEventListener(BagEvent.UPDATE,this.__updateGoods);
         this.sortItems();
      }
      
      private function sortItems() : void
      {
         var infoArr:Array = null;
         var i:String = null;
         var item:InventoryItemInfo = null;
         infoArr = new Array();
         for(i in _bagdata.items)
         {
            item = _bagdata.items[i];
            if(_cells[i] != null && Boolean(item))
            {
               if(item.CategoryID == BagInfo.FOOD || item.CategoryID == BagInfo.FOOD_OLD)
               {
                  BaseCell(_cells[i]).info = item;
                  infoArr.push(_cells[i]);
               }
            }
         }
         this._cellsSort(infoArr);
      }
      
      override protected function __updateGoods(evt:BagEvent) : void
      {
         var item:InventoryItemInfo = null;
         var c:InventoryItemInfo = null;
         if(!_bagdata)
         {
            return;
         }
         var changes:Dictionary = evt.changedSlots;
         for each(item in changes)
         {
            c = _bagdata.getItemAt(item.Place);
            if(Boolean(c) && c.CategoryID == BagInfo.FOOD)
            {
               setCellInfo(item.Place,c);
            }
            else
            {
               setCellInfo(item.Place,null);
            }
         }
         this.sortItems();
         dispatchEvent(new Event(Event.CHANGE));
      }
      
      private function updateFoodBagList() : void
      {
         var itemInfo:InventoryItemInfo = null;
         var foodBagInfo:BagInfo = new BagInfo(BagInfo.PROPBAG,PET_BAG_CAPABILITY);
         var dictionaryData:DictionaryData = new DictionaryData();
         var index:int = 0;
         for(var i:int = 0; i < PET_BAG_CAPABILITY; i++)
         {
            itemInfo = this._allBagData.items[i.toString()];
            if(_cells[i] != null)
            {
               if(Boolean(itemInfo) && itemInfo.CategoryID == BagInfo.FOOD)
               {
                  itemInfo.isMoveSpace = false;
                  _cells[index].info = itemInfo;
                  dictionaryData.add(index,itemInfo);
                  index++;
               }
            }
         }
         foodBagInfo.items = dictionaryData;
         _bagdata = foodBagInfo;
      }
      
      private function getItemIndex(i:InventoryItemInfo) : int
      {
         var j:String = null;
         var inventoryItemInfo:InventoryItemInfo = null;
         var index:int = -1;
         for(j in _bagdata.items)
         {
            inventoryItemInfo = _bagdata.items[j] as InventoryItemInfo;
            if(i.Place == inventoryItemInfo.Place)
            {
               index = int(j);
               break;
            }
         }
         return index;
      }
      
      private function _cellsSort(arr:Array) : void
      {
         var i:int = 0;
         var oldx:Number = NaN;
         var oldy:Number = NaN;
         var n:int = 0;
         var oldCell:BagCell = null;
         if(arr.length <= 0)
         {
            return;
         }
         for(i = 0; i < arr.length; )
         {
            oldx = Number(arr[i].x);
            oldy = Number(arr[i].y);
            n = int(_cellVec.indexOf(arr[i]));
            oldCell = _cellVec[i];
            arr[i].x = oldCell.x;
            arr[i].y = oldCell.y;
            oldCell.x = oldx;
            oldCell.y = oldy;
            _cellVec[i] = arr[i];
            _cellVec[n] = oldCell;
            i++;
         }
      }
   }
}

