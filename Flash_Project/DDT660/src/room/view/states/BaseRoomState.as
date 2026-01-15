package room.view.states
{
   import com.pickgliss.manager.CacheSysManager;
   import com.pickgliss.ui.LayerManager;
   import ddt.constants.CacheConsts;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.loader.StartupResourceLoader;
   import ddt.manager.AcademyManager;
   import ddt.manager.ChatManager;
   import ddt.manager.EffortMovieClipManager;
   import ddt.manager.GameInSocketOut;
   import ddt.manager.PathManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import ddt.manager.StateManager;
   import ddt.states.BaseStateView;
   import ddt.states.StateType;
   import ddt.view.MainToolBar;
   import flash.events.Event;
   import game.GameManager;
   import hall.tasktrack.HallTaskTrackManager;
   import par.ParticleManager;
   import par.ShapeManager;
   import room.RoomManager;
   import room.model.RoomInfo;
   import room.view.roomView.BaseRoomView;
   
   public class BaseRoomState extends BaseStateView
   {
      
      protected var _info:RoomInfo;
      
      protected var _roomView:BaseRoomView;
      
      public function BaseRoomState()
      {
         super();
         if(!StartupResourceLoader.firstEnterHall && !ShapeManager.ready)
         {
            ParticleManager.initPartical(PathManager.FLASHSITE);
         }
      }
      
      override public function enter(prev:BaseStateView, data:Object = null) : void
      {
         super.enter(prev,data);
         if(!StartupResourceLoader.firstEnterHall)
         {
            SoundManager.instance.playMusic("065");
         }
         this._info = RoomManager.Instance.current;
         MainToolBar.Instance.show();
         if(this._info.selfRoomPlayer.isViewer)
         {
            MainToolBar.Instance.setRoomStartState();
            MainToolBar.Instance.setReturnEnable(true);
         }
         MainToolBar.Instance.setReturnEnable(true);
         if(PlayerManager.Instance.hasTempStyle)
         {
            PlayerManager.Instance.readAllTempStyleEvent();
         }
         this.initEvents();
         EffortMovieClipManager.Instance.show();
         CacheSysManager.unlock(CacheConsts.ALERT_IN_FIGHT);
         CacheSysManager.getInstance().release(CacheConsts.ALERT_IN_FIGHT,1200);
         addChild(ChatManager.Instance.view);
         ChatManager.Instance.state = ChatManager.CHAT_ROOM_STATE;
         ChatManager.Instance.setFocus();
         AcademyManager.Instance.showAlert();
         PlayerManager.Instance.Self.sendOverTimeListByBody();
         HallTaskTrackManager.instance.checkOpenCommitView();
      }
      
      protected function initEvents() : void
      {
         GameManager.Instance.addEventListener(GameManager.START_LOAD,this.__startLoading);
         StateManager.getInGame_Step_1 = true;
      }
      
      protected function removeEvents() : void
      {
         GameManager.Instance.removeEventListener(GameManager.START_LOAD,this.__startLoading);
         StateManager.getInGame_Step_8 = true;
      }
      
      override public function leaving(next:BaseStateView) : void
      {
         this.removeEvents();
         if(Boolean(this._roomView))
         {
            this._roomView.dispose();
            this._roomView = null;
         }
         this._info = null;
         if(StateManager.isExitRoom(next.getType()))
         {
            GameInSocketOut.sendGamePlayerExit();
            GameManager.Instance.reset();
            RoomManager.Instance.reset();
         }
         MainToolBar.Instance.enableAll();
         super.leaving(next);
         PlayerManager.Instance.Self.sendOverTimeListByBody();
      }
      
      protected function __startLoading(e:Event) : void
      {
         StateManager.getInGame_Step_6 = true;
         ChatManager.Instance.input.faceEnabled = false;
         LayerManager.Instance.clearnGameDynamic();
         StateManager.setState(StateType.ROOM_LOADING,GameManager.Instance.Current);
         StateManager.getInGame_Step_7 = true;
      }
      
      private function __onFightNpc(evt:CrazyTankSocketEvent) : void
      {
      }
   }
}

