package ddt.manager
{
   import beadSystem.model.BeadInfo;
   import ddt.data.analyze.BeadAnalyzer;
   import flash.events.EventDispatcher;
   import road7th.data.DictionaryData;
   
   public class BeadTemplateManager extends EventDispatcher
   {
      
      private static var _instance:BeadTemplateManager;
      
      public var _beadList:DictionaryData;
      
      public function BeadTemplateManager()
      {
         super();
         this._beadList = new DictionaryData();
      }
      
      public static function get Instance() : BeadTemplateManager
      {
         if(_instance == null)
         {
            _instance = new BeadTemplateManager();
         }
         return _instance;
      }
      
      public function setup(pAnalyzer:BeadAnalyzer) : void
      {
         this._beadList = pAnalyzer.list;
      }
      
      public function GetBeadInfobyID(pBeadTemplateID:int) : BeadInfo
      {
         return this._beadList[pBeadTemplateID];
      }
      
      public function GetBeadTemplateIDByLv(pLv:int, pIDbefore:int) : int
      {
         var vResultID:int = 0;
         var o:BeadInfo = null;
         var info:BeadInfo = BeadTemplateManager.Instance.GetBeadInfobyID(pIDbefore);
         for each(o in this._beadList)
         {
            if(info.Name == o.Name)
            {
               if(pLv >= o.BaseLevel && pLv < o.BaseLevel + o.MaxLevel)
               {
                  vResultID = o.TemplateID;
                  break;
               }
            }
         }
         return vResultID;
      }
   }
}

