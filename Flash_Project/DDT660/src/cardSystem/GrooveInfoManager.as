package cardSystem
{
   import cardSystem.data.CardGrooveInfo;
   import ddt.data.analyze.CardGrooveEventAnalyzer;
   import flash.utils.Dictionary;
   
   public class GrooveInfoManager
   {
      
      private static var _instance:GrooveInfoManager;
      
      private var _grooveList:Dictionary;
      
      public function GrooveInfoManager()
      {
         super();
         this._grooveList = new Dictionary();
      }
      
      public static function get instance() : GrooveInfoManager
      {
         if(_instance == null)
         {
            _instance = new GrooveInfoManager();
         }
         return _instance;
      }
      
      public function setup(analyzer:CardGrooveEventAnalyzer) : void
      {
         this._grooveList = analyzer.list;
      }
      
      public function getInfoByLevel(key:String, type:String) : CardGrooveInfo
      {
         return this._grooveList[key + "," + type];
      }
   }
}

