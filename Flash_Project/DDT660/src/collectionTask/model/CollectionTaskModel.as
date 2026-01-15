package collectionTask.model
{
   import collectionTask.event.CollectionTaskEvent;
   import collectionTask.vo.PlayerVO;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import road7th.data.DictionaryData;
   
   public class CollectionTaskModel extends EventDispatcher
   {
      
      private var _players:DictionaryData = new DictionaryData(true);
      
      private var _playerNameVisible:Boolean = true;
      
      private var _playerChatBallVisible:Boolean = true;
      
      private var _playerVisible:Boolean = true;
      
      public function CollectionTaskModel(target:IEventDispatcher = null)
      {
         super(target);
      }
      
      public function addPlayer(player:PlayerVO) : void
      {
         this._players.add(player.playerInfo.ID,player);
      }
      
      public function removePlayer(id:int) : void
      {
         this._players.remove(id);
      }
      
      public function get playerNameVisible() : Boolean
      {
         return this._playerNameVisible;
      }
      
      public function set playerNameVisible(value:Boolean) : void
      {
         this._playerNameVisible = value;
         dispatchEvent(new CollectionTaskEvent(CollectionTaskEvent.PLAYER_NAME_VISIBLE));
      }
      
      public function get playerChatBallVisible() : Boolean
      {
         return this._playerChatBallVisible;
      }
      
      public function set playerChatBallVisible(value:Boolean) : void
      {
         this._playerChatBallVisible = value;
         dispatchEvent(new CollectionTaskEvent(CollectionTaskEvent.PLAYER_CHATBALL_VISIBLE));
      }
      
      public function set playerVisible(value:Boolean) : void
      {
         this._playerVisible = value;
         dispatchEvent(new CollectionTaskEvent(CollectionTaskEvent.PLAYER_VISIBLE));
      }
      
      public function get playerVisible() : Boolean
      {
         return this._playerVisible;
      }
      
      public function getPlayers() : DictionaryData
      {
         return this._players;
      }
   }
}

