package store.view.Compose
{
   import bagAndInfo.cell.DragEffect;
   import baglocked.BaglockedManager;
   import ddt.data.BagInfo;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.manager.DragManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import store.StoneCell;
   
   public class ComposeStoneCell extends StoneCell
   {
      
      public function ComposeStoneCell(stoneType:Array, $index:int)
      {
         super(stoneType,$index);
      }
      
      override public function dragDrop(effect:DragEffect) : void
      {
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         var sourceInfo:InventoryItemInfo = effect.data as InventoryItemInfo;
         if(sourceInfo.BagType == BagInfo.STOREBAG && info != null)
         {
            return;
         }
         if(Boolean(sourceInfo) && effect.action != DragEffect.SPLIT)
         {
            effect.action = DragEffect.NONE;
            if(sourceInfo.CategoryID == 11 && _types.indexOf(sourceInfo.Property1) > -1 && sourceInfo.getRemainDate() > 0)
            {
               SocketManager.Instance.out.sendMoveGoods(sourceInfo.BagType,sourceInfo.Place,BagInfo.STOREBAG,index,sourceInfo.Count,true);
               effect.action = DragEffect.NONE;
               DragManager.acceptDrag(this);
            }
         }
      }
   }
}

