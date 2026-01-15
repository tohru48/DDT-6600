package magicStone.views
{
   import bagAndInfo.bag.BagListView;
   import bagAndInfo.cell.CellFactory;
   import com.pickgliss.events.InteractiveEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.utils.DoubleClickManager;
   import ddt.data.BagInfo;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.events.BagEvent;
   import ddt.events.CellEvent;
   import flash.events.Event;
   import flash.utils.Dictionary;
   import magicStone.components.MgStoneCell;
   import magicStone.components.MgStoneUtils;
   
   public class MagicStoneBagList extends BagListView
   {
      
      private var _curPage:int = 1;
      
      private var _startIndex:int = MgStoneUtils.BAG_START;
      
      private var _endIndex:int;
      
      public function MagicStoneBagList(bagType:int, columnNum:int = 7, cellNun:int = 49)
      {
         this._endIndex = MgStoneUtils.BAG_START + cellNun - 1;
         super(bagType,columnNum,cellNun);
      }
      
      override protected function createCells() : void
      {
         var cell:MgStoneCell = null;
         _cells = new Dictionary();
         _cellMouseOverBg = ComponentFactory.Instance.creatBitmap("bagAndInfo.cell.bagCellOverBgAsset");
         for(var i:int = MgStoneUtils.BAG_START; i <= MgStoneUtils.BAG_END; i++)
         {
            cell = MgStoneCell(CellFactory.instance.createMgStoneCell(i));
            cell.addEventListener(InteractiveEvent.CLICK,__clickHandler);
            cell.addEventListener(InteractiveEvent.DOUBLE_CLICK,__doubleClickHandler);
            DoubleClickManager.Instance.enableDoubleClick(cell);
            cell.addEventListener(CellEvent.LOCK_CHANGED,__cellChanged);
            if(i >= this._startIndex && i <= this._endIndex)
            {
               addChild(cell);
            }
            _cells[i] = cell;
            _cellVec.push(cell);
         }
      }
      
      override public function setData(bag:BagInfo) : void
      {
         if(_bagdata == bag)
         {
            return;
         }
         if(Boolean(_bagdata))
         {
            _bagdata.removeEventListener(BagEvent.UPDATE,this.__updateGoods);
         }
         _bagdata = bag;
         this.updateBagList();
         _bagdata.addEventListener(BagEvent.UPDATE,this.__updateGoods);
      }
      
      override protected function __updateGoods(evt:BagEvent) : void
      {
         var item:InventoryItemInfo = null;
         var c:InventoryItemInfo = null;
         var changes:Dictionary = evt.changedSlots;
         for each(item in changes)
         {
            if(item.Place >= MgStoneUtils.BAG_START && item.Place <= MgStoneUtils.BAG_END)
            {
               c = _bagdata.getItemAt(item.Place);
               if(Boolean(c))
               {
                  this.setCellInfo(c.Place,c);
               }
               else
               {
                  this.setCellInfo(item.Place,null);
               }
               dispatchEvent(new Event(Event.CHANGE));
            }
         }
      }
      
      override public function setCellInfo(index:int, info:InventoryItemInfo) : void
      {
         var key:String = String(index);
         if(info == null)
         {
            if(Boolean(_cells[key]))
            {
               _cells[key].info = null;
            }
            return;
         }
         if(info.Count == 0)
         {
            _cells[key].info = null;
         }
         else
         {
            _cells[key].info = info;
         }
      }
      
      public function updateBagList() : void
      {
         var index:String = null;
         clearDataCells();
         removeAllChild();
         for(var i:int = MgStoneUtils.BAG_START; i <= MgStoneUtils.BAG_END; i++)
         {
            if(i >= this._startIndex && i <= this._endIndex)
            {
               addChild(_cells[i]);
            }
         }
         for(index in _bagdata.items)
         {
            if(_cells[index] != null)
            {
               _bagdata.items[index].isMoveSpace = true;
               _cells[index].info = _bagdata.items[index];
            }
         }
      }
      
      public function set curPage(value:int) : void
      {
         this._curPage = value;
         this._startIndex = MgStoneUtils.BAG_START + (this._curPage - 1) * _cellNum;
         this._endIndex = MgStoneUtils.BAG_START + this._curPage * _cellNum - 1;
      }
      
      override public function dispose() : void
      {
         if(Boolean(_bagdata))
         {
            _bagdata.removeEventListener(BagEvent.UPDATE,this.__updateGoods);
         }
         super.dispose();
      }
   }
}

