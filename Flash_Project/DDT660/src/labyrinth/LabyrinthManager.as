package labyrinth
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.LoadResourceManager;
   import com.pickgliss.loader.UIModuleLoader;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.UIModuleTypes;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.events.GameEvent;
   import ddt.events.RoomEvent;
   import ddt.manager.GameInSocketOut;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PathManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.StateManager;
   import ddt.states.StateType;
   import ddt.utils.PositionUtils;
   import ddt.view.UIModuleSmallLoading;
   import ddtBuried.BuriedEvent;
   import ddtBuried.BuriedManager;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import flash.net.URLVariables;
   import game.GameManager;
   import game.model.MissionAgainInfo;
   import labyrinth.data.CleanOutInfo;
   import labyrinth.data.LabyrinthModel;
   import labyrinth.data.LabyrinthPackageType;
   import labyrinth.data.RankingAnalyzer;
   import labyrinth.view.LabyrinthFrame;
   import labyrinth.view.LabyrinthTryAgain;
   import road7th.comm.PackageIn;
   import room.RoomManager;
   import room.model.RoomInfo;
   
   public class LabyrinthManager extends EventDispatcher
   {
      
      private static var _instance:LabyrinthManager;
      
      public static const UPDATE_INFO:String = "updateInfo";
      
      public static const UPDATE_REMAIN_TIME:String = "updateRemainTime";
      
      public static const RANKING_LOAD_COMPLETE:String = "rankingLoadComplete";
      
      public static const LABYRINTH_CHAT:String = "LabyrinthChat";
      
      private var _UILoadComplete:Boolean = false;
      
      private var _loadProgress:int = 0;
      
      private var labyrinthFrame:LabyrinthFrame;
      
      private var _model:LabyrinthModel;
      
      public var buyFrameEnable:Boolean = true;
      
      private var tryagain:LabyrinthTryAgain;
      
      private var _callback:Function;
      
      public function LabyrinthManager(target:IEventDispatcher = null)
      {
         super(target);
         this._model = new LabyrinthModel();
         this.initEvent();
      }
      
      public static function get Instance() : LabyrinthManager
      {
         if(_instance == null)
         {
            _instance = new LabyrinthManager();
         }
         return _instance;
      }
      
      private function initEvent() : void
      {
         GameManager.Instance.addEventListener(GameManager.START_LOAD,this.__startLoading);
         RoomManager.Instance.addEventListener(RoomEvent.START_LABYRINTH,this.__sendStart);
         SocketManager.Instance.addEventListener(LabyrinthPackageType.REQUEST_UPDATE_EVENT,this.__onUpdataInfo);
         SocketManager.Instance.addEventListener(LabyrinthPackageType.PUSH_CLEAN_OUT_INFO_EVENT,this.__onUpdataCleanOutInfo);
         SocketManager.Instance.addEventListener(LabyrinthPackageType.CLEAN_OUT_EVENT,this.__onRemainCleanOutTime);
         SocketManager.Instance.addEventListener(LabyrinthPackageType.TRY_AGAIN_EVENT,this.__onTryAgain);
      }
      
      protected function __onTryAgain(event:CrazyTankSocketEvent) : void
      {
         var missionAgain:MissionAgainInfo = new MissionAgainInfo();
         missionAgain.value = event.pkg.readInt();
         missionAgain.host = PlayerManager.Instance.Self.NickName;
         this.tryagain = new LabyrinthTryAgain(missionAgain,false);
         PositionUtils.setPos(this.tryagain,"dt.labyrinth.LabyrinthFrame.TryAgainPos");
         this.tryagain.addEventListener(GameEvent.TRYAGAIN,this.__tryAgain);
         this.tryagain.addEventListener(GameEvent.GIVEUP,this.__giveup);
         LayerManager.Instance.addToLayer(this.tryagain,LayerManager.GAME_DYNAMIC_LAYER,false,LayerManager.ALPHA_BLOCKGOUND);
         this.hideLabyrinthFrame();
      }
      
      protected function __giveup(event:GameEvent) : void
      {
         SocketManager.Instance.out.labyrinthTryAgain(false,event.data);
         this.disposeTryAgain();
         this._model.tryAgainComplete = false;
      }
      
      protected function __tryAgain(event:GameEvent) : void
      {
         SocketManager.Instance.out.labyrinthTryAgain(true,event.data);
         this.disposeTryAgain();
         this._model.tryAgainComplete = true;
      }
      
      private function disposeTryAgain() : void
      {
         this.tryagain.removeEventListener(GameEvent.TRYAGAIN,this.__tryAgain);
         this.tryagain.removeEventListener(GameEvent.GIVEUP,this.__giveup);
         ObjectUtils.disposeObject(this.tryagain);
         this.tryagain = null;
      }
      
      protected function __onRemainCleanOutTime(event:CrazyTankSocketEvent) : void
      {
         var pkg:PackageIn = event.pkg;
         this._model.remainTime = pkg.readInt();
         this._model.currentRemainTime = pkg.readInt();
         dispatchEvent(new Event(UPDATE_REMAIN_TIME));
      }
      
      protected function __onUpdataCleanOutInfo(event:CrazyTankSocketEvent) : void
      {
         var obj:Object = null;
         var pkg:PackageIn = event.pkg;
         var info:CleanOutInfo = new CleanOutInfo();
         info.FamRaidLevel = pkg.readInt();
         info.exp = pkg.readInt();
         var len:int = pkg.readInt();
         for(var i:int = 0; i < len; i++)
         {
            obj = new Object();
            obj["TemplateID"] = pkg.readInt();
            obj["num"] = pkg.readInt();
            info.TemplateIDs.push(obj);
         }
         info.HardCurrency = pkg.readInt();
         if(Boolean(this._model.cleanOutInfos[info.FamRaidLevel]))
         {
            this._model.cleanOutInfos.remove(info.FamRaidLevel);
            delete this._model.cleanOutInfos[info.FamRaidLevel];
         }
         this._model.cleanOutInfos.add(info.FamRaidLevel,info);
      }
      
      protected function __onUpdataInfo(event:CrazyTankSocketEvent) : void
      {
         var pkg:PackageIn = event.pkg;
         this._model.myProgress = pkg.readInt();
         this._model.currentFloor = pkg.readInt();
         this._model.completeChallenge = pkg.readBoolean();
         this._model.remainTime = pkg.readInt();
         this._model.accumulateExp = pkg.readInt();
         this._model.cleanOutAllTime = pkg.readInt();
         this._model.cleanOutGold = pkg.readInt();
         this._model.myRanking = pkg.readInt();
         this._model.isDoubleAward = pkg.readBoolean();
         this._model.isInGame = pkg.readBoolean();
         this._model.isCleanOut = pkg.readBoolean();
         this._model.serverMultiplyingPower = pkg.readBoolean();
         dispatchEvent(new Event(UPDATE_INFO));
      }
      
      protected function __sendStart(event:Event) : void
      {
         GameInSocketOut.sendGameStart();
      }
      
      protected function __startLoading(e:Event) : void
      {
         if(Boolean(RoomManager.Instance.current) && RoomManager.Instance.current.type == RoomInfo.LANBYRINTH_ROOM)
         {
            StateManager.getInGame_Step_6 = true;
            if(GameManager.Instance.Current == null)
            {
               return;
            }
            LayerManager.Instance.clearnGameDynamic();
            StateManager.setState(StateType.ROOM_LOADING,GameManager.Instance.Current);
            StateManager.getInGame_Step_7 = true;
         }
      }
      
      public function enterGame() : void
      {
         SocketManager.Instance.out.enterUserGuide(0,RoomInfo.LANBYRINTH_ROOM);
      }
      
      public function show() : void
      {
         this._callback = this.show;
         if(this._UILoadComplete)
         {
            this.labyrinthFrame = ComponentFactory.Instance.creatCustomObject("labyrinth.labyrinthFrame");
            this.labyrinthFrame.show();
            this.labyrinthFrame.addEventListener(FrameEvent.RESPONSE,this.__labyrinthFrameEvent);
         }
         else
         {
            this.loadUIModule();
         }
      }
      
      public function get model() : LabyrinthModel
      {
         return this._model;
      }
      
      public function set model(value:LabyrinthModel) : void
      {
         this._model = value;
      }
      
      protected function __labyrinthFrameEvent(event:FrameEvent) : void
      {
         SoundManager.instance.playButtonSound();
         if(event.responseCode == FrameEvent.ESC_CLICK || event.responseCode == FrameEvent.CLOSE_CLICK || event.responseCode == FrameEvent.CANCEL_CLICK)
         {
            this.hideLabyrinthFrame();
         }
      }
      
      private function hideLabyrinthFrame() : void
      {
         if(Boolean(this.labyrinthFrame))
         {
            this.labyrinthFrame.removeEventListener(FrameEvent.RESPONSE,this.__labyrinthFrameEvent);
            this.labyrinthFrame.dispose();
            this.labyrinthFrame = null;
         }
      }
      
      public function loadRankingList() : void
      {
         var args:URLVariables = new URLVariables();
         args["id"] = PlayerManager.Instance.Self.ID;
         var loader:BaseLoader = LoadResourceManager.Instance.creatAndStartLoad(PathManager.solveRequestPath("WarriorFamRankList.xml"),BaseLoader.TEXT_LOADER,args);
         loader.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.LoadingWarriorFamRankListFailure");
         loader.analyzer = new RankingAnalyzer(this.openRankingFrame);
      }
      
      private function openRankingFrame(action:RankingAnalyzer) : void
      {
         this._model.rankingList = action.list;
         dispatchEvent(new Event(RANKING_LOAD_COMPLETE));
      }
      
      public function loadUIModule() : void
      {
         if(!this._UILoadComplete)
         {
            UIModuleSmallLoading.Instance.progress = 0;
            UIModuleSmallLoading.Instance.show();
            UIModuleSmallLoading.Instance.addEventListener(Event.CLOSE,this.__onClose);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__onUIModuleComplete);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__onProgress);
            UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.LABYRINTH);
            UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.DDTSHOP);
         }
      }
      
      protected function __onProgress(event:UIModuleEvent) : void
      {
         UIModuleSmallLoading.Instance.progress = event.loader.progress * 100;
      }
      
      protected function __onUIModuleComplete(event:UIModuleEvent) : void
      {
         if(event.module == UIModuleTypes.LABYRINTH || event.module == UIModuleTypes.DDTSHOP)
         {
            ++this._loadProgress;
            if(this._loadProgress >= 2)
            {
               this._UILoadComplete = true;
            }
         }
         if(this._UILoadComplete)
         {
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__onUIModuleComplete);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__onProgress);
            UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__onClose);
            UIModuleSmallLoading.Instance.hide();
            if(this._callback != null)
            {
               this._callback();
            }
            BuriedManager.evnetDispatch.dispatchEvent(new BuriedEvent(BuriedEvent.LABYRINTH_OVER));
         }
      }
      
      public function get UILoadComplete() : Boolean
      {
         return this._UILoadComplete;
      }
      
      protected function __onClose(event:Event) : void
      {
         UIModuleSmallLoading.Instance.hide();
         UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__onClose);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__onUIModuleComplete);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__onProgress);
      }
      
      public function chat() : void
      {
         dispatchEvent(new Event(LABYRINTH_CHAT));
      }
   }
}

