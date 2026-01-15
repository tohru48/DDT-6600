package worldboss
{
	import baglocked.BaglockedManager;
	import com.pickgliss.loader.BaseLoader;
	import com.pickgliss.loader.LoadResourceManager;
	import com.pickgliss.loader.LoaderEvent;
	import com.pickgliss.manager.CacheSysManager;
	import com.pickgliss.ui.ComponentFactory;
	import com.pickgliss.utils.ObjectUtils;
	import ddt.constants.CacheConsts;
	import ddt.events.CrazyTankSocketEvent;
	import ddt.manager.GameInSocketOut;
	import ddt.manager.LanguageMgr;
	import ddt.manager.LeavePageManager;
	import ddt.manager.MessageTipManager;
	import ddt.manager.PathManager;
	import ddt.manager.PlayerManager;
	import ddt.manager.SocketManager;
	import ddt.manager.StateManager;
	import ddt.manager.TimeManager;
	import ddt.states.StateType;
	import ddt.utils.Helpers;
	import ddt.view.UIModuleSmallLoading;
	import ddtActivityIcon.DdtActivityIconManager;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Point;
	import hallIcon.HallIconManager;
	import hallIcon.HallIconType;
	import road7th.comm.PackageIn;
	import road7th.data.DictionaryData;
	import worldBossHelper.WorldBossHelperManager;
	import worldBossHelper.event.WorldBossHelperEvent;
	import worldboss.event.WorldBossRoomEvent;
	import worldboss.model.WorldBossBuffInfo;
	import worldboss.model.WorldBossInfo;
	import worldboss.player.PlayerVO;
	import worldboss.player.RankingPersonInfo;
	import worldboss.view.WorldBossRankingFram;
	
	public class WorldBossManager extends EventDispatcher
	{
		
		private static var _instance:WorldBossManager;
		
		public static var IsSuccessStartGame:Boolean = false;
		
		private var _isOpen:Boolean = false;
		
		private var _mapload:BaseLoader;
		
		private var _bossInfo:WorldBossInfo;
		
		private var _currentPVE_ID:int;
		
		private var _sky:MovieClip;
		
		public var iconEnterPath:String = getWorldbossResource() + "/icon/worldbossIcon.swf";
		
		public var mapPath:String;
		
		private var _autoBuyBuffs:DictionaryData = new DictionaryData();
		
		private var _appearPos:Array = new Array();
		
		private var _isShowBlood:Boolean = false;
		
		private var _isBuyBuffAlert:Boolean = false;
		
		private var _bossResourceId:String;
		
		private var _rankingInfos:Vector.<RankingPersonInfo> = new Vector.<RankingPersonInfo>();
		
		private var _autoBlood:Boolean = false;
		
		private var _mapLoader:BaseLoader;
		
		private var _isLoadingState:Boolean = false;
		
		public var worldBossNum:int;
		
		public function WorldBossManager()
		{
			super();
		}
		
		public static function get Instance() : WorldBossManager
		{
			if(!WorldBossManager._instance)
			{
				WorldBossManager._instance = new WorldBossManager();
			}
			return WorldBossManager._instance;
		}
		
		public function setup() : void
		{
			this.worldBossNum = 0;
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.WORLDBOSS_INIT,this.__init);
		}
		
		public function get BossResourceId() : String
		{
			return this._bossResourceId;
		}
		
		public function get isBuyBuffAlert() : Boolean
		{
			return this._isBuyBuffAlert;
		}
		
		public function set isBuyBuffAlert(value:Boolean) : void
		{
			this._isBuyBuffAlert = value;
		}
		
		public function get autoBuyBuffs() : DictionaryData
		{
			return this._autoBuyBuffs;
		}
		
		public function get isShowBlood() : Boolean
		{
			return this._isShowBlood;
		}
		
		public function get isAutoBlood() : Boolean
		{
			return this._autoBlood;
		}
		
		public function get rankingInfos() : Vector.<RankingPersonInfo>
		{
			return this._rankingInfos;
		}
		
		private function __init(event:CrazyTankSocketEvent) : void
		{
			var buffInfo:WorldBossBuffInfo = null;
			this._bossResourceId = event.pkg.readUTF();
			this._currentPVE_ID = event.pkg.readInt();
			event.pkg.readUTF();
			this.addSocketEvent();
			this._bossInfo = new WorldBossInfo();
			this._bossInfo.myPlayerVO = new PlayerVO();
			this._bossInfo.name = event.pkg.readUTF();
			this._bossInfo.total_Blood = event.pkg.readLong();
			this._bossInfo.current_Blood = this._bossInfo.total_Blood;
			var boss_x:int = event.pkg.readInt();
			var boss_y:int = event.pkg.readInt();
			this.mapPath = this.getWorldbossResource() + "/map/worldbossMap.swf";
			this._appearPos.length = 0;
			var posCount:int = event.pkg.readInt();
			for(var j:int = 0; j < posCount; j++)
			{
				this._appearPos.push(new Point(event.pkg.readInt(),event.pkg.readInt()));
			}
			this._bossInfo.playerDefaultPos = Helpers.randomPick(this._appearPos);
			this._bossInfo.begin_time = event.pkg.readDate();
			this._bossInfo.end_time = event.pkg.readDate();
			this._bossInfo.fight_time = event.pkg.readInt();
			this._bossInfo.fightOver = event.pkg.readBoolean();
			this._bossInfo.roomClose = event.pkg.readBoolean();
			this._bossInfo.ticketID = event.pkg.readInt();
			this._bossInfo.need_ticket_count = event.pkg.readInt();
			this._bossInfo.timeCD = event.pkg.readInt();
			this._bossInfo.reviveMoney = event.pkg.readInt();
			this._bossInfo.reFightMoney = event.pkg.readInt();
			this._bossInfo.addInjureBuffMoney = event.pkg.readInt();
			this._bossInfo.addInjureValue = event.pkg.readInt();
			this._bossInfo.buffArray.length = 0;
			var count:int = event.pkg.readInt();
			for(var i:int = 0; i < count; i++)
			{
				buffInfo = new WorldBossBuffInfo();
				buffInfo.ID = event.pkg.readInt();
				buffInfo.name = event.pkg.readUTF();
				buffInfo.price = event.pkg.readInt();
				buffInfo.decription = event.pkg.readUTF();
				buffInfo.costID = event.pkg.readInt();
				this._bossInfo.buffArray.push(buffInfo);
			}
			this._isShowBlood = event.pkg.readBoolean();
			this._autoBlood = event.pkg.readBoolean();
			this.isOpen = true;
			this.addshowHallEntranceBtn();
			WorldBossManager.Instance.isLoadingState = false;
			++this.worldBossNum;
			dispatchEvent(new WorldBossRoomEvent(WorldBossRoomEvent.GAME_INIT));
			if(WorldBossHelperManager.Instance.isInWorldBossHelperFrame && WorldBossHelperManager.Instance.helperOpen)
			{
				if(WorldBossHelperManager.Instance.isHelperOnlyOnce)
				{
					if(this.worldBossNum > 1)
					{
						return;
					}
					WorldBossHelperManager.Instance.dispatchEvent(new WorldBossHelperEvent(WorldBossHelperEvent.BOSS_OPEN));
				}
				else
				{
					WorldBossHelperManager.Instance.dispatchEvent(new WorldBossHelperEvent(WorldBossHelperEvent.BOSS_OPEN));
				}
			}
		}
		
		private function addSocketEvent() : void
		{
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.WORLDBOSS_ENTER,this.__enter);
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.WORLDBOSS_BLOOD_UPDATE,this.__update);
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.WORLDBOSS_FIGHTOVER,this.__fightOver);
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.WORLDBOSS_ROOMCLOSE,this.__leaveRoom);
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.WORLDBOSS_RANKING,this.__showRanking);
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.WORLDBOSS_OVER,this.__allOver);
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.GAME_ROOM_FULL,this.__gameRoomFull);
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.UPDATE_BUFF_LEVEL,this.__updateBuffLevel);
			SocketManager.Instance.addEventListener(CrazyTankSocketEvent.WORLDBOSS_PRIVATE_INFO,this.__updatePrivateInfo);
		}
		
		private function removeSocketEvent() : void
		{
			SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.WORLDBOSS_ENTER,this.__enter);
			SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.WORLDBOSS_BLOOD_UPDATE,this.__update);
			SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.WORLDBOSS_FIGHTOVER,this.__fightOver);
			SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.WORLDBOSS_ROOMCLOSE,this.__leaveRoom);
			SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.WORLDBOSS_RANKING,this.__showRanking);
			SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.WORLDBOSS_OVER,this.__allOver);
			SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.GAME_ROOM_FULL,this.__gameRoomFull);
			SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.UPDATE_BUFF_LEVEL,this.__updateBuffLevel);
			SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.WORLDBOSS_PRIVATE_INFO,this.__updatePrivateInfo);
		}
		
		protected function __updatePrivateInfo(event:CrazyTankSocketEvent) : void
		{
			var pkg:PackageIn = event.pkg;
			WorldBossManager.Instance.bossInfo.myPlayerVO.myDamage = pkg.readInt();
			WorldBossManager.Instance.bossInfo.myPlayerVO.myHonor = pkg.readInt();
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		protected function __updateBuffLevel(event:CrazyTankSocketEvent) : void
		{
			var pkg:PackageIn = event.pkg;
			WorldBossManager.Instance.bossInfo.myPlayerVO.buffLevel = pkg.readInt();
			WorldBossManager.Instance.bossInfo.myPlayerVO.buffInjure = pkg.readInt();
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		private function __gameRoomFull(pEvent:CrazyTankSocketEvent) : void
		{
			dispatchEvent(new WorldBossRoomEvent(WorldBossRoomEvent.WORLDBOSS_ROOM_FULL));
		}
		
		public function creatEnterIcon($isUse:Boolean = true, type:int = 1, $timeStr:String = null) : void
		{
			this._bossResourceId = type.toString();
			HallIconManager.instance.updateSwitchHandler(HallIconType["WORLDBOSSENTRANCE" + this._bossResourceId],true,$timeStr);
		}
		
		public function disposeEnterBtn() : void
		{
			HallIconManager.instance.updateSwitchHandler(HallIconType["WORLDBOSSENTRANCE" + this._bossResourceId],false);
		}
		
		private function __enter(event:CrazyTankSocketEvent) : void
		{
			var count:int = 0;
			var i:int = 0;
			if(event.pkg.bytesAvailable > 0 && event.pkg.readBoolean())
			{
				this._bossInfo.isLiving = !event.pkg.readBoolean();
				this._bossInfo.myPlayerVO.reviveCD = event.pkg.readInt();
				count = event.pkg.readInt();
				for(i = 0; i < count; i++)
				{
					this._bossInfo.myPlayerVO.buffID = event.pkg.readInt();
				}
				if(this._bossInfo.myPlayerVO.reviveCD > 0)
				{
					this._bossInfo.myPlayerVO.playerStauts = 3;
					this._bossInfo.myPlayerVO.playerPos = new Point(int(Math.random() * 300 + 300),int(Math.random() * 850) + 350);
				}
				else
				{
					this._bossInfo.myPlayerVO.playerPos = this._bossInfo.playerDefaultPos;
					this._bossInfo.myPlayerVO.playerStauts = 1;
				}
				dispatchEvent(new WorldBossRoomEvent(WorldBossRoomEvent.ALLOW_ENTER));
				this.loadMap();
			}
		}
		
		private function loadMap() : void
		{
			this._mapLoader = LoadResourceManager.Instance.createLoader(WorldBossManager.Instance.mapPath,BaseLoader.MODULE_LOADER);
			this._mapLoader.addEventListener(LoaderEvent.COMPLETE,this.onMapSrcLoadedComplete);
			LoadResourceManager.Instance.startLoad(this._mapLoader);
		}
		
		private function onMapSrcLoadedComplete(e:Event) : void
		{
			if(StateManager.getState(StateType.WORLDBOSS_ROOM) == null)
			{
				UIModuleSmallLoading.Instance.addEventListener(Event.CLOSE,this.__loadingIsCloseRoom);
			}
			StateManager.setState(StateType.WORLDBOSS_ROOM);
		}
		
		private function __loadingIsCloseRoom(e:Event) : void
		{
			UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__loadingIsCloseRoom);
		}
		
		private function __update(event:CrazyTankSocketEvent) : void
		{
			this._autoBlood = event.pkg.readBoolean();
			this._bossInfo.total_Blood = event.pkg.readLong();
			this._bossInfo.current_Blood = event.pkg.readLong();
			dispatchEvent(new WorldBossRoomEvent(WorldBossRoomEvent.BOSS_HP_UPDATA));
		}
		
		private function __fightOver(event:CrazyTankSocketEvent) : void
		{
			this._bossInfo.fightOver = true;
			this._bossInfo.isLiving = !event.pkg.readBoolean();
			dispatchEvent(new WorldBossRoomEvent(WorldBossRoomEvent.FIGHT_OVER));
		}
		
		private function __leaveRoom(e:Event) : void
		{
			this._bossInfo.roomClose = true;
			if(StateManager.currentStateType == StateType.WORLDBOSS_ROOM)
			{
				StateManager.setState(StateType.MAIN);
				WorldBossRoomController.Instance.dispose();
			}
			dispatchEvent(new WorldBossRoomEvent(WorldBossRoomEvent.ROOM_CLOSE));
		}
		
		private function __showRanking(evt:CrazyTankSocketEvent) : void
		{
			if(evt.pkg.readBoolean())
			{
				this.showRankingFrame(evt.pkg);
			}
			else
			{
				this.showRankingInRoom(evt.pkg);
			}
		}
		
		private function showRankingFrame(pkg:PackageIn) : void
		{
			var personInfo:RankingPersonInfo = null;
			this._rankingInfos.length = 0;
			WorldBossRankingFram._rankingPersons = new Array();
			var rankingFrame:WorldBossRankingFram = ComponentFactory.Instance.creat("worldboss.ranking.frame");
			var count:int = pkg.readInt();
			for(var i:int = 0; i < count; i++)
			{
				personInfo = new RankingPersonInfo();
				personInfo.id = pkg.readInt();
				personInfo.name = pkg.readUTF();
				personInfo.damage = pkg.readInt();
				rankingFrame.addPersonRanking(personInfo);
				this._rankingInfos.push(personInfo);
			}
			if(!(CacheSysManager.isLock(CacheConsts.ALERT_IN_FIGHT) && StateManager.currentStateType != StateType.WORLDBOSS_ROOM))
			{
				rankingFrame.show();
			}
		}
		
		private function showRankingInRoom(pkg:PackageIn) : void
		{
			dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.WORLDBOSS_RANKING_INROOM,pkg));
		}
		
		private function __allOver(event:CrazyTankSocketEvent) : void
		{
			this._bossInfo.fightOver = true;
			this._bossInfo.roomClose = true;
			this.isOpen = false;
			this.disposeEnterBtn();
			this.removeSocketEvent();
			DdtActivityIconManager.Instance.currObj = null;
		}
		
		public function enterGame() : void
		{
			SocketManager.Instance.out.enterUserGuide(WorldBossManager.Instance.currentPVE_ID,14);
			if(!WorldBossManager.Instance.bossInfo.fightOver)
			{
				IsSuccessStartGame = true;
				GameInSocketOut.sendGameStart();
				SocketManager.Instance.out.sendWorldBossRoomStauts(2);
				dispatchEvent(new Event(WorldBossRoomEvent.ENTERING_GAME));
			}
			else
			{
				StateManager.setState(StateType.WORLDBOSS_ROOM);
			}
		}
		
		public function exitGame() : void
		{
			IsSuccessStartGame = false;
			GameInSocketOut.sendGamePlayerExit();
		}
		
		public function addshowHallEntranceBtn() : void
		{
			if(this.isOpen)
			{
				HallIconManager.instance.updateSwitchHandler(HallIconType["WORLDBOSSENTRANCE" + this._bossResourceId],true);
			}
		}
		
		public function showHallSkyEffort(sky:MovieClip) : void
		{
			if(sky == this._sky)
			{
				return;
			}
			ObjectUtils.disposeObject(this._sky);
			this._sky = sky;
		}
		
		public function set isOpen(value:Boolean) : void
		{
			this._isOpen = value;
			if(StateManager.currentStateType == StateType.MAIN)
			{
				if(Boolean(this._sky))
				{
					this._sky.visible = !this._bossInfo.fightOver;
				}
			}
			if((StateManager.currentStateType == StateType.WORLDBOSS_AWARD || StateManager.currentStateType == StateType.WORLDBOSS_ROOM) && !this.isOpen)
			{
				StateManager.setState(StateType.MAIN);
			}
		}
		
		public function get isOpen() : Boolean
		{
			return this._isOpen;
		}
		
		public function get currentPVE_ID() : int
		{
			return this._currentPVE_ID;
		}
		
		public function get bossInfo() : WorldBossInfo
		{
			return this._bossInfo;
		}
		
		public function getWorldbossResource() : String
		{
			var temp:String = _bossResourceId == null ? "1" : _bossResourceId;
			return PathManager.SITE_MAIN + "image/worldboss/" + temp;
		}
		
		public function showRankingText() : void
		{
			var personInfo:RankingPersonInfo = null;
			WorldBossRankingFram._rankingPersons = new Array();
			var rankingFrame:WorldBossRankingFram = ComponentFactory.Instance.creat("worldboss.ranking.frame");
			for(var i:int = 0; i < 10; i++)
			{
				personInfo = new RankingPersonInfo();
				personInfo.id = 1;
				personInfo.name = "hawang" + i;
				personInfo.damage = 2 * i + i * i + 50;
				rankingFrame.addPersonRanking(personInfo);
			}
			rankingFrame.show();
		}
		
		public function buyNewBuff(type:int, isBuyFull:Boolean) : void
		{
			if(PlayerManager.Instance.Self.bagLocked)
			{
				BaglockedManager.Instance.show();
				return;
			}
			var curLevel:int = this.bossInfo.myPlayerVO.buffLevel;
			if(curLevel >= 20)
			{
				MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.worldboss.buffLevelMax"));
				return;
			}
			var addInjureBuffMoney:int = WorldBossManager.Instance.bossInfo.addInjureBuffMoney;
			var needMoney:int = addInjureBuffMoney;
			if(isBuyFull)
			{
				needMoney = (20 - curLevel) * addInjureBuffMoney;
			}
			if(type == 1)
			{
				if(PlayerManager.Instance.Self.Money < needMoney)
				{
					LeavePageManager.showFillFrame();
					return;
				}
			}
			else if(type == 2)
			{
				if(PlayerManager.Instance.Self.BandMoney < needMoney)
				{
					MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.view.transfer.StoreIITransferBG.lijinbuzu"));
					return;
				}
			}
			SocketManager.Instance.out.sendNewBuyWorldBossBuff(type,isBuyFull ? 20 - curLevel : 1);
		}
		
		public function set isLoadingState(value:Boolean) : void
		{
			this._isLoadingState = value;
		}
		
		public function get isLoadingState() : Boolean
		{
			return this._isLoadingState;
		}
		
		public function get beforeStartTime() : int
		{
			if(!this._bossInfo || !this._bossInfo.begin_time)
			{
				return 0;
			}
			return this.getDateHourTime(this._bossInfo.begin_time) + 300 - this.getDateHourTime(TimeManager.Instance.Now());
		}
		
		private function getDateHourTime(date:Date) : int
		{
			return int(date.hours * 3600 + date.minutes * 60 + date.seconds);
		}
	}
}

