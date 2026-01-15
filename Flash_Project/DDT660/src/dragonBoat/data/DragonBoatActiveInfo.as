package dragonBoat.data
{
   import road7th.utils.DateUtils;
   
   public class DragonBoatActiveInfo
   {
      
      private var _activeID:int = 1;
      
      private var _beginTimeDate:Date;
      
      private var _endTimeDate:Date;
      
      public var LimitGrade:int;
      
      private var _normalScore:int;
      
      private var _highScore:int;
      
      public var MinScore:int;
      
      public function DragonBoatActiveInfo()
      {
         super();
      }
      
      public function get beginTimeDate() : Date
      {
         return Boolean(this._beginTimeDate) ? this._beginTimeDate : new Date();
      }
      
      public function set BeginTime(value:String) : void
      {
         this._beginTimeDate = DateUtils.decodeDated(value);
      }
      
      public function get endTimeDate() : Date
      {
         return Boolean(this._endTimeDate) ? this._endTimeDate : new Date();
      }
      
      public function set EndTime(value:String) : void
      {
         this._endTimeDate = DateUtils.decodeDated(value);
      }
      
      public function get normalScore() : int
      {
         return this._normalScore;
      }
      
      public function set AddPropertyByMoney(value:String) : void
      {
         var tmp:String = value.split(":")[1];
         this._normalScore = tmp.split(",")[1];
      }
      
      public function get highScore() : int
      {
         return this._highScore;
      }
      
      public function set AddPropertyByProp(value:String) : void
      {
         var tmp:String = value.split(":")[1];
         this._highScore = tmp.split(",")[1];
      }
      
      public function get ActiveID() : int
      {
         return this._activeID;
      }
      
      public function set ActiveID(value:int) : void
      {
         this._activeID = value;
      }
   }
}

