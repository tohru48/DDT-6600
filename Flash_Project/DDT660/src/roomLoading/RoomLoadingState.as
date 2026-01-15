package roomLoading
{
   import ddt.loader.StartupResourceLoader;
   import ddt.manager.ChatManager;
   import ddt.manager.GameInSocketOut;
   import ddt.manager.PathManager;
   import ddt.manager.StateManager;
   import ddt.states.BaseStateView;
   import ddt.states.StateType;
   import ddt.view.MainToolBar;
   import game.GameManager;
   import game.model.GameInfo;
   import par.ParticleManager;
   import par.ShapeManager;
   import room.RoomManager;
   import room.model.RoomInfo;
   import roomLoading.view.RoomLoadingView;
   import worldboss.WorldBossManager;
   
   public class RoomLoadingState extends BaseStateView
   {
      
      protected var _current:GameInfo;
      
      protected var _loadingView:RoomLoadingView;
      
      public function RoomLoadingState()
      {
         super();
      }
      
      override public function enter(prev:BaseStateView, data:Object = null) : void
      {
         super.enter(prev,data);
         this._current = data as GameInfo;
         this._loadingView = new RoomLoadingView(this._current);
         addChild(this._loadingView);
         ChatManager.Instance.state = ChatManager.CHAT_GAME_LOADING;
         ChatManager.Instance.view.visible = true;
         addChild(ChatManager.Instance.view);
         MainToolBar.Instance.hide();
         RoomManager.Instance.current.resetStates();
         if(RoomManager.Instance.current.selfRoomPlayer.isHost)
         {
            GameInSocketOut.sendPlayerState(2);
         }
         else
         {
            GameInSocketOut.sendPlayerState(0);
         }
         ChatManager.Instance.setFocus();
         WorldBossManager.Instance.isLoadingState = true;
         if(!StartupResourceLoader.firstEnterHall && !ShapeManager.ready)
         {
            ParticleManager.initPartical(PathManager.FLASHSITE);
         }
      }
      
      override public function leaving(next:BaseStateView) : void
      {
         if(Boolean(this._loadingView))
         {
            this._loadingView.dispose();
            this._loadingView = null;
         }
         this._current = null;
         if(RoomManager.Instance.current.type == RoomInfo.CAMPBATTLE_BATTLE)
         {
            return;
         }
         if(StateManager.isExitRoom(next.getType()))
         {
            GameInSocketOut.sendGamePlayerExit();
            GameManager.Instance.reset();
            RoomManager.Instance.reset();
         }
         MainToolBar.Instance.enableAll();
         super.leaving(next);
      }
      
      override public function getType() : String
      {
         return StateType.ROOM_LOADING;
      }
   }
}

