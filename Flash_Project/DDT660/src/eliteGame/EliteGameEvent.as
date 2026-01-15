package eliteGame
{
   import flash.events.Event;
   
   public class EliteGameEvent extends Event
   {
      
      public static const TOP_SIXTEEN_READY:String = "topSixteenDataReady";
      
      public static const SELF_RANK_SCORE_READY:String = "selfRankScoreReady";
      
      public static const ELITEGAME_STATE_CHANGE:String = "eliteGameStateChange";
      
      public static const SCORERANK_DATAREADY:String = "scoreRankDataOK";
      
      public static const AWARD_DATA_READY:String = "award_data_Ready";
      
      public static const READY_TIME_OVER:String = "readyTimeOver";
      
      public function EliteGameEvent(type:String)
      {
         super(type);
      }
   }
}

