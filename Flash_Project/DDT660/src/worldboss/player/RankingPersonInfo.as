package worldboss.player
{
   public class RankingPersonInfo
   {
      
      private var _id:int;
      
      private var _name:String;
      
      private var _damage:int;
      
      private var _percentage:Number;
      
      public function RankingPersonInfo()
      {
         super();
      }
      
      public function set id(value:int) : void
      {
         this._id = value;
      }
      
      public function get id() : int
      {
         return this._id;
      }
      
      public function set name(value:String) : void
      {
         this._name = value;
      }
      
      public function get name() : String
      {
         return this._name;
      }
      
      public function set damage(value:int) : void
      {
         this._damage = value;
      }
      
      public function get damage() : int
      {
         return this._damage;
      }
      
      public function set percentage(value:Number) : void
      {
         this._percentage = value;
      }
      
      public function get percentage() : Number
      {
         return this._percentage;
      }
      
      public function getPercentage(num:Number) : String
      {
         return (this._damage / num * 100).toString().substr(0,5) + "%";
      }
   }
}

