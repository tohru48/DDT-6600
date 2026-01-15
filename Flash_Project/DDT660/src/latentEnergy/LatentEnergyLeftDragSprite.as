package latentEnergy
{
   import bagAndInfo.cell.DragEffect;
   import baglocked.BaglockedManager;
   import ddt.data.BagInfo;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.interfaces.IAcceptDrag;
   import ddt.manager.DragManager;
   import ddt.manager.PlayerManager;
   import flash.display.Sprite;
   
   public class LatentEnergyLeftDragSprite extends Sprite implements IAcceptDrag
   {
      
      public function LatentEnergyLeftDragSprite()
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
            tmpStr = LatentEnergyManager.EQUIP_MOVE;
         }
         else
         {
            tmpStr = LatentEnergyManager.ITEM_MOVE;
         }
         var event:LatentEnergyEvent = new LatentEnergyEvent(tmpStr);
         event.info = tmp;
         event.moveType = 1;
         LatentEnergyManager.instance.dispatchEvent(event);
      }
   }
}

