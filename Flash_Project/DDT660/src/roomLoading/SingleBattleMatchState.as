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
   import roomLoading.view.SingleBattleMatchingView;
   
   public class SingleBattleMatchState extends BaseStateView
   {
      
      protected var _current:GameInfo;
      
      protected var _matchView:SingleBattleMatchingView;
      
      public function SingleBattleMatchState()
      {
         super();
      }
      
      override public function enter(prev:BaseStateView, data:Object = null) : void
      {
         super.enter(prev,data);
         this._current = data as GameInfo;
         this._matchView = new SingleBattleMatchingView(this._current);
         addChild(this._matchView);
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
         ObjectUtils.disposeObject(this._matchView);
         this._matchView = null;
         this._current = null;
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
         return StateType.SINGLEBATTLE_MATCHING;
      }
   }
}

