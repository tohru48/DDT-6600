package enchant.view
{
   import bagAndInfo.cell.DragEffect;
   import baglocked.BaglockedManager;
   import ddt.data.BagInfo;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.interfaces.IAcceptDrag;
   import ddt.manager.DragManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import enchant.EnchantManager;
   import flash.display.Sprite;
   
   public class EnchantLeftDragSprite extends Sprite implements IAcceptDrag
   {
      
      public var equipCellActionState:Boolean;
      
      public function EnchantLeftDragSprite()
      {
         super();
      }
      
      public function dragDrop(effect:DragEffect) : void
      {
         DragManager.acceptDrag(this,DragEffect.NONE);
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         var tmp:InventoryItemInfo = effect.data as InventoryItemInfo;
         if(tmp.MagicLevel >= EnchantManager.instance.infoVec.length)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("enchant.cannotUp"));
            return;
         }
         if(tmp.BagType == BagInfo.EQUIPBAG)
         {
            this.equipCellActionState = true;
            SocketManager.Instance.out.sendMoveGoods(tmp.BagType,tmp.Place,BagInfo.STOREBAG,1,1);
         }
         else if(tmp.BagType == BagInfo.PROPBAG)
         {
            SocketManager.Instance.out.sendMoveGoods(tmp.BagType,tmp.Place,BagInfo.STOREBAG,0,tmp.Count,true);
         }
      }
   }
}

