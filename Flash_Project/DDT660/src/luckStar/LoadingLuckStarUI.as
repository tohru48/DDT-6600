package luckStar
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.LoaderEvent;
   import com.pickgliss.loader.LoaderManager;
   import com.pickgliss.loader.ModuleLoader;
   import com.pickgliss.loader.UIModuleLoader;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.UIModuleTypes;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PathManager;
   import ddt.utils.RequestVairableCreater;
   import ddt.view.UIModuleSmallLoading;
   import flash.events.Event;
   import flash.net.URLVariables;
   import luckStar.manager.LuckStarManager;
   import luckStar.model.LuckStarRankAnalyzer;
   
   public class LoadingLuckStarUI
   {
      
      private static var _instance:LoadingLuckStarUI;
      
      public function LoadingLuckStarUI()
      {
         super();
      }
      
      public static function get Instance() : LoadingLuckStarUI
      {
         if(_instance == null)
         {
            _instance = new LoadingLuckStarUI();
         }
         return _instance;
      }
      
      public function startLoad() : void
      {
         UIModuleSmallLoading.Instance.progress = 0;
         UIModuleSmallLoading.Instance.show();
         UIModuleSmallLoading.Instance.addEventListener(Event.CLOSE,this._onLoadingCloseHandle);
         UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__onLoadComplete);
         UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__onProgress);
         UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.LUCKSTAR);
      }
      
      private function __onLoadComplete(e:UIModuleEvent) : void
      {
         if(e.module == UIModuleTypes.LUCKSTAR)
         {
            UIModuleSmallLoading.Instance.hide();
            UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this._onLoadingCloseHandle);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__onLoadComplete);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__onProgress);
            this.loadingLuckStarAction();
            LuckStarManager.Instance.openLuckyStarFrame();
         }
      }
      
      private function __onProgress(e:UIModuleEvent) : void
      {
         if(e.module == UIModuleTypes.LUCKSTAR)
         {
            UIModuleSmallLoading.Instance.progress = e.loader.progress * 100;
         }
      }
      
      private function loadingLuckStarAction() : void
      {
         if(!ModuleLoader.hasDefinition("luckyStar.view.maxAwardAction"))
         {
            LoaderManager.Instance.creatAndStartLoad(PathManager.getUIPath() + "/swf/luckstaraction.swf",BaseLoader.MODULE_LOADER);
         }
      }
      
      private function _onLoadingCloseHandle(e:Event) : void
      {
         UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this._onLoadingCloseHandle);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__onLoadComplete);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__onProgress);
         UIModuleSmallLoading.Instance.hide();
      }
      
      public function RequestActivityRank() : void
      {
         LoaderManager.Instance.startLoad(this.createRequestLuckyStarActivityRank());
      }
      
      private function createRequestLuckyStarActivityRank() : BaseLoader
      {
         var args:URLVariables = RequestVairableCreater.creatWidthKey(true);
         var loader:BaseLoader = LoaderManager.Instance.creatLoader(PathManager.solveRequestPath("LuckStarActivityRank.ashx"),BaseLoader.REQUEST_LOADER,args);
         loader.loadErrorMessage = "请求幸运星模版失败!";
         loader.analyzer = new LuckStarRankAnalyzer(LuckStarManager.Instance.updateLuckyStarRank);
         loader.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         return loader;
      }
      
      private function __onLoadError(e:LoaderEvent) : void
      {
         var msg:String = e.loader.loadErrorMessage;
         if(Boolean(e.loader.analyzer))
         {
            if(e.loader.analyzer.message != null)
            {
               msg = e.loader.loadErrorMessage + "\n" + e.loader.analyzer.message;
            }
         }
         var alert:BaseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("alert"),msg,"确定");
         alert.addEventListener(FrameEvent.RESPONSE,this.__onAlertResponse);
      }
      
      private function __onAlertResponse(e:FrameEvent) : void
      {
         e.currentTarget.removeEventListener(FrameEvent.RESPONSE,this.__onAlertResponse);
         ObjectUtils.disposeObject(e.currentTarget);
      }
   }
}

