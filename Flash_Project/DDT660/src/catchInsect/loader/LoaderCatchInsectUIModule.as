package catchInsect.loader
{
   import catchInsect.CatchInsectMananger;
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.LoadResourceManager;
   import com.pickgliss.loader.LoaderEvent;
   import com.pickgliss.loader.UIModuleLoader;
   import com.pickgliss.ui.controls.Frame;
   import ddt.data.UIModuleTypes;
   import ddt.manager.PathManager;
   import ddt.manager.StateManager;
   import ddt.states.StateType;
   import ddt.view.UIModuleSmallLoading;
   import flash.events.Event;
   
   public class LoaderCatchInsectUIModule extends Frame
   {
      
      private static var _instance:LoaderCatchInsectUIModule;
      
      private var _func:Function;
      
      private var _funcParams:Array;
      
      public function LoaderCatchInsectUIModule()
      {
         super();
      }
      
      public static function get Instance() : LoaderCatchInsectUIModule
      {
         if(!_instance)
         {
            _instance = new LoaderCatchInsectUIModule();
         }
         return _instance;
      }
      
      public function loadUIModule(complete:Function = null, completeParams:Array = null) : void
      {
         this._func = complete;
         this._funcParams = completeParams;
         UIModuleSmallLoading.Instance.progress = 0;
         UIModuleSmallLoading.Instance.show();
         UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.loadCompleteHandler);
         UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.onUimoduleLoadProgress);
         UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.CATCH_INSECT);
      }
      
      private function loadCompleteHandler(event:UIModuleEvent) : void
      {
         if(event.module == UIModuleTypes.CATCH_INSECT)
         {
            UIModuleSmallLoading.Instance.hide();
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.loadCompleteHandler);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.onUimoduleLoadProgress);
            if(null != this._func)
            {
               this._func.apply(null,this._funcParams);
            }
            this._func = null;
            this._funcParams = null;
         }
      }
      
      private function onUimoduleLoadProgress(event:UIModuleEvent) : void
      {
         if(event.module == UIModuleTypes.CATCH_INSECT)
         {
            UIModuleSmallLoading.Instance.progress = event.loader.progress * 100;
         }
      }
      
      public function loadMap() : void
      {
         var mapLoader:BaseLoader = LoadResourceManager.Instance.createLoader(CatchInsectMananger.instance.mapPath,BaseLoader.MODULE_LOADER);
         mapLoader.addEventListener(LoaderEvent.COMPLETE,this.onCatchInsectMapSrcLoadedComplete);
         LoadResourceManager.Instance.startLoad(mapLoader);
      }
      
      private function onCatchInsectMapSrcLoadedComplete(e:Event) : void
      {
         if(StateManager.getState(StateType.CATCH_INSECT) == null)
         {
            UIModuleSmallLoading.Instance.addEventListener(Event.CLOSE,this.__loadingIsCloseRoom);
         }
         StateManager.setState(StateType.CATCH_INSECT);
      }
      
      private function __loadingIsCloseRoom(e:Event) : void
      {
         UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__loadingIsCloseRoom);
      }
      
      public function getCatchInsectResource() : String
      {
         return PathManager.SITE_MAIN + "image/scene/catchInsect";
      }
      
      public function getMapRes() : String
      {
         return "asset.catchInsect.map";
      }
      
      public function solveMonsterPath(pPath:String) : String
      {
         return this.getCatchInsectResource() + "/monsters/" + pPath + ".swf";
      }
   }
}

