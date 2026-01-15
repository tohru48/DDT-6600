package latentEnergy
{
   import bagAndInfo.cell.DragEffect;
   import ddt.data.BagInfo;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.interfaces.IAcceptDrag;
   import ddt.manager.DragManager;
   import flash.display.Sprite;
   
   public class LatentEnergyRightDragSprite extends Sprite implements IAcceptDrag
   {
      
      public function LatentEnergyRightDragSprite()
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
            tmpStr = LatentEnergyManager.EQUIP_MOVE2;
         }
         else
         {
            tmpStr = LatentEnergyManager.ITEM_MOVE2;
         }
         var event:LatentEnergyEvent = new LatentEnergyEvent(tmpStr);
         event.info = tmp;
         event.moveType = 2;
         LatentEnergyManager.instance.dispatchEvent(event);
      }
   }
}

