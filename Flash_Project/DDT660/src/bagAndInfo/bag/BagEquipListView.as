package bagAndInfo.bag
{
   import bagAndInfo.cell.BagCell;
   import bagAndInfo.cell.CellFactory;
   import com.pickgliss.events.InteractiveEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.utils.DoubleClickManager;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.events.CellEvent;
   import ddt.manager.SoundManager;
   import flash.events.MouseEvent;
   import flash.utils.Dictionary;
   
   public class BagEquipListView extends BagListView
   {
      
      public var _startIndex:int;
      
      public var _stopIndex:int;
      
      public function BagEquipListView(bagType:int, startIndex:int = 31, stopIndex:int = 80, columnNum:int = 7)
      {
         this._startIndex = startIndex;
         this._stopIndex = stopIndex;
         super(bagType,columnNum);
      }
      
      override protected function createCells() : void
      {
         var cell:BagCell = null;
         _cells = new Dictionary();
         _cellMouseOverBg = ComponentFactory.Instance.creatBitmap("bagAndInfo.cell.bagCellOverBgAsset");
         for(var i:int = this._startIndex; i < this._stopIndex; i++)
         {
            cell = CellFactory.instance.createBagCell(i) as BagCell;
            cell.mouseOverEffBoolean = false;
            addChild(cell);
            cell.addEventListener(InteractiveEvent.CLICK,this.__clickHandler);
            cell.addEventListener(InteractiveEvent.DOUBLE_CLICK,this.__doubleClickHandler);
            DoubleClickManager.Instance.enableDoubleClick(cell);
            cell.bagType = _bagType;
            cell.addEventListener(CellEvent.LOCK_CHANGED,__cellChanged);
            _cells[cell.place] = cell;
            _cellVec.push(cell);
         }
      }
      
      override protected function __doubleClickHandler(evt:InteractiveEvent) : void
      {
         if((evt.currentTarget as BagCell).info != null)
         {
            SoundManager.instance.play("008");
            dispatchEvent(new CellEvent(CellEvent.DOUBLE_CLICK,evt.currentTarget));
         }
      }
      
      override protected function __clickHandler(e:InteractiveEvent) : void
      {
         if(Boolean(e.currentTarget))
         {
            dispatchEvent(new CellEvent(CellEvent.ITEM_CLICK,e.currentTarget,false,false,e.ctrlKey));
         }
      }
      
      protected function __cellClick(evt:MouseEvent) : void
      {
      }
      
      override public function setCellInfo(index:int, info:InventoryItemInfo) : void
      {
         if(index >= this._startIndex && index < this._stopIndex)
         {
            if(info == null)
            {
               _cells[String(index)].info = null;
               return;
            }
            if(info.Count == 0)
            {
               _cells[String(index)].info = null;
            }
            else
            {
               _cells[String(index)].info = info;
            }
         }
      }
      
      override public function dispose() : void
      {
         var cell:BagCell = null;
         for each(cell in _cells)
         {
            cell.removeEventListener(InteractiveEvent.CLICK,this.__clickHandler);
            cell.removeEventListener(InteractiveEvent.DOUBLE_CLICK,this.__doubleClickHandler);
            DoubleClickManager.Instance.disableDoubleClick(cell);
            cell.removeEventListener(CellEvent.LOCK_CHANGED,__cellChanged);
         }
         _cellMouseOverBg = null;
         super.dispose();
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
   }
}

