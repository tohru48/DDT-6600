package game.view.card
{
   import com.pickgliss.ui.core.Disposeable;
   import consortion.ConsortionModelControl;
   import ddt.data.map.MissionInfo;
   import ddt.events.RoomEvent;
   import ddt.manager.GameInSocketOut;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.StateManager;
   import ddt.states.StateType;
   import ddt.utils.PositionUtils;
   import fightFootballTime.manager.FightFootballTimeManager;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import game.model.GameInfo;
   import game.model.Player;
   import game.view.experience.ExpTweenManager;
   import labyrinth.LabyrinthManager;
   import org.aswing.KeyboardManager;
   import road7th.data.DictionaryEvent;
   import room.model.RoomInfo;
   import room.model.RoomPlayer;
   import treasureLost.controller.TreasureLostManager;
   
   public class TakeOutCardController extends EventDispatcher implements Disposeable
   {
      
      private var _gameInfo:GameInfo;
      
      private var _roomInfo:RoomInfo;
      
      private var _cardView:SmallCardsView;
      
      private var _showSmallCardView:Function;
      
      private var _showLargeCardView:Function;
      
      private var _isKicked:Boolean;
      
      private var _disposeFunc:Function;
      
      public function TakeOutCardController(target:IEventDispatcher = null)
      {
         super(target);
      }
      
      public function setup(gameInfo:GameInfo, roomInfo:RoomInfo) : void
      {
         this._gameInfo = gameInfo;
         this._roomInfo = roomInfo;
         this.initEvent();
         if(this._gameInfo.selfGamePlayer.hasGardGet)
         {
            this.drawCardGetBuff();
         }
      }
      
      private function drawCardGetBuff() : void
      {
      }
      
      public function set disposeFunc(func:Function) : void
      {
         this._disposeFunc = func;
      }
      
      public function set showSmallCardView(func:Function) : void
      {
         this._showSmallCardView = func;
      }
      
      public function set showLargeCardView(func:Function) : void
      {
         this._showLargeCardView = func;
      }
      
      private function initEvent() : void
      {
         if(Boolean(this._gameInfo))
         {
            this._gameInfo.addEventListener(GameInfo.REMOVE_ROOM_PLAYER,this.__removePlayer);
         }
         if(Boolean(this._roomInfo))
         {
            this._roomInfo.addEventListener(RoomEvent.REMOVE_PLAYER,this.__removeRoomPlayer);
         }
      }
      
      private function __removePlayer(event:DictionaryEvent) : void
      {
         var info:Player = event.data as Player;
         if(Boolean(info) && info.isSelf)
         {
            if(this._roomInfo.type == RoomInfo.MATCH_ROOM || this._roomInfo.type == RoomInfo.CHALLENGE_ROOM || this._gameInfo.roomType == RoomInfo.ENCOUNTER_ROOM)
            {
               StateManager.setState(StateType.ROOM_LIST);
            }
            else
            {
               StateManager.setState(StateType.DUNGEON_LIST);
            }
         }
      }
      
      private function __removeRoomPlayer(event:RoomEvent) : void
      {
         var info:RoomPlayer = event.params[0] as RoomPlayer;
         if(Boolean(info) && info.isSelf)
         {
            this._isKicked = true;
         }
      }
      
      public function tryShowCard() : void
      {
         if(this._gameInfo.roomType == RoomInfo.MATCH_ROOM || this._gameInfo.roomType == RoomInfo.CHALLENGE_ROOM || this._gameInfo.roomType == RoomInfo.ENCOUNTER_ROOM || this._gameInfo.roomType == RoomInfo.FIGHTGROUND_ROOM || this._gameInfo.roomType == RoomInfo.SINGLE_BATTLE || this._gameInfo.roomType == RoomInfo.TRANSNATIONALFIGHT_ROOM || this._gameInfo.roomType == FightFootballTimeManager.FIGHTFOOTBALLTIME_ROOM)
         {
            this._cardView = new SmallCardsView();
            PositionUtils.setPos(this._cardView,"takeoutCard.SmallCardViewPos");
            this._cardView.addEventListener(Event.COMPLETE,this.__onCardViewComplete);
            this._showSmallCardView(this._cardView);
            return;
         }
         if(this._gameInfo.selfGamePlayer.isWin)
         {
            if(PlayerManager.Instance.Self.Grade < 2)
            {
               this._gameInfo.missionInfo.tackCardType = MissionInfo.HAVE_NO_CARD;
            }
            if(this._gameInfo.missionInfo.tackCardType == MissionInfo.SMALL_TAKE_CARD)
            {
               this._cardView = new SmallCardsView();
               PositionUtils.setPos(this._cardView,"takeoutCard.SmallCardViewPos");
               this._cardView.addEventListener(Event.COMPLETE,this.__onCardViewComplete);
               this._showSmallCardView(this._cardView);
            }
            else if(this._gameInfo.missionInfo.tackCardType == MissionInfo.BIG_TACK_CARD)
            {
               this._cardView = new LargeCardsView();
               this._cardView.addEventListener(Event.COMPLETE,this.__onCardViewComplete);
               PositionUtils.setPos(this._cardView,"takeoutCard.LargeCardViewPos");
               this._showLargeCardView(this._cardView);
            }
            else
            {
               this.__onCardViewComplete();
            }
         }
         else
         {
            this.setState();
         }
      }
      
      private function __onCardViewComplete(event:Event = null) : void
      {
         if(Boolean(this._cardView))
         {
            this._cardView.removeEventListener(Event.COMPLETE,this.__onCardViewComplete);
         }
         this.setState();
      }
      
      private function removeEvent() : void
      {
         if(Boolean(this._cardView))
         {
            this._cardView.removeEventListener(Event.COMPLETE,this.__onCardViewComplete);
            this._cardView.dispose();
         }
         this._gameInfo.removeEventListener(GameInfo.REMOVE_ROOM_PLAYER,this.__removePlayer);
         this._roomInfo.removeEventListener(RoomEvent.REMOVE_PLAYER,this.__removeRoomPlayer);
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         KeyboardManager.getInstance().isStopDispatching = false;
         SocketManager.Instance.out.sendGetTropToBag(-1);
         PlayerManager.Instance.Self.TempBag.clearnAll();
         ExpTweenManager.Instance.isPlaying = false;
         this._cardView = null;
         this._gameInfo = null;
         this._roomInfo = null;
         this._disposeFunc = null;
         this._showSmallCardView = null;
         this._showLargeCardView = null;
      }
      
      public function setState() : void
      {
         this._disposeFunc();
         var nextState:String = "";
         var callBack:Function = null;
         if(this._isKicked)
         {
            if(this._roomInfo.type == RoomInfo.MATCH_ROOM || this._roomInfo.type == RoomInfo.CHALLENGE_ROOM)
            {
               nextState = StateType.ROOM_LIST;
            }
            else
            {
               nextState = StateType.DUNGEON_LIST;
            }
         }
         else if(this._roomInfo.type == RoomInfo.MATCH_ROOM || this._roomInfo.type == RoomInfo.SCORE_ROOM)
         {
            nextState = StateType.MATCH_ROOM;
         }
         else if(this._roomInfo.type == RoomInfo.RANK_ROOM)
         {
            nextState = StateType.ROOM_LIST;
         }
         else if(this._roomInfo.type == RoomInfo.CHALLENGE_ROOM)
         {
            nextState = StateType.CHALLENGE_ROOM;
         }
         else if(this._roomInfo.type == RoomInfo.FRESHMAN_ROOM)
         {
            nextState = StateType.MAIN;
         }
         else if((this._roomInfo.type == RoomInfo.DUNGEON_ROOM || this._roomInfo.type == RoomInfo.SPECIAL_ACTIVITY_DUNGEON || this._roomInfo.type == RoomInfo.ACADEMY_DUNGEON_ROOM) && this._gameInfo.hasNextMission)
         {
            nextState = StateType.MISSION_ROOM;
         }
         else if(this._roomInfo.type == RoomInfo.FIGHT_LIB_ROOM)
         {
            nextState = StateType.MAIN;
         }
         else if(this._gameInfo.roomType == FightFootballTimeManager.FIGHTFOOTBALLTIME_ROOM)
         {
            nextState = StateType.MAIN;
            PlayerManager.Instance.Self.scoreArr = [];
            GameInSocketOut.sendGamePlayerExit();
         }
         else if(this._roomInfo.type == RoomInfo.NULL_ROOM)
         {
            nextState = StateType.ROOM_LIST;
         }
         else if(this._roomInfo.type == RoomInfo.WORLD_BOSS_FIGHT)
         {
            nextState = StateType.WORLDBOSS_ROOM;
         }
         else if(this._roomInfo.type == RoomInfo.LANBYRINTH_ROOM)
         {
            callBack = LabyrinthManager.Instance.show;
            nextState = StateType.MAIN;
         }
         else if(this._roomInfo.type == RoomInfo.CONSORTIA_BOSS)
         {
            nextState = StateType.CONSORTIA;
            callBack = ConsortionModelControl.Instance.openBossFrame;
         }
         else if(this._roomInfo.type == RoomInfo.CONSORTIA_BATTLE)
         {
            nextState = StateType.CONSORTIA_BATTLE_SCENE;
         }
         else if(this._roomInfo.type == RoomInfo.FIGHTGROUND_ROOM)
         {
            nextState = StateType.MAIN;
         }
         else if(this._roomInfo.type == RoomInfo.ENCOUNTER_ROOM || this._roomInfo.type == RoomInfo.SINGLE_BATTLE)
         {
            nextState = StateType.ROOM_LIST;
         }
         else if(this._roomInfo.type == RoomInfo.TRANSNATIONALFIGHT_ROOM)
         {
            nextState = StateType.MAIN;
         }
         else if(this._roomInfo.type == RoomInfo.TREASURELOST_ROOM)
         {
            nextState = StateType.MAIN;
            TreasureLostManager.Instance.isOpenFrame = true;
         }
         else if(this._roomInfo.type == RoomInfo.DUNGEON_ROOM || this._roomInfo.type == RoomInfo.SPECIAL_ACTIVITY_DUNGEON)
         {
            nextState = StateType.DUNGEON_ROOM;
         }
         else
         {
            nextState = StateType.DUNGEON_ROOM;
         }
         if(PlayerManager.Instance.Self.Grade == 3)
         {
            nextState = StateType.MAIN;
         }
         StateManager.setState(nextState,callBack);
         this.dispose();
      }
   }
}

