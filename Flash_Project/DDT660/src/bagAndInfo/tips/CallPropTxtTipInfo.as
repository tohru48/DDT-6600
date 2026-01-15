package bagAndInfo.tips
{
   public class CallPropTxtTipInfo
   {
      
      private var _atcAdd:int = 0;
      
      private var _defAdd:int = 0;
      
      private var _agiAdd:int = 0;
      
      private var _lukAdd:int = 0;
      
      private var _rank:String = "";
      
      public function CallPropTxtTipInfo()
      {
         super();
      }
      
      public function get Attack() : int
      {
         return this._atcAdd;
      }
      
      public function set Attack(M:int) : void
      {
         this._atcAdd = M;
      }
      
      public function get Defend() : int
      {
         return this._defAdd;
      }
      
      public function set Defend(M:int) : void
      {
         this._defAdd = M;
      }
      
      public function get Agility() : int
      {
         return this._agiAdd;
      }
      
      public function set Agility(M:int) : void
      {
         this._agiAdd = M;
      }
      
      public function get Lucky() : int
      {
         return this._lukAdd;
      }
      
      public function set Lucky(M:int) : void
      {
         this._lukAdd = M;
      }
      
      public function get Rank() : String
      {
         return this._rank;
      }
      
      public function set Rank(M:String) : void
      {
         this._rank = M;
      }
   }
}

