package activeEvents
{
   import activeEvents.analyze.ActiveEventsAnalyzer;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.LoadResourceManager;
   import com.pickgliss.loader.LoaderEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.PathManager;
   
   public class ActiveEventsManager
   {
      
      private static var _instance:ActiveEventsManager;
      
      private var _model:ActiveEventsModel;
      
      public function ActiveEventsManager()
      {
         super();
         this._model = new ActiveEventsModel();
      }
      
      public static function get Instance() : ActiveEventsManager
      {
         if(_instance == null)
         {
            _instance = new ActiveEventsManager();
         }
         return _instance;
      }
      
      public function setup() : void
      {
         var loader:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("ActiveList.xml"),BaseLoader.COMPRESS_TEXT_LOADER);
         loader.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.loadingActivityInformationFailure");
         loader.analyzer = new ActiveEventsAnalyzer(this.setupActiveEventsnfo);
         loader.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         LoadResourceManager.Instance.startLoad(loader);
      }
      
      public function setupActiveEventsnfo(analyzer:ActiveEventsAnalyzer) : void
      {
         this._model.actives = analyzer.list;
      }
      
      private function __onLoadError(event:LoaderEvent) : void
      {
         var msg:String = event.loader.loadErrorMessage;
         if(Boolean(event.loader.analyzer))
         {
            if(event.loader.analyzer.message != null)
            {
               msg = event.loader.loadErrorMessage + "\n" + event.loader.analyzer.message;
            }
         }
         var alert:BaseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("alert"),msg,LanguageMgr.GetTranslation("tank.room.RoomIIView2.affirm"));
         alert.addEventListener(FrameEvent.RESPONSE,this.__onAlertResponse);
      }
      
      private function __onAlertResponse(event:FrameEvent) : void
      {
         event.currentTarget.removeEventListener(FrameEvent.RESPONSE,this.__onAlertResponse);
         ObjectUtils.disposeObject(event.currentTarget);
         LeavePageManager.leaveToLoginPath();
      }
      
      public function get model() : ActiveEventsModel
      {
         return this._model;
      }
   }
}

