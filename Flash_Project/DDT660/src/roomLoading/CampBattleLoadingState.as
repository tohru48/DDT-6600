package roomLoading
{
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.ChatManager;
   import ddt.manager.GameInSocketOut;
   import ddt.manager.StateManager;
   import ddt.states.BaseStateView;
   import ddt.states.StateType;
   import ddt.view.MainToolBar;
   import game.GameManager;
   import game.model.GameInfo;
   import room.RoomManager;
   import roomLoading.view.CampBattleRoomLoadingView;
   
   public class CampBattleLoadingState extends RoomLoadingState
   {
      
      public function CampBattleLoadingState()
      {
         super();
      }
      
      override public function enter(prev:BaseStateView, data:Object = null) : void
      {
         super.enter(prev,data);
         _current = data as GameInfo;
         _loadingView = new CampBattleRoomLoadingView(_current);
         addChild(_loadingView);
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
      }
      
      override public function leaving(next:BaseStateView) : void
      {
         ObjectUtils.disposeObject(_loadingView);
         _loadingView = null;
         _current = null;
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
         return StateType.CAMP_BATTLE_LOADING;
      }
   }
}

