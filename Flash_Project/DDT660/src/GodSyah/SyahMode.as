package GodSyah
{
   public class SyahMode
   {
      
      private var _syahID:int;
      
      private var _attack:int;
      
      private var _defense:int;
      
      private var _agility:int;
      
      private var _lucky:int;
      
      private var _hp:int;
      
      private var _armor:int;
      
      private var _damage:int;
      
      private var _isHold:Boolean;
      
      private var _isValid:Boolean;
      
      private var _level:int;
      
      private var _isGold:Boolean;
      
      private var _valid:String;
      
      public function SyahMode()
      {
         super();
      }
      
      public function get attack() : int
      {
         return this._attack;
      }
      
      public function set attack(value:int) : void
      {
         this._attack = value;
      }
      
      public function get defense() : int
      {
         return this._defense;
      }
      
      public function set defense(value:int) : void
      {
         this._defense = value;
      }
      
      public function get agility() : int
      {
         return this._agility;
      }
      
      public function set agility(value:int) : void
      {
         this._agility = value;
      }
      
      public function get lucky() : int
      {
         return this._lucky;
      }
      
      public function set lucky(value:int) : void
      {
         this._lucky = value;
      }
      
      public function get hp() : int
      {
         return this._hp;
      }
      
      public function set hp(value:int) : void
      {
         this._hp = value;
      }
      
      public function get armor() : int
      {
         return this._armor;
      }
      
      public function set armor(value:int) : void
      {
         this._armor = value;
      }
      
      public function get damage() : int
      {
         return this._damage;
      }
      
      public function set damage(value:int) : void
      {
         this._damage = value;
      }
      
      public function get isHold() : Boolean
      {
         return this._isHold;
      }
      
      public function set isHold(value:Boolean) : void
      {
         this._isHold = value;
      }
      
      public function get syahID() : int
      {
         return this._syahID;
      }
      
      public function set syahID(value:int) : void
      {
         this._syahID = value;
      }
      
      public function get isValid() : Boolean
      {
         return this._isValid;
      }
      
      public function set isValid(value:Boolean) : void
      {
         this._isValid = value;
      }
      
      public function get level() : int
      {
         return this._level;
      }
      
      public function set level(value:int) : void
      {
         this._level = value;
      }
      
      public function get isGold() : Boolean
      {
         return this._isGold;
      }
      
      public function set isGold(value:Boolean) : void
      {
         this._isGold = value;
      }
      
      public function get valid() : String
      {
         return this._valid;
      }
      
      public function set valid(value:String) : void
      {
         this._valid = value;
      }
   }
}

