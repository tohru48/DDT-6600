package playerDress.views
{
   import bagAndInfo.bag.BagListView;
   import bagAndInfo.cell.BagCell;
   import bagAndInfo.cell.BaseCell;
   import ddt.data.BagInfo;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.events.BagEvent;
   import ddt.manager.SocketManager;
   import flash.utils.ByteArray;
   import flash.utils.Dictionary;
   import playerDress.PlayerDressManager;
   import playerDress.components.DressUtils;
   
   public class DressBagListView extends BagListView
   {
      
      public static const DRESS_INDEX:int = 80;
      
      private var _dressType:int;
      
      private var _sex:int;
      
      private var _searchStr:String;
      
      private var _displayItems:Dictionary;
      
      private var _equipBag:BagInfo;
      
      private var _virtualBag:BagInfo;
      
      private var _currentPage:int = 1;
      
      public var locked:Boolean = false;
      
      public function DressBagListView(bagType:int, columnNum:int = 7, cellNun:int = 49)
      {
         super(bagType,columnNum,cellNun);
      }
      
      public function setSortType(type:int, isMale:Boolean, str:String = "") : void
      {
         this._dressType = type;
         this._sex = isMale ? 1 : 2;
         this._searchStr = str;
         this.sortItems();
      }
      
      override public function setData(bag:BagInfo) : void
      {
         if(this._equipBag != null)
         {
            this._equipBag.removeEventListener(BagEvent.UPDATE,this.__updateGoods);
         }
         this._equipBag = bag;
         this.setVirtualBagData();
         this._equipBag.addEventListener(BagEvent.UPDATE,this.__updateGoods);
      }
      
      private function setVirtualBagData() : void
      {
         var item:InventoryItemInfo = null;
         this._virtualBag = new BagInfo(BagInfo.EQUIPBAG,48);
         var index:int = 0;
         for each(item in this._equipBag.items)
         {
            if(DressUtils.isDress(item))
            {
               this._virtualBag.items[index] = item;
               index++;
            }
         }
      }
      
      override protected function __updateGoods(evt:BagEvent) : void
      {
         if(!this.locked)
         {
            this.setVirtualBagData();
            this.sortItems();
         }
      }
      
      private function sortItems() : void
      {
         var key:String = null;
         var item:InventoryItemInfo = null;
         this._displayItems = new Dictionary();
         clearDataCells();
         var i:int = 0;
         this.sequenceItems();
         for(key in this._virtualBag.items)
         {
            item = this._virtualBag.items[key];
            if(item.NeedSex == this._sex || item.NeedSex == 0)
            {
               if(!PlayerDressManager.instance.showBind)
               {
                  if(item.IsBinds == true)
                  {
                     continue;
                  }
               }
               if(this._dressType == -1)
               {
                  if(this._searchStr != "" && item.Name.indexOf(this._searchStr) != -1)
                  {
                     this._displayItems[i] = item;
                     if(i >= 0 && i < _cellNum)
                     {
                        BaseCell(_cells[i]).info = item;
                     }
                     i++;
                  }
               }
               else if(this._dressType == 0)
               {
                  this._displayItems[i] = item;
                  if(i >= 0 && i < _cellNum)
                  {
                     BaseCell(_cells[i]).info = item;
                  }
                  i++;
               }
               else if(item.CategoryID == this._dressType)
               {
                  this._displayItems[i] = item;
                  if(i >= 0 && i < _cellNum)
                  {
                     BaseCell(_cells[i]).info = item;
                  }
                  i++;
               }
            }
         }
         this._currentPage = 1;
         (parent as DressBagView).currentPage = 1;
         (parent as DressBagView).updatePage();
      }
      
      private function sequenceItems() : void
      {
         var item:InventoryItemInfo = null;
         var fooBA:ByteArray = null;
         var tItem:InventoryItemInfo = null;
         var tempBag:BagInfo = new BagInfo(BagInfo.EQUIPBAG,48);
         var arr:Array = [];
         var arr2:Array = [];
         for each(item in this._virtualBag.items)
         {
            arr.push({
               "TemplateID":item.TemplateID,
               "ItemID":item.ItemID,
               "CategoryIDSort":DressUtils.getBagGoodsCategoryIDSort(uint(item.CategoryID)),
               "Place":item.Place,
               "RemainDate":item.getRemainDate() > 0,
               "CanStrengthen":item.CanStrengthen,
               "StrengthenLevel":item.StrengthenLevel,
               "IsBinds":item.IsBinds
            });
         }
         fooBA = new ByteArray();
         fooBA.writeObject(arr);
         fooBA.position = 0;
         arr2 = fooBA.readObject() as Array;
         arr.sortOn(["RemainDate","CategoryIDSort","TemplateID","CanStrengthen","IsBinds","StrengthenLevel","Place"],[Array.DESCENDING,Array.NUMERIC,Array.NUMERIC | Array.DESCENDING,Array.DESCENDING,Array.DESCENDING,Array.NUMERIC | Array.DESCENDING,Array.NUMERIC]);
         if(this.bagComparison(arr,arr2))
         {
            return;
         }
         var index:int = 0;
         for(var i:int = 0; i <= arr.length - 1; i++)
         {
            for each(tItem in this._virtualBag.items)
            {
               if(arr[i].Place == tItem.Place)
               {
                  tempBag.items[index] = tItem;
                  index++;
                  break;
               }
            }
         }
         this._virtualBag = tempBag;
      }
      
      private function bagComparison(bagArray1:Array, bagArray2:Array) : Boolean
      {
         if(bagArray1.length < bagArray2.length)
         {
            return false;
         }
         var len:int = int(bagArray1.length);
         for(var i:int = 0; i < len; i++)
         {
            if(bagArray1[i].ItemID != bagArray2[i].ItemID || bagArray1[i].TemplateID != bagArray2[i].TemplateID)
            {
               return false;
            }
         }
         return true;
      }
      
      public function foldItems() : void
      {
         var key:String = null;
         var item:InventoryItemInfo = null;
         var notFind:Boolean = false;
         var templateId:String = null;
         var skey:int = 0;
         var sPlace:int = 0;
         var canFoldDic:Dictionary = new Dictionary();
         var arr:Array = [];
         for(key in this._virtualBag.items)
         {
            item = this._virtualBag.items[key];
            if(DressUtils.isDress(item) && DressUtils.hasNoAddition(item))
            {
               notFind = true;
               for(templateId in canFoldDic)
               {
                  if(item.TemplateID == parseInt(templateId))
                  {
                     skey = int(canFoldDic[templateId]);
                     sPlace = int(this._virtualBag.items[skey].Place);
                     arr.push({
                        "sPlace":sPlace,
                        "tPlace":item.Place
                     });
                     notFind = false;
                     break;
                  }
               }
               if(notFind)
               {
                  canFoldDic[item.TemplateID] = key;
               }
            }
         }
         this._equipBag.isBatch = true;
         SocketManager.Instance.out.foldDressItem(arr);
      }
      
      public function fillPage(page:int) : void
      {
         var i:String = null;
         var index:int = 0;
         this._currentPage = page;
         clearDataCells();
         for(i in this._displayItems)
         {
            index = parseInt(i) - (this._currentPage - 1) * _cellNum;
            if(index >= 0 && index < _cellNum)
            {
               BaseCell(_cells[index]).info = this._displayItems[i];
            }
         }
      }
      
      public function displayItemsLength() : int
      {
         var item:* = undefined;
         var length:int = 0;
         for each(item in this._displayItems)
         {
            length++;
         }
         return length;
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
      
      public function unlockBag() : void
      {
         this.setVirtualBagData();
         this.sortItems();
         this.locked = false;
      }
      
      override public function dispose() : void
      {
         this.locked = false;
         if(Boolean(this._equipBag))
         {
            this._equipBag.removeEventListener(BagEvent.UPDATE,this.__updateGoods);
         }
         super.dispose();
      }
   }
}

