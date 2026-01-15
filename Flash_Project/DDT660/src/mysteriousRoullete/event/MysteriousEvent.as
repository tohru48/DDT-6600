package mysteriousRoullete.event
{
   import flash.events.Event;
   
   public class MysteriousEvent extends Event
   {
      
      public static const CHANG_VIEW:String = "changeView";
      
      public var viewType:int;
      
      public function MysteriousEvent(type:String, viewType:int, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         this.viewType = viewType;
         super(type,bubbles,cancelable);
      }
   }
}

