package ddt.manager
{
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.LoadResourceManager;
   import ddt.data.EquipType;
   import ddt.data.ShopType;
   import ddt.data.analyze.ShopItemAnalyzer;
   import ddt.data.analyze.ShopItemDisCountAnalyzer;
   import ddt.data.analyze.ShopItemSortAnalyzer;
   import ddt.data.goods.ItemPrice;
   import ddt.data.goods.ShopCarItemInfo;
   import ddt.data.goods.ShopItemInfo;
   import ddt.data.player.SelfInfo;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.states.StateType;
   import flash.events.EventDispatcher;
   import flash.net.URLVariables;
   import flash.utils.Dictionary;
   import gemstone.GemstoneManager;
   import road7th.comm.PackageIn;
   import road7th.data.DictionaryData;
   import shop.ShopEvent;
   
   public class ShopManager extends EventDispatcher
   {
      
      private static var _instance:ShopManager;
      
      public var initialized:Boolean = false;
      
      private var _shopGoods:DictionaryData;
      
      private var _shopSortList:Dictionary;
      
      private var _shopRealTimesDisCountGoods:Dictionary;
      
      public function ShopManager(singleton:SingletonEnfocer)
      {
         super();
      }
      
      public static function get Instance() : ShopManager
      {
         if(_instance == null)
         {
            _instance = new ShopManager(new SingletonEnfocer());
         }
         return _instance;
      }
      
      public function setup(analyzer:ShopItemAnalyzer) : void
      {
         this._shopGoods = analyzer.shopinfolist;
         this.initialized = true;
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.GOODS_COUNT,this.__updateGoodsCount);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.REALlTIMES_ITEMS_BY_DISCOUNT,this.__updateGoodsDisCount);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.SHOP_BUYLIMITEDCOUNT,this.__shopBuyLimitedCountHandler);
      }
      
      public function updateShopGoods(analyzer:ShopItemAnalyzer) : void
      {
         this._shopGoods = analyzer.shopinfolist;
      }
      
      public function sortShopItems(analyzer:ShopItemSortAnalyzer) : void
      {
         this._shopSortList = analyzer.shopSortedGoods;
      }
      
      public function getResultPages(type:int, count:int = 8) : int
      {
         var list:Vector.<ShopItemInfo> = this.getValidGoodByType(type);
         return int(Math.ceil(list.length / count));
      }
      
      public function buyIt(list:Array) : Array
      {
         var item:ShopCarItemInfo = null;
         var self:SelfInfo = PlayerManager.Instance.Self;
         var buyedArr:Array = [];
         var selfGold:int = self.Gold;
         var selfMoney:int = self.Money;
         var selfDDTMoney:int = self.BandMoney;
         for each(item in list)
         {
            if(selfGold >= item.getItemPrice(item.currentBuyType).goldValue && selfMoney >= item.getItemPrice(item.currentBuyType).moneyValue && selfDDTMoney >= item.getItemPrice(item.currentBuyType).bandDdtMoneyValue)
            {
               selfGold -= item.getItemPrice(item.currentBuyType).goldValue;
               selfMoney -= item.getItemPrice(item.currentBuyType).moneyValue;
               selfDDTMoney -= item.getItemPrice(item.currentBuyType).bandDdtMoneyValue;
               buyedArr.push(item);
            }
         }
         return buyedArr;
      }
      
      public function giveGift(list:Array, self:SelfInfo) : Array
      {
         var itemPrice:ItemPrice = null;
         var item:ShopCarItemInfo = null;
         var giftArray:Array = [];
         var money:int = self.Money;
         for each(item in list)
         {
            itemPrice = item.getItemPrice(item.currentBuyType);
            if(money >= itemPrice.moneyValue && itemPrice.bandDdtMoneyValue == 0 && itemPrice.goldValue == 0)
            {
               money -= itemPrice.moneyValue;
               giftArray.push(item);
            }
         }
         return giftArray;
      }
      
      private function __updateGoodsCount(evt:CrazyTankSocketEvent) : void
      {
         var goodsID:int = 0;
         var count:int = 0;
         var item:ShopItemInfo = null;
         var goodsID2:int = 0;
         var count2:int = 0;
         var item2:ShopItemInfo = null;
         var pkg:PackageIn = evt.pkg;
         var type:int = StateManager.currentStateType == StateType.CONSORTIA ? 2 : 1;
         var len:int = pkg.readInt();
         for(var i:int = 0; i < len; i++)
         {
            goodsID = pkg.readInt();
            count = pkg.readInt();
            item = this.getShopItemByGoodsID(goodsID);
            if(Boolean(item) && type == 1)
            {
               item.LimitCount = count;
            }
         }
         var consortiaID:int = pkg.readInt();
         var len2:int = pkg.readInt();
         for(var j:int = 0; j < len2; j++)
         {
            goodsID2 = pkg.readInt();
            count2 = pkg.readInt();
            item2 = this.getShopItemByGoodsID(goodsID2);
            if(item2 && type == 2 && consortiaID == PlayerManager.Instance.Self.ConsortiaID)
            {
               item2.LimitCount = count2;
            }
         }
         var playerId:int = pkg.readInt();
         GemstoneManager.Instance.upDataFitCount();
      }
      
      public function getShopItemByGoodsID(id:int) : ShopItemInfo
      {
         var result:DictionaryData = null;
         var item:ShopItemInfo = this._shopGoods[id];
         if(item != null)
         {
            return item;
         }
         for each(result in this._shopRealTimesDisCountGoods)
         {
            item = result[id];
            if(item != null && item.isValid)
            {
               return item;
            }
         }
         return null;
      }
      
      public function getValidSortedGoodsByType(type:int, page:int, count:int = 8) : Vector.<ShopItemInfo>
      {
         var startIndex:int = 0;
         var len:int = 0;
         var i:int = 0;
         var result:Vector.<ShopItemInfo> = new Vector.<ShopItemInfo>();
         var list:Vector.<ShopItemInfo> = this.getValidGoodByType(type);
         var totlaPage:int = Math.ceil(list.length / count);
         if(page > 0 && page <= totlaPage)
         {
            startIndex = 0 + count * (page - 1);
            len = Math.min(list.length - startIndex,count);
            for(i = 0; i < len; i++)
            {
               result.push(list[startIndex + i]);
            }
         }
         return result;
      }
      
      public function getValidSortedGoodsByList(list:Vector.<ShopItemInfo>, page:int, count:int = 8) : Vector.<ShopItemInfo>
      {
         var startIndex:int = 0;
         var len:int = 0;
         var i:int = 0;
         var result:Vector.<ShopItemInfo> = new Vector.<ShopItemInfo>();
         var totlaPage:int = Math.ceil(list.length / count);
         if(page > 0 && page <= totlaPage)
         {
            startIndex = 0 + count * (page - 1);
            len = Math.min(list.length - startIndex,count);
            for(i = 0; i < len; i++)
            {
               result.push(list[startIndex + i]);
            }
         }
         return result;
      }
      
      public function GetGoodsByTypeAndQuality(type:int, quality:int) : Vector.<ShopItemInfo>
      {
         var result:Vector.<ShopItemInfo> = new Vector.<ShopItemInfo>();
         var list:Vector.<ShopItemInfo> = this.getValidGoodByType(type);
         var i:int = 0;
         var L:int = int(list.length);
         for(i = 0; i < L; i++)
         {
            if(list[i].TemplateInfo.Quality == quality)
            {
               result.push(list[i]);
            }
         }
         return result;
      }
      
      public function getGoodsByType(type:int) : Vector.<ShopItemInfo>
      {
         return this._shopSortList[type] as Vector.<ShopItemInfo>;
      }
      
      public function getValidGoodByType(type:int) : Vector.<ShopItemInfo>
      {
         var item:ShopItemInfo = null;
         var result:Vector.<ShopItemInfo> = new Vector.<ShopItemInfo>();
         var list:Vector.<ShopItemInfo> = this._shopSortList[type];
         for each(item in list)
         {
            if(item.isValid)
            {
               result.push(item);
            }
         }
         return result;
      }
      
      public function consortiaShopLevelTemplates(level:int) : Vector.<ShopItemInfo>
      {
         return this._shopSortList[ShopType.GUILD_SHOP_1 + level - 1] as Vector.<ShopItemInfo>;
      }
      
      public function canAddPrice(templateID:int) : Boolean
      {
         if(!this.getGoodsByTemplateIDOnlyUseXuFei(templateID) || !this.getGoodsByTemplateIDOnlyUseXuFei(templateID).IsContinue)
         {
            return false;
         }
         if(this.getShopRechargeItemByTemplateId(templateID).length <= 0)
         {
            return false;
         }
         return true;
      }
      
      public function getShopRechargeItemByTemplateId(id:int) : Array
      {
         var item1:ShopItemInfo = null;
         var item2:ShopItemInfo = null;
         var result:Array = [];
         for each(item1 in this._shopGoods)
         {
            if(item1.TemplateID == id && item1.getItemPrice(1).moneyValue > 0 && item1.IsContinue)
            {
               if(item1.ShopID != ShopType.SALE_SHOP && item1.ShopID != ShopType.SHOP_PAST_PRICE)
               {
                  result.push(item1);
               }
            }
         }
         for each(item2 in this._shopGoods)
         {
            if(item2.TemplateID == id && item2.getItemPrice(1).bandDdtMoneyValue > 0 && item2.IsContinue)
            {
               if(item2.ShopID != ShopType.SALE_SHOP && item2.ShopID != ShopType.SHOP_PAST_PRICE)
               {
                  result.push(item2);
               }
            }
         }
         return result;
      }
      
      public function getShopItemByTemplateID(id:int, type:int) : ShopItemInfo
      {
         var item1:ShopItemInfo = null;
         var item:ShopItemInfo = null;
         var item2:ShopItemInfo = null;
         var item3:ShopItemInfo = null;
         var item4:ShopItemInfo = null;
         var item5:ShopItemInfo = null;
         switch(type)
         {
            case 1:
               for each(item1 in this._shopGoods)
               {
                  if(item1.TemplateID == id && item1.getItemPrice(1).hardCurrencyValue > 0)
                  {
                     if(item1.isValid)
                     {
                        return item1;
                     }
                  }
               }
               break;
            case 2:
               for each(item in this._shopGoods)
               {
                  if(item.TemplateID == id && item.getItemPrice(1).gesteValue > 0)
                  {
                     if(item.isValid)
                     {
                        return item;
                     }
                  }
               }
               break;
            case 3:
               return this.getMoneyShopItemByTemplateID(id);
            case 4:
               for each(item2 in this._shopGoods)
               {
                  if(item2.TemplateID == id && item2.getItemPrice(1).bandDdtMoneyValue > 0)
                  {
                     if(item2.isValid)
                     {
                        return item2;
                     }
                  }
               }
               break;
            case 5:
               for each(item3 in this._shopGoods)
               {
                  if(item3.TemplateID == id && item3.getItemPrice(1).scoreValue > 0)
                  {
                     if(item3.isValid)
                     {
                        return item3;
                     }
                  }
               }
               break;
            case 6:
               for each(item4 in this._shopGoods)
               {
                  if(item4.TemplateID == id)
                  {
                     if(item4.getItemPrice(1).leagueValue > 0 && item4.isValid)
                     {
                        return item4;
                     }
                  }
               }
               break;
            case -1700:
               for each(item5 in this._shopGoods)
               {
                  if(item5.TemplateID == id)
                  {
                     if(item5.ShopID == ShopType.TREASURELOST_SHOP && item5.isValid && item5.AValue1 > 0)
                     {
                        return item5;
                     }
                  }
               }
         }
         return null;
      }
      
      public function getMoneyShopItemByTemplateID(id:int, shouldInShop:Boolean = false) : ShopItemInfo
      {
         var types:Array = null;
         var type:int = 0;
         var shopitems:Vector.<ShopItemInfo> = null;
         var item:ShopItemInfo = null;
         var list:Vector.<ShopItemInfo> = null;
         var item1:ShopItemInfo = null;
         if(shouldInShop)
         {
            types = this.getType(ShopType.MALE_MONEY_TYPE).concat(this.getType(ShopType.FEMALE_MONEY_TYPE)).concat(this.getType(ShopType.FEMALE_DDTMONEY_TYPE)).concat(this.getType(ShopType.MALE_DDTMONEY_TYPE));
            for each(type in types)
            {
               shopitems = this.getValidGoodByType(type);
               for each(item in shopitems)
               {
                  if(item.TemplateID == id && item.getItemPrice(1).moneyValue > 0)
                  {
                     return item;
                  }
               }
            }
         }
         else
         {
            list = new Vector.<ShopItemInfo>();
            for each(item1 in this._shopGoods)
            {
               if(item1.TemplateID == id && item1.getItemPrice(1).moneyValue > 0 && item1.isValid)
               {
                  list.push(item1);
               }
            }
            if(list.length > 0)
            {
               return this.getInfoByBuyType(list);
            }
         }
         return null;
      }
      
	  private function getInfoByBuyType(list:Vector.<ShopItemInfo>) : ShopItemInfo
	  {
		  var info:ShopItemInfo = null;
		  var i:int = 0;
		  for(var j:int = 0; i < list.length; i++)
		  {
			  j = i - 1;
			  info = list[i];
			  while(j >= 0 && info.ShopID < list[j].ShopID)
			  {
				  list[j + 1] = list[j];
				  j--;
			  }
			  list[j + 1] = info;
		  }
		  return list[0];
	  }
      
      public function getMoneySaleShopItemByTemplateID(id:int) : ShopItemInfo
      {
         var item:ShopItemInfo = null;
         var list:Vector.<ShopItemInfo> = this._shopSortList[ShopType.SALE_SHOP];
         if(Boolean(list))
         {
            for each(item in list)
            {
               if(item.GoodsID == id && item.getItemPrice(1).moneyValue > 0)
               {
                  return item;
               }
            }
         }
         return null;
      }
      
      public function getMoneyShopItemByTemplateIDForGiftSystem(id:int) : ShopItemInfo
      {
         var item:ShopItemInfo = null;
         for each(item in this._shopGoods)
         {
            if(item.TemplateID == id)
            {
               return item;
            }
         }
         return null;
      }
      
      public function getBuriedGoodsList() : Vector.<ShopItemInfo>
      {
         var item:ShopItemInfo = null;
         var list:Vector.<ShopItemInfo> = new Vector.<ShopItemInfo>();
         for each(item in this._shopGoods)
         {
            if(item.ShopID == 94)
            {
               list.push(item);
            }
         }
         return list;
      }
      
      private function getGoodsByTemplateIDOnlyUseXuFei(id:int) : ShopItemInfo
      {
         var item:ShopItemInfo = null;
         var i:int = 0;
         var itemArr:Vector.<ShopItemInfo> = new Vector.<ShopItemInfo>();
         for each(item in this._shopGoods)
         {
            if(item.TemplateID == id)
            {
               itemArr.push(item);
            }
         }
         for(i = 0; i < itemArr.length; i++)
         {
            if(itemArr[i].IsContinue)
            {
               return itemArr[i];
            }
         }
         return null;
      }
      
      public function getGoodsByTemplateID(id:int) : ShopItemInfo
      {
         var item:ShopItemInfo = null;
         var list:Vector.<ShopItemInfo> = new Vector.<ShopItemInfo>();
         for each(item in this._shopGoods)
         {
            if(item.TemplateID == id)
            {
               list.push(item);
            }
         }
         if(list.length > 0)
         {
            return this.getInfoByBuyType(list);
         }
         return null;
      }
      
      public function getGoodsByTemplateIDFromTransnational(id:int) : ShopItemInfo
      {
         var item:ShopItemInfo = null;
         for each(item in this._shopGoods)
         {
            if(item.TemplateID == id && item.BuyType == 100)
            {
               return item;
            }
         }
         return null;
      }
      
      public function getGiftShopItemByTemplateID(id:int, shouldInShop:Boolean = false) : ShopItemInfo
      {
         var types:Array = null;
         var type:int = 0;
         var shopitems:Vector.<ShopItemInfo> = null;
         var item:ShopItemInfo = null;
         var item1:ShopItemInfo = null;
         if(shouldInShop)
         {
            types = this.getType(ShopType.MALE_MONEY_TYPE).concat(this.getType(ShopType.FEMALE_MONEY_TYPE)).concat(this.getType(ShopType.FEMALE_DDTMONEY_TYPE)).concat(this.getType(ShopType.MALE_DDTMONEY_TYPE));
            for each(type in types)
            {
               shopitems = this.getValidGoodByType(type);
               for each(item in shopitems)
               {
                  if(item.TemplateID == id)
                  {
                     if(item.getItemPrice(1).bandDdtMoneyValue > 0)
                     {
                        return item;
                     }
                  }
               }
            }
         }
         else
         {
            for each(item1 in this._shopGoods)
            {
               if(item1.TemplateID == id && item1.getItemPrice(1).bandDdtMoneyValue > 0)
               {
                  if(item1.isValid)
                  {
                     return item1;
                  }
               }
            }
         }
         return null;
      }
      
      private function getType(type:*) : Array
      {
         var t:* = undefined;
         var result:Array = [];
         if(type is Array)
         {
            for each(t in type)
            {
               result = result.concat(this.getType(t));
            }
         }
         else
         {
            result.push(type);
         }
         return result;
      }
      
      public function getGoldShopItemByTemplateID(id:int) : ShopItemInfo
      {
         var item:ShopItemInfo = null;
         for each(item in this._shopSortList[ShopType.ROOM_PROP])
         {
            if(item.TemplateID == id)
            {
               if(item.isValid)
               {
                  return item;
               }
            }
         }
         return null;
      }
      
      public function moneyGoods(list:Array, self:SelfInfo) : Array
      {
         var itemPrice:ItemPrice = null;
         var item:ShopCarItemInfo = null;
         var moneyGoods:Array = [];
         for each(item in list)
         {
            itemPrice = item.getItemPrice(item.currentBuyType);
            if(itemPrice.moneyValue > 0)
            {
               moneyGoods.push(item);
            }
         }
         return moneyGoods;
      }
      
      public function buyLeastGood(list:Array, self:SelfInfo) : Boolean
      {
         var item:ShopCarItemInfo = null;
         for each(item in list)
         {
            if(self.Gold >= item.getItemPrice(item.currentBuyType).goldValue && self.Money >= item.getItemPrice(item.currentBuyType).moneyValue && self.BandMoney >= item.getItemPrice(item.currentBuyType).bandDdtMoneyValue)
            {
               return true;
            }
         }
         return false;
      }
      
      public function getDesignatedAllShopItem() : Vector.<ShopItemInfo>
      {
         var type:int = 0;
         var result:Vector.<ShopItemInfo> = new Vector.<ShopItemInfo>();
         for(var i:int = 0; i < ShopType.CAN_SHOW_IN_SHOP.length; i++)
         {
            type = int(ShopType.CAN_SHOW_IN_SHOP[i]);
            if(Boolean(this._shopSortList[type]))
            {
               result = result.concat(this._shopSortList[type]);
            }
         }
         return result;
      }
      
      public function fuzzySearch($ShopItemList:Vector.<ShopItemInfo>, $shopName:String) : Vector.<ShopItemInfo>
      {
         var item:ShopItemInfo = null;
         var indexId:int = 0;
         var boole:Boolean = false;
         var info:ShopItemInfo = null;
         var result:Vector.<ShopItemInfo> = new Vector.<ShopItemInfo>();
         for each(item in $ShopItemList)
         {
            if(item.isValid && Boolean(item.TemplateInfo))
            {
               indexId = int(item.TemplateInfo.Name.indexOf($shopName));
               if(indexId > -1)
               {
                  boole = true;
                  for each(info in result)
                  {
                     if(info.GoodsID == item.GoodsID)
                     {
                        boole = false;
                     }
                  }
                  if(boole)
                  {
                     result.push(item);
                  }
               }
            }
         }
         return result;
      }
      
      public function getDisCountValidGoodByType(type:int) : Vector.<ShopItemInfo>
      {
         var list:DictionaryData = null;
         var item:ShopItemInfo = null;
         var item1:ShopItemInfo = null;
         var item2:ShopItemInfo = null;
         var item3:ShopItemInfo = null;
         var result:Vector.<ShopItemInfo> = new Vector.<ShopItemInfo>();
         if(type != 1)
         {
            list = this._shopRealTimesDisCountGoods[type];
            if(Boolean(list))
            {
               for each(item in list.list)
               {
                  if(item.isValid && item.TemplateInfo.CategoryID != EquipType.GIFTGOODS)
                  {
                     result.push(item);
                  }
               }
            }
            return result;
         }
         if(type == 1)
         {
            list = this._shopRealTimesDisCountGoods[type];
            if(Boolean(list))
            {
               for each(item1 in list.list)
               {
                  if(item1.isValid && item1.TemplateInfo.CategoryID != EquipType.GIFTGOODS)
                  {
                     result.push(item1);
                  }
               }
            }
            list = this._shopRealTimesDisCountGoods[8];
            if(Boolean(list))
            {
               for each(item2 in list.list)
               {
                  if(item2.isValid && item2.TemplateInfo.CategoryID != EquipType.GIFTGOODS)
                  {
                     result.push(item2);
                  }
               }
            }
            list = this._shopRealTimesDisCountGoods[9];
            if(Boolean(list))
            {
               for each(item3 in list.list)
               {
                  if(item3.isValid && item3.TemplateInfo.CategoryID != EquipType.GIFTGOODS)
                  {
                     result.push(item3);
                  }
               }
            }
            return result;
         }
         return result;
      }
      
      public function getDisCountResultPages(type:int, count:int = 8) : int
      {
         var totlaPage:int = 0;
         var list:Vector.<ShopItemInfo> = this.getDisCountValidGoodByType(type);
         if(Boolean(list))
         {
            totlaPage = Math.ceil(list.length / count);
         }
         return totlaPage;
      }
      
      public function getDisCountShopItemByGoodsID(id:int) : ShopItemInfo
      {
         var result:DictionaryData = null;
         var item:ShopItemInfo = null;
         for each(result in this._shopRealTimesDisCountGoods)
         {
            item = result[id];
            if(item != null && item.isValid)
            {
               return item;
            }
         }
         return null;
      }
      
      public function getDisCountGoods(type:int = 1, page:int = 1, count:int = 8) : Vector.<ShopItemInfo>
      {
         var totlaPage:int = 0;
         var startIndex:int = 0;
         var len:int = 0;
         var i:int = 0;
         var result:Vector.<ShopItemInfo> = new Vector.<ShopItemInfo>();
         var list:Vector.<ShopItemInfo> = this.getDisCountValidGoodByType(type);
         if(Boolean(list))
         {
            totlaPage = Math.ceil(list.length / count);
            if(page > 0 && page <= totlaPage)
            {
               startIndex = 0 + count * (page - 1);
               len = Math.min(list.length - startIndex,count);
               for(i = 0; i < len; i++)
               {
                  result.push(list[startIndex + i]);
               }
            }
         }
         return result;
      }
      
      public function isHasDisCountGoods(type:int) : Boolean
      {
         var result_8:DictionaryData = null;
         var result_9:DictionaryData = null;
         var result:DictionaryData = this._shopRealTimesDisCountGoods[type];
         if(type == 1)
         {
            result_8 = this._shopRealTimesDisCountGoods[8];
            result_9 = this._shopRealTimesDisCountGoods[9];
            if(this.checkIsHasDisCount(result) || this.checkIsHasDisCount(result_8) || this.checkIsHasDisCount(result_9))
            {
               return true;
            }
         }
         else if(this.checkIsHasDisCount(result))
         {
            return true;
         }
         return false;
      }
      
      private function checkIsHasDisCount(result:DictionaryData) : Boolean
      {
         var item:ShopItemInfo = null;
         if(Boolean(result) && result.length > 0)
         {
            for each(item in result.list)
            {
               if(Boolean(item) && item.isValid)
               {
                  return true;
               }
            }
         }
         return false;
      }
      
      private function __updateGoodsDisCount(evt:CrazyTankSocketEvent) : void
      {
         this.loadDisCounts();
      }
      
      private function __shopBuyLimitedCountHandler(evt:CrazyTankSocketEvent) : void
      {
         var i:int = 0;
         var id:int = 0;
         var count:int = 0;
         var pkg:PackageIn = evt.pkg;
         var length:int = pkg.readInt();
         if(length > 0)
         {
            for(i = 0; i < length; i++)
            {
               id = pkg.readInt();
               count = pkg.readInt();
               if(Boolean(this._shopGoods[id]))
               {
                  ShopItemInfo(this._shopGoods[id]).LimitAreaCount = count;
               }
            }
            dispatchEvent(new ShopEvent(ShopEvent.UPDATA_LIMITAREACOUNT));
         }
      }
      
      private function loadDisCounts() : void
      {
         var args:URLVariables = new URLVariables();
         args["rnd"] = Math.random();
         var loader:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("ShopCheapItemList.ashx"),BaseLoader.REQUEST_LOADER,args);
         loader.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.ShopDisCountRealTimesFailure");
         loader.analyzer = new ShopItemDisCountAnalyzer(ShopManager.Instance.updateRealTimesItemsByDisCount);
         LoadResourceManager.Instance.startLoad(loader);
      }
      
      public function updateRealTimesItemsByDisCount(analyzer:ShopItemDisCountAnalyzer) : void
      {
         this._shopRealTimesDisCountGoods = analyzer.shopDisCountGoods;
         dispatchEvent(new ShopEvent(ShopEvent.DISCOUNT_IS_CHANGE));
      }
      
      public function get shopGoods() : DictionaryData
      {
         return this._shopGoods;
      }
      
      public function set shopGoods(value:DictionaryData) : void
      {
         this._shopGoods = value;
      }
   }
}

class SingletonEnfocer
{
   
   public function SingletonEnfocer()
   {
      super();
   }
}
