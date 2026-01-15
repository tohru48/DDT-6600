package room.transnational
{
   import flash.events.Event;
   
   public class TransnationalEvent extends Event
   {
      
      public static var SHOPENABLE:String = "shopenable";
      
      public var _shopenable:Boolean;
      
      public function TransnationalEvent(type:String, $shopenable:Boolean, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
         this._shopenable = $shopenable;
      }
   }
}

