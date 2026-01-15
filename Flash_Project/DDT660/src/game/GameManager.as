package game
{
   import bombKing.BombKingManager;
   import campbattle.CampBattleManager;
   import catchbeast.CatchBeastManager;
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.LoadResourceManager;
   import cryptBoss.CryptBossManager;
   import ddt.data.BallInfo;
   import ddt.data.BuffInfo;
   import ddt.data.FightBuffInfo;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.map.MissionInfo;
   import ddt.data.player.PlayerInfo;
   import ddt.data.player.SelfInfo;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.events.GameEvent;
   import ddt.loader.StartupResourceLoader;
   import ddt.manager.BallManager;
   import ddt.manager.BeadTemplateManager;
   import ddt.manager.BuffManager;
   import ddt.manager.ChatManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LoadBombManager;
   import ddt.manager.PathManager;
   import ddt.manager.PetInfoManager;
   import ddt.manager.PetSkillManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.QueueManager;
   import ddt.manager.SocketManager;
   import ddt.manager.StateManager;
   import ddt.manager.TimeManager;
   import ddt.states.StateType;
   import ddt.view.chat.ChatData;
   import ddt.view.chat.ChatFormats;
   import ddt.view.chat.ChatInputView;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.geom.Point;
   import flash.utils.Dictionary;
   import game.model.GameInfo;
   import game.model.GameNeedMovieInfo;
   import game.model.GameNeedPetSkillInfo;
   import game.model.LocalPlayer;
   import game.model.Pet;
   import game.model.Player;
   import game.model.SimpleBoxInfo;
   import game.view.Bomb;
   import game.view.DropGoods;
   import game.view.GameView;
   import game.view.effects.BloodNumberCreater;
   import game.view.experience.ExpTweenManager;
   import pet.date.PetInfo;
   import pet.date.PetSkillTemplateInfo;
   import ringStation.RingStationManager;
   import road7th.comm.PackageIn;
   import road7th.data.DictionaryData;
   import room.RoomManager;
   import room.model.RoomInfo;
   import room.model.RoomPlayer;
   import trainer.controller.WeakGuildManager;
   
   public class GameManager extends EventDispatcher
   {
      
      public static var exploreOver:Boolean;
      
      private static var _instance:GameManager;
      
      public static var GAME_CAN_NOT_EXIT_SEND_LOG:int;
      
      public static const CAMP_BATTLE_MODEL_PVE:int = 24;
      
      public static const CAMP_BATTLE_MODEL_PVP:int = 23;
      
      public static const RING_STATION_MODEL:int = 26;
      
      public static const CATCH_BEAST_MODEL:int = 28;
      
      public static const BOMB_KING_FIRST_MODEL:int = 28;
      
      public static const BOMB_KING_FINAL_MODEL:int = 29;
      
      public static const FARM_BOSS_MODEL:int = 50;
      
      public static const CHRISTMAS_MODEL:int = 40;
      
      public static const CRYPTBOSS_MODEL:int = 41;
      
      public static const RESCUE_MODEL:int = 31;
      
      public static const CATCH_INSECT_MODEL:int = 52;
      
      public static const TREASURELOST:int = 55;
      
      public static const START_LOAD:String = "StartLoading";
      
      public static const START_MATCH:String = "StartMatch";
      
      public static var MinLevelDuplicate:int = 8;
      
      public static var MinLevelActivity:int = 25;
      
      public static const ENTER_MISSION_RESULT:String = "EnterMissionResult";
      
      public static const ENTER_ROOM:String = "EnterRoom";
      
      public static const LEAVE_MISSION:String = "leaveMission";
      
      public static const ENTER_DUNGEON:String = "EnterDungeon";
      
      public static const PLAYER_CLICK_PAY:String = "PlayerClickPay";
      
      public static const SKILL_INFO_INIT_GAME:String = "skillInfoInitGame";
      
      public static const MissionGiveup:int = 0;
      
      public static const MissionAgain:int = 1;
      
      public static const MissionTimeout:int = 2;
      
      private var _current:GameInfo;
      
      private var _numCreater:BloodNumberCreater;
      
      public var currentNum:int = 0;
      
      public var bossName:String = "";
      
      public var isAddTerrce:Boolean;
      
      public var terrceX:int;
      
      public var terrceY:int;
      
      public var terrceID:int;
      
      private var _loaderArray:Array;
      
      private var _gameView:GameView;
      
      private var _addLivingEvtVec:Vector.<CrazyTankSocketEvent>;
      
      private var _setPropertyEvtVec:Vector.<CrazyTankSocketEvent>;
      
      private var _livingFallingEvtVec:Vector.<CrazyTankSocketEvent>;
      
      private var _livingShowBloodEvtVec:Vector.<CrazyTankSocketEvent>;
      
      private var _addMapThingEvtVec:Vector.<CrazyTankSocketEvent>;
      
      private var _livingActionMappingEvtVec:Vector.<CrazyTankSocketEvent>;
      
      private var _updatePhysicObjectEvtVec:Vector.<CrazyTankSocketEvent>;
      
      private var _playerBloodEvtVec:Vector.<CrazyTankSocketEvent>;
      
      public var viewCompleteFlag:Boolean;
      
      public var dropGoodslist:Vector.<DropGoods> = new Vector.<DropGoods>();
      
      public var dropData:Array = new Array();
      
      public var dropGlod:int;
      
      public var selectList:Array;
      
      public var TryAgain:int = 0;
      
      private var _recevieLoadSocket:Boolean;
      
      private var _outBombs:DictionaryData;
      
      public var petSkillList:Array;
      
      public var horseSkillList:Array;
      
      public function GameManager()
      {
         super();
      }
      
      public static function isAcademyRoom(gameInfo:GameInfo) : Boolean
      {
         return gameInfo.roomType == RoomInfo.ACADEMY_DUNGEON_ROOM;
      }
      
      public static function isDungeonRoom(gameInfo:GameInfo) : Boolean
      {
         return gameInfo.roomType == RoomInfo.DUNGEON_ROOM || gameInfo.roomType == RoomInfo.LANBYRINTH_ROOM || gameInfo.roomType == RoomInfo.SPECIAL_ACTIVITY_DUNGEON;
      }
      
      public static function isLanbyrinthRoom(gameInfo:GameInfo) : Boolean
      {
         return gameInfo.roomType == RoomInfo.LANBYRINTH_ROOM;
      }
      
      public static function isFightLib(gameInfo:GameInfo) : Boolean
      {
         return gameInfo.roomType == RoomInfo.FIGHT_LIB_ROOM;
      }
      
      public static function isFreshMan(gameInfo:GameInfo) : Boolean
      {
         return gameInfo.roomType == RoomInfo.FRESHMAN_ROOM;
      }
      
      public static function get Instance() : GameManager
      {
         if(_instance == null)
         {
            _instance = new GameManager();
         }
         return _instance;
      }
      
      public function get Current() : GameInfo
      {
         return this._current;
      }
      
      public function set Current(value:GameInfo) : void
      {
         this._current = value;
      }
      
      private function initData() : void
      {
         this._loaderArray = new Array();
         this._addLivingEvtVec = new Vector.<CrazyTankSocketEvent>();
         this._setPropertyEvtVec = new Vector.<CrazyTankSocketEvent>();
         this._livingFallingEvtVec = new Vector.<CrazyTankSocketEvent>();
         this._livingShowBloodEvtVec = new Vector.<CrazyTankSocketEvent>();
         this._addMapThingEvtVec = new Vector.<CrazyTankSocketEvent>();
         this._livingActionMappingEvtVec = new Vector.<CrazyTankSocketEvent>();
         this._updatePhysicObjectEvtVec = new Vector.<CrazyTankSocketEvent>();
         this._playerBloodEvtVec = new Vector.<CrazyTankSocketEvent>();
      }
      
      public function setDropData(itemId:int, count:int) : void
      {
         var isItem:Boolean = false;
         var obj:Object = null;
         for(var i:int = 0; i < this.dropData.length; i++)
         {
            if(this.dropData[i].itemId == itemId)
            {
               this.dropData[i].count += count;
               isItem = true;
               break;
            }
         }
         if(!isItem)
         {
            obj = new Object();
            obj.count = count;
            obj.itemId = itemId;
            this.dropData.push(obj);
         }
      }
      
      public function setup() : void
      {
         this.initData();
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.ADD_LIVING,this.__addLiving);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.PLAYER_PROPERTY,this.__objectSetProperty);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.LIVING_FALLING,this.__livingFalling);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.LIVING_SHOW_BLOOD,this.__livingShowBlood);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.GAME_CREATE,this.__createGame);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.GAME_START,this.__gameStart);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.GAME_LOAD,this.__beginLoad);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.SINGLEBATTLE_STARTMATCH,this.__singleBattleStartMatch);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.LOAD,this.__loadprogress);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.GAME_ALL_MISSION_OVER,this.__missionAllOver);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.GAME_TAKE_OUT,this.__takeOut);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.SHOW_CARDS,this.__showAllCard);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.GAME_MISSION_INFO,this.__gameMissionInfo);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.GAME_MISSION_START,this.__gameMissionStart);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.GAME_MISSION_PREPARE,this.__gameMissionPrepare);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.GAME_ROOM_INFO,this.__missionInviteRoomInfo);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.PLAY_INFO_IN_GAME,this.__updatePlayInfoInGame);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.GAME_MISSION_TRY_AGAIN,this.__missionTryAgain);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.LOAD_RESOURCE,this.__loadResource);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.SELECT_OBJECT,this.__selectObject);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.BUFF_UPDATE,this.__buffUpdate);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.ADD_NEW_PLAYER,this.addNewPlayerHander);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.ADD_TERRACE,this.addTerrace);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.ADD_MAP_THINGS,this.__addMapThing);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.SKILL_INFO_INIT,this.__skillInfoInit);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.ACTION_MAPPING,this.__livingActionMapping);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.UPDATE_BOARD_STATE,this.__updatePhysicObject);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.PLAYER_BLOOD,this.__playerBlood);
      }
      
      protected function __addMapThing(event:CrazyTankSocketEvent) : void
      {
         if(!this.viewCompleteFlag)
         {
            this._addMapThingEvtVec.push(event);
         }
         else
         {
            this._gameView.addMapThing(event);
         }
      }
      
      protected function __livingActionMapping(event:CrazyTankSocketEvent) : void
      {
         if(!this.viewCompleteFlag)
         {
            this._livingActionMappingEvtVec.push(event);
         }
         else
         {
            this._gameView.livingActionMapping(event);
         }
      }
      
      protected function __addLiving(event:CrazyTankSocketEvent) : void
      {
         if(!this.viewCompleteFlag)
         {
            this._addLivingEvtVec.push(event);
         }
         else
         {
            this._gameView.addliving(event);
         }
      }
      
      protected function __updatePhysicObject(event:CrazyTankSocketEvent) : void
      {
         if(!this.viewCompleteFlag)
         {
            this._updatePhysicObjectEvtVec.push(event);
         }
         else
         {
            this._gameView.updatePhysicObject(event);
         }
      }
      
      protected function __playerBlood(event:CrazyTankSocketEvent) : void
      {
         if(!this.viewCompleteFlag)
         {
            this._playerBloodEvtVec.push(event);
         }
         else
         {
            this._gameView.playerBlood(event);
         }
      }
      
      protected function __objectSetProperty(event:CrazyTankSocketEvent) : void
      {
         if(!this.viewCompleteFlag)
         {
            this._setPropertyEvtVec.push(event);
         }
         else
         {
            this._gameView.objectSetProperty(event);
         }
      }
      
      protected function __livingFalling(event:CrazyTankSocketEvent) : void
      {
         if(!this.viewCompleteFlag)
         {
            this._livingFallingEvtVec.push(event);
         }
         else
         {
            this._gameView.livingFalling(event);
         }
      }
      
      protected function __livingShowBlood(event:CrazyTankSocketEvent) : void
      {
         if(!this.viewCompleteFlag)
         {
            this._livingShowBloodEvtVec.push(event);
         }
         else
         {
            this._gameView.livingShowBlood(event);
         }
      }
      
      private function addTerrace(event:CrazyTankSocketEvent) : void
      {
         var livingID:int = 0;
         var info:Player = null;
         var bool:Boolean = false;
         var livingX:int = 0;
         var livingY:int = 0;
         if(!this.Current || this.Current.gameMode != 23)
         {
            return;
         }
         var conut:int = event.pkg.readInt();
         for(var i:int = 0; i < conut; i++)
         {
            livingID = event.pkg.readInt();
            info = this.Current.findPlayer(livingID);
            bool = event.pkg.readBoolean();
            livingX = event.pkg.readInt();
            livingY = event.pkg.readInt();
            info.isLocked = bool;
            this.terrceID = livingID;
            if(bool)
            {
               this.isAddTerrce = true;
               this.terrceX = livingX;
               this.terrceY = livingY + 10;
               GameManager.Instance.dispatchEvent(new GameEvent(GameEvent.ADDTERRACE,[this.terrceX,this.terrceY,livingID]));
            }
            else
            {
               this.isAddTerrce = false;
               GameManager.Instance.dispatchEvent(new GameEvent(GameEvent.DELTERRACE,[livingID]));
            }
         }
      }
      
      private function addNewPlayerHander(event:CrazyTankSocketEvent) : void
      {
         var sex:Boolean = false;
         var Hide:int = 0;
         var Style:String = null;
         var Colors:String = null;
         var Skin:String = null;
         var r:int = 0;
         var pic:String = null;
         var date:String = null;
         var place:int = 0;
         var p:PetInfo = null;
         var ptd:int = 0;
         var activedSkillCount:int = 0;
         var k:int = 0;
         var splace:int = 0;
         var sid:int = 0;
         var deputyWeaponCount:int = 0;
         var buff:FightBuffInfo = null;
         var data:int = 0;
         var Buff:FightBuffInfo = null;
         var K:String = null;
         var Value:String = null;
         var gm:GameInfo = this.Current;
         var pkg:PackageIn = event.pkg;
         var zoneID:int = pkg.readInt();
         var zoneName:String = pkg.readUTF();
         var id:int = pkg.readInt();
         var sp:PlayerInfo = new PlayerInfo();
         sp.beginChanges();
         var fp:RoomPlayer = RoomManager.Instance.current.findPlayerByID(id,zoneID);
         if(fp == null)
         {
            fp = new RoomPlayer(sp);
         }
         sp.ID = id;
         sp.ZoneID = zoneID;
         var nickName:String = pkg.readUTF();
         var isViewer:Boolean = pkg.readBoolean();
         if(isViewer && fp.place < 8)
         {
            fp.place = 8;
         }
         sp.NickName = nickName;
         sp.typeVIP = pkg.readByte();
         sp.VIPLevel = pkg.readInt();
         if(PlayerManager.Instance.isChangeStyleTemp(sp.ID))
         {
            pkg.readBoolean();
            pkg.readInt();
            pkg.readUTF();
            pkg.readUTF();
            pkg.readUTF();
         }
         else
         {
            sex = pkg.readBoolean();
            Hide = pkg.readInt();
            Style = pkg.readUTF();
            Colors = pkg.readUTF();
            Skin = pkg.readUTF();
            sp.Sex = sex;
            sp.Hide = Hide;
            sp.Style = Style;
            sp.Colors = Colors;
            sp.Skin = Skin;
         }
         sp.Grade = pkg.readInt();
         sp.Repute = pkg.readInt();
         sp.WeaponID = pkg.readInt();
         if(sp.WeaponID != 0)
         {
            r = pkg.readInt();
            pic = pkg.readUTF();
            date = pkg.readDateString();
         }
         sp.DeputyWeaponID = pkg.readInt();
         sp.pvpBadgeId = pkg.readInt();
         sp.Nimbus = pkg.readInt();
         sp.IsShowConsortia = pkg.readBoolean();
         sp.ConsortiaID = pkg.readInt();
         sp.ConsortiaName = pkg.readUTF();
         sp.badgeID = pkg.readInt();
         var unknown1:int = pkg.readInt();
         var unknown2:int = pkg.readInt();
         sp.WinCount = pkg.readInt();
         sp.TotalCount = pkg.readInt();
         sp.FightPower = pkg.readInt();
         sp.apprenticeshipState = pkg.readInt();
         sp.masterID = pkg.readInt();
         sp.setMasterOrApprentices(pkg.readUTF());
         sp.AchievementPoint = pkg.readInt();
         sp.honor = pkg.readUTF();
         sp.Offer = pkg.readInt();
         sp.DailyLeagueFirst = pkg.readBoolean();
         sp.DailyLeagueLastScore = pkg.readInt();
         sp.commitChanges();
         fp.playerInfo.IsMarried = pkg.readBoolean();
         if(fp.playerInfo.IsMarried)
         {
            fp.playerInfo.SpouseID = pkg.readInt();
            fp.playerInfo.SpouseName = pkg.readUTF();
         }
         fp.additionInfo.resetAddition();
         fp.additionInfo.GMExperienceAdditionType = Number(pkg.readInt() / 100);
         fp.additionInfo.AuncherExperienceAddition = Number(pkg.readInt() / 100);
         fp.additionInfo.GMOfferAddition = Number(pkg.readInt() / 100);
         fp.additionInfo.AuncherOfferAddition = Number(pkg.readInt() / 100);
         fp.additionInfo.GMRichesAddition = Number(pkg.readInt() / 100);
         fp.additionInfo.AuncherRichesAddition = Number(pkg.readInt() / 100);
         fp.team = pkg.readInt();
         gm.addRoomPlayer(fp);
         var livingID:int = pkg.readInt();
         var blood:int = pkg.readInt();
         var info:Player = new Player(fp.playerInfo,livingID,fp.team,blood);
         var count:int = pkg.readInt();
         for(var j:int = 0; j < count; j++)
         {
            place = pkg.readInt();
            p = sp.pets[place];
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
            sp.pets.add(p.Place,p);
         }
         fp.horseSkillEquipList = [];
         var tmpCount:int = pkg.readInt();
         for(var n:int = 0; n < tmpCount; n++)
         {
            fp.horseSkillEquipList.push(pkg.readInt());
         }
         info.zoneName = zoneName;
         info.currentWeapInfo.refineryLevel = r;
         var livingID1:int = pkg.readInt();
         var x:int = pkg.readInt();
         var y:int = pkg.readInt();
         info.pos = new Point(x,y);
         info.energy = 1;
         info.direction = pkg.readInt();
         var blood2:int = pkg.readInt();
         var maxBlood:int = pkg.readInt();
         info.team = pkg.readInt();
         var refineryLevel:int = pkg.readInt();
         if(info is LocalPlayer)
         {
            (info as LocalPlayer).deputyWeaponCount = pkg.readInt();
         }
         else
         {
            deputyWeaponCount = pkg.readInt();
         }
         info.powerRatio = pkg.readInt();
         info.dander = pkg.readInt();
         info.maxBlood = maxBlood;
         info.updateBlood(blood,0,0);
         info.wishKingCount = pkg.readInt();
         info.wishKingEnergy = pkg.readInt();
         info.currentWeapInfo.refineryLevel = refineryLevel;
         var count1:int = pkg.readInt();
         for(var t_j:int = 0; t_j < count1; t_j++)
         {
            buff = BuffManager.creatBuff(pkg.readInt());
            data = pkg.readInt();
            if(Boolean(buff))
            {
               buff.data = data;
               info.addBuff(buff);
            }
         }
         var buffCount:int = pkg.readInt();
         var buffs:Vector.<FightBuffInfo> = new Vector.<FightBuffInfo>();
         for(var l:int = 0; l < buffCount; l++)
         {
            Buff = BuffManager.creatBuff(pkg.readInt());
            info.outTurnBuffs.push(Buff);
         }
         var isFrost:Boolean = pkg.readBoolean();
         var isHide:Boolean = pkg.readBoolean();
         var isNoHole:Boolean = pkg.readBoolean();
         var isBubble:Boolean = pkg.readBoolean();
         var sealSatesCount:int = pkg.readInt();
         var sealSates:Dictionary = new Dictionary();
         for(var I:int = 0; I < sealSatesCount; I++)
         {
            K = pkg.readUTF();
            Value = pkg.readUTF();
            sealSates[K] = Value;
         }
         if(isFrost)
         {
            isFrost = false;
         }
         info.isFrozen = isFrost;
         info.isHidden = isHide;
         info.isNoNole = isNoHole;
         info.outProperty = sealSates;
         if(RoomManager.Instance.current.type != 5 && Boolean(info.playerInfo.currentPet))
         {
            info.currentPet = new Pet(info.playerInfo.currentPet);
            this.petResLoad(info.playerInfo.currentPet);
         }
         var arr:Array = [fp];
         LoadBombManager.Instance.loadFullRoomPlayersBomb(arr);
         if(!fp.isViewer)
         {
            gm.addGamePlayer(info);
         }
         else
         {
            if(fp.isSelf)
            {
               gm.setSelfGamePlayer(info);
            }
            gm.addGameViewer(info);
         }
      }
      
      protected function __selectObject(event:CrazyTankSocketEvent) : void
      {
         var i:int = 0;
         var id:int = 0;
         var zoneID:int = 0;
         var selectID:int = 0;
         var selectZoneID:int = 0;
         var obj:Object = null;
         this.selectList = [];
         for(var len:int = event.pkg.readInt(); i < len; )
         {
            id = event.pkg.readInt();
            zoneID = event.pkg.readInt();
            this.Current.getRoomPlayerByID(id,zoneID).team = event.pkg.readInt();
            selectID = event.pkg.readInt();
            selectZoneID = event.pkg.readInt();
            obj = new Object();
            obj["id"] = id;
            obj["zoneID"] = zoneID;
            obj["selectID"] = selectID;
            obj["selectZoneID"] = selectZoneID;
            this.selectList.push(obj);
            i++;
         }
         dispatchEvent(new GameEvent(GameEvent.SELECT_COMPLETE,null));
      }
      
      private function petResLoad(currentPet:PetInfo) : void
      {
         var skillid:int = 0;
         var skill:PetSkillTemplateInfo = null;
         var ball:BallInfo = null;
         if(Boolean(currentPet))
         {
            LoadResourceManager.Instance.creatAndStartLoad(PathManager.solvePetGameAssetUrl(currentPet.GameAssetUrl),BaseLoader.MODULE_LOADER);
            for each(skillid in currentPet.equipdSkills)
            {
               if(skillid > 0)
               {
                  skill = PetSkillManager.getSkillByID(skillid);
                  if(Boolean(skill.EffectPic))
                  {
                     LoadResourceManager.Instance.creatAndStartLoad(PathManager.solvePetSkillEffect(skill.EffectPic),BaseLoader.MODULE_LOADER);
                  }
                  if(skill.NewBallID != -1)
                  {
                     ball = BallManager.findBall(skill.NewBallID);
                     ball.loadBombAsset();
                     ball.loadCraterBitmap();
                  }
               }
            }
         }
      }
      
      private function __missionTryAgain(e:CrazyTankSocketEvent) : void
      {
         this.TryAgain = e.pkg.readInt();
         dispatchEvent(new GameEvent(GameEvent.MISSIONAGAIN,this.TryAgain));
      }
      
      private function __updatePlayInfoInGame(e:CrazyTankSocketEvent) : void
      {
         var player:Player = null;
         var room:RoomInfo = RoomManager.Instance.current;
         if(room == null)
         {
            return;
         }
         var pkg:PackageIn = e.pkg;
         var zoneID:int = pkg.readInt();
         var id:int = pkg.readInt();
         var team:int = pkg.readInt();
         var livingid:int = pkg.readInt();
         var blood:int = pkg.readInt();
         var isReady:Boolean = pkg.readBoolean();
         var fp:RoomPlayer = RoomManager.Instance.current.findPlayerByID(id);
         if(zoneID != PlayerManager.Instance.Self.ZoneID || fp == null || this.Current == null)
         {
            return;
         }
         if(fp.isSelf)
         {
            player = new LocalPlayer(PlayerManager.Instance.Self,livingid,team,blood);
         }
         else
         {
            player = new Player(fp.playerInfo,livingid,team,blood);
         }
         player.isReady = isReady;
         if(Boolean(player.movie))
         {
            player.movie.setDefaultAction(player.movie.standAction);
         }
         this.Current.addRoomPlayer(fp);
         if(fp.isViewer)
         {
            this.Current.addGameViewer(player);
         }
         else
         {
            this.Current.addGamePlayer(player);
         }
         if(fp.isSelf && this.Current.roomType != 20)
         {
            StateManager.setState(StateType.MISSION_ROOM);
         }
      }
      
      private function __missionInviteRoomInfo(e:CrazyTankSocketEvent) : void
      {
         var pkg:PackageIn = null;
         var gm:GameInfo = null;
         var len:int = 0;
         var i:int = 0;
         var missionInfo:MissionInfo = null;
         var id:int = 0;
         var sp:PlayerInfo = null;
         var fp:RoomPlayer = null;
         var isViewer:Boolean = false;
         var r:int = 0;
         var pic:String = null;
         var date:String = null;
         var unknown1:int = 0;
         var unknown2:int = 0;
         var livingID:int = 0;
         var blood:int = 0;
         var $isReady:Boolean = false;
         var player:Player = null;
         if(Boolean(RoomManager.Instance.current))
         {
            pkg = e.pkg;
            gm = new GameInfo();
            gm.mapIndex = pkg.readInt();
            gm.roomType = pkg.readInt();
            gm.gameMode = pkg.readInt();
            gm.timeType = pkg.readInt();
            RoomManager.Instance.current.timeType = gm.timeType;
            len = pkg.readInt();
            for(i = 0; i < len; i++)
            {
               id = pkg.readInt();
               sp = PlayerManager.Instance.findPlayer(id);
               sp.beginChanges();
               fp = RoomManager.Instance.current.findPlayerByID(id);
               if(fp == null)
               {
                  fp = new RoomPlayer(sp);
                  sp.ID = id;
               }
               sp.ZoneID = PlayerManager.Instance.Self.ZoneID;
               sp.NickName = pkg.readUTF();
               isViewer = pkg.readBoolean();
               sp.typeVIP = pkg.readByte();
               sp.VIPLevel = pkg.readInt();
               sp.Sex = pkg.readBoolean();
               sp.Hide = pkg.readInt();
               sp.Style = pkg.readUTF();
               sp.Colors = pkg.readUTF();
               sp.Skin = pkg.readUTF();
               sp.Grade = pkg.readInt();
               sp.Repute = pkg.readInt();
               sp.WeaponID = pkg.readInt();
               if(sp.WeaponID > 0)
               {
                  r = pkg.readInt();
                  pic = pkg.readUTF();
                  date = pkg.readDateString();
               }
               sp.DeputyWeaponID = pkg.readInt();
               sp.ConsortiaID = pkg.readInt();
               sp.ConsortiaName = pkg.readUTF();
               sp.badgeID = pkg.readInt();
               unknown1 = pkg.readInt();
               unknown2 = pkg.readInt();
               sp.DailyLeagueFirst = pkg.readBoolean();
               sp.DailyLeagueLastScore = pkg.readInt();
               sp.commitChanges();
               fp.team = pkg.readInt();
               gm.addRoomPlayer(fp);
               livingID = pkg.readInt();
               blood = pkg.readInt();
               $isReady = pkg.readBoolean();
               if(fp.isSelf)
               {
                  player = new LocalPlayer(PlayerManager.Instance.Self,livingID,fp.team,blood);
               }
               else
               {
                  player = new Player(fp.playerInfo,livingID,fp.team,blood);
               }
               player.isReady = $isReady;
               player.currentWeapInfo.refineryLevel = r;
               if(!isViewer)
               {
                  gm.addGamePlayer(player);
               }
               else
               {
                  if(fp.isSelf)
                  {
                     gm.setSelfGamePlayer(player);
                  }
                  gm.addGameViewer(player);
               }
            }
            this.Current = gm;
            missionInfo = new MissionInfo();
            missionInfo.name = pkg.readUTF();
            missionInfo.pic = pkg.readUTF();
            missionInfo.success = pkg.readUTF();
            missionInfo.failure = pkg.readUTF();
            missionInfo.description = pkg.readUTF();
            missionInfo.totalMissiton = pkg.readInt();
            missionInfo.missionIndex = pkg.readInt();
            missionInfo.nextMissionIndex = missionInfo.missionIndex + 1;
            this.Current.missionInfo = missionInfo;
            this.Current.hasNextMission = true;
         }
      }
      
      private function __createGame(event:CrazyTankSocketEvent) : void
      {
         var pkg:PackageIn = null;
         if(Boolean(RoomManager.Instance.current))
         {
            pkg = event.pkg;
            this.createGameInfo(pkg);
         }
      }
      
      private function createGameInfo(pkg:PackageIn, isSingleBattle:Boolean = false) : void
      {
         var zoneID:int = 0;
         var zoneName:String = null;
         var id:int = 0;
         var sp:PlayerInfo = null;
         var fp:RoomPlayer = null;
         var nickName:String = null;
         var isViewer:Boolean = false;
         var isHasConsortia:Boolean = false;
         var unknown1:int = 0;
         var unknown2:int = 0;
         var livingID:int = 0;
         var blood:int = 0;
         var player:Player = null;
         var count:int = 0;
         var j:int = 0;
         var tmpCount:int = 0;
         var n:int = 0;
         var r:int = 0;
         var pic:String = null;
         var date:String = null;
         var place:int = 0;
         var p:PetInfo = null;
         var ptd:int = 0;
         var activedSkillCount:int = 0;
         var k:int = 0;
         var splace:int = 0;
         var sid:int = 0;
         var gm:GameInfo = new GameInfo();
         gm.roomType = pkg.readInt();
         gm.gameMode = pkg.readInt();
         if(gm.gameMode == 20)
         {
            gm.roomType = 18;
         }
         if(gm.roomType == 20 || gm.roomType == 24 || gm.roomType == 27)
         {
            gm.missionInfo = new MissionInfo();
         }
         else if(gm.gameMode == RoomInfo.TRANSNATIONALFIGHT_ROOM)
         {
            RoomManager.Instance.current.type = gm.gameMode;
         }
         if(gm.gameMode == RoomInfo.CONSORTIA_MATCH_SCORE || gm.gameMode == RoomInfo.CONSORTIA_MATCH_RANK || gm.gameMode == RoomInfo.CONSORTIA_MATCH_SCORE_WHOLE || gm.gameMode == RoomInfo.CONSORTIA_MATCH_RANK_WHOLE)
         {
            RoomManager.Instance.current.type = gm.gameMode;
         }
         if(gm.gameMode == RoomInfo.FIGHTFOOTBALLTIME_ROOM)
         {
            RoomManager.Instance.current.type = gm.gameMode;
         }
         gm.timeType = pkg.readInt();
         RoomManager.Instance.current.timeType = gm.timeType;
         var len:int = pkg.readInt();
         for(var i:int = 0; i < len; i++)
         {
            zoneID = pkg.readInt();
            zoneName = pkg.readUTF();
            id = pkg.readInt();
            sp = PlayerManager.Instance.findPlayer(id,zoneID);
            sp.beginChanges();
            fp = RoomManager.Instance.current.findPlayerByID(id,zoneID);
            if(fp == null)
            {
               fp = new RoomPlayer(sp);
            }
            sp.ID = id;
            sp.ZoneID = zoneID;
            nickName = pkg.readUTF();
            isViewer = pkg.readBoolean();
            if(isViewer && fp.place < 8)
            {
               fp.place = 8;
            }
            if(!(fp is SelfInfo))
            {
               sp.NickName = nickName;
            }
            sp.typeVIP = pkg.readByte();
            sp.VIPLevel = pkg.readInt();
            if(PlayerManager.Instance.isChangeStyleTemp(sp.ID))
            {
               pkg.readBoolean();
               pkg.readInt();
               pkg.readUTF();
               pkg.readUTF();
               pkg.readUTF();
            }
            else
            {
               sp.Sex = pkg.readBoolean();
               sp.Hide = pkg.readInt();
               sp.Style = pkg.readUTF();
               sp.Colors = pkg.readUTF();
               sp.Skin = pkg.readUTF();
            }
            sp.Grade = pkg.readInt();
            sp.Repute = pkg.readInt();
            sp.WeaponID = pkg.readInt();
            if(sp.WeaponID != 0)
            {
               r = pkg.readInt();
               pic = pkg.readUTF();
               date = pkg.readDateString();
            }
            if(sp.isSelf && gm.gameMode == RoomInfo.TRANSNATIONALFIGHT_ROOM)
            {
               sp.snapDeputyWeaponID = pkg.readInt();
            }
            else
            {
               sp.DeputyWeaponID = pkg.readInt();
            }
            sp.pvpBadgeId = pkg.readInt();
            sp.Nimbus = pkg.readInt();
            isHasConsortia = pkg.readBoolean();
            sp.ConsortiaID = pkg.readInt();
            sp.ConsortiaName = pkg.readUTF();
            sp.badgeID = pkg.readInt();
            unknown1 = pkg.readInt();
            unknown2 = pkg.readInt();
            sp.WinCount = pkg.readInt();
            sp.TotalCount = pkg.readInt();
            sp.FightPower = pkg.readInt();
            sp.apprenticeshipState = pkg.readInt();
            sp.masterID = pkg.readInt();
            sp.setMasterOrApprentices(pkg.readUTF());
            sp.AchievementPoint = pkg.readInt();
            sp.honor = pkg.readUTF();
            sp.Offer = pkg.readInt();
            sp.DailyLeagueFirst = pkg.readBoolean();
            sp.DailyLeagueLastScore = pkg.readInt();
            sp.fightStatus = 0;
            sp.isTrusteeship = false;
            sp.commitChanges();
            fp.playerInfo.IsMarried = pkg.readBoolean();
            if(fp.playerInfo.IsMarried)
            {
               fp.playerInfo.SpouseID = pkg.readInt();
               fp.playerInfo.SpouseName = pkg.readUTF();
            }
            fp.additionInfo.resetAddition();
            fp.additionInfo.GMExperienceAdditionType = Number(pkg.readInt() / 100);
            fp.additionInfo.AuncherExperienceAddition = Number(pkg.readInt() / 100);
            fp.additionInfo.GMOfferAddition = Number(pkg.readInt() / 100);
            fp.additionInfo.AuncherOfferAddition = Number(pkg.readInt() / 100);
            fp.additionInfo.GMRichesAddition = Number(pkg.readInt() / 100);
            fp.additionInfo.AuncherRichesAddition = Number(pkg.readInt() / 100);
            fp.team = pkg.readInt();
            gm.addRoomPlayer(fp);
            livingID = pkg.readInt();
            if(isSingleBattle)
            {
               livingID = i;
            }
            blood = pkg.readInt();
            if(fp.isSelf)
            {
               player = new LocalPlayer(PlayerManager.Instance.Self,livingID,fp.team,blood);
            }
            else
            {
               player = new Player(fp.playerInfo,livingID,fp.team,blood);
            }
            count = pkg.readInt();
            if(gm.gameMode == RoomInfo.TRANSNATIONALFIGHT_ROOM && sp.isSelf)
            {
               sp.pets.clear();
            }
            for(j = 0; j < count; j++)
            {
               place = pkg.readInt();
               p = sp.pets[place];
               ptd = pkg.readInt();
               if(gm.gameMode == RoomInfo.TRANSNATIONALFIGHT_ROOM)
               {
                  p = new PetInfo();
                  p.TemplateID = ptd;
                  PetInfoManager.fillPetInfo(p);
               }
               else
               {
                  p = sp.pets[place];
                  if(p == null)
                  {
                     p = new PetInfo();
                     p.TemplateID = ptd;
                     PetInfoManager.fillPetInfo(p);
                  }
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
               sp.pets.add(p.Place,p);
               if(RoomManager.Instance.isTransnationalFight())
               {
                  sp.flagID = pkg.readInt();
               }
               if(sp.isSelf && gm.gameMode == RoomInfo.TRANSNATIONALFIGHT_ROOM)
               {
                  sp.snapPet = p;
               }
            }
            fp.horseSkillEquipList = [];
            tmpCount = pkg.readInt();
            for(n = 0; n < tmpCount; n++)
            {
               fp.horseSkillEquipList.push(pkg.readInt());
            }
            player.zoneName = zoneName;
            player.currentWeapInfo.refineryLevel = r;
            if(!fp.isViewer)
            {
               gm.addGamePlayer(player);
            }
            else
            {
               if(fp.isSelf)
               {
                  gm.setSelfGamePlayer(player);
               }
               gm.addGameViewer(player);
            }
         }
         if(BombKingManager.instance.Recording)
         {
            this.setSelfPlayerInfo(gm);
         }
         this.Current = gm;
         if(!isSingleBattle)
         {
            QueueManager.setLifeTime(0);
         }
         RingStationManager.instance.RoomType = gm.roomType;
         CatchBeastManager.instance.RoomType = gm.roomType;
         CryptBossManager.instance.RoomType = gm.roomType;
      }
      
      private function setSelfPlayerInfo(gm:GameInfo) : void
      {
         var selfPlayer:LocalPlayer = null;
         var selfPlayerInfo:SelfInfo = PlayerManager.Instance.Self;
         if(gm.findPlayerByPlayerID(selfPlayerInfo.ID) == null)
         {
            selfPlayer = new LocalPlayer(selfPlayerInfo,0,0,0);
            gm.setSelfGamePlayer(selfPlayer);
            gm.addGameViewer(selfPlayer);
         }
      }
      
      private function __singleBattleStartMatch(event:CrazyTankSocketEvent) : void
      {
         var pkg:PackageIn = null;
         if(Boolean(RoomManager.Instance.current))
         {
            pkg = event.pkg;
            this.createGameInfo(pkg,true);
            dispatchEvent(new Event(START_MATCH));
         }
      }
      
      private function __buffObtain(evt:CrazyTankSocketEvent) : void
      {
         var pkg:PackageIn = null;
         var lth:int = 0;
         var i:int = 0;
         var type:int = 0;
         var isExist:Boolean = false;
         var beginData:Date = null;
         var validDate:int = 0;
         var value:int = 0;
         var buff:BuffInfo = null;
         if(Boolean(this.Current))
         {
            pkg = evt.pkg;
            if(pkg.extend1 == this.Current.selfGamePlayer.LivingID)
            {
               return;
            }
            if(this.Current.findPlayer(pkg.extend1) != null)
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
                  this.Current.findPlayer(pkg.extend1).playerInfo.buffInfo.add(buff.Type,buff);
               }
               evt.stopImmediatePropagation();
            }
         }
      }
      
      private function __buffUpdate(evt:CrazyTankSocketEvent) : void
      {
         var pkg:PackageIn = null;
         var len:int = 0;
         var _type:int = 0;
         var _isExist:Boolean = false;
         var _beginData:Date = null;
         var _validDate:int = 0;
         var _value:int = 0;
         var _buff:BuffInfo = null;
         if(Boolean(this.Current))
         {
            pkg = evt.pkg;
            if(pkg.extend1 == this.Current.selfGamePlayer.LivingID)
            {
               return;
            }
            if(this.Current.findPlayer(pkg.extend1) != null)
            {
               len = pkg.readInt();
               _type = pkg.readInt();
               _isExist = pkg.readBoolean();
               _beginData = pkg.readDate();
               _validDate = pkg.readInt();
               _value = pkg.readInt();
               _buff = new BuffInfo(_type,_isExist,_beginData,_validDate,_value);
               if(_isExist)
               {
                  this.Current.findPlayer(pkg.extend1).playerInfo.buffInfo.add(_buff.Type,_buff);
               }
               else
               {
                  this.Current.findPlayer(pkg.extend1).playerInfo.buffInfo.remove(_buff.Type);
               }
               evt.stopImmediatePropagation();
            }
         }
      }
      
      private function __beginLoad(event:CrazyTankSocketEvent) : void
      {
         var count:int = 0;
         var i:int = 0;
         var petSkillCount:int = 0;
         var j:int = 0;
         var needMovie:GameNeedMovieInfo = null;
         var needPetSkill:GameNeedPetSkillInfo = null;
         StateManager.getInGame_Step_3 = true;
         this._recevieLoadSocket = true;
         if(Boolean(this.Current))
         {
            StateManager.getInGame_Step_4 = true;
            this.Current.maxTime = event.pkg.readInt();
            this.Current.mapIndex = event.pkg.readInt();
            count = event.pkg.readInt();
            for(i = 1; i <= count; i++)
            {
               needMovie = new GameNeedMovieInfo();
               needMovie.type = event.pkg.readInt();
               needMovie.path = event.pkg.readUTF();
               needMovie.classPath = event.pkg.readUTF();
               this.Current.neededMovies.push(needMovie);
            }
            petSkillCount = event.pkg.readInt();
            for(j = 0; j < petSkillCount; j++)
            {
               needPetSkill = new GameNeedPetSkillInfo();
               needPetSkill.pic = event.pkg.readUTF();
               needPetSkill.effect = event.pkg.readUTF();
               this.Current.neededPetSkillResource.push(needPetSkill);
            }
         }
         this.checkCanToLoader();
      }
      
      private function checkCanToLoader() : void
      {
         if(this._recevieLoadSocket && this.Current && (this.Current.missionInfo || !this.getRoomTypeNeedMissionInfo(this.Current.roomType)))
         {
            dispatchEvent(new Event(START_LOAD));
            StateManager.getInGame_Step_5 = true;
            this._recevieLoadSocket = false;
         }
      }
      
      private function getRoomTypeNeedMissionInfo(roomType:int) : Boolean
      {
         return roomType == 2 || roomType == 3 || roomType == 4 || roomType == 5 || roomType == 8 || roomType == 10 || roomType == 11 || roomType == 14 || roomType == 17 || roomType == 20 || roomType == 21;
      }
      
      private function __gameMissionStart(evt:CrazyTankSocketEvent) : void
      {
         var pkg:PackageIn = evt.pkg;
         var obj:Object = new Object();
         obj.id = pkg.clientId;
         var $isReady:Boolean = pkg.readBoolean();
      }
      
      public function dispatchAllGameReadyState(array:Array) : void
      {
         var e:CrazyTankSocketEvent = null;
         var pkg:PackageIn = null;
         var obj:Object = null;
         var id:int = 0;
         var player:Player = null;
         var roomPlayer:RoomPlayer = null;
         for each(e in array)
         {
            pkg = e.pkg;
            obj = new Object();
            id = pkg.clientId;
            if(Boolean(this.Current))
            {
               player = this.Current.findPlayerByPlayerID(id);
               player.isReady = pkg.readBoolean();
               if(!player.isSelf && player.isReady)
               {
                  roomPlayer = RoomManager.Instance.current.findPlayerByID(id);
                  roomPlayer.isReady = true;
               }
            }
            pkg.position = SocketManager.PACKAGE_CONTENT_START_INDEX;
         }
      }
      
      private function __gameMissionPrepare(e:CrazyTankSocketEvent) : void
      {
         if(Boolean(RoomManager.Instance.current))
         {
            RoomManager.Instance.current.setPlayerReadyState(e.pkg.clientId,e.pkg.readBoolean());
         }
      }
      
      private function __gameMissionInfo(evt:CrazyTankSocketEvent) : void
      {
         var temp:String = null;
         var missionInfo:MissionInfo = null;
         if(this.Current == null)
         {
            return;
         }
         if(!this.Current.missionInfo)
         {
            missionInfo = this.Current.missionInfo = new MissionInfo();
         }
         else
         {
            missionInfo = this.Current.missionInfo;
         }
         missionInfo.id = evt.pkg.readInt();
         missionInfo.name = evt.pkg.readUTF();
         missionInfo.success = evt.pkg.readUTF();
         missionInfo.failure = evt.pkg.readUTF();
         missionInfo.description = evt.pkg.readUTF();
         temp = evt.pkg.readUTF();
         missionInfo.totalMissiton = evt.pkg.readInt();
         missionInfo.missionIndex = evt.pkg.readInt();
         missionInfo.totalValue1 = evt.pkg.readInt();
         missionInfo.totalValue2 = evt.pkg.readInt();
         missionInfo.totalValue3 = evt.pkg.readInt();
         missionInfo.totalValue4 = evt.pkg.readInt();
         missionInfo.nextMissionIndex = missionInfo.missionIndex + 1;
         missionInfo.parseString(temp);
         missionInfo.tryagain = evt.pkg.readInt();
         missionInfo.pic = evt.pkg.readUTF();
         this.checkCanToLoader();
      }
      
      private function __loadprogress(evt:CrazyTankSocketEvent) : void
      {
         var progress:int = 0;
         var zoneID:int = 0;
         var id:int = 0;
         var info:RoomPlayer = null;
         if(Boolean(this.Current))
         {
            progress = evt.pkg.readInt();
            zoneID = evt.pkg.readInt();
            id = evt.pkg.readInt();
            info = this.Current.findRoomPlayer(id,zoneID);
            if(Boolean(info) && !info.isSelf)
            {
               info.progress = progress;
            }
         }
      }
      
      private function __gameStart(event:CrazyTankSocketEvent) : void
      {
         var pkg:PackageIn = null;
         var len:int = 0;
         var i:int = 0;
         var bombLength:int = 0;
         var k:int = 0;
         var boxCount:int = 0;
         var b:uint = 0;
         var livingID:int = 0;
         var info:Player = null;
         var blood:int = 0;
         var maxBlood:int = 0;
         var refineryLevel:int = 0;
         var count:int = 0;
         var j:int = 0;
         var buffCount:int = 0;
         var buffs:Vector.<FightBuffInfo> = null;
         var l:int = 0;
         var isFrost:Boolean = false;
         var isHide:Boolean = false;
         var isNoHole:Boolean = false;
         var isBubble:Boolean = false;
         var sealSatesCount:int = 0;
         var sealSates:Dictionary = null;
         var I:int = 0;
         var deputyWeaponCount:int = 0;
         var buff:FightBuffInfo = null;
         var data:int = 0;
         var Buff:FightBuffInfo = null;
         var K:String = null;
         var Value:String = null;
         var bomb:Bomb = null;
         var boxInfo:SimpleBoxInfo = null;
         this.TryAgain = -1;
         ExpTweenManager.Instance.deleteTweens();
         if(Boolean(this.Current))
         {
            event.executed = false;
            pkg = event.pkg;
            len = pkg.readInt();
            for(i = 1; i <= len; i++)
            {
               livingID = pkg.readInt();
               info = this.Current.findPlayer(livingID);
               if(info != null)
               {
                  info.reset();
                  info.pos = new Point(pkg.readInt(),pkg.readInt());
                  info.energy = 1;
                  info.direction = pkg.readInt();
                  blood = pkg.readInt();
                  maxBlood = pkg.readInt();
                  info.team = pkg.readInt();
                  refineryLevel = pkg.readInt();
                  if(info is LocalPlayer)
                  {
                     (info as LocalPlayer).deputyWeaponCount = pkg.readInt();
                  }
                  else
                  {
                     deputyWeaponCount = pkg.readInt();
                  }
                  info.powerRatio = pkg.readInt();
                  info.dander = pkg.readInt();
                  info.maxBlood = maxBlood;
                  info.updateBlood(blood,0,0);
                  info.wishKingCount = pkg.readInt();
                  info.wishKingEnergy = pkg.readInt();
                  info.currentWeapInfo.refineryLevel = refineryLevel;
                  count = pkg.readInt();
                  for(j = 0; j < count; j++)
                  {
                     buff = BuffManager.creatBuff(pkg.readInt());
                     data = pkg.readInt();
                     if(Boolean(buff))
                     {
                        buff.data = data;
                        info.addBuff(buff);
                     }
                  }
                  buffCount = pkg.readInt();
                  buffs = new Vector.<FightBuffInfo>();
                  for(l = 0; l < buffCount; l++)
                  {
                     Buff = BuffManager.creatBuff(pkg.readInt());
                     info.outTurnBuffs.push(Buff);
                  }
                  isFrost = pkg.readBoolean();
                  isHide = pkg.readBoolean();
                  isNoHole = pkg.readBoolean();
                  isBubble = pkg.readBoolean();
                  sealSatesCount = pkg.readInt();
                  sealSates = new Dictionary();
                  for(I = 0; I < sealSatesCount; I++)
                  {
                     K = pkg.readUTF();
                     Value = pkg.readUTF();
                     sealSates[K] = Value;
                  }
                  info.isFrozen = isFrost;
                  info.isHidden = isHide;
                  info.isNoNole = isNoHole;
                  info.outProperty = sealSates;
                  if(RoomManager.Instance.current.type != 5 && Boolean(info.playerInfo.currentPet))
                  {
                     if(RoomManager.Instance.current.type == RoomInfo.TRANSNATIONALFIGHT_ROOM && Boolean(info.playerInfo.snapPet))
                     {
                        info.currentPet = new Pet(info.playerInfo.snapPet);
                     }
                     else if(RoomManager.Instance.current.type != 5 && Boolean(info.playerInfo.currentPet))
                     {
                        info.currentPet = new Pet(info.playerInfo.currentPet);
                     }
                  }
               }
            }
            bombLength = pkg.readInt();
            for(k = 0; k < bombLength; k++)
            {
               bomb = new Bomb();
               bomb.Id = pkg.readInt();
               bomb.X = pkg.readInt();
               bomb.Y = pkg.readInt();
               this.Current.outBombs.add(k,bomb);
            }
            boxCount = pkg.readInt();
            for(b = 0; b < boxCount; b++)
            {
               boxInfo = new SimpleBoxInfo();
               boxInfo.bid = pkg.readInt();
               boxInfo.bx = pkg.readInt();
               boxInfo.by = pkg.readInt();
               boxInfo.subType = pkg.readInt();
               this.Current.outBoxs.add(boxInfo.bid,boxInfo);
            }
            this.Current.startTime = pkg.readDate();
            if(RoomManager.Instance.current.type == 5)
            {
               StateManager.setState(StateType.FIGHT_LIB_GAMEVIEW,this.Current);
               if(PathManager.isStatistics)
               {
                  WeakGuildManager.Instance.statistics(4,TimeManager.Instance.enterFightTime);
               }
            }
            else if(RoomManager.Instance.current.type == RoomInfo.FRESHMAN_ROOM)
            {
               if(StartupResourceLoader.firstEnterHall)
               {
                  StateManager.setState(StateType.TRAINER2,this.Current);
               }
               else
               {
                  StateManager.setState(StateType.TRAINER1,this.Current);
               }
               if(PathManager.isStatistics)
               {
                  WeakGuildManager.Instance.statistics(4,TimeManager.Instance.enterFightTime);
               }
            }
            else if(len == 0)
            {
               if(RoomManager.Instance.current.type == RoomInfo.DUNGEON_ROOM)
               {
                  StateManager.setState(StateType.DUNGEON_LIST);
               }
               else
               {
                  StateManager.setState(StateType.ROOM_LIST);
               }
            }
            else
            {
               StateManager.setState(StateType.FIGHTING,this.Current);
               this.Current.IsOneOnOne = len == 2;
               if(PathManager.isStatistics)
               {
                  WeakGuildManager.Instance.statistics(4,TimeManager.Instance.enterFightTime);
               }
            }
            RoomManager.Instance.resetAllPlayerState();
         }
         CampBattleManager.instance.model.isFighting = true;
      }
      
      private function __missionAllOver(event:CrazyTankSocketEvent) : void
      {
         var i:int = 0;
         var obj:Object = null;
         var id:int = 0;
         var player:Player = null;
         var self:SelfInfo = null;
         var pkg:PackageIn = event.pkg;
         var playerCount:int = pkg.readInt();
         if(this.Current == null)
         {
            return;
         }
         while(i < playerCount)
         {
            id = pkg.readInt();
            player = this.Current.findGamerbyPlayerId(id);
            if(Boolean(player.expObj))
            {
               obj = player.expObj;
            }
            else
            {
               obj = new Object();
            }
            if(Boolean(player))
            {
               obj.killGP = pkg.readInt();
               obj.hertGP = pkg.readInt();
               obj.fightGP = pkg.readInt();
               obj.ghostGP = pkg.readInt();
               obj.gpForVIP = pkg.readInt();
               obj.gpForSpouse = pkg.readInt();
               obj.gpForServer = pkg.readInt();
               obj.gpForApprenticeOnline = pkg.readInt();
               obj.gpForApprenticeTeam = pkg.readInt();
               obj.gpForDoubleCard = pkg.readInt();
               obj.consortiaSkill = pkg.readInt();
               obj.luckyExp = pkg.readInt();
               obj.gainGP = pkg.readInt();
               obj.gpCSMUser = pkg.readInt();
               player.isWin = pkg.readBoolean();
               player.expObj = obj;
            }
            i++;
         }
         if(PathManager.solveExternalInterfaceEnabel() && this.Current.selfGamePlayer.isWin)
         {
            self = PlayerManager.Instance.Self;
         }
         this.Current.missionInfo.missionOverNPCMovies = [];
         var npcMovieCount:int = pkg.readInt();
         for(var j:int = 0; j < npcMovieCount; j++)
         {
            this.Current.missionInfo.missionOverNPCMovies.push(pkg.readUTF());
         }
      }
      
      private function __takeOut(event:CrazyTankSocketEvent) : void
      {
         if(Boolean(this.Current))
         {
            this.Current.resultCard.push(event);
         }
      }
      
      private function __showAllCard(event:CrazyTankSocketEvent) : void
      {
         if(Boolean(this.Current))
         {
            this.Current.showAllCard.push(event);
         }
      }
      
      public function reset() : void
      {
         if(Boolean(this.Current))
         {
            this.Current.dispose();
            this.Current = null;
         }
      }
      
      public function startLoading() : void
      {
         StateManager.setState(StateType.GAME_LOADING);
      }
      
      public function dispatchEnterRoom() : void
      {
         dispatchEvent(new Event(ENTER_ROOM));
      }
      
      public function dispatchLeaveMission() : void
      {
         dispatchEvent(new Event(LEAVE_MISSION));
      }
      
      public function dispatchPaymentConfirm() : void
      {
         dispatchEvent(new Event(PLAYER_CLICK_PAY));
      }
      
      public function selfGetItemShowAndSound(list:Dictionary) : Boolean
      {
         var info:InventoryItemInfo = null;
         var data:ChatData = null;
         var msg:String = null;
         var channelTag:Array = null;
         var goodTag:String = null;
         var playSound:Boolean = false;
         for each(info in list)
         {
            data = new ChatData();
            data.channel = ChatInputView.SYS_NOTICE;
            msg = LanguageMgr.GetTranslation("tank.data.player.FightingPlayerInfo.your");
            channelTag = ChatFormats.getTagsByChannel(data);
            goodTag = ChatFormats.creatGoodTag(info.Property1 != "31" ? "[" + info.Name + "]" : "[" + info.Name + "-" + BeadTemplateManager.Instance.GetBeadInfobyID(info.TemplateID).Name + "Lv" + BeadTemplateManager.Instance.GetBeadInfobyID(info.TemplateID).BaseLevel + "]",ChatFormats.CLICK_GOODS,info.TemplateID,info.Quality,info.IsBinds,data);
            data.htmlMessage = channelTag[0] + msg + goodTag + channelTag[1] + "<BR>";
            ChatManager.Instance.chat(data,false);
            if(info.Quality >= 3)
            {
               playSound = true;
            }
         }
         return playSound;
      }
      
      public function isIdenticalGame(id:int = 0) : Boolean
      {
         var i:RoomPlayer = null;
         var gamePlayers:DictionaryData = RoomManager.Instance.current.players;
         var selfInfo:SelfInfo = PlayerManager.Instance.Self;
         if(id == selfInfo.ID)
         {
            return false;
         }
         for each(i in gamePlayers)
         {
            if(i.playerInfo.ID == id && i.playerInfo.ZoneID == selfInfo.ZoneID)
            {
               return true;
            }
         }
         return false;
      }
      
      private function __loadResource(event:CrazyTankSocketEvent) : void
      {
         var needMovie:GameNeedMovieInfo = null;
         this.setLoaderStop();
         var count:int = event.pkg.readInt();
         for(var i:int = 0; i < count; i++)
         {
            needMovie = new GameNeedMovieInfo();
            needMovie.type = event.pkg.readInt();
            needMovie.path = event.pkg.readUTF();
            needMovie.classPath = event.pkg.readUTF();
            needMovie.startLoad();
         }
      }
      
      private function setLoaderStop() : void
      {
         var length:int = int(this._loaderArray.length);
         for(var i:int = 0; i < length; i++)
         {
            if(!(this._loaderArray[i] as BaseLoader).isComplete)
            {
               (this._loaderArray[i] as BaseLoader).unload();
            }
         }
         this._loaderArray.length = 0;
      }
      
      public function get numCreater() : BloodNumberCreater
      {
         if(Boolean(this._numCreater))
         {
            return this._numCreater;
         }
         this._numCreater = new BloodNumberCreater();
         return this._numCreater;
      }
      
      public function disposeNumCreater() : void
      {
         if(Boolean(this._numCreater))
         {
            this._numCreater.dispose();
         }
         this._numCreater = null;
      }
      
      public function get gameView() : GameView
      {
         return this._gameView;
      }
      
      public function set gameView(value:GameView) : void
      {
         this._gameView = value;
      }
      
      public function get addLivingEvtVec() : Vector.<CrazyTankSocketEvent>
      {
         return this._addLivingEvtVec;
      }
      
      public function get setPropertyEvtVec() : Vector.<CrazyTankSocketEvent>
      {
         return this._setPropertyEvtVec;
      }
      
      public function get livingFallingEvtVec() : Vector.<CrazyTankSocketEvent>
      {
         return this._livingFallingEvtVec;
      }
      
      public function get livingShowBloodEvtVec() : Vector.<CrazyTankSocketEvent>
      {
         return this._livingShowBloodEvtVec;
      }
      
      public function get addMapThingEvtVec() : Vector.<CrazyTankSocketEvent>
      {
         return this._addMapThingEvtVec;
      }
      
      private function __skillInfoInit(event:CrazyTankSocketEvent) : void
      {
         var skillId:int = 0;
         var cd:int = 0;
         var skillId2:int = 0;
         var cd2:int = 0;
         var count2:int = 0;
         var pkg:PackageIn = event.pkg;
         this.petSkillList = [];
         var count:int = pkg.readInt();
         for(var i:int = 0; i < count; i++)
         {
            skillId = pkg.readInt();
            cd = pkg.readInt();
            this.petSkillList.push({
               "id":skillId,
               "cd":cd
            });
            pkg.readInt();
         }
         this.horseSkillList = [];
         count = pkg.readInt();
         for(var j:int = 0; j < count; j++)
         {
            skillId2 = pkg.readInt();
            cd2 = pkg.readInt();
            count2 = pkg.readInt();
            this.horseSkillList.push({
               "id":skillId2,
               "cd":cd2,
               "count":count2
            });
         }
         dispatchEvent(new Event(SKILL_INFO_INIT_GAME));
      }
      
      public function get livingActionMappingEvtVec() : Vector.<CrazyTankSocketEvent>
      {
         return this._livingActionMappingEvtVec;
      }
      
      public function get updatePhysicObjectEvtVec() : Vector.<CrazyTankSocketEvent>
      {
         return this._updatePhysicObjectEvtVec;
      }
      
      public function get playerBloodEvtVec() : Vector.<CrazyTankSocketEvent>
      {
         return this._playerBloodEvtVec;
      }
   }
}

