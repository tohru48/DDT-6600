package newYearRice.model
{
   import newYearRice.view.NewYearRiceOpenFrameView;
   
   public class NewYearRiceModel
   {
      
      private var _isOpen:Boolean;
      
      private var _playerNum:int;
      
      private var _currentNum:Array = [10,20,30,40];
      
      private var _maxNum:Array = [40,40,40,40];
      
      private var _itemInfoList:Array;
      
      private var _yearFoodInfo:int;
      
      private var _playersLength:int;
      
      private var _playersArray:Array;
      
      private var _roomType:int;
      
      private var _openFrameView:NewYearRiceOpenFrameView;
      
      private var _playerID:int;
      
      private var _playerName:String;
      
      public function NewYearRiceModel()
      {
         super();
      }
      
      public function get isOpen() : Boolean
      {
         return this._isOpen;
      }
      
      public function set isOpen(value:Boolean) : void
      {
         this._isOpen = value;
      }
      
      public function get currentNum() : Array
      {
         return this._currentNum;
      }
      
      public function set currentNum(value:Array) : void
      {
         this._currentNum = value;
      }
      
      public function get maxNum() : Array
      {
         return this._maxNum;
      }
      
      public function set maxNum(value:Array) : void
      {
         this._maxNum = value;
      }
      
      public function get itemInfoList() : Array
      {
         return this._itemInfoList;
      }
      
      public function set itemInfoList(value:Array) : void
      {
         this._itemInfoList = value;
      }
      
      public function get yearFoodInfo() : int
      {
         return this._yearFoodInfo;
      }
      
      public function set yearFoodInfo(value:int) : void
      {
         this._yearFoodInfo = value;
      }
      
      public function get playerNum() : int
      {
         return this._playerNum;
      }
      
      public function set playerNum(value:int) : void
      {
         this._playerNum = value;
      }
      
      public function get playersLength() : int
      {
         return this._playersLength;
      }
      
      public function get playersArray() : Array
      {
         return this._playersArray;
      }
      
      public function set playersArray(value:Array) : void
      {
         this._playersArray = value;
      }
      
      public function get openFrameView() : NewYearRiceOpenFrameView
      {
         return this._openFrameView;
      }
      
      public function set openFrameView(value:NewYearRiceOpenFrameView) : void
      {
         this._openFrameView = value;
      }
      
      public function set playersLength(value:int) : void
      {
         this._playersLength = value;
      }
      
      public function get roomType() : int
      {
         return this._roomType;
      }
      
      public function set roomType(value:int) : void
      {
         this._roomType = value;
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
   }
}

