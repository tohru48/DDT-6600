package store.view.embed
{
   import bagAndInfo.cell.DragEffect;
   import baglocked.BaglockedManager;
   import com.pickgliss.ui.ComponentFactory;
   import ddt.data.BagInfo;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.events.StoreEmbedEvent;
   import ddt.manager.DragManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import store.StoreCell;
   
   public class EmbedItemCell extends StoreCell
   {
      
      public function EmbedItemCell($index:int)
      {
         var bg:Sprite = new Sprite();
         var bgBit:Bitmap = ComponentFactory.Instance.creatBitmap("asset.ddtstore.EquipCellBG");
         bg.addChild(bgBit);
         super(bg,$index);
         setContentSize(68,68);
      }
      
      override public function dragDrop(effect:DragEffect) : void
      {
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         var info:InventoryItemInfo = effect.data as InventoryItemInfo;
         if(Boolean(info) && effect.action != DragEffect.SPLIT)
         {
            effect.action = DragEffect.NONE;
            if(info.getRemainDate() < 0)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.view.fusion.AccessoryDragInArea.overdue"));
               return;
            }
            if(info.CanEquip)
            {
               dispatchEvent(new StoreEmbedEvent(StoreEmbedEvent.ItemChang));
               SocketManager.Instance.out.sendMoveGoods(info.BagType,info.Place,BagInfo.STOREBAG,index,1);
               effect.action = DragEffect.NONE;
               DragManager.acceptDrag(this);
            }
         }
      }
      
      override public function dispose() : void
      {
         super.dispose();
      }
   }
}

