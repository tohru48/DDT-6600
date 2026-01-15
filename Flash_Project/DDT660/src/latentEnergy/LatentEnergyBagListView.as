package latentEnergy
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
   
   public class LatentEnergyBagListView extends BagListView
   {
      
      private var _autoExpandV:Boolean;
      
      public function LatentEnergyBagListView(bagType:int, columnNum:int = 7, cellNun:int = 49, autoExpandV:Boolean = false)
      {
         this._autoExpandV = autoExpandV;
         super(bagType,columnNum,cellNun);
         if(bagType == BagInfo.EQUIPBAG)
         {
            LatentEnergyManager.instance.addEventListener(LatentEnergyManager.EQUIP_MOVE,this.equipMoveHandler);
            LatentEnergyManager.instance.addEventListener(LatentEnergyManager.EQUIP_MOVE2,this.equipMoveHandler2);
         }
         else
         {
            LatentEnergyManager.instance.addEventListener(LatentEnergyManager.ITEM_MOVE,this.equipMoveHandler);
            LatentEnergyManager.instance.addEventListener(LatentEnergyManager.ITEM_MOVE2,this.equipMoveHandler2);
         }
      }
      
      override protected function createCells() : void
      {
         _cells = new Dictionary();
         _cellMouseOverBg = ComponentFactory.Instance.creatBitmap("bagAndInfo.cell.bagCellOverBgAsset");
         for(var i:int = 0; i < _cellNum; i++)
         {
            this.addCell(i);
         }
      }
      
      private function addCell(place:int) : void
      {
         var cell:LatentEnergyEquipListCell = this.createBagCell(place);
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
      
      private function createBagCell(place:int, info:ItemTemplateInfo = null, showLoading:Boolean = true) : LatentEnergyEquipListCell
      {
         var cell:LatentEnergyEquipListCell = new LatentEnergyEquipListCell(place,info,showLoading);
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
      
      private function equipMoveHandler(event:LatentEnergyEvent) : void
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
      
      private function equipMoveHandler2(event:LatentEnergyEvent) : void
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
         var i:String = null;
         var tempA:int = 0;
         var tempB:int = 0;
         var tempC:int = 0;
         var q:int = 0;
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
         if(this.autoExpandV && _cellVec.length < _bagdata.items.length)
         {
            tempA = _bagdata.items.length - _cellVec.length;
            tempB = int(_cellVec.length);
            tempC = 0;
            if(_bagdata.items.length % 7 > 0)
            {
               tempC = 7 - _bagdata.items.length % 7;
            }
            for(q = tempB; q < tempB + tempA + tempC; q++)
            {
               this.addCell(q);
            }
            _cellNum = _cellVec.length;
         }
         var k:int = 0;
         for(i in _bagdata.items)
         {
            if(_cells[k] != null)
            {
               _bagdata.items[i].isMoveSpace = true;
               _cells[k].info = _bagdata.items[i];
            }
            k++;
         }
         _bagdata.addEventListener(BagEvent.UPDATE,__updateGoods);
      }
      
      public function get autoExpandV() : Boolean
      {
         return this._autoExpandV;
      }
      
      public function set autoExpandV(value:Boolean) : void
      {
         this._autoExpandV = value;
      }
      
      override public function dispose() : void
      {
         LatentEnergyManager.instance.removeEventListener(LatentEnergyManager.EQUIP_MOVE,this.equipMoveHandler);
         LatentEnergyManager.instance.removeEventListener(LatentEnergyManager.EQUIP_MOVE2,this.equipMoveHandler2);
         LatentEnergyManager.instance.removeEventListener(LatentEnergyManager.ITEM_MOVE,this.equipMoveHandler);
         LatentEnergyManager.instance.removeEventListener(LatentEnergyManager.ITEM_MOVE2,this.equipMoveHandler2);
         super.dispose();
      }
   }
}

