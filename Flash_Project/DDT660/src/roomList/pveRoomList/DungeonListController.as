package roomList.pveRoomList
{
   import com.pickgliss.manager.CacheSysManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import ddt.constants.CacheConsts;
   import ddt.data.map.DungeonInfo;
   import ddt.data.player.FriendListPlayer;
   import ddt.data.player.PlayerInfo;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.loader.StartupResourceLoader;
   import ddt.manager.AcademyManager;
   import ddt.manager.EffortMovieClipManager;
   import ddt.manager.GameInSocketOut;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MapManager;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.PlayerTipManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.StateManager;
   import ddt.manager.StatisticManager;
   import ddt.states.StateType;
   import ddt.view.MainToolBar;
   import ddt.view.tips.PlayerTip;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import road7th.comm.PackageIn;
   import road7th.data.DictionaryData;
   import room.RoomManager;
   import room.model.RoomInfo;
   import roomList.LookupEnumerate;
   import roomList.LookupRoomFrame;
   import roomList.pvpRoomList.RoomListCreateRoomView;
   import trainer.data.ArrowType;
   import trainer.data.Step;
   import trainer.view.NewHandContainer;
   
   public class DungeonListController
   {
      
      private static var _instance:DungeonListController;
      
      private var _model:DungeonListModel;
      
      private var _view:DungeonListView;
      
      private var _findRoom:LookupRoomFrame;
      
      private var _defaluDungeonMapId_3:int;
      
      private var _defaluDungeonMapId_4:int;
      
      private var _buffList:DictionaryData;
      
      private var _timer:Timer;
      
      public function DungeonListController()
      {
         this.upMapId();
         super();
      }
      
      public static function disorder(arr:Array) : Array
      {
         var random:int = 0;
         var temInfo:RoomInfo = null;
         for(var i:int = 0; i < arr.length; i++)
         {
            random = Math.random() * 10000 % arr.length;
            temInfo = arr[i];
            arr[i] = arr[random];
            arr[random] = temInfo;
         }
         var newArray:Array = [];
         for(var j:int = 0; j < arr.length; j++)
         {
            if(!(arr[j] as RoomInfo).isPlaying)
            {
               newArray.push(arr[j]);
            }
            else
            {
               newArray.unshift(arr[j]);
            }
         }
         return newArray;
      }
      
      public static function get instance() : DungeonListController
      {
         if(!_instance)
         {
            _instance = new DungeonListController();
         }
         return _instance;
      }
      
      private function init() : void
      {
         this._model = new DungeonListModel();
         StateManager.createStateAsync(StateType.DUNGEON_LIST,this.initDungeonListView);
      }
      
      private function initDungeonListView(type:String = null) : void
      {
         this.initEvent();
         this._view = ComponentFactory.Instance.creatComponentByStylename("roomList.DungeonListView");
         this._view.initView(this,this._model);
         LayerManager.Instance.addToLayer(this._view,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.ALPHA_BLOCKGOUND);
         this._timer = new Timer(1000);
         this._timer.addEventListener(TimerEvent.TIMER,this.timerHandler,false,0,true);
         this._timer.start();
         ++StatisticManager.loginRoomListNum;
         SocketManager.Instance.out.sendCurrentState(1);
         SocketManager.Instance.out.sendSceneLogin(LookupEnumerate.DUNGEON_LIST);
         MainToolBar.Instance.show();
         EffortMovieClipManager.Instance.show();
         CacheSysManager.unlock(CacheConsts.ALERT_IN_FIGHT);
         CacheSysManager.getInstance().release(CacheConsts.ALERT_IN_FIGHT,1200);
         AcademyManager.Instance.showAlert();
         PlayerManager.Instance.Self.isUpGradeInGame = false;
         PlayerManager.Instance.Self.sendOverTimeListByBody();
         if(!PlayerManager.Instance.Self.isDungeonGuideFinish(Step.DUNGEON_GUIDE_1))
         {
            NewHandContainer.Instance.showArrow(ArrowType.DUNGEON_GUIDE,0,"trainer.creatRoomArrowPos","asset.trainer.creatRoomTipAsset","trainer.creatRoomTipPos",LayerManager.Instance.getLayerByType(LayerManager.GAME_TOP_LAYER));
         }
      }
      
      private function timerHandler(event:TimerEvent) : void
      {
         var len:int = this._buffList.length;
         len = len > 50 ? 50 : len;
         var tmpArray:Array = this._buffList.list.concat();
         for(var i:int = 0; i < len; i++)
         {
            this._model.addWaitingPlayer(tmpArray[i]);
            this._buffList.remove(tmpArray[i].ID);
         }
      }
      
      private function initEvent() : void
      {
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.GAME_ROOMLIST_UPDATE,this.__addRoom);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.SCENE_ADD_USER,this.__addWaitingPlayer);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.SCENE_REMOVE_USER,this.__removeWaitingPlayer);
         PlayerTipManager.instance.addEventListener(PlayerTip.CHALLENGE,this.__onChanllengeClick);
      }
      
      private function __addRoom(evt:CrazyTankSocketEvent) : void
      {
         var id:int = 0;
         var info:RoomInfo = null;
         var tempArray:Array = [];
         var pkg:PackageIn = evt.pkg;
         this._model.roomTotal = pkg.readInt();
         var len:int = pkg.readInt();
         for(var i:int = 0; i < len; i++)
         {
            id = pkg.readInt();
            info = this._model.getRoomById(id);
            if(info == null)
            {
               info = new RoomInfo();
            }
            info.ID = id;
            info.type = pkg.readByte();
            info.timeType = pkg.readByte();
            info.totalPlayer = pkg.readByte();
            info.viewerCnt = pkg.readByte();
            info.maxViewerCnt = pkg.readByte();
            info.placeCount = pkg.readByte();
            info.IsLocked = pkg.readBoolean();
            info.mapId = pkg.readInt();
            info.isPlaying = pkg.readBoolean();
            info.Name = pkg.readUTF();
            info.gameMode = pkg.readByte();
            info.hardLevel = pkg.readByte();
            info.levelLimits = pkg.readInt();
            info.isOpenBoss = pkg.readBoolean();
            if(info.type != RoomInfo.FRESHMAN_ROOM)
            {
               tempArray.push(info);
            }
         }
         this.updataRoom(tempArray);
      }
      
      private function updataRoom(tempArray:Array) : void
      {
         if(tempArray.length == 0)
         {
            this._model.updateRoom(tempArray);
            return;
         }
         if((tempArray[0] as RoomInfo).type > 2)
         {
            this._model.updateRoom(tempArray);
         }
      }
      
      private function __addWaitingPlayer(evt:CrazyTankSocketEvent) : void
      {
         var pkg:PackageIn = evt.pkg;
         var player:PlayerInfo = PlayerManager.Instance.findPlayer(pkg.clientId);
         player.beginChanges();
         player.Grade = pkg.readInt();
         player.Sex = pkg.readBoolean();
         player.NickName = pkg.readUTF();
         player.typeVIP = pkg.readByte();
         player.VIPLevel = pkg.readInt();
         player.ConsortiaName = pkg.readUTF();
         player.Offer = pkg.readInt();
         player.WinCount = pkg.readInt();
         player.TotalCount = pkg.readInt();
         player.EscapeCount = pkg.readInt();
         player.ConsortiaID = pkg.readInt();
         player.Repute = pkg.readInt();
         player.IsMarried = pkg.readBoolean();
         if(player.IsMarried)
         {
            player.SpouseID = pkg.readInt();
            player.SpouseName = pkg.readUTF();
         }
         player.LoginName = pkg.readUTF();
         player.FightPower = pkg.readInt();
         player.apprenticeshipState = pkg.readInt();
         player.isOld = pkg.readBoolean();
         player.commitChanges();
         this._buffList.add(player.ID,player);
      }
      
      private function __removeWaitingPlayer(evt:CrazyTankSocketEvent) : void
      {
         var tmpId:int = evt.pkg.clientId;
         if(this._buffList.hasKey(tmpId))
         {
            this._buffList.remove(tmpId);
         }
         else
         {
            this._model.removeWaitingPlayer(tmpId);
         }
      }
      
      public function setRoomShowMode(mode:int) : void
      {
         this._model.roomShowMode = mode;
      }
      
      public function enter() : void
      {
         if(!StartupResourceLoader.firstEnterHall)
         {
            SoundManager.instance.playMusic("062");
         }
         this._buffList = new DictionaryData();
         this.init();
      }
      
      public function hide() : void
      {
         if(Boolean(this._view))
         {
            this._view.dispose();
            this._view = null;
         }
         this.dispose();
         PlayerManager.Instance.Self.sendOverTimeListByBody();
      }
      
      public function getType() : String
      {
         return StateType.DUNGEON_LIST;
      }
      
      public function sendGoIntoRoom(info:RoomInfo) : void
      {
      }
      
      public function showFindRoom() : void
      {
         if(Boolean(this._findRoom))
         {
            this._findRoom.dispose();
         }
         this._findRoom = null;
         this._findRoom = ComponentFactory.Instance.creat("asset.ddtroomList.LookupRoomFrame");
         LayerManager.Instance.addToLayer(this._findRoom,LayerManager.GAME_DYNAMIC_LAYER);
      }
      
      protected function __onChanllengeClick(e:Event) : void
      {
         if(PlayerTipManager.instance.info.Grade < 12)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.roomlist.cantBeChallenged"));
            return;
         }
         if(PlayerTipManager.instance.info.playerState.StateID == 0 && e.target.info is FriendListPlayer)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.roomlist.friendOffline"));
            return;
         }
         var i:int = int(Math.random() * RoomListCreateRoomView.PREWORD.length);
         GameInSocketOut.sendCreateRoom(RoomListCreateRoomView.PREWORD[i],1,2,"");
         RoomManager.Instance.tempInventPlayerID = PlayerTipManager.instance.info.ID;
         PlayerTipManager.instance.removeEventListener(PlayerTip.CHALLENGE,this.__onChanllengeClick);
      }
      
      private function upMapId() : void
      {
         var dungeon:DungeonInfo = MapManager.getListByType(3)[0] as DungeonInfo;
         if(Boolean(dungeon))
         {
            this._defaluDungeonMapId_3 = dungeon.ID;
         }
         var dungeon_4:DungeonInfo = MapManager.getListByType(4)[0] as DungeonInfo;
         if(Boolean(dungeon_4))
         {
            this._defaluDungeonMapId_4 = dungeon_4.ID;
         }
      }
      
      public function dispose() : void
      {
         if(Boolean(this._timer))
         {
            this._timer.removeEventListener(TimerEvent.TIMER,this.timerHandler);
            this._timer.reset();
            this._timer.stop();
            this._timer = null;
         }
         this._buffList = null;
         PlayerTipManager.instance.removeEventListener(PlayerTip.CHALLENGE,this.__onChanllengeClick);
         if(Boolean(this._findRoom))
         {
            this._findRoom.dispose();
         }
         if(Boolean(this._model))
         {
            this._model.dispose();
         }
         this._findRoom = null;
         this._model = null;
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.GAME_ROOMLIST_UPDATE,this.__addRoom);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.SCENE_ADD_USER,this.__addWaitingPlayer);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.SCENE_REMOVE_USER,this.__removeWaitingPlayer);
      }
      
      public function getBackType() : String
      {
         return StateType.MAIN;
      }
   }
}

