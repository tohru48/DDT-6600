package store.view.strength
{
   import bagAndInfo.cell.DragEffect;
   import baglocked.BaglockedManager;
   import ddt.data.StoneType;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.manager.DragManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import store.StoreDragInArea;
   
   public class StrengthDragInArea extends StoreDragInArea
   {
      
      private var _hasStone:Boolean = false;
      
      private var _hasItem:Boolean = false;
      
      private var _stonePlace:int = -1;
      
      private var _effect:DragEffect;
      
      public function StrengthDragInArea(cells:Array)
      {
         super(cells);
      }
      
      override public function dragDrop(effect:DragEffect) : void
      {
         var i:int = 0;
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         var info:InventoryItemInfo = effect.data as InventoryItemInfo;
         this._effect = effect;
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
               for(i = 0; i < 5; i++)
               {
                  if(i == 0 || i == 3 || i == 4)
                  {
                     if(_cells[i].itemInfo != null)
                     {
                        this._hasStone = true;
                        this._stonePlace = i;
                        break;
                     }
                  }
               }
               if(_cells[2].itemInfo != null)
               {
                  this._hasItem = true;
               }
               if(info.CanEquip)
               {
                  if(!this._hasStone)
                  {
                     _cells[2].dragDrop(effect);
                  }
                  else if(info.RefineryLevel > 0 && _cells[this._stonePlace].itemInfo.Property1 == "35" || info.RefineryLevel == 0 && _cells[this._stonePlace].itemInfo.Property1 == StoneType.STRENGTH)
                  {
                     _cells[2].dragDrop(effect);
                     this.reset();
                  }
                  else
                  {
                     MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.view.strength.unpare"));
                  }
               }
               else if(_cells[2].itemInfo.RefineryLevel > 0 && info.Property1 == "35" || _cells[2].itemInfo.RefineryLevel == 0 && info.Property1 == StoneType.STRENGTH)
               {
                  if(!this._hasStone)
                  {
                     this.findCellAndDrop();
                     this.reset();
                  }
                  else if(_cells[this._stonePlace].itemInfo.Property1 == info.Property1)
                  {
                     this.findCellAndDrop();
                     this.reset();
                  }
                  else
                  {
                     MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.view.strength.typeUnpare"));
                  }
               }
               else
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.view.strength.unpare"));
               }
            }
         }
      }
      
      private function findCellAndDrop() : void
      {
         for(var i:int = 0; i < 5; i++)
         {
            if(i == 0 || i == 3 || i == 4)
            {
               if(_cells[i].itemInfo == null)
               {
                  _cells[i].dragDrop(this._effect);
                  this.reset();
                  return;
               }
            }
         }
         _cells[0].dragDrop(this._effect);
         this.reset();
      }
      
      private function reset() : void
      {
         this._hasStone = false;
         this._hasItem = false;
         this._stonePlace = -1;
         this._effect = null;
      }
      
      override public function dispose() : void
      {
         this.reset();
         super.dispose();
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

