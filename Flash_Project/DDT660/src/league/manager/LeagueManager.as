package league.manager
{
   import com.pickgliss.action.FunctionAction;
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.UIModuleLoader;
   import com.pickgliss.manager.CacheSysManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import ddt.bagStore.BagStore;
   import ddt.constants.CacheConsts;
   import ddt.data.UIModuleTypes;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.SocketManager;
   import ddt.manager.StateManager;
   import ddt.states.StateType;
   import ddt.view.UIModuleSmallLoading;
   import ddtActivityIcon.DdtActivityIconManager;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   import league.view.LeagueShopFrame;
   import league.view.LeagueStartNoticeView;
   import road7th.comm.PackageIn;
   
   public class LeagueManager extends EventDispatcher
   {
      
      private static var _instance:LeagueManager;
      
      public var maxCount:int = 30;
      
      public var restCount:int = 10;
      
      public var militaryRank:int = -1;
      
      private var _func:Function;
      
      private var _funcParams:Array;
      
      private var timeOutNumber:uint;
      
      public var isOpen:Boolean = false;
      
      private var _lsnView:LeagueStartNoticeView;
      
      public var addLeaIcon:Function;
      
      public var deleteLeaIcon:Function;
      
      public function LeagueManager(target:IEventDispatcher = null)
      {
         super(target);
      }
      
      public static function get instance() : LeagueManager
      {
         if(_instance == null)
         {
            _instance = new LeagueManager();
         }
         return _instance;
      }
      
      public function showLeagueShopFrame() : void
      {
         this.loadLeagueModule(this.doShowLeagueShopFrame);
      }
      
      private function doShowLeagueShopFrame() : void
      {
         var leagueFrame:LeagueShopFrame = ComponentFactory.Instance.creatComponentByStylename("league.LeagueShopFrame");
         LayerManager.Instance.addToLayer(leagueFrame,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      public function loadLeagueModule(complete:Function = null, completeParams:Array = null) : void
      {
         this._func = complete;
         this._funcParams = completeParams;
         UIModuleSmallLoading.Instance.progress = 0;
         UIModuleSmallLoading.Instance.show();
         UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.loadCompleteHandler);
         UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.onUimoduleLoadProgress);
         UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.LEAGUE);
      }
      
      private function onUimoduleLoadProgress(event:UIModuleEvent) : void
      {
         if(event.module == UIModuleTypes.LEAGUE)
         {
            UIModuleSmallLoading.Instance.progress = event.loader.progress * 100;
         }
      }
      
      private function loadCompleteHandler(event:UIModuleEvent) : void
      {
         if(event.module == UIModuleTypes.LEAGUE)
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
      
      public function initLeagueStartNoticeEvent() : void
      {
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.POPUP_LEAGUESTART_NOTICE,this.onLeagueNotice);
      }
      
      private function onLeagueNotice(e:CrazyTankSocketEvent) : void
      {
         var pkg:PackageIn = e.pkg;
         var tmpType:int = pkg.readByte();
         if(tmpType == 1)
         {
            this.restCount = pkg.readInt();
            this.maxCount = pkg.readInt();
            this.isOpen = true;
            if(StateManager.currentStateType == StateType.MAIN || StateManager.currentStateType == StateType.ROOM_LIST || StateManager.currentStateType == StateType.DUNGEON_LIST || StateManager.currentStateType == StateType.DUNGEON_ROOM || StateManager.currentStateType == StateType.MATCH_ROOM || StateManager.currentStateType == StateType.CHALLENGE_ROOM || StateManager.currentStateType == StateType.LOGIN)
            {
               if(BagStore.instance.storeOpenAble)
               {
                  return;
               }
               this.timeOutNumber = setTimeout(this.showLeagueStartNoticeView,1000);
            }
            if(this.addLeaIcon != null)
            {
               this.addLeaIcon();
            }
         }
         else if(tmpType == 2)
         {
            this.restCount = -1;
            this.maxCount = -1;
            this.isOpen = false;
            DdtActivityIconManager.Instance.currObj = null;
            if(this.deleteLeaIcon != null)
            {
               this.deleteLeaIcon();
            }
         }
         else if(tmpType == 3)
         {
            this.restCount = pkg.readInt();
         }
      }
      
      private function showLeagueStartNoticeView() : void
      {
         this._lsnView = ComponentFactory.Instance.creat("league.leagueStartNoticeView");
         if(CacheSysManager.isLock(CacheConsts.ALERT_IN_NEWVERSIONGUIDETIP))
         {
            CacheSysManager.getInstance().cache(CacheConsts.ALERT_IN_NEWVERSIONGUIDETIP,new FunctionAction(this._lsnView.show));
         }
         else
         {
            this._lsnView.show();
         }
         clearTimeout(this.timeOutNumber);
      }
   }
}

