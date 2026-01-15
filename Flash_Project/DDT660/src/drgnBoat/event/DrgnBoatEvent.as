package drgnBoat.event
{
   import flash.events.Event;
   
   public class DrgnBoatEvent extends Event
   {
      
      public var data:Object;
      
      public function DrgnBoatEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
      }
   }
}

