package catchInsect.controller
{
   import catchInsect.CatchInsectMananger;
   import catchInsect.data.InsectInfo;
   import catchInsect.event.CatchInsectEvent;
   import catchInsect.event.CatchInsectRoomEvent;
   import catchInsect.loader.LoaderCatchInsectUIModule;
   import catchInsect.model.CatchInsectRoomModel;
   import catchInsect.player.PlayerVO;
   import catchInsect.view.CatchInsectRoomView;
   import christmas.view.playingSnowman.WaitingChristmasView;
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.LoadResourceManager;
   import com.pickgliss.loader.QueueLoader;
   import com.pickgliss.manager.CacheSysManager;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.constants.CacheConsts;
   import ddt.data.player.PlayerInfo;
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
   import road7th.data.DictionaryData;
   
   public class CatchInsectRoomController extends BaseStateView
   {
      
      public static var isTimeOver:Boolean;
      
      private static var _instance:CatchInsectRoomController;
      
      private static var _isFirstCome:Boolean = true;
      
      private var _sceneModel:CatchInsectRoomModel;
      
      private var _view:CatchInsectRoomView;
      
      private var _waitingView:WaitingChristmasView;
      
      protected var _monsters:DictionaryData;
      
      private var _monsterCount:int = 0;
      
      private var _callback:Function;
      
      private var _callbackArg:int;
      
      public function CatchInsectRoomController()
      {
         super();
      }
      
      public static function get Instance() : CatchInsectRoomController
      {
         if(!_instance)
         {
            _instance = new CatchInsectRoomController();
         }
         return _instance;
      }
      
      override public function enter(prev:BaseStateView, data:Object = null) : void
      {
         InviteManager.Instance.enabled = false;
         CacheSysManager.lock(CacheConsts.CATCH_INSECT_SCENE);
         KeyboardShortcutsManager.Instance.forbiddenFull();
         GameLoadingManager.Instance.hide();
         super.enter(prev,data);
         LayerManager.Instance.clearnGameDynamic();
         LayerManager.Instance.clearnStageDynamic();
         MainToolBar.Instance.hide();
         this.addEvent();
         if(CatchInsectMananger.isToRoom)
         {
            this.setSelfStatus(0);
            SocketManager.Instance.out.enterOrLeaveInsectScene(2,CatchInsectMananger.instance.catchInsectInfo.myPlayerVO.playerPos);
         }
         else
         {
            SocketManager.Instance.out.enterOrLeaveInsectScene(2,CatchInsectMananger.instance.catchInsectInfo.playerDefaultPos);
         }
         if(_isFirstCome)
         {
            this.init();
            _isFirstCome = false;
         }
         else if(Boolean(this._view))
         {
            this._view.setViewAgain();
         }
         if(this._callback != null)
         {
            this._callback(this._callbackArg);
         }
      }
      
      private function init() : void
      {
         this._sceneModel = new CatchInsectRoomModel();
         this._view = new CatchInsectRoomView(this,this._sceneModel);
         this._view.show();
         this._waitingView = new WaitingChristmasView();
         addChild(this._waitingView);
         this._waitingView.visible = false;
         this._waitingView.addEventListener(CatchInsectRoomEvent.ENTER_GAME_TIME_OUT,this.__onTimeOut);
      }
      
      protected function __onTimeOut(event:Event) : void
      {
         this._waitingView.stop();
         this._waitingView.visible = false;
         CatchInsectMananger.instance.exitGame();
      }
      
      private function addEvent() : void
      {
         CatchInsectMananger.instance.addEventListener(CatchInsectEvent.ADDPLAYER_ROOM,this.__addPlayer);
         CatchInsectMananger.instance.addEventListener(CatchInsectEvent.MOVE,this.__movePlayer);
         CatchInsectMananger.instance.addEventListener(CatchInsectEvent.PLAYER_STATUE,this.__updatePlayerStauts);
         CatchInsectMananger.instance.addEventListener(CatchInsectEvent.REMOVE_PLAYER,this.__removePlayer);
         CatchInsectMananger.instance.addEventListener(CatchInsectEvent.MONSTER,this.__monstersEvent);
      }
      
      public function __updatePlayerStauts(event:CatchInsectEvent) : void
      {
         var pkg:PackageIn = event.pkg;
         var id:int = pkg.readInt();
         var stauts:int = pkg.readByte();
         var point:Point = new Point(pkg.readInt(),pkg.readInt());
         this._view.updatePlayerStauts(id,stauts,point);
         this._sceneModel.updatePlayerStauts(id,stauts,point);
      }
      
      private function __monstersEvent(pEvent:CatchInsectEvent) : void
      {
         var i:int = 0;
         var monsInfo:InsectInfo = null;
         var id:int = 0;
         var o:InsectInfo = null;
         var count:int = 0;
         var k:int = 0;
         var monsterID:int = 0;
         var monsterX:int = 0;
         var monsterY:int = 0;
         var monsterState:int = 0;
         var ID:int = 0;
         var state:int = 0;
         var queryLoader:QueueLoader = new QueueLoader();
         var p:PackageIn = pEvent.pkg;
         var select:int = p.readByte();
         var path:String = "";
         if(select == 0)
         {
            this._monsterCount = p.readInt();
            for(i = 0; i < this._monsterCount; i++)
            {
               monsInfo = new InsectInfo();
               monsInfo.ID = p.readInt();
               monsInfo.type = p.readInt();
               switch(monsInfo.type)
               {
                  case 0:
                     monsInfo.ActionMovieName = "game.living.Living387";
                     monsInfo.MissionID = 70007;
                     path = "living387";
                     break;
                  case 1:
                     monsInfo.ActionMovieName = "game.living.Living389";
                     monsInfo.MissionID = 70009;
                     path = "living389";
                     break;
                  case 2:
                     monsInfo.ActionMovieName = "game.living.Living388";
                     monsInfo.MissionID = 70008;
                     path = "living388";
               }
               monsInfo.MonsterName = "";
               monsInfo.State = p.readInt();
               monsInfo.MonsterPos = new Point(p.readInt(),p.readInt());
               if(monsInfo.State != InsectInfo.DEAD && !this._sceneModel._mapObjects.hasKey(monsInfo.ID))
               {
                  queryLoader.addLoader(LoadResourceManager.Instance.createLoader(LoaderCatchInsectUIModule.Instance.solveMonsterPath(path),BaseLoader.MODULE_LOADER));
                  this._sceneModel._mapObjects.add(monsInfo.ID,monsInfo);
               }
            }
            queryLoader.addEventListener(Event.COMPLETE,this.__onLoadComplete);
            queryLoader.start();
         }
         else if(select == 1)
         {
            id = p.readInt();
            for each(o in this._sceneModel._mapObjects)
            {
               if(o.ID == id)
               {
                  this._sceneModel._mapObjects.remove(o.ID);
               }
            }
         }
         else if(select == 2)
         {
            count = p.readInt();
            for(k = 0; k < count; k++)
            {
               monsterID = p.readInt();
               monsterX = p.readInt();
               monsterY = p.readInt();
               monsterState = p.readInt();
               if(this._sceneModel._mapObjects && this._sceneModel._mapObjects.hasKey(monsterID) && this._sceneModel._mapObjects[monsterID].State != 1)
               {
                  this._sceneModel._mapObjects[monsterID].State = monsterState;
                  this._sceneModel._mapObjects[monsterID].MonsterNewPos = new Point(monsterX,monsterY);
               }
            }
         }
         else if(select == 3)
         {
            ID = p.readInt();
            state = p.readInt();
            if(Boolean(this._sceneModel._mapObjects) && this._sceneModel._mapObjects.hasKey(ID))
            {
               this._sceneModel._mapObjects[ID].State = state;
            }
         }
      }
      
      private function __onLoadComplete(pEvent:Event) : void
      {
         var loaderQueue:QueueLoader = pEvent.currentTarget as QueueLoader;
         if(loaderQueue.completeCount == this._monsterCount)
         {
            loaderQueue.removeEvent();
         }
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
         CatchInsectMananger.instance.removeEventListener(CatchInsectEvent.ADDPLAYER_ROOM,this.__addPlayer);
         CatchInsectMananger.instance.removeEventListener(CatchInsectEvent.MOVE,this.__movePlayer);
         CatchInsectMananger.instance.removeEventListener(CatchInsectEvent.REMOVE_PLAYER,this.__removePlayer);
         CatchInsectMananger.instance.removeEventListener(CatchInsectEvent.MONSTER,this.__monstersEvent);
         CatchInsectMananger.instance.removeEventListener(CatchInsectEvent.PLAYER_STATUE,this.__updatePlayerStauts);
         if(Boolean(this._waitingView))
         {
            this._waitingView.removeEventListener(CatchInsectRoomEvent.ENTER_GAME_TIME_OUT,this.__onTimeOut);
         }
      }
      
      override public function getBackType() : String
      {
         return StateType.MAIN;
      }
      
      public function __addPlayer(event:CatchInsectEvent) : void
      {
         var playerInfo:PlayerInfo = null;
         var posx:int = 0;
         var posy:int = 0;
         var playerVO:PlayerVO = null;
         var pkg:PackageIn = event.pkg;
         var len:int = pkg.readInt();
         for(var i:int = 0; i < len; i++)
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
            playerInfo.FightPower = pkg.readInt();
            playerInfo.WinCount = pkg.readInt();
            playerInfo.TotalCount = pkg.readInt();
            playerInfo.Offer = pkg.readInt();
            playerInfo.commitChanges();
            posx = pkg.readInt();
            posy = pkg.readInt();
            playerVO = new PlayerVO();
            playerVO.playerInfo = playerInfo;
            playerVO.playerPos = new Point(posx,posy);
            playerVO.playerStauts = pkg.readByte();
            if(playerInfo.ID != PlayerManager.Instance.Self.ID)
            {
               this._sceneModel.addPlayer(playerVO);
            }
         }
      }
      
      public function __removePlayer(event:CatchInsectEvent) : void
      {
         var id:int = event.pkg.readInt();
         if(id == PlayerManager.Instance.Self.ID)
         {
            if(StateManager.currentStateType == StateType.CATCH_INSECT)
            {
               StateManager.setState(StateType.MAIN);
            }
            else
            {
               isTimeOver = true;
            }
         }
         this._sceneModel.removePlayer(id);
      }
      
      public function __movePlayer(event:CatchInsectEvent) : void
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
         if(this._view == null)
         {
            if(this._sceneModel == null)
            {
               this._sceneModel = new CatchInsectRoomModel();
            }
            this._view = new CatchInsectRoomView(this,this._sceneModel);
            this._view.show();
         }
         this._view.movePlayer(id,path);
      }
      
      override public function getType() : String
      {
         return StateType.CATCH_INSECT;
      }
      
      override public function leaving(next:BaseStateView) : void
      {
         InviteManager.Instance.enabled = true;
         CacheSysManager.unlock(CacheConsts.CATCH_INSECT_SCENE);
         CacheSysManager.getInstance().release(CacheConsts.CATCH_INSECT_SCENE);
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
         CacheSysManager.unlock(CacheConsts.CATCH_INSECT_SCENE);
         CacheSysManager.getInstance().release(CacheConsts.CATCH_INSECT_SCENE);
         _isFirstCome = true;
         CatchInsectMananger.isToRoom = false;
      }
   }
}

