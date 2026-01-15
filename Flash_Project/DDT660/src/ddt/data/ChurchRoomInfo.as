package ddt.data
{
   import church.events.WeddingRoomEvent;
   import flash.events.EventDispatcher;
   
   public class ChurchRoomInfo extends EventDispatcher
   {
      
      public static const WEDDING_NONE:String = "wedding_none";
      
      public static const WEDDING_ING:String = "wedding_ing";
      
      public var id:int;
      
      public var roomName:String = "";
      
      public var brideID:int;
      
      public var brideName:String;
      
      public var groomID:int;
      
      public var groomName:String;
      
      public var createID:int;
      
      public var createName:String;
      
      public var mapID:int;
      
      public var isLocked:Boolean;
      
      public var password:String = "";
      
      public var discription:String = "";
      
      public var canInvite:Boolean;
      
      public var isUsedSalute:Boolean;
      
      public var creactTime:Date;
      
      private var _validTimes:uint;
      
      public var maxNum:uint = 200;
      
      private var _status:String = "wedding_none";
      
      private var _currentNum:uint;
      
      private var _isStarted:Boolean;
      
      private var _roomType:int;
      
      public function ChurchRoomInfo()
      {
         super();
      }
      
      public function get isStarted() : Boolean
      {
         return this._isStarted;
      }
      
      public function set isStarted(value:Boolean) : void
      {
         this._isStarted = value;
      }
      
      public function get valideTimes() : uint
      {
         return this._validTimes;
      }
      
      public function set valideTimes(value:uint) : void
      {
         this._validTimes = value;
         dispatchEvent(new WeddingRoomEvent(WeddingRoomEvent.ROOM_VALIDETIME_CHANGE,this));
      }
      
      public function get currentNum() : uint
      {
         return this._currentNum;
      }
      
      public function set currentNum(value:uint) : void
      {
         this._currentNum = value;
      }
      
      public function get status() : String
      {
         return this._status;
      }
      
      public function set status(value:String) : void
      {
         if(this._status == value)
         {
            return;
         }
         this._status = value;
         dispatchEvent(new WeddingRoomEvent(WeddingRoomEvent.WEDDING_STATUS_CHANGE,this));
      }
      
      public function get roomType() : int
      {
         return this._roomType;
      }
      
      public function set roomType(value:int) : void
      {
         this._roomType = value;
      }
   }
}

