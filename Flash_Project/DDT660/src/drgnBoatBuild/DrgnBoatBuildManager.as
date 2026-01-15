package drgnBoatBuild
{
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.LoadResourceManager;
   import com.pickgliss.loader.UIModuleLoader;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.utils.MD5;
   import ddt.data.UIModuleTypes;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PathManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.view.UIModuleSmallLoading;
   import drgnBoatBuild.data.DrgnBoatBuildCellInfo;
   import drgnBoatBuild.data.DrgnBoatBuildEvent;
   import drgnBoatBuild.data.DrgnBoatFriendsAnalyzer;
   import drgnBoatBuild.views.DrgnBoatBuildFrame;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.net.URLVariables;
   import hall.player.HallPlayerView;
   import road7th.comm.PackageIn;
   
   public class DrgnBoatBuildManager extends EventDispatcher
   {
      
      private static var _instance:DrgnBoatBuildManager;
      
      private var _playerView:HallPlayerView;
      
      private var _btn:BaseButton;
      
      private var _frame:DrgnBoatBuildFrame;
      
      private var buildingStage:int;
      
      private var progress:int;
      
      private var building:MovieClip;
      
      public var friendStateList:Array;
      
      public var isMcPlay:Boolean;
      
      public var selectedId:int;
      
      public function DrgnBoatBuildManager()
      {
         super();
      }
      
      public static function get instance() : DrgnBoatBuildManager
      {
         if(!_instance)
         {
            _instance = new DrgnBoatBuildManager();
         }
         return _instance;
      }
      
      public function setup(view:HallPlayerView, btn:BaseButton) : void
      {
         this._playerView = view;
         this._btn = btn;
         this._btn.visible = false;
      }
      
      public function addToHall() : void
      {
         this._btn.visible = true;
         if(Boolean(this.building) && Boolean(this.building.parent))
         {
            this.building.parent.removeChild(this.building);
         }
         this.building = ComponentFactory.Instance.creat("asset.hall.drgnBoatBuildingMC");
         if(this._playerView && this._playerView.hallView && Boolean(this._playerView.hallView.getChildByName("drgnBoatBuilding")))
         {
            (this._playerView.hallView.getChildByName("drgnBoatBuilding") as MovieClip).addChild(this.building);
         }
         this.building.gotoAndStop(this.buildingStage + 1);
      }
      
      public function removeFromHall() : void
      {
         this._btn.visible = false;
         if(Boolean(this.building) && Boolean(this.building.parent))
         {
            this.building.parent.removeChild(this.building);
         }
         this.building = null;
      }
      
      public function initBuildingStatus(pkg:PackageIn) : void
      {
         this.buildingStage = pkg.readInt();
         this.progress = pkg.readInt();
         if(Boolean(this.building))
         {
            this.building.gotoAndStop(this.buildingStage + 1);
         }
      }
      
      public function updateBuildInfo(pkg:PackageIn) : void
      {
         var info:DrgnBoatBuildCellInfo = new DrgnBoatBuildCellInfo();
         info.id = pkg.readInt();
         info.stage = pkg.readInt();
         info.progress = pkg.readInt();
         if(info.id == PlayerManager.Instance.Self.ID)
         {
            this.buildingStage = info.stage;
            this.progress = info.progress;
            if(Boolean(this.building))
            {
               this.building.gotoAndStop(this.buildingStage + 1);
            }
         }
         var event:DrgnBoatBuildEvent = new DrgnBoatBuildEvent(DrgnBoatBuildEvent.UPDATE_VIEW);
         event.info = info;
         dispatchEvent(event);
      }
      
      public function receiveCommitResult(pkg:PackageIn) : void
      {
         this.isMcPlay = pkg.readBoolean();
         if(this.isMcPlay)
         {
            SocketManager.Instance.out.updateDrgnBoatBuildInfo();
         }
      }
      
      public function receiveHelpToBuild(pkg:PackageIn) : void
      {
         var result:Boolean = pkg.readBoolean();
         var id:int = pkg.readInt();
         if(result)
         {
            SocketManager.Instance.out.updateDrgnBoatBuildInfo(id);
         }
      }
      
      public function updateDrgnBoatFriendList() : void
      {
         var args:URLVariables = new URLVariables();
         args["selfid"] = PlayerManager.Instance.Self.ID;
         args["key"] = MD5.hash(PlayerManager.Instance.Account.Password);
         args["rnd"] = Math.random();
         var loader:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("DragonBoatFriendInfos.ashx"),BaseLoader.REQUEST_LOADER,args);
         loader.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.LoadingDrgnBoatFriendListFailure");
         loader.analyzer = new DrgnBoatFriendsAnalyzer(this.setupFriendList);
         LoadResourceManager.Instance.startLoad(loader);
      }
      
      public function setupFriendList(analyzer:DrgnBoatFriendsAnalyzer) : void
      {
         this.friendStateList = analyzer.list;
         dispatchEvent(new DrgnBoatBuildEvent(DrgnBoatBuildEvent.UPDATE_FRIEND_LIST));
      }
      
      public function onShow() : void
      {
         if(!this._frame)
         {
            UIModuleSmallLoading.Instance.progress = 0;
            UIModuleSmallLoading.Instance.show();
            UIModuleSmallLoading.Instance.addEventListener(Event.CLOSE,this.onSmallLoadingClose);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.createDrgnBoatBuildFrame);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.onUIProgress);
            UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.DRGN_BOAT_BUILD);
         }
         else
         {
            this._frame = ComponentFactory.Instance.creatComponentByStylename("drgnBoatBuild.DrgnBoatBuildFrame");
            LayerManager.Instance.addToLayer(this._frame,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
         }
      }
      
      protected function onSmallLoadingClose(event:Event) : void
      {
         UIModuleSmallLoading.Instance.hide();
         UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.onSmallLoadingClose);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.createDrgnBoatBuildFrame);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.onUIProgress);
      }
      
      protected function onUIProgress(event:UIModuleEvent) : void
      {
         if(event.module == UIModuleTypes.DRGN_BOAT_BUILD)
         {
            UIModuleSmallLoading.Instance.progress = event.loader.progress * 100;
         }
      }
      
      protected function createDrgnBoatBuildFrame(event:UIModuleEvent) : void
      {
         if(event.module != UIModuleTypes.DRGN_BOAT_BUILD)
         {
            return;
         }
         UIModuleSmallLoading.Instance.hide();
         UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.onSmallLoadingClose);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.createDrgnBoatBuildFrame);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.onUIProgress);
         this._frame = ComponentFactory.Instance.creatComponentByStylename("drgnBoatBuild.DrgnBoatBuildFrame");
         LayerManager.Instance.addToLayer(this._frame,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      public function set frame(value:DrgnBoatBuildFrame) : void
      {
         this._frame = value;
      }
   }
}

