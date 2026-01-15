package catchInsect
{
   import catchInsect.data.InsectInfo;
   import catchInsect.event.InsectEvent;
   import catchInsect.player.CatchInsectMonster;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.GameInSocketOut;
   import flash.events.EventDispatcher;
   import room.RoomManager;
   import room.model.RoomInfo;
   
   public class CatchInsectMonsterManager extends EventDispatcher
   {
      
      private static var _instance:CatchInsectMonsterManager;
      
      private var _monsterInfo:InsectInfo;
      
      public var isFighting:Boolean = false;
      
      private var _activeState:Boolean = false;
      
      public var curMonster:CatchInsectMonster;
      
      public function CatchInsectMonsterManager()
      {
         super();
      }
      
      public static function get Instance() : CatchInsectMonsterManager
      {
         if(_instance == null)
         {
            _instance = new CatchInsectMonsterManager();
         }
         return _instance;
      }
      
      public function set ActiveState(value:Boolean) : void
      {
         this._activeState = value;
         CatchInsectMonsterManager.Instance.dispatchEvent(new InsectEvent(InsectEvent.MONSTER_ACTIVE_START,value));
      }
      
      public function setupFightEvent() : void
      {
         RoomManager.Instance.addEventListener(CrazyTankSocketEvent.GAME_ROOM_CREATE,this.__gameStart);
      }
      
      private function __gameStart(pEvent:CrazyTankSocketEvent) : void
      {
         RoomManager.Instance.removeEventListener(CrazyTankSocketEvent.GAME_ROOM_CREATE,this.__gameStart);
         if(Boolean(this._monsterInfo))
         {
            GameInSocketOut.sendGameRoomSetUp(this._monsterInfo.MissionID,RoomInfo.CATCH_INSECT_ROOM,false,"","",3,0,0,false,this._monsterInfo.MissionID);
            CatchInsectMonsterManager.Instance.curMonster = null;
            GameInSocketOut.sendGameStart();
         }
      }
      
      public function removeFightEvent() : void
      {
         RoomManager.Instance.removeEventListener(CrazyTankSocketEvent.GAME_ROOM_CREATE,this.__gameStart);
      }
      
      public function get ActiveState() : Boolean
      {
         return this._activeState;
      }
      
      public function set CurrentMonster(value:InsectInfo) : void
      {
         this._monsterInfo = value;
      }
   }
}

