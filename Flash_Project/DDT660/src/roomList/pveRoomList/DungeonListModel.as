package roomList.pveRoomList
{
   import ddt.data.player.PlayerInfo;
   import ddt.manager.PlayerManager;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import road7th.data.DictionaryData;
   import room.model.RoomInfo;
   import roomList.pvpRoomList.RoomListController;
   
   public class DungeonListModel extends EventDispatcher
   {
      
      public static const ROOMSHOWMODE_CHANGE:String = "roomshowmodechange";
      
      public static const DUNGEON_LIST_UPDATE:String = "DungeonListUpdate";
      
      private var _roomList:DictionaryData;
      
      private var _playerlist:DictionaryData;
      
      private var _self:PlayerInfo;
      
      private var _roomTotal:int;
      
      private var _roomShowMode:int;
      
      private var _temListArray:Array;
      
      private var _isAddEnd:Boolean;
      
      public function DungeonListModel()
      {
         super();
         this._roomList = new DictionaryData(true);
         this._playerlist = new DictionaryData(true);
         this._self = PlayerManager.Instance.Self;
         this._roomShowMode = 1;
      }
      
      public function getSelfPlayerInfo() : PlayerInfo
      {
         return this._self;
      }
      
      public function get isAddEnd() : Boolean
      {
         return this._isAddEnd;
      }
      
      public function updateRoom(arr:Array) : void
      {
         this._roomList.clear();
         this._isAddEnd = false;
         if(arr.length == 0)
         {
            return;
         }
         arr = RoomListController.disorder(arr);
         for(var i:int = 0; i < arr.length; i++)
         {
            if(i == arr.length - 1)
            {
               this._isAddEnd = true;
            }
            this._roomList.add((arr[i] as RoomInfo).ID,arr[i] as RoomInfo);
         }
         dispatchEvent(new Event(DUNGEON_LIST_UPDATE));
      }
      
      public function set roomTotal(value:int) : void
      {
         this._roomTotal = value;
      }
      
      public function get roomTotal() : int
      {
         return this._roomTotal;
      }
      
      public function getRoomById(id:int) : RoomInfo
      {
         return this._roomList[id];
      }
      
      public function getRoomList() : DictionaryData
      {
         return this._roomList;
      }
      
      public function addWaitingPlayer(info:PlayerInfo) : void
      {
         this._playerlist.add(info.ID,info);
      }
      
      public function removeWaitingPlayer(id:int) : void
      {
         this._playerlist.remove(id);
      }
      
      public function getPlayerList() : DictionaryData
      {
         return this._playerlist;
      }
      
      public function get roomShowMode() : int
      {
         return this._roomShowMode;
      }
      
      public function set roomShowMode(value:int) : void
      {
         this._roomShowMode = value;
         dispatchEvent(new Event(ROOMSHOWMODE_CHANGE));
      }
      
      public function dispose() : void
      {
         this._roomList = null;
         this._playerlist = null;
         this._self = null;
      }
   }
}

