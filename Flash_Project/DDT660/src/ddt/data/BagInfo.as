package ddt.data
{
   import cardSystem.CardControl;
   import cardSystem.data.CardInfo;
   import cardSystem.data.SetsInfo;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.events.BagEvent;
   import ddt.manager.ItemManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.ShopManager;
   import ddt.manager.SocketManager;
   import ddt.manager.StateManager;
   import ddt.states.StateType;
   import flash.events.EventDispatcher;
   import flash.utils.ByteArray;
   import flash.utils.Dictionary;
   import road7th.data.DictionaryData;
   
   [Event(name="update",type="ddt.events.BagEvent")]
   public class BagInfo extends EventDispatcher
   {
      
      public static const EQUIPBAG:int = 0;
      
      public static const PROPBAG:int = 1;
      
      public static const TASKBAG:int = 2;
      
      public static const FIGHTBAG:int = 3;
      
      public static const TEMPBAG:int = 4;
      
      public static const CADDYBAG:int = 5;
      
      public static const CONSORTIA:int = 11;
      
      public static const FARM:int = 13;
      
      public static const VEGETABLE:int = 14;
      
      public static const FOOD_OLD:int = 32;
      
      public static const FOOD:int = 34;
      
      public static const PETEGG:int = 35;
      
      public static const MAGICHOUSE:int = 51;
      
      public static const BEADBAG:int = 21;
      
      public static const MAGICSTONE:int = 41;
      
      public static const MAXPROPCOUNT:int = 48;
      
      public static const STOREBAG:int = 12;
      
      public static const PERSONAL_EQUIP_COUNT:int = 30;
      
      public var isBatch:Boolean = false;
      
      private var _type:int;
      
      private var _capability:int;
      
      private var _items:DictionaryData;
      
      private var _changedCount:int = 0;
      
      private var _changedSlots:Dictionary = new Dictionary();
      
      public const NUMBER:Number = 1;
      
      public function BagInfo(type:int, capability:int)
      {
         super();
         this._type = type;
         this._items = new DictionaryData();
         this._capability = capability;
      }
      
      public function get BagType() : int
      {
         return this._type;
      }
      
      public function getItemAt(slot:int) : InventoryItemInfo
      {
         return this._items[slot];
      }
      
      public function get items() : DictionaryData
      {
         return this._items;
      }
      
      public function get itemNumber() : int
      {
         var result:int = 0;
         for(var i:int = 0; i < 49; i++)
         {
            if(this._items[i] != null)
            {
               result++;
            }
         }
         return result;
      }
      
      public function set items(dic:DictionaryData) : void
      {
         this._items = dic;
      }
      
      public function addItem(item:InventoryItemInfo) : void
      {
         item.BagType = this._type;
         this._items.add(item.Place,item);
         if(this.isBatch)
         {
            return;
         }
         this.onItemChanged(item.Place,item);
      }
      
      public function addItemIntoFightBag(itemID:int, count:int = 1) : void
      {
         var item:InventoryItemInfo = new InventoryItemInfo();
         item.BagType = FIGHTBAG;
         item.Place = this.findFirstPlace();
         item.Count = count;
         item.TemplateID = itemID;
         ItemManager.fill(item);
         this.addItem(item);
      }
      
      private function findFirstPlace() : int
      {
         for(var i:int = 0; i < 3; i++)
         {
            if(this.getItemAt(i) == null)
            {
               return i;
            }
         }
         return -1;
      }
      
      public function removeItemAt(slot:int) : void
      {
         var item:InventoryItemInfo = this._items[slot];
         if(Boolean(item))
         {
            this._items.remove(slot);
            if(this.isBatch || this._type == TEMPBAG && StateManager.currentStateType == StateType.FIGHTING)
            {
               return;
            }
            this.onItemChanged(slot,item);
         }
      }
      
      public function updateItem(item:InventoryItemInfo) : void
      {
         if(item.BagType == this._type)
         {
            this.onItemChanged(item.Place,item);
         }
      }
      
      public function beginChanges() : void
      {
         ++this._changedCount;
      }
      
      public function commiteChanges() : void
      {
         --this._changedCount;
         if(this._changedCount <= 0)
         {
            this._changedCount = 0;
            this.updateChanged();
         }
      }
      
      protected function onItemChanged(slot:int, value:InventoryItemInfo) : void
      {
         this._changedSlots[slot] = value;
         if(this._changedCount <= 0)
         {
            this._changedCount = 0;
            this.updateChanged();
         }
      }
      
      protected function updateChanged() : void
      {
         dispatchEvent(new BagEvent(BagEvent.UPDATE,this._changedSlots));
         this.isBatch = false;
         this._changedSlots = new Dictionary();
      }
      
      public function findItems(categoryId:int, validate:Boolean = true) : Array
      {
         var i:InventoryItemInfo = null;
         var list:Array = new Array();
         for each(i in this._items)
         {
            if(i.CategoryID == categoryId)
            {
               if(!validate || i.getRemainDate() > 0)
               {
                  list.push(i);
               }
            }
         }
         return list;
      }
      
      public function findFirstItem(categoryId:int, validate:Boolean = true) : InventoryItemInfo
      {
         var i:InventoryItemInfo = null;
         for each(i in this._items)
         {
            if(i.CategoryID == categoryId)
            {
               if(!validate || i.getRemainDate() > 0)
               {
                  return i;
               }
            }
         }
         return null;
      }
      
      public function getItemByTemplateId(TemplateID:int) : InventoryItemInfo
      {
         var i:InventoryItemInfo = null;
         for each(i in this._items)
         {
            if(i.TemplateID == TemplateID)
            {
               return i;
            }
         }
         return null;
      }
      
      public function findEquipedItemByTemplateId(TemplateID:int, validate:Boolean = true) : InventoryItemInfo
      {
         var i:InventoryItemInfo = null;
         for each(i in this._items)
         {
            if(i.TemplateID == TemplateID)
            {
               if(i.Place <= 30)
               {
                  if(!validate || i.getRemainDate() > 0)
                  {
                     return i;
                  }
               }
            }
         }
         return null;
      }
      
      public function findIsEquipedByPlace(placeArr:Array) : Array
      {
         var item:InventoryItemInfo = null;
         var i:int = 0;
         var notEquipedPlaceArray:Array = placeArr;
         for each(item in this._items)
         {
            if(item.Place <= 30)
            {
               for(i = 0; i < placeArr.length; i++)
               {
                  if(placeArr[i] == item.Place && item.getRemainDate() > 0)
                  {
                     notEquipedPlaceArray.splice(i,1);
                  }
               }
            }
         }
         return notEquipedPlaceArray;
      }
      
      public function findOvertimeItems(lefttime:Number = 0) : Array
      {
         var i:InventoryItemInfo = null;
         var num:Number = NaN;
         var list:Array = new Array();
         for each(i in this._items)
         {
            num = i.getRemainDate();
            if(num > lefttime && num < this.NUMBER)
            {
               list.push(i);
            }
         }
         return list;
      }
      
      public function findOvertimeItemsByBody() : Array
      {
         var num:Number = NaN;
         var list:Array = [];
         for(var i:uint = 0; i < 30; i++)
         {
            if(Boolean(this._items[i] as InventoryItemInfo))
            {
               num = (this._items[i] as InventoryItemInfo).getRemainDate();
               if(num <= 0 && ShopManager.Instance.canAddPrice((this._items[i] as InventoryItemInfo).TemplateID))
               {
                  list.push(this._items[i]);
               }
            }
         }
         return list;
      }
      
      public function findOvertimeItemsByBodyII() : Array
      {
         var num:Number = NaN;
         var list:Array = [];
         for(var i:uint = 0; i < 80; i++)
         {
            if(Boolean(this._items[i] as InventoryItemInfo))
            {
               if(i < 30)
               {
                  num = (this._items[i] as InventoryItemInfo).getRemainDate();
               }
               if((this._items[i] as InventoryItemInfo).isGold)
               {
                  num = (this._items[i] as InventoryItemInfo).getGoldRemainDate();
               }
               if(num <= 0)
               {
                  list.push(this._items[i]);
               }
            }
         }
         return list;
      }
      
      public function findItemsForEach(categoryId:int, validate:Boolean = true) : Array
      {
         var i:InventoryItemInfo = null;
         var t:DictionaryData = new DictionaryData();
         for each(i in this._items)
         {
            if(i.CategoryID == categoryId && t[i.TemplateID] == null)
            {
               if(!validate || i.getRemainDate() > 0)
               {
                  t.add(i.TemplateID,i);
               }
            }
         }
         return t.list;
      }
      
      public function findFistItemByTemplateId(templateId:int, validate:Boolean = true, usedFirst:Boolean = false) : InventoryItemInfo
      {
         var i:InventoryItemInfo = null;
         var used:InventoryItemInfo = null;
         var normal:InventoryItemInfo = null;
         for each(i in this._items)
         {
            if(i.TemplateID == templateId && (!validate || i.getRemainDate() > 0))
            {
               if(!usedFirst)
               {
                  return i;
               }
               if(i.IsUsed)
               {
                  if(used == null)
                  {
                     used = i;
                  }
               }
               else if(normal == null)
               {
                  normal = i;
               }
            }
         }
         return Boolean(used) ? used : normal;
      }
      
      public function findBodyThingByCategory(id:int) : Array
      {
         var item:InventoryItemInfo = null;
         var arr:Array = new Array();
         for(var i:int = 0; i < 30; i++)
         {
            item = this._items[i] as InventoryItemInfo;
            if(item != null)
            {
               if(item.CategoryID == id)
               {
                  arr.push(item);
               }
            }
         }
         return arr;
      }
      
      public function getItemCountByTemplateIdBindType(templateId:int, bindType:int) : int
      {
         var i:InventoryItemInfo = null;
         var count:int = 0;
         for each(i in this._items)
         {
            if(i.TemplateID == templateId && i.getRemainDate() > 0 && (bindType == 1 && !i.IsBinds || bindType == 2 && i.IsBinds))
            {
               count += i.Count;
            }
         }
         return count;
      }
      
      public function getItemCountByTemplateId(templateId:int, validate:Boolean = true) : int
      {
         var i:InventoryItemInfo = null;
         var count:int = 0;
         for each(i in this._items)
         {
            if(i.TemplateID == templateId && (!validate || i.getRemainDate() > 0))
            {
               count += i.Count;
            }
         }
         return count;
      }
      
      public function getLimitSLItemCountByTemplateId(templateId:int, LimitValue:int = -1, validate:Boolean = true) : int
      {
         var i:InventoryItemInfo = null;
         var count:int = 0;
         for each(i in this._items)
         {
            if(i.TemplateID == templateId && i.Place > 30 && (i.StrengthenLevel == LimitValue || LimitValue == -1) && (!validate || i.getRemainDate() > 0))
            {
               count += i.Count;
            }
         }
         return count;
      }
      
      public function getBagItemCountByTemplateIdBindType(templateId:int, bindType:int) : int
      {
         var i:InventoryItemInfo = null;
         var count:int = 0;
         var selfID:int = PlayerManager.Instance.Self.ID;
         for each(i in this._items)
         {
            if(i.TemplateID == templateId && i.Place > 30 && i.getRemainDate() > 0 && (bindType == 1 && !i.IsBinds || bindType == 2 && i.IsBinds))
            {
               count += i.Count;
            }
         }
         return count;
      }
      
      public function getBagItemCountByTemplateId(templateId:int, validate:Boolean = true) : int
      {
         var i:InventoryItemInfo = null;
         var count:int = 0;
         var selfID:int = PlayerManager.Instance.Self.ID;
         for each(i in this._items)
         {
            if(i.TemplateID == templateId && i.Place > 30 && (!validate || i.getRemainDate() > 0))
            {
               count += i.Count;
            }
         }
         return count;
      }
      
      public function getItemCountByCategoryID(categoryID:int, validate:Boolean = true) : int
      {
         var i:InventoryItemInfo = null;
         var count:int = 0;
         for each(i in this._items)
         {
            if(i.CategoryID == categoryID && (!validate || i.getRemainDate() > 0))
            {
               count += i.Count;
            }
         }
         return count;
      }
      
      public function findItemsByTempleteID(templeteID:int, validate:Boolean = true) : Array
      {
         var i:InventoryItemInfo = null;
         var t:DictionaryData = new DictionaryData();
         for each(i in this._items)
         {
            if(i.TemplateID == templeteID && t[i.TemplateID] == null)
            {
               if(!validate || i.getRemainDate() > 0)
               {
                  t.add(i.TemplateID,i);
               }
            }
         }
         return t.list;
      }
      
      public function findCellsByTempleteID(templeteID:int, validate:Boolean = true) : Array
      {
         var i:InventoryItemInfo = null;
         var t:Array = new Array();
         for each(i in this._items)
         {
            if(i.TemplateID == templeteID && (!validate || i.getRemainDate() > 0))
            {
               t.push(i);
            }
         }
         return t;
      }
      
      public function clearnAll() : void
      {
         for(var i:int = 0; i < 49; i++)
         {
            this.removeItemAt(i);
         }
      }
      
      public function unlockItem(item:InventoryItemInfo) : void
      {
         item.lock = false;
         this.onItemChanged(item.Place,item);
      }
      
      public function unLockAll() : void
      {
         var i:InventoryItemInfo = null;
         this.beginChanges();
         for each(i in this._items)
         {
            if(i.lock)
            {
               this.onItemChanged(i.Place,i);
            }
            i.lock = false;
         }
         this.commiteChanges();
      }
      
      public function sortBag(type:int, bagInfo:BagInfo, startPlace:int, endPlace:int, isSegistration:Boolean = false) : void
      {
         var bagData:DictionaryData = null;
         var arrayBag:Array = null;
         var arrayBag2:Array = null;
         var CategoryIDSort:int = 0;
         var listLen:int = 0;
         var beginPlace:int = 0;
         var i:int = 0;
         var fooBA:ByteArray = null;
         if(type != BagInfo.TASKBAG && type != BagInfo.BEADBAG && type != BagInfo.MAGICSTONE)
         {
            bagData = bagInfo.items;
            arrayBag = [];
            arrayBag2 = [];
            CategoryIDSort = 0;
            listLen = int(bagData.list.length);
            beginPlace = 0;
            if(bagInfo == PlayerManager.Instance.Self.Bag)
            {
               beginPlace = 31;
               endPlace = 79;
            }
            while(i < listLen)
            {
               if(int(bagData.list[i].Place) >= beginPlace && int(bagData.list[i].Place) <= endPlace)
               {
                  arrayBag.push({
                     "TemplateID":bagData.list[i].TemplateID,
                     "ItemID":bagData.list[i].ItemID,
                     "CategoryIDSort":this.getBagGoodsCategoryIDSort(uint(bagData.list[i].CategoryID)),
                     "Place":bagData.list[i].Place,
                     "RemainDate":bagData.list[i].getRemainDate() > 0,
                     "CanStrengthen":bagData.list[i].CanStrengthen,
                     "StrengthenLevel":bagData.list[i].StrengthenLevel,
                     "IsBinds":bagData.list[i].IsBinds
                  });
               }
               i++;
            }
            fooBA = new ByteArray();
            fooBA.writeObject(arrayBag);
            fooBA.position = 0;
            arrayBag2 = fooBA.readObject() as Array;
            arrayBag.sortOn(["RemainDate","CategoryIDSort","TemplateID","CanStrengthen","IsBinds","StrengthenLevel","Place"],[Array.DESCENDING,Array.NUMERIC,Array.NUMERIC | Array.DESCENDING,Array.DESCENDING,Array.DESCENDING,Array.NUMERIC | Array.DESCENDING,Array.NUMERIC]);
            if(this.bagComparison(arrayBag,arrayBag2,beginPlace) && !isSegistration)
            {
               return;
            }
            SocketManager.Instance.out.sendMoveGoodsAll(bagInfo.BagType,arrayBag,beginPlace,isSegistration);
         }
         else if(type == BagInfo.TASKBAG && isSegistration)
         {
            this.sortCard();
         }
         else if(type == BagInfo.BEADBAG)
         {
            this.sortBead(bagInfo,startPlace,endPlace,isSegistration);
         }
         else if(type == BagInfo.MAGICSTONE)
         {
            this.sortMagicStone(bagInfo,startPlace,endPlace);
         }
      }
      
      private function sortMagicStone(bagInfo:BagInfo, startPlace:int, endPlace:int) : void
      {
         var item:InventoryItemInfo = null;
         var fooBA:ByteArray = null;
         var bagData:DictionaryData = bagInfo.items;
         var arrayBag:Array = [];
         var arrayBag2:Array = [];
         for each(item in bagData)
         {
            if(item.Place >= startPlace && item.Place <= endPlace)
            {
               arrayBag.push({
                  "Property":this.propertyAssort(item),
                  "Quality":item.Quality,
                  "StrengthenLevel":item.StrengthenLevel,
                  "StrengthenExp":item.StrengthenExp,
                  "Place":item.Place,
                  "Name":item.Name,
                  "ItemID":item.ItemID,
                  "TemplateID":item.TemplateID
               });
            }
         }
         fooBA = new ByteArray();
         fooBA.writeObject(arrayBag);
         fooBA.position = 0;
         arrayBag2 = fooBA.readObject() as Array;
         arrayBag.sortOn(["Property","Quality","StrengthenLevel","StrengthenExp","Place"],[Array.NUMERIC,Array.NUMERIC | Array.DESCENDING,Array.NUMERIC | Array.DESCENDING,Array.NUMERIC | Array.DESCENDING,Array.NUMERIC]);
         if(this.bagComparison(arrayBag,arrayBag2,startPlace))
         {
            return;
         }
         SocketManager.Instance.out.sortMgStoneBag(arrayBag,startPlace);
      }
      
      private function propertyAssort(item:InventoryItemInfo) : int
      {
         if(item.Property3 == "4")
         {
            return 1;
         }
         if(item.Property3 == "3")
         {
            return 2;
         }
         if(item.Property3 == "2")
         {
            return 3;
         }
         if(item.MagicAttack > 0)
         {
            return 4;
         }
         if(item.MagicDefence > 0)
         {
            return 5;
         }
         if(item.AttackCompose > 0)
         {
            return 6;
         }
         if(item.DefendCompose > 0)
         {
            return 7;
         }
         if(item.AgilityCompose > 0)
         {
            return 8;
         }
         if(item.LuckCompose > 0)
         {
            return 9;
         }
         return 0;
      }
      
      private function sortBead(bagInfo:BagInfo, startPlace:int, endPlace:int, isSegistration:Boolean) : void
      {
         var bagData:DictionaryData = bagInfo.items;
         var arrayBag:Array = [];
         var arrayBag2:Array = [];
         var listLen:int = int(bagData.list.length);
         for(var i:int = 0; i < listLen; i++)
         {
            if(int(bagData.list[i].Place) >= startPlace && int(bagData.list[i].Place) <= endPlace)
            {
               arrayBag.push({
                  "Type":bagData.list[i].Property2,
                  "TemplateID":bagData.list[i].TemplateID,
                  "Level":bagData.list[i].Hole1,
                  "Exp":bagData.list[i].Hole2,
                  "Place":bagData.list[i].Place
               });
            }
         }
         var fooBA:ByteArray = new ByteArray();
         fooBA.writeObject(arrayBag);
         fooBA.position = 0;
         arrayBag2 = fooBA.readObject() as Array;
         arrayBag.sortOn(["Type","TemplateID","Level","Exp","Place"],[Array.NUMERIC,Array.DESCENDING,Array.DESCENDING,Array.DESCENDING,Array.NUMERIC]);
         if(this.bagComparison(arrayBag,arrayBag2,startPlace) && !isSegistration)
         {
            return;
         }
         SocketManager.Instance.out.sendMoveGoodsAll(bagInfo.BagType,arrayBag,startPlace,isSegistration);
      }
      
      private function sortCard() : void
      {
         var idVec:Vector.<int> = null;
         var j:int = 0;
         var data:DictionaryData = null;
         var info:CardInfo = null;
         var sortData:Vector.<int> = new Vector.<int>();
         var sortArr:Vector.<SetsInfo> = CardControl.Instance.model.setsSortRuleVector;
         for(var m:int = 0; m < sortArr.length; m++)
         {
            idVec = sortArr[m].cardIdVec;
            for(j = 0; j < idVec.length; j++)
            {
               data = PlayerManager.Instance.Self.cardBagDic;
               for each(info in data)
               {
                  if(info.TemplateID == idVec[j])
                  {
                     sortData.push(info.Place);
                     break;
                  }
               }
            }
         }
         SocketManager.Instance.out.sendSortCards(sortData);
      }
      
      public function getBagGoodsCategoryIDSort(CategoryID:uint) : int
      {
         var arrCategoryIDSort:Array = [EquipType.ARM,EquipType.OFFHAND,EquipType.HEAD,EquipType.CLOTH,EquipType.ARMLET,EquipType.RING,EquipType.GLASS,EquipType.NECKLACE,EquipType.SUITS,EquipType.WING,EquipType.HAIR,EquipType.FACE,EquipType.EFF,EquipType.CHATBALL,EquipType.ATACCKT,EquipType.DEFENT,EquipType.ATTRIBUTE];
         for(var i:int = 0; i < arrCategoryIDSort.length; i++)
         {
            if(CategoryID == arrCategoryIDSort[i])
            {
               return i;
            }
         }
         return 9999;
      }
      
      private function bagComparison(bagArray1:Array, bagArray2:Array, startPlace:int) : Boolean
      {
         if(bagArray1.length < bagArray2.length)
         {
            return false;
         }
         var len:int = int(bagArray1.length);
         for(var i:int = 0; i < len; i++)
         {
            if(i + startPlace != bagArray2[i].Place || bagArray1[i].ItemID != bagArray2[i].ItemID || bagArray1[i].TemplateID != bagArray2[i].TemplateID)
            {
               return false;
            }
         }
         return true;
      }
      
      public function itemBgNumber(startPlace:int, endPlace:int) : int
      {
         var result:int = 0;
         for(var i:int = startPlace; i <= endPlace; i++)
         {
            if(this._items[i] != null)
            {
               result++;
            }
         }
         return result;
      }
      
      public function getItemByItemId(itemId:int) : InventoryItemInfo
      {
         var i:InventoryItemInfo = null;
         for each(i in this._items)
         {
            if(i.ItemID == itemId)
            {
               return i;
            }
         }
         return null;
      }
   }
}

