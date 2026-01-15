package catchInsect.data
{
   public class CatchCallPropTxtTipInfo
   {
      
      private var _atcAdd:int = 0;
      
      private var _defAdd:int = 0;
      
      private var _agiAdd:int = 0;
      
      private var _lukAdd:int = 0;
      
      private var _rank:String = "";
      
      private var _validDate:String = "";
      
      public function CatchCallPropTxtTipInfo()
      {
         super();
      }
      
      public function get Attack() : int
      {
         return this._atcAdd;
      }
      
      public function set Attack(value:int) : void
      {
         this._atcAdd = value;
      }
      
      public function get Defend() : int
      {
         return this._defAdd;
      }
      
      public function set Defend(value:int) : void
      {
         this._defAdd = value;
      }
      
      public function get Agility() : int
      {
         return this._agiAdd;
      }
      
      public function set Agility(value:int) : void
      {
         this._agiAdd = value;
      }
      
      public function get Lucky() : int
      {
         return this._lukAdd;
      }
      
      public function set Lucky(value:int) : void
      {
         this._lukAdd = value;
      }
      
      public function get Rank() : String
      {
         return this._rank;
      }
      
      public function set Rank(value:String) : void
      {
         this._rank = value;
      }
      
      public function get ValidDate() : String
      {
         return this._validDate;
      }
      
      public function set ValidDate(value:String) : void
      {
         this._validDate = value;
      }
   }
}

