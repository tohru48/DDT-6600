package store.forge.wishBead
{
   import bagAndInfo.cell.DragEffect;
   import ddt.data.BagInfo;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.interfaces.IAcceptDrag;
   import ddt.manager.DragManager;
   import flash.display.Sprite;
   
   public class WishBeadRightDragSprite extends Sprite implements IAcceptDrag
   {
      
      public function WishBeadRightDragSprite()
      {
         super();
      }
      
      public function dragDrop(effect:DragEffect) : void
      {
         var tmpStr:String = null;
         DragManager.acceptDrag(this,DragEffect.NONE);
         var tmp:InventoryItemInfo = effect.data as InventoryItemInfo;
         if(tmp.BagType == BagInfo.EQUIPBAG)
         {
            tmpStr = WishBeadManager.EQUIP_MOVE2;
         }
         else
         {
            tmpStr = WishBeadManager.ITEM_MOVE2;
         }
         var event:WishBeadEvent = new WishBeadEvent(tmpStr);
         event.info = tmp;
         event.moveType = 2;
         WishBeadManager.instance.dispatchEvent(event);
      }
   }
}

