package worldboss.model
{
   import flash.events.EventDispatcher;
   import flash.geom.Point;
   import flash.utils.setTimeout;
   import road7th.data.DictionaryData;
   import worldboss.event.WorldBossRoomEvent;
   import worldboss.player.PlayerVO;
   
   public class WorldBossRoomModel extends EventDispatcher
   {
      
      private var _players:DictionaryData;
      
      private var _playersBuffer:Array;
      
      private var _playerNameVisible:Boolean = true;
      
      private var _playerChatBallVisible:Boolean = true;
      
      private var _playerFireVisible:Boolean = true;
      
      public function WorldBossRoomModel()
      {
         super();
         this._players = new DictionaryData(true);
         this._playersBuffer = new Array();
      }
      
      public function get players() : DictionaryData
      {
         return this._players;
      }
      
      public function addPlayer(player:PlayerVO) : void
      {
         this._playersBuffer.push(player);
         setTimeout(this.addPlayerToMap,500 + this._playersBuffer.length * 200);
      }
      
      private function addPlayerToMap() : void
      {
         if(!this._players || !this._playersBuffer[0])
         {
            return;
         }
         this._players.add(this._playersBuffer[0].playerInfo.ID,this._playersBuffer[0]);
         this._playersBuffer.shift();
      }
      
      public function updatePlayerStauts(id:int, status:int, point:Point) : void
      {
         var i:int = 0;
         var playerVO:PlayerVO = null;
         if(Boolean(this._playersBuffer) && this._playersBuffer.length > 0)
         {
            for(i = 0; i < this._playersBuffer.length; i++)
            {
               if(id == this._playersBuffer[i].playerInfo.ID)
               {
                  playerVO = this._playersBuffer[i] as PlayerVO;
                  playerVO.playerStauts = status;
                  playerVO.playerPos = point;
                  return;
               }
            }
         }
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
         dispatchEvent(new WorldBossRoomEvent(WorldBossRoomEvent.PLAYER_NAME_VISIBLE));
      }
      
      public function dispose() : void
      {
         this._players = null;
         this._playersBuffer = null;
      }
   }
}

