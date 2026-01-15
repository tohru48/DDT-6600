package equipretrieve.view
{
   import bagAndInfo.bag.BagEquipListView;
   import bagAndInfo.cell.BagCell;
   import com.pickgliss.events.InteractiveEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.utils.DoubleClickManager;
   import ddt.data.BagInfo;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.events.BagEvent;
   import ddt.events.CellEvent;
   import ddt.manager.ItemManager;
   import equipretrieve.RetrieveModel;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.utils.Dictionary;
   
   public class RetrieveBagEquipListView extends BagEquipListView
   {
      
      public function RetrieveBagEquipListView(bagType:int, startIndex:int = 31, stopIndex:int = 80)
      {
         super(bagType,startIndex,stopIndex);
      }
      
      override protected function createCells() : void
      {
         var cell:RetrieveBagcell = null;
         _cells = new Dictionary();
         _cellMouseOverBg = ComponentFactory.Instance.creatBitmap("bagAndInfo.cell.bagCellOverBgAsset");
         for(var i:int = _startIndex; i < _stopIndex; i++)
         {
            cell = new RetrieveBagcell(i);
            cell.mouseOverEffBoolean = false;
            addChild(cell);
            cell.addEventListener(InteractiveEvent.CLICK,__clickHandler);
            cell.addEventListener(InteractiveEvent.DOUBLE_CLICK,__doubleClickHandler);
            cell.addEventListener(CellEvent.DRAGSTOP,this._stopDrag);
            cell.addEventListener(MouseEvent.MOUSE_OVER,_cellOverEff);
            cell.addEventListener(MouseEvent.MOUSE_OUT,_cellOutEff);
            DoubleClickManager.Instance.enableDoubleClick(cell);
            cell.bagType = _bagType;
            cell.addEventListener(CellEvent.LOCK_CHANGED,__cellChanged);
            _cells[cell.place] = cell;
            _cellVec.push(cell);
         }
      }
      
      private function _stopDrag(e:CellEvent) : void
      {
         dispatchEvent(new CellEvent(CellEvent.DRAGSTOP,e.currentTarget));
      }
      
      override public function setData(bag:BagInfo) : void
      {
         var i:String = null;
         var infoSLevel:int = 0;
         if(_bagdata == bag)
         {
            return;
         }
         if(_bagdata != null)
         {
            _bagdata.removeEventListener(BagEvent.UPDATE,__updateGoods);
         }
         _bagdata = bag;
         var _infoArr:Array = new Array();
         for(i in _bagdata.items)
         {
            if(_cells[i] != null && _bagdata.items[i] && ItemManager.Instance.getTemplateById(_bagdata.items[i].TemplateID).CanRecycle != 0)
            {
               infoSLevel = int(_bagdata.items[i].StrengthenLevel);
               if(infoSLevel < 7)
               {
                  if(_bagdata.items[i].BagType == 0 && _bagdata.items[i].Place < 17)
                  {
                     _cells[i].isUsed = true;
                  }
                  else
                  {
                     _cells[i].isUsed = false;
                  }
                  _cells[i].info = _bagdata.items[i];
                  _infoArr.push(_cells[i]);
               }
            }
         }
         _bagdata.addEventListener(BagEvent.UPDATE,__updateGoods);
         this._cellsSort(_infoArr);
      }
      
      override public function setCellInfo(index:int, info:InventoryItemInfo) : void
      {
         var infoSLevel:int = 0;
         if(index >= _startIndex && index < _stopIndex)
         {
            if(info == null)
            {
               _cells[String(index)].info = null;
               return;
            }
            infoSLevel = info.StrengthenLevel;
            if(info.Count > 0 && ItemManager.Instance.getTemplateById(info.TemplateID).CanRecycle != 0 && infoSLevel < 7)
            {
               _cells[String(index)].info = info;
            }
            else
            {
               _cells[String(index)].info = null;
            }
         }
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
            _cellVec[n] = oldCell as RetrieveBagcell;
            i++;
         }
      }
      
      public function returnNullPoint(_dx:Number, _dy:Number) : Object
      {
         var point:Point = new Point(0,0);
         var obj:Object = new Object();
         for(var i:int = _startIndex; i < _stopIndex; i++)
         {
            if(_bagdata.items[i] == null)
            {
               point.x = this.localToGlobal(new Point(_cells[i].x,_cells[i].y)).x;
               point.y = this.localToGlobal(new Point(_cells[i].x,_cells[i].y)).y;
               obj.point = point;
               obj.bagType = BagInfo.EQUIPBAG;
               obj.place = i;
               obj.cell = _cells[i];
               return obj;
            }
         }
         point.x = RetrieveModel.EmailX;
         point.y = RetrieveModel.EmailY;
         obj.point = point;
         obj.bagType = BagInfo.EQUIPBAG;
         obj.place = i;
         obj.cell = _cells[i];
         RetrieveModel.Instance.isFull = true;
         return obj;
      }
   }
}

