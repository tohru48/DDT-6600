package beadSystem.views
{
   import bagAndInfo.cell.BagCell;
   import beadSystem.controls.BeadBagList;
   import beadSystem.controls.BeadLockButton;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.events.CellEvent;
   import ddt.manager.PlayerManager;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class BeadBagListView extends Sprite implements Disposeable
   {
      
      private var _beadLockBtn:BeadLockButton;
      
      private var _beadBagList:BeadBagList;
      
      public function BeadBagListView()
      {
         super();
         this._beadLockBtn = ComponentFactory.Instance.creatCustomObject("beadLockBtn");
         this._beadBagList = ComponentFactory.Instance.creatCustomObject("beadBagList");
         this._beadBagList.setData(PlayerManager.Instance.Self.BeadBag);
         addChild(this._beadBagList);
         addChild(this._beadLockBtn);
         this._beadLockBtn.addEventListener(MouseEvent.CLICK,this.lockBead,false,0,true);
         this._beadBagList.addEventListener(CellEvent.ITEM_CLICK,this.__cellClick);
      }
      
      protected function __cellClick(evt:CellEvent) : void
      {
         var info:InventoryItemInfo = null;
         evt.stopImmediatePropagation();
         var cell:BagCell = evt.data as BagCell;
         if(Boolean(cell))
         {
            info = cell.info as InventoryItemInfo;
         }
         if(info == null)
         {
            return;
         }
         if(!cell.locked)
         {
            cell.dragStart();
         }
      }
      
      public function dispose() : void
      {
         this._beadLockBtn.removeEventListener(MouseEvent.CLICK,this.lockBead);
         this._beadBagList.removeEventListener(CellEvent.ITEM_CLICK,this.__cellClick);
         if(Boolean(this._beadLockBtn))
         {
            ObjectUtils.disposeObject(this._beadLockBtn);
         }
         this._beadLockBtn = null;
         if(Boolean(this._beadBagList))
         {
            ObjectUtils.disposeObject(this._beadBagList);
         }
         this._beadBagList = null;
      }
      
      private function lockBead(event:MouseEvent) : void
      {
         this._beadLockBtn.dragStart(event.stageX,event.stageY);
      }
   }
}

