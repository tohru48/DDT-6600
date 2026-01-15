package eliteGame
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.LoadResourceManager;
   import com.pickgliss.loader.LoaderEvent;
   import com.pickgliss.loader.UIModuleLoader;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.UIModuleTypes;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.GameInSocketOut;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PathManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.StateManager;
   import ddt.states.StateType;
   import ddt.view.UIModuleSmallLoading;
   import eliteGame.analyze.EliteGameAwardAnalyer;
   import eliteGame.analyze.EliteGameScoreRankAnalyer;
   import eliteGame.info.EliteGameTopSixteenInfo;
   import eliteGame.view.EliteGamePaarungFrame;
   import eliteGame.view.EliteGamePreview;
   import eliteGame.view.EliteGameReadyFrame;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.TimerEvent;
   import flash.net.URLVariables;
   import flash.utils.Timer;
   import road7th.comm.PackageIn;
   import road7th.data.DictionaryData;
   
   public class EliteGameController extends EventDispatcher
   {
      
      private static var _instance:EliteGameController;
      
      public static const ELITEGAME_CLOSE:int = 0;
      
      public static const SCORE_PHASE_30_40:int = 1;
      
      public static const CHAMPION_PHASE_30_40:int = 2;
      
      public static const SCORE_PHASE_41_50:int = 3;
      
      public static const CHAMPION_PHASE_41_50:int = 4;
      
      private var _score_30_40:int = 1;
      
      private var _champion_30_40:int = 2;
      
      private var _score_41_50:int = 4;
      
      private var _champion_41_50:int = 8;
      
      private var _eliteGameState:int = 0;
      
      private var _model:EliteGameModel;
      
      private var _timer:Timer;
      
      public var leftTime:int = 30;
      
      private var _isFirstPreview:Boolean = true;
      
      private var _readyFrame:EliteGameReadyFrame;
      
      private var _isalertReady:Boolean = false;
      
      private var _sroceRankType:int;
      
      public function EliteGameController()
      {
         super();
         this._model = new EliteGameModel();
      }
      
      public static function get Instance() : EliteGameController
      {
         if(_instance == null)
         {
            _instance = new EliteGameController();
         }
         return _instance;
      }
      
      public function get Model() : EliteGameModel
      {
         return this._model;
      }
      
      public function setup() : void
      {
         this._timer = new Timer(1000);
         this._timer.addEventListener(TimerEvent.TIMER,this.__timerHandler);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.ELITE_MATCH_TYPE,this.__matchTypeHandler);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.ELITE_MATCH_PLAYER_RANK,this.__selfRankHandler);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.ELITE_MATCH_RANK_START,this.__gameStartHandler);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.ELITE_MATCH_RANK_DETAIL,this.__detailHandler);
      }
      
      protected function __detailHandler(event:CrazyTankSocketEvent) : void
      {
         var info:EliteGameTopSixteenInfo = null;
         var round:int = 0;
         var lorW:int = 0;
         var goR:int = 0;
         var j:int = 0;
         var pkg:PackageIn = event.pkg;
         var type:int = pkg.readInt();
         var len1:int = pkg.readInt();
         var infos:Vector.<EliteGameTopSixteenInfo> = new Vector.<EliteGameTopSixteenInfo>();
         var dics:DictionaryData = new DictionaryData();
         for(var i:int = 0; i < len1; i++)
         {
            info = new EliteGameTopSixteenInfo();
            info.id = pkg.readInt();
            info.name = pkg.readUTF();
            info.rank = pkg.readInt();
            infos.push(info);
            round = pkg.readInt();
            lorW = pkg.readInt();
            goR = lorW == 0 ? round - 1 : round;
            for(j = 1; j <= goR; j++)
            {
               if(dics[j] == null)
               {
                  dics[j] = new Vector.<int>();
               }
               (dics[j] as Vector.<int>).push(info.id);
            }
         }
         if(type == 1)
         {
            this._model.topSixteen30_40 = infos;
            this._model.paarungRound30_40 = dics;
         }
         else if(type == 2)
         {
            this._model.topSixteen41_50 = infos;
            this._model.paarungRound41_50 = dics;
         }
         dispatchEvent(new EliteGameEvent(EliteGameEvent.TOP_SIXTEEN_READY));
      }
      
      protected function __timerHandler(event:TimerEvent) : void
      {
         --this.leftTime;
         if(this._timer.currentCount == 30)
         {
            this._timer.stop();
            if(StateManager.currentStateType == StateType.MATCH_ROOM)
            {
               dispatchEvent(new EliteGameEvent(EliteGameEvent.READY_TIME_OVER));
            }
            else
            {
               if(Boolean(this._readyFrame))
               {
                  this._readyFrame.dispose();
               }
               this._readyFrame = null;
            }
         }
      }
      
      protected function __gameStartHandler(event:CrazyTankSocketEvent) : void
      {
         this.alertReadyFrame();
      }
      
      protected function __selfRankHandler(event:CrazyTankSocketEvent) : void
      {
         this._model.selfRank = event.pkg.readInt();
         this._model.selfScore = event.pkg.readInt();
         if(this._model.selfScore == 0)
         {
            this._model.selfScore = 1000;
         }
         dispatchEvent(new EliteGameEvent(EliteGameEvent.SELF_RANK_SCORE_READY));
      }
      
      protected function __matchTypeHandler(event:CrazyTankSocketEvent) : void
      {
         var state:int = event.pkg.readInt();
         this.eliteGameState = state;
      }
      
      public function get eliteGameState() : int
      {
         return this._eliteGameState;
      }
      
      public function set eliteGameState(value:int) : void
      {
         if(this._eliteGameState == value)
         {
            return;
         }
         this._eliteGameState = value;
         dispatchEvent(new EliteGameEvent(EliteGameEvent.ELITEGAME_STATE_CHANGE));
      }
      
      public function getState() : Array
      {
         var arr:Array = new Array();
         if(Boolean(this._eliteGameState & this._score_30_40))
         {
            arr.push(SCORE_PHASE_30_40);
         }
         if(Boolean(this._eliteGameState & this._champion_30_40))
         {
            arr.push(CHAMPION_PHASE_30_40);
         }
         if(Boolean(this._eliteGameState & this._score_41_50))
         {
            arr.push(SCORE_PHASE_41_50);
         }
         if(Boolean(this._eliteGameState & this._champion_41_50))
         {
            arr.push(CHAMPION_PHASE_41_50);
         }
         return arr;
      }
      
      public function alertPreview() : void
      {
         var preview:EliteGamePreview = null;
         if(this._isFirstPreview)
         {
            this._isalertReady = false;
            UIModuleSmallLoading.Instance.progress = 0;
            UIModuleSmallLoading.Instance.show();
            UIModuleSmallLoading.Instance.addEventListener(Event.CLOSE,this.__onSmallLoadingClose);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__onUIComplete);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__onUIProgress);
            UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.DDTELITEGAME);
            this.getAwardData();
         }
         else
         {
            SocketManager.Instance.out.sendGetSelfRankSroce();
            SocketManager.Instance.out.sendGetEliteGameState();
            this.getScoreRankData();
            preview = ComponentFactory.Instance.creatComponentByStylename("ddteliteGamePreview");
            LayerManager.Instance.addToLayer(preview,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.ALPHA_BLOCKGOUND,true);
         }
      }
      
      public function alertReadyFrame() : void
      {
         if(!StateManager.isExitGame(StateManager.currentStateType) || !StateManager.isExitRoom(StateManager.currentStateType) || StateManager.currentStateType == StateType.CHURCH_ROOM || StateManager.currentStateType == StateType.FIGHTING)
         {
            return;
         }
         this.leftTime = 30;
         if(this._isFirstPreview)
         {
            this._isalertReady = true;
            UIModuleSmallLoading.Instance.progress = 0;
            UIModuleSmallLoading.Instance.show();
            UIModuleSmallLoading.Instance.addEventListener(Event.CLOSE,this.__onSmallLoadingClose);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__onUIComplete);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__onUIProgress);
            UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.DDTELITEGAME);
         }
         else
         {
            this._timer.reset();
            this._timer.start();
            this._readyFrame = ComponentFactory.Instance.creatComponentByStylename("ddteliteGameReadyFrame");
            SoundManager.instance.play("018");
            LayerManager.Instance.addToLayer(this._readyFrame,LayerManager.GAME_TOP_LAYER,true,LayerManager.BLCAK_BLOCKGOUND,true);
         }
      }
      
      public function setReadyFrame() : void
      {
         this._readyFrame = null;
      }
      
      public function alertPaarungFrame() : void
      {
         var frame:EliteGamePaarungFrame = ComponentFactory.Instance.creatComponentByStylename("ddteliteGamePaarungFrame");
         LayerManager.Instance.addToLayer(frame,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
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
         if(e.module == UIModuleTypes.DDTELITEGAME)
         {
            UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__onSmallLoadingClose);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__onUIComplete);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__onUIProgress);
            UIModuleSmallLoading.Instance.hide();
            this._isFirstPreview = false;
            if(this._isalertReady)
            {
               this.alertReadyFrame();
            }
            else
            {
               this.alertPreview();
            }
         }
      }
      
      private function __onUIProgress(e:UIModuleEvent) : void
      {
         if(e.module == UIModuleTypes.DDTELITEGAME)
         {
            UIModuleSmallLoading.Instance.progress = e.loader.progress * 100;
         }
      }
      
      public function joinEliteGame() : void
      {
         if(!StateManager.isExitRoom(StateManager.currentStateType))
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("room.scoreRoom.isInRoom"));
         }
         else
         {
            GameInSocketOut.sendCreateRoom("",12,3);
         }
      }
      
      public function joinChampionEliteGame() : void
      {
         SocketManager.Instance.out.sendEliteGameStart();
         GameInSocketOut.sendCreateRoom("",13,3);
      }
      
      public function getScoreRankData() : void
      {
         var args:URLVariables = new URLVariables();
         args["new"] = Math.random();
         var eliteGameScoreRankAnalyer:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("EliteMatchPlayerList.xml"),BaseLoader.COMPRESS_TEXT_LOADER,args);
         eliteGameScoreRankAnalyer.loadErrorMessage = LanguageMgr.GetTranslation("EliteGame.loadScoreRank.fail");
         eliteGameScoreRankAnalyer.analyzer = new EliteGameScoreRankAnalyer(this.scroeRankLoadComplete);
         eliteGameScoreRankAnalyer.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         LoadResourceManager.Instance.startLoad(eliteGameScoreRankAnalyer);
      }
      
      private function scroeRankLoadComplete(analyer:EliteGameScoreRankAnalyer) : void
      {
         this._model.scoreRankInfo = analyer.scoreRankInfo;
      }
      
      public function getAwardData() : void
      {
         var awardAnalyer:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("EliteMatchPrizeList.xml"),BaseLoader.COMPRESS_TEXT_LOADER);
         awardAnalyer.loadErrorMessage = LanguageMgr.GetTranslation("EliteGame.loadAward.fail");
         awardAnalyer.analyzer = new EliteGameAwardAnalyer(this.awardLoadComplete);
         awardAnalyer.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         LoadResourceManager.Instance.startLoad(awardAnalyer);
      }
      
      private function awardLoadComplete(analyer:EliteGameAwardAnalyer) : void
      {
         this._model.award30_39 = analyer.award30_39;
         this._model.award40_60 = analyer.award40_60;
         dispatchEvent(new EliteGameEvent(EliteGameEvent.AWARD_DATA_READY));
      }
      
      private function __onLoadError(event:LoaderEvent) : void
      {
         var msg:String = event.loader.loadErrorMessage;
         if(Boolean(event.loader.analyzer))
         {
            msg = event.loader.loadErrorMessage + "\n" + event.loader.analyzer.message;
         }
         var alert:BaseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("alert"),event.loader.loadErrorMessage,LanguageMgr.GetTranslation("tank.view.bagII.baglocked.sure"));
         alert.addEventListener(FrameEvent.RESPONSE,this.__onAlertResponse);
      }
      
      private function __onAlertResponse(event:FrameEvent) : void
      {
         event.currentTarget.removeEventListener(FrameEvent.RESPONSE,this.__onAlertResponse);
         ObjectUtils.disposeObject(event.currentTarget);
         LeavePageManager.leaveToLoginPath();
      }
   }
}

