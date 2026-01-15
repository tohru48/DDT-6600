package store.forge.wishBead
{
   import bagAndInfo.cell.DragEffect;
   import baglocked.BaglockedManager;
   import ddt.data.BagInfo;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.interfaces.IAcceptDrag;
   import ddt.manager.DragManager;
   import ddt.manager.PlayerManager;
   import flash.display.Sprite;
   
   public class WishBeadLeftDragSprite extends Sprite implements IAcceptDrag
   {
      
      public function WishBeadLeftDragSprite()
      {
         super();
      }
      
      public function dragDrop(effect:DragEffect) : void
      {
         var tmpStr:String = null;
         DragManager.acceptDrag(this,DragEffect.NONE);
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         var tmp:InventoryItemInfo = effect.data as InventoryItemInfo;
         if(tmp.BagType == BagInfo.EQUIPBAG)
         {
            tmpStr = WishBeadManager.EQUIP_MOVE;
         }
         else
         {
            tmpStr = WishBeadManager.ITEM_MOVE;
         }
         var event:WishBeadEvent = new WishBeadEvent(tmpStr);
         event.info = tmp;
         event.moveType = 1;
         WishBeadManager.instance.dispatchEvent(event);
      }
   }
}

