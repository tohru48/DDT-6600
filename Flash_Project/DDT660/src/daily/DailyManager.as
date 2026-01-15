package daily
{
   import ddt.data.analyze.DaylyGiveAnalyzer;
   
   public class DailyManager
   {
      
      public static var list:Array;
      
      private static var _instance:DailyManager;
      
      public function DailyManager()
      {
         super();
      }
      
      public static function setupDailyInfo(analyzer:DaylyGiveAnalyzer) : void
      {
         list = analyzer.list;
      }
      
      public static function get Instance() : DailyManager
      {
         if(_instance == null)
         {
            _instance = new DailyManager();
         }
         return _instance;
      }
      
      public function show() : void
      {
      }
   }
}

