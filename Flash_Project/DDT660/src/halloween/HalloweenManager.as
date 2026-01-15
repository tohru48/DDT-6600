package halloween
{
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.loader.LoadResourceManager;
   import com.pickgliss.loader.UIModuleLoader;
   import com.pickgliss.ui.ComponentFactory;
   import ddt.data.UIModuleTypes;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.PathManager;
   import ddt.manager.SocketManager;
   import ddt.view.UIModuleSmallLoading;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import hallIcon.HallIconManager;
   import hallIcon.HallIconType;
   import halloween.analyze.HalloweenDataAnalyzer;
   import halloween.analyze.HalloweenRankDataAnalyzer;
   import halloween.data.HalloweenType;
   import halloween.info.HalloweenMainInfo;
   import halloween.info.HalloweenRankInfo;
   import road7th.comm.PackageIn;
   
   public class HalloweenManager extends EventDispatcher
   {
      
      private static var _instance:HalloweenManager = null;
      
      public static var loadComplete:Boolean = false;
      
      public static var useFirst:Boolean = true;
      
      public var prizeArr:Array = new Array();
      
      public var rankArr:Vector.<HalloweenRankInfo> = new Vector.<HalloweenRankInfo>();
      
      public var mainViewData:HalloweenMainInfo = new HalloweenMainInfo();
      
      private var _frameView:HalloweenView;
      
      public function HalloweenManager()
      {
         super();
      }
      
      public static function get instance() : HalloweenManager
      {
         if(_instance == null)
         {
            _instance = new HalloweenManager();
         }
         return _instance;
      }
      
      public function setup() : void
      {
         this.initEvent();
      }
      
      public function templateDataSetup(analyzer:DataAnalyzer) : void
      {
         if(analyzer is HalloweenDataAnalyzer)
         {
            this.prizeArr = HalloweenDataAnalyzer(analyzer).dataList;
         }
      }
      
      public function rankDataSetup(analyzer:DataAnalyzer) : void
      {
         if(analyzer is HalloweenRankDataAnalyzer)
         {
            this.rankArr = HalloweenRankDataAnalyzer(analyzer).dataList;
            if(Boolean(this._frameView))
            {
               this._frameView.dataLoad();
            }
         }
      }
      
      private function initEvent() : void
      {
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.HALLOWEEN,this.openHandler);
      }
      
      public function showHideIcon(bol:Boolean) : void
      {
         HallIconManager.instance.updateSwitchHandler(HallIconType.HALLOWEEN,bol);
      }
      
      private function openHandler(e:CrazyTankSocketEvent) : void
      {
         var pkg:PackageIn = e.pkg;
         var cmd:int = e._cmd;
         switch(cmd)
         {
            case HalloweenType.OPEN:
               this.showHideIcon(pkg.readBoolean());
               break;
            case HalloweenType.ENTER:
               this.mainViewData.mycard = pkg.readInt();
               this.mainViewData.myrank = pkg.readInt();
               this.mainViewData.refreshTime = pkg.readDate();
               this.show();
         }
      }
      
      private function show() : void
      {
         if(loadComplete)
         {
            this.showFrame();
         }
         else if(useFirst)
         {
            UIModuleSmallLoading.Instance.progress = 0;
            UIModuleSmallLoading.Instance.show();
            UIModuleSmallLoading.Instance.addEventListener(Event.CLOSE,this.__onClose);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__progressShow);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__complainShow);
            UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.HALLOWEEN);
         }
      }
      
      protected function __onClose(event:Event) : void
      {
         UIModuleSmallLoading.Instance.hide();
         UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__onClose);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__progressShow);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__complainShow);
      }
      
      private function __progressShow(event:UIModuleEvent) : void
      {
         if(event.module == UIModuleTypes.HALLOWEEN)
         {
            UIModuleSmallLoading.Instance.progress = event.loader.progress * 100;
         }
      }
      
      private function __complainShow(event:UIModuleEvent) : void
      {
         if(event.module == UIModuleTypes.HALLOWEEN)
         {
            UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__onClose);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__progressShow);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__complainShow);
            UIModuleSmallLoading.Instance.hide();
            loadComplete = true;
            useFirst = false;
            this.showFrame();
         }
      }
      
      public function hide() : void
      {
         if(this._frameView != null)
         {
            this._frameView.dispose();
         }
         this._frameView = null;
      }
      
      private function showFrame() : void
      {
         if(this._frameView == null)
         {
            this._frameView = ComponentFactory.Instance.creatComponentByStylename("asset.halloween.HalloweenView");
            this._frameView.show();
         }
         this._frameView.mainViewDataload();
         this._loadXml("ActivityHalloweenRank.ashx?ran=" + Math.random(),BaseLoader.REQUEST_LOADER);
      }
      
      private function _loadXml($url:String, $requestType:int, $loadErrorMessage:String = "") : void
      {
         var loadSelfConsortiaMemberList:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath($url),$requestType);
         loadSelfConsortiaMemberList.loadErrorMessage = $loadErrorMessage;
         loadSelfConsortiaMemberList.analyzer = new HalloweenRankDataAnalyzer(this.rankDataSetup);
         LoadResourceManager.Instance.startLoad(loadSelfConsortiaMemberList);
      }
   }
}

