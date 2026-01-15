package ddt.manager
{
   import baglocked.BagLockedController;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.LoadResourceManager;
   import com.pickgliss.loader.LoaderEvent;
   import com.pickgliss.loader.QueueLoader;
   import com.pickgliss.manager.CacheSysManager;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import ddt.DDT;
   import ddt.constants.CacheConsts;
   import ddt.data.ServerInfo;
   import ddt.data.analyze.ServerListAnalyzer;
   import ddt.data.player.SelfInfo;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.events.DuowanInterfaceEvent;
   import ddt.loader.LoaderCreate;
   import ddt.loader.StartupResourceLoader;
   import ddt.states.StateType;
   import ddt.view.DailyButtunBar;
   import ddt.view.MainToolBar;
   import email.manager.MailManager;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.utils.Timer;
   import flash.utils.setTimeout;
   import hall.player.HallPlayerView;
   import horseRace.controller.HorseRaceManager;
   import pet.sprite.PetSpriteController;
   import road7th.comm.PackageIn;
   import trainer.controller.SystemOpenPromptManager;
   
   [Event(name="change",type="flash.events.Event")]
   public class ServerManager extends EventDispatcher
   {
      
      private static var _instance:ServerManager;
      
      public static const CHANGE_SERVER:String = "changeServer";
      
      public static var AUTO_UNLOCK:Boolean = false;
      
      private static const CONNENT_TIME_OUT:int = 30000;
      
      private var _list:Vector.<ServerInfo>;
      
      private var _current:ServerInfo;
      
      private var _zoneName:String;
      
      private var _agentid:int;
      
      public var refreshFlag:Boolean = false;
      
      private var _connentTimer:Timer;
      
      private var _currentServerName:String;
      
      private var _loaderQueue:QueueLoader;
      
      private var _requestCompleted:int;
      
      public function ServerManager()
      {
         super();
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.LOGIN,this.__onLoginComplete);
      }
      
      public static function get Instance() : ServerManager
      {
         if(_instance == null)
         {
            _instance = new ServerManager();
         }
         return _instance;
      }
      
      public function get zoneName() : String
      {
         return this._zoneName;
      }
      
      public function set zoneName(value:String) : void
      {
         this._zoneName = value;
         dispatchEvent(new Event(Event.CHANGE));
      }
      
      public function get AgentID() : int
      {
         return this._agentid;
      }
      
      public function set AgentID(value:int) : void
      {
         this._agentid = value;
      }
      
      public function set current(value:ServerInfo) : void
      {
         this._current = value;
      }
      
      public function get current() : ServerInfo
      {
         return this._current;
      }
      
      public function get list() : Vector.<ServerInfo>
      {
         return this._list;
      }
      
      public function set list(value:Vector.<ServerInfo>) : void
      {
         this._list = value;
         dispatchEvent(new Event(Event.CHANGE));
      }
      
      public function setup(analyzer:ServerListAnalyzer) : void
      {
         this._list = analyzer.list;
         this._agentid = analyzer.agentId;
         this._zoneName = analyzer.zoneName;
      }
      
      public function canAutoLogin() : Boolean
      {
         this.searchAvailableServer();
         return this._current != null;
      }
      
      public function connentCurrentServer() : void
      {
         SocketManager.Instance.isLogin = false;
         SocketManager.Instance.connect(this._current.IP,this._current.Port);
      }
      
      private function searchAvailableServer() : void
      {
         var index:int = 0;
         var player:SelfInfo = PlayerManager.Instance.Self;
         if(DDT.SERVER_ID != -1)
         {
            this._current = this.getServerInfoByID(DDT.SERVER_ID);
            return;
         }
         if(player.LastServerId != -1)
         {
            this._current = this.getServerInfoByID(player.LastServerId);
            return;
         }
         if(PathManager.solveRandomChannel())
         {
            index = Math.round(Math.random() * (this._list.length - 1));
            this._current = this._list[index];
            while(this._current.State == 1)
            {
               index = Math.round(Math.random() * (this._list.length - 1));
               this._current = this._list[index];
            }
         }
         else
         {
            this._current = this.searchServerByState(ServerInfo.UNIMPEDED);
            if(this._current == null)
            {
               this._current = this.searchServerByState(ServerInfo.HALF);
            }
         }
         if(this._current == null)
         {
            this._current = this._list[0];
         }
      }
      
      public function getServerInfoByID(id:int) : ServerInfo
      {
         for(var i:int = 0; i < this._list.length; i++)
         {
            if(this._list[i].ID == id)
            {
               return this._list[i];
            }
         }
         return null;
      }
      
      private function searchServerByState(state:int) : ServerInfo
      {
         for(var i:int = 0; i < this._list.length; i++)
         {
            if(this._list[i].State == state)
            {
               return this._list[i];
            }
         }
         return null;
      }
      
      public function connentServer(info:ServerInfo) : Boolean
      {
         var alert:BaseAlerFrame = null;
         if(info == null)
         {
            alert = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("tank.serverlist.ServerListPosView.choose"));
            this.alertControl(alert);
            return false;
         }
         if(info.MustLevel < PlayerManager.Instance.Self.Grade)
         {
            alert = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("tank.serverlist.ServerListPosView.your"));
            this.alertControl(alert);
            return false;
         }
         if(info.LowestLevel > PlayerManager.Instance.Self.Grade)
         {
            alert = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("tank.serverlist.ServerListPosView.low"));
            this.alertControl(alert);
            return false;
         }
         if(SocketManager.Instance.socket.connected && SocketManager.Instance.socket.isSame(info.IP,info.Port) && SocketManager.Instance.isLogin)
         {
            StateManager.setState(StateType.MAIN);
            return false;
         }
         if(info.State == ServerInfo.ALL_FULL)
         {
            alert = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("tank.serverlist.ServerListPosView.full"));
            this.alertControl(alert);
            return false;
         }
         if(info.State == ServerInfo.MAINTAIN)
         {
            alert = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("tank.serverlist.ServerListPosView.maintenance"));
            this.alertControl(alert);
            return false;
         }
         this._currentServerName = info.Name;
         this.requestUpdateServerListData();
         return true;
      }
      
      private function requestUpdateServerListData() : void
      {
         var _temploader:BaseLoader = LoaderCreate.Instance.creatServerListLoader();
         _temploader.addEventListener(LoaderEvent.COMPLETE,this.__onDataListLoadComplete);
         LoadResourceManager.Instance.startLoad(_temploader);
      }
      
      private function __onDataListLoadComplete(e:LoaderEvent) : void
      {
         e.currentTarget.removeEventListener(LoaderEvent.COMPLETE,this.__onDataListLoadComplete);
         var info:ServerInfo = this.getServerByName(this._currentServerName);
         if(info.Online >= info.Total)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.serverlist.fullRoomListMsg"));
         }
         else
         {
            this._current = info;
            this.connentCurrentServer();
            dispatchEvent(new Event(CHANGE_SERVER));
         }
      }
      
      private function getServerByName(serverName:String) : ServerInfo
      {
         var info:ServerInfo = null;
         for each(info in this.list)
         {
            if(info.Name == serverName)
            {
               return info;
            }
         }
         return null;
      }
      
      private function alertControl(alert:BaseAlerFrame) : void
      {
         alert.addEventListener(FrameEvent.RESPONSE,this.__alertResponse);
      }
      
      private function __alertResponse(evt:FrameEvent) : void
      {
         var alert:BaseAlerFrame = evt.currentTarget as BaseAlerFrame;
         alert.removeEventListener(FrameEvent.RESPONSE,this.__alertResponse);
         alert.dispose();
      }
      
      private function __onLoginComplete(event:CrazyTankSocketEvent) : void
      {
         var styleAndSkin:String = null;
         var t:Array = null;
         var locked:Boolean = false;
         var lockReleased:Boolean = false;
         var alert:BaseAlerFrame = null;
         var pkg:PackageIn = event.pkg;
         var self:SelfInfo = PlayerManager.Instance.Self;
         if(pkg.readByte() == 0)
         {
            CacheSysManager.getInstance().singleRelease(CacheConsts.ALERT_IN_NEWVERSIONGUIDETIP);
            CacheSysManager.lock(CacheConsts.ALERT_IN_NEWVERSIONGUIDETIP);
            self.beginChanges();
            SocketManager.Instance.isLogin = true;
            self.ZoneID = pkg.readInt();
            self.Attack = pkg.readInt();
            self.Defence = pkg.readInt();
            self.Agility = pkg.readInt();
            self.Luck = pkg.readInt();
            self.GP = pkg.readInt();
            self.Repute = pkg.readInt();
            self.Gold = pkg.readInt();
            self.Money = pkg.readInt();
            self.BandMoney = pkg.readInt();
            pkg.readInt();
            self.Score = pkg.readInt();
            self.Hide = pkg.readInt();
            self.FightPower = pkg.readInt();
            self.apprenticeshipState = pkg.readInt();
            self.masterID = pkg.readInt();
            self.setMasterOrApprentices(pkg.readUTF());
            self.graduatesCount = pkg.readInt();
            self.honourOfMaster = pkg.readUTF();
            self.freezesDate = pkg.readDate();
            self.typeVIP = pkg.readByte();
            self.VIPLevel = pkg.readInt();
            self.VIPExp = pkg.readInt();
            self.VIPExpireDay = pkg.readDate();
            self.LastDate = pkg.readDate();
            self.VIPNextLevelDaysNeeded = pkg.readInt();
            self.systemDate = pkg.readDate();
            self.canTakeVipReward = pkg.readBoolean();
            self.OptionOnOff = pkg.readInt();
            self.AchievementPoint = pkg.readInt();
            self.honor = pkg.readUTF();
            self.honorId = pkg.readInt();
            TimeManager.Instance.totalGameTime = pkg.readInt();
            self.Sex = pkg.readBoolean();
            styleAndSkin = pkg.readUTF();
            t = styleAndSkin.split("&");
            self.Style = t[0];
            self.Colors = t[1];
            self.Skin = pkg.readUTF();
            self.ConsortiaID = pkg.readInt();
            self.ConsortiaName = pkg.readUTF();
            self.badgeID = pkg.readInt();
            self.DutyLevel = pkg.readInt();
            self.DutyName = pkg.readUTF();
            self.Right = pkg.readInt();
            self.consortiaInfo.ChairmanName = pkg.readUTF();
            self.consortiaInfo.Honor = pkg.readInt();
            self.consortiaInfo.Riches = pkg.readInt();
            locked = pkg.readBoolean();
            lockReleased = self.bagPwdState && !self.bagLocked;
            self.bagPwdState = locked;
            if(lockReleased)
            {
               setTimeout(this.releaseLock,1000);
            }
            self.bagLocked = locked;
            self.questionOne = pkg.readUTF();
            self.questionTwo = pkg.readUTF();
            self.leftTimes = pkg.readInt();
            self.LoginName = pkg.readUTF();
            self.Nimbus = pkg.readInt();
            TaskManager.instance.requestCanAcceptTask();
            self.PvePermission = pkg.readUTF();
            self.fightLibMission = pkg.readUTF();
            self.userGuildProgress = pkg.readInt();
            self.LastSpaDate = pkg.readDate();
            self.shopFinallyGottenTime = pkg.readDate();
            self.UseOffer = pkg.readInt();
            self.matchInfo.dailyScore = pkg.readInt();
            self.matchInfo.dailyWinCount = pkg.readInt();
            self.matchInfo.dailyGameCount = pkg.readInt();
            self.DailyLeagueFirst = pkg.readBoolean();
            self.DailyLeagueLastScore = pkg.readInt();
            self.matchInfo.weeklyScore = pkg.readInt();
            self.matchInfo.weeklyGameCount = pkg.readInt();
            self.matchInfo.weeklyRanking = pkg.readInt();
            self.spdTexpExp = pkg.readInt();
            self.attTexpExp = pkg.readInt();
            self.defTexpExp = pkg.readInt();
            self.hpTexpExp = pkg.readInt();
            self.lukTexpExp = pkg.readInt();
            self.texpTaskCount = pkg.readInt();
            self.texpCount = pkg.readInt();
            self.texpTaskDate = pkg.readDate();
            self.isOldPlayerHasValidEquitAtLogin = pkg.readBoolean();
            self.badLuckNumber = pkg.readInt();
            self.luckyNum = pkg.readInt();
            self.lastLuckyNumDate = pkg.readDate();
            self.lastLuckNum = pkg.readInt();
            self.isOld = pkg.readBoolean();
            self.CardSoul = pkg.readInt();
            self.GetSoulCount = pkg.readInt();
            self.uesedFinishTime = pkg.readInt();
            self.totemId = pkg.readInt();
            self.necklaceExp = pkg.readInt();
            self.accumulativeLoginDays = pkg.readInt();
            self.accumulativeAwardDays = pkg.readInt();
            BossBoxManager.instance.receiebox = pkg.readInt();
            BossBoxManager.instance.receieGrade = pkg.readInt();
            BossBoxManager.instance.needGetBoxTime = pkg.readInt();
            BossBoxManager.instance.currentGrade = PlayerManager.Instance.Self.Grade;
            BossBoxManager.instance.startGradeChangeEvent();
            self.isFirstDivorce = pkg.readInt();
            self.PveEpicPermission = pkg.readUTF();
            self.MountsType = pkg.readInt();
            self.PetsID = pkg.readInt();
            HorseRaceManager.Instance.horseRaceCanRaceTime = pkg.readInt();
            self.commitChanges();
            MapManager.buildMap();
            PlayerManager.Instance.Self.loadRelatedPlayersInfo();
            DailyButtunBar.Insance.hideFlag = true;
            MainToolBar.Instance.signEffectEnable = true;
            StateManager.setState(StateType.MAIN);
            ExternalInterfaceManager.sendTo360Agent(4);
            if(!StartupResourceLoader.firstEnterHall)
            {
               StartupResourceLoader.Instance.startLoadRelatedInfo();
               SocketManager.Instance.out.sendPlayerGift(self.ID);
            }
            if(DesktopManager.Instance.isDesktop)
            {
               setTimeout(TaskManager.instance.onDesktopApp,500);
            }
            PetSpriteController.Instance.setup();
            DuowanInterfaceManage.Instance.dispatchEvent(new DuowanInterfaceEvent(DuowanInterfaceEvent.ONLINE));
            SystemOpenPromptManager.instance.isShowNewEuipTip = true;
            if(this.refreshFlag)
            {
               SystemOpenPromptManager.instance.showFrame();
               this.refreshFlag = false;
            }
            if(HallPlayerView.initFlag)
            {
               SocketManager.Instance.out.sendOtherPlayerInfo();
            }
            if(MailManager.Instance.linkChurchRoomId != -1)
            {
               SocketManager.Instance.out.sendEnterRoom(MailManager.Instance.linkChurchRoomId,"");
            }
            SocketManager.Instance.out.requestWonderfulActInit(3);
            this.addLoaderAgain();
         }
         else
         {
            alert = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("alert"),LanguageMgr.GetTranslation("ServerLinkError"));
            this.alertControl(alert);
         }
      }
      
      private function addLoaderAgain() : void
      {
         this._loaderQueue = new QueueLoader();
         this._loaderQueue.addEventListener(Event.CHANGE,this.__onSetupSourceLoadChange);
         this._loaderQueue.addEventListener(Event.COMPLETE,this.__onSetupSourceLoadComplete);
         this.addLoader(LoaderCreate.Instance.createCallPropDataLoader());
         this._loaderQueue.start();
      }
      
      private function addLoader(loader:BaseLoader) : void
      {
         this._loaderQueue.addLoader(loader);
      }
      
      private function __onSetupSourceLoadChange(event:Event) : void
      {
         this._requestCompleted = (event.currentTarget as QueueLoader).completeCount;
      }
      
      private function __onSetupSourceLoadComplete(event:Event) : void
      {
         var queue:QueueLoader = event.currentTarget as QueueLoader;
         queue.removeEventListener(Event.COMPLETE,this.__onSetupSourceLoadComplete);
         queue.removeEventListener(Event.CHANGE,this.__onSetupSourceLoadChange);
         queue.dispose();
         queue = null;
      }
      
      private function releaseLock() : void
      {
         AUTO_UNLOCK = true;
         SocketManager.Instance.out.sendBagLocked(BagLockedController.PWD,2);
      }
   }
}

