package beadSystem.controls
{
   import bagAndInfo.bag.BagListView;
   import bagAndInfo.cell.CellFactory;
   import baglocked.BaglockedManager;
   import beadSystem.beadSystemManager;
   import beadSystem.model.BeadModel;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.events.InteractiveEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.utils.DoubleClickManager;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.BagInfo;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.events.BagEvent;
   import ddt.events.CellEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import flash.events.Event;
   import flash.utils.Dictionary;
   
   public class BeadBagList extends BagListView
   {
      
      public var _startIndex:int;
      
      public var _stopIndex:int;
      
      private var _toPlace:int;
      
      private var _beadInfo:InventoryItemInfo;
      
      public function BeadBagList(bagType:int, startIndex:int = 32, stopIndex:int = 80, columnNum:int = 7)
      {
         this._startIndex = startIndex;
         this._stopIndex = stopIndex;
         super(bagType,columnNum);
      }
      
      override protected function __doubleClickHandler(evt:InteractiveEvent) : void
      {
         var bindAlert:BaseAlerFrame = null;
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         var info:InventoryItemInfo = (evt.currentTarget as BeadCell).itemInfo;
         this._beadInfo = info;
         if(Boolean(info) && !info.IsBinds)
         {
            bindAlert = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tips"),LanguageMgr.GetTranslation("ddt.beadSystem.useBindBead"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,true,false,LayerManager.ALPHA_BLOCKGOUND);
            bindAlert.addEventListener(FrameEvent.RESPONSE,this.__onBindRespones);
         }
         else
         {
            this.doBeadEquip();
         }
      }
      
      private function doBeadEquip() : void
      {
         var vToPlace:int = 0;
         if(Boolean(this._beadInfo))
         {
            if(this._beadInfo.Property1 == "31")
            {
               if(this._beadInfo.IsBinds)
               {
               }
               vToPlace = beadSystemManager.Instance.getEquipPlace(this._beadInfo);
               if(Boolean(PlayerManager.Instance.Self.BeadBag.getItemAt(4)) && vToPlace == 4)
               {
                  if(!PlayerManager.Instance.Self.BeadBag.getItemAt(13) && BeadModel._BeadCells[13].isOpend && beadSystemManager.Instance.judgeLevel(this._beadInfo.Hole1,BeadModel._BeadCells[13].HoleLv))
                  {
                     vToPlace = 13;
                  }
                  else if(!PlayerManager.Instance.Self.BeadBag.getItemAt(14) && BeadModel._BeadCells[14].isOpend && beadSystemManager.Instance.judgeLevel(this._beadInfo.Hole1,BeadModel._BeadCells[14].HoleLv))
                  {
                     vToPlace = 14;
                  }
                  else if(!PlayerManager.Instance.Self.BeadBag.getItemAt(15) && BeadModel._BeadCells[15].isOpend && beadSystemManager.Instance.judgeLevel(this._beadInfo.Hole1,BeadModel._BeadCells[15].HoleLv))
                  {
                     vToPlace = 15;
                  }
                  else if(!PlayerManager.Instance.Self.BeadBag.getItemAt(16) && BeadModel._BeadCells[16].isOpend && beadSystemManager.Instance.judgeLevel(this._beadInfo.Hole1,BeadModel._BeadCells[16].HoleLv))
                  {
                     vToPlace = 16;
                  }
                  else if(!PlayerManager.Instance.Self.BeadBag.getItemAt(17) && BeadModel._BeadCells[17].isOpend && beadSystemManager.Instance.judgeLevel(this._beadInfo.Hole1,BeadModel._BeadCells[17].HoleLv))
                  {
                     vToPlace = 17;
                  }
                  else if(!PlayerManager.Instance.Self.BeadBag.getItemAt(18) && BeadModel._BeadCells[18].isOpend && beadSystemManager.Instance.judgeLevel(this._beadInfo.Hole1,BeadModel._BeadCells[18].HoleLv))
                  {
                     vToPlace = 18;
                  }
               }
               SocketManager.Instance.out.sendBeadEquip(this._beadInfo.Place,vToPlace);
            }
         }
      }
      
      protected function __onBindRespones(pEvent:FrameEvent) : void
      {
         switch(pEvent.responseCode)
         {
            case FrameEvent.CANCEL_CLICK:
            case FrameEvent.CLOSE_CLICK:
            case FrameEvent.ESC_CLICK:
               break;
            case FrameEvent.SUBMIT_CLICK:
            case FrameEvent.ENTER_CLICK:
               this.doBeadEquip();
         }
         pEvent.currentTarget.removeEventListener(FrameEvent.RESPONSE,this.__onBindRespones);
         ObjectUtils.disposeObject(pEvent.currentTarget);
      }
      
      public function get BeadCells() : Dictionary
      {
         return _cells;
      }
      
      override protected function createCells() : void
      {
         var cell:BeadCell = null;
         _cells = new Dictionary();
         _cellMouseOverBg = ComponentFactory.Instance.creatBitmap("bagAndInfo.cell.bagCellOverBgAsset");
         for(var i:int = this._startIndex; i <= this._stopIndex; i++)
         {
            cell = BeadCell(CellFactory.instance.createBeadCell(i));
            addChild(cell);
            cell.addEventListener(InteractiveEvent.CLICK,this.__clickHandler);
            cell.addEventListener(InteractiveEvent.DOUBLE_CLICK,this.__doubleClickHandler);
            DoubleClickManager.Instance.enableDoubleClick(cell);
            cell.addEventListener(CellEvent.LOCK_CHANGED,__cellChanged);
            _cells[cell.beadPlace] = cell;
            _cellVec.push(cell);
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
            _bagdata.removeEventListener(BagEvent.UPDATE,this.__updateGoods);
         }
         clearDataCells();
         _bagdata = bag;
         for(i in _bagdata.items)
         {
            if(_cells[i] != null)
            {
               _bagdata.items[i].isMoveSpace = true;
               _cells[i].itemInfo = _bagdata.items[i];
               _cells[i].info = _bagdata.items[i];
            }
         }
         _bagdata.addEventListener(BagEvent.UPDATE,this.__updateGoods);
      }
      
      override protected function __updateGoods(evt:BagEvent) : void
      {
         var i:InventoryItemInfo = null;
         var c:InventoryItemInfo = null;
         var changes:Dictionary = evt.changedSlots;
         for each(i in changes)
         {
            c = _bagdata.getItemAt(i.Place);
            if(Boolean(c))
            {
               this.setCellInfo(c.Place,c);
            }
            else
            {
               this.setCellInfo(i.Place,null);
            }
            dispatchEvent(new Event(Event.CHANGE));
         }
      }
      
      override protected function __clickHandler(evt:InteractiveEvent) : void
      {
         if((evt.currentTarget as BeadCell).info != null)
         {
            dispatchEvent(new CellEvent(CellEvent.ITEM_CLICK,evt.currentTarget,false,false,evt.ctrlKey));
         }
      }
      
      override public function setCellInfo(index:int, info:InventoryItemInfo) : void
      {
         if(index >= this._startIndex && index <= this._stopIndex)
         {
            if(info == null)
            {
               _cells[String(index)].info = null;
               _cells[String(index)].itemInfo = null;
               return;
            }
            if(info.Count == 0)
            {
               _cells[String(index)].info = null;
               _cells[String(index)].itemInfo = null;
            }
            else
            {
               _cells[String(index)].itemInfo = info;
               _cells[String(index)].info = info;
            }
         }
      }
      
      override public function dispose() : void
      {
         var cell:BeadCell = null;
         for each(cell in _cells)
         {
            cell.removeEventListener(InteractiveEvent.CLICK,this.__clickHandler);
            cell.removeEventListener(InteractiveEvent.DOUBLE_CLICK,this.__doubleClickHandler);
            cell.locked = false;
            cell.dispose();
         }
         _cells = null;
         super.dispose();
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
   }
}

