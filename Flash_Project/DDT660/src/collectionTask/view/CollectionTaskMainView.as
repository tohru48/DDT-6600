package collectionTask.view
{
   import collectionTask.event.CollectionTaskEvent;
   import collectionTask.model.CollectionTaskModel;
   import collectionTask.vo.PlayerVO;
   import com.pickgliss.manager.CacheSysManager;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.constants.CacheConsts;
   import ddt.data.player.PlayerInfo;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.InviteManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.StateManager;
   import ddt.manager.TaskManager;
   import ddt.states.BaseStateView;
   import ddt.states.StateType;
   import ddt.view.MainToolBar;
   import flash.events.Event;
   import flash.geom.Point;
   import road7th.comm.PackageIn;
   
   public class CollectionTaskMainView extends BaseStateView
   {
      
      private var _mapView:CollectionTaskRoomView;
      
      private var _sceneModel:CollectionTaskModel;
      
      public function CollectionTaskMainView()
      {
         super();
      }
      
      override public function enter(prev:BaseStateView, data:Object = null) : void
      {
         InviteManager.Instance.enabled = false;
         CacheSysManager.lock(CacheConsts.ALERT_IN_COLLECTIONTASK);
         super.enter(prev,data);
         SoundManager.instance.playMusic("12025");
         LayerManager.Instance.clearnGameDynamic();
         LayerManager.Instance.clearnStageDynamic();
         SocketManager.Instance.out.sendCurrentState(0);
         MainToolBar.Instance.hide();
         this.initView();
         this.addEvent();
         SocketManager.Instance.out.sendCollectionSceneEnter();
      }
      
      private function initView() : void
      {
         this._sceneModel = new CollectionTaskModel();
         this._mapView = new CollectionTaskRoomView(this._sceneModel);
         addChild(this._mapView);
      }
      
      private function addEvent() : void
      {
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.COLLECTION_TASK,this.__pkgHandler);
         TaskManager.instance.addEventListener(CollectionTaskEvent.REFRESH_COMPLETE,this.__refreshProgress);
      }
      
      protected function __refreshProgress(event:Event) : void
      {
         this._mapView.refreshProgress();
      }
      
      protected function __pkgHandler(event:CrazyTankSocketEvent) : void
      {
         var pkg:PackageIn = event.pkg;
         var cmd:int = pkg.readByte();
         switch(cmd)
         {
            case CollectionTaskEvent.INIT_PLAYERS:
               this.initPlayers(pkg);
               break;
            case CollectionTaskEvent.ADD_ONE_PLAYER:
               this.addOnePlayer(pkg);
               break;
            case CollectionTaskEvent.WALK:
               this.movePlayer(pkg);
               break;
            case CollectionTaskEvent.COLLECT:
               break;
            case CollectionTaskEvent.QUIT:
               this.removePlayer(pkg);
         }
      }
      
      public function initPlayers(pkg:PackageIn) : void
      {
         var len:int = pkg.readInt();
         var count:int = len > 20 ? 20 : len;
         this.addPlayer(pkg,count);
         if(this._mapView == null)
         {
            if(this._sceneModel == null)
            {
               this._sceneModel = new CollectionTaskModel();
            }
            this._mapView = new CollectionTaskRoomView(this._sceneModel);
            addChild(this._mapView);
         }
         this._mapView.addRobertPlayer(len + 1);
      }
      
      public function addOnePlayer(pkg:PackageIn) : void
      {
         if(this._mapView.getAllPlayersLength() > 20)
         {
            return;
         }
         this.addPlayer(pkg,1);
      }
      
      private function addPlayer(pkg:PackageIn, len:int) : void
      {
         var playerInfo:PlayerInfo = null;
         var posx:int = 0;
         var posy:int = 0;
         var playerVO:PlayerVO = null;
         for(var i:int = 0; i < len; i++)
         {
            playerInfo = new PlayerInfo();
            playerInfo.beginChanges();
            playerInfo.ID = pkg.readInt();
            playerInfo.NickName = pkg.readUTF();
            playerInfo.isOld = pkg.readBoolean();
            playerInfo.typeVIP = pkg.readByte();
            playerInfo.VIPLevel = pkg.readInt();
            playerInfo.Sex = pkg.readBoolean();
            playerInfo.Style = pkg.readUTF();
            playerInfo.Colors = pkg.readUTF();
            playerInfo.Skin = pkg.readUTF();
            playerInfo.commitChanges();
            posx = pkg.readInt();
            posy = pkg.readInt();
            playerVO = new PlayerVO();
            playerVO.playerInfo = playerInfo;
            playerVO.playerPos = new Point(posx,posy);
            if(playerInfo.ID != PlayerManager.Instance.Self.ID)
            {
               this._sceneModel.addPlayer(playerVO);
            }
         }
      }
      
      public function movePlayer(pkg:PackageIn) : void
      {
         var p:Point = null;
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
         if(this._mapView == null)
         {
            if(this._sceneModel == null)
            {
               this._sceneModel = new CollectionTaskModel();
            }
            this._mapView = new CollectionTaskRoomView(this._sceneModel);
            addChild(this._mapView);
         }
         this._mapView.movePlayer(id,path);
      }
      
      public function removePlayer(pkg:PackageIn) : void
      {
         var id:int = pkg.readInt();
         this._sceneModel.removePlayer(id);
         if(id == PlayerManager.Instance.Self.ID)
         {
            StateManager.setState(StateType.MAIN);
         }
      }
      
      private function removeEvent() : void
      {
         TaskManager.instance.removeEventListener(CollectionTaskEvent.REFRESH_COMPLETE,this.__refreshProgress);
      }
      
      override public function getType() : String
      {
         return StateType.COLLECTION_TASK_SCENE;
      }
      
      override public function leaving(next:BaseStateView) : void
      {
         InviteManager.Instance.enabled = true;
         CacheSysManager.unlock(CacheConsts.ALERT_IN_COLLECTIONTASK);
         CacheSysManager.getInstance().release(CacheConsts.ALERT_IN_COLLECTIONTASK);
         this.removeEvent();
         super.leaving(next);
         ObjectUtils.disposeObject(this._mapView);
         this._mapView = null;
      }
   }
}

