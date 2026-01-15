package game.objects
{
   import ddt.events.LivingEvent;
   import game.model.TurnedLiving;
   import game.view.smallMap.SmallLiving;
   
   public class GameTurnedLiving extends GameLiving
   {
      
      public function GameTurnedLiving(info:TurnedLiving)
      {
         super(info);
      }
      
      public function get turnedLiving() : TurnedLiving
      {
         return _info as TurnedLiving;
      }
      
      override protected function initListener() : void
      {
         super.initListener();
         this.turnedLiving.addEventListener(LivingEvent.ATTACKING_CHANGED,this.__attackingChanged);
      }
      
      override protected function removeListener() : void
      {
         super.removeListener();
         if(Boolean(this.turnedLiving))
         {
            this.turnedLiving.removeEventListener(LivingEvent.ATTACKING_CHANGED,this.__attackingChanged);
         }
      }
      
      protected function __attackingChanged(event:LivingEvent) : void
      {
         if(Boolean(_smallView))
         {
            SmallLiving(_smallView).isAttacking = this.turnedLiving.isAttacking;
         }
      }
      
      override public function die() : void
      {
         this.turnedLiving.isAttacking = false;
         super.die();
      }
   }
}

