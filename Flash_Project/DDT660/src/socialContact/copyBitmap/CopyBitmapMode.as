package socialContact.copyBitmap
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   
   public class CopyBitmapMode extends EventDispatcher
   {
      
      public static const CHANGE_MODE:String = "change_mode";
      
      public var ponitID:int;
      
      private var _startX:int;
      
      private var _startY:int;
      
      private var _endX:int;
      
      private var _endY:int;
      
      public function CopyBitmapMode()
      {
         super();
      }
      
      public function set startX(num:int) : void
      {
         this._startX = num;
         dispatchEvent(new Event(CHANGE_MODE));
      }
      
      public function get startX() : int
      {
         return this._startX;
      }
      
      public function set startY(num:int) : void
      {
         this._startY = num;
         dispatchEvent(new Event(CHANGE_MODE));
      }
      
      public function get startY() : int
      {
         return this._startY;
      }
      
      public function set endX(num:int) : void
      {
         this._endX = num;
         dispatchEvent(new Event(CHANGE_MODE));
      }
      
      public function get endX() : int
      {
         return this._endX;
      }
      
      public function set endY(num:int) : void
      {
         this._endY = num;
         dispatchEvent(new Event(CHANGE_MODE));
      }
      
      public function get endY() : int
      {
         return this._endY;
      }
   }
}

