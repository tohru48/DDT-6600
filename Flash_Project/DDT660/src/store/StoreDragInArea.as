package store
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
   import flash.display.Sprite;
   
   public class StoreDragInArea extends Sprite implements IAcceptDrag
   {
      
      public static const RECTWIDTH:int = 340;
      
      public static const RECTHEIGHT:int = 360;
      
      protected var _cells:Array;
      
      public function StoreDragInArea(cells:Array)
      {
         super();
         this._cells = cells;
         this.init();
      }
      
      private function init() : void
      {
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
         if(info.BagType == BagInfo.STOREBAG)
         {
            effect.action = DragEffect.NONE;
            DragManager.acceptDrag(this);
            return;
         }
         if(Boolean(info) && effect.action != DragEffect.SPLIT)
         {
            effect.action = DragEffect.NONE;
            if(info.getRemainDate() <= 0)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.view.fusion.AccessoryDragInArea.overdue"));
               DragManager.acceptDrag(this);
            }
            else
            {
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
                     MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.view.fusion.AccessoryDragInArea.type"));
                  }
                  DragManager.acceptDrag(this);
               }
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

