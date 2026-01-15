package labyrinth.data
{
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import road7th.data.DictionaryData;
   
   public class LabyrinthModel extends EventDispatcher
   {
      
      private var _myProgress:int;
      
      private var _myRanking:int;
      
      private var _completeChallenge:Boolean;
      
      private var _isDoubleAward:Boolean = true;
      
      private var _rankingList:Array;
      
      private var _currentFloor:int;
      
      private var _accumulateExp:int;
      
      private var _cleanOutInfos:DictionaryData = new DictionaryData();
      
      private var _remainTime:int;
      
      private var _currentRemainTime:int;
      
      private var _cleanOutAllTime:int;
      
      private var _cleanOutGold:int;
      
      private var _tryAgainComplete:Boolean;
      
      private var _isInGame:Boolean;
      
      private var _isCleanOut:Boolean;
      
      private var _serverMultiplyingPower:Boolean;
      
      public function LabyrinthModel(target:IEventDispatcher = null)
      {
         super(target);
      }
      
      public function get myRanking() : int
      {
         return this._myRanking;
      }
      
      public function set myRanking(value:int) : void
      {
         this._myRanking = value;
      }
      
      public function get myProgress() : int
      {
         return this._myProgress;
      }
      
      public function set myProgress(value:int) : void
      {
         this._myProgress = value;
      }
      
      public function get completeChallenge() : Boolean
      {
         return this._completeChallenge;
      }
      
      public function set completeChallenge(value:Boolean) : void
      {
         this._completeChallenge = value;
      }
      
      public function get isDoubleAward() : Boolean
      {
         return this._isDoubleAward;
      }
      
      public function set isDoubleAward(value:Boolean) : void
      {
         this._isDoubleAward = value;
      }
      
      public function get rankingList() : Array
      {
         return this._rankingList;
      }
      
      public function set rankingList(value:Array) : void
      {
         this._rankingList = value;
      }
      
      public function get currentFloor() : int
      {
         return this._currentFloor;
      }
      
      public function set currentFloor(value:int) : void
      {
         this._currentFloor = value;
      }
      
      public function get accumulateExp() : int
      {
         return this._accumulateExp;
      }
      
      public function set accumulateExp(value:int) : void
      {
         this._accumulateExp = value;
      }
      
      public function get cleanOutInfos() : DictionaryData
      {
         return this._cleanOutInfos;
      }
      
      public function set cleanOutInfos(value:DictionaryData) : void
      {
         this._cleanOutInfos = value;
      }
      
      public function get remainTime() : int
      {
         return this._remainTime;
      }
      
      public function set remainTime(value:int) : void
      {
         this._remainTime = value;
      }
      
      public function get cleanOutAllTime() : int
      {
         return this._cleanOutAllTime;
      }
      
      public function set cleanOutAllTime(value:int) : void
      {
         this._cleanOutAllTime = value;
      }
      
      public function get cleanOutGold() : int
      {
         return this._cleanOutGold;
      }
      
      public function set cleanOutGold(value:int) : void
      {
         this._cleanOutGold = value;
      }
      
      public function get currentRemainTime() : int
      {
         return this._currentRemainTime;
      }
      
      public function set currentRemainTime(value:int) : void
      {
         this._currentRemainTime = value;
      }
      
      public function get tryAgainComplete() : Boolean
      {
         return this._tryAgainComplete;
      }
      
      public function set tryAgainComplete(value:Boolean) : void
      {
         this._tryAgainComplete = value;
      }
      
      public function get isInGame() : Boolean
      {
         return this._isInGame;
      }
      
      public function set isInGame(value:Boolean) : void
      {
         this._isInGame = value;
      }
      
      public function get isCleanOut() : Boolean
      {
         return this._isCleanOut;
      }
      
      public function set isCleanOut(value:Boolean) : void
      {
         this._isCleanOut = value;
      }
      
      public function get serverMultiplyingPower() : Boolean
      {
         return this._serverMultiplyingPower;
      }
      
      public function set serverMultiplyingPower(value:Boolean) : void
      {
         this._serverMultiplyingPower = value;
      }
   }
}

