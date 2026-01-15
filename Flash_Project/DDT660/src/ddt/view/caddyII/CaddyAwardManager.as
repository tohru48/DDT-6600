package ddt.view.caddyII
{
   public class CaddyAwardManager
   {
      
      private static var _instance:CaddyAwardManager;
      
      public var _awards:Vector.<CaddyAwardInfo>;
      
      public var _silverAwards:Vector.<CaddyAwardInfo>;
      
      public var _goldAwards:Vector.<CaddyAwardInfo>;
      
      public function CaddyAwardManager()
      {
         super();
      }
      
      public static function get Instance() : CaddyAwardManager
      {
         if(!_instance)
         {
            _instance = new CaddyAwardManager();
         }
         return _instance;
      }
      
      public function completeHander(analyzer:CaddyAwardDataAnalyzer) : void
      {
         this._awards = analyzer._awards;
         this._silverAwards = analyzer._silverAwards;
         this._goldAwards = analyzer._goldAwards;
      }
   }
}

