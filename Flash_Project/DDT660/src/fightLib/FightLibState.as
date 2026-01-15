package fightLib
{
   import com.pickgliss.toplevel.StageReferance;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.ChatManager;
   import ddt.manager.FightLibManager;
   import ddt.manager.GameInSocketOut;
   import ddt.manager.PathManager;
   import ddt.manager.PlayerManager;
   import ddt.states.BaseStateView;
   import ddt.states.StateType;
   import ddt.view.MainToolBar;
   import flash.display.Shape;
   import flash.events.Event;
   import game.GameManager;
   import par.ParticleManager;
   import room.RoomManager;
   import roomLoading.view.RoomLoadingView;
   
   public class FightLibState extends BaseStateView
   {
      
      public static const LibLevelMin:int = 15;
      
      public static const GuildOne:int = 1;
      
      public static const GuildTwo:int = 2;
      
      private var _container:Shape;
      
      private var _roomLoading:RoomLoadingView;
      
      public function FightLibState()
      {
         super();
      }
      
      override public function dispose() : void
      {
         if(Boolean(this._roomLoading))
         {
            ObjectUtils.disposeObject(this._roomLoading);
            this._roomLoading = null;
         }
         super.dispose();
      }
      
      override public function enter(prev:BaseStateView, data:Object = null) : void
      {
         super.enter(prev,data);
         ParticleManager.initPartical(PathManager.FLASHSITE);
         GameManager.Instance.addEventListener(GameManager.START_LOAD,this.__startLoading);
         this._container = new Shape();
         this._container.graphics.beginFill(0,1);
         this._container.graphics.drawRect(0,0,StageReferance.stageWidth,StageReferance.stageHeight);
         this._container.graphics.endFill();
         addChild(this._container);
         PlayerManager.Instance.Self.sendOverTimeListByBody();
         GameInSocketOut.sendGameStart();
      }
      
      private function __startLoading(evt:Event) : void
      {
         ChatManager.Instance.input.faceEnabled = false;
         ChatManager.Instance.state = ChatManager.CHAT_GAME_LOADING;
         LayerManager.Instance.clearnGameDynamic();
         RoomManager.Instance.current.selfRoomPlayer.resetCharacter();
         this._roomLoading = new RoomLoadingView(GameManager.Instance.Current);
         addChild(this._roomLoading);
         addChild(ChatManager.Instance.view);
         MainToolBar.Instance.hide();
         FightLibManager.Instance.lastInfo = null;
         FightLibManager.Instance.lastFightLibMission = null;
         FightLibManager.Instance.lastWin = false;
      }
      
      override public function getBackType() : String
      {
         return StateType.MAIN;
      }
      
      override public function getType() : String
      {
         return StateType.FIGHT_LIB;
      }
      
      override public function leaving(next:BaseStateView) : void
      {
         GameManager.Instance.removeEventListener(GameManager.START_LOAD,this.__startLoading);
         PlayerManager.Instance.Self.isUpGradeInGame = false;
         FightLibManager.Instance.lastInfo = null;
         FightLibManager.Instance.lastWin = false;
         if(Boolean(this._roomLoading))
         {
            ObjectUtils.disposeObject(this._roomLoading);
            this._roomLoading = null;
         }
         if(next.getType() != StateType.FIGHT_LIB_GAMEVIEW)
         {
            GameInSocketOut.sendGamePlayerExit();
            RoomManager.Instance.reset();
         }
         PlayerManager.Instance.Self.sendOverTimeListByBody();
      }
   }
}

