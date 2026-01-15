package bagAndInfo.cell
{
   import com.pickgliss.events.InteractiveEvent;
   import com.pickgliss.utils.DoubleClickManager;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.events.CellEvent;
   import ddt.interfaces.IDragable;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import flash.display.Sprite;
   import flash.events.Event;
   
   public class LinkedBagCell extends BagCell
   {
      
      protected var _bagCell:BagCell;
      
      public var DoubleClickEnabled:Boolean = true;
      
      public function LinkedBagCell(bg:Sprite)
      {
         super(0,null,true,bg);
      }
      
      override protected function init() : void
      {
         addEventListener(InteractiveEvent.CLICK,this.__clickHandler);
         addEventListener(InteractiveEvent.DOUBLE_CLICK,this.__doubleClickHandler);
         DoubleClickManager.Instance.enableDoubleClick(this);
         super.init();
      }
      
      private function __clickHandler(evt:InteractiveEvent) : void
      {
         if(_info && !locked && stage && allowDrag)
         {
            SoundManager.instance.play("008");
         }
         dragStart();
      }
      
      public function get bagCell() : BagCell
      {
         return this._bagCell;
      }
      
      public function set bagCell(value:BagCell) : void
      {
         if(Boolean(this._bagCell))
         {
            this._bagCell.removeEventListener(Event.CHANGE,this.__changed);
            if(Boolean(this._bagCell.itemInfo) && this._bagCell.itemInfo.BagType == 0)
            {
               PlayerManager.Instance.Self.Bag.unlockItem(this._bagCell.itemInfo);
            }
            else if(Boolean(this._bagCell.itemInfo))
            {
               PlayerManager.Instance.Self.PropBag.unlockItem(this._bagCell.itemInfo);
            }
            this._bagCell.locked = false;
            info = null;
         }
         this._bagCell = value;
         if(Boolean(this._bagCell))
         {
            this._bagCell.addEventListener(Event.CHANGE,this.__changed);
            this.info = this._bagCell.info;
         }
      }
      
      override public function get place() : int
      {
         if(Boolean(this._bagCell))
         {
            return this._bagCell.itemInfo.Place;
         }
         return -1;
      }
      
      protected function __doubleClickHandler(evt:InteractiveEvent) : void
      {
         if(!this.DoubleClickEnabled)
         {
            return;
         }
         if((evt.currentTarget as BagCell).info != null)
         {
            if((evt.currentTarget as BagCell).info != null)
            {
               dispatchEvent(new CellEvent(CellEvent.DOUBLE_CLICK,this,true));
            }
         }
      }
      
      override public function dragStop(effect:DragEffect) : void
      {
         if(PlayerManager.Instance.Self.bagLocked)
         {
            return;
         }
         if(Boolean(this._bagCell))
         {
            if(effect.action != DragEffect.NONE || Boolean(effect.target))
            {
               this._bagCell.dragStop(effect);
               this._bagCell.removeEventListener(Event.CHANGE,this.__changed);
               this._bagCell = null;
               info = null;
            }
            else
            {
               this.locked = false;
            }
         }
      }
      
      private function __changed(event:Event) : void
      {
         this.info = this._bagCell == null ? null : this._bagCell.info;
         if(this._bagCell == null || this._bagCell.info == null)
         {
            this.clearLinkCell();
         }
         else
         {
            this._bagCell.locked = true;
         }
      }
      
      override public function getSource() : IDragable
      {
         return this._bagCell;
      }
      
      public function clearLinkCell() : void
      {
         if(Boolean(this._bagCell))
         {
            this._bagCell.removeEventListener(Event.CHANGE,this.__changed);
            if(Boolean(this._bagCell.itemInfo) && this._bagCell.itemInfo.lock)
            {
               if(Boolean(this._bagCell.itemInfo) && this._bagCell.itemInfo.BagType == 0)
               {
                  PlayerManager.Instance.Self.Bag.unlockItem(this._bagCell.itemInfo);
               }
               else
               {
                  PlayerManager.Instance.Self.PropBag.unlockItem(this._bagCell.itemInfo);
               }
            }
            this._bagCell.locked = false;
         }
         this.bagCell = null;
      }
      
      override public function set locked(b:Boolean) : void
      {
      }
      
      override public function dispose() : void
      {
         removeEventListener(InteractiveEvent.CLICK,this.__clickHandler);
         removeEventListener(InteractiveEvent.DOUBLE_CLICK,this.__doubleClickHandler);
         DoubleClickManager.Instance.disableDoubleClick(this);
         this.clearLinkCell();
         if(info is InventoryItemInfo)
         {
            info["lock"] = false;
         }
         super.dispose();
         this.bagCell = null;
      }
   }
}

