package church.controller
{
   import church.model.ChurchRoomListModel;
   import church.view.ChurchMainView;
   import church.view.weddingRoomList.frame.WeddingRoomEnterInputPasswordView;
   import com.pickgliss.ui.ComponentFactory;
   import ddt.data.ChurchRoomInfo;
   import ddt.data.player.SelfInfo;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.ChurchManager;
   import ddt.manager.ExternalInterfaceManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PathManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.ServerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.states.BaseStateView;
   import ddt.states.StateType;
   import ddt.view.MainToolBar;
   import email.manager.MailManager;
   import road7th.comm.PackageIn;
   
   public class ChurchRoomListController extends BaseStateView
   {
      
      private var _model:ChurchRoomListModel;
      
      private var _view:ChurchMainView;
      
      private var _mapSrcLoaded:Boolean = false;
      
      private var _mapServerReady:Boolean = false;
      
      public function ChurchRoomListController()
      {
         super();
      }
      
      override public function prepare() : void
      {
         super.prepare();
      }
      
      override public function enter(prev:BaseStateView, data:Object = null) : void
      {
         super.enter(prev,data);
         this.init();
         this.addEvent();
         MainToolBar.Instance.show();
         SoundManager.instance.playMusic("062");
      }
      
      private function init() : void
      {
         this._model = new ChurchRoomListModel();
         this._view = new ChurchMainView(this,this._model);
         this._view.show();
         this.checkEmailLink();
      }
      
      private function addEvent() : void
      {
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.MARRY_ROOM_CREATE,this.__addRoom);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.MARRY_ROOM_DISPOSE,this.__removeRoom);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.MARRY_ROOM_UPDATE,this.__updateRoom);
      }
      
      private function removeEvent() : void
      {
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.MARRY_ROOM_CREATE,this.__addRoom);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.MARRY_ROOM_DISPOSE,this.__removeRoom);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.MARRY_ROOM_UPDATE,this.__updateRoom);
      }
      
      override public function refresh() : void
      {
         super.refresh();
         this.checkEmailLink();
      }
      
      public function checkEmailLink() : void
      {
         var churchRoomInfo:ChurchRoomInfo = null;
         var _weddingRoomEnterInputPasswordView:WeddingRoomEnterInputPasswordView = null;
         if(MailManager.Instance.linkChurchRoomId != -1)
         {
            this.changeViewState(ChurchMainView.ROOM_LIST);
            churchRoomInfo = new ChurchRoomInfo();
            churchRoomInfo.id = MailManager.Instance.linkChurchRoomId;
            _weddingRoomEnterInputPasswordView = ComponentFactory.Instance.creat("church.main.weddingRoomList.WeddingRoomEnterInputPasswordView");
            _weddingRoomEnterInputPasswordView.churchRoomInfo = churchRoomInfo;
            _weddingRoomEnterInputPasswordView.submitButtonEnable = false;
            _weddingRoomEnterInputPasswordView.show();
            MailManager.Instance.linkChurchRoomId = -1;
         }
      }
      
      private function __addRoom(event:CrazyTankSocketEvent) : void
      {
         var self:SelfInfo = null;
         var pkg:PackageIn = event.pkg;
         var result:Boolean = pkg.readBoolean();
         if(!result)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("church.weddingRoom.WeddingRoomControler.addRoom"));
            return;
         }
         var room:ChurchRoomInfo = new ChurchRoomInfo();
         room.id = pkg.readInt();
         room.isStarted = pkg.readBoolean();
         room.roomName = pkg.readUTF();
         room.isLocked = pkg.readBoolean();
         room.mapID = pkg.readInt();
         room.valideTimes = pkg.readInt();
         room.currentNum = pkg.readInt();
         room.createID = pkg.readInt();
         room.createName = pkg.readUTF();
         room.groomID = pkg.readInt();
         room.groomName = pkg.readUTF();
         room.brideID = pkg.readInt();
         room.brideName = pkg.readUTF();
         room.creactTime = pkg.readDate();
         var statu:int = pkg.readByte();
         if(statu == 1)
         {
            room.status = ChurchRoomInfo.WEDDING_NONE;
         }
         else
         {
            room.status = ChurchRoomInfo.WEDDING_ING;
         }
         if(PathManager.solveExternalInterfaceEnabel())
         {
            self = PlayerManager.Instance.Self;
            ExternalInterfaceManager.sendToAgent(8,self.ID,self.NickName,ServerManager.Instance.zoneName,-1,"",self.SpouseName);
         }
         room.discription = pkg.readUTF();
         this._model.addRoom(room);
      }
      
      private function __removeRoom(event:CrazyTankSocketEvent) : void
      {
         var id:int = event.pkg.readInt();
         this._model.removeRoom(id);
      }
      
      private function __updateRoom(event:CrazyTankSocketEvent) : void
      {
         var room:ChurchRoomInfo = null;
         var statu:int = 0;
         var pkg:PackageIn = event.pkg;
         var result:Boolean = pkg.readBoolean();
         if(result)
         {
            room = new ChurchRoomInfo();
            room.id = pkg.readInt();
            room.isStarted = pkg.readBoolean();
            room.roomName = pkg.readUTF();
            room.isLocked = pkg.readBoolean();
            room.mapID = pkg.readInt();
            room.valideTimes = pkg.readInt();
            room.currentNum = pkg.readInt();
            room.createID = pkg.readInt();
            room.createName = pkg.readUTF();
            room.groomID = pkg.readInt();
            room.groomName = pkg.readUTF();
            room.brideID = pkg.readInt();
            room.brideName = pkg.readUTF();
            room.creactTime = pkg.readDate();
            statu = pkg.readByte();
            if(statu == 1)
            {
               room.status = ChurchRoomInfo.WEDDING_NONE;
            }
            else
            {
               room.status = ChurchRoomInfo.WEDDING_ING;
            }
            room.discription = pkg.readUTF();
            this._model.updateRoom(room);
         }
      }
      
      public function createRoom(room:ChurchRoomInfo) : void
      {
         if(Boolean(ChurchManager.instance.selfRoom))
         {
            SocketManager.Instance.out.sendEnterRoom(0,"");
         }
         SocketManager.Instance.out.sendCreateRoom(room.roomName,Boolean(room.password) ? room.password : "",room.mapID,room.valideTimes,room.canInvite,room.discription);
      }
      
      public function unmarry(isPlayMovie:Boolean = false) : void
      {
         if(Boolean(ChurchManager.instance._selfRoom))
         {
            if(ChurchManager.instance._selfRoom.status == ChurchRoomInfo.WEDDING_ING)
            {
               SocketManager.Instance.out.sendUnmarry(true);
               SocketManager.Instance.out.sendUnmarry(isPlayMovie);
               if(Boolean(this._model) && Boolean(ChurchManager.instance._selfRoom))
               {
                  this._model.removeRoom(ChurchManager.instance._selfRoom.id);
               }
               return;
            }
         }
         SocketManager.Instance.out.sendUnmarry(isPlayMovie);
         if(Boolean(this._model) && Boolean(ChurchManager.instance._selfRoom))
         {
            this._model.removeRoom(ChurchManager.instance._selfRoom.id);
         }
      }
      
      public function changeViewState(state:String) : void
      {
         this._view.changeState(state);
      }
      
      override public function leaving(next:BaseStateView) : void
      {
         super.leaving(next);
         SocketManager.Instance.out.sendExitMarryRoom();
         MainToolBar.Instance.backFunction = null;
         MainToolBar.Instance.hide();
         this.dispose();
      }
      
      override public function getBackType() : String
      {
         return StateType.MAIN;
      }
      
      override public function getType() : String
      {
         return StateType.DDTCHURCH_ROOM_LIST;
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         if(Boolean(this._model))
         {
            this._model.dispose();
         }
         this._model = null;
         if(Boolean(this._view))
         {
            if(Boolean(this._view.parent))
            {
               this._view.parent.removeChild(this._view);
            }
            this._view.dispose();
         }
         this._view = null;
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
   }
}

