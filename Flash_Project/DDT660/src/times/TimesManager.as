package times
{
   import activeEvents.ActiveController;
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.LoadResourceManager;
   import com.pickgliss.loader.LoaderEvent;
   import com.pickgliss.loader.UIModuleLoader;
   import com.pickgliss.toplevel.StageReferance;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.ComponentSetting;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.utils.DisplayUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.UIModuleTypes;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.loader.StartupResourceLoader;
   import ddt.manager.PathManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SharedManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.StateManager;
   import ddt.states.StateType;
   import ddt.utils.RequestVairableCreater;
   import ddt.view.UIModuleSmallLoading;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.net.URLVariables;
   import flash.ui.Keyboard;
   import flash.utils.setTimeout;
   import hall.HallStateView;
   import road7th.comm.PackageIn;
   import shop.manager.ShopBuyManager;
   import times.data.TimesAnalyzer;
   import times.data.TimesEvent;
   import times.data.TimesPicInfo;
   import times.data.TimesStatistics;
   import times.view.TimesView;
   
   public class TimesManager
   {
      
      private static var _instance:TimesManager;
      
      public var isDefaultStarUpShow:Boolean;
      
      private var _timesBtn:MovieClip;
      
      private var _timesView:TimesView;
      
      private var _isReturn:Boolean;
      
      private var _isUIComplete:Boolean;
      
      private var _isUpdateResComplete:Boolean;
      
      private var _isThumbnailComplete:Boolean;
      
      private var _controller:TimesController;
      
      private var _statistics:TimesStatistics;
      
      private var _hallView:HallStateView;
      
      private var _isQQshow:Boolean = false;
      
      private var _page:int = 0;
      
      private var _updateContentList:Array;
      
      private var _isNeedOpenUpdateFrame:Boolean = false;
      
      public var isShowActivityAdvView:Boolean = false;
      
      public function TimesManager()
      {
         super();
      }
      
      public static function get Instance() : TimesManager
      {
         if(!_instance)
         {
            _instance = new TimesManager();
         }
         return _instance;
      }
      
      public function setup() : void
      {
         this.createTimesInfo();
         this._controller = TimesController.Instance;
         this._controller.model.webPath = PathManager.SITE_WEEKLY + "weekly/";
         this._controller.addEventListener(TimesEvent.THUMBNAIL_LOAD_COMPLETE,this.__onThumbnailComplete);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.WEEKLY_CLICK_CNT,this.__canGenerateEgg);
         this._statistics = new TimesStatistics();
      }
      
      public function showButton(hallView:HallStateView) : void
      {
         this._hallView = hallView;
         if(this._isThumbnailComplete)
         {
            if(this._timesBtn && this._timesBtn.parent || !this._hallView)
            {
               return;
            }
            this._timesBtn = ComponentFactory.Instance.creat("asset.times.TimesBtnMc");
            this._timesBtn.buttonMode = true;
            this._timesBtn.addEventListener(MouseEvent.CLICK,this.__onBtnClick);
            this._timesBtn.addEventListener(Event.ADDED_TO_STAGE,this.onWeeklyAdded);
            LayerManager.Instance.addToLayer(this._timesBtn,LayerManager.GAME_DYNAMIC_LAYER,false,0,false);
            this._timesBtn.parent.setChildIndex(this._timesBtn,0);
         }
      }
      
      private function onWeeklyAdded(event:Event) : void
      {
         if(PlayerManager.Instance.Self.IsFirst > 1)
         {
            setTimeout(function():void
            {
               if(TimesManager.Instance.isDefaultStarUpShow)
               {
                  TimesManager.Instance.isDefaultStarUpShow = false;
                  __onBtnClick(null);
               }
            },1000);
         }
      }
      
      private function __onThumbnailComplete(event:TimesEvent) : void
      {
         this._isThumbnailComplete = true;
         if(StateManager.currentStateType == StateType.MAIN)
         {
            this.showButton(this._hallView);
         }
      }
      
      public function hideButton() : void
      {
         if(Boolean(this._timesBtn))
         {
            if(Boolean(this._timesBtn.parent))
            {
               this._timesBtn.parent.removeChild(this._timesBtn);
            }
            this._timesBtn.removeEventListener(MouseEvent.CLICK,this.__onBtnClick);
            this._timesBtn = null;
         }
      }
      
      public function show() : void
      {
         if(!this._isReturn || !this._isUIComplete || !this._isUpdateResComplete)
         {
            return;
         }
         SoundManager.instance.playMusic("140");
         TimesController.Instance.updateContenList = this._updateContentList;
         TimesController.Instance.isShowUpdateView = this.isShowUpdateView;
         this._timesView = new TimesView();
         this._controller.addEventListener(TimesEvent.CLOSE_VIEW,this.__timesEventHandler);
         this._controller.addEventListener(TimesEvent.PLAY_SOUND,this.__timesEventHandler);
         this._controller.addEventListener(TimesEvent.GOT_EGG,this.__timesEventHandler);
         this._controller.addEventListener(TimesEvent.PURCHASE,this.__timesEventHandler);
         this._controller.initEvent();
         StageReferance.stage.addEventListener(KeyboardEvent.KEY_DOWN,this.__keyBoardEventHandler);
         LayerManager.Instance.addToLayer(this._timesView,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
         if(this._isQQshow)
         {
            this._isQQshow = false;
            this._QQshowComplete();
         }
      }
      
      public function showByQQtips(page:int) : void
      {
         this._isQQshow = true;
         this._page = page;
         this.__onBtnClick(null);
      }
      
      private function _QQshowComplete() : void
      {
         var i:int = 0;
         var j:int = 0;
         var sum:int = 0;
         var contentArr:Array = this._controller.model.contentInfos;
         for(var tempInfo:TimesPicInfo = new TimesPicInfo(); i < contentArr.length; )
         {
            for(j = 0; j < contentArr[i].length; j++)
            {
               sum++;
               if(sum == this._page)
               {
                  tempInfo.targetCategory = i;
                  tempInfo.targetPage = j;
               }
            }
            i++;
         }
         this._controller.dispatchEvent(new TimesEvent(TimesEvent.GOTO_CONTENT,tempInfo));
      }
      
      private function __keyBoardEventHandler(event:KeyboardEvent) : void
      {
         if(event.keyCode == Keyboard.ESCAPE)
         {
            SoundManager.instance.play("008");
            this.hide();
         }
      }
      
      public function hide() : void
      {
         if(ShopBuyManager.Instance.isShow)
         {
            ShopBuyManager.Instance.dispose();
            return;
         }
         if(ActiveController.instance.isShowing)
         {
            return;
         }
         StageReferance.stage.removeEventListener(KeyboardEvent.KEY_DOWN,this.__keyBoardEventHandler);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.WEEKLY_CLICK_CNT,this.__canGenerateEgg);
         if(!StartupResourceLoader.firstEnterHall)
         {
            SoundManager.instance.playMusic("062");
         }
         this.sendStatistics();
         DisplayUtils.removeDisplay(this._timesView);
         this._controller.clearExtraObjects();
         this._controller.removeEvent();
         ObjectUtils.disposeObject(this._timesView);
         this._timesView = null;
      }
      
      public function get statistics() : TimesStatistics
      {
         return this._statistics;
      }
      
      private function sendStatistics() : void
      {
         var sum:int = 0;
         var stayTime:Vector.<int> = this._statistics.stayTime;
         for(var i:int = 0; i < stayTime.length; i++)
         {
            sum += stayTime[i];
         }
         if(sum == 0)
         {
            this._statistics.stopTick();
            return;
         }
         var args:URLVariables = RequestVairableCreater.creatWidthKey(true);
         args["Versions"] = this._controller.model.edition;
         args["Forum1"] = stayTime[0];
         args["Forum2"] = stayTime[1];
         args["Forum3"] = stayTime[2];
         args["Forum4"] = stayTime[3];
         args["Forum5"] = stayTime[4];
         var loader:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("CommitWeeklyUserRecord.ashx"),BaseLoader.REQUEST_LOADER,args);
         LoadResourceManager.Instance.startLoad(loader);
         this._statistics.stopTick();
      }
      
      private function __timesEventHandler(event:TimesEvent) : void
      {
         switch(event.type)
         {
            case TimesEvent.CLOSE_VIEW:
               SoundManager.instance.play("008");
               this.hide();
               break;
            case TimesEvent.PLAY_SOUND:
               SoundManager.instance.play("008");
               break;
            case TimesEvent.GOT_EGG:
               SoundManager.instance.play("008");
               SocketManager.Instance.out.sendDailyAward(2);
               this._controller.model.isShowEgg = !this._controller.model.isShowEgg;
               break;
            case TimesEvent.PURCHASE:
               SoundManager.instance.play("008");
               ShopBuyManager.Instance.buy(int(event.info.templateID));
         }
      }
      
      private function __onBtnClick(e:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         ComponentSetting.SEND_USELOG_ID(24);
         this.show();
         if(!this._isReturn)
         {
            SocketManager.Instance.out.sendWeeklyClick();
         }
         if(!this._isUIComplete || !this._isUpdateResComplete)
         {
            UIModuleSmallLoading.Instance.progress = 0;
            UIModuleSmallLoading.Instance.show();
            UIModuleSmallLoading.Instance.addEventListener(Event.CLOSE,this.__onSmallLoadingClose);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__onUIComplete);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__onUIProgress);
            UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.TIMES_UPDATE);
            UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.TIMES);
         }
      }
      
      private function __canGenerateEgg(event:CrazyTankSocketEvent) : void
      {
         var pkg:PackageIn = event.pkg;
         this._controller.model.isShowEgg = pkg.readBoolean();
         this._isReturn = true;
         this.show();
      }
      
      private function __onUIProgress(e:UIModuleEvent) : void
      {
         if(e.module == UIModuleTypes.TIMES)
         {
            UIModuleSmallLoading.Instance.progress = e.loader.progress * 100;
         }
      }
      
      private function __onSmallLoadingClose(e:Event) : void
      {
         UIModuleSmallLoading.Instance.hide();
         UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__onSmallLoadingClose);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__onUIComplete);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__onUIProgress);
      }
      
      private function __onUIComplete(e:UIModuleEvent) : void
      {
         if(e.module == UIModuleTypes.TIMES)
         {
            this._isUIComplete = true;
         }
         if(e.module == UIModuleTypes.TIMES_UPDATE)
         {
            this._isUpdateResComplete = true;
         }
         if(!this._isUIComplete || !this._isUpdateResComplete)
         {
            return;
         }
         UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__onSmallLoadingClose);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__onUIComplete);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__onUIProgress);
         UIModuleSmallLoading.Instance.hide();
         this.show();
      }
      
      private function createTimesInfo() : void
      {
         var loader:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.SITE_WEEKLY + "weekly/weeklyInfo.xml",BaseLoader.TEXT_LOADER);
         loader.loadErrorMessage = "Error occur when loading times pic! Please refer to webmaster!";
         loader.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         loader.analyzer = new TimesAnalyzer(TimesController.Instance.setup);
         LoadResourceManager.Instance.startLoad(loader,true);
      }
      
      private function __onLoadError(event:LoaderEvent) : void
      {
      }
      
      public function get updateContentList() : Array
      {
         return this._updateContentList;
      }
      
      public function checkOpenUpdateFrame() : void
      {
         if(this._isNeedOpenUpdateFrame)
         {
            this.doOpenUpdateFrame();
         }
      }
      
      public function checkLoadUpdateRes(updateContentList:Array, idList:Array) : void
      {
         this._updateContentList = updateContentList;
         var strLoction:String = SharedManager.Instance.edictumVersion;
         var idStr:String = idList.join("|");
         if(strLoction != idStr)
         {
            this._isNeedOpenUpdateFrame = true;
            SharedManager.Instance.edictumVersion = idStr;
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.loadCompleteHandler);
            UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.TIMES_UPDATE);
         }
      }
      
      private function loadCompleteHandler(event:UIModuleEvent) : void
      {
         if(event.module == UIModuleTypes.TIMES_UPDATE)
         {
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.loadCompleteHandler);
            if(StateManager.currentStateType == StateType.MAIN)
            {
               this.doOpenUpdateFrame();
            }
         }
      }
      
      private function doOpenUpdateFrame() : void
      {
         this._isNeedOpenUpdateFrame = false;
         var frame:TimesUpdateFrame = ComponentFactory.Instance.creatComponentByStylename("TimesUpdateFrame");
         LayerManager.Instance.addToLayer(frame,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
         this.isShowActivityAdvView = true;
      }
      
      public function get isShowUpdateView() : Boolean
      {
         return Boolean(this._updateContentList) && this._updateContentList.length > 0;
      }
   }
}

