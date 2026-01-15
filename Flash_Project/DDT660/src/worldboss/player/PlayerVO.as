package worldboss.player
{
   import ddt.data.player.PlayerInfo;
   import ddt.view.sceneCharacter.SceneCharacterDirection;
   import flash.events.EventDispatcher;
   import flash.geom.Point;
   import worldboss.event.WorldBossScenePlayerEvent;
   
   public class PlayerVO extends EventDispatcher
   {
      
      private var _playerPos:Point;
      
      private var _playerNickName:String;
      
      private var _playerSex:Boolean;
      
      private var _playerInfo:PlayerInfo;
      
      private var _walkPath:Array = [];
      
      private var _sceneCharacterDirection:SceneCharacterDirection = SceneCharacterDirection.RT;
      
      private var _playerDirection:int = 3;
      
      private var _playerMoveSpeed:Number = 0.15;
      
      private var _reviveCD:int;
      
      private var _buffs:Array = new Array();
      
      public var currentWalkStartPoint:Point;
      
      private var _playerStauts:int = 1;
      
      private var _buffLevel:int = 0;
      
      private var _buffInjure:int = 0;
      
      private var _myDamage:int = 0;
      
      private var _myHonor:int = 0;
      
      public function PlayerVO()
      {
         super();
      }
      
      public function get buffLevel() : int
      {
         return this._buffLevel;
      }
      
      public function set buffLevel(value:int) : void
      {
         this._buffLevel = value;
      }
      
      public function set myDamage(value:int) : void
      {
         this._myDamage = value;
      }
      
      public function get myDamage() : int
      {
         return this._myDamage;
      }
      
      public function set myHonor(value:int) : void
      {
         this._myHonor = value;
      }
      
      public function get myHonor() : int
      {
         return this._myHonor;
      }
      
      public function get buffInjure() : int
      {
         return this._buffInjure;
      }
      
      public function set buffInjure(value:int) : void
      {
         this._buffInjure = value;
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
            dispatchEvent(new WorldBossScenePlayerEvent(WorldBossScenePlayerEvent.PLAYER_POS_CHANGE,this._playerInfo.ID));
         }
      }
      
      public function get reviveCD() : int
      {
         return this._reviveCD;
      }
      
      public function set reviveCD(value:int) : void
      {
         this._reviveCD = value;
      }
      
      public function get buffs() : Array
      {
         return this._buffs;
      }
      
      public function set buffs(value:Array) : void
      {
         this._buffs = value;
      }
      
      public function set buffID(value:int) : void
      {
         if(!this._buffs)
         {
            this._buffs = new Array();
         }
         this._buffs.push(value);
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
         dispatchEvent(new WorldBossScenePlayerEvent(WorldBossScenePlayerEvent.PLAYER_MOVE_SPEED_CHANGE,this._playerInfo.ID));
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

