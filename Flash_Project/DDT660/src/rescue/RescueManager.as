package rescue
{
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.LoadResourceManager;
   import com.pickgliss.loader.UIModuleLoader;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import ddt.data.UIModuleTypes;
   import ddt.loader.LoaderCreate;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.view.UIModuleSmallLoading;
   import flash.display.MovieClip;
   import flash.events.Event;
   import hall.HallStateView;
   import hallIcon.HallIconManager;
   import hallIcon.HallIconType;
   import rescue.data.RescueEvent;
   import rescue.data.RescueResultInfo;
   import rescue.data.RescueRewardAnalyzer;
   import rescue.views.RescueMainFrame;
   import rescue.views.RescueResultFrame;
   import road7th.comm.PackageIn;
   
   public class RescueManager
   {
      
      private static var _instance:RescueManager;
      
      public var _isBegin:Boolean;
      
      private var _hallView:HallStateView;
      
      private var _rescueIcon:MovieClip;
      
      private var _frame:RescueMainFrame;
      
      private var _resultFrame:RescueResultFrame;
      
      public var rewardArr:Array;
      
      public var isNoPrompt:Boolean;
      
      public var isBand:Boolean;
      
      public var curIndex:int;
      
      public function RescueManager()
      {
         super();
      }
      
      public static function get instance() : RescueManager
      {
         if(!_instance)
         {
            _instance = new RescueManager();
         }
         return _instance;
      }
      
      public function setup() : void
      {
         SocketManager.Instance.addEventListener(RescueEvent.IS_OPEN,this.__addRescueBtn);
         SocketManager.Instance.addEventListener(RescueEvent.FIGHT_RESULT,this.__fightResultHandler);
      }
      
      protected function __fightResultHandler(event:RescueEvent) : void
      {
         var pkg:PackageIn = event.pkg;
         var info:RescueResultInfo = new RescueResultInfo();
         info.score = pkg.readInt();
         info.star = pkg.readInt();
         info.sceneId = pkg.readInt();
         info.isWin = pkg.readBoolean();
         this._resultFrame = ComponentFactory.Instance.creatComponentByStylename("rescue.resultFrame");
         this._resultFrame.setData(info);
         LayerManager.Instance.addToLayer(this._resultFrame,LayerManager.GAME_TOP_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      protected function __addRescueBtn(event:RescueEvent) : void
      {
         var pkg:PackageIn = event.pkg;
         var flag:Boolean = pkg.readBoolean();
         this._isBegin = flag;
         this.createRescueBtn(this._isBegin);
      }
      
      public function createRescueBtn(flag:Boolean) : void
      {
         HallIconManager.instance.updateSwitchHandler(HallIconType.RESCUE,flag);
      }
      
      public function loadRewardXml() : void
      {
         var loader:BaseLoader = LoaderCreate.Instance.createRescueRewardLoader();
         LoadResourceManager.Instance.startLoad(loader);
      }
      
      public function setupRewardList(analyzer:RescueRewardAnalyzer) : void
      {
         this.rewardArr = analyzer.list;
      }
      
      public function show() : void
      {
         if(PlayerManager.Instance.Self.Grade < 20)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("rescue.gradeLimit"));
            return;
         }
         if(!this._frame)
         {
            UIModuleSmallLoading.Instance.progress = 0;
            UIModuleSmallLoading.Instance.show();
            UIModuleSmallLoading.Instance.addEventListener(Event.CLOSE,this.onSmallLoadingClose);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.createRescueMainFrame);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.onUIProgress);
            UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.RESCUE);
         }
         else
         {
            this._frame = ComponentFactory.Instance.creatComponentByStylename("rescue.rescueMainView");
            LayerManager.Instance.addToLayer(this._frame,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
         }
      }
      
      protected function onSmallLoadingClose(event:Event) : void
      {
         UIModuleSmallLoading.Instance.hide();
         UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.onSmallLoadingClose);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.createRescueMainFrame);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.onUIProgress);
      }
      
      protected function createRescueMainFrame(event:UIModuleEvent) : void
      {
         if(event.module != UIModuleTypes.RESCUE)
         {
            return;
         }
         UIModuleSmallLoading.Instance.hide();
         UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.onSmallLoadingClose);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.createRescueMainFrame);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.onUIProgress);
         this._frame = ComponentFactory.Instance.creatComponentByStylename("rescue.rescueMainView");
         LayerManager.Instance.addToLayer(this._frame,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      protected function onUIProgress(event:UIModuleEvent) : void
      {
         if(event.module == UIModuleTypes.RESCUE)
         {
            UIModuleSmallLoading.Instance.progress = event.loader.progress * 100;
         }
      }
      
      public function get rescueIcon() : MovieClip
      {
         return this._rescueIcon;
      }
   }
}

