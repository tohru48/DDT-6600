package ddt.events
{
   import flash.events.Event;
   
   public class PhyobjEvent extends Event
   {
      
      public static const CHANGE:String = "phyobjChange";
      
      public var action:String;
      
      public function PhyobjEvent(actionType:String, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         super(PhyobjEvent.CHANGE,bubbles,cancelable);
         this.action = actionType;
      }
   }
}

