package equipretrieve.view
{
   import bagAndInfo.bag.BagListView;
   import bagAndInfo.cell.BagCell;
   import com.pickgliss.events.InteractiveEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.utils.DoubleClickManager;
   import ddt.data.BagInfo;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.events.BagEvent;
   import ddt.events.CellEvent;
   import ddt.manager.ItemManager;
   import ddt.manager.SoundManager;
   import equipretrieve.RetrieveModel;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.utils.Dictionary;
   
   public class RetrieveBagListView extends BagListView
   {
      
      public function RetrieveBagListView(bagType:int, columnNum:int = 7)
      {
         super(bagType,columnNum);
      }
      
      override protected function createCells() : void
      {
         var cell:RetrieveBagcell = null;
         _cells = new Dictionary();
         _cellMouseOverBg = ComponentFactory.Instance.creatBitmap("bagAndInfo.cell.bagCellOverBgAsset");
         for(var i:int = 0; i < 49; i++)
         {
            cell = new RetrieveBagcell(i);
            cell.mouseOverEffBoolean = false;
            addChild(cell);
            cell.bagType = _bagType;
            cell.addEventListener(InteractiveEvent.CLICK,this.__clickHandler);
            cell.addEventListener(InteractiveEvent.DOUBLE_CLICK,this.__doubleClickHandler);
            cell.addEventListener(CellEvent.DRAGSTOP,this._stopDrag);
            DoubleClickManager.Instance.enableDoubleClick(cell);
            cell.addEventListener(MouseEvent.MOUSE_OVER,_cellOverEff);
            cell.addEventListener(MouseEvent.MOUSE_OUT,_cellOutEff);
            cell.addEventListener(CellEvent.LOCK_CHANGED,__cellChanged);
            _cells[cell.place] = cell;
            _cellVec.push(cell);
         }
      }
      
      private function _stopDrag(e:CellEvent) : void
      {
         dispatchEvent(new CellEvent(CellEvent.DRAGSTOP,e.currentTarget));
      }
      
      override protected function __clickHandler(evt:InteractiveEvent) : void
      {
         if((evt.currentTarget as BagCell).info != null)
         {
            dispatchEvent(new CellEvent(CellEvent.ITEM_CLICK,evt.currentTarget,false,false,evt.ctrlKey));
         }
      }
      
      override protected function __doubleClickHandler(evt:InteractiveEvent) : void
      {
         SoundManager.instance.play("008");
         if((evt.currentTarget as BagCell).info != null)
         {
            dispatchEvent(new CellEvent(CellEvent.DOUBLE_CLICK,evt.currentTarget));
         }
      }
      
      override public function setData(bag:BagInfo) : void
      {
         var i:String = null;
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
               _cells[i].info = _bagdata.items[i];
               _infoArr.push(_cells[i]);
            }
         }
         _bagdata.addEventListener(BagEvent.UPDATE,__updateGoods);
         this._cellsSort(_infoArr);
      }
      
      override public function setCellInfo(index:int, info:InventoryItemInfo) : void
      {
         if(info == null)
         {
            _cells[String(index)].info = null;
            return;
         }
         if(info.Count > 0 && ItemManager.Instance.getTemplateById(info.TemplateID).CanRecycle != 0)
         {
            _cells[String(index)].info = info;
         }
         else
         {
            _cells[String(index)].info = null;
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
            _cellVec[n] = oldCell;
            i++;
         }
      }
      
      public function returnNullPoint(_dx:Number, _dy:Number) : Object
      {
         var point:Point = new Point(0,0);
         var obj:Object = new Object();
         for(var i:int = 0; i < 49; i++)
         {
            if(_bagdata.items[i] == null)
            {
               point.x = this.localToGlobal(new Point(_cells[i].x,_cells[i].y)).x;
               point.y = this.localToGlobal(new Point(_cells[i].x,_cells[i].y)).y;
               obj.point = point;
               obj.bagType = BagInfo.PROPBAG;
               obj.place = i;
               obj.cell = _cells[i];
               return obj;
            }
         }
         point.x = RetrieveModel.EmailX;
         point.y = RetrieveModel.EmailY;
         obj.point = point;
         obj.bagType = BagInfo.PROPBAG;
         obj.place = i;
         obj.cell = _cells[i];
         RetrieveModel.Instance.isFull = true;
         return obj;
      }
      
      override public function dispose() : void
      {
         DoubleClickManager.Instance.clearTarget();
         super.dispose();
      }
   }
}

