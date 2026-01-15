package dragonBoat
{
   import GodSyah.GodSyahPackageType;
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.LoadResourceManager;
   import com.pickgliss.loader.LoaderEvent;
   import com.pickgliss.loader.UIModuleLoader;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.UIModuleTypes;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.loader.StartupResourceLoader;
   import ddt.manager.ItemManager;
   import ddt.manager.PathManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SharedManager;
   import ddt.manager.SocketManager;
   import ddt.view.UIModuleSmallLoading;
   import dragonBoat.data.DragonBoatActiveInfo;
   import dragonBoat.data.DragonBoatAwardInfo;
   import dragonBoat.dataAnalyzer.DragonBoatActiveDataAnalyzer;
   import dragonBoat.view.DragonBoatEntryBtn;
   import dragonBoat.view.DragonBoatFrame;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import hall.player.HallPlayerView;
   import road7th.comm.PackageIn;
   
   public class DragonBoatManager extends EventDispatcher
   {
      
      private static var _instance:DragonBoatManager;
      
      public static const BTNID_DRAGONBOAT:int = 100;
      
      public static const END_UPDATE:String = "DragonBoatEndUpdate";
      
      public static const BOAT_RES_LOAD_COMPLETE:String = "DragonBoatBoatResLoadComplete";
      
      public static const BUILD_OR_DECORATE_UPDATE:String = "DragonBoatBuildOrDecorateUpdate";
      
      public static const REFRESH_BOAT_STATUS:String = "DragonBoatRefreshBoatStatus";
      
      public static const UPDATE_RANK_INFO:String = "DragBoatUpdateRankInfo";
      
      public static const DRAGONBOAT_CHIP:int = 11771;
      
      public static const KINGSTATUE_CHIP:int = 11771;
      
      public static const LINSHI_CHIP:int = 201309;
      
      private var _scoreRank:int;
      
      private var _scoreUse:int;
      
      private var _completeStatus:int;
      
      private var _func:Function;
      
      private var _funcParams:Array;
      
      private var _activeInfo:DragonBoatActiveInfo;
      
      private var _boatExpList:Array = [];
      
      private var _awardsListSelf:Array = [];
      
      private var _awardsListOther:Array = [];
      
      private var _awardsInfoSelf:Object = {};
      
      private var _awardsInfoOther:Object = {};
      
      private var _boatCompleteExp:int;
      
      private var _useableScore:int;
      
      private var _totalScore:int;
      
      private var _periodType:int = 0;
      
      private var _isLoadBoatResComplete:Boolean;
      
      private var _isLoadFrameResComplete:Boolean;
      
      private var _isHadOpenedFrame:Boolean;
      
      private var _entryBtn:DragonBoatEntryBtn;
      
      public function DragonBoatManager(target:IEventDispatcher = null)
      {
         super(target);
      }
      
      public static function get instance() : DragonBoatManager
      {
         if(_instance == null)
         {
            _instance = new DragonBoatManager();
         }
         return _instance;
      }
      
      public function get activeInfo() : DragonBoatActiveInfo
      {
         return this._activeInfo;
      }
      
      public function get boatCompleteStatus() : int
      {
         var tmp:int = this._boatCompleteExp * 100 / this._boatExpList[this._boatExpList.length - 1];
         return tmp > 100 ? 100 : tmp;
      }
      
      public function get boatInWhatStatus() : int
      {
         var tmpLen:int = int(this._boatExpList.length);
         var tmpIndex:int = 1;
         for(var i:int = tmpLen - 1; i >= 0; i--)
         {
            if(this._boatCompleteExp >= this._boatExpList[i])
            {
               tmpIndex = i + 1;
               break;
            }
         }
         return tmpIndex;
      }
      
      public function get isBuildEnd() : Boolean
      {
         if(this._boatCompleteExp > 0 && this.periodType == 2)
         {
            return true;
         }
         return false;
      }
      
      public function get useableScore() : int
      {
         return this._useableScore;
      }
      
      public function get totalScore() : int
      {
         return this._totalScore;
      }
      
      public function get isStart() : Boolean
      {
         return this._periodType == 1 || this._periodType == 2;
      }
      
      public function get periodType() : int
      {
         return this._periodType;
      }
      
      public function get isCanBuildOrDecorate() : Boolean
      {
         return this._periodType == 1;
      }
      
      public function get isLoadBoatResComplete() : Boolean
      {
         return this._isLoadBoatResComplete;
      }
      
      public function templateDataSetup(analyzer:DragonBoatActiveDataAnalyzer) : void
      {
         this._activeInfo = analyzer.data;
         this._boatExpList = analyzer.dataList;
         this._awardsListSelf = analyzer.dataListSelf;
         this._awardsListOther = analyzer.dataListOther;
      }
      
      public function getAwardInfoByRank(type:int, rank:int) : Array
      {
         var _awardsInfo:DragonBoatAwardInfo = null;
         var _awardsInfo2:DragonBoatAwardInfo = null;
         var itemInfoArr:Array = [];
         if(type == 1)
         {
            if(Boolean(this._awardsInfoSelf[rank]))
            {
               return this._awardsInfoSelf[rank] as Array;
            }
            for each(_awardsInfo in this._awardsListSelf)
            {
               if(_awardsInfo.RandID == rank)
               {
                  itemInfoArr.push(this.createInventoryItemInfo(_awardsInfo));
               }
            }
            this._awardsInfoSelf[rank] = itemInfoArr;
         }
         else
         {
            if(Boolean(this._awardsInfoOther[rank]))
            {
               return this._awardsInfoOther[rank] as Array;
            }
            for each(_awardsInfo2 in this._awardsListOther)
            {
               if(_awardsInfo2.RandID == rank)
               {
                  itemInfoArr.push(this.createInventoryItemInfo(_awardsInfo2));
               }
            }
            this._awardsInfoOther[rank] = itemInfoArr;
         }
         itemInfoArr.sortOn("TemplateID",Array.NUMERIC);
         return itemInfoArr;
      }
      
      private function createInventoryItemInfo(tmpData:DragonBoatAwardInfo) : InventoryItemInfo
      {
         var itemInfo:InventoryItemInfo = new InventoryItemInfo();
         itemInfo.TemplateID = tmpData.TemplateID;
         ItemManager.fill(itemInfo);
         itemInfo.StrengthenLevel = tmpData.StrengthenLevel;
         itemInfo.AttackCompose = tmpData.AttackCompose;
         itemInfo.DefendCompose = tmpData.DefendCompose;
         itemInfo.LuckCompose = tmpData.LuckCompose;
         itemInfo.AgilityCompose = tmpData.AgilityCompose;
         itemInfo.IsBinds = tmpData.IsBind;
         itemInfo.ValidDate = tmpData.ValidDate;
         itemInfo.Count = tmpData.Count;
         return itemInfo;
      }
      
      public function setup() : void
      {
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.DRAGON_BOAT,this.pkgHandler);
      }
      
      private function pkgHandler(event:CrazyTankSocketEvent) : void
      {
         var pkg:PackageIn = event.pkg;
         var cmd:int = pkg.readByte();
         switch(cmd)
         {
            case DragonBoatPackageType.START_OR_CLOSE:
               this.openOrClose(pkg);
               break;
            case DragonBoatPackageType.BUILD_DECORATE:
               this.buildOrDecorate(pkg);
               break;
            case DragonBoatPackageType.REFRESH_BOAT_STATUS:
               this.refreshBoatStatus(pkg);
               break;
            case DragonBoatPackageType.REFRESH_RANK:
               this.updateSelfRank(pkg);
               break;
            case DragonBoatPackageType.REFRESH_RANK_OTHER:
               this.updateOtherRank(pkg);
               break;
            case GodSyahPackageType.GODSYAH_TEMPORARILY_POWER:
               StartupResourceLoader.Instance.reloadGodSyah(pkg);
         }
      }
      
      private function updateSelfRank(pkg:PackageIn) : void
      {
         var obj:Object = null;
         var count:int = pkg.readInt();
         var dataList:Array = [];
         for(var i:int = 0; i < count; i++)
         {
            obj = {};
            obj.rank = pkg.readInt();
            obj.score = pkg.readInt();
            obj.name = pkg.readUTF();
            obj.itemInfoArr = this.getAwardInfoByRank(1,obj.rank);
            dataList.push(obj);
         }
         var myRank:int = pkg.readInt();
         var lessScore:int = pkg.readInt();
         var newEvent:DragonBoatEvent = new DragonBoatEvent(UPDATE_RANK_INFO);
         newEvent.tag = 1;
         newEvent.data = {
            "dataList":dataList,
            "myRank":myRank,
            "lessScore":lessScore
         };
         dispatchEvent(newEvent);
      }
      
      private function updateOtherRank(pkg:PackageIn) : void
      {
         var obj:Object = null;
         var count:int = pkg.readInt();
         var dataList:Array = [];
         for(var i:int = 0; i < count; i++)
         {
            obj = {};
            obj.rank = pkg.readInt();
            obj.score = pkg.readInt();
            obj.name = pkg.readUTF();
            obj.zone = pkg.readUTF();
            obj.itemInfoArr = this.getAwardInfoByRank(2,obj.rank);
            dataList.push(obj);
         }
         var myRank:int = pkg.readInt();
         var lessScore:int = pkg.readInt();
         var newEvent:DragonBoatEvent = new DragonBoatEvent(UPDATE_RANK_INFO);
         newEvent.tag = 2;
         newEvent.data = {
            "dataList":dataList,
            "myRank":myRank,
            "lessScore":lessScore
         };
         dispatchEvent(newEvent);
      }
      
      private function openOrClose(pkg:PackageIn) : void
      {
         var loader:BaseLoader = null;
         var type:int = pkg.readInt();
         this._periodType = pkg.readInt();
         if(this.isStart)
         {
            this._boatCompleteExp = pkg.readInt();
            this._isLoadBoatResComplete = false;
            loader = LoadResourceManager.Instance.createLoader(PathManager.getUIPath() + "/swf/dragonboatboatres.swf",BaseLoader.MODULE_LOADER);
            loader.addEventListener(LoaderEvent.COMPLETE,this.onLoadComplete);
            LoadResourceManager.Instance.startLoad(loader);
         }
         else
         {
            this.disposeEntryBtn();
            dispatchEvent(new Event(END_UPDATE));
         }
      }
      
      private function onLoadComplete(event:LoaderEvent) : void
      {
         event.loader.removeEventListener(LoaderEvent.COMPLETE,this.onLoadComplete);
         this._isLoadBoatResComplete = true;
         dispatchEvent(new Event(BOAT_RES_LOAD_COMPLETE));
         this._isLoadFrameResComplete = false;
         UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.loadPreResCompleteHandler,false,-1);
         UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.DRAGON_BOAT);
      }
      
      private function loadPreResCompleteHandler(event:UIModuleEvent) : void
      {
         if(event.module == UIModuleTypes.DRAGON_BOAT)
         {
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.loadPreResCompleteHandler);
            this._isLoadFrameResComplete = true;
         }
      }
      
      private function autoOpenFrame() : void
      {
         var frame:DragonBoatFrame = null;
         if(!this._isHadOpenedFrame && !SharedManager.Instance.isDragonBoatOpenFrame && this.isStart && PlayerManager.Instance.Self.Grade >= this.activeInfo.LimitGrade)
         {
            frame = ComponentFactory.Instance.creatComponentByStylename("DragonBoatFrame");
            frame.init2(this._activeInfo.ActiveID);
            LayerManager.Instance.addToLayer(frame,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
         }
      }
      
      public function setOpenFrameParam() : void
      {
         this._isHadOpenedFrame = true;
         if(!SharedManager.Instance.isDragonBoatOpenFrame)
         {
            SharedManager.Instance.isDragonBoatOpenFrame = true;
            SharedManager.Instance.save();
         }
      }
      
      public function enterMainOpenFrame() : void
      {
         if(this._isLoadFrameResComplete)
         {
            this.autoOpenFrame();
         }
      }
      
      private function buildOrDecorate(pkg:PackageIn) : void
      {
         this._useableScore = pkg.readInt();
         this._totalScore = pkg.readInt();
         dispatchEvent(new Event(BUILD_OR_DECORATE_UPDATE));
      }
      
      private function refreshBoatStatus(pkg:PackageIn) : void
      {
         this._boatCompleteExp = pkg.readInt();
         dispatchEvent(new Event(REFRESH_BOAT_STATUS));
      }
      
      public function loadUIModule(complete:Function = null, completeParams:Array = null) : void
      {
         this._func = complete;
         this._funcParams = completeParams;
         UIModuleSmallLoading.Instance.progress = 0;
         UIModuleSmallLoading.Instance.show();
         UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.loadCompleteHandler);
         UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.onUimoduleLoadProgress);
         UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.DRAGON_BOAT);
      }
      
      private function onUimoduleLoadProgress(event:UIModuleEvent) : void
      {
         if(event.module == UIModuleTypes.DRAGON_BOAT)
         {
            UIModuleSmallLoading.Instance.progress = event.loader.progress * 100;
         }
      }
      
      private function loadCompleteHandler(event:UIModuleEvent) : void
      {
         if(event.module == UIModuleTypes.DRAGON_BOAT)
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
      
      public function doOpenDragonBoatFrame() : void
      {
         var frame:DragonBoatFrame = ComponentFactory.Instance.creatComponentByStylename("DragonBoatFrame");
         frame.init2(this._activeInfo.ActiveID);
         LayerManager.Instance.addToLayer(frame,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      public function createEntryBtn(hallPlayerView:HallPlayerView) : void
      {
         this._entryBtn = new DragonBoatEntryBtn(hallPlayerView);
         hallPlayerView.touchArea.addChild(this._entryBtn);
         hallPlayerView.hallView.addChild(this._entryBtn.content);
      }
      
      public function disposeEntryBtn() : void
      {
         ObjectUtils.disposeObject(this._entryBtn);
         this._entryBtn = null;
      }
   }
}

