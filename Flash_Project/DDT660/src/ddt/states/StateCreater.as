package ddt.states
{
   import Dice.View.DiceSystem;
   import academy.AcademyController;
   import auctionHouse.controller.AuctionHouseController;
   import boguAdventure.view.BoguAdventureStateView;
   import campbattle.view.CampBattleView;
   import catchInsect.controller.CatchInsectRoomController;
   import christmas.controller.ChristmasRoomController;
   import church.controller.ChurchRoomController;
   import church.controller.ChurchRoomListController;
   import civil.CivilController;
   import collectionTask.view.CollectionTaskMainView;
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.UIModuleLoader;
   import com.pickgliss.utils.StringUtils;
   import consortion.ConsortionControl;
   import consortionBattle.view.ConsortiaBattleMainView;
   import ddt.data.UIModuleTypes;
   import ddt.manager.PlayerManager;
   import ddt.view.UIModuleSmallLoading;
   import drgnBoat.views.DrgnBoatMainView;
   import escort.view.EscortMainView;
   import farm.viewx.FarmSwitchView;
   import fightFootballTime.FightFootballTimeLoadingState;
   import fightLib.FightLibState;
   import fightLib.view.FightLibGameView;
   import flash.events.Event;
   import flash.utils.Dictionary;
   import game.view.GameView;
   import hall.HallStateView;
   import lightRoad.Controller.LightRoadController;
   import littleGame.LittleGame;
   import littleGame.LittleHall;
   import login.LoginStateView;
   import lottery.LotteryContorller;
   import lottery.contorller.CardLotteryContorller;
   import magpieBridge.view.MagPieBridgeView;
   import pyramid.view.PyramidSystem;
   import room.RoomManager;
   import room.model.RoomInfo;
   import room.view.states.ChallengeRoomState;
   import room.view.states.DungeonRoomState;
   import room.view.states.FreshmanRoomState;
   import room.view.states.MatchRoomState;
   import room.view.states.MissionRoomState;
   import roomLoading.CampBattleLoadingState;
   import roomLoading.EncounterLoadingState;
   import roomLoading.RoomLoadingState;
   import roomLoading.SingleBattleMatchState;
   import sevenDouble.view.SevenDoubleMainView;
   import shop.ShopController;
   import superWinner.controller.SuperWinnerController;
   import tofflist.TofflistController;
   import trainer.view.TrainerGameView;
   import treasure.view.TreasureMain;
   import worldboss.WorldBossAwardController;
   import worldboss.WorldBossManager;
   import worldboss.WorldBossRoomController;
   import worldboss.event.WorldBossRoomEvent;
   import worldboss.view.WorldBossFightRoomState;
   
   public class StateCreater implements IStateCreator
   {
      
      private var _state:Dictionary = new Dictionary();
      
      private var _currentStateType:String;
      
      public function StateCreater()
      {
         super();
      }
      
      public function create(type:String, id:int = 0) : BaseStateView
      {
         UIModuleSmallLoading.Instance.hide();
         switch(type)
         {
            case StateType.LOGIN:
               return new LoginStateView();
            case StateType.MAIN:
               return new HallStateView();
            case StateType.ROOM_LOADING:
               return new RoomLoadingState();
            case StateType.ENCOUNTER_LOADING:
               return new EncounterLoadingState();
            case StateType.SINGLEBATTLE_MATCHING:
               return new SingleBattleMatchState();
            case StateType.CAMP_BATTLE_LOADING:
               return new CampBattleLoadingState();
            case StateType.AUCTION:
               return new AuctionHouseController();
            case StateType.TOFFLIST:
               return new TofflistController();
            case StateType.CONSORTIA:
               return new ConsortionControl();
            case StateType.FARM:
               return new FarmSwitchView();
            case StateType.DDTCHURCH_ROOM_LIST:
               return new ChurchRoomListController();
            case StateType.CHURCH_ROOM:
               return new ChurchRoomController();
            case StateType.SHOP:
               return new ShopController();
            case StateType.MATCH_ROOM:
               return new MatchRoomState();
            case StateType.DUNGEON_ROOM:
               return new DungeonRoomState();
            case StateType.CHALLENGE_ROOM:
               return new ChallengeRoomState();
            case StateType.TRAINER1:
            case StateType.TRAINER2:
               return new TrainerGameView();
            case StateType.MISSION_ROOM:
               return new MissionRoomState();
            case StateType.FIGHTING:
               return new GameView();
            case StateType.CIVIL:
               return new CivilController();
            case StateType.FRESHMAN_ROOM1:
            case StateType.FRESHMAN_ROOM2:
               return new FreshmanRoomState();
            case StateType.ACADEMY_REGISTRATION:
               return new AcademyController();
            case StateType.FIGHT_LIB:
               return new FightLibState();
            case StateType.FIGHT_LIB_GAMEVIEW:
               return new FightLibGameView();
            case StateType.LITTLEHALL:
               return new LittleHall();
            case StateType.LITTLEGAME:
               return new LittleGame();
            case StateType.WORLDBOSS_ROOM:
               return WorldBossRoomController.Instance;
            case StateType.WORLDBOSS_AWARD:
               return new WorldBossAwardController();
            case StateType.WORLDBOSS_FIGHT_ROOM:
               return new WorldBossFightRoomState();
            case StateType.CONSORTIA_BATTLE_SCENE:
               return new ConsortiaBattleMainView();
            case StateType.LOTTERY_HALL:
               return new LotteryContorller();
            case StateType.LOTTERY_CARD:
               return new CardLotteryContorller();
            case StateType.DICE_SYSTEM:
               return new DiceSystem();
            case StateType.TREASURE:
               return new TreasureMain();
            case StateType.FIGHTFOOTBALLTIME:
               return new FightFootballTimeLoadingState();
            case StateType.PYRAMID:
               return new PyramidSystem();
            case StateType.CAMP_BATTLE_SCENE:
               return new CampBattleView();
            case StateType.SEVEN_DOUBLE_SCENE:
               return new SevenDoubleMainView();
            case StateType.CHRISTMAS_ROOM:
               return ChristmasRoomController.Instance;
            case StateType.ESCORT:
               return new EscortMainView();
            case StateType.COLLECTION_TASK_SCENE:
               return new CollectionTaskMainView();
            case StateType.DRGN_BOAT:
               return new DrgnBoatMainView();
            case StateType.SUPER_WINNER:
               return SuperWinnerController.instance;
            case StateType.LIGHTROAD_WINDOW:
               return LightRoadController.Instance;
            case StateType.BOGU_ADVENTURE:
               return new BoguAdventureStateView();
            case StateType.MAGPIEBRIDGE:
               return new MagPieBridgeView();
            case StateType.CATCH_INSECT:
               return new CatchInsectRoomController();
            default:
               return null;
         }
      }
      
      public function createAsync(type:String, callback:Function, mapID:int = 0) : void
      {
         var i:int = 0;
         var stateLoadingInfo:StateLoadingInfo = this.getStateLoadingInfo(type,this.getNeededUIModuleByType(type),callback);
         this._currentStateType = type;
         if(stateLoadingInfo.isComplete)
         {
            callback(this.create(type,mapID));
         }
         else
         {
            UIModuleSmallLoading.Instance.progress = 0;
            UIModuleSmallLoading.Instance.show();
            UIModuleSmallLoading.Instance.addEventListener(Event.CLOSE,this.__onCloseLoading);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__onUimoduleLoadComplete);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__onUimoduleLoadProgress);
            for(i = 0; i < stateLoadingInfo.neededUIModule.length; i++)
            {
               UIModuleLoader.Instance.addUIModuleImp(stateLoadingInfo.neededUIModule[i],type);
            }
         }
      }
      
      private function __onCloseLoading(event:Event) : void
      {
         if(PlayerManager.Instance.Self.Grade >= 2)
         {
            UIModuleSmallLoading.Instance.hide();
            UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__onCloseLoading);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__onUimoduleLoadComplete);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__onUimoduleLoadProgress);
            if(this._currentStateType == StateType.WORLDBOSS_FIGHT_ROOM)
            {
               WorldBossManager.Instance.dispatchEvent(new WorldBossRoomEvent(WorldBossRoomEvent.STOPFIGHT));
            }
         }
      }
      
      private function getStateLoadingInfo(type:String, needUIModule:String = null, callBack:Function = null) : StateLoadingInfo
      {
         var stateLoadingInfo:StateLoadingInfo = null;
         var modules:Array = null;
         var i:int = 0;
         stateLoadingInfo = this._state[type];
         if(stateLoadingInfo == null)
         {
            stateLoadingInfo = new StateLoadingInfo();
            if(needUIModule != null && needUIModule != "")
            {
               modules = needUIModule.split(",");
               for(i = 0; i < modules.length; i++)
               {
                  stateLoadingInfo.neededUIModule.push(modules[i]);
               }
            }
            else
            {
               stateLoadingInfo.isComplete = true;
            }
            stateLoadingInfo.state = type;
            stateLoadingInfo.callBack = callBack;
            this._state[type] = stateLoadingInfo;
         }
         return stateLoadingInfo;
      }
      
      private function __onUimoduleLoadComplete(event:UIModuleEvent) : void
      {
         var state:BaseStateView = null;
         if(StringUtils.isEmpty(event.state))
         {
            return;
         }
         var stateLoadingInfo:StateLoadingInfo = this.getStateLoadingInfo(event.state);
         if(stateLoadingInfo.completeedUIModule.indexOf(event.module) == -1)
         {
            stateLoadingInfo.completeedUIModule.push(event.module);
         }
         var allComplete:Boolean = true;
         for(var i:int = 0; i < stateLoadingInfo.neededUIModule.length; i++)
         {
            if(stateLoadingInfo.completeedUIModule.indexOf(stateLoadingInfo.neededUIModule[i]) == -1)
            {
               allComplete = false;
            }
         }
         stateLoadingInfo.isComplete = allComplete;
         if(stateLoadingInfo.isComplete && this._currentStateType == stateLoadingInfo.state)
         {
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__onUimoduleLoadComplete);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__onUimoduleLoadProgress);
            UIModuleSmallLoading.Instance.hide();
            state = this.create(event.state);
            if(stateLoadingInfo.callBack != null)
            {
               stateLoadingInfo.callBack(state);
            }
         }
      }
      
      private function __onUimoduleLoadError(event:UIModuleEvent) : void
      {
      }
      
      private function __onUimoduleLoadProgress(event:UIModuleEvent) : void
      {
         var loadingInfo:StateLoadingInfo = null;
         var stateLoadingInfo:StateLoadingInfo = null;
         var progress:int = 0;
         var i:int = 0;
         var moduleProgress:Number = NaN;
         for each(loadingInfo in this._state)
         {
            if(loadingInfo.neededUIModule.indexOf(event.module) != -1)
            {
               loadingInfo.progress[event.module] = event.loader.progress;
            }
         }
         stateLoadingInfo = this.getStateLoadingInfo(event.state);
         progress = 0;
         for(i = 0; i < stateLoadingInfo.neededUIModule.length; i++)
         {
            if(stateLoadingInfo.progress[stateLoadingInfo.neededUIModule[i]] != null)
            {
               moduleProgress = Number(stateLoadingInfo.progress[stateLoadingInfo.neededUIModule[i]]);
               progress += moduleProgress * 100 / stateLoadingInfo.neededUIModule.length;
            }
         }
         if(this._currentStateType == stateLoadingInfo.state)
         {
            UIModuleSmallLoading.Instance.progress = progress;
         }
      }
      
      public function getNeededUIModuleByType(type:String) : String
      {
         var extraType:String = null;
         if(type == StateType.MAIN)
         {
            return UIModuleTypes.DDTCHURCH_ROOM_LIST;
         }
         if(type == StateType.TOFFLIST)
         {
            return UIModuleTypes.TOFFLIST;
         }
         if(type == StateType.SUPER_WINNER)
         {
            return UIModuleTypes.SUPER_WINNER;
         }
         if(type == StateType.AUCTION)
         {
            return UIModuleTypes.DDTAUCTION + "," + UIModuleTypes.DDTBEAD;
         }
         if(type == StateType.FARM)
         {
            return UIModuleTypes.FARM + "," + UIModuleTypes.CHAT_BALL;
         }
         if(type == StateType.CONSORTIA)
         {
            return UIModuleTypes.CONSORTIAII + "," + UIModuleTypes.DDTCONSORTIA + "," + UIModuleTypes.DDTBEAD;
         }
         if(type == StateType.SHOP)
         {
            return UIModuleTypes.DDTSHOP;
         }
         if(type == StateType.ROOM_LIST || type == StateType.DUNGEON_LIST || type == StateType.FRESHMAN_ROOM1 || type == StateType.WORLDBOSS_FIGHT_ROOM)
         {
            return UIModuleTypes.DDTROOM + "," + UIModuleTypes.DDTROOMLIST + "," + UIModuleTypes.CHAT_BALL + "," + UIModuleTypes.GAME + "," + UIModuleTypes.DEFAULT_LIVING + "," + UIModuleTypes.GAMEII + "," + UIModuleTypes.GAMEIII + "," + UIModuleTypes.EXPRESSION + "," + UIModuleTypes.DDTROOMLOADING + "," + UIModuleTypes.GAMEOVER;
         }
         if(type == StateType.FRESHMAN_ROOM2)
         {
            return UIModuleTypes.DDTROOMLOADING + "," + UIModuleTypes.GAMEIII;
         }
         if(type == StateType.MATCH_ROOM || type == StateType.DUNGEON_ROOM || type == StateType.MISSION_ROOM)
         {
            return UIModuleTypes.DDTROOM + "," + UIModuleTypes.EXPRESSION + "," + UIModuleTypes.CHAT_BALL + "," + UIModuleTypes.GAME + "," + UIModuleTypes.DEFAULT_LIVING + "," + UIModuleTypes.GAMEII + "," + UIModuleTypes.GAMEIII + "," + UIModuleTypes.DDTROOMLOADING + "," + UIModuleTypes.GAMEOVER;
         }
         if(type == StateType.CHALLENGE_ROOM)
         {
            return UIModuleTypes.DDTROOM + "," + UIModuleTypes.EXPRESSION + "," + UIModuleTypes.CHAT_BALL + "," + UIModuleTypes.GAME + "," + UIModuleTypes.DEFAULT_LIVING + "," + UIModuleTypes.GAMEII + "," + UIModuleTypes.GAMEIII + "," + UIModuleTypes.DDTROOMLOADING;
         }
         if(type == StateType.DDTCHURCH_ROOM_LIST)
         {
            return UIModuleTypes.DDTCHURCH_ROOM_LIST;
         }
         if(type == StateType.CHURCH_ROOM)
         {
            return UIModuleTypes.CHURCH_ROOM + "," + UIModuleTypes.CHAT_BALL + "," + UIModuleTypes.EXPRESSION;
         }
         if(type == StateType.CIVIL)
         {
            return UIModuleTypes.DDTCIVIL;
         }
         if(type == StateType.HOT_SPRING_ROOM_LIST)
         {
            return UIModuleTypes.DDT_HOT_SPRING_ROOM_LIST;
         }
         if(type == StateType.HOT_SPRING_ROOM)
         {
            return UIModuleTypes.HOT_SPRING_ROOM + "," + UIModuleTypes.EXPRESSION;
         }
         if(type == StateType.FIGHTING)
         {
            extraType = "";
            if(RoomManager.Instance.current.type == RoomInfo.RESCUE)
            {
               extraType += "," + UIModuleTypes.RESCUE;
            }
            return UIModuleTypes.GAME + "," + UIModuleTypes.DEFAULT_LIVING + "," + UIModuleTypes.GAMEII + "," + UIModuleTypes.GAMEIII + "," + UIModuleTypes.GAMEOVER + "," + UIModuleTypes.CHAT_BALL + extraType;
         }
         if(type == StateType.TRAINER1)
         {
            return UIModuleTypes.GAME + "," + UIModuleTypes.DEFAULT_LIVING + "," + UIModuleTypes.GAMEII + "," + UIModuleTypes.GAMEIII + "," + UIModuleTypes.GAMEOVER + "," + UIModuleTypes.DDTROOMLOADING + "," + UIModuleTypes.CHAT_BALL;
         }
         if(type == StateType.TRAINER2)
         {
            return UIModuleTypes.GAMEIII + "," + UIModuleTypes.DDTROOMLOADING + "," + UIModuleTypes.CHAT_BALL;
         }
         if(type == StateType.ACADEMY_REGISTRATION)
         {
            return UIModuleTypes.DDTACADEMY;
         }
         if(type == StateType.FIGHT_LIB)
         {
            return UIModuleTypes.GAMEIII + "," + UIModuleTypes.DDTROOMLOADING + "," + UIModuleTypes.GAME + "," + UIModuleTypes.DEFAULT_LIVING + "," + UIModuleTypes.GAMEII + "," + UIModuleTypes.FIGHT_LIB + "," + UIModuleTypes.CHAT_BALL + "," + UIModuleTypes.DDTROOM;
         }
         if(type == StateType.LITTLEHALL)
         {
            return UIModuleTypes.DDTSHOP + "," + UIModuleTypes.DDT_LITTLEGAME + "," + UIModuleTypes.EXPRESSION;
         }
         if(type == StateType.WORLDBOSS_AWARD)
         {
            return UIModuleTypes.WORLDBOSS_MAP + "," + UIModuleTypes.DDTSHOP + "," + UIModuleTypes.DDT_LITTLEGAME;
         }
         if(type == StateType.WORLDBOSS_ROOM || type == StateType.CHRISTMAS_ROOM || type == StateType.CATCH_INSECT)
         {
            return UIModuleTypes.WORLDBOSS_MAP + "," + UIModuleTypes.DDTROOM + "," + UIModuleTypes.DDTROOMLIST + "," + UIModuleTypes.CHAT_BALL + "," + UIModuleTypes.GAME + "," + UIModuleTypes.DEFAULT_LIVING + "," + UIModuleTypes.GAMEII + "," + UIModuleTypes.GAMEIII + "," + UIModuleTypes.EXPRESSION + "," + UIModuleTypes.DDTROOMLOADING + "," + UIModuleTypes.GAMEOVER;
         }
         if(type == StateType.ROOM_LOADING || type == StateType.ENCOUNTER_LOADING || type == StateType.CAMP_BATTLE_LOADING || type == StateType.SINGLEBATTLE_MATCHING || type == StateType.FIGHTFOOTBALLTIME)
         {
            return UIModuleTypes.DDTROOM + "," + UIModuleTypes.CHAT_BALL + "," + UIModuleTypes.GAME + "," + UIModuleTypes.DEFAULT_LIVING + "," + UIModuleTypes.GAMEII + "," + UIModuleTypes.GAMEIII + "," + UIModuleTypes.EXPRESSION + "," + UIModuleTypes.DDTROOMLOADING + "," + UIModuleTypes.GAMEOVER;
         }
         if(type == StateType.ROOM_LOADING)
         {
            return UIModuleTypes.DDTROOM + "," + UIModuleTypes.CHAT_BALL + "," + UIModuleTypes.GAME + "," + UIModuleTypes.DEFAULT_LIVING + "," + UIModuleTypes.GAMEII + "," + UIModuleTypes.GAMEIII + "," + UIModuleTypes.EXPRESSION + "," + UIModuleTypes.DDTROOMLOADING + "," + UIModuleTypes.GAMEOVER;
         }
         if(type == StateType.LOTTERY_HALL)
         {
            return UIModuleTypes.LOTTERY;
         }
         if(type == StateType.CONSORTIA_BATTLE_SCENE)
         {
            return UIModuleTypes.CONSORTIA_BATTLE;
         }
         if(type == StateType.CAMP_BATTLE_SCENE)
         {
            return UIModuleTypes.CAMP_BATTLE_SCENE + "," + UIModuleTypes.GAME + "," + UIModuleTypes.CHAT_BALL + "," + UIModuleTypes.DEFAULT_LIVING + "," + UIModuleTypes.CONSORTIA_BATTLE + "," + UIModuleTypes.DDTCONSORTIA;
         }
         if(type == StateType.PYRAMID)
         {
            return UIModuleTypes.PYRAMID + "," + UIModuleTypes.DDTSHOP;
         }
         if(type == StateType.SEVEN_DOUBLE_SCENE)
         {
            return UIModuleTypes.SEVEN_DOUBLE_GAME;
         }
         if(type == StateType.ESCORT)
         {
            return UIModuleTypes.ESCORT_GAME;
         }
         if(type == StateType.COLLECTION_TASK_SCENE)
         {
            return UIModuleTypes.COLLECTION_TASK + "," + UIModuleTypes.CHAT_BALL;
         }
         if(type == StateType.DRGN_BOAT)
         {
            return UIModuleTypes.DRGN_BOAT_GAME + "," + UIModuleTypes.CHAT_BALL;
         }
         if(type == StateType.BOGU_ADVENTURE)
         {
            return UIModuleTypes.BOGU_ADVENTURE + "," + UIModuleTypes.CHAT_BALL + "," + UIModuleTypes.DEFAULT_LIVING;
         }
         if(type == StateType.MAGPIEBRIDGE)
         {
            return UIModuleTypes.MAGPIE_BRIDGE + "," + UIModuleTypes.DDT_BURIED;
         }
         return "";
      }
   }
}

