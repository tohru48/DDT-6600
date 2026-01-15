package ddt.data
{
   public class HotSpringRoomInfo
   {
      
      private var _roomID:int;
      
      private var _roomNumber:int;
      
      private var _roomType:int;
      
      private var _roomName:String;
      
      private var _playerID:int;
      
      private var _playerName:String;
      
      private var _roomIsPassword:Boolean;
      
      private var _roomPassword:String;
      
      private var _effectiveTime:int;
      
      private var _maxCount:int;
      
      private var _curCount:int;
      
      private var _mapIndex:int;
      
      private var _startTime:Date;
      
      private var _breakTime:Date;
      
      private var _roomIntroduction:String;
      
      private var _serverID:int;
      
      public function HotSpringRoomInfo()
      {
         super();
      }
      
      public function get roomID() : int
      {
         return this._roomID;
      }
      
      public function set roomID(value:int) : void
      {
         this._roomID = value;
      }
      
      public function get roomType() : int
      {
         return this._roomType;
      }
      
      public function set roomType(value:int) : void
      {
         this._roomType = value;
      }
      
      public function get roomName() : String
      {
         return this._roomName;
      }
      
      public function set roomName(value:String) : void
      {
         this._roomName = value;
      }
      
      public function get playerID() : int
      {
         return this._playerID;
      }
      
      public function set playerID(value:int) : void
      {
         this._playerID = value;
      }
      
      public function get playerName() : String
      {
         return this._playerName;
      }
      
      public function set playerName(value:String) : void
      {
         this._playerName = value;
      }
      
      public function get roomIsPassword() : Boolean
      {
         return this._roomIsPassword;
      }
      
      public function set roomIsPassword(value:Boolean) : void
      {
         this._roomIsPassword = value;
      }
      
      public function get roomPassword() : String
      {
         return this._roomPassword;
      }
      
      public function set roomPassword(value:String) : void
      {
         this._roomPassword = value;
         this._roomIsPassword = Boolean(this._roomPassword) && this._roomPassword != "" && this._roomPassword.length > 0;
      }
      
      public function get effectiveTime() : int
      {
         return this._effectiveTime;
      }
      
      public function set effectiveTime(value:int) : void
      {
         this._effectiveTime = value;
      }
      
      public function get maxCount() : int
      {
         return this._maxCount;
      }
      
      public function set maxCount(value:int) : void
      {
         this._maxCount = value;
      }
      
      public function get curCount() : int
      {
         return this._curCount;
      }
      
      public function set curCount(value:int) : void
      {
         this._curCount = value;
      }
      
      public function get startTime() : Date
      {
         return this._startTime;
      }
      
      public function set startTime(value:Date) : void
      {
         this._startTime = value;
      }
      
      public function get breakTime() : Date
      {
         return this._breakTime;
      }
      
      public function set breakTime(value:Date) : void
      {
         this._breakTime = value;
      }
      
      public function get roomIntroduction() : String
      {
         return this._roomIntroduction;
      }
      
      public function set roomIntroduction(value:String) : void
      {
         this._roomIntroduction = value;
      }
      
      public function get serverID() : int
      {
         return this._serverID;
      }
      
      public function set serverID(value:int) : void
      {
         this._serverID = value;
      }
      
      public function get roomNumber() : int
      {
         return this._roomNumber;
      }
      
      public function set roomNumber(value:int) : void
      {
         this._roomNumber = value;
      }
   }
}

