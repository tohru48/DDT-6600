package consortionBattle
{
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.BitmapLoader;
   import com.pickgliss.loader.LoadResourceManager;
   import com.pickgliss.loader.LoaderEvent;
   import consortionBattle.event.ConsBatEvent;
   import consortionBattle.player.ConsortiaBattlePlayer;
   import consortionBattle.player.ConsortiaBattlePlayerInfo;
   import ddt.data.player.SelfInfo;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.ChatManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PathManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.StateManager;
   import ddt.manager.TimeManager;
   import ddt.states.StateType;
   import ddtActivityIcon.DdtActivityIconManager;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import flash.events.TimerEvent;
   import flash.geom.Point;
   import flash.utils.Timer;
   import hallIcon.HallIconManager;
   import hallIcon.HallIconType;
   import road7th.comm.PackageIn;
   import road7th.data.DictionaryData;
   
   public class ConsortiaBattleManager extends EventDispatcher
   {
      
      private static var _instance:ConsortiaBattleManager;
      
      public static const ICON_AND_MAP_LOAD_COMPLETE:String = "consBatIconMapComplete";
      
      public static const CLOSE:String = "consortiaBattleClose";
      
      public static const MOVE_PLAYER:String = "consortiaBattleMovePlayer";
      
      public static const UPDATE_SCENE_INFO:String = "consortiaBattleUpdateSceneInfo";
      
      public static const HIDE_RECORD_CHANGE:String = "consortiaBattleHideRecordChange";
      
      public static const UPDATE_SCORE:String = "consortiaBattleUpdateScore";
      
      public static const BROADCAST:String = "consortiaBattleBroadcast";
      
      public const resourcePrUrl:String = PathManager.SITE_MAIN + "image/factionwar/";
      
      public var isAutoPowerFull:Boolean = false;
      
      private var _isOpen:Boolean = false;
      
      private var _isLoadMapComplete:Boolean = false;
      
      private var _playerDataList:DictionaryData;
      
      private var _buffPlayerList:DictionaryData;
      
      private var _buffCreatePlayerList:DictionaryData;
      
      private var _timer:Timer;
      
      public var isInMainView:Boolean = false;
      
      private var _startTime:Date;
      
      private var _endTime:Date;
      
      private var _isPowerFullUsed:Boolean = true;
      
      private var _isDoubleScoreUsed:Boolean = true;
      
      private var _victoryCount:int;
      
      private var _winningStreak:int;
      
      private var _score:int;
      
      private var _curHp:int;
      
      private var _hideRecord:int = 0;
      
      private var _buyRecordStatus:Array;
      
      private var _isCanEnter:Boolean;
      
      private var _isHadLoadRes:Boolean = false;
      
      private var _isHadShowOpenTip:Boolean = false;
      
      public function ConsortiaBattleManager(target:IEventDispatcher = null)
      {
         super(target);
         this._playerDataList = new DictionaryData();
         this._buffPlayerList = new DictionaryData();
         this._buffCreatePlayerList = new DictionaryData();
         this._timer = new Timer(500);
         this._timer.addEventListener(TimerEvent.TIMER,this.timerHandler,false,0,true);
      }
      
      public static function get instance() : ConsortiaBattleManager
      {
         if(_instance == null)
         {
            _instance = new ConsortiaBattleManager();
         }
         return _instance;
      }
      
      public function get playerDataList() : DictionaryData
      {
         return this._playerDataList;
      }
      
      public function get isPowerFullUsed() : Boolean
      {
         return this._isPowerFullUsed;
      }
      
      public function get isDoubleScoreUsed() : Boolean
      {
         return this._isDoubleScoreUsed;
      }
      
      public function get victoryCount() : int
      {
         return this._victoryCount;
      }
      
      public function get winningStreak() : int
      {
         return this._winningStreak;
      }
      
      public function get score() : int
      {
         return this._score;
      }
      
      public function get curHp() : int
      {
         return this._curHp;
      }
      
      public function get isCanEnter() : Boolean
      {
         return this._isCanEnter;
      }
      
      private function timerHandler(event:TimerEvent) : void
      {
         if(this._buffCreatePlayerList.length <= 0)
         {
            this._timer.stop();
            return;
         }
         var tmpData:ConsortiaBattlePlayerInfo = this._buffCreatePlayerList.list[0];
         this._buffCreatePlayerList.remove(tmpData.id);
         if(this._playerDataList.length < 80)
         {
            this._playerDataList.add(tmpData.id,tmpData);
         }
      }
      
      public function judgeCreatePlayer(posX:Number, posY:Number) : void
      {
         var tmpPlayerData:ConsortiaBattlePlayerInfo = null;
         var id:int = 0;
         var playerPosX:Number = NaN;
         var playerPosY:Number = NaN;
         var tmpData:ConsortiaBattlePlayerInfo = null;
         var deleteIdList:Array = [];
         for each(tmpPlayerData in this._buffPlayerList)
         {
            playerPosX = tmpPlayerData.pos.x + posX;
            playerPosY = tmpPlayerData.pos.y + posY;
            if(playerPosX > 0 && playerPosX < 1000 && playerPosY > 10 && playerPosY <= 650)
            {
               deleteIdList.push(tmpPlayerData.id);
            }
         }
         for each(id in deleteIdList)
         {
            tmpData = this._buffPlayerList[id];
            this._buffPlayerList.remove(id);
            this._buffCreatePlayerList.add(tmpData.id,tmpData);
         }
         if(deleteIdList.length > 0 && !this._timer.running)
         {
            this._timer.start();
         }
      }
      
      public function getBuyRecordStatus(index:int) : Object
      {
         var i:int = 0;
         var obj:Object = null;
         if(!this._buyRecordStatus)
         {
            this._buyRecordStatus = [];
            for(i = 0; i < 4; i++)
            {
               obj = {};
               obj.isNoPrompt = false;
               obj.isBand = false;
               this._buyRecordStatus.push(obj);
            }
         }
         return this._buyRecordStatus[index];
      }
      
      public function get isOpen() : Boolean
      {
         return this._isOpen;
      }
      
      public function get isLoadIconMapComplete() : Boolean
      {
         return this._isLoadMapComplete;
      }
      
      public function get beforeStartTime() : int
      {
         if(!this._startTime)
         {
            return 0;
         }
         return this.getDateHourTime(this._startTime) - this.getDateHourTime(TimeManager.Instance.Now());
      }
      
      public function get toEndTime() : int
      {
         if(!this._endTime)
         {
            return 0;
         }
         return this.getDateHourTime(this._endTime) - this.getDateHourTime(TimeManager.Instance.Now());
      }
      
      public function setup() : void
      {
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.CONSORTIA_BATTLE,this.pkgHandler);
      }
      
      private function getDateHourTime(date:Date) : int
      {
         return int(date.hours * 3600 + date.minutes * 60 + date.seconds);
      }
      
      public function changeHideRecord(index:int, isHide:Boolean) : void
      {
         var tmp:int = 0;
         if(isHide)
         {
            if(index == 1)
            {
               tmp = 4;
            }
            else if(index == 2)
            {
               tmp = 2;
            }
            else
            {
               tmp = 1;
            }
            this._hideRecord |= tmp;
         }
         else
         {
            if(index == 1)
            {
               tmp = 3;
            }
            else if(index == 2)
            {
               tmp = 5;
            }
            else
            {
               tmp = 6;
            }
            this._hideRecord &= tmp;
         }
         dispatchEvent(new Event(HIDE_RECORD_CHANGE));
      }
      
      public function isHide(index:int) : Boolean
      {
         var tmp:int = 0;
         if(index == 1)
         {
            tmp = 4;
         }
         else if(index == 2)
         {
            tmp = 2;
         }
         else
         {
            tmp = 1;
         }
         if((this._hideRecord & tmp) == 0)
         {
            return false;
         }
         return true;
      }
      
      public function judgePlayerVisible(player:ConsortiaBattlePlayer) : Boolean
      {
         if(player.playerData.id == PlayerManager.Instance.Self.ID)
         {
            return true;
         }
         if(ConsortiaBattleManager.instance.isHide(1) && player.playerData.selfOrEnemy == 1)
         {
            return false;
         }
         if(ConsortiaBattleManager.instance.isHide(2) && player.isInTomb)
         {
            return false;
         }
         if(ConsortiaBattleManager.instance.isHide(3) && player.isInFighting)
         {
            return false;
         }
         return true;
      }
      
      public function addEntryBtn($isOpen:Boolean, $timeStr:String = null) : void
      {
         ConsortiaBattleManager.instance.addEventListener(ConsortiaBattleManager.CLOSE,this.closeHandler);
         if($timeStr != "" && $timeStr != null)
         {
            HallIconManager.instance.updateSwitchHandler(HallIconType.CONSORTIABATTLE,$isOpen,$timeStr);
         }
         if(ConsortiaBattleManager.instance.isLoadIconMapComplete)
         {
            HallIconManager.instance.updateSwitchHandler(HallIconType.CONSORTIABATTLE,$isOpen,$timeStr);
         }
         if(!this._isHadLoadRes)
         {
            this.loadMap();
            this._isHadLoadRes = true;
         }
      }
      
      private function closeHandler(event:Event) : void
      {
         HallIconManager.instance.updateSwitchHandler(HallIconType.CONSORTIABATTLE,false);
      }
      
      private function pkgHandler(event:CrazyTankSocketEvent) : void
      {
         var pkg:PackageIn = null;
         var tmpIsJump:Boolean = false;
         pkg = event.pkg;
         var cmd:int = pkg.readByte();
         switch(cmd)
         {
            case ConsBatPackageType.START_OR_CLOSE:
               this.openOrCloseHandler(pkg);
               break;
            case ConsBatPackageType.ENTER_SELF_INFO:
               tmpIsJump = pkg.readBoolean();
               this.initSelfInfo(pkg);
               if(tmpIsJump)
               {
                  StateManager.setState(StateType.CONSORTIA_BATTLE_SCENE);
               }
               break;
            case ConsBatPackageType.ADD_PLAYER:
               this.addPlayerInfo(pkg);
               break;
            case ConsBatPackageType.PLAYER_MOVE:
               this.movePlayer(pkg);
               break;
            case ConsBatPackageType.DELETE_PLAYER:
               this.deletePlayer(pkg);
               break;
            case ConsBatPackageType.PLAYER_STATUS:
               this.updatePlayerStatus(pkg);
               break;
            case ConsBatPackageType.UPDATE_SCENE_INFO:
               this.updateSceneInfo(pkg);
               break;
            case ConsBatPackageType.UPDATE_SCORE:
               this.updateScore(pkg);
               break;
            case ConsBatPackageType.SPLIT_MERGE:
               this.splitMergeHandler();
               break;
            case ConsBatPackageType.BROADCAST:
               this.broadcastHandler(pkg);
         }
      }
      
      private function broadcastHandler(pkg:PackageIn) : void
      {
         var tmp:ConsBatEvent = new ConsBatEvent(BROADCAST);
         tmp.data = pkg;
         dispatchEvent(tmp);
      }
      
      private function splitMergeHandler() : void
      {
         var key:String = null;
         if(!this.isInMainView)
         {
            return;
         }
         for(key in this._playerDataList)
         {
            if(int(key) != PlayerManager.Instance.Self.ID)
            {
               this._playerDataList.remove(key);
            }
         }
         this._buffPlayerList = new DictionaryData();
         this._buffCreatePlayerList = new DictionaryData();
         SocketManager.Instance.out.sendConsBatRequestPlayerInfo();
      }
      
      private function updateScore(pkg:PackageIn) : void
      {
         if(!this.isInMainView)
         {
            return;
         }
         var tmp:ConsBatEvent = new ConsBatEvent(UPDATE_SCORE);
         tmp.data = pkg;
         dispatchEvent(tmp);
      }
      
      private function updateSceneInfo(pkg:PackageIn) : void
      {
         this._curHp = pkg.readInt();
         this._victoryCount = pkg.readInt();
         this._winningStreak = pkg.readInt();
         this._score = pkg.readInt();
         this._isPowerFullUsed = pkg.readBoolean();
         this._isDoubleScoreUsed = pkg.readBoolean();
         var tmp:ConsortiaBattlePlayerInfo = this._playerDataList[PlayerManager.Instance.Self.ID] as ConsortiaBattlePlayerInfo;
         if(Boolean(tmp))
         {
            tmp.tombstoneEndTime = pkg.readDate();
         }
         dispatchEvent(new Event(UPDATE_SCENE_INFO));
      }
      
      private function updatePlayerStatus(pkg:PackageIn) : void
      {
         var tmpData:ConsortiaBattlePlayerInfo = null;
         var id:int = pkg.readInt();
         if(!this.isInMainView && id != PlayerManager.Instance.Self.ID)
         {
            return;
         }
         if(Boolean(this._playerDataList[id]))
         {
            tmpData = this._playerDataList[id];
         }
         else if(Boolean(this._buffPlayerList[id]))
         {
            tmpData = this._buffPlayerList[id];
         }
         else
         {
            tmpData = this._buffCreatePlayerList[id];
         }
         if(Boolean(tmpData))
         {
            tmpData.tombstoneEndTime = pkg.readDate();
            tmpData.status = pkg.readByte();
            tmpData.pos = new Point(pkg.readInt(),pkg.readInt());
            tmpData.winningStreak = pkg.readInt();
            tmpData.failBuffCount = pkg.readInt();
            pkg.readInt();
            tmpData.PetsID = pkg.readInt();
            tmpData.Sex = pkg.readBoolean();
            tmpData.Style = pkg.readUTF();
            tmpData.Colors = pkg.readUTF();
            if(tmpData == this._playerDataList[id])
            {
               this._playerDataList.add(tmpData.id,tmpData);
            }
         }
      }
      
      private function deletePlayer(pkg:PackageIn) : void
      {
         var id:int = pkg.readInt();
         if(id == PlayerManager.Instance.Self.ID)
         {
            StateManager.setState(StateType.MAIN);
            return;
         }
         if(this.isInMainView)
         {
            this._playerDataList.remove(id);
            this._buffPlayerList.remove(id);
            this._buffCreatePlayerList.remove(id);
         }
      }
      
      private function movePlayer(pkg:PackageIn) : void
      {
         var p:Point = null;
         var event:ConsBatEvent = null;
         var tmpData:ConsortiaBattlePlayerInfo = null;
         if(!this.isInMainView)
         {
            return;
         }
         var id:int = pkg.readInt();
         var posX:int = pkg.readInt();
         var posY:int = pkg.readInt();
         var pathStr:String = pkg.readUTF();
         if(id == PlayerManager.Instance.Self.ID)
         {
            return;
         }
         var arr:Array = pathStr.split(",");
         var path:Array = [];
         for(var i:uint = 0; i < arr.length; i += 2)
         {
            p = new Point(arr[i],arr[i + 1]);
            path.push(p);
         }
         if(Boolean(this._playerDataList[id]))
         {
            event = new ConsBatEvent(MOVE_PLAYER);
            event.data = {
               "id":id,
               "path":path
            };
            dispatchEvent(event);
         }
         else
         {
            if(Boolean(this._buffPlayerList[id]))
            {
               tmpData = this._buffPlayerList[id];
            }
            else
            {
               tmpData = this._buffCreatePlayerList[id];
            }
            if(Boolean(tmpData))
            {
               tmpData.pos = path[path.length - 1];
            }
         }
      }
      
      private function addPlayerInfo(pkg:PackageIn) : void
      {
         var tmpData:ConsortiaBattlePlayerInfo = null;
         var tmpConsId:int = 0;
         if(!this.isInMainView)
         {
            return;
         }
         var count:int = pkg.readInt();
         for(var i:int = 0; i < count; i++)
         {
            tmpData = new ConsortiaBattlePlayerInfo();
            tmpData.id = pkg.readInt();
            tmpData.tombstoneEndTime = pkg.readDate();
            tmpData.status = pkg.readByte();
            tmpData.pos = new Point(pkg.readInt(),pkg.readInt());
            tmpData.sex = pkg.readBoolean();
            tmpConsId = pkg.readInt();
            if(tmpConsId == PlayerManager.Instance.Self.ConsortiaID)
            {
               tmpData.selfOrEnemy = 1;
            }
            else
            {
               tmpData.selfOrEnemy = 2;
            }
            tmpData.clothIndex = 2;
            tmpData.consortiaName = pkg.readUTF();
            tmpData.winningStreak = pkg.readInt();
            tmpData.failBuffCount = pkg.readInt();
            pkg.readInt();
            tmpData.PetsID = pkg.readInt();
            tmpData.Sex = pkg.readBoolean();
            tmpData.Style = pkg.readUTF();
            tmpData.Colors = pkg.readUTF();
            if(tmpData.id != PlayerManager.Instance.Self.ID)
            {
               this._buffPlayerList.add(tmpData.id,tmpData);
            }
         }
      }
      
      private function initSelfInfo(pkg:PackageIn) : void
      {
         var self:SelfInfo = PlayerManager.Instance.Self;
         var tmpSelfData:ConsortiaBattlePlayerInfo = new ConsortiaBattlePlayerInfo();
         tmpSelfData.id = self.ID;
         tmpSelfData.tombstoneEndTime = pkg.readDate();
         tmpSelfData.pos = new Point(pkg.readInt(),pkg.readInt());
         tmpSelfData.clothIndex = 1;
         tmpSelfData.selfOrEnemy = 1;
         tmpSelfData.consortiaName = self.ConsortiaName;
         tmpSelfData.PetsID = self.PetsID;
         tmpSelfData.sex = self.Sex;
         tmpSelfData.Style = self.Style;
         tmpSelfData.Colors = self.Colors;
         tmpSelfData.isSelf = self.isSelf;
         this._playerDataList = new DictionaryData();
         this._playerDataList.add(self.ID,tmpSelfData);
         this._curHp = pkg.readInt();
         this._victoryCount = pkg.readInt();
         this._winningStreak = pkg.readInt();
         this._score = pkg.readInt();
         this._isPowerFullUsed = pkg.readBoolean();
         this._isDoubleScoreUsed = pkg.readBoolean();
      }
      
      public function getPlayerInfo(id:int) : ConsortiaBattlePlayerInfo
      {
         return this._playerDataList[id];
      }
      
      public function clearPlayerInfo() : void
      {
         var tmp:ConsortiaBattlePlayerInfo = this._playerDataList[PlayerManager.Instance.Self.ID];
         this._playerDataList = new DictionaryData();
         if(Boolean(tmp))
         {
            this._playerDataList.add(tmp.id,tmp);
         }
         this._buffPlayerList = new DictionaryData();
         this._buffCreatePlayerList = new DictionaryData();
      }
      
      private function openOrCloseHandler(pkg:PackageIn) : void
      {
         if(pkg.readBoolean())
         {
            this._startTime = pkg.readDate();
            this._endTime = pkg.readDate();
            this._isCanEnter = pkg.readBoolean();
            this.open();
         }
         else
         {
            this._isOpen = false;
            this._startTime = null;
            this._endTime = null;
            this._isCanEnter = false;
            this._isHadShowOpenTip = false;
            dispatchEvent(new Event(CLOSE));
            DdtActivityIconManager.Instance.currObj = null;
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.consortiaBattle.closePromptTxt"),0,true);
            ChatManager.Instance.sysChatAmaranth(LanguageMgr.GetTranslation("ddt.consortiaBattle.closePromptTxt"));
         }
      }
      
      private function open() : void
      {
         this._isOpen = true;
         this._isLoadMapComplete = false;
         if(this._isCanEnter)
         {
            this.loadMap();
         }
         else
         {
            this._isLoadMapComplete = true;
         }
      }
      
      private function loadMap() : void
      {
         var mapLoader:BaseLoader = LoadResourceManager.Instance.createLoader(this.resourcePrUrl + "map/factionwarmap.swf",BaseLoader.MODULE_LOADER);
         mapLoader.addEventListener(LoaderEvent.COMPLETE,this.onMapLoadComplete);
         LoadResourceManager.Instance.startLoad(mapLoader);
      }
      
      private function onMapLoadComplete(event:LoaderEvent) : void
      {
         event.loader.removeEventListener(LoaderEvent.COMPLETE,this.onMapLoadComplete);
         this._isLoadMapComplete = true;
         if(this.isLoadIconMapComplete)
         {
            HallIconManager.instance.updateSwitchHandler(HallIconType.CONSORTIABATTLE,this._isOpen);
            dispatchEvent(new Event(ICON_AND_MAP_LOAD_COMPLETE));
            if(!this._isHadShowOpenTip)
            {
               ChatManager.Instance.sysChatAmaranth(LanguageMgr.GetTranslation("ddt.consortiaBattle.openPromptTxt"));
               this._isHadShowOpenTip = true;
            }
         }
      }
      
      public function createLoader(url:String) : BitmapLoader
      {
         return LoadResourceManager.Instance.createLoader(url,BaseLoader.BITMAP_LOADER);
      }
   }
}

