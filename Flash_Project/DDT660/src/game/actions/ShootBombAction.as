package game.actions
{
   import ddt.command.PlayerAction;
   import ddt.data.BallInfo;
   import ddt.data.EquipType;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.BallManager;
   import ddt.manager.SoundManager;
   import ddt.view.character.GameCharacter;
   import game.model.LocalPlayer;
   import game.objects.ActionType;
   import game.objects.GameLocalPlayer;
   import game.objects.GamePlayer;
   import game.objects.SimpleBomb;
   import game.objects.SkillBomb;
   import game.view.Bomb;
   import phy.bombs.BaseBomb;
   
   public class ShootBombAction extends BaseAction
   {
      
      private var _player:GamePlayer;
      
      private var _showAction:PlayerAction;
      
      private var _hideAction:PlayerAction;
      
      private var _bombs:Array;
      
      private var _isShoot:Boolean;
      
      private var _shootInterval:int;
      
      private var _info:BallInfo;
      
      private var _event:CrazyTankSocketEvent;
      
      public function ShootBombAction(player:GamePlayer, bombs:Array, event:CrazyTankSocketEvent, interval:int)
      {
         super();
         this._player = player;
         this._bombs = bombs;
         this._event = event;
         this._shootInterval = interval;
         this._event.executed = false;
      }
      
      override public function prepare() : void
      {
         if(_isPrepare)
         {
            return;
         }
         _isPrepare = true;
         if(this._player == null || this._player.body == null || this._player.player == null)
         {
            this.finish();
            return;
         }
         this._info = BallManager.findBall(this._player.player.currentBomb);
         this._showAction = this._info.ActionType == 0 ? GameCharacter.THROWS : GameCharacter.SHOT;
         this._hideAction = this._info.ActionType == 0 ? GameCharacter.HIDETHROWS : GameCharacter.HIDEGUN;
         if(this._player.isLiving)
         {
            this._player.body.doAction(this._showAction);
            if(Boolean(this._player.weaponMovie))
            {
               this._player.weaponMovie.visible = true;
               this._player.setWeaponMoiveActionSyc("shot");
               this._player.body.WingState = GameCharacter.GAME_WING_SHOOT;
            }
         }
      }
      
      override public function execute() : void
      {
         if(this._player == null || this._player.body == null || this._player.body.currentAction == null)
         {
            this.finish();
            return;
         }
         if(this._player.body.currentAction != this._showAction)
         {
            if(Boolean(this._player.weaponMovie))
            {
               this._player.weaponMovie.visible = false;
            }
            this._player.body.WingState = GameCharacter.GAME_WING_WAIT;
         }
         if(!this._isShoot)
         {
            if(!this._player.body.actionPlaying() || this._player.body.currentAction != this._showAction)
            {
               this.executeImp(false);
            }
         }
         else
         {
            --this._shootInterval;
            if(this._shootInterval <= 0)
            {
               if(this._player.body.currentAction == this._showAction)
               {
                  if(this._player.isLiving)
                  {
                     this._player.body.doAction(this._hideAction);
                  }
                  if(Boolean(this._player.weaponMovie))
                  {
                     this._player.setWeaponMoiveActionSyc("end");
                  }
                  this._player.body.WingState = GameCharacter.GAME_WING_WAIT;
               }
               this.finish();
            }
         }
      }
      
      private function setSelfShootFinish() : void
      {
         if(!this._player.isExist)
         {
            return;
         }
         if(!this._player.info.isSelf)
         {
            return;
         }
         if(GameLocalPlayer(this._player).shootOverCount >= LocalPlayer(this._player.info).shootCount)
         {
            GameLocalPlayer(this._player).shootOverCount = LocalPlayer(this._player.info).shootCount;
         }
         else
         {
            ++GameLocalPlayer(this._player).shootOverCount;
         }
      }
      
      private function finish() : void
      {
         _isFinished = true;
         this._event.executed = true;
         this.setSelfShootFinish();
      }
      
      private function executeImp(fastModel:Boolean) : void
      {
         var i:int = 0;
         var b:Bomb = null;
         var j:int = 0;
         var bomb:BaseBomb = null;
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
               if(b.Template.ID == EquipType.LaserBomdID)
               {
                  bomb = new SkillBomb(b,this._player.info);
               }
               else
               {
                  bomb = new SimpleBomb(b,this._player.info,this._player.player.currentWeapInfo.refineryLevel);
               }
               this._player.map.addPhysical(bomb);
               if(fastModel)
               {
                  bomb.bombAtOnce();
               }
            }
         }
      }
      
      override public function executeAtOnce() : void
      {
         super.executeAtOnce();
         this.executeImp(true);
      }
   }
}

