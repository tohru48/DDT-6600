package church.vo
{
   public class FatherBallConfigVO
   {
      
      private var _isMask:String;
      
      private var _rowNumber:int;
      
      private var _rowWitdh:Number;
      
      private var _rowHeight:Number;
      
      private var _frameStep:Number;
      
      private var _sleepSecond:int;
      
      public function FatherBallConfigVO()
      {
         super();
      }
      
      public function get isMask() : String
      {
         return this._isMask;
      }
      
      public function set isMask(value:String) : void
      {
         this._isMask = value;
      }
      
      public function get sleepSecond() : int
      {
         return this._sleepSecond;
      }
      
      public function set sleepSecond(value:int) : void
      {
         this._sleepSecond = value;
      }
      
      public function get frameStep() : Number
      {
         return this._frameStep;
      }
      
      public function set frameStep(value:Number) : void
      {
         this._frameStep = value;
      }
      
      public function get rowHeight() : Number
      {
         return this._rowHeight;
      }
      
      public function set rowHeight(value:Number) : void
      {
         this._rowHeight = value;
      }
      
      public function get rowWitdh() : Number
      {
         return this._rowWitdh;
      }
      
      public function set rowWitdh(value:Number) : void
      {
         this._rowWitdh = value;
      }
      
      public function get rowNumber() : int
      {
         return this._rowNumber;
      }
      
      public function set rowNumber(value:int) : void
      {
         this._rowNumber = value;
      }
   }
}

