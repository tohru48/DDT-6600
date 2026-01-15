package collectionTask.vo
{
   import ddt.data.player.PlayerInfo;
   import ddt.view.sceneCharacter.SceneCharacterDirection;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import flash.geom.Point;
   
   public class PlayerVO extends EventDispatcher
   {
      
      private var _playerInfo:PlayerInfo;
      
      private var _playerPos:Point;
      
      private var _playerMoveSpeed:Number = 0.15;
      
      private var _sceneCharacterDirection:SceneCharacterDirection;
      
      private var _playerDirection:int = 3;
      
      private var _walkPath:Array = [];
      
      public var currentWalkStartPoint:Point;
      
      private var _isRobert:Boolean;
      
      public function PlayerVO(target:IEventDispatcher = null)
      {
         super(target);
         this._sceneCharacterDirection = SceneCharacterDirection.RB;
      }
      
      public function get scenePlayerDirection() : SceneCharacterDirection
      {
         if(!this._sceneCharacterDirection)
         {
            this._sceneCharacterDirection = SceneCharacterDirection.RB;
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
      
      public function get playerPos() : Point
      {
         return this._playerPos;
      }
      
      public function set playerPos(value:Point) : void
      {
         this._playerPos = value;
      }
      
      public function get playerMoveSpeed() : Number
      {
         return this._playerMoveSpeed;
      }
      
      public function set playerMoveSpeed(value:Number) : void
      {
         this._playerMoveSpeed = value;
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
      
      public function get isRobert() : Boolean
      {
         return this._isRobert;
      }
      
      public function set isRobert(value:Boolean) : void
      {
         this._isRobert = value;
      }
   }
}

