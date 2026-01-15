package worldBossHelper
{
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.UIModuleLoader;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.ServerConfigInfo;
   import ddt.data.UIModuleTypes;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.InviteManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.ServerConfigManager;
   import ddt.manager.SocketManager;
   import ddt.view.UIModuleSmallLoading;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import worldBossHelper.data.WorldBossHelperTypeData;
   import worldBossHelper.event.WorldBossHelperEvent;
   import worldBossHelper.view.WorldBossHelperFrame;
   
   public class WorldBossHelperManager extends EventDispatcher
   {
      
      private static var _instance:WorldBossHelperManager;
      
      private var _frame:WorldBossHelperFrame;
      
      public var data:WorldBossHelperTypeData;
      
      public var receieveData:Boolean;
      
      public var helperOpen:Boolean;
      
      public var isInWorldBossHelperFrame:Boolean;
      
      public var isHelperOnlyOnce:Boolean;
      
      public var isHelperInited:Boolean;
      
      private var _isFightOver:Boolean;
      
      public var isFighting:Boolean;
      
      private var _honor:int;
      
      public var allHonor:int;
      
      private var _money:int;
      
      public var allMoney:int;
      
      public var num:int;
      
      public var WorldBossAssistantTimeInfo1:ServerConfigInfo;
      
      public var WorldBossAssistantTimeInfo2:ServerConfigInfo;
      
      public var WorldBossAssistantTimeInfo3:ServerConfigInfo;
      
      public function WorldBossHelperManager()
      {
         super();
      }
      
      public static function get Instance() : WorldBossHelperManager
      {
         if(_instance == null)
         {
            _instance = new WorldBossHelperManager();
         }
         return _instance;
      }
      
      public function setup() : void
      {
         this.initData();
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.WORLDBOSS_PLAYERFIGHTASSIATANT,this.__playerInfoHandler);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.WORLDBOSS_ASSISTANT,this.__assistantHandler);
         addEventListener(WorldBossHelperEvent.BOSS_OPEN,this.__bossOpenHandler);
         UIModuleSmallLoading.Instance.progress = 0;
         UIModuleSmallLoading.Instance.show();
         UIModuleSmallLoading.Instance.addEventListener(Event.CLOSE,this._loadingCloseHandler);
         UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this._loaderCompleteHandler);
         UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this._loaderProgressHandler);
         UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.WORLDBOSS_HELPER);
      }
      
      private function initData() : void
      {
         this.isHelperInited = true;
         InviteManager.Instance.enabled = false;
         this.num = 1;
         this.isFighting = false;
         this.WorldBossAssistantTimeInfo1 = ServerConfigManager.instance.findInfoByName("WorldBossAssistantNormalTime");
         this.WorldBossAssistantTimeInfo2 = ServerConfigManager.instance.findInfoByName("WorldBossAssistantReviveTime");
         this.WorldBossAssistantTimeInfo3 = ServerConfigManager.instance.findInfoByName("WorldBossAssistantFastTime");
      }
      
      protected function __bossOpenHandler(event:WorldBossHelperEvent) : void
      {
         if(Boolean(this._frame))
         {
            this._frame.startFight();
         }
      }
      
      protected function __playerInfoHandler(event:CrazyTankSocketEvent) : void
      {
         this.isFighting = event.pkg.readBoolean();
         var count:int = event.pkg.readInt();
         var hurtArr:Array = new Array();
         for(var i:int = 0; i < count; i++)
         {
            hurtArr.push(event.pkg.readInt());
         }
         this._honor = event.pkg.readInt();
         this.allHonor += this._honor;
         this._money = event.pkg.readInt();
         this.allMoney += this._money;
         if(Boolean(this._frame))
         {
            this._frame.addPlayerInfo(true,this.num,hurtArr,this._honor);
         }
         ++this.num;
      }
      
      protected function __assistantHandler(event:CrazyTankSocketEvent) : void
      {
         this.data.isOpen = event.pkg.readBoolean();
         this.helperOpen = this.data.isOpen;
         this.data.buffNum = event.pkg.readInt();
         this.data.type = event.pkg.readInt();
         this.data.openType = event.pkg.readInt();
         if(this.data.openType == 0)
         {
            this.data.openType = 1;
         }
         if(Boolean(this._frame))
         {
            this._frame.updateView();
            return;
         }
         this._frame = ComponentFactory.Instance.creatComponentByStylename("worldBossHelperFrame");
         this._frame.titleText = LanguageMgr.GetTranslation("worldbosshelper.title");
         LayerManager.Instance.addToLayer(this._frame,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      protected function _loadingCloseHandler(event:Event) : void
      {
         this.closeLoading();
         UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this._loadingCloseHandler);
      }
      
      private function closeLoading() : void
      {
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this._loaderCompleteHandler);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this._loaderProgressHandler);
         UIModuleSmallLoading.Instance.hide();
      }
      
      protected function _loaderCompleteHandler(event:UIModuleEvent) : void
      {
         if(event.module == UIModuleTypes.WORLDBOSS_HELPER)
         {
            this.closeLoading();
            this.data = new WorldBossHelperTypeData();
            this.data.requestType = 1;
            SocketManager.Instance.out.openOrCloseWorldBossHelper(this.data);
         }
      }
      
      public function dispose() : void
      {
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.WORLDBOSS_ASSISTANT,this.__assistantHandler);
         this.data = null;
         if(Boolean(this._frame))
         {
            this.allMoney = 0;
            this.allHonor = 0;
            this.isHelperInited = false;
            ObjectUtils.disposeObject(this._frame);
            this._frame = null;
            this.isInWorldBossHelperFrame = false;
            SocketManager.Instance.out.quitWorldBossHelperView();
         }
         InviteManager.Instance.enabled = true;
      }
      
      protected function _loaderProgressHandler(event:UIModuleEvent) : void
      {
         UIModuleSmallLoading.Instance.progress = event.loader.progress * 100;
      }
   }
}

