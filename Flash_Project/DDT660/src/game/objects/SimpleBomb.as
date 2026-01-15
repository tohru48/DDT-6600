package game.objects
{
   import ddt.manager.BallManager;
   import ddt.manager.SharedManager;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import game.GameManager;
   import game.animations.PhysicalObjFocusAnimation;
   import game.animations.ShockMapAnimation;
   import game.model.GameInfo;
   import game.model.Living;
   import game.model.Player;
   import game.view.Bomb;
   import game.view.map.MapView;
   import game.view.smallMap.SmallBomb;
   import par.ParticleManager;
   import par.emitters.Emitter;
   import phy.bombs.BaseBomb;
   import phy.maps.Map;
   import phy.object.Physics;
   import phy.object.SmallObject;
   import road7th.utils.MovieClipWrapper;
   import room.model.RoomInfo;
   
   public class SimpleBomb extends BaseBomb
   {
      
      protected var _info:Bomb;
      
      protected var _lifeTime:int = 0;
      
      protected var _owner:Living;
      
      protected var _emitters:Array = new Array();
      
      protected var _spinV:Number;
      
      protected var _blastMC:MovieClipWrapper;
      
      protected var _dir:int = 1;
      
      protected var _smallBall:SmallObject = new SmallBomb();
      
      private var _game:GameInfo;
      
      private var _bitmapNum:int = 0;
      
      private var _refineryLevel:int;
      
      protected var _bullet:MovieClip;
      
      protected var _blastOut:MovieClip;
      
      protected var _crater:Bitmap;
      
      protected var _craterBrink:Bitmap;
      
      private var fastModel:Boolean;
      
      public function SimpleBomb(info:Bomb, owner:Living, refineryLevel:int = 0)
      {
         this._info = info;
         this._owner = owner;
         this._refineryLevel = refineryLevel;
         super(this._info.Id,info.Template.Mass,info.Template.Weight,info.Template.Wind,info.Template.DragIndex);
         this.createBallAsset();
      }
      
      public function get map() : MapView
      {
         return _map as MapView;
      }
      
      public function get info() : Bomb
      {
         return this._info;
      }
      
      public function get owner() : Living
      {
         return this._owner;
      }
      
      private function createBallAsset() : void
      {
         var bombAsset:BombAsset = null;
         this._bullet = BallManager.createBulletMovie(this.info.Template.ID);
         this._blastOut = BallManager.createBlastOutMovie(this.info.Template.blastOutID);
         if(BallManager.hasBombAsset(this.info.Template.craterID))
         {
            bombAsset = BallManager.getBombAsset(this.info.Template.craterID);
            this._crater = bombAsset.crater;
            this._craterBrink = bombAsset.craterBrink;
         }
      }
      
      protected function initMovie() : void
      {
         super.setMovie(this._bullet,this._crater,this._craterBrink);
         if(Boolean(this._blastOut))
         {
            this._blastOut.x = 0;
            this._blastOut.y = 0;
         }
         if(!this._info)
         {
            return;
         }
         this._blastMC = new MovieClipWrapper(this._blastOut,false,true);
         _testRect = new Rectangle(-3,-3,6,6);
         addSpeedXY(new Point(this._info.VX,this._info.VY));
         this._dir = this._info.VX >= 0 ? 1 : -1;
         x = this._info.X;
         y = this._info.Y;
         if(this._info.Template.SpinV > 0)
         {
            _movie.scaleX = this._dir;
         }
         else
         {
            _movie.scaleY = this._dir;
         }
         rotation = motionAngle * 180 / Math.PI;
         if(this.owner && !this.owner.isSelf && this._info.Template.ID == Bomb.FLY_BOMB && this.owner.isHidden)
         {
            this.visible = false;
            this._smallBall.visible = false;
         }
         mouseEnabled = false;
         mouseChildren = false;
         this.startMoving();
      }
      
      override public function setMap(map:Map) : void
      {
         super.setMap(map);
         if(Boolean(map))
         {
            this._game = this.map.game;
            this.initMovie();
         }
      }
      
      override public function startMoving() : void
      {
         var index:int = 0;
         var emitter:Emitter = null;
         var player:Player = null;
         super.startMoving();
         if(GameManager.Instance.Current == null)
         {
            return;
         }
         if(SharedManager.Instance.showParticle && visible)
         {
            index = 0;
            if(this._info.changedPartical != "")
            {
               if(this.owner.isPlayer())
               {
                  player = this.owner as Player;
                  index = player.currentWeapInfo.refineryLevel;
               }
               emitter = ParticleManager.creatEmitter(int(this._info.changedPartical));
            }
            if(Boolean(emitter))
            {
               _map.particleEnginee.addEmitter(emitter);
               this._emitters.push(emitter);
            }
         }
         this._spinV = this._info.Template.SpinV * this._dir;
      }
      
      override public function get smallView() : SmallObject
      {
         return this._smallBall;
      }
      
      override public function moveTo(p:Point) : void
      {
         var action:BombAction = null;
         var e:Emitter = null;
         while(this._info.Actions.length > 0)
         {
            if(this._info.Actions[0].time > this._lifeTime)
            {
               break;
            }
            action = this._info.Actions.shift();
            this._info.UsedActions.push(action);
            action.execute(this,this._game);
            if(!_isLiving)
            {
               return;
            }
         }
         if(_isLiving)
         {
            if(_map.IsOutMap(p.x,p.y))
            {
               this.die();
            }
            else
            {
               this.map.smallMap.updatePos(this._smallBall,pos);
               for each(e in this._emitters)
               {
                  e.x = x;
                  e.y = y;
                  e.angle = motionAngle;
               }
               pos = p;
               if(GameManager.Instance.Current.roomType != RoomInfo.ACTIVITY_DUNGEON_ROOM || GameManager.Instance.Current.roomType == RoomInfo.ACTIVITY_DUNGEON_ROOM && this._owner is Player && this._owner.LivingID == GameManager.Instance.Current.selfGamePlayer.LivingID)
               {
                  this.map.animateSet.addAnimation(new PhysicalObjFocusAnimation(this,25,0));
               }
               if(GameManager.Instance.Current.roomType != RoomInfo.STONEEXPLORE_ROOM || GameManager.Instance.Current.roomType == RoomInfo.STONEEXPLORE_ROOM && this._owner is Player && this._owner.LivingID == GameManager.Instance.Current.selfGamePlayer.LivingID)
               {
                  this.map.animateSet.addAnimation(new PhysicalObjFocusAnimation(this,25,0));
               }
            }
         }
      }
      
      public function clearWG() : void
      {
         _wf = 0;
         _gf = 0;
         _arf = 0;
      }
      
      override public function bomb() : void
      {
         var p:Physics = null;
         var radius:uint = 0;
         this.map.transform.matrix = new Matrix();
         if(this._info.IsHole)
         {
            super.DigMap();
            this.map.smallMap.draw();
            this.map.resetMapChanged();
         }
         var list:Array = this.map.getPhysicalObjectByPoint(pos,100,this);
         for each(p in list)
         {
            if(p is TombView)
            {
               p.startMoving();
            }
         }
         this.stopMoving();
         if(!this.fastModel)
         {
            if(this._info.Template.Shake)
            {
               radius = 7;
               if(this.info.damageMod < 1)
               {
                  radius = 4;
               }
               if(this.info.damageMod > 2)
               {
                  radius = 14;
               }
               this.map.animateSet.addAnimation(new ShockMapAnimation(this,radius));
            }
            else
            {
               if(GameManager.Instance.Current.roomType != RoomInfo.ACTIVITY_DUNGEON_ROOM || GameManager.Instance.Current.roomType == RoomInfo.ACTIVITY_DUNGEON_ROOM && this._owner is Player && this._owner.LivingID == GameManager.Instance.Current.selfGamePlayer.LivingID)
               {
                  this.map.animateSet.addAnimation(new PhysicalObjFocusAnimation(this,10));
               }
               if(GameManager.Instance.Current.roomType != RoomInfo.STONEEXPLORE_ROOM || GameManager.Instance.Current.roomType == RoomInfo.STONEEXPLORE_ROOM && this._owner is Player && this._owner.LivingID == GameManager.Instance.Current.selfGamePlayer.LivingID)
               {
                  this.map.animateSet.addAnimation(new PhysicalObjFocusAnimation(this,10));
               }
            }
         }
         if(!this.fastModel)
         {
            if(_isLiving)
            {
               SoundManager.instance.play(this._info.Template.BombSound);
            }
            if(visible)
            {
               this._blastMC.movie.x = x;
               this._blastMC.movie.y = y;
               _map.addToPhyLayer(this._blastMC.movie);
               this._blastMC.addEventListener(Event.COMPLETE,this.__complete);
               this._blastMC.play();
            }
            else
            {
               this.die();
            }
         }
         else
         {
            this.die();
         }
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
      
      override public function bombAtOnce() : void
      {
         var boomAction:BombAction = null;
         var action:BombAction = null;
         this.fastModel = true;
         for(var i:int = 0; i < this._info.Actions.length; i++)
         {
            if(this._info.Actions[i].type == ActionType.BOMB)
            {
               boomAction = this._info.Actions[i];
               break;
            }
         }
         var boomIndex:int = int(this._info.Actions.indexOf(boomAction));
         var newActions:Array = this._info.Actions.splice(boomIndex,1);
         if(Boolean(boomAction))
         {
            this._info.Actions.push(boomAction);
         }
         while(this._info.Actions.length > 0)
         {
            action = this._info.Actions.shift();
            this._info.UsedActions.push(action);
            action.execute(this,this._game);
            if(!_isLiving)
            {
               return;
            }
         }
         if(Boolean(this._info))
         {
            this._info.Actions = [];
         }
      }
      
      private function __complete(event:Event) : void
      {
         this.die();
      }
      
      override public function die() : void
      {
         super.die();
         this.dispose();
      }
      
      override public function stopMoving() : void
      {
         var e:Emitter = null;
         for each(e in this._emitters)
         {
            _map.particleEnginee.removeEmitter(e);
         }
         this._emitters = [];
         super.stopMoving();
      }
      
      override protected function updatePosition(dt:Number) : void
      {
         this._lifeTime += 40;
         super.updatePosition(dt);
         if(!_isLiving)
         {
            return;
         }
         if(this._spinV > 1 || this._spinV < -1)
         {
            this._spinV = int(this._spinV * this._info.Template.SpinVA);
            _movie.rotation += this._spinV;
         }
         rotation = motionAngle * 180 / Math.PI;
      }
      
      public function get target() : Point
      {
         if(Boolean(this._info))
         {
            return this._info.target;
         }
         return null;
      }
      
      override public function dispose() : void
      {
         super.dispose();
         if(Boolean(this._blastMC))
         {
            this._blastMC.removeEventListener(Event.COMPLETE,this.__complete);
            this._blastMC.dispose();
            this._blastMC = null;
         }
         if(Boolean(_map))
         {
            _map.removePhysical(this);
         }
         if(Boolean(this._smallBall))
         {
            if(Boolean(this._smallBall.parent))
            {
               this._smallBall.parent.removeChild(this._smallBall);
            }
            this._smallBall.dispose();
            this._smallBall = null;
         }
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
         this._crater = null;
         this._craterBrink = null;
         this._owner = null;
         this._emitters = null;
         this._info = null;
         this._game = null;
         this._bullet = null;
         this._blastOut = null;
      }
   }
}

