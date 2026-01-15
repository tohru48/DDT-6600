package game.model
{
   import ddt.data.map.MissionInfo;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.events.GameEvent;
   import ddt.loader.MapLoader;
   import ddt.manager.PlayerManager;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import road7th.data.DictionaryData;
   import room.RoomManager;
   import room.model.RoomPlayer;
   
   public class GameInfo extends EventDispatcher
   {
      
      public static const ADD_ROOM_PLAYER:String = "addRoomPlayer";
      
      public static const REMOVE_ROOM_PLAYER:String = "removeRoomPlayer";
      
      public var redScore:int;
      
      public var blueScore:int;
      
      private var _mapIndex:int;
      
      private var _nextPlayerId:int;
      
      private var _currentPlayerId:int;
      
      public var roomType:int;
      
      public var showAllCard:Array = new Array();
      
      public var startEvent:CrazyTankSocketEvent;
      
      public var GainRiches:int;
      
      public var PlayerCount:int;
      
      public var startPlayer:int;
      
      public var hasNextSession:Boolean;
      
      public var neededMovies:Array = new Array();
      
      public var neededPetSkillResource:Array = new Array();
      
      private var _selfGamePlayer:LocalPlayer;
      
      public var roomPlayers:Array = [];
      
      public var timeType:int;
      
      public var maxTime:int;
      
      public var outBombs:DictionaryData = new DictionaryData();
      
      public var outBoxs:DictionaryData = new DictionaryData();
      
      public var loaderMap:MapLoader;
      
      public var livings:DictionaryData = new DictionaryData();
      
      private var _teams:DictionaryData = new DictionaryData();
      
      public var startTime:Date;
      
      public var viewers:DictionaryData = new DictionaryData();
      
      public var currentLiving:Living;
      
      public var IsOneOnOne:Boolean;
      
      private var _gameMode:int;
      
      private var _resultCard:Array = [];
      
      private var _missionInfo:MissionInfo;
      
      public var missionCount:int;
      
      public var gameOverNpcMovies:Array = [];
      
      private var _wind:Number = 0;
      
      private var _hasNextMission:Boolean;
      
      public function GameInfo()
      {
         super();
      }
      
      public function get currentPlayerId() : int
      {
         return this._currentPlayerId;
      }
      
      public function set currentPlayerId(value:int) : void
      {
         this._currentPlayerId = value;
      }
      
      public function get nextPlayerId() : int
      {
         return this._nextPlayerId;
      }
      
      public function set nextPlayerId(value:int) : void
      {
         this._nextPlayerId = value;
         dispatchEvent(new Event("showNextPlayer"));
      }
      
      public function get mapIndex() : int
      {
         return this._mapIndex;
      }
      
      public function set mapIndex(value:int) : void
      {
         this._mapIndex = value;
      }
      
      public function get teams() : DictionaryData
      {
         return this._teams;
      }
      
      public function set teams(value:DictionaryData) : void
      {
         this._teams = value;
      }
      
      public function set gameMode(value:int) : void
      {
         this._gameMode = value;
      }
      
      public function get gameMode() : int
      {
         return this._gameMode;
      }
      
      public function get resultCard() : Array
      {
         return this._resultCard;
      }
      
      public function set resultCard(arr:Array) : void
      {
         this._resultCard = arr;
      }
      
      public function get missionInfo() : MissionInfo
      {
         return this._missionInfo;
      }
      
      public function set missionInfo(value:MissionInfo) : void
      {
         this._missionInfo = value;
      }
      
      public function resetBossCardCnt() : void
      {
         var living:Living = null;
         var player:Player = null;
         for each(living in this.livings)
         {
            player = living as Player;
            if(Boolean(player))
            {
               player.BossCardCount = 0;
               player.GetCardCount = 0;
            }
         }
      }
      
      public function addGamePlayer(info:Living) : void
      {
         var p:Living = this.livings[info.LivingID];
         if(Boolean(p))
         {
            p.dispose();
         }
         if(info is LocalPlayer)
         {
            this._selfGamePlayer = info as LocalPlayer;
         }
         this.livings.add(info.LivingID,info);
         this.addTeamPlayer(info);
      }
      
      public function addGameViewer(info:Living) : void
      {
         var p:Living = this.viewers[info.playerInfo.ID];
         if(Boolean(p))
         {
            p.dispose();
         }
         if(info is LocalPlayer)
         {
            this._selfGamePlayer = info as LocalPlayer;
         }
         this.viewers.add(info.playerInfo.ID,info);
      }
      
      public function viewerToLiving(playerID:int) : void
      {
         var player:Living = this.viewers[playerID];
         if(Boolean(player))
         {
            this.viewers.remove(playerID);
            if(player is LocalPlayer)
            {
               this._selfGamePlayer = player as LocalPlayer;
            }
            this.livings.add(player.LivingID,player);
            this.addTeamPlayer(player);
         }
      }
      
      public function livingToViewer(playerID:int, zoneID:int) : void
      {
         var player:Living = this.findLivingByPlayerID(playerID,zoneID);
         if(Boolean(player))
         {
            this.livings.remove(player.LivingID);
            this.removeTeamPlayer(player);
            if(player is LocalPlayer)
            {
               this._selfGamePlayer = player as LocalPlayer;
            }
            this.viewers.add(playerID,player);
         }
      }
      
      public function addTeamPlayer(info:Living) : void
      {
         var team:DictionaryData = new DictionaryData();
         if(this.teams[info.team] == null)
         {
            team = new DictionaryData();
            this.teams[info.team] = team;
         }
         else
         {
            team = this.teams[info.team];
         }
         if(team[info.LivingID] == null)
         {
            team.add(info.LivingID,info);
         }
      }
      
      public function removeTeamPlayer(info:Living) : void
      {
         var team:DictionaryData = this.teams[info.team];
         if(Boolean(team) && Boolean(team[info.LivingID]))
         {
            team.remove(info.LivingID);
         }
      }
      
      public function setSelfGamePlayer(info:Living) : void
      {
         this._selfGamePlayer = info as LocalPlayer;
      }
      
      public function removeGamePlayer(livingID:int) : Living
      {
         var info:Living = this.livings[livingID];
         if(Boolean(info))
         {
            this.removeTeamPlayer(info);
            this.livings.remove(livingID);
            info.dispose();
         }
         return info;
      }
      
      public function removeGamePlayerByPlayerID(zoneID:int, playerID:int) : void
      {
         var living:Living = null;
         var viewer:Living = null;
         for each(living in this.livings)
         {
            if(living is Player && Boolean(living.playerInfo))
            {
               if(living.playerInfo.ZoneID == zoneID && living.playerInfo.ID == playerID)
               {
                  this.livings.remove(living.LivingID);
                  living.dispose();
               }
            }
         }
         for each(viewer in this.viewers)
         {
            if(viewer.playerInfo.ZoneID == zoneID && viewer.playerInfo.ID == playerID)
            {
               this.viewers.remove(viewer.playerInfo.ID);
               viewer.dispose();
            }
         }
      }
      
      public function isAllReady() : Boolean
      {
         var info:Player = null;
         var allReady:Boolean = true;
         for each(info in this.livings)
         {
            if(info.isReady == false)
            {
               allReady = false;
               break;
            }
         }
         return allReady;
      }
      
      public function findPlayer(livingID:int) : Player
      {
         return this.livings[livingID] as Player;
      }
      
      public function findPlayerByPlayerID(playerid:int) : Player
      {
         var i:Living = null;
         for each(i in this.livings)
         {
            if(i.isPlayer() && i.playerInfo.ID == playerid)
            {
               return i as Player;
            }
         }
         return null;
      }
      
      public function findGamerbyPlayerId(playerid:int) : Player
      {
         var i:Living = null;
         var v:Living = null;
         for each(i in this.livings)
         {
            if(i.isPlayer() && i.playerInfo.ID == playerid)
            {
               return i as Player;
            }
         }
         for each(v in this.viewers)
         {
            if(v.playerInfo.ID == playerid)
            {
               return v as Player;
            }
         }
         return null;
      }
      
      public function get haveAllias() : Boolean
      {
         var info:Living = null;
         for each(info in this.livings)
         {
            if(info.isLiving && info.team == this.selfGamePlayer.team)
            {
               return true;
            }
         }
         return false;
      }
      
      public function get allias() : Vector.<Player>
      {
         var item:RoomPlayer = null;
         var item1:Player = null;
         var players:Vector.<Player> = new Vector.<Player>();
         for(var i:int = 0; i < this.roomPlayers.length; i++)
         {
            item = this.roomPlayers[i] as RoomPlayer;
            if(Boolean(item))
            {
               item1 = this.findPlayerByPlayerID(item.playerInfo.ID);
               if(item1 && item1.team == this.selfGamePlayer.team && item1 != this.selfGamePlayer && Boolean(item1.expObj))
               {
                  players.push(item1);
               }
            }
         }
         return players;
      }
      
      public function findLiving(livingID:int) : Living
      {
         return this.livings[livingID];
      }
      
      public function findLivingByName(name:String) : Living
      {
         var info:Living = null;
         for each(info in this.livings)
         {
            if(info.isLiving && info.name == name)
            {
               return info;
            }
         }
         return null;
      }
      
      public function findTeam(id:int) : DictionaryData
      {
         return this.teams[id];
      }
      
      public function findLivingByPlayerID(playerID:int, zoneID:int) : Player
      {
         var living:Living = null;
         for each(living in this.livings)
         {
            if(living is Player && Boolean(living.playerInfo))
            {
               if(living.playerInfo.ID == playerID && living.playerInfo.ZoneID == zoneID)
               {
                  return living as Player;
               }
            }
         }
         return null;
      }
      
      public function removeAllMonsters() : void
      {
         var living:Living = null;
         for each(living in this.livings)
         {
            if(!(living is Player))
            {
               this.livings.remove(living.LivingID);
               living.dispose();
            }
         }
      }
      
      public function removeAllTeam() : void
      {
      }
      
      public function get selfGamePlayer() : LocalPlayer
      {
         return this._selfGamePlayer;
      }
      
      public function addRoomPlayer(info:RoomPlayer) : void
      {
         var index:int = int(this.roomPlayers.indexOf(info));
         if(index > -1)
         {
            this.removeRoomPlayer(info.playerInfo.ZoneID,info.playerInfo.ID);
         }
         this.roomPlayers.push(info);
      }
      
      public function removeRoomPlayer(zoneID:int, playerID:int) : void
      {
         var info:RoomPlayer = this.findRoomPlayer(playerID,zoneID);
         if(Boolean(info))
         {
            this.roomPlayers.splice(this.roomPlayers.indexOf(info),1);
         }
      }
      
      public function findRoomPlayer(userID:int, zoneID:int) : RoomPlayer
      {
         var rp:RoomPlayer = null;
         for each(rp in this.roomPlayers)
         {
            if(rp.playerInfo != null)
            {
               if(rp.playerInfo.ID == userID && rp.playerInfo.ZoneID == zoneID)
               {
                  return rp;
               }
            }
         }
         return null;
      }
      
      public function setWind(value:Number, isSelfTurn:Boolean = false, arr:Array = null) : void
      {
         this._wind = value;
         dispatchEvent(new GameEvent(GameEvent.WIND_CHANGED,{
            "wind":this._wind,
            "isSelfTurn":isSelfTurn,
            "windNumArr":arr
         }));
      }
      
      public function get wind() : Number
      {
         return this._wind;
      }
      
      public function get hasNextMission() : Boolean
      {
         return this._hasNextMission;
      }
      
      public function set hasNextMission(value:Boolean) : void
      {
         if(this._hasNextMission == value)
         {
            return;
         }
         this._hasNextMission = value;
      }
      
      public function resetResultCard() : void
      {
         this._resultCard = [];
      }
      
      public function getRoomPlayerByID(id:int, zoneID:int) : RoomPlayer
      {
         var p:RoomPlayer = null;
         for each(p in this.roomPlayers)
         {
            if(p.playerInfo.ID == id && p.playerInfo.ZoneID == zoneID)
            {
               return p;
            }
         }
         return null;
      }
      
      public function get isHasOneDead() : Boolean
      {
         var living:Living = null;
         for each(living in this.livings)
         {
            if(living is Player && living.team == this.selfGamePlayer.team && !living.isLiving)
            {
               return true;
            }
         }
         return false;
      }
      
      public function dispose() : void
      {
         var player:RoomPlayer = null;
         var i:Living = null;
         for each(player in this.roomPlayers)
         {
            if(RoomManager.Instance.current.players.list.indexOf(player) == -1)
            {
               player.dispose();
            }
         }
         if(Boolean(this.roomPlayers))
         {
            this.roomPlayers = null;
         }
         if(Boolean(this.livings))
         {
            for each(i in this.livings)
            {
               i.dispose();
               i = null;
            }
            this.livings.clear();
         }
         if(Boolean(this._resultCard))
         {
            this._resultCard = [];
         }
         this.missionInfo = null;
         if(Boolean(this.loaderMap))
         {
            this.loaderMap.dispose();
         }
         if(PlayerManager.Instance.hasTempStyle)
         {
            PlayerManager.Instance.readAllTempStyleEvent();
         }
      }
   }
}

