package ddt.manager
{
   import consortion.data.BadgeInfo;
   import ddt.data.analyze.BadgeInfoAnalyzer;
   import flash.utils.Dictionary;
   
   public class BadgeInfoManager
   {
      
      private static var _instance:BadgeInfoManager;
      
      private var _badgeList:Dictionary;
      
      public function BadgeInfoManager()
      {
         super();
         this._badgeList = new Dictionary();
      }
      
      public static function get instance() : BadgeInfoManager
      {
         if(_instance == null)
         {
            _instance = new BadgeInfoManager();
         }
         return _instance;
      }
      
      public function setup(analyzer:BadgeInfoAnalyzer) : void
      {
         this._badgeList = analyzer.list;
      }
      
      public function getBadgeInfoByID(id:int) : BadgeInfo
      {
         return this._badgeList[id];
      }
      
      public function getBadgeInfoByLevel(min:int, max:int) : Array
      {
         var info:BadgeInfo = null;
         var result:Array = [];
         for each(info in this._badgeList)
         {
            if(info.LimitLevel >= min && info.LimitLevel <= max)
            {
               result.push(info);
            }
         }
         return result;
      }
   }
}

