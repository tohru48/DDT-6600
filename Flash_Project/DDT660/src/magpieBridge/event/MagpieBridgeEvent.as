package magpieBridge.event
{
   import flash.events.Event;
   import road7th.comm.PackageIn;
   
   public class MagpieBridgeEvent extends Event
   {
      
      public static const ENTER_MAGPIEBRIDGE:String = "enterMagpieBridge";
      
      public static const ROLL_DICE:String = "rollDice";
      
      public static const BUY_COUNT:String = "buyCount";
      
      public static const REFRESH_VIEW:String = "refreshView";
      
      public static const EXIT_VIEW:String = "exitView";
      
      public static const GET_AWARD:String = "getAward";
      
      public static const UPDATE_PLAYERPOS:String = "updatePlayerPos";
      
      public static const CLOSE_ICON:String = "closeIcon";
      
      public static const MAGPIE_NUM:String = "magpieNum";
      
      public static const WALK_OVER:String = "walkOver";
      
      public static const OPEN:String = "open";
      
      public static const PLAYMEETANINMATION:String = "playMeetAnimation";
      
      public static const SETBTNENABLE:String = "setBtnEnable";
      
      public static const SET_COUNT:String = "setCount";
      
      private var _pkg:PackageIn;
      
      public function MagpieBridgeEvent(type:String, pkg:PackageIn = null)
      {
         super(type,bubbles,cancelable);
         this._pkg = pkg;
      }
      
      public function get pkg() : PackageIn
      {
         return this._pkg;
      }
   }
}

