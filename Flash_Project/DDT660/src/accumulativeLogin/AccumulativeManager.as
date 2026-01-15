package accumulativeLogin
{
   import accumulativeLogin.view.AccumulativeLoginView;
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.UIModuleLoader;
   import ddt.data.UIModuleTypes;
   import ddt.data.player.SelfInfo;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.view.UIModuleSmallLoading;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import flash.utils.Dictionary;
   import hallIcon.HallIconManager;
   import hallIcon.HallIconType;
   import road7th.comm.PackageIn;
   
   public class AccumulativeManager extends EventDispatcher
   {
      
      private static var _instance:AccumulativeManager;
      
      public static const ACCUMULATIVE_AWARD_REFRESH:String = "accumulativeLoginAwardRefresh";
      
      public var dataDic:Dictionary;
      
      public function AccumulativeManager(target:IEventDispatcher = null)
      {
         super(target);
      }
      
      public static function get instance() : AccumulativeManager
      {
         if(_instance == null)
         {
            _instance = new AccumulativeManager();
         }
         return _instance;
      }
      
      public function setup() : void
      {
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.ACCUMULATIVELOGIN_AWARD,this.__awardHandler);
      }
      
      protected function __awardHandler(event:CrazyTankSocketEvent) : void
      {
         var pkg:PackageIn = event.pkg;
         var self:SelfInfo = PlayerManager.Instance.Self;
         self.accumulativeLoginDays = pkg.readInt();
         self.accumulativeAwardDays = pkg.readInt();
         dispatchEvent(new Event(ACCUMULATIVE_AWARD_REFRESH));
      }
      
      public function addAct() : void
      {
         if(PlayerManager.Instance.Self.Grade >= 10)
         {
            HallIconManager.instance.updateSwitchHandler(HallIconType.ACCUMULATIVE_LOGIN,true);
         }
         else
         {
            HallIconManager.instance.executeCacheRightIconLevelLimit(HallIconType.ACCUMULATIVE_LOGIN,true,10);
         }
      }
      
      public function removeAct() : void
      {
         HallIconManager.instance.updateSwitchHandler(HallIconType.ACCUMULATIVE_LOGIN,false);
         HallIconManager.instance.executeCacheRightIconLevelLimit(HallIconType.ACCUMULATIVE_LOGIN,false);
      }
      
      public function loadTempleteDataComplete(analyzer:AccumulativeLoginAnalyer) : void
      {
         this.dataDic = analyzer.accumulativeloginDataDic;
      }
      
      public function showFrame() : void
      {
         SoundManager.instance.play("008");
         UIModuleSmallLoading.Instance.progress = 0;
         UIModuleSmallLoading.Instance.show();
         UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.loadCompleteHandler);
         UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.onUimoduleLoadProgress);
         UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.WONDERFULACTIVI);
      }
      
      private function onUimoduleLoadProgress(event:UIModuleEvent) : void
      {
         if(event.module == UIModuleTypes.WONDERFULACTIVI)
         {
            UIModuleSmallLoading.Instance.progress = event.loader.progress * 100;
         }
      }
      
      private function loadCompleteHandler(event:UIModuleEvent) : void
      {
         var _view:AccumulativeLoginView = null;
         if(event.module == UIModuleTypes.WONDERFULACTIVI)
         {
            UIModuleSmallLoading.Instance.hide();
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.loadCompleteHandler);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.onUimoduleLoadProgress);
            _view = new AccumulativeLoginView();
            _view.init();
            _view.x = -227;
            HallIconManager.instance.showCommonFrame(_view,"wonderfulActivityManager.btnTxt15");
         }
      }
   }
}

