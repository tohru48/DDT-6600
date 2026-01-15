package luckStar.model
{
   import ddt.data.goods.InventoryItemInfo;
   import flash.events.EventDispatcher;
   import luckStar.event.LuckStarEvent;
   
   public class LuckStarModel extends EventDispatcher
   {
      
      private var _rank:Array;
      
      private var _reward:Vector.<InventoryItemInfo>;
      
      private var _goods:Vector.<InventoryItemInfo>;
      
      private var _newRewardList:Vector.<Array>;
      
      private var _coins:int = 0;
      
      private var _activityDate:Array;
      
      private var _selfInfo:LuckStarPlayerInfo;
      
      private var _lastDate:String;
      
      private var _minUseNum:int;
      
      public function LuckStarModel()
      {
         super();
         this._goods = new Vector.<InventoryItemInfo>();
      }
      
      public function set reward(value:Vector.<InventoryItemInfo>) : void
      {
         this._reward = value;
      }
      
      public function set rank(value:Array) : void
      {
         this._rank = value;
      }
      
      public function set newRewardList(value:Vector.<Array>) : void
      {
         this._newRewardList = value;
         dispatchEvent(new LuckStarEvent(LuckStarEvent.NEW_REWARD_LIST));
      }
      
      public function set goods(value:Vector.<InventoryItemInfo>) : void
      {
         this._goods = value;
         dispatchEvent(new LuckStarEvent(LuckStarEvent.GOODS));
      }
      
      public function set coins(value:int) : void
      {
         if(this._coins == value)
         {
            return;
         }
         this._coins = value;
         dispatchEvent(new LuckStarEvent(LuckStarEvent.COINS));
      }
      
      public function setActivityDate(startDate:Date, endDate:Date) : void
      {
         if(this._activityDate == null)
         {
            this._activityDate = new Array(2);
         }
         this._activityDate[0] = startDate;
         this._activityDate[1] = endDate;
      }
      
      public function set selfInfo(value:LuckStarPlayerInfo) : void
      {
         this._selfInfo = value;
      }
      
      public function set lastDate(value:String) : void
      {
         this._lastDate = value;
      }
      
      public function get lastDate() : String
      {
         return this._lastDate;
      }
      
      public function get selfInfo() : LuckStarPlayerInfo
      {
         return this._selfInfo;
      }
      
      public function get activityDate() : Array
      {
         return this._activityDate;
      }
      
      public function get rank() : Array
      {
         return this._rank;
      }
      
      public function get goods() : Vector.<InventoryItemInfo>
      {
         return this._goods;
      }
      
      public function get reward() : Vector.<InventoryItemInfo>
      {
         return this._reward;
      }
      
      public function get newRewardList() : Vector.<Array>
      {
         return this._newRewardList;
      }
      
      public function get coins() : int
      {
         return this._coins;
      }
      
      public function set minUseNum(value:int) : void
      {
         this._minUseNum = value;
      }
      
      public function get minUseNum() : int
      {
         return this._minUseNum;
      }
   }
}

