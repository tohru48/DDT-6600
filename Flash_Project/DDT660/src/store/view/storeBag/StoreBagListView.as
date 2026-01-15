package store.view.storeBag
{
   import bagAndInfo.cell.BagCell;
   import com.pickgliss.events.InteractiveEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.container.SimpleTileList;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.DoubleClickManager;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.EquipType;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.events.CellEvent;
   import ddt.manager.SoundManager;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import road7th.data.DictionaryData;
   import road7th.data.DictionaryEvent;
   import store.events.StoreBagEvent;
   import store.events.UpdateItemEvent;
   
   public class StoreBagListView extends Sprite implements Disposeable
   {
      
      public static const SMALLGRID:int = 21;
      
      private var _list:SimpleTileList;
      
      protected var panel:ScrollPanel;
      
      protected var _cells:DictionaryData;
      
      protected var _bagdata:DictionaryData;
      
      protected var _controller:StoreBagController;
      
      protected var _bagType:int;
      
      private var cellNum:int = 70;
      
      private var beginGridNumber:int;
      
      public function StoreBagListView()
      {
         super();
      }
      
      public function setup(bagType:int, controller:StoreBagController, number:int) : void
      {
         this._bagType = bagType;
         this._controller = controller;
         this.beginGridNumber = number;
         this.init();
      }
      
      private function init() : void
      {
         this.createPanel();
         this._list = new SimpleTileList(7);
         this._list.vSpace = 0;
         this._list.hSpace = 0;
         this.panel.setView(this._list);
         this.panel.invalidateViewport();
         this.createCells();
      }
      
      protected function createPanel() : void
      {
         this.panel = ComponentFactory.Instance.creat("ddtstore.StoreBagView.BagEquipScrollPanel");
         addChild(this.panel);
         this.panel.hScrollProxy = ScrollPanel.OFF;
         this.panel.vScrollProxy = ScrollPanel.ON;
      }
      
      protected function createCells() : void
      {
         this._cells = new DictionaryData();
      }
      
      private function __doubleClickHandler(evt:InteractiveEvent) : void
      {
         evt.stopImmediatePropagation();
         if((evt.currentTarget as BagCell).info != null)
         {
            if((evt.currentTarget as BagCell).info != null)
            {
               dispatchEvent(new CellEvent(CellEvent.DOUBLE_CLICK,evt.currentTarget,true));
               SoundManager.instance.play("008");
            }
         }
      }
      
      private function __clickHandler(e:InteractiveEvent) : void
      {
         if(Boolean(e.currentTarget))
         {
            dispatchEvent(new CellEvent(CellEvent.ITEM_CLICK,e.currentTarget));
         }
      }
      
      protected function __cellChanged(event:Event) : void
      {
         dispatchEvent(new Event(Event.CHANGE));
      }
      
      protected function __cellClick(evt:MouseEvent) : void
      {
         evt.stopImmediatePropagation();
      }
      
      public function getCellByPlace(place:int) : BagCell
      {
         return this._cells[place];
      }
      
      public function setCellInfo(index:int, info:InventoryItemInfo) : void
      {
         if(info == null)
         {
            if(Boolean(this._cells) && Boolean(this._cells[String(index)]))
            {
               this._cells[String(index)].info = null;
            }
            return;
         }
         if(info.Count == 0)
         {
            if(Boolean(this._cells) && Boolean(this._cells[String(index)]))
            {
               this._cells[String(index)].info = null;
            }
         }
         else
         {
            if(!this._cells[String(index)])
            {
               this._appendCell(index);
            }
            if(info.BagType == 0 && info.Place < 17)
            {
               this._cells[String(index)].isUsed = true;
            }
            else
            {
               this._cells[String(index)].isUsed = false;
            }
            this._cells[String(index)].info = info;
         }
      }
      
      public function setData(list:DictionaryData) : void
      {
         var arr:Array = null;
         var key:String = null;
         var i:String = null;
         if(this._bagdata != null)
         {
            this._bagdata.removeEventListener(DictionaryEvent.ADD,this.__addGoods);
            this._bagdata.removeEventListener(StoreBagEvent.REMOVE,this.__removeGoods);
            this._bagdata.removeEventListener(UpdateItemEvent.UPDATEITEMEVENT,this.__updateGoods);
         }
         this._bagdata = list;
         this.addGrid(list);
         if(Boolean(list))
         {
            arr = new Array();
            for(key in list)
            {
               arr.push(key);
            }
            arr.sort(Array.NUMERIC);
            for(i in arr)
            {
               if(this._cells[i] != null)
               {
                  if(list[i] && list[i].BagType == 0 && list[i].Place < 17)
                  {
                     this._cells[i].isUsed = true;
                  }
                  else
                  {
                     this._cells[i].isUsed = false;
                  }
                  this._cells[i].info = list[i];
               }
            }
         }
         this._bagdata.addEventListener(DictionaryEvent.ADD,this.__addGoods);
         this._bagdata.addEventListener(StoreBagEvent.REMOVE,this.__removeGoods);
         this._bagdata.addEventListener(UpdateItemEvent.UPDATEITEMEVENT,this.__updateGoods);
         this.updateScrollBar();
      }
      
      private function addGrid(list:DictionaryData) : void
      {
         var key:String = null;
         var needGrid:int = 0;
         this._cells.clear();
         this._list.disposeAllChildren();
         var n:int = 0;
         for(key in list)
         {
            n++;
         }
         needGrid = (int((n - 1) / 7) + 1) * 7;
         needGrid = needGrid < this.beginGridNumber ? this.beginGridNumber : needGrid;
         this.cellNum = needGrid;
         this._list.beginChanges();
         for(var i:int = 0; i < needGrid; i++)
         {
            this.createCell(i);
         }
         this._list.commitChanges();
         this.invalidatePanel();
      }
      
      private function createCell(index:int) : void
      {
         var cell:StoreBagCell = new StoreBagCell(index);
         cell.bagType = this._bagType;
         cell.tipDirctions = "7,6,5,4,3,2,1";
         cell.addEventListener(InteractiveEvent.CLICK,this.__clickHandler);
         cell.addEventListener(InteractiveEvent.DOUBLE_CLICK,this.__doubleClickHandler);
         DoubleClickManager.Instance.enableDoubleClick(cell);
         cell.addEventListener(MouseEvent.CLICK,this.__cellClick);
         cell.addEventListener(CellEvent.LOCK_CHANGED,this.__cellChanged);
         this._cells.add(cell.place,cell);
         this._list.addChild(cell);
      }
      
      private function _appendCell(sum:int) : void
      {
         for(var i:int = sum; i < sum + 7; i++)
         {
            this.createCell(i);
         }
      }
      
      private function updateScrollBar(updatePosition:Boolean = true) : void
      {
      }
      
      protected function __addGoods(evt:DictionaryEvent) : void
      {
         var t:InventoryItemInfo = evt.data as InventoryItemInfo;
         for(var i:int = 0; i < this.cellNum; i++)
         {
            if(this._bagdata[i] == t)
            {
               this.setCellInfo(i,t);
               break;
            }
         }
         this.updateScrollBar();
      }
      
      private function checkShouldAutoLink(item:InventoryItemInfo) : Boolean
      {
         if(this._controller.model.NeedAutoLink <= 0)
         {
            return false;
         }
         if(item.TemplateID == EquipType.LUCKY || item.TemplateID == EquipType.SYMBLE || item.TemplateID == EquipType.STRENGTH_STONE4 || item.StrengthenLevel >= 10)
         {
            return true;
         }
         return false;
      }
      
      protected function __removeGoods(evt:StoreBagEvent) : void
      {
         this._cells[evt.pos].info = null;
         this.updateScrollBar(false);
      }
      
      private function __updateGoods(evt:UpdateItemEvent) : void
      {
         if(Boolean(this._cells) && this._cells.length > evt.pos)
         {
            this._cells[evt.pos].info = evt.item as InventoryItemInfo;
            this.updateScrollBar(false);
         }
      }
      
      public function getCellByPos(pos:int) : BagCell
      {
         return this._cells[pos];
      }
      
      private function invalidatePanel() : void
      {
         this.panel.invalidateViewport();
      }
      
      public function dispose() : void
      {
         var i:BagCell = null;
         this._controller = null;
         if(this._bagdata != null)
         {
            this._bagdata.removeEventListener(DictionaryEvent.ADD,this.__addGoods);
            this._bagdata.removeEventListener(StoreBagEvent.REMOVE,this.__removeGoods);
            this._bagdata.removeEventListener(UpdateItemEvent.UPDATEITEMEVENT,this.__updateGoods);
            this._bagdata = null;
         }
         for each(i in this._cells)
         {
            i.removeEventListener(InteractiveEvent.CLICK,this.__clickHandler);
            i.removeEventListener(InteractiveEvent.DOUBLE_CLICK,this.__doubleClickHandler);
            DoubleClickManager.Instance.disableDoubleClick(i);
            i.removeEventListener(MouseEvent.CLICK,this.__cellClick);
            i.removeEventListener(CellEvent.LOCK_CHANGED,this.__cellChanged);
            ObjectUtils.disposeObject(i);
         }
         this._cells.clear();
         DoubleClickManager.Instance.clearTarget();
         this._list.disposeAllChildren();
         this._list = null;
         this._cells = null;
         if(Boolean(this.panel))
         {
            ObjectUtils.disposeObject(this.panel);
         }
         this.panel = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
      
      public function get cells() : DictionaryData
      {
         return this._cells;
      }
   }
}

