package christmas.loader
{
   import christmas.manager.ChristmasManager;
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.LoaderEvent;
   import com.pickgliss.loader.LoaderManager;
   import com.pickgliss.loader.UIModuleLoader;
   import com.pickgliss.ui.controls.Frame;
   import ddt.data.UIModuleTypes;
   import ddt.manager.PathManager;
   import ddt.manager.StateManager;
   import ddt.states.StateType;
   import ddt.view.UIModuleSmallLoading;
   import flash.events.Event;
   
   public class LoaderChristmasUIModule extends Frame
   {
      
      private static var _instance:LoaderChristmasUIModule;
      
      private var _func:Function;
      
      private var _funcParams:Array;
      
      public function LoaderChristmasUIModule(pct:PrivateClass)
      {
         super();
      }
      
      public static function get Instance() : LoaderChristmasUIModule
      {
         if(LoaderChristmasUIModule._instance == null)
         {
            LoaderChristmasUIModule._instance = new LoaderChristmasUIModule(new PrivateClass());
         }
         return LoaderChristmasUIModule._instance;
      }
      
      public function loadUIModule(complete:Function = null, completeParams:Array = null) : void
      {
         this._func = complete;
         this._funcParams = completeParams;
         UIModuleSmallLoading.Instance.progress = 0;
         UIModuleSmallLoading.Instance.show();
         UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.loadCompleteHandler);
         UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.onUimoduleLoadProgress);
         UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.CHRISTMAS);
      }
      
      private function loadCompleteHandler(event:UIModuleEvent) : void
      {
         if(event.module == UIModuleTypes.CHRISTMAS)
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
         if(event.module == UIModuleTypes.CHRISTMAS)
         {
            UIModuleSmallLoading.Instance.progress = event.loader.progress * 100;
         }
      }
      
      public function loadMap() : void
      {
         var mapLoader:BaseLoader = LoaderManager.Instance.creatLoader(ChristmasManager.instance.mapPath,BaseLoader.MODULE_LOADER);
         mapLoader.addEventListener(LoaderEvent.COMPLETE,this.onChristmasMapSrcLoadedComplete);
         LoaderManager.Instance.startLoad(mapLoader);
      }
      
      private function onChristmasMapSrcLoadedComplete(e:Event) : void
      {
         if(StateManager.getState(StateType.CHRISTMAS_ROOM) == null)
         {
            UIModuleSmallLoading.Instance.addEventListener(Event.CLOSE,this.__loadingIsCloseRoom);
         }
         StateManager.setState(StateType.CHRISTMAS_ROOM);
      }
      
      private function __loadingIsCloseRoom(e:Event) : void
      {
         UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__loadingIsCloseRoom);
      }
      
      public function getChristmasResource() : String
      {
         return PathManager.SITE_MAIN + "image/scene/christmas/";
      }
      
      public function getMapRes() : String
      {
         return "tank.christmas.Map";
      }
   }
}

class PrivateClass
{
   
   public function PrivateClass()
   {
      super();
   }
}
