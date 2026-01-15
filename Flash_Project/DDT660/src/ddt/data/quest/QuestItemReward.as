package ddt.data.quest
{
   public class QuestItemReward
   {
      
      private var _selectGroup:int;
      
      private var _itemID:int;
      
      private var _count:Array;
      
      private var _isOptional:int;
      
      private var _time:int;
      
      private var _StrengthenLevel:int;
      
      private var _AttackCompose:int;
      
      private var _DefendCompose:int;
      
      private var _AgilityCompose:int;
      
      private var _LuckCompose:int;
      
      private var _isBind:Boolean;
      
      public var AttackCompose:int;
      
      public var DefendCompose:int;
      
      public var LuckCompose:int;
      
      public var AgilityCompose:int;
      
      public var StrengthenLevel:int;
      
      public var IsCount:Boolean;
      
      public var MagicAttack:int;
      
      public var MagicDefence:int;
      
      public function QuestItemReward(id:int, count:Array, optional:String, isBind:String = "true")
      {
         super();
         this._itemID = id;
         this._count = count;
         if(optional == "true")
         {
            this._isOptional = 1;
         }
         else
         {
            this._isOptional = 0;
         }
         if(isBind == "true")
         {
            this._isBind = true;
         }
         else
         {
            this._isBind = false;
         }
      }
      
      public function get count() : Array
      {
         return this._count;
      }
      
      public function get itemID() : int
      {
         return this._itemID;
      }
      
      public function set time(time:int) : void
      {
         this._time = time;
      }
      
      public function get time() : int
      {
         return this._time;
      }
      
      public function get ValidateTime() : Number
      {
         return this._time;
      }
      
      public function get isOptional() : int
      {
         return this._isOptional;
      }
      
      public function get isBind() : Boolean
      {
         return this._isBind;
      }
   }
}

