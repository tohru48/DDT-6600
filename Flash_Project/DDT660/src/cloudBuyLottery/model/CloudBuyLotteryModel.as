package cloudBuyLottery.model
{
   import cloudBuyLottery.view.WinningLogItemInfo;
   
   public class CloudBuyLotteryModel
   {
      
      private var _isOpen:Boolean;
      
      private var _luckTime:Date;
      
      public var myGiftData:Vector.<WinningLogItemInfo>;
      
      public var packsLen:int = 15;
      
      private var _moneyNum:int = 200;
      
      private var _templateId:int;
      
      private var _templatedIdCount:int;
      
      private var _validDate:int;
      
      private var _property:Array;
      
      private var _count:int;
      
      private var _buyGoodsIDArray:Array;
      
      private var _buyGoodsCountArray:Array;
      
      private var _buyMoney:int;
      
      private var _maxNum:int;
      
      private var _currentNum:int;
      
      private var _totalSeconds:int;
      
      private var _luckCount:int;
      
      private var _remainTimes:int;
      
      private var _luckDrawId:int;
      
      private var _isGame:Boolean;
      
      private var _isGetReward:Boolean;
      
      public function CloudBuyLotteryModel()
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
      
      public function get luckTime() : Date
      {
         return this._luckTime;
      }
      
      public function set luckTime(value:Date) : void
      {
         this._luckTime = value;
      }
      
      public function get moneyNum() : int
      {
         return this._moneyNum;
      }
      
      public function set moneyNum(value:int) : void
      {
         this._moneyNum = value;
      }
      
      public function get templateId() : int
      {
         return this._templateId;
      }
      
      public function set templateId(value:int) : void
      {
         this._templateId = value;
      }
      
      public function get validDate() : int
      {
         return this._validDate;
      }
      
      public function set validDate(value:int) : void
      {
         this._validDate = value;
      }
      
      public function get count() : int
      {
         return this._count;
      }
      
      public function set count(value:int) : void
      {
         this._count = value;
      }
      
      public function get buyGoodsIDArray() : Array
      {
         return this._buyGoodsIDArray;
      }
      
      public function set buyGoodsIDArray(value:Array) : void
      {
         this._buyGoodsIDArray = value;
      }
      
      public function get buyGoodsCountArray() : Array
      {
         return this._buyGoodsCountArray;
      }
      
      public function set buyGoodsCountArray(value:Array) : void
      {
         this._buyGoodsCountArray = value;
      }
      
      public function get buyMoney() : int
      {
         return this._buyMoney;
      }
      
      public function set buyMoney(value:int) : void
      {
         this._buyMoney = value;
      }
      
      public function get maxNum() : int
      {
         return this._maxNum;
      }
      
      public function set maxNum(value:int) : void
      {
         this._maxNum = value;
      }
      
      public function get currentNum() : int
      {
         return this._currentNum;
      }
      
      public function set currentNum(value:int) : void
      {
         this._currentNum = value;
      }
      
      public function get totalSeconds() : int
      {
         return this._totalSeconds;
      }
      
      public function set totalSeconds(value:int) : void
      {
         this._totalSeconds = value;
      }
      
      public function get luckCount() : int
      {
         return this._luckCount;
      }
      
      public function set luckCount(value:int) : void
      {
         this._luckCount = value;
      }
      
      public function get remainTimes() : int
      {
         return this._remainTimes;
      }
      
      public function set remainTimes(value:int) : void
      {
         this._remainTimes = value;
      }
      
      public function get property() : Array
      {
         return this._property;
      }
      
      public function set property(value:Array) : void
      {
         this._property = value;
      }
      
      public function get luckDrawId() : int
      {
         return this._luckDrawId;
      }
      
      public function set luckDrawId(value:int) : void
      {
         this._luckDrawId = value;
      }
      
      public function get isGame() : Boolean
      {
         return this._isGame;
      }
      
      public function set isGame(value:Boolean) : void
      {
         this._isGame = value;
      }
      
      public function get isGetReward() : Boolean
      {
         return this._isGetReward;
      }
      
      public function set isGetReward(value:Boolean) : void
      {
         this._isGetReward = value;
      }
      
      public function get templatedIdCount() : int
      {
         return this._templatedIdCount;
      }
      
      public function set templatedIdCount(value:int) : void
      {
         this._templatedIdCount = value;
      }
   }
}

