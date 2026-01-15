package dragonBoat
{
   import flash.events.Event;
   
   public class DragonBoatEvent extends Event
   {
      
      public var tag:int;
      
      public var data:Object;
      
      public function DragonBoatEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
      }
   }
}

