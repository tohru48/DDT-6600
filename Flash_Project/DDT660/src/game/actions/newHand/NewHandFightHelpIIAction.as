package game.actions.newHand
{
   import ddt.manager.PlayerManager;
   import game.GameManager;
   import game.actions.BaseAction;
   import game.model.Living;
   import game.model.LocalPlayer;
   import game.model.Player;
   import trainer.data.Step;
   
   public class NewHandFightHelpIIAction extends BaseNewHandFightHelpAction
   {
      
      private var _player:LocalPlayer;
      
      private var _diffBlood:int;
      
      public function NewHandFightHelpIIAction(player:LocalPlayer, diffBlood:Number)
      {
         super();
         this._player = player;
         this._diffBlood = diffBlood;
      }
      
      override public function prepare() : void
      {
         super.prepare();
         if(!isInNewHandRoom)
         {
            _isFinished = true;
            return;
         }
         if(!(_gameInfo.currentLiving == this._player && this._player.isLiving))
         {
            _isFinished = true;
         }
      }
      
      override public function connect(action:BaseAction) : Boolean
      {
         var act:NewHandFightHelpIIAction = action as NewHandFightHelpIIAction;
         if(Boolean(act))
         {
            return true;
         }
         return false;
      }
      
      override public function executeAtOnce() : void
      {
         super.executeAtOnce();
         if(!this._player.isLiving && !isInNewHandRoom)
         {
            return;
         }
         if(this.checkSelfBlood())
         {
            return;
         }
      }
      
      override public function execute() : void
      {
         super.execute();
         this._player = null;
         _gameInfo = null;
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
      
      private function checkBeEnemyHurt() : Boolean
      {
         if(this._player.isAttacking)
         {
            return false;
         }
         if(!this._player.lockFly && this._diffBlood < 0)
         {
            ++this._player.NewHandBeEnemyHurtCounter;
            if(this._player.NewHandBeEnemyHurtCounter % 2 == 0)
            {
               showFightTip("tank.trainer.fightAction.newHandTip5");
               return true;
            }
         }
         else
         {
            this._player.NewHandBeEnemyHurtCounter = 0;
         }
         return false;
      }
      
      private function checkSelfBlood() : Boolean
      {
         return false;
      }
      
      private function getPropNum() : int
      {
         if(PlayerManager.Instance.Self.IsWeakGuildFinish(Step.FROZE_PROP_OPEN))
         {
            return 8;
         }
         if(PlayerManager.Instance.Self.IsWeakGuildFinish(Step.HIDE_PROP_OPEN))
         {
            return 7;
         }
         if(PlayerManager.Instance.Self.IsWeakGuildFinish(Step.POWER_PROP_OPEN))
         {
            return 4;
         }
         if(PlayerManager.Instance.Self.IsWeakGuildFinish(Step.GUILD_PROP_OPEN))
         {
            return 3;
         }
         if(PlayerManager.Instance.Self.IsWeakGuildFinish(Step.HP_PROP_OPEN))
         {
            return 2;
         }
         return 0;
      }
   }
}

