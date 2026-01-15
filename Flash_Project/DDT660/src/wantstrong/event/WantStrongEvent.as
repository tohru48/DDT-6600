package wantstrong.event
{
   import flash.events.Event;
   
   public class WantStrongEvent extends Event
   {
      
      public static const ALREADYFINDBACK:String = "alreadyFindBack";
      
      public static const ALREADYUPDATETIME:String = "alreadyUpdateTime";
      
      public function WantStrongEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
      }
   }
}

