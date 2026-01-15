package changeColor.view
{
   import bagAndInfo.bag.BagListView;
   import bagAndInfo.cell.BagCell;
   import changeColor.ChangeColorCellEvent;
   import ddt.data.BagInfo;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.events.BagEvent;
   import ddt.events.CellEvent;
   import ddt.manager.PlayerManager;
   import flash.events.MouseEvent;
   import flash.utils.Dictionary;
   
   public class ColorChangeBagListView extends BagListView
   {
      
      public function ColorChangeBagListView()
      {
         super(1);
      }
      
      override protected function createCells() : void
      {
         var cell:ChangeColorBagCell = null;
         _cells = new Dictionary();
         for(var i:int = 0; i < 49; i++)
         {
            cell = new ChangeColorBagCell(i);
            addChild(cell);
            cell.bagType = _bagType;
            cell.addEventListener(MouseEvent.CLICK,this.__cellClick);
            cell.addEventListener(CellEvent.LOCK_CHANGED,__cellChanged);
            _cells[cell.place] = cell;
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
            _bagdata.removeEventListener(BagEvent.UPDATE,this.__updateGoodsII);
         }
         _bagdata = bag;
         var j:int = 0;
         for(i in _bagdata.items)
         {
            if(!Boolean(_cells[j]))
            {
               break;
            }
            _cells[j].info = _bagdata.items[i];
            j++;
         }
         _bagdata.addEventListener(BagEvent.UPDATE,this.__updateGoodsII);
      }
      
      private function __updateGoodsII(evt:BagEvent) : void
      {
         var i:InventoryItemInfo = null;
         var c:InventoryItemInfo = null;
         var changes:Dictionary = evt.changedSlots;
         for each(i in changes)
         {
            c = PlayerManager.Instance.Self.Bag.getItemAt(i.Place);
            if(Boolean(c))
            {
               this.updateItem(c);
            }
            else
            {
               this.removeBagItem(i);
            }
         }
      }
      
      public function updateItem(item:InventoryItemInfo) : void
      {
         for(var i:int = 0; i < 49; i++)
         {
            if(Boolean(_cells[i].itemInfo) && _cells[i].itemInfo.Place == item.Place)
            {
               _cells[i].info = item;
               return;
            }
         }
         for(var j:int = 0; j < 49; j++)
         {
            if(_cells[j].itemInfo == null)
            {
               _cells[j].info = item;
               return;
            }
         }
      }
      
      public function removeBagItem(item:InventoryItemInfo) : void
      {
         for(var i:int = 0; i < 49; i++)
         {
            if(Boolean(_cells[i].itemInfo) && _cells[i].itemInfo.Place == item.Place)
            {
               _cells[i].info = null;
               return;
            }
         }
      }
      
      private function __cellClick(evt:MouseEvent) : void
      {
         if((evt.currentTarget as BagCell).locked == false && (evt.currentTarget as BagCell).info != null)
         {
            dispatchEvent(new ChangeColorCellEvent(ChangeColorCellEvent.CLICK,evt.currentTarget as BagCell,true));
         }
      }
      
      override public function dispose() : void
      {
         var i:String = null;
         if(_bagdata != null)
         {
            _bagdata.removeEventListener(BagEvent.UPDATE,this.__updateGoodsII);
            _bagdata = null;
         }
         for(i in _cells)
         {
            _cells[i].removeEventListener(MouseEvent.CLICK,this.__cellClick);
            _cells[i].removeEventListener(CellEvent.LOCK_CHANGED,__cellChanged);
            _cells[i].dispose();
            _cells[i] = null;
         }
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

