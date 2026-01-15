package store.view.transfer
{
   import bagAndInfo.cell.DragEffect;
   import baglocked.BaglockedManager;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.interfaces.IAcceptDrag;
   import ddt.manager.DragManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import flash.display.Sprite;
   
   public class TransferDragInArea extends Sprite implements IAcceptDrag
   {
      
      public static const RECTWIDTH:int = 345;
      
      public static const RECTHEIGHT:int = 360;
      
      private var _cells:Vector.<TransferItemCell>;
      
      public function TransferDragInArea(cells:Vector.<TransferItemCell>)
      {
         super();
         this._cells = cells;
         graphics.beginFill(255,0);
         graphics.drawRect(0,0,RECTWIDTH,RECTHEIGHT);
         graphics.endFill();
      }
      
      public function dragDrop(effect:DragEffect) : void
      {
         var hasCell:Boolean = false;
         var i:int = 0;
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         var info:InventoryItemInfo = effect.data as InventoryItemInfo;
         if(Boolean(info) && effect.action != DragEffect.SPLIT)
         {
            effect.action = DragEffect.NONE;
            hasCell = false;
            for(i = 0; i < this._cells.length; i++)
            {
               if(this._cells[i].info == null)
               {
                  this._cells[i].dragDrop(effect);
                  if(Boolean(effect.target))
                  {
                     break;
                  }
               }
               else if(this._cells[i].info == info)
               {
                  hasCell = true;
               }
            }
            if(effect.target == null)
            {
               if(!hasCell)
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.view.transfer.info"));
               }
               DragManager.acceptDrag(this);
            }
         }
      }
      
      public function dispose() : void
      {
         this._cells = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

