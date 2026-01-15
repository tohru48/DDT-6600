package game.view.prop
{
   import com.pickgliss.ui.core.Disposeable;
   import ddt.events.LivingEvent;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.Sprite;
   import game.model.Living;
   
   public class UsedPropBar extends Sprite implements Disposeable
   {
      
      private var _container:DisplayObjectContainer;
      
      private var _living:Living;
      
      private var _cells:Vector.<DisplayObject>;
      
      public function UsedPropBar()
      {
         super();
      }
      
      private function clearCells() : void
      {
      }
      
      public function setInfo(living:Living) : void
      {
         this.clearCells();
         var lv:Living = this._living;
         this._living = this._living;
         this.addEventToLiving(this._living);
         if(lv != null)
         {
            this.removeEventFromLiving(lv);
         }
      }
      
      private function addEventToLiving(living:Living) : void
      {
         living.addEventListener(LivingEvent.USING_ITEM,this.__usingItem);
      }
      
      private function __usingItem(evt:LivingEvent) : void
      {
      }
      
      private function removeEventFromLiving(living:Living) : void
      {
         living.removeEventListener(LivingEvent.USING_ITEM,this.__usingItem);
      }
      
      public function dispose() : void
      {
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

