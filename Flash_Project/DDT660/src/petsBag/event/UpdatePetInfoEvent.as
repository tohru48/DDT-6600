package petsBag.event
{
   import flash.events.Event;
   
   public class UpdatePetInfoEvent extends Event
   {
      
      public static const UPDATE:String = "update";
      
      public var data:Object;
      
      public function UpdatePetInfoEvent(type:String, obj:Object = null, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         this.data = obj;
         super(type,bubbles,cancelable);
      }
   }
}

