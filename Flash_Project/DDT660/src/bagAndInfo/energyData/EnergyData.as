package bagAndInfo.energyData
{
   public class EnergyData
   {
      
      private var _energy:int;
      
      private var _money:int;
      
      private var _count:int;
      
      public function EnergyData()
      {
         super();
      }
      
      public function get Energy() : int
      {
         return this._energy;
      }
      
      public function set Energy(value:int) : void
      {
         this._energy = value;
      }
      
      public function get Money() : int
      {
         return this._money;
      }
      
      public function set Money(value:int) : void
      {
         this._money = value;
      }
      
      public function get Count() : int
      {
         return this._count;
      }
      
      public function set Count(value:int) : void
      {
         this._count = value;
      }
   }
}

