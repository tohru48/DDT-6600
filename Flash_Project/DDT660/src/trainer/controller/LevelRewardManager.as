package trainer.controller
{
   import com.pickgliss.action.AlertAction;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.LoadResourceManager;
   import com.pickgliss.loader.LoaderEvent;
   import com.pickgliss.manager.CacheSysManager;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.constants.CacheConsts;
   import ddt.data.analyze.LevelRewardAnalyzer;
   import ddt.events.PlayerPropertyEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.PathManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import flash.utils.Dictionary;
   import trainer.data.LevelRewardInfo;
   import trainer.data.Step;
   import trainer.view.LevelRewardFrame;
   import trainer.view.SecondOnlineView;
   
   public class LevelRewardManager
   {
      
      private static var _instance:LevelRewardManager;
      
      public var _isShow:Boolean;
      
      private var _reward:Dictionary;
      
      private var _fr:LevelRewardFrame;
      
      public function LevelRewardManager()
      {
         super();
      }
      
      public static function get Instance() : LevelRewardManager
      {
         if(_instance == null)
         {
            _instance = new LevelRewardManager();
         }
         return _instance;
      }
      
      public function get isShow() : Boolean
      {
         return this._isShow;
      }
      
      public function set isShow(value:Boolean) : void
      {
         this._isShow = value;
      }
      
      public function setup() : void
      {
         var loader:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.getLevelRewardPath(),BaseLoader.TEXT_LOADER);
         loader.loadErrorMessage = "load levelRewards Failed";
         loader.analyzer = new LevelRewardAnalyzer(this.onDataComplete);
         loader.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         LoadResourceManager.Instance.startLoad(loader);
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
      
      private function onDataComplete(analyzer:LevelRewardAnalyzer) : void
      {
         if(!WeakGuildManager.Instance.switchUserGuide || PlayerManager.Instance.Self.IsWeakGuildFinish(Step.OLD_PLAYER))
         {
            return;
         }
         this._reward = analyzer.list;
         PlayerManager.Instance.Self.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__onChange);
      }
      
      private function __onChange(event:PlayerPropertyEvent) : void
      {
         if(Boolean(event.changedProperties["Grade"]) && PlayerManager.Instance.Self.IsUpGrade)
         {
            if(PlayerManager.Instance.Self.Grade == 6)
            {
               this.showSecFrame();
            }
            SocketManager.Instance.out.sendExpBlessedData();
         }
      }
      
      private function __onResponse(evt:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         this.hide();
      }
      
      public function getRewardInfo(level:int, sort:int) : LevelRewardInfo
      {
         return this._reward[level][sort];
      }
      
      public function showSecFrame() : void
      {
         if(!WeakGuildManager.Instance.switchUserGuide || PlayerManager.Instance.Self.IsWeakGuildFinish(Step.OLD_PLAYER))
         {
            return;
         }
         var secFr:SecondOnlineView = ComponentFactory.Instance.creat("trainer.second.mainFrame");
         if(CacheSysManager.isLock(CacheConsts.ALERT_IN_FIGHT))
         {
            CacheSysManager.getInstance().cache(CacheConsts.ALERT_IN_FIGHT,new AlertAction(secFr,LayerManager.GAME_UI_LAYER,LayerManager.ALPHA_BLOCKGOUND));
         }
         else
         {
            secFr.show();
         }
      }
      
      public function showFrame(level:int) : void
      {
         if(!WeakGuildManager.Instance.switchUserGuide || PlayerManager.Instance.Self.Grade == 1 || PlayerManager.Instance.Self.IsWeakGuildFinish(Step.OLD_PLAYER))
         {
            return;
         }
         this._fr = ComponentFactory.Instance.creatCustomObject("trainer.welcome.levelRewardFrame");
         this._fr.addEventListener(FrameEvent.RESPONSE,this.__onResponse);
         if(CacheSysManager.isLock(CacheConsts.ALERT_IN_FIGHT))
         {
            this._fr.level = level;
            CacheSysManager.getInstance().cache(CacheConsts.ALERT_IN_FIGHT,new AlertAction(this._fr,LayerManager.GAME_UI_LAYER,LayerManager.ALPHA_BLOCKGOUND));
         }
         else
         {
            this._fr.level = level;
            this._fr.show(level);
            this.isShow = true;
         }
      }
      
      public function hide() : void
      {
         if(Boolean(this._fr))
         {
            this._fr.removeEventListener(FrameEvent.RESPONSE,this.__onResponse);
            this._fr.hide();
            this._fr = null;
            this.isShow = false;
         }
      }
   }
}

