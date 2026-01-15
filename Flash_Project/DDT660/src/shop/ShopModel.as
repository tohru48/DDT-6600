package shop
{
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.EquipType;
   import ddt.data.ShopType;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ItemPrice;
   import ddt.data.goods.ShopCarItemInfo;
   import ddt.data.goods.ShopItemInfo;
   import ddt.data.player.PlayerInfo;
   import ddt.data.player.SelfInfo;
   import ddt.events.BagEvent;
   import ddt.events.PlayerPropertyEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.ShopManager;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.utils.Dictionary;
   import road7th.data.DictionaryData;
   
   public class ShopModel extends EventDispatcher
   {
      
      private static var DEFAULT_MAN_STYLE:String = "1101,2101,3101,4101,5101,6101,7001,13101,15001";
      
      private static var DEFAULT_WOMAN_STYLE:String = "1201,2201,3201,4201,5201,6201,7002,13201,15001";
      
      public static const SHOP_CART_MAX_LENGTH:uint = 20;
      
      public var leftCarList:Array = [];
      
      public var leftManList:Array = [];
      
      public var isBandList:Array = [];
      
      public var leftWomanList:Array = [];
      
      private var _bodyThings:DictionaryData;
      
      private var _carList:Array;
      
      private var _currentGift:int;
      
      private var _currentGold:int;
      
      private var _currentMedal:int;
      
      private var _currentMoney:int;
      
      private var _totalGold:int;
      
      private var _totalMedal:int;
      
      private var _totalMoney:int;
      
      private var _defaultModel:int;
      
      private var _manMemoryList:Array;
      
      private var _manModel:PlayerInfo;
      
      private var _manTempList:Array;
      
      private var _womanMemoryList:Array;
      
      private var _womanModel:PlayerInfo;
      
      private var _womanTempList:Array;
      
      private var _manHistoryList:Array;
      
      private var _womanHistoryList:Array;
      
      private var _self:SelfInfo;
      
      private var _sex:Boolean;
      
      private var _totalGift:int;
      
      private var maleCollocation:Array;
      
      private var femaleCollocation:Array;
      
      public function ShopModel()
      {
         super();
         this._self = PlayerManager.Instance.Self;
         this._womanModel = new PlayerInfo();
         this._manModel = new PlayerInfo();
         this._womanTempList = [];
         this._manTempList = [];
         this._carList = [];
         this._manMemoryList = [];
         this._womanMemoryList = [];
         this._manHistoryList = [];
         this._womanHistoryList = [];
         this._totalGold = 0;
         this._totalMoney = 0;
         this._totalGift = 0;
         this._totalMedal = 0;
         this._defaultModel = 1;
         this.init();
         this.fittingSex = this._self.Sex;
         this._self.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__styleChange);
         this._self.Bag.addEventListener(BagEvent.UPDATE,this.__bagChange);
         this.initRandom();
      }
      
      public function removeLatestItem() : void
      {
         var arr:Array = null;
         var item:ShopCarItemInfo = null;
         var arr1:Array = null;
         var shopitem:ShopCarItemInfo = null;
         var index:int = 0;
         var list:Array = this._sex ? this._manTempList : this._womanTempList;
         if(this.currentHistoryList.length > 0)
         {
            arr = this.currentHistoryList.pop();
            for each(item in arr)
            {
               this.removeTempEquip(item);
            }
         }
         for(var i:int = this.currentHistoryList.length - 1; i > -1; i--)
         {
            arr1 = this.currentHistoryList[i];
            for each(shopitem in arr1)
            {
               index = this.currentTempListHasItem(shopitem.TemplateInfo.CategoryID);
               if(index <= -1)
               {
                  this.currentTempList.push(shopitem);
                  dispatchEvent(new ShopEvent(ShopEvent.ADD_TEMP_EQUIP,shopitem));
                  shopitem.addEventListener(Event.CHANGE,this.__onItemChange);
               }
            }
         }
         this.updateCost();
      }
      
      private function currentTempListHasItem(categoryID:int) : int
      {
         var item:ShopCarItemInfo = null;
         var items:Array = this.currentTempList;
         for each(item in items)
         {
            if(item.TemplateInfo.CategoryID == categoryID)
            {
               return items.indexOf(item);
            }
         }
         return -1;
      }
      
      public function get currentHistoryList() : Array
      {
         return this._sex ? this._manHistoryList : this._womanHistoryList;
      }
      
      private function initRandom() : void
      {
         this.maleCollocation = [];
         this.femaleCollocation = [];
         this.maleCollocation.push(ShopManager.Instance.getValidGoodByType(ShopType.MONEY_M_CLOTH));
         this.maleCollocation.push(ShopManager.Instance.getValidGoodByType(ShopType.MONEY_M_HAT));
         this.maleCollocation.push(ShopManager.Instance.getValidGoodByType(ShopType.MONEY_M_GLASS));
         this.maleCollocation.push(ShopManager.Instance.getValidGoodByType(ShopType.MONEY_M_HAIR));
         this.maleCollocation.push(ShopManager.Instance.getValidGoodByType(ShopType.MONEY_M_EYES));
         this.maleCollocation.push(ShopManager.Instance.getValidGoodByType(ShopType.MONEY_M_WING));
         this.maleCollocation.push(ShopManager.Instance.getValidGoodByType(ShopType.MONEY_M_LIANSHI));
         this.femaleCollocation.push(ShopManager.Instance.getValidGoodByType(ShopType.MONEY_F_CLOTH));
         this.femaleCollocation.push(ShopManager.Instance.getValidGoodByType(ShopType.MONEY_F_HAT));
         this.femaleCollocation.push(ShopManager.Instance.getValidGoodByType(ShopType.MONEY_F_GLASS));
         this.femaleCollocation.push(ShopManager.Instance.getValidGoodByType(ShopType.MONEY_F_HAIR));
         this.femaleCollocation.push(ShopManager.Instance.getValidGoodByType(ShopType.MONEY_F_EYES));
         this.femaleCollocation.push(ShopManager.Instance.getValidGoodByType(ShopType.MONEY_F_WING));
         this.femaleCollocation.push(ShopManager.Instance.getValidGoodByType(ShopType.MONEY_F_LIANSHI));
      }
      
      public function random() : void
      {
         var vect:Vector.<ShopItemInfo> = null;
         var index:int = 0;
         var list:Array = this._sex ? this.maleCollocation : this.femaleCollocation;
         var result:Array = [];
         for each(vect in list)
         {
            index = Math.floor(Math.random() * vect.length);
            result.push(this.fillToShopCarInfo(vect[index]));
         }
         this.addTempEquip(result);
         this.updateCost();
      }
      
      public function get Self() : SelfInfo
      {
         return this._self;
      }
      
      public function isCarListMax() : Boolean
      {
         return this._carList.length + this._manTempList.length + this._womanTempList.length >= SHOP_CART_MAX_LENGTH;
      }
      
      public function addTempEquip(item:*) : Boolean
      {
         var items:Array = null;
         var history:Array = null;
         var shopitem:ShopItemInfo = null;
         var index:int = 0;
         var t:ShopCarItemInfo = null;
         var index1:int = 0;
         var tt:ShopCarItemInfo = null;
         var cantAdd:Boolean = this.isCarListMax();
         if(cantAdd)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("shop.ShopIIModel.car"));
            return cantAdd;
         }
         if(item is Array)
         {
            items = item as Array;
            history = [];
            for each(shopitem in items)
            {
               index = this.currentTempListHasItem(shopitem.TemplateInfo.CategoryID);
               if(index > -1)
               {
                  this.currentTempList.splice(index,1);
               }
               t = this.fillToShopCarInfo(shopitem);
               t.dressing = true;
               t.ModelSex = this.currentModel.Sex;
               this.currentTempList.push(t);
               dispatchEvent(new ShopEvent(ShopEvent.ADD_TEMP_EQUIP,t));
               this.updateCost();
               t.addEventListener(Event.CHANGE,this.__onItemChange);
               history.push(t);
            }
            this.currentHistoryList.push(history);
         }
         else
         {
            index1 = this.currentTempListHasItem(item.TemplateInfo.CategoryID);
            if(index1 > -1)
            {
               this.currentTempList.splice(index1,1);
            }
            tt = this.fillToShopCarInfo(item);
            tt.dressing = true;
            tt.ModelSex = this.currentModel.Sex;
            this.currentTempList.push(tt);
            dispatchEvent(new ShopEvent(ShopEvent.ADD_TEMP_EQUIP,tt));
            this.updateCost();
            tt.addEventListener(Event.CHANGE,this.__onItemChange);
            this.currentHistoryList.push([tt]);
         }
         return !cantAdd;
      }
      
      public function addToShoppingCar(item:ShopCarItemInfo) : void
      {
         if(this.isCarListMax())
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("shop.ShopIIModel.car"));
            return;
         }
         if(this.isOverCount(item))
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("shop.ShopIIModel.GoodsNumberLimit"));
            return;
         }
         this._carList.push(item);
         this.updateCost();
         item.addEventListener(Event.CHANGE,this.__onItemChange);
         dispatchEvent(new ShopEvent(ShopEvent.ADD_CAR_EQUIP,item));
      }
      
      private function __onItemChange(evt:Event) : void
      {
         this.updateCost();
      }
      
      public function isOverCount(info:ShopItemInfo) : Boolean
      {
         var item:ShopCarItemInfo = null;
         var count:uint = 0;
         var arr:Array = this.allItems;
         for(var i:int = 0; i < arr.length; i++)
         {
            item = arr[i] as ShopCarItemInfo;
            if(info.TemplateID == item.TemplateID)
            {
               count++;
            }
         }
         return count >= info.LimitCount && info.LimitCount != -1 ? true : false;
      }
      
      public function get allItems() : Array
      {
         return this._carList.concat(this._manTempList).concat(this._womanTempList);
      }
      
      public function get allItemsCount() : int
      {
         return this._carList.length + this._manTempList.length + this._womanTempList.length;
      }
      
      public function calcPrices(list:Array, list2:Array = null) : Array
      {
         var totalPrice:ItemPrice = new ItemPrice(null,null,null);
         var g:int = 0;
         var m:int = 0;
         var b:int = 0;
         for(var i:int = 0; i < list.length; i++)
         {
            if(Boolean(list2))
            {
               if(Boolean(list2[i]))
               {
                  totalPrice.addItemPrice(list[i].getCurrentPrice(),list2[i]);
               }
               else
               {
                  totalPrice.addItemPrice(list[i].getCurrentPrice());
               }
            }
            else
            {
               totalPrice.addItemPrice(list[i].getCurrentPrice());
            }
         }
         g = totalPrice.goldValue;
         m = totalPrice.moneyValue;
         b = totalPrice.bandDdtMoneyValue;
         return [g,m,0,b];
      }
      
      public function canBuyLeastOneGood(array:Array) : Boolean
      {
         return ShopManager.Instance.buyLeastGood(array,this._self);
      }
      
      public function canChangSkin() : Boolean
      {
         var list:Array = this.currentTempList;
         for(var i:int = 0; i < list.length; i++)
         {
            if(list[i].CategoryID == EquipType.FACE)
            {
               return true;
            }
         }
         return false;
      }
      
      public function clearAllitems() : void
      {
         this._carList = [];
         this._defaultModel = 1;
         this._manTempList = [];
         this._womanTempList = [];
         this.updateCost();
         dispatchEvent(new ShopEvent(ShopEvent.UPDATE_CAR));
         this.init();
      }
      
      public function clearCurrentTempList(sex:int = 0) : void
      {
         var list:Array = null;
         if(sex == 0)
         {
            list = this._sex ? this._manTempList : this._womanTempList;
            list.splice(0,list.length);
         }
         else if(sex == 1)
         {
            this._manTempList.splice(0,this._manTempList.length);
         }
         else if(sex == 2)
         {
            this._womanTempList.splice(0,this._womanTempList.length);
         }
         this.updateCost();
         dispatchEvent(new ShopEvent(ShopEvent.UPDATE_CAR));
         this.init();
      }
      
      public function clearLeftList() : void
      {
         this.leftCarList = [];
         this.leftManList = [];
         this.leftWomanList = [];
      }
      
      public function get currentGift() : int
      {
         var temp:Array = this.calcPrices(this.currentTempList);
         this._currentGift = temp[2];
         return this._currentGift;
      }
      
      public function get currentGold() : int
      {
         var temp:Array = this.calcPrices(this.currentTempList);
         this._currentGold = temp[0];
         return this._currentGold;
      }
      
      public function get currentLeftList() : Array
      {
         return this._sex ? this.leftManList : this.leftWomanList;
      }
      
      public function get currentMedal() : int
      {
         var temp:Array = this.calcPrices(this.currentTempList);
         this._currentMedal = temp[3];
         return this._currentMedal;
      }
      
      public function get currentMemoryList() : Array
      {
         return this.currentModel.Sex ? this._manMemoryList : this._womanMemoryList;
      }
      
      public function get currentModel() : PlayerInfo
      {
         return this._sex ? this._manModel : this._womanModel;
      }
      
      public function get currentMoney() : int
      {
         var temp:Array = this.calcPrices(this.currentTempList);
         this._currentMoney = temp[1];
         return this._currentMoney;
      }
      
      public function get currentSkin() : String
      {
         var list:Array = this.currentTempList;
         for(var i:int = 0; i < list.length; i++)
         {
            if(list[i].CategoryID == EquipType.FACE)
            {
               return list[i].skin;
            }
         }
         return "";
      }
      
      public function get currentTempList() : Array
      {
         return this._sex ? this._manTempList : this._womanTempList;
      }
      
      public function dispose() : void
      {
         this._self.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__styleChange);
         this._self.Bag.removeEventListener(BagEvent.UPDATE,this.__bagChange);
         this._womanModel = null;
         this._manModel = null;
         this._carList = null;
         this.leftCarList = null;
         this.leftManList = null;
         this.leftWomanList = null;
         this.maleCollocation = null;
         this.femaleCollocation = null;
      }
      
      public function get fittingSex() : Boolean
      {
         return this._sex;
      }
      
      public function set fittingSex(value:Boolean) : void
      {
         var shopEvt:ShopEvent = null;
         if(this._sex != value)
         {
            this._sex = value;
            shopEvt = new ShopEvent(ShopEvent.FITTINGMODEL_CHANGE,"sexChange");
            dispatchEvent(shopEvt);
         }
      }
      
      public function get isSelfModel() : Boolean
      {
         return this._sex == this._self.Sex;
      }
      
      public function get manModelInfo() : PlayerInfo
      {
         return this._manModel;
      }
      
      public function removeFromShoppingCar(item:ShopCarItemInfo) : void
      {
         this.removeTempEquip(item);
         var index:int = int(this._carList.indexOf(item));
         if(index != -1)
         {
            this._carList.splice(index,1);
            this.updateCost();
            item.removeEventListener(Event.CHANGE,this.__onItemChange);
            dispatchEvent(new ShopEvent(ShopEvent.REMOVE_CAR_EQUIP,item));
         }
      }
      
      public function checkPoint() : Boolean
      {
         var item:ShopCarItemInfo = null;
         var i:int = 0;
         for(var len:int = int(this._carList.length); i < len; )
         {
            item = this._carList[i] as ShopCarItemInfo;
            if(item.getCurrentPrice().bandDdtMoneyValue > 0)
            {
               return true;
            }
            if(Boolean(this.isBandList[i]))
            {
               return true;
            }
            i++;
         }
         for(var j:int = 0; j < this._manTempList.length; j++)
         {
            item = this._manTempList[j] as ShopCarItemInfo;
            if(item.getCurrentPrice().bandDdtMoneyValue > 0)
            {
               return true;
            }
            if(Boolean(this.isBandList[j]))
            {
               return true;
            }
         }
         for(var k:int = 0; k < this._womanTempList.length; k++)
         {
            item = this._womanTempList[k] as ShopCarItemInfo;
            if(item.getCurrentPrice().bandDdtMoneyValue > 0)
            {
               return true;
            }
            if(Boolean(this.isBandList[j]))
            {
               return true;
            }
         }
         return false;
      }
      
      public function checkDiscount() : Boolean
      {
         var item:ShopCarItemInfo = null;
         var i:int = 0;
         for(var len:int = int(this._carList.length); i < len; )
         {
            item = this._carList[i] as ShopCarItemInfo;
            if(item.isDiscount == 2)
            {
               return true;
            }
            i++;
         }
         for(var j:int = 0; j < this._manTempList.length; j++)
         {
            item = this._manTempList[j] as ShopCarItemInfo;
            if(item.isDiscount == 2)
            {
               return true;
            }
         }
         for(var k:int = 0; k < this._womanTempList.length; k++)
         {
            item = this._womanTempList[k] as ShopCarItemInfo;
            if(item.isDiscount == 2)
            {
               return true;
            }
         }
         return false;
      }
      
      public function removeItem(item:ShopCarItemInfo) : void
      {
         var arr:Array = null;
         var arr1:Array = null;
         if(this._carList.indexOf(item) != -1)
         {
            this._carList.splice(this._carList.indexOf(item),1);
            return;
         }
         for each(arr in this._manTempList)
         {
            if(arr.indexOf(item) > -1)
            {
               if(arr.length > 1)
               {
                  arr.splice(arr.indexOf(item),1);
               }
               else
               {
                  this._manTempList.splice(this._manTempList.indexOf(arr),1);
               }
            }
         }
         for each(arr1 in this._womanTempList)
         {
            if(arr1.indexOf(item) > -1)
            {
               if(arr1.length > 1)
               {
                  arr1.splice(arr1.indexOf(item),1);
               }
               else
               {
                  this._womanTempList.splice(this._womanTempList.indexOf(arr1),1);
               }
            }
         }
      }
      
      public function removeTempEquip(item:ShopCarItemInfo) : void
      {
         var model:PlayerInfo = null;
         var oldItem:InventoryItemInfo = null;
         var index:int = int(this._manTempList.indexOf(item));
         if(index != -1)
         {
            this._manTempList.splice(index,1);
            model = this._manModel;
         }
         else
         {
            index = int(this._womanTempList.indexOf(item));
            if(index != -1)
            {
               this._womanTempList.splice(index,1);
               model = this._womanModel;
            }
         }
         if(Boolean(model))
         {
            oldItem = model.Bag.items[item.place];
            if(Boolean(oldItem))
            {
               if(oldItem.CategoryID >= 1 && oldItem.CategoryID <= 6 || item.CategoryID == EquipType.SUITS || item.CategoryID == EquipType.WING)
               {
                  model.setPartStyle(item.CategoryID,item.TemplateInfo.NeedSex,oldItem.TemplateID,oldItem.Color);
               }
               if(item.CategoryID == EquipType.FACE)
               {
                  model.Skin = this._self.Skin;
               }
            }
            else if(EquipType.dressAble(item.TemplateInfo))
            {
               model.setPartStyle(item.CategoryID,item.TemplateInfo.NeedSex);
               if(item.CategoryID == EquipType.FACE)
               {
                  model.Skin = "";
               }
            }
            dispatchEvent(new ShopEvent(ShopEvent.REMOVE_TEMP_EQUIP,item,model));
         }
         this.updateCost();
         item.removeEventListener(Event.CHANGE,this.__onItemChange);
         if(this.currentTempList.length > 0)
         {
            this.setSelectedEquip(this.currentTempList[this.currentTempList.length - 1]);
         }
      }
      
      public function restoreAllItemsOnBody() : void
      {
         var list:Array = null;
         if(this.currentModel.Sex == this._self.Sex && this.currentTempList.length > 0 || this.currentModel.Bag.items != this._bodyThings)
         {
            list = this._sex ? this._manTempList : this._womanTempList;
            list.splice(0,list.length);
            this.init();
            dispatchEvent(new ShopEvent(ShopEvent.FITTINGMODEL_CHANGE));
            this.updateCost();
            dispatchEvent(new ShopEvent(ShopEvent.UPDATE_CAR));
         }
      }
      
      public function revertToDefalt() : void
      {
         this.clearAllItemsOnBody();
         dispatchEvent(new ShopEvent(ShopEvent.FITTINGMODEL_CHANGE));
         this.updateCost();
         dispatchEvent(new ShopEvent(ShopEvent.UPDATE_CAR));
      }
      
      public function setSelectedEquip(item:ShopCarItemInfo) : void
      {
         var list:Array = null;
         if(item is ShopCarItemInfo)
         {
            list = this.currentTempList;
            if(list.indexOf(item) > -1)
            {
               list.splice(list.indexOf(item),1);
               list.push(item);
            }
            dispatchEvent(new ShopEvent(ShopEvent.SELECTEDEQUIP_CHANGE,item));
         }
      }
      
      public function get totalGift() : int
      {
         return this._totalGift;
      }
      
      public function get totalGold() : int
      {
         return this._totalGold;
      }
      
      public function get totalMedal() : int
      {
         return this._totalMedal;
      }
      
      public function get totalMoney() : int
      {
         return this._totalMoney;
      }
      
      public function updateCost() : void
      {
         this._totalGold = 0;
         this._totalMoney = 0;
         this._totalGift = 0;
         this._totalMedal = 0;
         var temp:Array = this.calcPrices(this._carList);
         this._totalGold += temp[0];
         this._totalMoney += temp[1];
         this._totalGift += temp[2];
         this._totalMedal += temp[3];
         temp = this.calcPrices(this._womanTempList);
         this._totalGold += temp[0];
         this._totalMoney += temp[1];
         this._totalGift += temp[2];
         this._totalMedal += temp[3];
         temp = this.calcPrices(this._manTempList);
         this._totalGold += temp[0];
         this._totalMoney += temp[1];
         this._totalGift += temp[2];
         this._totalMedal += temp[3];
         dispatchEvent(new ShopEvent(ShopEvent.COST_UPDATE));
      }
      
      public function get womanModelInfo() : PlayerInfo
      {
         return this._womanModel;
      }
      
      private function __bagChange(evt:BagEvent) : void
      {
         var item:InventoryItemInfo = null;
         var shouldUpdate:Boolean = false;
         var items:Dictionary = evt.changedSlots;
         for each(item in items)
         {
            if(item.Place <= 30)
            {
               shouldUpdate = true;
               break;
            }
         }
         if(!shouldUpdate)
         {
            return;
         }
         var model:PlayerInfo = this._self.Sex ? this._manModel : this._womanModel;
         if(this._self.Sex)
         {
            this._manModel.Bag.items = this._self.Bag.items;
         }
         else
         {
            this._womanModel.Bag.items = this._self.Bag.items;
         }
         dispatchEvent(new ShopEvent(ShopEvent.FITTINGMODEL_CHANGE));
      }
      
      private function __styleChange(evt:PlayerPropertyEvent) : void
      {
         var model:PlayerInfo = null;
         if(Boolean(this.currentModel) && Boolean(evt.changedProperties[PlayerInfo.STYLE]))
         {
            this._defaultModel = 1;
            model = this._self.Sex ? this._manModel : this._womanModel;
            if(this._self.Sex)
            {
               this._manModel.updateStyle(this._self.Sex,this._self.Hide,this._self.getPrivateStyle(),this._self.Colors,this._self.getSkinColor());
               this._womanModel.updateStyle(false,2222222222,DEFAULT_WOMAN_STYLE,",,,,,,","");
               this._manModel.Bag.items = this._self.Bag.items;
            }
            else
            {
               this._manModel.updateStyle(true,2222222222,DEFAULT_MAN_STYLE,",,,,,,","");
               this._womanModel.updateStyle(this._self.Sex,this._self.Hide,this._self.getPrivateStyle(),this._self.Colors,this._self.getSkinColor());
               this._womanModel.Bag.items = this._self.Bag.items;
            }
            dispatchEvent(new ShopEvent(ShopEvent.FITTINGMODEL_CHANGE));
         }
      }
      
      private function clearAllItemsOnBody() : void
      {
         this.saveTriedList();
         this.currentModel.Bag.items = new DictionaryData();
         var list:Array = this._sex ? this._manTempList : this._womanTempList;
         list.splice(0,list.length);
         if(this.currentModel.Sex)
         {
            this.currentModel.updateStyle(true,2222222222,DEFAULT_MAN_STYLE,",,,,,,","");
         }
         else
         {
            this.currentModel.updateStyle(false,2222222222,DEFAULT_WOMAN_STYLE,",,,,,,","");
         }
      }
      
      private function fillToShopCarInfo(item:ShopItemInfo) : ShopCarItemInfo
      {
         var t:ShopCarItemInfo = new ShopCarItemInfo(item.GoodsID,item.TemplateID);
         ObjectUtils.copyProperties(t,item);
         return t;
      }
      
      private function findEquip(id:Number, list:Array) : int
      {
         for(var i:int = 0; i < list.length; i++)
         {
            if(list[i].TemplateID == id)
            {
               return i;
            }
         }
         return -1;
      }
      
      private function init() : void
      {
         this.initBodyThing();
         if(this._self.Sex)
         {
            if(this._defaultModel == 1)
            {
               this._manModel.updateStyle(this._self.Sex,this._self.Hide,this._self.getPrivateStyle(),this._self.Colors,this._self.getSkinColor());
               this._manModel.Bag.items = this._bodyThings;
            }
            else
            {
               this._manModel.updateStyle(true,2222222222,DEFAULT_MAN_STYLE,",,,,,,","");
               this._manModel.Bag.items = new DictionaryData();
            }
            this._womanModel.updateStyle(false,2222222222,DEFAULT_WOMAN_STYLE,",,,,,,","");
         }
         else
         {
            this._manModel.updateStyle(true,2222222222,DEFAULT_MAN_STYLE,",,,,,,","");
            if(this._defaultModel == 1)
            {
               this._womanModel.updateStyle(this._self.Sex,this._self.Hide,this._self.getPrivateStyle(),this._self.Colors,this._self.getSkinColor());
               this._womanModel.Bag.items = this._bodyThings;
            }
            else
            {
               this._womanModel.updateStyle(false,2222222222,DEFAULT_WOMAN_STYLE,",,,,,,","");
               this._womanModel.Bag.items = new DictionaryData();
            }
         }
         dispatchEvent(new ShopEvent(ShopEvent.FITTINGMODEL_CHANGE));
      }
      
      private function initBodyThing() : void
      {
         var item:InventoryItemInfo = null;
         this._bodyThings = new DictionaryData();
         for each(item in this._self.Bag.items)
         {
            if(item.Place <= 30)
            {
               this._bodyThings.add(item.Place,item);
            }
         }
      }
      
      private function saveTriedList() : void
      {
         if(this.currentModel.Sex)
         {
            this._manMemoryList = this.currentTempList.concat();
         }
         else
         {
            this._womanMemoryList = this.currentTempList.concat();
         }
      }
      
      public function getBagItems($id:int, $isIndex:Boolean = false) : int
      {
         var numArr:Array = [0,2,4,11,1,3,5,13];
         if(!$isIndex)
         {
            return numArr[$id] != null ? int(numArr[$id]) : -1;
         }
         return numArr.indexOf($id);
      }
   }
}

