package overSeasCommunity.vietnam.openapi
{
   import flash.events.Event;
   
   public class ZMRequestEvent extends Event
   {
      
      public static const RESPONSE:String = "response";
      
      private var _result:*;
      
      public function ZMRequestEvent(type:String, result:*)
      {
         super(type);
         this._result = result;
      }
      
      public function get result() : *
      {
         return this._result;
      }
   }
}

