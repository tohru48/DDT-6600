package oldPlayerRegress
{
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.LoaderEvent;
   import com.pickgliss.loader.LoaderManager;
   import com.pickgliss.loader.UIModuleLoader;
   import com.pickgliss.ui.ComponentFactory;
   import ddt.data.UIModuleTypes;
   import ddt.data.analyze.PlayerRegressNotificationAnalyzer;
   import ddt.loader.LoaderCreate;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PathManager;
   import ddt.view.UIModuleSmallLoading;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import oldPlayerRegress.view.RegressView;
   
   public class RegressManager extends EventDispatcher
   {
      
      private static var _instance:RegressManager;
      
      public static var loadComplete:Boolean = false;
      
      public static var useFirst:Boolean = true;
      
      private var _regressView:RegressView;
      
      public var autoPopUp:Boolean;
      
      public var updateContent:String;
      
      public function RegressManager()
      {
         super();
         this.autoPopUp = false;
      }
      
      public static function get instance() : RegressManager
      {
         if(!_instance)
         {
            _instance = new RegressManager();
         }
         return _instance;
      }
      
      public function startPlayerRegressNotificationLoader() : void
      {
         var loader:BaseLoader = LoaderManager.Instance.creatLoader(PathManager.getPlayerRegressNotificationPath(),BaseLoader.TEXT_LOADER);
         loader.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.LoadingPlayerRegressNotificationFailure");
         loader.analyzer = new PlayerRegressNotificationAnalyzer(this.setup);
         loader.addEventListener(LoaderEvent.LOAD_ERROR,LoaderCreate.Instance.__onLoadError);
         loader.addEventListener(LoaderEvent.COMPLETE,this.__loaderComplete);
         LoaderManager.Instance.startLoad(loader);
      }
      
      private function __loaderComplete(event:LoaderEvent) : void
      {
         var loader:BaseLoader = BaseLoader(event.currentTarget);
         loader.removeEventListener(LoaderEvent.LOAD_ERROR,LoaderCreate.Instance.__onLoadError);
         loader.removeEventListener(LoaderEvent.COMPLETE,this.__loaderComplete);
         this.show();
      }
      
      public function setup(analyzer:PlayerRegressNotificationAnalyzer) : void
      {
         this.updateContent = analyzer.updateContent;
      }
      
      public function show() : void
      {
         if(!this.updateContent)
         {
            this.startPlayerRegressNotificationLoader();
            return;
         }
         if(loadComplete)
         {
            this.showRegressFrame();
         }
         else if(useFirst)
         {
            UIModuleSmallLoading.Instance.progress = 0;
            UIModuleSmallLoading.Instance.show();
            UIModuleSmallLoading.Instance.addEventListener(Event.CLOSE,this.__onClose);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__progressShow);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__complainShow);
            UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.REGRESS_VIEW);
         }
      }
      
      public function hide() : void
      {
         if(this._regressView != null)
         {
            this._regressView.dispose();
         }
         this._regressView = null;
      }
      
      private function __complainShow(event:UIModuleEvent) : void
      {
         if(event.module == UIModuleTypes.REGRESS_VIEW)
         {
            UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__onClose);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__progressShow);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__complainShow);
            UIModuleSmallLoading.Instance.hide();
            loadComplete = true;
            useFirst = false;
            this.show();
         }
      }
      
      private function __progressShow(event:UIModuleEvent) : void
      {
         if(event.module == UIModuleTypes.REGRESS_VIEW)
         {
            UIModuleSmallLoading.Instance.progress = event.loader.progress * 100;
         }
      }
      
      protected function __onClose(event:Event) : void
      {
         UIModuleSmallLoading.Instance.hide();
         UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__onClose);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__progressShow);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__complainShow);
      }
      
      private function showRegressFrame() : void
      {
         this._regressView = ComponentFactory.Instance.creatComponentByStylename("regress.RegressView");
         this._regressView.show();
      }
   }
}

