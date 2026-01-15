package auctionHouse.model
{
   import auctionHouse.AuctionState;
   import auctionHouse.event.AuctionHouseEvent;
   import ddt.data.auctionHouse.AuctionGoodsInfo;
   import ddt.data.goods.CateCoryInfo;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import road7th.data.DictionaryData;
   
   [Event(name="browseTypeChange",type="auctionHouse.event.AuctionHouseEvent")]
   [Event(name="updatePage",type="auctionHouse.event.AuctionHouseEvent")]
   [Event(name="addAuction",type="auctionHouse.event.AuctionHouseEvent")]
   [Event(name="deleteAuction",type="auctionHouse.event.AuctionHouseEvent")]
   [Event(name="getGoodCategory",type="auctionHouse.event.event.AuctionHouseEvent")]
   [Event(name="changeState",type="auctionHouse.event.AuctionHouseEvent")]
   public class AuctionHouseModel extends EventDispatcher
   {
      
      public static var searchType:int;
      
      public static var _dimBooble:Boolean;
      
      public static var SINGLE_PAGE_NUM:int = 20;
      
      private var _state:String;
      
      private var _categorys:Vector.<CateCoryInfo> = new Vector.<CateCoryInfo>();
      
      private var _myAuctionData:DictionaryData;
      
      private var _sellTotal:int;
      
      private var _sellCurrent:int;
      
      private var _browseAuctionData:DictionaryData;
      
      private var _browseTotal:int;
      
      private var _browseCurrent:int = 1;
      
      private var _currentBrowseGoodInfo:CateCoryInfo;
      
      private var _buyAuctionData:DictionaryData;
      
      private var _buyTotal:int;
      
      private var _buyCurrent:int = 1;
      
      public function AuctionHouseModel(target:IEventDispatcher = null)
      {
         super(target);
         this._state = AuctionState.BROWSE;
         this._myAuctionData = new DictionaryData();
         this._browseAuctionData = new DictionaryData();
         this._buyAuctionData = new DictionaryData();
      }
      
      public function get state() : String
      {
         return this._state;
      }
      
      public function set state(value:String) : void
      {
         this._state = value;
         dispatchEvent(new AuctionHouseEvent(AuctionHouseEvent.CHANGE_STATE));
      }
      
      public function get category() : Vector.<CateCoryInfo>
      {
         return this._categorys.slice(0);
      }
      
      public function set category(value:Vector.<CateCoryInfo>) : void
      {
         this._categorys = value;
         if(value.length != 0)
         {
            dispatchEvent(new AuctionHouseEvent(AuctionHouseEvent.GET_GOOD_CATEGORY));
         }
      }
      
      public function getCatecoryById(id:int) : CateCoryInfo
      {
         var info:CateCoryInfo = null;
         for each(info in this._categorys)
         {
            if(info.ID == id)
            {
               return info;
            }
         }
         return null;
      }
      
      public function get myAuctionData() : DictionaryData
      {
         return this._myAuctionData;
      }
      
      public function addMyAuction(info:AuctionGoodsInfo) : void
      {
         if(this._state == AuctionState.SELL)
         {
            this._myAuctionData.add(info.AuctionID,info);
         }
         else if(this._state == AuctionState.BROWSE)
         {
            this._browseAuctionData.add(info.AuctionID,info);
         }
         else if(this._state == AuctionState.BUY)
         {
            this._buyAuctionData.add(info.AuctionID,info);
         }
      }
      
      public function clearMyAuction() : void
      {
         this._myAuctionData.clear();
      }
      
      public function removeMyAuction(info:AuctionGoodsInfo) : void
      {
         if(this._state == AuctionState.SELL)
         {
            this._myAuctionData.remove(info.AuctionID);
         }
         else if(this._state == AuctionState.BROWSE)
         {
            this._browseAuctionData.remove(info.AuctionID);
         }
         else if(this._state == AuctionState.BUY)
         {
            this._buyAuctionData.remove(info.AuctionID);
         }
      }
      
      public function set sellTotal(value:int) : void
      {
         this._sellTotal = value;
         dispatchEvent(new AuctionHouseEvent(AuctionHouseEvent.UPDATE_PAGE));
      }
      
      public function get sellTotal() : int
      {
         return this._sellTotal;
      }
      
      public function get sellTotalPage() : int
      {
         return Math.ceil(this._sellTotal / SINGLE_PAGE_NUM);
      }
      
      public function set sellCurrent(value:int) : void
      {
         this._sellCurrent = value;
      }
      
      public function get sellCurrent() : int
      {
         return this._sellCurrent;
      }
      
      public function get browseAuctionData() : DictionaryData
      {
         return this._browseAuctionData;
      }
      
      public function addBrowseAuctionData(info:AuctionGoodsInfo) : void
      {
         this._browseAuctionData.add(info.AuctionID,info);
      }
      
      public function clearBrowseAuctionData() : void
      {
         this._browseAuctionData.clear();
      }
      
      public function removeBrowseAuctionData(info:AuctionGoodsInfo) : void
      {
         this._browseAuctionData.remove(info.AuctionID);
      }
      
      public function set browseTotal(value:int) : void
      {
         this._browseTotal = value;
         dispatchEvent(new AuctionHouseEvent(AuctionHouseEvent.UPDATE_PAGE));
      }
      
      public function get browseTotal() : int
      {
         return this._browseTotal;
      }
      
      public function get browseTotalPage() : int
      {
         return Math.ceil(this._browseTotal / SINGLE_PAGE_NUM);
      }
      
      public function set browseCurrent(value:int) : void
      {
         this._browseCurrent = value;
      }
      
      public function get browseCurrent() : int
      {
         return this._browseCurrent;
      }
      
      public function get currentBrowseGoodInfo() : CateCoryInfo
      {
         return this._currentBrowseGoodInfo;
      }
      
      public function set currentBrowseGoodInfo(value:CateCoryInfo) : void
      {
         this._currentBrowseGoodInfo = value;
         this._browseCurrent = 1;
         dispatchEvent(new AuctionHouseEvent(AuctionHouseEvent.BROWSE_TYPE_CHANGE));
      }
      
      public function get buyAuctionData() : DictionaryData
      {
         return this._buyAuctionData;
      }
      
      public function addBuyAuctionData(info:AuctionGoodsInfo) : void
      {
         this._buyAuctionData.add(info.AuctionID,info);
      }
      
      public function removeBuyAuctionData(info:AuctionGoodsInfo) : void
      {
         this._buyAuctionData.remove(info);
      }
      
      public function clearBuyAuctionData() : void
      {
         this._buyAuctionData.clear();
      }
      
      public function set buyTotal(value:int) : void
      {
         this._buyTotal = value;
         dispatchEvent(new AuctionHouseEvent(AuctionHouseEvent.UPDATE_PAGE));
      }
      
      public function get buyTotal() : int
      {
         return this._buyTotal;
      }
      
      public function get buyTotalPage() : int
      {
         return Math.ceil(this._buyTotal / 50);
      }
      
      public function set buyCurrent(value:int) : void
      {
         this._buyCurrent = value;
      }
      
      public function get buyCurrent() : int
      {
         return this._buyCurrent;
      }
      
      public function dispose() : void
      {
         this._categorys = new Vector.<CateCoryInfo>();
         if(Boolean(this._myAuctionData))
         {
            this._myAuctionData.clear();
         }
         this._myAuctionData = null;
         if(Boolean(this._browseAuctionData))
         {
            this._browseAuctionData.clear();
         }
         this._browseAuctionData = null;
         if(Boolean(this._buyAuctionData))
         {
            this._buyAuctionData.clear();
         }
         this._buyAuctionData = null;
      }
   }
}

