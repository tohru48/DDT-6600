package ddt.manager
{
   import bombKing.BombKingManager;
   import campbattle.view.CampBattleView;
   import catchbeast.CatchBeastManager;
   import com.pickgliss.loader.LoaderSavingManager;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.ShowTipManager;
   import cryptBoss.CryptBossManager;
   import ddt.states.BaseStateView;
   import ddt.states.FadingBlock;
   import ddt.states.IStateCreator;
   import ddt.states.StateType;
   import ddt.utils.MenoryUtil;
   import ddt.view.chat.ChatBugleView;
   import email.manager.MailManager;
   import farm.FarmModelController;
   import flash.display.Sprite;
   import flash.display.Stage;
   import flash.utils.Dictionary;
   import ringStation.RingStationManager;
   import room.model.RoomInfo;
   import roomList.pveRoomList.DungeonListController;
   import roomList.pvpRoomList.RoomListController;
   
   public class StateManager
   {
      
      private static var dic:Dictionary;
      
      private static var root:Sprite;
      
      private static var current:BaseStateView;
      
      private static var next:BaseStateView;
      
      private static var _currentStateType:String;
      
      private static var _stage:Stage;
      
      private static var fadingBlock:FadingBlock;
      
      private static var _creator:IStateCreator;
      
      private static var _data:Object;
      
      private static var _enterType:String;
      
      public static var isOpenRoomList:Boolean;
      
      public static var isOpenDungeonList:Boolean;
      
      public static var getInGame_Step_1:Boolean = false;
      
      public static var getInGame_Step_2:Boolean = false;
      
      public static var getInGame_Step_3:Boolean = false;
      
      public static var getInGame_Step_4:Boolean = false;
      
      public static var getInGame_Step_5:Boolean = false;
      
      public static var getInGame_Step_6:Boolean = false;
      
      public static var getInGame_Step_7:Boolean = false;
      
      public static var getInGame_Step_8:Boolean = false;
      
      public static var alertFuncVec:Vector.<Function> = new Vector.<Function>();
      
      public static var isShowFadingAnimation:Boolean = true;
      
      public function StateManager()
      {
         super();
      }
      
      public static function get currentStateType() : String
      {
         return _currentStateType;
      }
      
      public static function set currentStateType(value:String) : void
      {
         _currentStateType = value;
      }
      
      public static function get nextState() : BaseStateView
      {
         return next;
      }
      
      public static function setup(parent:Sprite, creator:IStateCreator) : void
      {
         dic = new Dictionary();
         root = parent;
         _creator = creator;
         fadingBlock = new FadingBlock(addNextToStage,showLoading);
      }
      
      public static function setState(type:String = "default", data:Object = null, mapId:int = 0) : void
      {
         if(type == StateType.ROOM_LIST)
         {
            isOpenRoomList = true;
            type = StateType.MAIN;
            currentStateType = type;
         }
         if(type == StateType.DUNGEON_LIST)
         {
            isOpenDungeonList = true;
            type = StateType.MAIN;
            currentStateType = type;
         }
         var next:BaseStateView = getState(type);
         if(type == StateType.ROOM_LIST && current.getType() == StateType.MATCH_ROOM)
         {
            if(getInGame_Step_1 && getInGame_Step_2)
            {
               if(getInGame_Step_3 && !getInGame_Step_4)
               {
                  SocketManager.Instance.out.sendErrorMsg("房间类型：" + type + "游戏步骤进行到3之后停止了");
               }
               else if(getInGame_Step_4 && !getInGame_Step_5)
               {
                  SocketManager.Instance.out.sendErrorMsg("房间类型：" + type + "游戏步骤进行到4之后停止了");
               }
               else if(getInGame_Step_5 && !getInGame_Step_6)
               {
                  SocketManager.Instance.out.sendErrorMsg("房间类型：" + type + "游戏步骤进行到5之后停止了");
               }
               else if(getInGame_Step_6 && !getInGame_Step_7)
               {
                  SocketManager.Instance.out.sendErrorMsg("房间类型：" + type + "游戏步骤进行到6之后停止了");
               }
               else if(getInGame_Step_7 && !getInGame_Step_8)
               {
                  SocketManager.Instance.out.sendErrorMsg("房间类型：" + type + "游戏步骤进行到7之后停止了");
               }
               getInGame_Step_1 = getInGame_Step_2 = getInGame_Step_3 = getInGame_Step_4 = getInGame_Step_5 = getInGame_Step_6 = getInGame_Step_7 = getInGame_Step_8 = false;
            }
         }
         _data = data;
         _enterType = type;
         if(Boolean(next))
         {
            setStateImp(next,mapId);
         }
         else
         {
            createStateAsync(type,createCallbak);
         }
      }
      
      public static function stopImidily() : void
      {
         fadingBlock.stopImidily();
      }
      
      private static function createCallbak(value:BaseStateView) : void
      {
         if(Boolean(value))
         {
            dic[value.getType()] = value;
         }
         setStateImp(value);
      }
      
      private static function setStateImp(value:BaseStateView, id:int = 0) : Boolean
      {
         if(value == null)
         {
            return false;
         }
         if(value.getType() != _enterType)
         {
            return false;
         }
         _enterType = "";
         if(value == current || next == value)
         {
            if(!(value is CampBattleView))
            {
               current.refresh();
               showAlertRoomDungeon();
               return false;
            }
         }
         if(value.check(currentStateType))
         {
            QueueManager.pause();
            next = value;
            if(!next.prepared)
            {
               next.prepare();
            }
            ShowTipManager.Instance.removeAllTip();
            LayerManager.Instance.clearnGameDynamic();
            if(Boolean(current))
            {
               fadingBlock.setNextState(next);
               fadingBlock.update();
            }
            else
            {
               addNextToStage();
            }
            return true;
         }
         return false;
      }
      
      private static function addNextToStage() : void
      {
         QueueManager.resume();
         if(Boolean(current))
         {
            current.leaving(next);
         }
         var last:BaseStateView = current;
         current = next;
         currentStateType = current.getType();
         next = null;
         current.enter(last,_data);
         MenoryUtil.clearMenory();
         root.addChild(current.getView());
         current.addedToStage();
         if(Boolean(last) && (!(last is CampBattleView) || !(current is CampBattleView)))
         {
            if(Boolean(last.getView().parent))
            {
               last.getView().parent.removeChild(last.getView());
            }
            last.removedFromStage();
         }
         if(current.goBack())
         {
            fadingBlock.executed = false;
            back();
         }
         EnthrallManager.getInstance().updateEnthrallView();
         ChatBugleView.instance.updatePos();
         MailManager.Instance.isOpenFromBag = false;
         if(ChurchManager.instance.isUnwedding)
         {
            ChurchManager.instance.isUnwedding = false;
            ChurchManager.instance.openAlert();
         }
         if(!BombKingManager.instance.Recording)
         {
            if(RingStationManager.instance.RoomType == RoomInfo.RING_STATION && currentStateType == StateType.MAIN)
            {
               RingStationManager.instance.show();
            }
            if(CatchBeastManager.instance.RoomType == RoomInfo.CATCH_BEAST && currentStateType == StateType.MAIN)
            {
               CatchBeastManager.instance.show();
            }
            if(CryptBossManager.instance.RoomType == RoomInfo.CRYPTBOSS_ROOM && currentStateType == StateType.MAIN)
            {
               CryptBossManager.instance.show();
            }
            showAlertRoomDungeon();
         }
         if(currentStateType != StateType.MAIN)
         {
            SocketManager.Instance.out.sendPlayerExit(PlayerManager.Instance.Self.ID);
         }
         else if(BombKingManager.instance.Recording)
         {
            BombKingManager.instance.onShow();
            BombKingManager.instance.Recording = false;
         }
      }
      
      private static function showAlertRoomDungeon() : void
      {
         if(isOpenRoomList)
         {
            isOpenRoomList = false;
            RoomListController.instance.enter();
         }
         if(isOpenDungeonList)
         {
            isOpenDungeonList = false;
            if(!FarmModelController.instance.FightPoultryFlag)
            {
               DungeonListController.instance.enter();
            }
            else
            {
               FarmModelController.instance.FightPoultryFlag = false;
            }
         }
      }
      
      private static function showLoading() : void
      {
         if(LoaderSavingManager.hasFileToSave)
         {
         }
      }
      
      public static function back() : void
      {
         var backtype:String = null;
         if(current != null)
         {
            backtype = current.getBackType();
            if(backtype != "")
            {
               setState(backtype);
            }
         }
      }
      
      public static function getState(type:String) : BaseStateView
      {
         return dic[type] as BaseStateView;
      }
      
      public static function createStateAsync(type:String, callbak:Function, mapID:int = 0) : void
      {
         _creator.createAsync(type,callbak,mapID);
      }
      
      public static function isExitGame(type:String) : Boolean
      {
         return type != StateType.FIGHTING && type != StateType.MISSION_ROOM && type != StateType.FIGHT_LIB_GAMEVIEW;
      }
      
      public static function isExitRoom(type:String) : Boolean
      {
         return type != StateType.FIGHTING && type != StateType.MATCH_ROOM && type != StateType.MISSION_ROOM && type != StateType.DUNGEON_ROOM && type != StateType.CHALLENGE_ROOM && type != StateType.ROOM_LOADING && type != StateType.ENCOUNTER_LOADING && type != StateType.FIGHT_LIB && type != StateType.TRAINER1 && type != StateType.TRAINER2 && type != StateType.FIGHT_LIB_GAMEVIEW && type != StateType.CONSORTIA_BATTLE_SCENE && type != StateType.CAMP_BATTLE_SCENE;
      }
      
      public static function isInGame(type:String) : Boolean
      {
         switch(type)
         {
            case StateType.FIGHTING:
            case StateType.TRAINER1:
            case StateType.TRAINER2:
            case StateType.FIGHT_LIB_GAMEVIEW:
               return true;
            default:
               return false;
         }
      }
	  public static var RecordFlag:Boolean;
   }
}

