package store.newFusion
{
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import store.newFusion.data.FusionNewDataAnalyzer;
   
   public class FusionNewManager extends EventDispatcher
   {
      
      private static var _instance:FusionNewManager;
      
      public var isInContinuousFusion:Boolean;
      
      private var _dataList:Object;
      
      public function FusionNewManager(target:IEventDispatcher = null)
      {
         super(target);
      }
      
      public static function get instance() : FusionNewManager
      {
         if(_instance == null)
         {
            _instance = new FusionNewManager();
         }
         return _instance;
      }
      
      public function setup(analyzer:FusionNewDataAnalyzer) : void
      {
         this._dataList = analyzer.data;
      }
      
      public function getDataListByType(type:int) : Array
      {
         if(Boolean(this._dataList))
         {
            return this._dataList[type] as Array;
         }
         return [];
      }
   }
}

