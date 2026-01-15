package store.view.fusion
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
   
   public class AccessoryDragInArea extends Sprite implements IAcceptDrag
   {
      
      private var _cells:Array;
      
      public function AccessoryDragInArea(cells:Array)
      {
         super();
         this._cells = cells;
         graphics.beginFill(255,0);
         graphics.drawRect(-40,-40,280,230);
         graphics.endFill();
      }
      
      public function dragDrop(effect:DragEffect) : void
      {
         var hasEmpty:Boolean = false;
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
               hasEmpty = false;
               hasCell = false;
               for(i = 0; i < this._cells.length; i++)
               {
                  if(this._cells[i].info == null)
                  {
                     hasEmpty = true;
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
                     if(hasEmpty)
                     {
                        MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.view.fusion.AccessoryDragInArea.type"));
                     }
                     else
                     {
                        MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.view.fusion.AccessoryDragInArea.more"));
                     }
                  }
                  DragManager.acceptDrag(this);
               }
            }
         }
      }
   }
}

