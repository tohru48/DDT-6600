package fightFootballTime
{
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.ChatManager;
   import ddt.manager.GameInSocketOut;
   import ddt.manager.StateManager;
   import ddt.states.BaseStateView;
   import ddt.states.StateType;
   import ddt.view.MainToolBar;
   import fightFootballTime.view.FightFootballTimeLoadingView;
   import game.GameManager;
   import game.model.GameInfo;
   import room.RoomManager;
   
   public class FightFootballTimeLoadingState extends BaseStateView
   {
      
      protected var _current:GameInfo;
      
      protected var _loadingView:FightFootballTimeLoadingView;
      
      public function FightFootballTimeLoadingState()
      {
         super();
      }
      
      override public function enter(prev:BaseStateView, data:Object = null) : void
      {
         super.enter(prev,data);
         this._current = data as GameInfo;
         this._loadingView = new FightFootballTimeLoadingView(this._current);
         addChild(this._loadingView);
         ChatManager.Instance.state = ChatManager.CHAT_GAME_LOADING;
         ChatManager.Instance.view.visible = true;
         addChild(ChatManager.Instance.view);
         MainToolBar.Instance.hide();
         ChatManager.Instance.setFocus();
         GameManager.Instance.viewCompleteFlag = false;
      }
      
      override public function leaving(next:BaseStateView) : void
      {
         ObjectUtils.disposeObject(this._loadingView);
         this._loadingView = null;
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
         return StateType.FIGHTFOOTBALLTIME;
      }
   }
}

