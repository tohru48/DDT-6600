package midAutumnWorshipTheMoon.model
{
   import midAutumnWorshipTheMoon.view.WorshipTheMoonMainFrame;
   
   public class WorshipTheMoonModel
   {
      
      private static var instance:WorshipTheMoonModel;
      
      private var _view:WorshipTheMoonMainFrame;
      
      private var _isopen:Boolean = false;
      
      private var _timesRemain:int = -1;
      
      private var _usedTimes:int = -1;
      
      private var _on200timesGainID:int;
      
      private var _currentMoonType:int;
      
      private var _awardsBoxInfoList:Vector.<WorshipTheMoonAwardsBoxInfo>;
      
      private var _itemsCanGainsIDList:Vector.<int>;
      
      private var _pricePerWorship:int;
      
      private var _isOnceBtnShowBuyTipThisLogin:Boolean = true;
      
      private var _isOnceBtnUseBindMoney:Boolean = false;
      
      private var _isTensBtnShowBuyTipThisLogin:Boolean = true;
      
      private var _isTensBtnUseBindMoney:Boolean = false;
      
      private var _timesGoingToWorship:int = 0;
      
      private var _state200AwardsBoxIcon:int;
      
      public function WorshipTheMoonModel(single:inner)
      {
         super();
      }
      
      public static function getInstance() : WorshipTheMoonModel
      {
         if(!instance)
         {
            instance = new WorshipTheMoonModel(new inner());
         }
         return instance;
      }
      
      public function init($view:WorshipTheMoonMainFrame) : void
      {
         this._view = $view;
      }
      
      public function dispose() : void
      {
         this._view = null;
      }
      
      public function getIsActivityOpen() : Boolean
      {
         return this._isopen;
      }
      
      public function onceBtnShowTipsAgain() : void
      {
         this._isOnceBtnShowBuyTipThisLogin = true;
      }
      
      public function tensBtnShowTipsAgain() : void
      {
         this._isTensBtnShowBuyTipThisLogin = true;
      }
      
      public function onceBtnNotShowBuyTipsAgainThisLogin(isUseBindMoney:Boolean) : void
      {
         this._isOnceBtnShowBuyTipThisLogin = false;
         this._isOnceBtnUseBindMoney = isUseBindMoney;
      }
      
      public function tensBtnNotShowBuyTipsAgainThisLogin(isUseBindMoney:Boolean) : void
      {
         this._isTensBtnShowBuyTipThisLogin = false;
         this._isTensBtnUseBindMoney = isUseBindMoney;
      }
      
      public function getPricePerWorship() : int
      {
         return this._pricePerWorship;
      }
      
      public function getIsOnceBtnShowBuyTipThisLogin() : Boolean
      {
         return this._isOnceBtnShowBuyTipThisLogin;
      }
      
      public function getIsTensBtnShowBuyTipThisLogin() : Boolean
      {
         return this._isTensBtnShowBuyTipThisLogin;
      }
      
      public function updateIsOnceBtnUseBindMoney(value:Boolean) : void
      {
         this._isOnceBtnUseBindMoney = value;
      }
      
      public function updateIsTensBtnUseBindMoney(value:Boolean) : void
      {
         this._isTensBtnUseBindMoney = value;
      }
      
      public function getIsOnceBtnUseBindMoney() : Boolean
      {
         return this._isOnceBtnUseBindMoney;
      }
      
      public function getIsTensBtnUseBindMoney() : Boolean
      {
         return this._isTensBtnUseBindMoney;
      }
      
      public function getNeedMoneyTimes(timesGoingToRequire:int) : int
      {
         return Math.max(0,timesGoingToRequire - this._timesRemain);
      }
      
      public function getNeedMoney(times:int) : int
      {
         return this._pricePerWorship * this.getNeedMoneyTimes(times);
      }
      
      public function getTimesRemain() : int
      {
         return this._timesRemain;
      }
      
      public function getUsedTimes() : int
      {
         return this._usedTimes;
      }
      
      public function getAwardsGainedBoxInfoList() : Vector.<WorshipTheMoonAwardsBoxInfo>
      {
         return this._awardsBoxInfoList;
      }
      
      public function getItemsCanGainsIDList() : Vector.<int>
      {
         return this._itemsCanGainsIDList;
      }
      
      public function getCurrentMoonType() : int
      {
         return this._currentMoonType;
      }
      
      public function get200TimesGainsID() : int
      {
         return this._on200timesGainID;
      }
      
      public function updateIsOpen(value:Boolean) : void
      {
         this._isopen = value;
      }
      
      public function updatePrice(value:int) : void
      {
         this._pricePerWorship = value;
      }
      
      public function update200TimesGain(id:int) : void
      {
         this._on200timesGainID = id;
         this._view.update200TimesGains();
      }
      
      public function updateFreeCounts(value:int) : void
      {
         this._timesRemain = value;
         this._view.updateTimesRemains();
      }
      
      public function updateWorshipedCounts(value:int) : void
      {
         this._usedTimes = value;
         this._view.updateUsedTimes();
      }
      
      public function update200State(gained:int) : void
      {
         if((gained + 1) * 800 - this._usedTimes > 0)
         {
            this._state200AwardsBoxIcon = 1;
         }
         else
         {
            this._state200AwardsBoxIcon = 2;
         }
         this._view.update200TimesGains();
      }
      
      public function canGain200AwardsBox() : int
      {
         return this._state200AwardsBoxIcon;
      }
      
      public function updateAwardsBoxInfoList(value:Vector.<WorshipTheMoonAwardsBoxInfo>) : void
      {
         this._awardsBoxInfoList = value;
         if(this._awardsBoxInfoList.length == 1)
         {
            this._currentMoonType = this._awardsBoxInfoList[0].moonType;
            this._view.playOnceAnimation();
         }
         else
         {
            this._view.playTenTimesAnimation();
         }
      }
      
      public function updateItemsCanGainsIDList(value:Vector.<int>) : void
      {
         this._itemsCanGainsIDList = value;
         this._view.updateAwardItemsCanGainList();
      }
   }
}

class inner
{
   
   public function inner()
   {
      super();
   }
}
