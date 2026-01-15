package room
{
   import bombKing.BombKingManager;
   import bombKing.event.BombKingEvent;
   import campbattle.CampBattleManager;
   import catchInsect.CatchInsectMananger;
   import christmas.manager.ChristmasMonsterManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.UIModuleLoader;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.utils.ObjectUtils;
   import consortion.ConsortionModelControl;
   import ddt.data.BuffInfo;
   import ddt.data.UIModuleTypes;
   import ddt.data.fightLib.FightLibInfo;
   import ddt.data.player.PlayerInfo;
   import ddt.data.player.SelfInfo;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.events.RoomEvent;
   import ddt.loader.StartupResourceLoader;
   import ddt.manager.ChatManager;
   import ddt.manager.FightLibManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.MapManager;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PetInfoManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.StateManager;
   import ddt.states.StateType;
   import ddt.view.UIModuleSmallLoading;
   import drgnBoat.DrgnBoatManager;
   import escort.EscortManager;
   import fightLib.LessonType;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import game.GameManager;
   import hall.GameLoadingManager;
   import invite.ResponseInviteFrame;
   import kingDivision.KingDivisionManager;
   import labyrinth.LabyrinthManager;
   import pet.date.PetInfo;
   import road7th.comm.PackageIn;
   import road7th.data.DictionaryData;
   import room.model.RoomInfo;
   import room.model.RoomPlayer;
   import room.transnational.TransnationalFightManager;
   import room.view.RoomPlayerItem;
   import room.view.roomView.SingleRoomView;
   import sevenDouble.SevenDoubleManager;
   import trainer.controller.NewHandGuideManager;
   import treasureLost.controller.TreasureLostManager;
   import worldboss.WorldBossManager;
   
   public class RoomManager extends EventDispatcher
   {
      
      private static var _instance:RoomManager;
      
      public static const PAYMENT_TAKE_CARD:String = "PaymentCard";
      
      public static const LOGIN_ROOM_RESULT:String = "loginRoomResult";
      
      public static const PLAYER_ROOM_EXIT:String = "PlayerRoomExit";
      
      public static const UPDATE_ROOMLIST:String = "updateRoomList";
      
      public static const CAMP_BATTLE_ROOM:int = 5;
      
      public static const BATTLE_ROOM:int = 3;
      
      public static const ENCOUNTER_MODEL:int = 1;
      
      public static const BATTLE_MODEL:int = 2;
      
      public static const SINGLEBATTLE_MODEL:int = 6;
      
      public static const TRANSNATIONAL_ROOM:int = 10;
      
      public static const FIGHTFOOTBALLTIME_ROOM:int = 20;
      
      public static const HORSERACE_ROOM:int = 60;
      
      private var _current:RoomInfo;
      
      private var _isEnconterUI:Boolean;
      
      public var _removeRoomMsg:String = "";
      
      private var _battleType:int;
      
      public var IsLastMisstion:Boolean = false;
      
      public var IsFirstInWarriorsarena:Boolean = true;
      
      private var _alert:BaseAlerFrame;
      
      private var _isSingleBattleAndForcedExit:Boolean = false;
      
      private var __transtionalPlayerInfo:String;
      
      private var _transnationalMainWeaponId:int;
      
      private var _transnationalSecWeaponId:int;
      
      private var _transnationalPetId:int;
      
      private var _transnationalSnapLever:int;
      
      private var _isShowGameLoading:Boolean;
      
      private var _tempInventPlayerID:int = -1;
      
      private var _singleRoomView:SingleRoomView;
      
      public var isNotAlertEnergyNotEnough:Boolean = false;
      
      public function RoomManager()
      {
         super();
      }
      
      public static function getTurnTimeByType(type:int) : int
      {
         switch(type)
         {
            case 1:
               return 6;
            case 2:
               return 8;
            case 3:
               return 11;
            case 4:
               return 16;
            case 5:
               return 21;
            case 6:
               return 31;
            default:
               return -1;
         }
      }
      
      public static function get Instance() : RoomManager
      {
         if(_instance == null)
         {
            _instance = new RoomManager();
         }
         return _instance;
      }
      
      public function set current(val:RoomInfo) : void
      {
         this.setCurrent(val);
      }
      
      public function get current() : RoomInfo
      {
         if(!this._current)
         {
            return null;
         }
         return this._current;
      }
      
      public function isReset(type:int) : Boolean
      {
         return type != RoomInfo.LANBYRINTH_ROOM && type != RoomInfo.STONEEXPLORE_ROOM;
      }
      
      private function setCurrent(value:RoomInfo) : void
      {
         if(Boolean(this._current))
         {
            this._current.dispose();
         }
         this._current = value;
      }
      
      public function isTransnationalFight() : Boolean
      {
         return RoomManager._instance.current.type == RoomInfo.TRANSNATIONALFIGHT_ROOM;
      }
      
      public function isChristmasFight() : Boolean
      {
         return RoomManager._instance.current.type == RoomInfo.CHRISTMAS_ROOM;
      }
      
      public function createTrainerRoom() : void
      {
         this.setCurrent(new RoomInfo());
         this._current.timeType = 3;
      }
      
      public function setRoomDefyInfo(value:Array) : void
      {
         if(Boolean(this._current))
         {
            this._current.defyInfo = value;
         }
      }
      
      public function setup() : void
      {
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.GAME_ROOM_CREATE,this.__createRoom);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.SINGLE_ROOM_BEGIN,this.__createSingleRoom);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.TRANSNATIONAL_ROOM_BEGIN,this.__createTransnationalRoom);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.TRANSNATIONALFIGHT_PLAYERINFO,this.__updataplayerinfo);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.GAME_ROOM_LOGIN,this.__loginRoomResult);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.GAME_ROOM_SETUP_CHANGE,this.__settingRoom);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.GAME_ROOM_UPDATE_PLACE,this.__updateRoomPlaces);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.GAME_PLAYER_STATE_CHANGE,this.__playerStateChange);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.GMAE_STYLE_RECV,this.__updateGameStyle);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.GAME_TEAM,this.__setPlayerTeam);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.NETWORK,this.__netWork);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.BUFF_OBTAIN,this.__buffObtain);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.BUFF_UPDATE,this.__buffUpdate);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.GAME_WAIT_FAILED,this.__waitGameFailed);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.GAME_WAIT_RECV,this.__waitGameRecv);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.GAME_AWIT_CANCEL,this.__waitCancel);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.GAME_PLAYER_ENTER,this.__addPlayerInRoom);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.GAME_PLAYER_EXIT,this.__removePlayerInRoom);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.INSUFFICIENT_MONEY,this.__paymentFailed);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.IS_LAST_MISSION,this.__isLastMission);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.PASSED_WARRIORSARENA_10,this.__hasPassedWarriorsarena);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.LAST_MISSION_FOR_WARRIORSARENA,this.__isLastForWarriorsarena);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.No_WARRIORSARENA_TICKET,this.__noWarriorsarenaTicket);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.SINGBATTLE_FORCED_EXIT,this.__forcedExitHandler);
      }
      
      protected function __forcedExitHandler(event:Event) : void
      {
         this._isSingleBattleAndForcedExit = true;
      }
      
      protected function __createSingleRoom(event:CrazyTankSocketEvent) : void
      {
         var fpInfo:RoomPlayer = null;
         var pkg:PackageIn = event.pkg;
         var info:RoomInfo = new RoomInfo();
         info.ID = pkg.readInt();
         info.type = pkg.readByte();
         info.hardLevel = pkg.readByte();
         info.isPlaying = pkg.readBoolean();
         info.gameMode = pkg.readByte();
         if(info.gameMode == 20)
         {
            info.type = RoomInfo.FIGHTGROUND_ROOM;
         }
         info.mapId = pkg.readInt();
         info.isCrossZone = pkg.readBoolean();
         this.setCurrent(info);
         PlayerManager.Instance.Self.ZoneID = pkg.readInt();
         this._isShowGameLoading = pkg.readBoolean();
         if(this._isShowGameLoading)
         {
            GameLoadingManager.Instance.show();
         }
         if(GameManager.Instance.Current != null)
         {
            fpInfo = GameManager.Instance.Current.findRoomPlayer(PlayerManager.Instance.Self.ID,PlayerManager.Instance.Self.ZoneID);
         }
         if(fpInfo == null)
         {
            fpInfo = new RoomPlayer(PlayerManager.Instance.Self);
         }
         info.addPlayer(fpInfo);
         if(Boolean(this._current))
         {
            if(this._current.type == RoomInfo.ENCOUNTER_ROOM)
            {
               this._battleType = ENCOUNTER_MODEL;
               this.addBattleSingleRoom();
            }
            else if(this._current.type == RoomInfo.FIGHTGROUND_ROOM)
            {
               this._battleType = BATTLE_MODEL;
               this.addBattleSingleRoom(BATTLE_MODEL);
            }
            else if(this._current.type == RoomInfo.SINGLE_BATTLE)
            {
               this._battleType = SINGLEBATTLE_MODEL;
               if(Boolean(this._singleRoomView))
               {
                  this._singleRoomView.startTime();
               }
            }
            if(this._current.type == RoomInfo.CONSORTIA_MATCH_SCORE || this._current.type == RoomInfo.CONSORTIA_MATCH_RANK || this._current.type == RoomInfo.CONSORTIA_MATCH_SCORE_WHOLE || this._current.type == RoomInfo.CONSORTIA_MATCH_RANK_WHOLE)
            {
               if(KingDivisionManager.Instance._kingDivFrame.qualificationsFrame != null)
               {
                  KingDivisionManager.Instance._kingDivFrame.qualificationsFrame.updateButtons();
               }
               else if(KingDivisionManager.Instance._kingDivFrame.rankingRoundView != null)
               {
                  KingDivisionManager.Instance._kingDivFrame.rankingRoundView.updateButtons();
               }
            }
            if(this._current.type == RoomInfo.FIGHTFOOTBALLTIME_ROOM)
            {
            }
         }
         if(this._current.type == RoomInfo.TREASURELOST_ROOM)
         {
            this._isShowGameLoading = true;
         }
         if(this._isShowGameLoading)
         {
            GameManager.Instance.addEventListener(GameManager.START_LOAD,this.__startLoading);
         }
         PlayerManager.Instance.Self.LastServerId = -1;
         if(BombKingManager.instance.Recording)
         {
            dispatchEvent(new BombKingEvent(BombKingEvent.STARTLOADBATTLEXML));
         }
      }
      
      private function __noWarriorsarenaTicket(event:CrazyTankSocketEvent) : void
      {
         var pkg:PackageIn = event.pkg;
         var str:String = pkg.readUTF();
         if(Boolean(this._alert))
         {
            this._alert.removeEventListener(FrameEvent.RESPONSE,this.__alertResponse);
            ObjectUtils.disposeObject(this._alert);
            this._alert.dispose();
            this._alert = null;
         }
         this._alert = AlertManager.Instance.simpleAlert("",str,LanguageMgr.GetTranslation("ok"),"",false,true,true,LayerManager.BLCAK_BLOCKGOUND);
         this._alert.moveEnable = false;
         this._alert.addEventListener(FrameEvent.RESPONSE,this.__alertResponse);
      }
      
      private function __isLastForWarriorsarena(e:CrazyTankSocketEvent) : void
      {
         var pkg:PackageIn = e.pkg;
         this.IsLastMisstion = pkg.readBoolean();
      }
      
      private function __isLastMission(e:CrazyTankSocketEvent) : void
      {
         this.current.IsLastSession = e.pkg.readBoolean();
      }
      
      private function __updataplayerinfo(evt:CrazyTankSocketEvent) : void
      {
         this._transnationalMainWeaponId = evt.pkg.readInt();
         this._transnationalSecWeaponId = evt.pkg.readInt();
         this._transnationalPetId = evt.pkg.readInt();
         this.__transtionalPlayerInfo = evt.pkg.readUTF();
         this._transnationalSnapLever = evt.pkg.readInt();
         this.addTransnationalRoom();
      }
      
      protected function __createTransnationalRoom(event:CrazyTankSocketEvent) : void
      {
         var fpInfo:RoomPlayer = null;
         var pkg:PackageIn = event.pkg;
         var info:RoomInfo = new RoomInfo();
         info.ID = pkg.readInt();
         info.type = pkg.readByte();
         info.isPlaying = pkg.readBoolean();
         info.gameMode = pkg.readByte();
         info.mapId = pkg.readInt();
         info.isCrossZone = pkg.readBoolean();
         this.setCurrent(info);
         PlayerManager.Instance.Self.ZoneID = pkg.readInt();
         if(GameManager.Instance.Current != null)
         {
            fpInfo = GameManager.Instance.Current.findRoomPlayer(PlayerManager.Instance.Self.ID,PlayerManager.Instance.Self.ZoneID);
         }
         if(fpInfo == null)
         {
            fpInfo = new RoomPlayer(PlayerManager.Instance.Self);
         }
         info.addPlayer(fpInfo);
         this.addTransnationalRoom();
      }
      
      public function addTransnationalRoom() : void
      {
         if(this._isEnconterUI)
         {
            TransnationalFightManager.Instance.show(this.__transtionalPlayerInfo,this._transnationalMainWeaponId,this._transnationalSecWeaponId,this._transnationalPetId,this._transnationalSnapLever);
         }
         else
         {
            UIModuleSmallLoading.Instance.progress = 0;
            UIModuleSmallLoading.Instance.show();
            UIModuleSmallLoading.Instance.addEventListener(Event.CLOSE,this.__onClose);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__onComplete);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__onProgress);
            UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.DDTROOM);
         }
      }
      
      private function __onComplete(evt:UIModuleEvent) : void
      {
         if(evt.module == UIModuleTypes.DDTROOM)
         {
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__onComplete);
            UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__onClose);
            this._isEnconterUI = true;
            UIModuleSmallLoading.Instance.hide();
            TransnationalFightManager.Instance.show(this.__transtionalPlayerInfo,this._transnationalMainWeaponId,this._transnationalSecWeaponId,this._transnationalPetId,this._transnationalSnapLever);
         }
      }
      
      private function __hasPassedWarriorsarena(event:CrazyTankSocketEvent) : void
      {
         var alert:BaseAlerFrame = AlertManager.Instance.simpleAlert("",LanguageMgr.GetTranslation("ddt.dungeonroom.pass.warriorsArena",10),LanguageMgr.GetTranslation("ok"),"",false,true,true,2);
         alert.addEventListener(FrameEvent.RESPONSE,this.__onResponse);
      }
      
      private function __onResponse(event:FrameEvent) : void
      {
         var alert:BaseAlerFrame = event.currentTarget as BaseAlerFrame;
         alert.removeEventListener(FrameEvent.RESPONSE,this.__onResponse);
         ObjectUtils.disposeObject(alert);
         alert = null;
      }
      
      public function canCloseItem(target:RoomPlayerItem) : Boolean
      {
         var place:int = target.place;
         var openCount:uint = 4;
         var arr:Array = this._current.placesState;
         for(var i:int = 0; i < 8; i++)
         {
            if(i % 2 == place % 2)
            {
               if(arr[i] == 0)
               {
                  openCount--;
               }
            }
         }
         if(openCount <= 1)
         {
            return false;
         }
         return true;
      }
      
      private function __paymentFailed(e:CrazyTankSocketEvent) : void
      {
         var alert:BaseAlerFrame = null;
         var alert1:BaseAlerFrame = null;
         var alert2:BaseAlerFrame = null;
         var pkg:PackageIn = e.pkg;
         var type:int = pkg.readByte();
         var payment:Boolean = pkg.readBoolean();
         if(type == 0)
         {
            if(!payment)
            {
               alert = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tank.room.RoomIIView2.notenoughmoney.title"),LanguageMgr.GetTranslation("tank.room.RoomIIView2.notenoughmoney.content"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,true,true,LayerManager.ALPHA_BLOCKGOUND);
               alert.addEventListener(FrameEvent.RESPONSE,this._responseI);
            }
         }
         else if(type == 1)
         {
            if(!payment)
            {
               dispatchEvent(new Event(PAYMENT_TAKE_CARD));
               alert1 = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tank.room.RoomIIView2.notenoughmoney.title"),LanguageMgr.GetTranslation("tank.room.RoomIIView2.notenoughmoney.content"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,true,true,LayerManager.ALPHA_BLOCKGOUND);
               if(Boolean(alert1.parent))
               {
                  alert1.parent.removeChild(alert1);
               }
               LayerManager.Instance.addToLayer(alert1,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.ALPHA_BLOCKGOUND);
               alert1.addEventListener(FrameEvent.RESPONSE,this._responseI);
               ChatManager.Instance.sysChatYellow(LanguageMgr.GetTranslation("tank.gameover.NotEnoughPayToTakeCard"));
            }
         }
         else if(type == 2)
         {
            if(!payment)
            {
               alert2 = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tank.room.RoomIIView2.notenoughmoney.title"),LanguageMgr.GetTranslation("tank.room.RoomIIView2.notenoughmoney.content"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,true,true,LayerManager.ALPHA_BLOCKGOUND);
               alert2.addEventListener(FrameEvent.RESPONSE,this._responseII);
            }
         }
      }
      
      private function _responseI(evt:FrameEvent) : void
      {
         (evt.currentTarget as BaseAlerFrame).removeEventListener(FrameEvent.RESPONSE,this._responseI);
         if(evt.responseCode == FrameEvent.SUBMIT_CLICK || evt.responseCode == FrameEvent.ENTER_CLICK)
         {
            LeavePageManager.leaveToFillPath();
         }
         ObjectUtils.disposeObject(evt.currentTarget);
      }
      
      private function _responseII(evt:FrameEvent) : void
      {
         (evt.currentTarget as BaseAlerFrame).removeEventListener(FrameEvent.RESPONSE,this._responseII);
         if(evt.responseCode == FrameEvent.SUBMIT_CLICK || evt.responseCode == FrameEvent.ENTER_CLICK)
         {
            this.__toPaymentTryagainHandler();
         }
         else
         {
            this.__cancelPaymenttryagainHandler();
         }
         ObjectUtils.disposeObject(evt.currentTarget);
      }
      
      private function __toPaymentTryagainHandler() : void
      {
         LeavePageManager.leaveToFillPath();
         GameManager.Instance.dispatchPaymentConfirm();
      }
      
      private function __cancelPaymenttryagainHandler() : void
      {
         GameManager.Instance.dispatchLeaveMission();
      }
      
      private function __createRoom(evt:CrazyTankSocketEvent) : void
      {
         var pkg:PackageIn = evt.pkg;
         var info:RoomInfo = new RoomInfo();
         info.ID = pkg.readInt();
         info.type = pkg.readByte();
         info.hardLevel = pkg.readByte();
         info.timeType = pkg.readByte();
         info.totalPlayer = pkg.readByte();
         info.viewerCnt = pkg.readByte();
         info.placeCount = pkg.readByte();
         info.isLocked = pkg.readBoolean();
         info.mapId = pkg.readInt();
         info.started = pkg.readBoolean();
         info.Name = pkg.readUTF();
         info.gameMode = pkg.readByte();
         info.levelLimits = pkg.readInt();
         info.isCrossZone = pkg.readBoolean();
         info.isWithinLeageTime = pkg.readBoolean();
         info.isOpenBoss = pkg.readBoolean();
         info.pic = evt.pkg.readUTF();
         this._isShowGameLoading = evt.pkg.readBoolean();
         if(this._isShowGameLoading)
         {
            GameLoadingManager.Instance.show();
            if(info.type == 10)
            {
               NewHandGuideManager.Instance.mapID = info.mapId;
            }
         }
         this.setCurrent(info);
         if(this._isShowGameLoading)
         {
            GameLoadingManager.Instance.createRoomComplete();
            if(info.gameMode == 8)
            {
               this.enterFightLib();
            }
         }
         dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.GAME_ROOM_CREATE));
      }
      
      private function enterFightLib() : void
      {
         FightLibManager.Instance.currentInfoID = this.current.mapId;
         FightLibManager.Instance.currentInfo.difficulty = this.current.hardLevel;
         StateManager.setState(StateType.FIGHT_LIB);
      }
      
      private function getSecondType(infoId:int, difficulty:int) : int
      {
         var secondType:int = 0;
         if(infoId == LessonType.Twenty || infoId == LessonType.SixtyFive || infoId == LessonType.HighThrow)
         {
            if(difficulty == FightLibInfo.EASY)
            {
               secondType = 6;
            }
            else if(difficulty == FightLibInfo.NORMAL)
            {
               secondType = 5;
            }
            else
            {
               secondType = 3;
            }
         }
         else if(infoId == LessonType.HighGap)
         {
            if(difficulty == FightLibInfo.EASY)
            {
               secondType = 5;
            }
            else if(difficulty == FightLibInfo.NORMAL)
            {
               secondType = 4;
            }
            else
            {
               secondType = 3;
            }
         }
         return secondType;
      }
      
      public function set tempInventPlayerID(id:int) : void
      {
         this._tempInventPlayerID = id;
      }
      
      public function get tempInventPlayerID() : int
      {
         return this._tempInventPlayerID;
      }
      
      public function haveTempInventPlayer() : Boolean
      {
         return this._tempInventPlayerID != -1;
      }
      
      private function __loginRoomResult(evt:CrazyTankSocketEvent) : void
      {
         dispatchEvent(new Event(LOGIN_ROOM_RESULT));
         if(evt.pkg.readBoolean() == false)
         {
         }
      }
      
      private function __addPlayerInRoom(evt:CrazyTankSocketEvent) : void
      {
         var pkg:PackageIn = null;
         var id:int = 0;
         var isInGame:Boolean = false;
         var pos:int = 0;
         var team:int = 0;
         var isFirstIn:Boolean = false;
         var level:int = 0;
         var offer:int = 0;
         var hide:int = 0;
         var repute:int = 0;
         var speed:int = 0;
         var zoneID:int = 0;
         var enterNum:int = 0;
         var info:PlayerInfo = null;
         var fpInfo:RoomPlayer = null;
         var unknown1:int = 0;
         var unknown2:int = 0;
         var count:int = 0;
         var j:int = 0;
         var place:int = 0;
         var p:PetInfo = null;
         var ptd:int = 0;
         var activedSkillCount:int = 0;
         var k:int = 0;
         var splace:int = 0;
         var sid:int = 0;
         ResponseInviteFrame.clearInviteFrame();
         if(Boolean(this._current))
         {
            pkg = evt.pkg;
            id = pkg.clientId;
            isInGame = pkg.readBoolean();
            pos = pkg.readByte();
            team = pkg.readByte();
            isFirstIn = pkg.readBoolean();
            level = pkg.readInt();
            offer = pkg.readInt();
            hide = pkg.readInt();
            repute = pkg.readInt();
            speed = pkg.readInt();
            zoneID = pkg.readInt();
            enterNum = pkg.readInt();
            if(id != PlayerManager.Instance.Self.ID)
            {
               info = PlayerManager.Instance.findPlayer(id);
               info.beginChanges();
               info.ID = pkg.readInt();
               info.NickName = pkg.readUTF();
               info.typeVIP = pkg.readByte();
               info.VIPLevel = pkg.readInt();
               info.Sex = pkg.readBoolean();
               info.Style = pkg.readUTF();
               info.Colors = pkg.readUTF();
               info.Skin = pkg.readUTF();
               info.WeaponID = pkg.readInt();
               info.DeputyWeaponID = pkg.readInt();
               info.Repute = repute;
               info.Grade = level;
               info.Offer = offer;
               info.Hide = hide;
               info.ConsortiaID = pkg.readInt();
               info.ConsortiaName = pkg.readUTF();
               info.badgeID = pkg.readInt();
               info.WinCount = pkg.readInt();
               info.TotalCount = pkg.readInt();
               info.EscapeCount = pkg.readInt();
               unknown1 = pkg.readInt();
               unknown2 = pkg.readInt();
               info.IsMarried = pkg.readBoolean();
               if(info.IsMarried)
               {
                  info.SpouseID = pkg.readInt();
                  info.SpouseName = pkg.readUTF();
               }
               else
               {
                  info.SpouseID = 0;
                  info.SpouseName = "";
               }
               info.LoginName = pkg.readUTF();
               info.Nimbus = pkg.readInt();
               info.FightPower = pkg.readInt();
               info.apprenticeshipState = pkg.readInt();
               info.masterID = pkg.readInt();
               info.setMasterOrApprentices(pkg.readUTF());
               info.graduatesCount = pkg.readInt();
               info.honourOfMaster = pkg.readUTF();
               info.DailyLeagueFirst = pkg.readBoolean();
               info.DailyLeagueLastScore = pkg.readInt();
               info.isOld = pkg.readBoolean();
               count = pkg.readInt();
               for(j = 0; j < count; j++)
               {
                  place = pkg.readInt();
                  p = info.pets[place];
                  ptd = pkg.readInt();
                  if(p == null)
                  {
                     p = new PetInfo();
                     p.TemplateID = ptd;
                     PetInfoManager.fillPetInfo(p);
                  }
                  p.ID = pkg.readInt();
                  p.Name = pkg.readUTF();
                  p.UserID = pkg.readInt();
                  p.Level = pkg.readInt();
                  p.IsEquip = true;
                  p.clearEquipedSkills();
                  activedSkillCount = pkg.readInt();
                  for(k = 0; k < activedSkillCount; k++)
                  {
                     splace = pkg.readInt();
                     sid = pkg.readInt();
                     p.equipdSkills.add(splace,sid);
                  }
                  p.Place = place;
                  info.pets.add(p.Place,p);
               }
               info.commitChanges();
            }
            else
            {
               info = PlayerManager.Instance.Self;
            }
            info.ZoneID = zoneID;
            info.activityTanabataNum = enterNum;
            if(GameManager.Instance.Current != null)
            {
               fpInfo = GameManager.Instance.Current.findRoomPlayer(id,zoneID);
            }
            if(fpInfo == null)
            {
               fpInfo = new RoomPlayer(info);
            }
            fpInfo.isFirstIn = isFirstIn;
            fpInfo.place = pos;
            fpInfo.team = team;
            fpInfo.webSpeedInfo.delay = speed;
            if(fpInfo.isSelf && this._current && !this._isShowGameLoading)
            {
               if(this._current.type != 5)
               {
                  if(this._current.type == RoomInfo.MATCH_ROOM || this._current.type == RoomInfo.SCORE_ROOM || this._current.type == RoomInfo.RANK_ROOM || this._current.type == RoomInfo.ENTERTAINMENT_ROOM || this._current.type == RoomInfo.ENTERTAINMENT_ROOM_PK)
                  {
                     StateManager.setState(StateType.MATCH_ROOM);
                  }
                  else if(this._current.type == RoomInfo.CHALLENGE_ROOM)
                  {
                     StateManager.setState(StateType.CHALLENGE_ROOM);
                  }
                  else if(this._current.type == RoomInfo.DUNGEON_ROOM || this._current.type == RoomInfo.ACADEMY_DUNGEON_ROOM || this._current.type == RoomInfo.ACTIVITY_DUNGEON_ROOM || this._current.type == RoomInfo.SPECIAL_ACTIVITY_DUNGEON || this._current.type == RoomInfo.FARM_BOSS)
                  {
                     StateManager.setState(StateType.DUNGEON_ROOM);
                  }
                  else if(this._current.type == RoomInfo.FRESHMAN_ROOM)
                  {
                     if(StartupResourceLoader.firstEnterHall)
                     {
                        StateManager.setState(StateType.FRESHMAN_ROOM2);
                     }
                     else
                     {
                        StateManager.setState(StateType.FRESHMAN_ROOM1);
                     }
                  }
                  else if(this._current.type == RoomInfo.WORLD_BOSS_FIGHT)
                  {
                     WorldBossManager.Instance.enterGame();
                  }
                  else if(this._current.type == RoomInfo.LANBYRINTH_ROOM)
                  {
                     LabyrinthManager.Instance.enterGame();
                  }
                  else if(this._current.type == RoomInfo.CHRISTMAS_ROOM)
                  {
                     ChristmasMonsterManager.Instance.setupFightEvent();
                  }
               }
            }
            if(this._isShowGameLoading)
            {
               GameManager.Instance.addEventListener(GameManager.START_LOAD,this.__startLoading);
            }
            this._current.addPlayer(fpInfo);
            PlayerManager.Instance.Self.LastServerId = -1;
         }
      }
      
      protected function __startLoading(e:Event) : void
      {
         GameManager.Instance.removeEventListener(GameManager.START_LOAD,this.__startLoading);
         StateManager.getInGame_Step_6 = true;
         ChatManager.Instance.input.faceEnabled = false;
         LayerManager.Instance.clearnGameDynamic();
         StateManager.setState(StateType.ROOM_LOADING,GameManager.Instance.Current);
         StateManager.getInGame_Step_7 = true;
      }
      
      public function addBattleSingleRoom(type:int = 6) : void
      {
         this._battleType = type;
         if(this._isEnconterUI)
         {
            this.showSingleRoomView(this._battleType);
            return;
         }
         UIModuleSmallLoading.Instance.progress = 0;
         UIModuleSmallLoading.Instance.show();
         UIModuleSmallLoading.Instance.addEventListener(Event.CLOSE,this.__onClose);
         UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__onUIModuleComplete);
         UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__onProgress);
         UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.DDTROOM);
      }
      
      private function __onProgress(event:UIModuleEvent) : void
      {
         if(event.module == UIModuleTypes.DDTROOM)
         {
            UIModuleSmallLoading.Instance.progress = event.loader.progress * 100;
         }
      }
      
      private function __onUIModuleComplete(evt:UIModuleEvent) : void
      {
         if(evt.module == UIModuleTypes.DDTROOM)
         {
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__onUIModuleComplete);
            UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__onClose);
            this._isEnconterUI = true;
            UIModuleSmallLoading.Instance.hide();
            this.showSingleRoomView(this._battleType);
         }
      }
      
      private function __onClose(event:Event) : void
      {
         this._isEnconterUI = false;
         UIModuleSmallLoading.Instance.hide();
         UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__onClose);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__onUIModuleComplete);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__onProgress);
      }
      
      private function __removePlayerInRoom(evt:CrazyTankSocketEvent) : void
      {
         var id:int = 0;
         var zoneID:int = 0;
         var info:RoomPlayer = null;
         CampBattleManager.instance.model.isFighting = false;
         if(Boolean(this._current))
         {
            id = evt.pkg.clientId;
            zoneID = evt.pkg.readInt();
            info = this._current.findPlayerByID(id,zoneID);
            if(Boolean(info) && info.isSelf)
            {
               GameManager.Instance.currentNum = 0;
               if(StateManager.currentStateType == StateType.MATCH_ROOM || StateManager.currentStateType == StateType.CHALLENGE_ROOM || StateManager.currentStateType == StateType.SINGLEBATTLE_MATCHING)
               {
                  StateManager.setState(StateType.ROOM_LIST);
               }
               else if(this._current.type == RoomInfo.FIGHTGROUND_ROOM)
               {
                  StateManager.setState(StateType.MAIN);
               }
               else if(this._current.type == RoomInfo.ENTERTAINMENT_ROOM || this._current.type == RoomInfo.ENTERTAINMENT_ROOM_PK)
               {
                  StateManager.setState(StateType.MAIN);
               }
               else if(this._current.type == RoomInfo.TRANSNATIONALFIGHT_ROOM)
               {
                  StateManager.setState(StateType.MAIN);
               }
               else if(StateManager.currentStateType == StateType.DUNGEON_ROOM || StateManager.currentStateType == StateType.MISSION_ROOM)
               {
                  StateManager.setState(StateType.DUNGEON_LIST);
               }
               else if(StateManager.currentStateType == StateType.FIGHT_LIB_GAMEVIEW)
               {
                  StateManager.setState(StateType.MAIN);
               }
               else if(StateManager.currentStateType == StateType.FIGHTING || StateManager.currentStateType == StateType.ROOM_LOADING || StateManager.currentStateType == StateType.GAME_LOADING)
               {
                  if(this._current.type == RoomInfo.DUNGEON_ROOM || this._current.type == RoomInfo.ACADEMY_DUNGEON_ROOM || this._current.type == RoomInfo.ACTIVITY_DUNGEON_ROOM || this._current.type == RoomInfo.SPECIAL_ACTIVITY_DUNGEON)
                  {
                     StateManager.setState(StateType.DUNGEON_LIST);
                  }
                  else if(this._current.type != RoomInfo.WORLD_BOSS_FIGHT)
                  {
                     if(this._current.type == RoomInfo.SINGLE_BATTLE)
                     {
                        if(this._isSingleBattleAndForcedExit)
                        {
                           StateManager.setState(StateType.ROOM_LIST);
                        }
                        StateManager.setState(StateType.ROOM_LIST);
                     }
                     else if(this._current.type == RoomInfo.LANBYRINTH_ROOM)
                     {
                        StateManager.setState(StateType.MAIN,LabyrinthManager.Instance.show);
                     }
                     else if(this._current.type == RoomInfo.CONSORTIA_BOSS)
                     {
                        StateManager.setState(StateType.CONSORTIA,ConsortionModelControl.Instance.openBossFrame);
                     }
                     else if(this._current.type == RoomInfo.CONSORTIA_BATTLE)
                     {
                        StateManager.setState(StateType.CONSORTIA_BATTLE_SCENE);
                     }
                     else if(this._current.type == RoomInfo.CAMPBATTLE_BATTLE)
                     {
                        SocketManager.Instance.out.returnToPve();
                     }
                     else if(this._current.type == RoomInfo.SEVEN_DOUBLE)
                     {
                        if(SevenDoubleManager.instance.isStart)
                        {
                           StateManager.setState(StateType.SEVEN_DOUBLE_SCENE);
                        }
                        else if(EscortManager.instance.isStart)
                        {
                           StateManager.setState(StateType.ESCORT);
                        }
                        else if(DrgnBoatManager.instance.isStart)
                        {
                           StateManager.setState(StateType.DRGN_BOAT);
                        }
                        else
                        {
                           StateManager.setState(StateType.MAIN);
                        }
                     }
                     else if(this._current.type == RoomInfo.CATCH_BEAST || this._current.type == RoomInfo.FARM_BOSS)
                     {
                        StateManager.setState(StateType.MAIN);
                     }
                     else if(this._current.type == RoomInfo.CRYPTBOSS_ROOM)
                     {
                        StateManager.setState(StateType.MAIN);
                     }
                     else if(this._current.type == RoomInfo.RESCUE)
                     {
                        StateManager.setState(StateType.MAIN);
                     }
                     else if(this._current.type == RoomInfo.CATCH_INSECT_ROOM)
                     {
                        CatchInsectMananger.isToRoom = true;
                        if(!CatchInsectMananger.instance.loadUiModuleComplete)
                        {
                           CatchInsectMananger.instance.reConnect();
                        }
                        else
                        {
                           CatchInsectMananger.instance.isReConnect = false;
                           StateManager.setState(StateType.CATCH_INSECT);
                        }
                     }
                     else if(this._current.type == RoomInfo.TREASURELOST_ROOM)
                     {
                        StateManager.setState(StateType.MAIN);
                        TreasureLostManager.Instance.isOpenFrame = true;
                     }
                     else
                     {
                        StateManager.setState(StateType.ROOM_LIST);
                     }
                  }
               }
               PlayerManager.Instance.Self.unlockAllBag();
            }
            else
            {
               if(Boolean(GameManager.Instance.Current))
               {
                  GameManager.Instance.Current.removeRoomPlayer(zoneID,id);
                  GameManager.Instance.Current.removeGamePlayerByPlayerID(zoneID,id);
               }
               this._current.removePlayer(zoneID,id);
            }
            dispatchEvent(new Event(PLAYER_ROOM_EXIT));
         }
         if(Boolean(this._alert))
         {
            this._alert.removeEventListener(FrameEvent.RESPONSE,this.__alertResponse);
            ObjectUtils.disposeObject(this._alert);
            this._alert.dispose();
         }
         this._alert = null;
         this.IsLastMisstion = false;
         this._isSingleBattleAndForcedExit = false;
         GameLoadingManager.Instance.hide();
      }
      
      public function showSingleRoomView(type:int = 6) : void
      {
         this._singleRoomView = ComponentFactory.Instance.creat("room.view.roomView.singleRoomView",[type]);
         this._singleRoomView.show();
         this._singleRoomView.addEventListener(FrameEvent.RESPONSE,this.__onSingleRoomEvent);
      }
      
      protected function __onSingleRoomEvent(event:FrameEvent) : void
      {
         if(event.responseCode == FrameEvent.ESC_CLICK || event.responseCode == FrameEvent.CANCEL_CLICK || event.responseCode == FrameEvent.CLOSE_CLICK)
         {
            SoundManager.instance.playButtonSound();
            this._singleRoomView.isCloseOrEscClick = true;
            this.hideSingleRoomView();
         }
      }
      
      private function hideSingleRoomView() : void
      {
         this._singleRoomView.removeEventListener(FrameEvent.RESPONSE,this.__onSingleRoomEvent);
         ObjectUtils.disposeObject(this._singleRoomView);
         this._singleRoomView = null;
      }
      
      private function __alertResponse(event:FrameEvent) : void
      {
         if(Boolean(this._alert))
         {
            this._alert.removeEventListener(FrameEvent.RESPONSE,this.__alertResponse);
            ObjectUtils.disposeObject(this._alert);
            this._alert.dispose();
         }
         this._alert = null;
      }
      
      private function __playerStateChange(evt:CrazyTankSocketEvent) : void
      {
         var states:Array = null;
         var i:int = 0;
         if(Boolean(this._current))
         {
            states = new Array();
            for(i = 0; i < 8; i++)
            {
               states[i] = evt.pkg.readByte();
            }
            this._current.updatePlayerState(states);
         }
      }
      
      public function findRoomPlayer(id:int) : RoomPlayer
      {
         if(Boolean(this._current))
         {
            return this._current.players[id] as RoomPlayer;
         }
         return null;
      }
      
      private function __settingRoom(evt:CrazyTankSocketEvent) : void
      {
         if(this._current == null)
         {
            return;
         }
         var bool:Boolean = evt.pkg.readBoolean();
         if(bool)
         {
            this._current.pic = evt.pkg.readUTF();
            if(!RoomManager.Instance.current.selfRoomPlayer.isHost && StateManager.currentStateType != StateType.DUNGEON_ROOM)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("BaseRoomView.getout.bossRoom"));
            }
         }
         this._current.isOpenBoss = bool;
         this._current.mapId = evt.pkg.readInt();
         this._current.type = evt.pkg.readByte();
         this._current.roomPass = evt.pkg.readUTF();
         this._current.roomName = evt.pkg.readUTF();
         this._current.timeType = evt.pkg.readByte();
         this._current.hardLevel = evt.pkg.readByte();
         this._current.levelLimits = evt.pkg.readInt();
         this._current.isCrossZone = evt.pkg.readBoolean();
         if(MapManager.PVE_ADVANCED_MAP.indexOf(this._current.mapId) != -1 && RoomManager.Instance.IsFirstInWarriorsarena)
         {
            this._alert = AlertManager.Instance.simpleAlert("",LanguageMgr.GetTranslation("ddt.dungeonroom.FisrtInWarriorsArena"),LanguageMgr.GetTranslation("ok"),"",false,true,true,LayerManager.BLCAK_BLOCKGOUND);
            this._alert.moveEnable = false;
            this._alert.addEventListener(FrameEvent.RESPONSE,this.__alertResponse);
            RoomManager.Instance.IsFirstInWarriorsarena = false;
         }
         if(this._current.type == RoomInfo.LANBYRINTH_ROOM)
         {
            dispatchEvent(new RoomEvent(RoomEvent.START_LABYRINTH));
         }
      }
      
      private function __updateRoomPlaces(evt:CrazyTankSocketEvent) : void
      {
         var states:Array = new Array();
         for(var i:int = 0; i < 10; i++)
         {
            states[i] = evt.pkg.readInt();
         }
         if(Boolean(this._current))
         {
            this._current.updatePlaceState(states);
         }
      }
      
      private function __updateGameStyle(evt:CrazyTankSocketEvent) : void
      {
         if(this._current == null)
         {
            return;
         }
         this._current.gameMode = evt.pkg.readByte();
         if(this._current.gameMode == 2)
         {
            ChatManager.Instance.sysChatYellow(LanguageMgr.GetTranslation("tank.room.UpdateGameStyle"));
         }
      }
      
      private function __setPlayerTeam(evt:CrazyTankSocketEvent) : void
      {
         if(this._current == null)
         {
            return;
         }
         this._current.updatePlayerTeam(evt.pkg.clientId,evt.pkg.readByte(),evt.pkg.readByte());
      }
      
      private function __netWork(event:CrazyTankSocketEvent) : void
      {
         var info:PlayerInfo = PlayerManager.Instance.findPlayer(event.pkg.clientId);
         var speed:int = event.pkg.readInt();
         if(Boolean(info))
         {
            info.webSpeed = speed;
         }
      }
      
      private function __buffObtain(evt:CrazyTankSocketEvent) : void
      {
         var lth:int = 0;
         var i:int = 0;
         var type:int = 0;
         var isExist:Boolean = false;
         var beginData:Date = null;
         var validDate:int = 0;
         var value:int = 0;
         var buff:BuffInfo = null;
         var pkg:PackageIn = evt.pkg;
         if(!this._current)
         {
            this._current = new RoomInfo();
         }
         if(pkg.clientId == PlayerManager.Instance.Self.ID)
         {
            return;
         }
         if(this._current.findPlayerByID(pkg.clientId) != null)
         {
            lth = pkg.readInt();
            for(i = 0; i < lth; i++)
            {
               type = pkg.readInt();
               isExist = pkg.readBoolean();
               beginData = pkg.readDate();
               validDate = pkg.readInt();
               value = pkg.readInt();
               buff = new BuffInfo(type,isExist,beginData,validDate,value);
               this._current.findPlayerByID(pkg.clientId).playerInfo.buffInfo.add(buff.Type,buff);
            }
            evt.stopImmediatePropagation();
         }
      }
      
      private function __buffUpdate(evt:CrazyTankSocketEvent) : void
      {
         var len:int = 0;
         var i:int = 0;
         var _type:int = 0;
         var _isExist:Boolean = false;
         var _beginData:Date = null;
         var _validDate:int = 0;
         var _value:int = 0;
         var _buff:BuffInfo = null;
         var pkg:PackageIn = evt.pkg;
         if(pkg.clientId == PlayerManager.Instance.Self.ID)
         {
            return;
         }
         if(Boolean(this._current) && this._current.findPlayerByID(pkg.clientId) != null)
         {
            len = pkg.readInt();
            for(i = 0; i < len; i++)
            {
               _type = pkg.readInt();
               _isExist = pkg.readBoolean();
               _beginData = pkg.readDate();
               _validDate = pkg.readInt();
               _value = pkg.readInt();
               _buff = new BuffInfo(_type,_isExist,_beginData,_validDate,_value);
               if(_isExist)
               {
                  this._current.findPlayerByID(pkg.clientId).playerInfo.buffInfo.add(_buff.Type,_buff);
               }
               else
               {
                  this._current.findPlayerByID(pkg.clientId).playerInfo.buffInfo.remove(_buff.Type);
               }
            }
            evt.stopImmediatePropagation();
         }
      }
      
      private function __waitGameFailed(evt:CrazyTankSocketEvent) : void
      {
         if(Boolean(this._current))
         {
            this._current.pickupFailed();
         }
      }
      
      private function __waitGameRecv(evt:CrazyTankSocketEvent) : void
      {
         if(Boolean(this._current))
         {
            this._current.startPickup();
         }
      }
      
      private function __waitCancel(evt:CrazyTankSocketEvent) : void
      {
         if(Boolean(this._current))
         {
            this._current.cancelPickup();
         }
      }
      
      public function resetAllPlayerState() : void
      {
         var player:RoomPlayer = null;
         for each(player in this._current.players)
         {
            player.isReady = false;
            player.progress = 0;
            if(this._current.type != RoomInfo.CHALLENGE_ROOM)
            {
               player.team = 1;
            }
         }
      }
      
      public function isIdenticalRoom(id:int = 0, name:String = "") : Boolean
      {
         var i:RoomPlayer = null;
         var roomPlayers:DictionaryData = this.current.players;
         var selfInfo:SelfInfo = PlayerManager.Instance.Self;
         if(id == selfInfo.ID)
         {
            return false;
         }
         for each(i in roomPlayers)
         {
            if(i.playerInfo.ID == id || i.playerInfo.NickName == name)
            {
               return true;
            }
         }
         return false;
      }
      
      public function reset() : void
      {
         if(Boolean(this._current))
         {
            this._current.dispose();
            this._current = null;
         }
      }
   }
}

