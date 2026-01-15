package game.gametrainer.view
{
   import bagAndInfo.cell.DragEffect;
   import bagAndInfo.cell.LinkedBagCell;
   import com.pickgliss.events.InteractiveEvent;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class DropCell extends LinkedBagCell
   {
      
      public function DropCell()
      {
         super(null);
         this.allowDrag = false;
         removeEventListener(InteractiveEvent.CLICK,__doubleClickHandler);
      }
      
      override public function dragDrop(effect:DragEffect) : void
      {
      }
      
      override protected function onMouseOver(evt:MouseEvent) : void
      {
         dispatchEvent(new Event(Event.CHANGE));
         super.onMouseOver(evt);
      }
      
      override protected function onMouseOut(evt:MouseEvent) : void
      {
         dispatchEvent(new Event(Event.COMPLETE));
         super.onMouseOut(evt);
      }
      
      override protected function onMouseClick(evt:MouseEvent) : void
      {
      }
      
      override protected function createContentComplete() : void
      {
         super.createContentComplete();
         _pic.width = 45;
         _pic.height = 46;
      }
   }
}

