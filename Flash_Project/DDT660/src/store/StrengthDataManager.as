package store
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.LoadResourceManager;
   import com.pickgliss.loader.LoaderEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PathManager;
   import ddt.manager.SoundManager;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import flash.utils.Dictionary;
   import store.analyze.StrengthenDataAnalyzer;
   import store.events.StoreIIEvent;
   
   public class StrengthDataManager extends EventDispatcher
   {
      
      private static var _instance:StrengthDataManager;
      
      public static const FUSIONFINISH:String = "fusionFinish";
      
      public var _strengthData:Vector.<Dictionary>;
      
      public var autoFusion:Boolean;
      
      public function StrengthDataManager(target:IEventDispatcher = null)
      {
         super(target);
         this.loadStrengthenLevel();
      }
      
      public static function get instance() : StrengthDataManager
      {
         if(_instance == null)
         {
            _instance = new StrengthDataManager();
         }
         return _instance;
      }
      
      public function setup() : void
      {
      }
      
      private function loadStrengthenLevel() : void
      {
         var loader:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("ItemStrengthenData.xml"),BaseLoader.COMPRESS_TEXT_LOADER);
         loader.loadErrorMessage = LanguageMgr.GetTranslation("store.view.fusion.LoadStrengthenListError");
         loader.analyzer = new StrengthenDataAnalyzer(this.__searchResult);
         LoadResourceManager.Instance.startLoad(loader);
         loader.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
      }
      
      private function __searchResult(action:StrengthenDataAnalyzer) : void
      {
         this._strengthData = action._strengthData;
      }
      
      private function __onLoadError(event:LoaderEvent) : void
      {
         var msg:String = event.loader.loadErrorMessage;
         if(Boolean(event.loader.analyzer))
         {
            msg = event.loader.loadErrorMessage + "\n" + event.loader.analyzer.message;
         }
         var alert:BaseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("alert"),event.loader.loadErrorMessage,LanguageMgr.GetTranslation("tank.view.bagII.baglocked.sure"));
         alert.addEventListener(FrameEvent.RESPONSE,this.__onAlertResponse);
      }
      
      private function __onAlertResponse(event:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         event.currentTarget.removeEventListener(FrameEvent.RESPONSE,this.__onAlertResponse);
         ObjectUtils.disposeObject(event.currentTarget);
      }
      
      public function getRecoverDongAddition(TempID:int, strengthenLevel:int) : Number
      {
         return this._strengthData[strengthenLevel][TempID];
      }
      
      public function fusionFinish() : void
      {
         dispatchEvent(new Event(FUSIONFINISH));
      }
      
      public function exaltFinish() : void
      {
         dispatchEvent(new StoreIIEvent(StoreIIEvent.EXALT_FINISH));
      }
      
      public function exaltFail(lucky:int = 0) : void
      {
         dispatchEvent(new StoreIIEvent(StoreIIEvent.EXALT_FAIL,lucky));
      }
   }
}

