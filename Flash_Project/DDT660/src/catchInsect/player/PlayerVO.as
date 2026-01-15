package catchInsect.player
{
   import catchInsect.event.CatchInsectRoomEvent;
   import ddt.data.player.PlayerInfo;
   import ddt.view.sceneCharacter.SceneCharacterDirection;
   import flash.events.EventDispatcher;
   import flash.geom.Point;
   
   public class PlayerVO extends EventDispatcher
   {
      
      private var _playerPos:Point;
      
      private var _playerInfo:PlayerInfo;
      
      private var _walkPath:Array = [];
      
      private var _sceneCharacterDirection:SceneCharacterDirection = SceneCharacterDirection.RT;
      
      private var _playerDirection:int = 3;
      
      private var _playerMoveSpeed:Number = 0.15;
      
      public var currentWalkStartPoint:Point;
      
      private var _playerStauts:int = 0;
      
      public function PlayerVO()
      {
         super();
      }
      
      public function set playerStauts(value:int) : void
      {
         this._playerStauts = value;
      }
      
      public function get playerStauts() : int
      {
         return this._playerStauts;
      }
      
      public function get playerPos() : Point
      {
         return this._playerPos;
      }
      
      public function set playerPos(value:Point) : void
      {
         this._playerPos = value;
         if(Boolean(this._playerInfo))
         {
            dispatchEvent(new CatchInsectRoomEvent(CatchInsectRoomEvent.PLAYER_POS_CHANGE,null,this._playerInfo.ID));
         }
      }
      
      public function get playerInfo() : PlayerInfo
      {
         return this._playerInfo;
      }
      
      public function set playerInfo(value:PlayerInfo) : void
      {
         this._playerInfo = value;
      }
      
      public function get walkPath() : Array
      {
         return this._walkPath;
      }
      
      public function set walkPath(value:Array) : void
      {
         this._walkPath = value;
      }
      
      public function get scenePlayerDirection() : SceneCharacterDirection
      {
         if(!this._sceneCharacterDirection)
         {
            this._sceneCharacterDirection = SceneCharacterDirection.RT;
         }
         return this._sceneCharacterDirection;
      }
      
      public function set scenePlayerDirection(value:SceneCharacterDirection) : void
      {
         this._sceneCharacterDirection = value;
         switch(this._sceneCharacterDirection)
         {
            case SceneCharacterDirection.RT:
               this._playerDirection = 1;
               break;
            case SceneCharacterDirection.LT:
               this._playerDirection = 2;
               break;
            case SceneCharacterDirection.RB:
               this._playerDirection = 3;
               break;
            case SceneCharacterDirection.LB:
               this._playerDirection = 4;
         }
      }
      
      public function get playerDirection() : int
      {
         return this._playerDirection;
      }
      
      public function set playerDirection(value:int) : void
      {
         this._playerDirection = value;
         switch(this._playerDirection)
         {
            case 1:
               this._sceneCharacterDirection = SceneCharacterDirection.RT;
               break;
            case 2:
               this._sceneCharacterDirection = SceneCharacterDirection.LT;
               break;
            case 3:
               this._sceneCharacterDirection = SceneCharacterDirection.RB;
               break;
            case 4:
               this._sceneCharacterDirection = SceneCharacterDirection.LB;
         }
      }
      
      public function get playerMoveSpeed() : Number
      {
         return this._playerMoveSpeed;
      }
      
      public function set playerMoveSpeed(value:Number) : void
      {
         if(this._playerMoveSpeed == value)
         {
            return;
         }
         this._playerMoveSpeed = value;
         dispatchEvent(new CatchInsectRoomEvent(CatchInsectRoomEvent.PLAYER_MOVE_SPEED_CHANGE,null,this._playerInfo.ID));
      }
      
      public function clone() : PlayerVO
      {
         var playerVO:PlayerVO = new PlayerVO();
         playerVO.playerInfo = this._playerInfo;
         playerVO.playerPos = this._playerPos;
         playerVO.walkPath = this._walkPath;
         playerVO.playerDirection = this._playerDirection;
         playerVO.playerMoveSpeed = this._playerMoveSpeed;
         return playerVO;
      }
      
      public function dispose() : void
      {
         while(Boolean(this._walkPath) && this._walkPath.length > 0)
         {
            this._walkPath.shift();
         }
         this._walkPath = null;
         this._playerPos = null;
         this._sceneCharacterDirection = null;
      }
   }
}

