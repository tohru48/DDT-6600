package church.model
{
   import church.events.WeddingRoomEvent;
   import church.vo.PlayerVO;
   import flash.events.EventDispatcher;
   import road7th.data.DictionaryData;
   
   public class ChurchRoomModel extends EventDispatcher
   {
      
      private var _players:DictionaryData;
      
      private var _playerNameVisible:Boolean = true;
      
      private var _playerChatBallVisible:Boolean = true;
      
      private var _playerFireVisible:Boolean = true;
      
      private var _fireEnable:Boolean;
      
      private var _fireTemplateIDList:Array = [21002,21006];
      
      public function ChurchRoomModel()
      {
         super();
         this._players = new DictionaryData(true);
      }
      
      public function get players() : DictionaryData
      {
         return this._players;
      }
      
      public function addPlayer(player:PlayerVO) : void
      {
         this._players.add(player.playerInfo.ID,player);
      }
      
      public function removePlayer(id:int) : void
      {
         this._players.remove(id);
      }
      
      public function getPlayers() : DictionaryData
      {
         return this._players;
      }
      
      public function getPlayerFromID(id:int) : PlayerVO
      {
         return this._players[id];
      }
      
      public function reset() : void
      {
         this.dispose();
         this._players = new DictionaryData(true);
      }
      
      public function get playerNameVisible() : Boolean
      {
         return this._playerNameVisible;
      }
      
      public function set playerNameVisible(value:Boolean) : void
      {
         this._playerNameVisible = value;
         dispatchEvent(new WeddingRoomEvent(WeddingRoomEvent.PLAYER_NAME_VISIBLE));
      }
      
      public function get playerChatBallVisible() : Boolean
      {
         return this._playerChatBallVisible;
      }
      
      public function set playerChatBallVisible(value:Boolean) : void
      {
         this._playerChatBallVisible = value;
         dispatchEvent(new WeddingRoomEvent(WeddingRoomEvent.PLAYER_CHATBALL_VISIBLE));
      }
      
      public function set playerFireVisible(value:Boolean) : void
      {
         this._playerFireVisible = value;
      }
      
      public function get playerFireVisible() : Boolean
      {
         return this._playerFireVisible;
      }
      
      public function set fireEnable(value:Boolean) : void
      {
         this._fireEnable = value;
         dispatchEvent(new WeddingRoomEvent(WeddingRoomEvent.ROOM_FIRE_ENABLE_CHANGE));
      }
      
      public function get fireEnable() : Boolean
      {
         return this._fireEnable;
      }
      
      public function get fireTemplateIDList() : Array
      {
         return this._fireTemplateIDList;
      }
      
      public function dispose() : void
      {
         this._players = null;
      }
   }
}

