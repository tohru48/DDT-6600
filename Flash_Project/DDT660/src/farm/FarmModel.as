package farm
{
   import ddt.data.BagInfo;
   import ddt.data.EquipType;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.manager.PlayerManager;
   import ddt.manager.TimeManager;
   import farm.modelx.FieldVO;
   import farm.modelx.SuperPetFoodPriceInfo;
   import farm.view.compose.vo.FoodComposeListTemplateInfo;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import flash.utils.Dictionary;
   import road7th.data.DictionaryData;
   
   public class FarmModel extends EventDispatcher
   {
      
      public var FarmTreeLevel:int;
      
      public var farmPoultryInfo:Dictionary;
      
      public var PoultryState:int;
      
      public var SelectIndex:int;
      
      public var payFieldMoney:String;
      
      public var payAutoMoney:String;
      
      public var autoPayTime:Date;
      
      public var autoValidDate:int;
      
      public var vipLimitLevel:int;
      
      private var _stopTime:Date;
      
      private var _isArrange:Boolean;
      
      public var helperArray:Array;
      
      private var _currentFarmerId:int;
      
      public var currentFarmerName:String;
      
      public var fieldsInfo:Vector.<FieldVO>;
      
      public var seedingFieldInfo:FieldVO;
      
      public var selfFieldsInfo:Vector.<FieldVO>;
      
      public var gainFieldId:int;
      
      public var payFieldIDs:Array;
      
      public var matureId:int;
      
      public var killCropId:int;
      
      public var isAutoId:int;
      
      public var batchFieldIDArray:Array;
      
      public var foodComposeList:Vector.<FoodComposeListTemplateInfo>;
      
      private var _friendStateList:DictionaryData;
      
      private var _friendStateListStolenInfo:DictionaryData;
      
      private var _buyExpRemainNum:int;
      
      private var _priceList:Vector.<SuperPetFoodPriceInfo>;
      
      public function FarmModel(target:IEventDispatcher = null)
      {
         super(target);
      }
      
      public function get payFieldDiscount() : int
      {
         if(Boolean(this.payFieldMoney.split("|")[2]))
         {
            return parseInt(this.payFieldMoney.split("|")[2]);
         }
         return 100;
      }
      
      public function get payFieldMoneyToWeek() : int
      {
         return parseInt(this.payFieldMoney.split("|")[0].split(",")[1]);
      }
      
      public function get payFieldTimeToWeek() : int
      {
         return parseInt(this.payFieldMoney.split("|")[0].split(",")[0]);
      }
      
      public function get payFieldMoneyToMonth() : int
      {
         return parseInt(this.payFieldMoney.split("|")[1].split(",")[1]);
      }
      
      public function get payFieldTimeToMonth() : int
      {
         return parseInt(this.payFieldMoney.split("|")[1].split(",")[0]);
      }
      
      public function get payAutoMoneyToWeek() : int
      {
         return parseInt(this.payAutoMoney.split("|")[0].split(",")[1]);
      }
      
      public function get payAutoTimeToWeek() : int
      {
         return parseInt(this.payAutoMoney.split("|")[0].split(",")[0]);
      }
      
      public function get payAutoMoneyToMonth() : int
      {
         return parseInt(this.payAutoMoney.split("|")[1].split(",")[1]);
      }
      
      public function get payAutoTimeToMonth() : int
      {
         return parseInt(this.payAutoMoney.split("|")[1].split(",")[0]);
      }
      
      public function get isArrange() : Boolean
      {
         return this._isArrange;
      }
      
      public function set isArrange(value:Boolean) : void
      {
         this._isArrange = value;
      }
      
      public function get isHelperMay() : Boolean
      {
         return (TimeManager.Instance.Now().time - this.autoPayTime.time) / 3600000 <= this.autoValidDate;
      }
      
      public function get stopTime() : Date
      {
         this._stopTime = new Date();
         var time:Number = this.autoPayTime.time + this.autoValidDate * 60 * 60 * 1000;
         this._stopTime.setTime(time);
         return this._stopTime;
      }
      
      public function get currentFarmerId() : int
      {
         return this._currentFarmerId;
      }
      
      public function set currentFarmerId(value:int) : void
      {
         this._currentFarmerId = value;
      }
      
      public function getfieldInfoById(fieldId:int) : FieldVO
      {
         var field:FieldVO = null;
         for each(field in this.fieldsInfo)
         {
            if(field.fieldID == fieldId)
            {
               return field;
            }
         }
         return null;
      }
      
      public function get friendStateList() : DictionaryData
      {
         if(this._friendStateList == null)
         {
            this._friendStateList = new DictionaryData();
         }
         return this._friendStateList;
      }
      
      public function set friendStateList(value:DictionaryData) : void
      {
         this._friendStateList = value;
      }
      
      public function get friendStateListStolenInfo() : DictionaryData
      {
         if(this._friendStateListStolenInfo == null)
         {
            this._friendStateListStolenInfo = new DictionaryData();
         }
         return this._friendStateListStolenInfo;
      }
      
      public function set friendStateListStolenInfo(value:DictionaryData) : void
      {
         this._friendStateListStolenInfo = value;
      }
      
      public function findItemInfo(equipType:int, templateID:int) : InventoryItemInfo
      {
         var item:InventoryItemInfo = null;
         var itemInfo:InventoryItemInfo = null;
         var arr:Array = PlayerManager.Instance.Self.getBag(BagInfo.FARM).findItems(equipType);
         for each(item in arr)
         {
            if(item.TemplateID == templateID)
            {
               itemInfo = item;
               break;
            }
         }
         return itemInfo;
      }
      
      public function getSeedCountByID(templateID:int) : int
      {
         var item:InventoryItemInfo = null;
         var allCount:int = 0;
         var arr:Array = PlayerManager.Instance.Self.getBag(BagInfo.FARM).findItems(EquipType.SEED);
         for each(item in arr)
         {
            if(item.TemplateID == templateID)
            {
               allCount += item.Count;
            }
         }
         return allCount;
      }
      
      public function get buyExpRemainNum() : int
      {
         return this._buyExpRemainNum;
      }
      
      public function set buyExpRemainNum(value:int) : void
      {
         this._buyExpRemainNum = value;
      }
      
      public function get priceList() : Vector.<SuperPetFoodPriceInfo>
      {
         return this._priceList;
      }
      
      public function set priceList(value:Vector.<SuperPetFoodPriceInfo>) : void
      {
         this._priceList = value;
      }
   }
}

