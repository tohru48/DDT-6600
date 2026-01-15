package store.view.storeBag
{
   import bagAndInfo.cell.DragEffect;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.image.Image;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.interfaces.IDragable;
   import ddt.manager.DragManager;
   import ddt.manager.PlayerManager;
   import flash.display.Sprite;
   
   public class StoreBagbgbmp extends Sprite implements IBagDrag
   {
      
      private var bg:Image;
      
      public function StoreBagbgbmp()
      {
         super();
         this.bg = ComponentFactory.Instance.creatComponentByStylename("ddtstore.StoreBagViewBg");
         addChild(this.bg);
      }
      
      public function dragDrop(effect:DragEffect) : void
      {
         var info:InventoryItemInfo = null;
         if(PlayerManager.Instance.Self.bagLocked)
         {
            return;
         }
         if(effect.data is InventoryItemInfo)
         {
            info = effect.data as InventoryItemInfo;
            effect.action = DragEffect.NONE;
            DragManager.acceptDrag(this);
         }
      }
      
      public function dragStop(effect:DragEffect) : void
      {
      }
      
      public function getSource() : IDragable
      {
         return this;
      }
      
      public function dispose() : void
      {
         if(Boolean(this.bg))
         {
            ObjectUtils.disposeObject(this.bg);
         }
         this.bg = null;
         ObjectUtils.disposeAllChildren(this);
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

