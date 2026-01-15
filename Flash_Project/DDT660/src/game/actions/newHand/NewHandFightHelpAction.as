package game.actions.newHand
{
   import game.GameManager;
   import game.model.Living;
   import game.model.LocalPlayer;
   import game.model.Player;
   import game.view.Bomb;
   import game.view.map.MapView;
   
   public class NewHandFightHelpAction extends BaseNewHandFightHelpAction
   {
      
      private var _player:LocalPlayer;
      
      private var _enemyPlayer:Player;
      
      private var _bombs:Array;
      
      private var _shootOverCount:int;
      
      private var _map:MapView;
      
      public function NewHandFightHelpAction(player:LocalPlayer, shootOverCount:int, map:MapView)
      {
         super();
         this._player = player;
         this._bombs = this._player.lastFireBombs;
         this._shootOverCount = shootOverCount;
         this._map = map;
      }
      
      override public function prepare() : void
      {
         super.prepare();
         if(!isInNewHandRoom)
         {
            _isFinished = true;
            return;
         }
         this._enemyPlayer = this.getNewHandEnemy();
         if(!this._enemyPlayer || !this._player.isLiving || !_gameInfo)
         {
            _isFinished = true;
         }
         else if(_gameInfo.currentLiving != this._player && this._shootOverCount > 0)
         {
            _isFinished = false;
         }
         else if(_gameInfo.currentLiving == this._player)
         {
            this._player.NewHandEnemyBlood = this._enemyPlayer.blood;
            this._player.NewHandEnemyIsFrozen = this._enemyPlayer.isFrozen;
            this._player.NewHandSelfBlood = this._player.blood;
            _isFinished = true;
         }
         else
         {
            _isFinished = true;
         }
      }
      
      override public function executeAtOnce() : void
      {
         super.executeAtOnce();
         if(!this._player || !_gameInfo || !this._map || !this._enemyPlayer)
         {
            return;
         }
         if(this.checkShootDirection())
         {
            return;
         }
         if(this.checkShootOutMap())
         {
            return;
         }
         if(this.checkHurtEnemy())
         {
            return;
         }
      }
      
      override public function execute() : void
      {
         super.execute();
         this._player = null;
         this._bombs = null;
         _gameInfo = null;
         this._map = null;
         this._enemyPlayer = null;
      }
      
      private function getNewHandEnemy() : Player
      {
         var p:Living = null;
         for each(p in GameManager.Instance.Current.livings)
         {
            if(p.isPlayer() && p.isLiving && p != this._player)
            {
               return p as Player;
            }
         }
         return null;
      }
      
      private function checkShootDirection() : Boolean
      {
         var bomb:Bomb = this.getRecentBomb();
         if(bomb == null || bomb.Template.ID == Bomb.FLY_BOMB)
         {
            return false;
         }
         var dic1:int = this._enemyPlayer.pos.x > this._player.pos.x ? 1 : -1;
         var dic2:int = bomb.target.x >= bomb.X ? 1 : -1;
         if(dic1 != dic2)
         {
            showFightTip("tank.trainer.fightAction.newHandTip1");
            return true;
         }
         return false;
      }
      
      private function checkShootOutMap() : Boolean
      {
         var bomb:Bomb = null;
         for each(bomb in this._bombs)
         {
            if(bomb.Template.ID != 64 && this._map.IsOutMap(bomb.target.x,bomb.target.y))
            {
               ++this._player.NewHandHurtEnemyCounter;
               this.checkHurtEnemy(false);
               showFightTip("tank.trainer.fightAction.newHandTip2");
               return true;
            }
         }
         return false;
      }
      
      private function checkHurtSelf() : Boolean
      {
         var blood:int = this._player.NewHandSelfBlood > 0 ? this._player.NewHandSelfBlood : this._player.maxBlood;
         if(blood > this._player.blood)
         {
            ++this._player.NewHandHurtSelfCounter;
            if(this._player.NewHandHurtSelfCounter > 0)
            {
               showFightTip("tank.trainer.fightAction.newHandTip4");
               return true;
            }
         }
         else
         {
            this._player.NewHandHurtSelfCounter = 0;
         }
         return false;
      }
      
      private function getRecentBomb() : Bomb
      {
         var result:Bomb = null;
         var bomb:Bomb = null;
         var TemplateID:int = 0;
         var inst:int = -1;
         for each(bomb in this._bombs)
         {
            TemplateID = bomb.Template.ID;
            if(bomb && (TemplateID != 64 && TemplateID != Bomb.FLY_BOMB && TemplateID != Bomb.FREEZE_BOMB) && (inst == -1 || Math.abs(bomb.target.x - this._enemyPlayer.pos.x) < inst))
            {
               inst = Math.abs(bomb.target.x - this._enemyPlayer.pos.x);
               result = bomb;
            }
         }
         return result;
      }
      
      private function checkHurtEnemy(showTip:Boolean = true) : Boolean
      {
         var bomb:Bomb = null;
         var dic1:int = 0;
         var dic2:int = 0;
         if(this._player.NewHandEnemyBlood != this._enemyPlayer.blood || this._player.NewHandEnemyIsFrozen && !this._enemyPlayer.isFrozen)
         {
            this._player.NewHandHurtEnemyCounter = 0;
         }
         else
         {
            bomb = this.getRecentBomb();
            if(bomb == null)
            {
               return false;
            }
            ++this._player.NewHandHurtEnemyCounter;
            if(this._player.NewHandHurtEnemyCounter > 1)
            {
               dic1 = this._enemyPlayer.pos.x > this._player.pos.x ? 1 : -1;
               dic2 = bomb.target.x > this._enemyPlayer.pos.x ? 1 : -1;
               if(showTip)
               {
                  showFightTip("tank.trainer.fightAction.newHandTip3" + (dic1 == dic2 ? "Small" : "Large"));
               }
               return true;
            }
         }
         return false;
      }
   }
}

