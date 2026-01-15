package store.forge.wishBead
{
   import bagAndInfo.bag.BagListView;
   import bagAndInfo.cell.BagCell;
   import com.pickgliss.events.InteractiveEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.utils.DoubleClickManager;
   import ddt.data.BagInfo;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.events.BagEvent;
   import ddt.events.CellEvent;
   import ddt.interfaces.ICell;
   import flash.events.MouseEvent;
   import flash.utils.Dictionary;
   
   public class WishBeadBagListView extends BagListView
   {
      
      public function WishBeadBagListView(bagType:int, columnNum:int = 7, cellNun:int = 49)
      {
         super(bagType,columnNum,cellNun);
         if(bagType == BagInfo.EQUIPBAG)
         {
            WishBeadManager.instance.addEventListener(WishBeadManager.EQUIP_MOVE,this.equipMoveHandler);
            WishBeadManager.instance.addEventListener(WishBeadManager.EQUIP_MOVE2,this.equipMoveHandler2);
         }
         else
         {
            WishBeadManager.instance.addEventListener(WishBeadManager.ITEM_MOVE,this.equipMoveHandler);
            WishBeadManager.instance.addEventListener(WishBeadManager.ITEM_MOVE2,this.equipMoveHandler2);
         }
      }
      
      override protected function createCells() : void
      {
         var cell:WishBeadEquipListCell = null;
         _cells = new Dictionary();
         _cellMouseOverBg = ComponentFactory.Instance.creatBitmap("bagAndInfo.cell.bagCellOverBgAsset");
         for(var i:int = 0; i < _cellNum; i++)
         {
            cell = this.createBagCell(i);
            cell.mouseOverEffBoolean = false;
            addChild(cell);
            cell.bagType = _bagType;
            cell.addEventListener(InteractiveEvent.CLICK,__clickHandler);
            cell.addEventListener(MouseEvent.MOUSE_OVER,_cellOverEff);
            cell.addEventListener(MouseEvent.MOUSE_OUT,_cellOutEff);
            cell.addEventListener(InteractiveEvent.DOUBLE_CLICK,__doubleClickHandler);
            DoubleClickManager.Instance.enableDoubleClick(cell);
            cell.addEventListener(CellEvent.LOCK_CHANGED,__cellChanged);
            _cells[cell.place] = cell;
            _cellVec.push(cell);
         }
      }
      
      private function createBagCell(place:int, info:ItemTemplateInfo = null, showLoading:Boolean = true) : WishBeadEquipListCell
      {
         var cell:WishBeadEquipListCell = new WishBeadEquipListCell(place,info,showLoading);
         this.fillTipProp(cell);
         return cell;
      }
      
      private function fillTipProp(cell:ICell) : void
      {
         cell.tipDirctions = "7,6,2,1,5,4,0,3,6";
         cell.tipGapV = 10;
         cell.tipGapH = 10;
         cell.tipStyle = "core.GoodsTip";
      }
      
      private function equipMoveHandler(event:WishBeadEvent) : void
      {
         var itemInfo:InventoryItemInfo = event.info;
         for(var i:int = 0; i < _cellNum; i++)
         {
            if(_cells[i].info == itemInfo)
            {
               _cells[i].info = null;
               break;
            }
         }
      }
      
      private function equipMoveHandler2(event:WishBeadEvent) : void
      {
         var cell:BagCell = null;
         var itemInfo:InventoryItemInfo = event.info;
         if(event.moveType == 2)
         {
            for each(cell in _cells)
            {
               if(cell.info == itemInfo)
               {
                  return;
               }
            }
         }
         for(var k:int = 0; k < _cellNum; k++)
         {
            if(!_cells[k].info)
            {
               _cells[k].info = itemInfo;
               break;
            }
         }
      }
      
      override public function setData(bag:BagInfo) : void
      {
         var key:String = null;
         var i:String = null;
         if(_bagdata == bag)
         {
            return;
         }
         if(_bagdata != null)
         {
            _bagdata.removeEventListener(BagEvent.UPDATE,__updateGoods);
         }
         clearDataCells();
         _bagdata = bag;
         var k:int = 0;
         var arr:Array = new Array();
         for(key in _bagdata.items)
         {
            arr.push(key);
         }
         arr.sort(Array.NUMERIC);
         for each(i in arr)
         {
            if(_cells[k] != null)
            {
               if(_bagdata.items[i].BagType == 0 && _bagdata.items[i].Place < 17)
               {
                  _cells[k].isUsed = true;
               }
               else
               {
                  _cells[k].isUsed = false;
               }
               _bagdata.items[i].isMoveSpace = true;
               _cells[k].info = _bagdata.items[i];
            }
            k++;
         }
         _bagdata.addEventListener(BagEvent.UPDATE,__updateGoods);
      }
      
      override public function dispose() : void
      {
         WishBeadManager.instance.removeEventListener(WishBeadManager.EQUIP_MOVE,this.equipMoveHandler);
         WishBeadManager.instance.removeEventListener(WishBeadManager.EQUIP_MOVE2,this.equipMoveHandler2);
         WishBeadManager.instance.removeEventListener(WishBeadManager.ITEM_MOVE,this.equipMoveHandler);
         WishBeadManager.instance.removeEventListener(WishBeadManager.ITEM_MOVE2,this.equipMoveHandler2);
         super.dispose();
      }
   }
}

