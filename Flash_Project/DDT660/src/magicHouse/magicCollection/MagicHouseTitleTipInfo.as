package magicHouse.magicCollection
{
   public class MagicHouseTitleTipInfo
   {
      
      private var _magicAttack:int;
      
      private var _magicDefense:int;
      
      private var _critDamage:int;
      
      private var _title:String = "";
      
      public function MagicHouseTitleTipInfo()
      {
         super();
      }
      
      public function get magicAttack() : int
      {
         return this._magicAttack;
      }
      
      public function set magicAttack(value:int) : void
      {
         this._magicAttack = value;
      }
      
      public function get magicDefense() : int
      {
         return this._magicDefense;
      }
      
      public function set magicDefense(value:int) : void
      {
         this._magicDefense = value;
      }
      
      public function get critDamage() : int
      {
         return this._critDamage;
      }
      
      public function set critDamage(value:int) : void
      {
         this._critDamage = value;
      }
      
      public function get title() : String
      {
         return this._title;
      }
      
      public function set title(value:String) : void
      {
         this._title = value;
      }
   }
}

