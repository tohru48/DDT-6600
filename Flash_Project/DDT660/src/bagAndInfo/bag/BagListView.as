package bagAndInfo.bag
{
   import bagAndInfo.cell.BagCell;
   import bagAndInfo.cell.BaseCell;
   import bagAndInfo.cell.CellFactory;
   import com.pickgliss.events.InteractiveEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.container.SimpleTileList;
   import com.pickgliss.utils.DoubleClickManager;
   import ddt.data.BagInfo;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.events.BagEvent;
   import ddt.events.CellEvent;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.utils.Dictionary;
   
   public class BagListView extends SimpleTileList
   {
      
      public static const BAG_CAPABILITY:int = 49;
      
      private var _allBagData:BagInfo;
      
      protected var _cellNum:int;
      
      protected var _bagdata:BagInfo;
      
      protected var _bagType:int;
      
      protected var _cells:Dictionary;
      
      protected var _cellMouseOverBg:Bitmap;
      
      protected var _cellVec:Array;
      
      private var _isSetFoodData:Boolean;
      
      private var _currentBagType:int;
      
      public function BagListView(bagType:int, columnNum:int = 7, cellNun:int = 49)
      {
         this._cellNum = cellNun;
         this._bagType = bagType;
         super(columnNum);
         _vSpace = 0;
         _hSpace = 0;
         this._cellVec = new Array();
         this.createCells();
      }
      
      protected function createCells() : void
      {
         var cell:BagCell = null;
         this._cells = new Dictionary();
         this._cellMouseOverBg = ComponentFactory.Instance.creatBitmap("bagAndInfo.cell.bagCellOverBgAsset");
         for(var i:int = 0; i < this._cellNum; i++)
         {
            cell = BagCell(CellFactory.instance.createBagCell(i));
            cell.mouseOverEffBoolean = false;
            addChild(cell);
            cell.bagType = this._bagType;
            cell.addEventListener(InteractiveEvent.CLICK,this.__clickHandler);
            cell.addEventListener(MouseEvent.MOUSE_OVER,this._cellOverEff);
            cell.addEventListener(MouseEvent.MOUSE_OUT,this._cellOutEff);
            cell.addEventListener(InteractiveEvent.DOUBLE_CLICK,this.__doubleClickHandler);
            DoubleClickManager.Instance.enableDoubleClick(cell);
            cell.addEventListener(CellEvent.LOCK_CHANGED,this.__cellChanged);
            this._cells[cell.place] = cell;
            this._cellVec.push(cell);
         }
      }
      
      protected function __doubleClickHandler(evt:InteractiveEvent) : void
      {
         if((evt.currentTarget as BagCell).info != null)
         {
            SoundManager.instance.play("008");
            dispatchEvent(new CellEvent(CellEvent.DOUBLE_CLICK,evt.currentTarget));
         }
      }
      
      protected function __cellChanged(event:Event) : void
      {
         dispatchEvent(new Event(Event.CHANGE));
      }
      
      protected function __clickHandler(evt:InteractiveEvent) : void
      {
         if((evt.currentTarget as BagCell).info != null)
         {
            dispatchEvent(new CellEvent(CellEvent.ITEM_CLICK,evt.currentTarget,false,false,evt.ctrlKey));
         }
      }
      
      protected function _cellOverEff(e:MouseEvent) : void
      {
         BagCell(e.currentTarget).onParentMouseOver(this._cellMouseOverBg);
      }
      
      protected function _cellOutEff(e:MouseEvent) : void
      {
         BagCell(e.currentTarget).onParentMouseOut();
      }
      
      public function setCellInfo(index:int, info:InventoryItemInfo) : void
      {
         if(info == null)
         {
            if(Boolean(this._cells[String(index)]))
            {
               this._cells[String(index)].info = null;
            }
            return;
         }
         if(info.Count == 0)
         {
            this._cells[String(index)].info = null;
         }
         else
         {
            this._cells[String(index)].info = info;
         }
      }
      
      protected function clearDataCells() : void
      {
         var cell:BagCell = null;
         for each(cell in this._cells)
         {
            cell.info = null;
         }
      }
      
      public function set currentBagType(value:int) : void
      {
         this._currentBagType = value;
      }
      
      public function setData(bag:BagInfo) : void
      {
         var i:String = null;
         this._isSetFoodData = false;
         if(this._bagdata == bag)
         {
            return;
         }
         if(this._bagdata != null)
         {
            this._bagdata.removeEventListener(BagEvent.UPDATE,this.__updateGoods);
         }
         this.clearDataCells();
         this._bagdata = bag;
         var infoArr:Array = new Array();
         for(i in this._bagdata.items)
         {
            if(this._cells[i] != null)
            {
               if(this._currentBagType == BagView.PET)
               {
                  if(this._bagdata.items[i].CategoryID == 50 || this._bagdata.items[i].CategoryID == 51 || this._bagdata.items[i].CategoryID == 52)
                  {
                     this._bagdata.items[i].isMoveSpace = true;
                     this._cells[i].info = this._bagdata.items[i];
                     infoArr.push(this._cells[i]);
                  }
               }
               else
               {
                  this._bagdata.items[i].isMoveSpace = true;
                  this._cells[i].info = this._bagdata.items[i];
               }
            }
         }
         this._bagdata.addEventListener(BagEvent.UPDATE,this.__updateGoods);
         if(this._currentBagType == BagView.PET)
         {
            this._cellsSort(infoArr);
         }
      }
      
      private function sortItems() : void
      {
         var i:String = null;
         var item:InventoryItemInfo = null;
         var infoArr:Array = new Array();
         for(i in this._bagdata.items)
         {
            item = this._bagdata.items[i];
            if(this._cells[i] != null && Boolean(item))
            {
               if(item.CategoryID == 50 || item.CategoryID == 51 || item.CategoryID == 52)
               {
                  BaseCell(this._cells[i]).info = item;
                  infoArr.push(this._cells[i]);
               }
            }
         }
         this._cellsSort(infoArr);
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
            n = int(this._cellVec.indexOf(arr[i]));
            oldCell = this._cellVec[i];
            arr[i].x = oldCell.x;
            arr[i].y = oldCell.y;
            oldCell.x = oldx;
            oldCell.y = oldy;
            this._cellVec[i] = arr[i];
            this._cellVec[n] = oldCell;
            i++;
         }
      }
      
      protected function __updateFoodGoods(evt:BagEvent) : void
      {
         var i:InventoryItemInfo = null;
         var index:int = 0;
         var c:InventoryItemInfo = null;
         var j:String = null;
         var inventoryItemInfo:InventoryItemInfo = null;
         var d:InventoryItemInfo = null;
         if(!this._bagdata)
         {
            return;
         }
         var changes:Dictionary = evt.changedSlots;
         for each(i in changes)
         {
            index = -1;
            c = null;
            for(j in this._bagdata.items)
            {
               inventoryItemInfo = this._bagdata.items[j] as InventoryItemInfo;
               if(i.ItemID == inventoryItemInfo.ItemID)
               {
                  c = i;
                  index = int(j);
                  break;
               }
            }
            if(index != -1)
            {
               d = this._bagdata.getItemAt(index);
               if(Boolean(d))
               {
                  d.Count = c.Count;
                  if(Boolean(this._cells[String(index)].info))
                  {
                     this.setCellInfo(index,null);
                  }
                  else
                  {
                     this.setCellInfo(index,d);
                  }
               }
               else
               {
                  this.setCellInfo(index,null);
               }
               dispatchEvent(new Event(Event.CHANGE));
            }
         }
      }
      
      protected function __updateGoods(evt:BagEvent) : void
      {
         var changes:Dictionary = null;
         var i:InventoryItemInfo = null;
         var c:InventoryItemInfo = null;
         if(this._isSetFoodData)
         {
            this.__updateFoodGoods(evt);
         }
         else
         {
            changes = evt.changedSlots;
            for each(i in changes)
            {
               c = this._bagdata.getItemAt(i.Place);
               if(Boolean(c))
               {
                  if(this._currentBagType == BagView.PET)
                  {
                     if(c.CategoryID != 50 && c.CategoryID != 51 && c.CategoryID != 52)
                     {
                        this.setCellInfo(i.Place,null);
                        continue;
                     }
                  }
                  this.setCellInfo(c.Place,c);
               }
               else
               {
                  this.setCellInfo(i.Place,null);
               }
               dispatchEvent(new Event(Event.CHANGE));
            }
         }
         if(this._currentBagType == BagView.PET)
         {
            this.sortItems();
         }
      }
      
      override public function dispose() : void
      {
         var i:BagCell = null;
         if(this._bagdata != null)
         {
            this._bagdata.removeEventListener(BagEvent.UPDATE,this.__updateGoods);
            this._bagdata = null;
         }
         for each(i in this._cells)
         {
            i.removeEventListener(InteractiveEvent.CLICK,this.__clickHandler);
            i.removeEventListener(CellEvent.LOCK_CHANGED,this.__cellChanged);
            i.removeEventListener(MouseEvent.MOUSE_OVER,this._cellOverEff);
            i.removeEventListener(MouseEvent.MOUSE_OUT,this._cellOutEff);
            i.removeEventListener(InteractiveEvent.DOUBLE_CLICK,this.__doubleClickHandler);
            DoubleClickManager.Instance.disableDoubleClick(i);
            i.dispose();
         }
         this._cells = null;
         this._cellVec = null;
         if(Boolean(this._cellMouseOverBg))
         {
            if(Boolean(this._cellMouseOverBg.parent))
            {
               this._cellMouseOverBg.parent.removeChild(this._cellMouseOverBg);
            }
            this._cellMouseOverBg.bitmapData.dispose();
         }
         this._cellMouseOverBg = null;
         super.dispose();
      }
      
      public function get cells() : Dictionary
      {
         return this._cells;
      }
   }
}

