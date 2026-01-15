package game.model
{
   import ddt.events.LivingEvent;
   import flash.utils.Dictionary;
   
   [Event(name="attackingChanged",type="ddt.events.LivingEvent")]
   public class TurnedLiving extends Living
   {
      
      protected var _isAttacking:Boolean = false;
      
      private var _fightBuffs:Dictionary;
      
      public function TurnedLiving(id:int, team:int, maxBlood:int)
      {
         super(id,team,maxBlood);
      }
      
      public function get isAttacking() : Boolean
      {
         return this._isAttacking;
      }
      
      public function set isAttacking(value:Boolean) : void
      {
         if(this._isAttacking == value)
         {
            return;
         }
         this._isAttacking = value;
         dispatchEvent(new LivingEvent(LivingEvent.ATTACKING_CHANGED));
      }
      
      override public function beginNewTurn() : void
      {
         super.beginNewTurn();
         this.isAttacking = false;
         this._fightBuffs = new Dictionary();
      }
      
      override public function die(widthAction:Boolean = true) : void
      {
         if(isLiving)
         {
            if(this._isAttacking)
            {
               this.stopAttacking();
            }
            super.die(widthAction);
         }
      }
      
      public function hasState(stateId:int) : Boolean
      {
         return this._fightBuffs[stateId] != null;
      }
      
      public function addState(stateId:int, pic:String = "") : void
      {
         if(stateId != 0 && Boolean(this._fightBuffs))
         {
            this._fightBuffs[stateId] = true;
         }
         dispatchEvent(new LivingEvent(LivingEvent.ADD_STATE,stateId,0,pic));
      }
      
      public function startAttacking() : void
      {
         this.isAttacking = true;
      }
      
      public function stopAttacking() : void
      {
         this.isAttacking = false;
      }
      
      override public function dispose() : void
      {
         this._fightBuffs = null;
         super.dispose();
      }
   }
}

