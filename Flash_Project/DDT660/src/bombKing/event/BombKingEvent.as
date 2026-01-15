package bombKing.event
{
   import flash.events.Event;
   import road7th.comm.PackageIn;
   
   public class BombKingEvent extends Event
   {
      
      public static const STATUE_INFO:String = "statueInfo";
      
      public static const UPDATE_MAIN_FRAME:String = "updateMainFrame";
      
      public static const BATTLE_LOG:String = "battleLog";
      
      public static const RANK_BY_PAGE:String = "rankByPage";
      
      public static const UPDATE_REQUEST:String = "updateRequest";
      
      public static const STARTLOADBATTLEXML:String = "startloadbattlexml";
      
      public static const SHOW_TEXT:String = "showText";
      
      public static const SHOW_TIP:String = "showTip";
      
      public static const SHOW_FRAME:String = "showFrame";
      
      private var _pkg:PackageIn;
      
      public function BombKingEvent(type:String, pkg:PackageIn = null)
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

