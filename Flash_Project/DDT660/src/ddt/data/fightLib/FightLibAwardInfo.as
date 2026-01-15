package ddt.data.fightLib
{
   public class FightLibAwardInfo
   {
      
      private var _id:int;
      
      private var _easyAward:Array;
      
      private var _normalAward:Array;
      
      private var _difficultAward:Array;
      
      public function FightLibAwardInfo()
      {
         super();
         this._easyAward = [];
         this._normalAward = [];
         this._difficultAward = [];
      }
      
      public function get easyAward() : Array
      {
         return this._easyAward;
      }
      
      public function set easyAward(value:Array) : void
      {
         this._easyAward = value;
      }
      
      public function get normalAward() : Array
      {
         return this._normalAward;
      }
      
      public function set normalAward(value:Array) : void
      {
         this._normalAward = value;
      }
      
      public function get difficultAward() : Array
      {
         return this._difficultAward;
      }
      
      public function set difficultAward(value:Array) : void
      {
         this._difficultAward = value;
      }
      
      public function get id() : int
      {
         return this._id;
      }
      
      public function set id(value:int) : void
      {
         this._id = value;
      }
   }
}

