package store.forge.wishBead
{
   import bagAndInfo.cell.BagCell;
   import com.pickgliss.events.InteractiveEvent;
   import com.pickgliss.utils.DoubleClickManager;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.manager.SoundManager;
   import flash.display.DisplayObject;
   
   public class WishBeadEquipCell extends BagCell
   {
      
      public function WishBeadEquipCell(index:int, info:ItemTemplateInfo = null, showLoading:Boolean = true, bg:DisplayObject = null, mouseOverEffBoolean:Boolean = true)
      {
         super(index,info,showLoading,bg,mouseOverEffBoolean);
      }
      
      override protected function initEvent() : void
      {
         super.initEvent();
         addEventListener(InteractiveEvent.CLICK,this.__clickHandler);
         addEventListener(InteractiveEvent.DOUBLE_CLICK,this.__doubleClickHandler);
         DoubleClickManager.Instance.enableDoubleClick(this);
         WishBeadManager.instance.addEventListener(WishBeadManager.EQUIP_MOVE,this.equipMoveHandler);
         WishBeadManager.instance.addEventListener(WishBeadManager.EQUIP_MOVE2,this.equipMoveHandler2);
      }
      
      private function equipMoveHandler(event:WishBeadEvent) : void
      {
         var event2:WishBeadEvent = null;
         if(info == event.info)
         {
            return;
         }
         if(Boolean(info))
         {
            event2 = new WishBeadEvent(WishBeadManager.EQUIP_MOVE2);
            event2.info = info as InventoryItemInfo;
            event2.moveType = 3;
            WishBeadManager.instance.dispatchEvent(event2);
         }
         info = event.info;
      }
      
      private function equipMoveHandler2(event:WishBeadEvent) : void
      {
         if(info != event.info || event.moveType != 2)
         {
            return;
         }
         info = null;
      }
      
      protected function __doubleClickHandler(evt:InteractiveEvent) : void
      {
         if(!info)
         {
            return;
         }
         SoundManager.instance.play("008");
         var event:WishBeadEvent = new WishBeadEvent(WishBeadManager.EQUIP_MOVE2);
         event.info = info as InventoryItemInfo;
         event.moveType = 2;
         WishBeadManager.instance.dispatchEvent(event);
      }
      
      override protected function removeEvent() : void
      {
         super.removeEvent();
         removeEventListener(InteractiveEvent.CLICK,this.__clickHandler);
         removeEventListener(InteractiveEvent.DOUBLE_CLICK,this.__doubleClickHandler);
         DoubleClickManager.Instance.disableDoubleClick(this);
         WishBeadManager.instance.removeEventListener(WishBeadManager.EQUIP_MOVE,this.equipMoveHandler);
         WishBeadManager.instance.removeEventListener(WishBeadManager.EQUIP_MOVE2,this.equipMoveHandler2);
      }
      
      protected function __clickHandler(evt:InteractiveEvent) : void
      {
         SoundManager.instance.play("008");
         dragStart();
      }
      
      public function clearInfo() : void
      {
         var event:WishBeadEvent = null;
         if(Boolean(info))
         {
            event = new WishBeadEvent(WishBeadManager.EQUIP_MOVE2);
            event.info = info as InventoryItemInfo;
            event.moveType = 2;
            WishBeadManager.instance.dispatchEvent(event);
         }
      }
   }
}

