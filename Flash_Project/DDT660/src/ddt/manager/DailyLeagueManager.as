package ddt.manager
{
   import com.pickgliss.loader.DataAnalyzer;
   import ddt.data.DailyLeagueAwardInfo;
   import ddt.data.DailyLeagueLevelInfo;
   import ddt.data.analyze.DailyLeagueAwardAnalyzer;
   import ddt.data.analyze.DailyLeagueLevelAnalyzer;
   import flash.events.EventDispatcher;
   
   public class DailyLeagueManager extends EventDispatcher
   {
      
      private static var _instance:DailyLeagueManager;
      
      private static const PLAYER_LEVEL:Array = [[20,29],[30,39],[40,49]];
      
      private var _leagueLevelRank:Array;
      
      private var _leagueAwardList:Array;
      
      private var _lv1:int;
      
      private var _lv2:int;
      
      private var _scoreLv:int;
      
      public function DailyLeagueManager()
      {
         super();
      }
      
      public static function get Instance() : DailyLeagueManager
      {
         if(_instance == null)
         {
            _instance = new DailyLeagueManager();
         }
         return _instance;
      }
      
      public function setup(analyzer:DataAnalyzer) : void
      {
         if(analyzer is DailyLeagueAwardAnalyzer)
         {
            this._leagueAwardList = DailyLeagueAwardAnalyzer(analyzer).list;
         }
         else if(analyzer is DailyLeagueLevelAnalyzer)
         {
            this._leagueLevelRank = DailyLeagueLevelAnalyzer(analyzer).list;
         }
      }
      
      public function getLeagueLevelByScore(score:Number, leagueFirst:Boolean = false) : DailyLeagueLevelInfo
      {
         var leagueLevel:DailyLeagueLevelInfo = new DailyLeagueLevelInfo();
         if(leagueFirst)
         {
            return this._leagueLevelRank[0];
         }
         for(var i:int = 0; i < this._leagueLevelRank.length; i++)
         {
            if(this._leagueLevelRank[i].Score > -1 && score >= this._leagueLevelRank[i].Score)
            {
               leagueLevel = this._leagueLevelRank[i];
            }
         }
         return leagueLevel;
      }
      
      public function filterLeagueAwardList(playerLv:int, scoreLv:int) : Array
      {
         this._lv1 = PLAYER_LEVEL[playerLv][0];
         this._lv2 = PLAYER_LEVEL[playerLv][1];
         this._scoreLv = playerLv * 4 + (scoreLv + 1);
         return this._leagueAwardList.filter(this.filterLeagueAwardListCallback);
      }
      
      private function filterLeagueAwardListCallback(item:DailyLeagueAwardInfo, index:int, array:Array) : Boolean
      {
         if(item.Level >= this._lv1 && item.Level <= this._lv2 && item.Class == this._scoreLv)
         {
            return true;
         }
         return false;
      }
   }
}

