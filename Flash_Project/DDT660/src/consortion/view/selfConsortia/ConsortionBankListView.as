package consortion.view.selfConsortia
{
   import bagAndInfo.bag.BagListView;
   import bagAndInfo.cell.BagCell;
   import bagAndInfo.cell.CellFactory;
   import com.pickgliss.events.InteractiveEvent;
   import com.pickgliss.utils.DoubleClickManager;
   import ddt.events.CellEvent;
   import flash.events.MouseEvent;
   import flash.utils.Dictionary;
   
   public class ConsortionBankListView extends BagListView
   {
      
      private static var MAX_LINE_NUM:int = 10;
      
      private var _bankLevel:int;
      
      public function ConsortionBankListView(bagType:int, level:int = 0)
      {
         super(bagType,MAX_LINE_NUM);
      }
      
      public function upLevel(level:int) : void
      {
         var j:int = 0;
         var index:int = 0;
         var cell:BagCell = null;
         if(level == this._bankLevel)
         {
            return;
         }
         for(var i:int = this._bankLevel; i < level; i++)
         {
            for(j = 0; j < MAX_LINE_NUM; j++)
            {
               index = i * MAX_LINE_NUM + j;
               cell = _cells[index] as BagCell;
               cell.grayFilters = false;
               cell.mouseEnabled = true;
            }
         }
         this._bankLevel = level;
      }
      
      override protected function __doubleClickHandler(evt:InteractiveEvent) : void
      {
         if((evt.currentTarget as BagCell).info != null)
         {
            dispatchEvent(new CellEvent(CellEvent.DOUBLE_CLICK,evt.currentTarget));
         }
      }
      
      override protected function __clickHandler(e:InteractiveEvent) : void
      {
         if(Boolean(e.currentTarget))
         {
            dispatchEvent(new CellEvent(CellEvent.ITEM_CLICK,e.currentTarget,false,false));
         }
      }
      
      private function __resultHandler(evt:MouseEvent) : void
      {
      }
      
      override protected function createCells() : void
      {
         var j:int = 0;
         var index:int = 0;
         var cell:BagCell = null;
         _cells = new Dictionary();
         for(var i:int = 0; i < MAX_LINE_NUM; i++)
         {
            for(j = 0; j < MAX_LINE_NUM; j++)
            {
               index = i * MAX_LINE_NUM + j;
               cell = CellFactory.instance.createBankCell(index) as BagCell;
               addChild(cell);
               cell.bagType = _bagType;
               cell.addEventListener(InteractiveEvent.CLICK,this.__clickHandler);
               cell.addEventListener(InteractiveEvent.DOUBLE_CLICK,this.__doubleClickHandler);
               DoubleClickManager.Instance.enableDoubleClick(cell);
               cell.addEventListener(CellEvent.LOCK_CHANGED,__cellChanged);
               _cells[cell.place] = cell;
               if(this._bankLevel <= i)
               {
                  cell.grayFilters = true;
                  cell.mouseEnabled = false;
               }
            }
         }
      }
      
      public function checkConsortiaStoreCell() : int
      {
         var j:int = 0;
         var index:int = 0;
         var cell:BagCell = null;
         if(this._bankLevel == 0)
         {
            return 1;
         }
         for(var i:int = 0; i < this._bankLevel; i++)
         {
            for(j = 0; j < MAX_LINE_NUM; j++)
            {
               index = i * MAX_LINE_NUM + j;
               cell = _cells[index] as BagCell;
               if(!cell.info)
               {
                  return 0;
               }
            }
         }
         if(this._bankLevel == MAX_LINE_NUM)
         {
            return 2;
         }
         return 3;
      }
      
      override public function dispose() : void
      {
         var cell:BagCell = null;
         for each(cell in _cells)
         {
            cell.removeEventListener(InteractiveEvent.CLICK,this.__clickHandler);
            cell.removeEventListener(InteractiveEvent.DOUBLE_CLICK,this.__doubleClickHandler);
            cell.removeEventListener(CellEvent.LOCK_CHANGED,__cellChanged);
         }
         super.dispose();
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
   }
}

