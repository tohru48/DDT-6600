package activeEvents
{
   import flash.events.Event;
   
   public class ActiveConductEvent extends Event
   {
      
      public static const ONLINK:String = "on_link";
      
      public var _data:Object;
      
      public function ActiveConductEvent(type:String, $data:Object, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         this._data = $data;
         super(type,bubbles,cancelable);
      }
   }
}

