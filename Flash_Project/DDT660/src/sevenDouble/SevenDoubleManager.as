package sevenDouble
{
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.LoadResourceManager;
   import com.pickgliss.loader.LoaderEvent;
   import com.pickgliss.loader.UIModuleLoader;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import ddt.data.ServerConfigInfo;
   import ddt.data.UIModuleTypes;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.ChatManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PathManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.ServerConfigManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.TimeManager;
   import ddt.view.UIModuleSmallLoading;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import road7th.comm.PackageIn;
   import road7th.data.DictionaryData;
   import sevenDouble.data.SevenDoubleCarInfo;
   import sevenDouble.data.SevenDoubleInfoVo;
   import sevenDouble.data.SevenDoublePlayerInfo;
   import sevenDouble.event.SevenDoubleEvent;
   import sevenDouble.view.SevenDoubleFrame;
   
   public class SevenDoubleManager extends EventDispatcher
   {
      
      private static var _instance:SevenDoubleManager;
      
      public static const ICON_RES_LOAD_COMPLETE:String = "sevenDoubleIconResLoadComplete";
      
      public static const CAR_STATUS_CHANGE:String = "sevenDoubleCarStatusChange";
      
      public static const START_GAME:String = "sevenDoubleStartGame";
      
      public static const ENTER_GAME:String = "sevenDoubleEnterGame";
      
      public static const ALL_READY:String = "sevenDoubleAllReady";
      
      public static const MOVE:String = "sevenDoubleMove";
      
      public static const REFRESH_ITEM:String = "sevenDoubleAppearItem";
      
      public static const REFRESH_BUFF:String = "sevenDoubleRefreshBuff";
      
      public static const USE_SKILL:String = "sevenDoubleUseSkill";
      
      public static const RANK_LIST:String = "sevenDoubleRankList";
      
      public static const RANK_ARRIVE_LIST:String = "";
      
      public static const ARRIVE:String = "sevenDoubleArrive";
      
      public static const DESTROY:String = "sevenDoubleDestroy";
      
      public static const RE_ENTER_ALL_INFO:String = "sevenDoubleReEnterAllInfo";
      
      public static const CAN_ENTER:String = "sevenDoubleCanEnter";
      
      public static const FIGHT_STATE_CHANGE:String = "sevenDoubleFightStateChange";
      
      public static const LEAP_PROMPT_SHOW_HIDE:String = "sevenDoubleLeapPromptShowHide";
      
      public static const END:String = "sevenDoubleEnd";
      
      public static const REFRESH_ENTER_COUNT:String = "sevenDoubleRefreshEnterCount";
      
      public static const REFRESH_ITEM_FREE_COUNT:String = "sevenDoubleRefreshItemCount";
      
      public static const CANCEL_GAME:String = "sevenDoubleCancelGame";
      
      public var dataInfo:SevenDoubleInfoVo;
      
      public var isShowDungeonTip:Boolean = true;
      
      private var _isStart:Boolean;
      
      private var _isLoadIconComplete:Boolean;
      
      private var _isInGame:Boolean;
      
      private var _carStatus:int;
      
      private var _freeCount:int;
      
      private var _usableCount:int;
      
      private var _rankAddInfo:Array;
      
      private var _playerList:Vector.<SevenDoublePlayerInfo>;
      
      private var _accelerateRate:int;
      
      private var _decelerateRate:int;
      
      private var _buyRecordStatus:Array;
      
      private var _startGameNeedMoney:int;
      
      private var _doubleTimeArray:Array = [];
      
      private var _timer:Timer;
      
      private var _itemFreeCountList:Array = [0,0,0];
      
      private var _sprintAwardInfo:Array;
      
      private var _endTime:int = -1;
      
      private var _hasPrompted:DictionaryData;
      
      private var _isPromptDoubleTime:Boolean = false;
      
      private var _loadResCount:int;
      
      public function SevenDoubleManager(target:IEventDispatcher = null)
      {
         super(target);
      }
      
      public static function get instance() : SevenDoubleManager
      {
         if(_instance == null)
         {
            _instance = new SevenDoubleManager();
         }
         return _instance;
      }
      
      public function get sprintAwardInfo() : Array
      {
         return this._sprintAwardInfo;
      }
      
      public function get itemFreeCountList() : Array
      {
         return this._itemFreeCountList;
      }
      
      public function get isInDoubleTime() : Boolean
      {
         var nowDate:Date = TimeManager.Instance.Now();
         var nowHours:Number = nowDate.hours;
         var nowMin:Number = nowDate.minutes;
         var startHour:int = int(this._doubleTimeArray[0]);
         var startMin:int = int(this._doubleTimeArray[1]);
         var endHour:int = int(this._doubleTimeArray[2]);
         var endMin:int = int(this._doubleTimeArray[3]);
         var startHour2:int = int(this._doubleTimeArray[4]);
         var startMin2:int = int(this._doubleTimeArray[5]);
         var endHour2:int = int(this._doubleTimeArray[6]);
         var endMin2:int = int(this._doubleTimeArray[7]);
         if((nowHours > startHour || nowHours == startHour && nowMin >= startMin) && (nowHours < endHour || nowHours == endHour && nowMin < endMin) || (nowHours > startHour2 || nowHours == startHour2 && nowMin >= startMin2) && (nowHours < endHour2 || nowHours == endHour2 && nowMin < endMin2))
         {
            return true;
         }
         return false;
      }
      
      public function get startGameNeedMoney() : int
      {
         return this._startGameNeedMoney;
      }
      
      public function getBuyRecordStatus(index:int) : Object
      {
         var i:int = 0;
         var obj:Object = null;
         if(!this._buyRecordStatus)
         {
            this._buyRecordStatus = [];
            for(i = 0; i < 5; i++)
            {
               obj = {};
               obj.isNoPrompt = false;
               obj.isBand = false;
               this._buyRecordStatus.push(obj);
            }
         }
         return this._buyRecordStatus[index];
      }
      
      public function get rankAddInfo() : Array
      {
         return this._rankAddInfo;
      }
      
      public function get decelerateRate() : int
      {
         return this._decelerateRate;
      }
      
      public function get accelerateRate() : int
      {
         return this._accelerateRate;
      }
      
      public function get playerList() : Vector.<SevenDoublePlayerInfo>
      {
         return this._playerList;
      }
      
      public function get usableCount() : int
      {
         return this._usableCount;
      }
      
      public function get freeCount() : int
      {
         return this._freeCount;
      }
      
      public function get carStatus() : int
      {
         return this._carStatus;
      }
      
      public function get isInGame() : Boolean
      {
         return this._isInGame;
      }
      
      public function get isStart() : Boolean
      {
         return this._isStart;
      }
      
      public function get isLoadIconComplete() : Boolean
      {
         return this._isLoadIconComplete;
      }
      
      public function setup() : void
      {
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.SEVEN_DOUBLE,this.pkgHandler);
      }
      
      private function pkgHandler(event:CrazyTankSocketEvent) : void
      {
         var pkg:PackageIn = event.pkg;
         var cmd:int = pkg.readByte();
         switch(cmd)
         {
            case SevenDoublePackageType.START_OR_END:
               this.openOrCloseHandler(pkg);
               break;
            case SevenDoublePackageType.CALL:
               this.changeCarStatus(pkg);
               break;
            case SevenDoublePackageType.START_GAME:
               this.startGameHandler(pkg);
               break;
            case SevenDoublePackageType.ENTER_GAME:
               this.enterGameHandler(pkg);
               break;
            case SevenDoublePackageType.ALL_READY:
               this.allReadyHandler(pkg);
               break;
            case SevenDoublePackageType.MOVE:
               this.moveHandler(pkg);
               break;
            case SevenDoublePackageType.REFRESH_ITEM:
               this.refreshItemHandler(pkg);
               break;
            case SevenDoublePackageType.REFRESH_BUFF:
               this.refreshBuffHandler(pkg);
               break;
            case SevenDoublePackageType.USE_SKILL:
               this.useSkillHandler(pkg);
               break;
            case SevenDoublePackageType.RANK_LIST:
               this.rankListHandler(pkg);
               break;
            case SevenDoublePackageType.ARRIVE:
               this.arriveHandler(pkg);
               break;
            case SevenDoublePackageType.DESTROY:
               this.destroyHandler(pkg);
               break;
            case SevenDoublePackageType.RE_ENTER_ALL_INFO:
               this.reEnterAllInfoHandler(pkg);
               break;
            case SevenDoublePackageType.IS_CAN_ENTER:
               this.canEnterHandler(pkg);
               break;
            case SevenDoublePackageType.REFRESH_FIGHT_STATE:
               this.refreshFightStateHandler(pkg);
               break;
            case SevenDoublePackageType.REFRESH_ENTER_COUNT:
               this.refreshEnterCountHandler(pkg);
               break;
            case SevenDoublePackageType.REFRESH_ITEM_FREE_COUNT:
               this.refreshItemFreeCountHandler(pkg);
               break;
            case SevenDoublePackageType.CANCEL_GAME:
               dispatchEvent(new Event(CANCEL_GAME));
         }
      }
      
      private function refreshItemFreeCountHandler(pkg:PackageIn) : void
      {
         this._itemFreeCountList[0] = pkg.readInt();
         this._itemFreeCountList[1] = pkg.readInt();
         this._itemFreeCountList[2] = pkg.readInt();
         dispatchEvent(new Event(REFRESH_ITEM_FREE_COUNT));
      }
      
      private function refreshEnterCountHandler(pkg:PackageIn) : void
      {
         this._freeCount = pkg.readInt();
         this._usableCount = pkg.readInt();
         dispatchEvent(new Event(REFRESH_ENTER_COUNT));
      }
      
      private function refreshFightStateHandler(pkg:PackageIn) : void
      {
         var id:int = pkg.readInt();
         var zoneId:int = pkg.readInt();
         var fightState:int = pkg.readInt();
         var posX:int = pkg.readInt();
         var tmpEvent:SevenDoubleEvent = new SevenDoubleEvent(FIGHT_STATE_CHANGE);
         tmpEvent.data = {
            "id":id,
            "zoneId":zoneId,
            "fightState":fightState,
            "posX":posX
         };
         dispatchEvent(tmpEvent);
      }
      
      private function canEnterHandler(pkg:PackageIn) : void
      {
         this._isInGame = pkg.readBoolean();
         if(this._isInGame)
         {
            dispatchEvent(new SevenDoubleEvent(CAN_ENTER));
         }
         else
         {
            this.loadSevenDoubleModule();
         }
      }
      
      private function reEnterAllInfoHandler(pkg:PackageIn) : void
      {
         var tmp:SevenDoublePlayerInfo = null;
         var endTime:Date = pkg.readDate();
         this._playerList = new Vector.<SevenDoublePlayerInfo>();
         var count:int = pkg.readInt();
         for(var i:int = 0; i < count; i++)
         {
            tmp = new SevenDoublePlayerInfo();
            tmp.index = i;
            tmp.id = pkg.readInt();
            tmp.zoneId = pkg.readInt();
            tmp.name = pkg.readUTF();
            tmp.carType = pkg.readInt();
            tmp.posX = pkg.readInt();
            tmp.fightState = pkg.readInt();
            tmp.acceleEndTime = pkg.readDate();
            tmp.deceleEndTime = pkg.readDate();
            tmp.invisiEndTime = pkg.readDate();
            if(tmp.zoneId == PlayerManager.Instance.Self.ZoneID && tmp.id == PlayerManager.Instance.Self.ID)
            {
               tmp.isSelf = true;
            }
            else
            {
               tmp.isSelf = false;
            }
            this._playerList.push(tmp);
         }
         dispatchEvent(new Event(RE_ENTER_ALL_INFO));
         this.refreshItemHandler(pkg);
         this.rankListHandler(pkg);
         var sprintEndTime:Date = pkg.readDate();
         var tmpEvent:SevenDoubleEvent = new SevenDoubleEvent(ALL_READY);
         tmpEvent.data = {
            "endTime":endTime,
            "isShowStartCountDown":false,
            "sprintEndTime":sprintEndTime
         };
         dispatchEvent(tmpEvent);
      }
      
      private function destroyHandler(pkg:PackageIn) : void
      {
         this._isInGame = false;
         this._carStatus = 0;
         dispatchEvent(new SevenDoubleEvent(DESTROY));
      }
      
      private function arriveHandler(pkg:PackageIn) : void
      {
         var id:int = pkg.readInt();
         var zoneId:int = pkg.readInt();
         if(zoneId == PlayerManager.Instance.Self.ZoneID && id == PlayerManager.Instance.Self.ID)
         {
            this._isInGame = false;
            this._carStatus = 0;
         }
         var tmpEvent:SevenDoubleEvent = new SevenDoubleEvent(ARRIVE);
         tmpEvent.data = {
            "id":id,
            "zoneId":zoneId
         };
         dispatchEvent(tmpEvent);
      }
      
      private function rankListHandler(pkg:PackageIn) : void
      {
         var rank:int = 0;
         var name:String = null;
         var carType:int = 0;
         var id:int = 0;
         var zoneId:int = 0;
         var isSprint:Boolean = false;
         var count:int = pkg.readInt();
         var rankList:Array = [];
         for(var i:int = 0; i < count; i++)
         {
            rank = pkg.readInt();
            name = pkg.readUTF();
            carType = pkg.readInt();
            id = pkg.readInt();
            zoneId = pkg.readInt();
            isSprint = pkg.readBoolean();
            rankList.push({
               "rank":rank,
               "name":name,
               "carType":carType,
               "id":id,
               "zoneId":zoneId,
               "isSprint":isSprint
            });
         }
         rankList.sortOn("rank",Array.NUMERIC);
         var tmpEvent:SevenDoubleEvent = new SevenDoubleEvent(RANK_ARRIVE_LIST);
         tmpEvent.data = rankList;
         dispatchEvent(tmpEvent);
      }
      
      private function useSkillHandler(pkg:PackageIn) : void
      {
         var id:int = pkg.readInt();
         var zoneId:int = pkg.readInt();
         var leapX:int = pkg.readInt();
         var tmpEvent:SevenDoubleEvent = new SevenDoubleEvent(USE_SKILL);
         tmpEvent.data = {
            "id":id,
            "zoneId":zoneId,
            "leapX":leapX,
            "sound":true
         };
         dispatchEvent(tmpEvent);
      }
      
      private function refreshBuffHandler(pkg:PackageIn) : void
      {
         var id:int = pkg.readInt();
         var zoneId:int = pkg.readInt();
         var acceleEndTime:Date = pkg.readDate();
         var deceleEndTime:Date = pkg.readDate();
         var invisiEndTime:Date = pkg.readDate();
         var tmpEvent:SevenDoubleEvent = new SevenDoubleEvent(REFRESH_BUFF);
         tmpEvent.data = {
            "id":id,
            "zoneId":zoneId,
            "acceleEndTime":acceleEndTime,
            "deceleEndTime":deceleEndTime,
            "invisiEndTime":invisiEndTime
         };
         dispatchEvent(tmpEvent);
      }
      
      private function refreshItemHandler(pkg:PackageIn) : void
      {
         var index:int = 0;
         var type:int = 0;
         var posX:int = 0;
         var tag:int = 0;
         var count:int = pkg.readInt();
         var itemList:Array = [];
         for(var i:int = 0; i < count; i++)
         {
            index = pkg.readInt();
            type = pkg.readInt();
            posX = pkg.readInt();
            tag = pkg.readInt();
            itemList.push({
               "index":index,
               "type":type,
               "posX":posX,
               "tag":tag
            });
         }
         var tmpEvent:SevenDoubleEvent = new SevenDoubleEvent(REFRESH_ITEM);
         tmpEvent.data = {"itemList":itemList};
         dispatchEvent(tmpEvent);
      }
      
      private function moveHandler(pkg:PackageIn) : void
      {
         var id:int = pkg.readInt();
         var zoneId:int = pkg.readInt();
         var destX:Number = pkg.readInt();
         var tmpEvent:SevenDoubleEvent = new SevenDoubleEvent(MOVE);
         tmpEvent.data = {
            "zoneId":zoneId,
            "id":id,
            "destX":destX
         };
         dispatchEvent(tmpEvent);
      }
      
      private function allReadyHandler(pkg:PackageIn) : void
      {
         var endTime:Date = pkg.readDate();
         var sprintEndTime:Date = pkg.readDate();
         var tmpEvent:SevenDoubleEvent = new SevenDoubleEvent(ALL_READY);
         tmpEvent.data = {
            "endTime":endTime,
            "isShowStartCountDown":true,
            "sprintEndTime":sprintEndTime
         };
         dispatchEvent(tmpEvent);
      }
      
      private function enterGameHandler(pkg:PackageIn) : void
      {
         var tmp:SevenDoublePlayerInfo = null;
         this._playerList = new Vector.<SevenDoublePlayerInfo>();
         var count:int = pkg.readInt();
         for(var i:int = 0; i < count; i++)
         {
            tmp = new SevenDoublePlayerInfo();
            tmp.index = i;
            tmp.zoneId = pkg.readInt();
            tmp.id = pkg.readInt();
            tmp.carType = pkg.readInt();
            tmp.name = pkg.readUTF();
            if(tmp.zoneId == PlayerManager.Instance.Self.ZoneID && tmp.id == PlayerManager.Instance.Self.ID)
            {
               tmp.isSelf = true;
            }
            else
            {
               tmp.isSelf = false;
            }
            this._playerList.push(tmp);
         }
         this._isInGame = true;
         dispatchEvent(new Event(ENTER_GAME));
      }
      
      private function startGameHandler(pkg:PackageIn) : void
      {
         dispatchEvent(new Event(START_GAME));
      }
      
      private function changeCarStatus(pkg:PackageIn) : void
      {
         this._carStatus = pkg.readInt();
         dispatchEvent(new Event(CAR_STATUS_CHANGE));
      }
      
      private function openOrCloseHandler(pkg:PackageIn) : void
      {
         var count:int = 0;
         var i:int = 0;
         var j:int = 0;
         var tmpStr:String = null;
         var tmpArray:Array = null;
         var tmpTimeArray:Array = null;
         var n:int = 0;
         var endTimeInfo:ServerConfigInfo = null;
         var endTimeArray:Array = null;
         var endTimeArray2:Array = null;
         var endTimeArray3:Array = null;
         var tmpEndTime:Date = null;
         var tmp:SevenDoubleCarInfo = null;
         var tmpLen:int = 0;
         var k:int = 0;
         var tmpId:int = 0;
         var tmpCount:int = 0;
         var tmpArray1:Array = null;
         var m:int = 0;
         pkg.readInt();
         this._isStart = pkg.readBoolean();
         if(this._isStart)
         {
            this.dataInfo = new SevenDoubleInfoVo();
            this._isInGame = pkg.readBoolean();
            this._freeCount = pkg.readInt();
            this._usableCount = pkg.readInt();
            this._carStatus = pkg.readInt();
            this.dataInfo.carInfo = {};
            count = pkg.readInt();
            for(i = 0; i < count; i++)
            {
               tmp = new SevenDoubleCarInfo();
               tmp.type = pkg.readInt();
               tmp.needMoney = pkg.readInt();
               tmp.speed = pkg.readInt();
               tmpLen = pkg.readInt();
               for(k = 0; k < tmpLen; k++)
               {
                  tmpId = pkg.readInt();
                  tmpCount = pkg.readInt();
                  if(tmpId == -1300)
                  {
                     tmp.prestige = tmpCount;
                  }
                  else
                  {
                     tmp.itemId = tmpId;
                     tmp.itemCount = tmpCount;
                  }
               }
               this.dataInfo.carInfo[tmp.type] = tmp;
            }
            this.dataInfo.useSkillNeedMoney = [];
            this.dataInfo.useSkillNeedMoney.push(pkg.readInt());
            this.dataInfo.useSkillNeedMoney.push(pkg.readInt());
            this.dataInfo.useSkillNeedMoney.push(pkg.readInt());
            this._rankAddInfo = [];
            count = pkg.readInt();
            for(j = 0; j < count; j++)
            {
               this._rankAddInfo.push(pkg.readInt());
            }
            this._accelerateRate = pkg.readInt();
            this._decelerateRate = pkg.readInt();
            this._startGameNeedMoney = pkg.readInt();
            tmpStr = pkg.readUTF();
            tmpArray = [];
            tmpTimeArray = tmpStr.split("|");
            for(n = 0; n < tmpTimeArray.length; n++)
            {
               tmpArray1 = tmpTimeArray[n].split(",");
               for(m = 0; m < tmpArray1.length; m++)
               {
                  tmpArray = tmpArray.concat(tmpArray1[m].split(":"));
               }
            }
            this._doubleTimeArray = tmpArray;
            this._sprintAwardInfo = pkg.readUTF().split(",");
            this._timer = new Timer(1000);
            this._timer.addEventListener(TimerEvent.TIMER,this.timerHandler,false,0,true);
            this._timer.start();
            this.open();
            endTimeInfo = ServerConfigManager.instance.findInfoByName("Activity77EndDate");
            endTimeArray = endTimeInfo.Value.split(" ");
            if((endTimeArray[0] as String).indexOf("-") > 0)
            {
               endTimeArray2 = endTimeArray[0].split("-");
            }
            else
            {
               endTimeArray2 = endTimeArray[0].split("/");
            }
            endTimeArray3 = endTimeArray[1].split(":");
            tmpEndTime = new Date(endTimeArray2[0],int(endTimeArray2[1]) - 1,endTimeArray2[2],endTimeArray3[0],endTimeArray3[1],endTimeArray3[2]);
            this._endTime = tmpEndTime.getTime() / 1000;
            this._hasPrompted = new DictionaryData();
         }
         else
         {
            this._isInGame = false;
            if(Boolean(this._timer))
            {
               this._timer.removeEventListener(TimerEvent.TIMER,this.timerHandler);
               this._timer.stop();
               this._timer = null;
            }
            dispatchEvent(new Event(END));
         }
      }
      
      private function timerHandler(event:TimerEvent) : void
      {
         var nowTimeSec:int = 0;
         var diff:int = 0;
         var residue:int = 0;
         var onTime:int = 0;
         if(this.isInDoubleTime)
         {
            if(!this._isPromptDoubleTime)
            {
               ChatManager.Instance.sysChatAmaranth(LanguageMgr.GetTranslation("sevenDouble.doubleTime.startTipTxt"));
               this._isPromptDoubleTime = true;
            }
         }
         else if(this._isPromptDoubleTime)
         {
            ChatManager.Instance.sysChatAmaranth(LanguageMgr.GetTranslation("sevenDouble.doubleTime.endTipTxt"));
            this._isPromptDoubleTime = false;
         }
         if(this._endTime > 0)
         {
            nowTimeSec = TimeManager.Instance.Now().getTime() / 1000;
            diff = this._endTime - nowTimeSec;
            if(diff > 0)
            {
               residue = diff % 3600;
               if(residue < 5)
               {
                  onTime = diff / 3600;
                  if(onTime <= 48 && onTime > 0 && !this._hasPrompted.hasKey(onTime))
                  {
                     ChatManager.Instance.sysChatAmaranth(LanguageMgr.GetTranslation("escort.willEnd.promptTxt",onTime));
                     this._hasPrompted.add(onTime,1);
                  }
               }
            }
         }
      }
      
      public function enterMainViewHandler() : void
      {
      }
      
      public function leaveMainViewHandler() : void
      {
         this._playerList = null;
      }
      
      public function open() : void
      {
         this._isLoadIconComplete = true;
         dispatchEvent(new Event(ICON_RES_LOAD_COMPLETE));
      }
      
      public function loadSevenDoubleModule() : void
      {
         this._loadResCount = 0;
         UIModuleSmallLoading.Instance.progress = 0;
         UIModuleSmallLoading.Instance.show();
         UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.loadFrameCompleteHandler);
         UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.onUimoduleLoadProgress);
         UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.SEVEN_DOUBLE_FRAME);
         UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.SEVEN_DOUBLE_GAME);
         UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.DDTROOM);
      }
      
      private function onUimoduleLoadProgress(event:UIModuleEvent) : void
      {
         var tmp:Number = NaN;
         if(event.module == UIModuleTypes.SEVEN_DOUBLE_FRAME || event.module == UIModuleTypes.SEVEN_DOUBLE_GAME || event.module == UIModuleTypes.DDTROOM)
         {
            tmp = event.loader.progress;
            tmp = tmp > 0.99 ? 0.99 : tmp;
            UIModuleSmallLoading.Instance.progress = tmp * 100;
         }
      }
      
      private function loadFrameCompleteHandler(event:UIModuleEvent) : void
      {
         var frame:SevenDoubleFrame = null;
         if(event.module == UIModuleTypes.SEVEN_DOUBLE_FRAME)
         {
            ++this._loadResCount;
         }
         if(event.module == UIModuleTypes.SEVEN_DOUBLE_GAME)
         {
            ++this._loadResCount;
         }
         if(event.module == UIModuleTypes.DDTROOM)
         {
            ++this._loadResCount;
         }
         if(this._loadResCount >= 3)
         {
            UIModuleSmallLoading.Instance.hide();
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.loadFrameCompleteHandler);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.onUimoduleLoadProgress);
            frame = ComponentFactory.Instance.creatComponentByStylename("SevenDoubleFrame");
            LayerManager.Instance.addToLayer(frame,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
         }
      }
      
      public function getPlayerResUrl(isSelf:Boolean, carType:int) : String
      {
         var tmpStr:String = null;
         if(isSelf)
         {
            tmpStr = "self";
         }
         else
         {
            tmpStr = "other";
         }
         return PathManager.SITE_MAIN + "image/sevendouble/" + "sevendouble" + tmpStr + carType + ".swf";
      }
      
      public function loadSound() : void
      {
         var loader:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.SITE_MAIN + "image/sevendouble/sevenDoubleAudio.swf",BaseLoader.MODULE_LOADER);
         loader.addEventListener(LoaderEvent.COMPLETE,this.loadSoundCompleteHandler);
         LoadResourceManager.Instance.startLoad(loader);
      }
      
      private function loadSoundCompleteHandler(event:LoaderEvent) : void
      {
         event.loader.removeEventListener(LoaderEvent.COMPLETE,this.loadSoundCompleteHandler);
         SoundManager.instance.initSevenDoubleSound();
      }
   }
}

