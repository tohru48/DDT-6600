package worldboss
{
   import com.pickgliss.manager.CacheSysManager;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.constants.CacheConsts;
   import ddt.data.player.PlayerInfo;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.InviteManager;
   import ddt.manager.KeyboardShortcutsManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.StateManager;
   import ddt.states.BaseStateView;
   import ddt.states.StateType;
   import ddt.view.MainToolBar;
   import flash.events.Event;
   import flash.geom.Point;
   import hall.GameLoadingManager;
   import road7th.comm.PackageIn;
   import worldboss.event.WorldBossRoomEvent;
   import worldboss.model.WorldBossRoomModel;
   import worldboss.player.PlayerVO;
   import worldboss.player.RankingPersonInfo;
   import worldboss.view.WaitingWorldBossView;
   import worldboss.view.WorldBossRoomView;
   
   public class WorldBossRoomController extends BaseStateView
   {
      
      private static var _instance:WorldBossRoomController;
      
      private static var _isFirstCome:Boolean = true;
      
      private var _sceneModel:WorldBossRoomModel;
      
      private var _view:WorldBossRoomView;
      
      private var _waitingView:WaitingWorldBossView;
      
      private var _callback:Function;
      
      private var _callbackArg:int;
      
      public function WorldBossRoomController()
      {
         super();
      }
      
      public static function get Instance() : WorldBossRoomController
      {
         if(!_instance)
         {
            _instance = new WorldBossRoomController();
         }
         return _instance;
      }
      
      override public function enter(prev:BaseStateView, data:Object = null) : void
      {
         InviteManager.Instance.enabled = false;
         CacheSysManager.lock(CacheConsts.WORLDBOSS_IN_ROOM);
         KeyboardShortcutsManager.Instance.forbiddenFull();
         GameLoadingManager.Instance.hide();
         super.enter(prev,data);
         LayerManager.Instance.clearnGameDynamic();
         LayerManager.Instance.clearnStageDynamic();
         MainToolBar.Instance.hide();
         this.addEvent();
         SocketManager.Instance.out.sendCurrentState(2);
         if(_isFirstCome)
         {
            this.init();
            _isFirstCome = false;
         }
         else if(Boolean(this._view))
         {
            if(WorldBossManager.IsSuccessStartGame)
            {
               WorldBossManager.Instance.bossInfo.myPlayerVO.buffs = new Array();
               this._view.clearBuff();
            }
            this.checkSelfStatus();
            this._view.setViewAgain();
            SocketManager.Instance.out.sendAddAllWorldBossPlayer();
         }
         if(this._callback != null)
         {
            this._callback(this._callbackArg);
         }
      }
      
      private function init() : void
      {
         this._sceneModel = new WorldBossRoomModel();
         this._view = new WorldBossRoomView(this,this._sceneModel);
         this._view.show();
         this._view.showBuff();
         this._waitingView = new WaitingWorldBossView();
         addChild(this._waitingView);
         this._waitingView.visible = false;
         this._waitingView.addEventListener(WorldBossRoomEvent.ENTER_GAME_TIME_OUT,this.__onTimeOut);
      }
      
      protected function __onTimeOut(event:Event) : void
      {
         this._waitingView.stop();
         this._waitingView.visible = false;
         WorldBossManager.Instance.exitGame();
         this.checkSelfStatus();
      }
      
      private function addEvent() : void
      {
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.WORLDBOSS_ROOM,this.__addPlayer);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.WORLDBOSS_MOVE,this.__movePlayer);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.WORLDBOSS_EXIT,this.__removePlayer);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.WORLDBOSS_PLAYERSTAUTSUPDATE,this.__updatePlayerStauts);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.WORLDBOSS_PLAYERREVIVE,this.__playerRevive);
         WorldBossManager.Instance.addEventListener(WorldBossRoomEvent.FIGHT_OVER,this.__updata);
         WorldBossManager.Instance.addEventListener(CrazyTankSocketEvent.WORLDBOSS_RANKING_INROOM,this.__updataRanking);
         WorldBossManager.Instance.addEventListener(WorldBossRoomEvent.ENTERING_GAME,this.__onEnteringGame);
         WorldBossManager.Instance.addEventListener(WorldBossRoomEvent.GAME_INIT,this.__onGameInit);
      }
      
      protected function __onUpdateBlood(event:Event) : void
      {
         if(Boolean(this._view))
         {
            this._view.refreshHpScript();
         }
      }
      
      protected function __onGameInit(event:Event) : void
      {
         if(Boolean(this._view))
         {
            this._view.refreshHpScript();
         }
      }
      
      protected function __onEnteringGame(event:Event) : void
      {
         this._waitingView.visible = true;
         this._waitingView.start();
      }
      
      public function checkSelfStatus() : void
      {
         this._view.checkSelfStatus();
      }
      
      public function setSelfStatus(value:int) : void
      {
         if(Boolean(this._view))
         {
            this._view.updateSelfStatus(value);
         }
         else
         {
            this._callback = this.setSelfStatus;
            this._callbackArg = value;
         }
      }
      
      private function removeEvent() : void
      {
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.WORLDBOSS_ROOM,this.__addPlayer);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.WORLDBOSS_MOVE,this.__movePlayer);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.WORLDBOSS_EXIT,this.__removePlayer);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.WORLDBOSS_PLAYERSTAUTSUPDATE,this.__updatePlayerStauts);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.WORLDBOSS_PLAYERREVIVE,this.__playerRevive);
         WorldBossManager.Instance.removeEventListener(WorldBossRoomEvent.FIGHT_OVER,this.__updata);
         WorldBossManager.Instance.removeEventListener(CrazyTankSocketEvent.WORLDBOSS_RANKING_INROOM,this.__updataRanking);
         WorldBossManager.Instance.removeEventListener(WorldBossRoomEvent.ENTERING_GAME,this.__onEnteringGame);
         WorldBossManager.Instance.removeEventListener(WorldBossRoomEvent.GAME_INIT,this.__onGameInit);
         WorldBossManager.Instance.removeEventListener(WorldBossRoomEvent.BOSS_HP_UPDATA,this.__onUpdateBlood);
         if(Boolean(this._waitingView))
         {
            this._waitingView.removeEventListener(WorldBossRoomEvent.ENTER_GAME_TIME_OUT,this.__onTimeOut);
         }
      }
      
      override public function getBackType() : String
      {
         return StateType.MAIN;
      }
      
      public function __addPlayer(event:CrazyTankSocketEvent) : void
      {
         var playerInfo:PlayerInfo = null;
         var posx:int = 0;
         var posy:int = 0;
         var playerVO:PlayerVO = null;
         var pkg:PackageIn = event.pkg;
         if(event.pkg.bytesAvailable > 10)
         {
            playerInfo = new PlayerInfo();
            playerInfo.beginChanges();
            playerInfo.Grade = pkg.readInt();
            playerInfo.Hide = pkg.readInt();
            playerInfo.Repute = pkg.readInt();
            playerInfo.ID = pkg.readInt();
            playerInfo.NickName = pkg.readUTF();
            playerInfo.typeVIP = pkg.readByte();
            playerInfo.VIPLevel = pkg.readInt();
            playerInfo.Sex = pkg.readBoolean();
            playerInfo.Style = pkg.readUTF();
            playerInfo.Colors = pkg.readUTF();
            playerInfo.Skin = pkg.readUTF();
            posx = pkg.readInt();
            posy = pkg.readInt();
            playerInfo.FightPower = pkg.readInt();
            playerInfo.WinCount = pkg.readInt();
            playerInfo.TotalCount = pkg.readInt();
            playerInfo.Offer = pkg.readInt();
            playerInfo.commitChanges();
            playerVO = new PlayerVO();
            playerVO.playerInfo = playerInfo;
            playerVO.playerPos = new Point(posx,posy);
            playerVO.playerStauts = pkg.readByte();
            pkg.readInt();
            playerVO.playerInfo.MountsType = pkg.readInt();
            playerVO.playerInfo.PetsID = pkg.readInt();
            if(playerInfo.ID == PlayerManager.Instance.Self.ID)
            {
               return;
            }
            this._sceneModel.addPlayer(playerVO);
         }
      }
      
      public function __removePlayer(event:CrazyTankSocketEvent) : void
      {
         var id:int = event.pkg.readInt();
         this._sceneModel.removePlayer(id);
      }
      
      public function __movePlayer(event:CrazyTankSocketEvent) : void
      {
         var p:Point = null;
         var id:int = event.pkg.readInt();
         var posX:int = event.pkg.readInt();
         var posY:int = event.pkg.readInt();
         var pathStr:String = event.pkg.readUTF();
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
         this._view.movePlayer(id,path);
      }
      
      public function __updatePlayerStauts(event:CrazyTankSocketEvent) : void
      {
         var pkg:PackageIn = event.pkg;
         var id:int = pkg.readInt();
         var stauts:int = pkg.readByte();
         var point:Point = new Point(pkg.readInt(),pkg.readInt());
         this._view.updatePlayerStauts(id,stauts,point);
         this._sceneModel.updatePlayerStauts(id,stauts,point);
      }
      
      private function __playerRevive(event:CrazyTankSocketEvent) : void
      {
         var pkg:PackageIn = event.pkg;
         var id:int = pkg.readInt();
         this._view.playerRevive(id);
      }
      
      public function __updata(e:Event) : void
      {
         if(StateManager.currentStateType == StateType.WORLDBOSS_ROOM)
         {
            this._view.gameOver();
         }
         this._view.timeComplete();
      }
      
      public function __updataRanking(evt:CrazyTankSocketEvent) : void
      {
         var personInfo:RankingPersonInfo = null;
         var pkg:PackageIn = evt.pkg;
         var arr:Array = new Array();
         var count:int = evt.pkg.readInt();
         for(var i:int = 0; i < count; i++)
         {
            personInfo = new RankingPersonInfo();
            personInfo.id = evt.pkg.readInt();
            personInfo.name = evt.pkg.readUTF();
            personInfo.damage = evt.pkg.readInt();
            arr.push(personInfo);
         }
         this._view.updataRanking(arr);
      }
      
      override public function getType() : String
      {
         return StateType.WORLDBOSS_ROOM;
      }
      
      override public function leaving(next:BaseStateView) : void
      {
         InviteManager.Instance.enabled = true;
         CacheSysManager.unlock(CacheConsts.WORLDBOSS_IN_ROOM);
         CacheSysManager.getInstance().release(CacheConsts.WORLDBOSS_IN_ROOM);
         KeyboardShortcutsManager.Instance.cancelForbidden();
         super.leaving(next);
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         if(Boolean(this._sceneModel))
         {
            this._sceneModel.dispose();
         }
         ObjectUtils.disposeAllChildren(this);
         this._view = null;
         this._sceneModel = null;
         CacheSysManager.unlock(CacheConsts.WORLDBOSS_IN_ROOM);
         CacheSysManager.getInstance().release(CacheConsts.WORLDBOSS_IN_ROOM);
         _isFirstCome = true;
      }
   }
}

