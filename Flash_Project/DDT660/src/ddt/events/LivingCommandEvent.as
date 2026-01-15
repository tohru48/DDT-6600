package ddt.events
{
   import flash.events.Event;
   
   public class LivingCommandEvent extends Event
   {
      
      public static const COMMAND:String = "livingCommand";
      
      private var _cmdType:String;
      
      private var _cmdObj:Object;
      
      public function LivingCommandEvent(cmdType:String, cmdObj:Object = null, eventType:String = "livingCommand", bubbles:Boolean = false, cancelable:Boolean = false)
      {
         super(eventType,bubbles,cancelable);
         this._cmdType = cmdType;
         this._cmdObj = cmdObj;
      }
      
      public function get commandType() : String
      {
         return this._cmdType;
      }
      
      public function get object() : Object
      {
         return this._cmdObj;
      }
   }
}

