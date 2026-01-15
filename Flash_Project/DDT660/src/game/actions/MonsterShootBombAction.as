package game.actions
{
   import ddt.data.BallInfo;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.BallManager;
   import ddt.manager.SoundManager;
   import flash.events.Event;
   import game.animations.AnimationLevel;
   import game.objects.ActionType;
   import game.objects.GameLiving;
   import game.objects.SimpleBomb;
   import game.view.Bomb;
   
   public class MonsterShootBombAction extends BaseAction
   {
      
      private var _monster:GameLiving;
      
      private var _bombs:Array;
      
      private var _isShoot:Boolean;
      
      private var _prepared:Boolean;
      
      private var _prepareAction:String;
      
      private var _shootInterval:int;
      
      private var _info:BallInfo;
      
      private var _event:CrazyTankSocketEvent;
      
      private var _endAction:String = "";
      
      private var _canShootImp:Boolean;
      
      public function MonsterShootBombAction(monster:GameLiving, bombs:Array, event:CrazyTankSocketEvent, interval:int)
      {
         super();
         this._monster = monster;
         this._bombs = bombs;
         this._event = event;
         this._prepared = false;
         this._shootInterval = interval / 40;
      }
      
      override public function prepare() : void
      {
         this._info = BallManager.findBall(this._bombs[0].Template.ID);
         this._monster.map.requestForFocus(this._monster,AnimationLevel.LOW);
         this._monster.actionMovie.addEventListener(GameLiving.SHOOT_PREPARED,this.onEventPrepared);
         this._monster.actionMovie.doAction("shoot",this.onCallbackPrepared);
      }
      
      protected function onEventPrepared(evt:Event) : void
      {
         this.canShoot();
      }
      
      protected function onCallbackPrepared() : void
      {
         this.canShoot();
      }
      
      private function canShoot() : void
      {
         this._monster.actionMovie.removeEventListener(GameLiving.SHOOT_PREPARED,this.onEventPrepared);
         this._prepared = true;
         this._monster.map.cancelFocus(this._monster);
      }
      
      override public function execute() : void
      {
         if(!this._prepared)
         {
            return;
         }
         if(!this._isShoot)
         {
            this.executeImp(false);
         }
         else
         {
            --this._shootInterval;
            if(this._shootInterval <= 0)
            {
               _isFinished = true;
               this._event.executed = true;
            }
         }
      }
      
      private function executeImp(fastModel:Boolean) : void
      {
         var i:int = 0;
         var b:Bomb = null;
         var j:int = 0;
         var bomb:SimpleBomb = null;
         if(!this._isShoot)
         {
            this._isShoot = true;
            SoundManager.instance.play(this._info.ShootSound);
            for(i = 0; i < this._bombs.length; i++)
            {
               for(j = 0; j < this._bombs[i].Actions.length; j++)
               {
                  if(this._bombs[i].Actions[j].type == ActionType.KILL_PLAYER)
                  {
                     this._bombs.unshift(this._bombs.splice(i,1)[0]);
                     break;
                  }
               }
            }
            for each(b in this._bombs)
            {
               bomb = new SimpleBomb(b,this._monster.info);
               this._monster.map.addPhysical(bomb);
               if(fastModel)
               {
                  bomb.bombAtOnce();
               }
            }
         }
      }
   }
}

