package com.pickgliss.manager
{
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.LoadResourceManager;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import flash.net.URLVariables;
   
   public class NoviceDataManager extends EventDispatcher
   {
      
      private static var _instance:NoviceDataManager;
      
      public var firstEnterGame:Boolean = false;
      
      public function NoviceDataManager(param1:IEventDispatcher = null)
      {
         super(param1);
      }
      
      public static function get instance() : NoviceDataManager
      {
         if(!_instance)
         {
            _instance = new NoviceDataManager();
         }
         return _instance;
      }
      
      public function saveNoviceData(param1:int, param2:String, param3:String) : void
      {
         var _loc4_:URLVariables = new URLVariables();
         _loc4_["nodeID"] = param1;
         _loc4_["userName"] = param2;
         var _loc5_:BaseLoader = LoadResourceManager.Instance.createLoader(param3 + "NoviceNodeData.ashx",BaseLoader.REQUEST_LOADER,_loc4_);
         LoadResourceManager.Instance.startLoad(_loc5_);
      }
   }
}

