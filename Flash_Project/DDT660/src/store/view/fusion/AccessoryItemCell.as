package store.view.fusion
{
   import bagAndInfo.cell.DragEffect;
   import com.pickgliss.ui.ComponentFactory;
   import ddt.data.BagInfo;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.manager.DragManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import store.StoreCell;
   
   public class AccessoryItemCell extends StoreCell
   {
      
      public function AccessoryItemCell($index:int)
      {
         var bg:Sprite = new Sprite();
         var bgBit:Bitmap = ComponentFactory.Instance.creatBitmap("asset.ddtstore.GoodPanelSmall");
         bg.addChild(bgBit);
         super(bg,$index);
      }
      
      override public function dragDrop(effect:DragEffect) : void
      {
         if(PlayerManager.Instance.Self.bagLocked)
         {
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
            if(sourceInfo.getRemainDate() <= 0)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.view.fusion.AccessoryItemCell.overdue"));
            }
            else if(sourceInfo.FusionType == 0)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.view.fusion.AccessoryItemCell.fusion"));
            }
            else
            {
               SocketManager.Instance.out.sendMoveGoods(sourceInfo.BagType,sourceInfo.Place,BagInfo.STOREBAG,index,1);
               effect.action = DragEffect.NONE;
               DragManager.acceptDrag(this);
            }
         }
      }
   }
}

