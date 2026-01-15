package store.data
{
   import com.pickgliss.ui.ComponentFactory;
   import ddt.data.BagInfo;
   import ddt.data.EquipType;
   import ddt.data.StoneType;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.player.PlayerInfo;
   import ddt.data.player.SelfInfo;
   import ddt.events.BagEvent;
   import flash.events.EventDispatcher;
   import flash.utils.Dictionary;
   import road7th.data.DictionaryData;
   import road7th.data.DictionaryEvent;
   import store.events.StoreBagEvent;
   import store.events.UpdateItemEvent;
   
   public class StoreModel extends EventDispatcher
   {
      
      private static var _holeExpModel:HoleExpModel;
      
      private static const FORMULA_FLOCCULANT:int = 11301;
      
      private static const FORMULA_BIRD:int = 11201;
      
      private static const FORMULA_SNAKE:int = 11202;
      
      private static const FORMULA_DRAGON:int = 11203;
      
      private static const FORMULA_TIGER:int = 11204;
      
      private static const FORMULA_RING:int = 11302;
      
      private static const FORMULA_BANGLE:int = 11303;
      
      private static const RING_TIANYU:int = 9002;
      
      private static const RIN_GZHUFU:int = 8002;
      
      private var _info:SelfInfo;
      
      private var _equipmentBag:DictionaryData;
      
      private var _propBag:DictionaryData;
      
      private var _canCpsEquipmentList:DictionaryData;
      
      private var _canStrthEqpmtList:DictionaryData;
      
      private var _canExaltEqpmtList:DictionaryData;
      
      private var _strthList:DictionaryData;
      
      private var _cpsAndANchList:DictionaryData;
      
      private var _cpsAndStrthAndformula:DictionaryData;
      
      private var _exaltRock:DictionaryData;
      
      private var _canRongLiangPropList:DictionaryData;
      
      private var _canTransEquipmengtList:DictionaryData;
      
      private var _canNotTransEquipmengtList:DictionaryData;
      
      private var _canRongLiangEquipmengtList:DictionaryData;
      
      private var _canLianhuaEquipList:DictionaryData;
      
      private var _canLianhuaPropList:DictionaryData;
      
      private var _canEmbedEquipList:DictionaryData;
      
      private var _canEmbedPropList:DictionaryData;
      
      private var _currentPanel:int;
      
      private var _needAutoLink:int = 0;
      
      public function StoreModel(info:PlayerInfo)
      {
         super();
         this._info = info as SelfInfo;
         this._equipmentBag = this._info.Bag.items;
         this._propBag = this._info.PropBag.items;
         this.initData();
         this.initEvent();
      }
      
      public static function getHoleMaxLv() : int
      {
         if(_holeExpModel == null)
         {
            _holeExpModel = ComponentFactory.Instance.creatCustomObject("HoleExpModel");
         }
         return _holeExpModel.getMaxLv();
      }
      
      public static function getHoleMaxOpLv() : int
      {
         if(_holeExpModel == null)
         {
            _holeExpModel = ComponentFactory.Instance.creatCustomObject("HoleExpModel");
         }
         return _holeExpModel.getMaxOpLv();
      }
      
      public static function getHoleExpByLv(lv:int) : int
      {
         if(_holeExpModel == null)
         {
            _holeExpModel = ComponentFactory.Instance.creatCustomObject("HoleExpModel");
         }
         return _holeExpModel.getExpByLevel(lv);
      }
      
      private function initData() : void
      {
         this._canStrthEqpmtList = new DictionaryData();
         this._canCpsEquipmentList = new DictionaryData();
         this._strthList = new DictionaryData();
         this._cpsAndANchList = new DictionaryData();
         this._canTransEquipmengtList = new DictionaryData();
         this._canNotTransEquipmengtList = new DictionaryData();
         this._canLianhuaEquipList = new DictionaryData();
         this._canLianhuaPropList = new DictionaryData();
         this._canEmbedEquipList = new DictionaryData();
         this._canEmbedPropList = new DictionaryData();
         this._canRongLiangPropList = new DictionaryData();
         this._exaltRock = new DictionaryData();
         this._canExaltEqpmtList = new DictionaryData();
         this._canRongLiangEquipmengtList = new DictionaryData();
         this.pickValidItemsOutOf(this._equipmentBag,true);
         this.pickValidItemsOutOf(this._propBag,false);
         this._canStrthEqpmtList = this.sortEquipList(this._canStrthEqpmtList);
         this._canCpsEquipmentList = this.sortEquipList(this._canCpsEquipmentList);
         this._strthList = this.sortPropStrthList(this._strthList);
         this._cpsAndANchList = this.sortPropList(this._cpsAndANchList,true);
         this._canRongLiangPropList = this.sortPropList(this._canRongLiangPropList);
         this._canTransEquipmengtList = this.sortEquipList(this._canTransEquipmengtList);
         this._canNotTransEquipmengtList = this.sortEquipList(this._canNotTransEquipmengtList);
         this._canLianhuaEquipList = this.sortEquipList(this._canLianhuaEquipList);
         this._canLianhuaPropList = this.sortPropList(this._canLianhuaPropList);
         this._canEmbedEquipList = this.sortEquipList(this._canEmbedEquipList);
         this._canEmbedPropList = this.sortPropList(this._canEmbedPropList);
         this._canExaltEqpmtList = this.sortEquipList(this._canExaltEqpmtList);
         this._canRongLiangEquipmengtList = this.sortRoogEquipList(this._canRongLiangEquipmengtList);
      }
      
      private function pickValidItemsOutOf(bag:DictionaryData, isEquip:Boolean) : void
      {
         var item:InventoryItemInfo = null;
         for each(item in bag)
         {
            if(isEquip)
            {
               if(this.isProperTo_CanStrthEqpmtList(item))
               {
                  this._canStrthEqpmtList.add(this._canStrthEqpmtList.length,item);
               }
               if(this.isProperTo_CanCpsEquipmentList(item))
               {
                  this._canCpsEquipmentList.add(this._canCpsEquipmentList.length,item);
               }
               if(this.isProperTo_CanRongLiangEquipmengtList(item))
               {
                  this._canRongLiangEquipmengtList.add(this._canRongLiangEquipmengtList.length,item);
               }
               if(item.Quality >= 4 && (item.CanCompose || item.CanStrengthen || item.isCanLatentEnergy) && item.CanTransfer == 1)
               {
                  if(this.isProperTo_CanTransEquipmengtList(item))
                  {
                     this._canTransEquipmengtList.add(this._canTransEquipmengtList.length,item);
                  }
                  else if(this.isProperTo_NotCanTransEquipmengtList(item) && item.CanTransfer == 1)
                  {
                     this._canNotTransEquipmengtList.add(this._canNotTransEquipmengtList.length,item);
                  }
               }
               if(this.isProperTo_canLianhuaEquipList(item))
               {
                  this._canLianhuaEquipList.add(this._canLianhuaEquipList.length,item);
               }
               if(this.isProperTo_CanEmbedEquipList(item))
               {
                  this._canEmbedEquipList.add(this._canEmbedEquipList.length,item);
               }
               if(this.isProperTo_CanExaltEqpmtList(item))
               {
                  this._canExaltEqpmtList.add(this._canExaltEqpmtList.length,item);
               }
            }
            else
            {
               if(this.isProperTo_StrthList(item))
               {
                  this._strthList.add(this._strthList.length,item);
               }
               if(this.isProperTo_CpsAndANchList(item))
               {
                  this._cpsAndANchList.add(this._cpsAndANchList.length,item);
               }
               if(this.isProperTo_canLianhuaPropList(item))
               {
                  this._canLianhuaPropList.add(this._canLianhuaPropList.length,item);
               }
               if(this.isProperTo_CanEmbedPropList(item))
               {
                  this._canEmbedPropList.add(this._canEmbedPropList.length,item);
               }
               if(this.isProperTo_canRongLiangProperList(item))
               {
                  this._canRongLiangPropList.add(this._canRongLiangPropList.length,item);
               }
               if(this.isProperTo_ExaltList(item))
               {
                  this._exaltRock.add(this._exaltRock.length,item);
               }
            }
         }
      }
      
      private function isProperTo_canRongLiangProperList(item:InventoryItemInfo) : Boolean
      {
         if(item.Property1 == StoneType.FORMULA)
         {
            return true;
         }
         if(item.FusionType != 0 && item.getRemainDate() > 0)
         {
            return true;
         }
         return false;
      }
      
      private function initEvent() : void
      {
         this._info.PropBag.addEventListener(BagEvent.UPDATE,this.updateBag);
         this._info.Bag.addEventListener(BagEvent.UPDATE,this.updateBag);
      }
      
      private function updateBag(evt:BagEvent) : void
      {
         var i:InventoryItemInfo = null;
         var c:InventoryItemInfo = null;
         var bag:BagInfo = evt.target as BagInfo;
         var changes:Dictionary = evt.changedSlots;
         for each(i in changes)
         {
            c = bag.getItemAt(i.Place);
            if(Boolean(c))
            {
               if(bag.BagType == BagInfo.EQUIPBAG)
               {
                  this.__updateEquip(c);
               }
               else if(bag.BagType == BagInfo.PROPBAG)
               {
                  this.__updateProp(c);
               }
            }
            else if(bag.BagType == BagInfo.EQUIPBAG)
            {
               this.removeFrom(i,this._canStrthEqpmtList);
               this.removeFrom(i,this._canCpsEquipmentList);
               this.removeFrom(i,this._canTransEquipmengtList);
               this.removeFrom(i,this._canNotTransEquipmengtList);
               this.removeFrom(i,this._canLianhuaEquipList);
               this.removeFrom(i,this._canEmbedEquipList);
               this.removeFrom(i,this._canRongLiangEquipmengtList);
               this.removeFrom(i,this._canExaltEqpmtList);
            }
            else
            {
               this.removeFrom(i,this._strthList);
               this.removeFrom(i,this._cpsAndANchList);
               this.removeFrom(i,this._canRongLiangPropList);
               this.removeFrom(i,this._canLianhuaPropList);
               this.removeFrom(i,this._canEmbedPropList);
               this.removeFrom(i,this._exaltRock);
            }
         }
      }
      
      private function __updateEquip(item:InventoryItemInfo) : void
      {
         if(this.isProperTo_CanStrthEqpmtList(item))
         {
            this.updateDic(this._canStrthEqpmtList,item);
         }
         else
         {
            this.removeFrom(item,this._canStrthEqpmtList);
         }
         if(this.isProperTo_CanCpsEquipmentList(item))
         {
            this.updateDic(this._canCpsEquipmentList,item);
         }
         else
         {
            this.removeFrom(item,this._canCpsEquipmentList);
         }
         if(this.isProperTo_CanTransEquipmengtList(item) && item.CanTransfer == 1 && item.Quality >= 4)
         {
            this.updateDic(this._canTransEquipmengtList,item);
         }
         else
         {
            this.removeFrom(item,this._canTransEquipmengtList);
         }
         if(this.isProperTo_NotCanTransEquipmengtList(item) && item.CanTransfer == 1)
         {
            this.updateDic(this._canNotTransEquipmengtList,item);
         }
         else
         {
            this.removeFrom(item,this._canNotTransEquipmengtList);
         }
         if(this.isProperTo_CanRongLiangEquipmengtList(item))
         {
            this.updateDic(this._canRongLiangEquipmengtList,item);
         }
         else
         {
            this.removeFrom(item,this._canRongLiangEquipmengtList);
         }
         if(this.isProperTo_canLianhuaEquipList(item))
         {
            this.updateDic(this._canLianhuaEquipList,item);
         }
         else
         {
            this.removeFrom(item,this._canLianhuaEquipList);
         }
         if(this.isProperTo_CanEmbedEquipList(item))
         {
            this.updateDic(this._canEmbedEquipList,item);
         }
         else
         {
            this.removeFrom(item,this._canEmbedEquipList);
         }
         if(this.isProperTo_CanExaltEqpmtList(item))
         {
            this.updateDic(this._canExaltEqpmtList,item);
         }
         else
         {
            this.removeFrom(item,this._canExaltEqpmtList);
         }
      }
      
      private function __updateProp(item:InventoryItemInfo) : void
      {
         if(this.isProperTo_CpsAndANchList(item))
         {
            this.updateDic(this._cpsAndANchList,item);
         }
         else
         {
            this.removeFrom(item,this._cpsAndANchList);
         }
         if(this.isProperTo_canRongLiangProperList(item))
         {
            this.updateDic(this._canRongLiangPropList,item);
         }
         else
         {
            this.removeFrom(item,this._canRongLiangPropList);
         }
         if(this.isProperTo_StrthList(item))
         {
            this.updateDic(this._strthList,item);
         }
         else
         {
            this.removeFrom(item,this._strthList);
         }
         if(this.isProperTo_ExaltList(item))
         {
            this.updateDic(this._exaltRock,item);
         }
         else
         {
            this.removeFrom(item,this._exaltRock);
         }
         if(this.isProperTo_canLianhuaPropList(item))
         {
            this.updateDic(this._canLianhuaPropList,item);
         }
         else
         {
            this.removeFrom(item,this._canLianhuaPropList);
         }
         if(this.isProperTo_CanEmbedPropList(item))
         {
            this.updateDic(this._canEmbedPropList,item);
         }
         else
         {
            this.removeFrom(item,this._canEmbedPropList);
         }
      }
      
      private function isProperTo_CanCpsEquipmentList(item:InventoryItemInfo) : Boolean
      {
         if(item.CanCompose && item.getRemainDate() > 0)
         {
            return true;
         }
         return false;
      }
      
      private function isProperTo_CanStrthEqpmtList(item:InventoryItemInfo) : Boolean
      {
         if(item.CanStrengthen && item.getRemainDate() > 0)
         {
            return true;
         }
         return false;
      }
      
      private function isProperTo_CanExaltEqpmtList(item:InventoryItemInfo) : Boolean
      {
         if(item.CanStrengthen && item.getRemainDate() > 0 && item.StrengthenLevel >= 12)
         {
            return true;
         }
         return false;
      }
      
      private function isProperTo_StrthList(item:InventoryItemInfo) : Boolean
      {
         if(item.getRemainDate() <= 0)
         {
            return false;
         }
         if(EquipType.isStrengthStone(item))
         {
            return true;
         }
         return false;
      }
      
      private function isProperTo_ExaltList(item:InventoryItemInfo) : Boolean
      {
         if(item.getRemainDate() <= 0)
         {
            return false;
         }
         if(item.CategoryID == 11 && item.Property1 == "45")
         {
            return true;
         }
         return false;
      }
      
      private function isProperTo_CpsAndANchList(item:InventoryItemInfo) : Boolean
      {
         if(item.getRemainDate() <= 0)
         {
            return false;
         }
         if(EquipType.isComposeStone(item) || item.CategoryID == 11 && item.Property1 == StoneType.LUCKY)
         {
            return true;
         }
         return false;
      }
      
      private function isProperTo_CpsAndStrthAndformula(item:InventoryItemInfo) : Boolean
      {
         if(item.getRemainDate() <= 0)
         {
            return false;
         }
         if(item.FusionType != 0)
         {
            return true;
         }
         if(EquipType.isComposeStone(item) || item.CategoryID == 11 && item.Property1 == StoneType.FORMULA || EquipType.isStrengthStone(item))
         {
            return true;
         }
         if(item.CategoryID == 11 && item.Property1 == "31")
         {
            return true;
         }
         return false;
      }
      
      private function isProperTo_CanRongLiangEquipmengtList(item:InventoryItemInfo) : Boolean
      {
         if(item.FusionType != 0 && item.getRemainDate() > 0 && item.FusionRate > 0)
         {
            return true;
         }
         return false;
      }
      
      private function isProperTo_canLianhuaEquipList(item:InventoryItemInfo) : Boolean
      {
         if(item.RefineryLevel >= 0 && item.getRemainDate() >= 0)
         {
            return true;
         }
         return false;
      }
      
      private function isProperTo_canLianhuaPropList(item:InventoryItemInfo) : Boolean
      {
         if(item.getRemainDate() <= 0)
         {
            return false;
         }
         if(item.CategoryID == 11 && (item.Property1 == "32" || item.Property1 == "33") || item.CategoryID == 11 && item.Property1 == StoneType.LUCKY)
         {
            return true;
         }
         return false;
      }
      
      private function isProperTo_CanTransEquipmengtList(item:InventoryItemInfo) : Boolean
      {
         if(item.CategoryID == 27)
         {
            return false;
         }
         if(item.StrengthenLevel > 0 || item.AttackCompose > 0 || item.DefendCompose > 0 || item.AgilityCompose > 0 || item.LuckCompose > 0 || item.isHasLatentEnergy || item.isCanEnchant() && item.MagicLevel > 0)
         {
            return true;
         }
         return false;
      }
      
      private function isProperTo_NotCanTransEquipmengtList(item:InventoryItemInfo) : Boolean
      {
         if(!this.isProperTo_CanTransEquipmengtList(item))
         {
            return true;
         }
         return false;
      }
      
      private function isProperTo_CanEmbedEquipList(item:InventoryItemInfo) : Boolean
      {
         var hole:String = null;
         var propertyArr:Array = null;
         if(item.getRemainDate() <= 0 || item.CategoryID == 27)
         {
            return false;
         }
		 if(!item || !item.Hole)
		 {
			 return false;
		 }
         var holeArr:Array = item.Hole.split("|");
         for each(hole in holeArr)
         {
            propertyArr = hole.split(",");
            if(propertyArr[1] == "-1")
            {
               return false;
            }
         }
         return true;
      }
      
      private function isProperTo_CanEmbedPropList(item:InventoryItemInfo) : Boolean
      {
         if(item.getRemainDate() <= 0)
         {
            return false;
         }
         if(EquipType.isDrill(item))
         {
            return true;
         }
         if(item.CategoryID == 11 && (item.Property1 == "31" || item.Property1 == "16"))
         {
            return true;
         }
         return false;
      }
      
      private function updateDic(dic:DictionaryData, item:InventoryItemInfo) : void
      {
         for(var i:int = 0; i < dic.length; i++)
         {
            if(dic[i] != null && dic[i].Place == item.Place)
            {
               dic.add(i,item);
               dic.dispatchEvent(new UpdateItemEvent(UpdateItemEvent.UPDATEITEMEVENT,i,item));
               return;
            }
         }
         this.addItemToTheFirstNullCell(item,dic);
      }
      
      private function __removeEquip(evt:DictionaryEvent) : void
      {
         var item_1:InventoryItemInfo = evt.data as InventoryItemInfo;
         this.removeFrom(item_1,this._canCpsEquipmentList);
         this.removeFrom(item_1,this._canStrthEqpmtList);
         this.removeFrom(item_1,this._canTransEquipmengtList);
         this.removeFrom(item_1,this._canRongLiangEquipmengtList);
      }
      
      private function addItemToTheFirstNullCell(item:InventoryItemInfo, dic:DictionaryData) : void
      {
         dic.add(this.findFirstNullCellID(dic),item);
      }
      
      private function findFirstNullCellID(dic:DictionaryData) : int
      {
         var result:int = -1;
         var lth:int = dic.length;
         for(var i:int = 0; i <= lth; i++)
         {
            if(dic[i] == null)
            {
               result = i;
               break;
            }
         }
         return result;
      }
      
      private function removeFrom(item:InventoryItemInfo, dic:DictionaryData) : void
      {
         var lth:int = dic.length;
         for(var i:int = 0; i < lth; i++)
         {
            if(Boolean(dic[i]) && dic[i].Place == item.Place)
            {
               dic[i] = null;
               dic.dispatchEvent(new StoreBagEvent(StoreBagEvent.REMOVE,i,item));
               break;
            }
         }
      }
      
      public function sortEquipList(equipList:DictionaryData) : DictionaryData
      {
         var temp:DictionaryData = equipList;
         equipList = new DictionaryData();
         this.fillByCategoryID(temp,equipList,EquipType.ARM);
         this.fillByCategoryID(temp,equipList,EquipType.CLOTH);
         this.fillByCategoryID(temp,equipList,EquipType.HEAD);
         this.fillByCategoryID(temp,equipList,EquipType.GLASS);
         this.fillByCategoryID(temp,equipList,EquipType.HAIR);
         this.fillByCategoryID(temp,equipList,EquipType.EFF);
         this.fillByCategoryID(temp,equipList,EquipType.FACE);
         this.fillByCategoryID(temp,equipList,EquipType.SUITS);
         this.fillByCategoryID(temp,equipList,EquipType.WING);
         this.fillByCategoryID(temp,equipList,EquipType.ARMLET);
         this.fillByCategoryID(temp,equipList,EquipType.RING);
         this.fillByCategoryID(temp,equipList,EquipType.OFFHAND);
         return this.sortByIsUsed(equipList);
      }
      
      private function sortByIsUsed(source:DictionaryData) : DictionaryData
      {
         var item:InventoryItemInfo = null;
         var itemInfo:InventoryItemInfo = null;
         var temp:DictionaryData = new DictionaryData();
         var dic:DictionaryData = new DictionaryData();
         for each(item in source)
         {
            if(item.Place < 17)
            {
               temp.add(temp.length,item);
            }
            else
            {
               dic.add(dic.length,item);
            }
         }
         for each(itemInfo in dic)
         {
            temp.add(temp.length,itemInfo);
         }
         return temp;
      }
      
      public function sortRoogEquipList(equipList:DictionaryData) : DictionaryData
      {
         var temp:DictionaryData = equipList;
         equipList = new DictionaryData();
         this.rongLiangFill(temp,equipList,EquipType.ARM);
         this.rongLiangFill(temp,equipList,EquipType.OFFHAND);
         this.rongLiangFill(temp,equipList,EquipType.ARMLET);
         this.rongLiangFill(temp,equipList,EquipType.RING);
         this.rongLiangFill(temp,equipList,EquipType.NECKLACE);
         this.rongLiangFill(temp,equipList,EquipType.HEALSTONE);
         return equipList;
      }
      
      private function fillByCategoryID(source:DictionaryData, target:DictionaryData, categoryID:int) : void
      {
         var item:InventoryItemInfo = null;
         for each(item in source)
         {
            if(item.CategoryID == categoryID)
            {
               target.add(target.length,item);
            }
         }
      }
      
      private function rongLiangFill(source:DictionaryData, target:DictionaryData, CategoryID:int) : void
      {
         var item:InventoryItemInfo = null;
         for each(item in source)
         {
            if(item.CategoryID == CategoryID)
            {
               target.add(target.length,item);
            }
         }
      }
      
      private function rongLiangFunFill(source:DictionaryData, target:DictionaryData) : void
      {
         var item:InventoryItemInfo = null;
         for each(item in source)
         {
            if(item.Property1 == StoneType.FORMULA)
            {
               target.add(target.length,item);
            }
         }
      }
      
      private function fillByTemplateID(source:DictionaryData, target:DictionaryData, templateID:int) : void
      {
         var item:InventoryItemInfo = null;
         for each(item in source)
         {
            if(item.TemplateID == templateID)
            {
               target.add(target.length,item);
            }
         }
      }
      
      private function fillByProperty1AndProperty3(source:DictionaryData, target:DictionaryData, property1:String, property3:String) : void
      {
         var item:InventoryItemInfo = null;
         var tempArr:Array = [];
         for each(item in source)
         {
            if(item.Property1 == property1 && item.Property3 == property3)
            {
               tempArr.push(item);
            }
         }
         this.bubbleSort(tempArr);
         for each(item in tempArr)
         {
            target.add(target.length,item);
         }
      }
      
      private function fillByProperty1(source:DictionaryData, target:DictionaryData, property1:String) : void
      {
         var item:InventoryItemInfo = null;
         var tempArr:Array = [];
         for each(item in source)
         {
            if(item.Property1 == property1)
            {
               tempArr.push(item);
            }
         }
         this.bubbleSort(tempArr);
         for each(item in tempArr)
         {
            target.add(target.length,item);
         }
      }
      
      private function findByTemplateID(source:DictionaryData, target:DictionaryData, templateId:int) : void
      {
         var item:InventoryItemInfo = null;
         var tempArr:Array = [];
         for each(item in source)
         {
            if(item.TemplateID == templateId)
            {
               tempArr.push(item);
            }
         }
         this.bubbleSort(tempArr);
         for each(item in tempArr)
         {
            target.add(target.length,item);
         }
      }
      
      public function sortPropList(propList:DictionaryData, isCompose:Boolean = false) : DictionaryData
      {
         var temp:DictionaryData = propList;
         propList = new DictionaryData();
         this.rongLiangFunFill(temp,propList);
         this.fillByProperty1(temp,propList,StoneType.STRENGTH);
         this.fillByProperty1(temp,propList,StoneType.STRENGTH_1);
         this.fillByProperty1(temp,propList,StoneType.LIANHUA_MAIN_MATIERIAL);
         this.fillByProperty1(temp,propList,StoneType.LIANHUA_AIDED_MATIERIAL);
         this.fillByProperty1(temp,propList,StoneType.OPENHOLE);
         this.fillByProperty1(temp,propList,"31");
         this.fillByProperty1AndProperty3(temp,propList,StoneType.COMPOSE,StoneType.BIRD);
         this.fillByProperty1AndProperty3(temp,propList,StoneType.COMPOSE,StoneType.SNAKE);
         this.fillByProperty1AndProperty3(temp,propList,StoneType.COMPOSE,StoneType.DRAGON);
         this.fillByProperty1AndProperty3(temp,propList,StoneType.COMPOSE,StoneType.TIGER);
         if(!isCompose)
         {
            this.fillByProperty1(temp,propList,StoneType.SOULSYMBOL);
         }
         this.fillByProperty1(temp,propList,StoneType.LUCKY);
         this.rongLiangFill(temp,propList,8);
         this.rongLiangFill(temp,propList,9);
         this.rongLiangFill(temp,propList,14);
         this.fillByProperty1(temp,propList,StoneType.BADGE);
         return propList;
      }
      
      public function sortPropStrthList(propList:DictionaryData, isCompose:Boolean = false) : DictionaryData
      {
         var temp:DictionaryData = propList;
         propList = new DictionaryData();
         this.rongLiangFunFill(temp,propList);
         this.fillByProperty1(temp,propList,StoneType.STRENGTH);
         this.fillByProperty1(temp,propList,StoneType.STRENGTH_1);
         this.fillByProperty1(temp,propList,StoneType.LIANHUA_MAIN_MATIERIAL);
         this.fillByProperty1(temp,propList,StoneType.LIANHUA_AIDED_MATIERIAL);
         this.fillByProperty1(temp,propList,StoneType.OPENHOLE);
         this.fillByProperty1(temp,propList,"31");
         this.fillByProperty1AndProperty3(temp,propList,StoneType.COMPOSE,StoneType.BIRD);
         this.fillByProperty1AndProperty3(temp,propList,StoneType.COMPOSE,StoneType.SNAKE);
         this.fillByProperty1AndProperty3(temp,propList,StoneType.COMPOSE,StoneType.DRAGON);
         this.fillByProperty1AndProperty3(temp,propList,StoneType.COMPOSE,StoneType.TIGER);
         this.rongLiangFill(temp,propList,8);
         this.rongLiangFill(temp,propList,9);
         this.rongLiangFill(temp,propList,14);
         this.fillByProperty1(temp,propList,StoneType.BADGE);
         return propList;
      }
      
      private function bubbleSort(dic:Array) : void
      {
         var flag:Boolean = false;
         var j:int = 0;
         var temp:InventoryItemInfo = null;
         var lth:int = int(dic.length);
         for(var i:int = 0; i < lth; i++)
         {
            flag = true;
            for(j = 0; j < lth - 1; j++)
            {
               if(dic[j].Quality < dic[j + 1].Quality)
               {
                  temp = dic[j];
                  dic[j] = dic[j + 1];
                  dic[j + 1] = temp;
                  flag = false;
               }
            }
            if(flag)
            {
               return;
            }
         }
      }
      
      public function get info() : PlayerInfo
      {
         return this._info;
      }
      
      public function set currentPanel(currentPanel:int) : void
      {
         this._currentPanel = currentPanel;
      }
      
      public function get currentPanel() : int
      {
         return this._currentPanel;
      }
      
      public function get canCpsEquipmentList() : DictionaryData
      {
         return this._canCpsEquipmentList;
      }
      
      public function get canExaltEqpmtList() : DictionaryData
      {
         return this._canExaltEqpmtList;
      }
      
      public function get canLianhuaEquipList() : DictionaryData
      {
         return this._canLianhuaEquipList;
      }
      
      public function get canLianhuaPropList() : DictionaryData
      {
         return this._canLianhuaPropList;
      }
      
      public function get canStrthEqpmtList() : DictionaryData
      {
         return this._canStrthEqpmtList;
      }
      
      public function get strthList() : DictionaryData
      {
         return this._strthList;
      }
      
      public function get exaltRock() : DictionaryData
      {
         return this._exaltRock;
      }
      
      public function get cpsAndANchList() : DictionaryData
      {
         return this._cpsAndANchList;
      }
      
      public function get cpsAndStrthAndformula() : DictionaryData
      {
         return this._cpsAndStrthAndformula;
      }
      
      public function get canRongLiangPropList() : DictionaryData
      {
         return this._canRongLiangPropList;
      }
      
      public function get canTransEquipmengtList() : DictionaryData
      {
         return this._canTransEquipmengtList;
      }
      
      public function get canNotTransEquipmengtList() : DictionaryData
      {
         return this._canNotTransEquipmengtList;
      }
      
      public function get canRongLiangEquipmengtList() : DictionaryData
      {
         return this._canRongLiangEquipmengtList;
      }
      
      public function get canEmbedEquipList() : DictionaryData
      {
         return this._canEmbedEquipList;
      }
      
      public function get canEmbedPropList() : DictionaryData
      {
         return this._canEmbedPropList;
      }
      
      public function set NeedAutoLink(value:int) : void
      {
         this._needAutoLink = value;
      }
      
      public function get NeedAutoLink() : int
      {
         return this._needAutoLink;
      }
      
      public function checkEmbeded() : Boolean
      {
         var length:String = null;
         var item:InventoryItemInfo = null;
         for(length in this._canEmbedEquipList)
         {
            item = this._canEmbedEquipList[int(length)] as InventoryItemInfo;
            if(item && item.Hole1 != -1 && item.Hole1 != 0)
            {
               return false;
            }
            if(item && item.Hole2 != -1 && item.Hole2 != 0)
            {
               return false;
            }
            if(item && item.Hole3 != -1 && item.Hole3 != 0)
            {
               return false;
            }
            if(item && item.Hole4 != -1 && item.Hole4 != 0)
            {
               return false;
            }
            if(item && item.Hole5 != -1 && item.Hole5 != 0)
            {
               return false;
            }
            if(item && item.Hole6 != -1 && item.Hole6 != 0)
            {
               return false;
            }
         }
         return true;
      }
      
      public function loadBagData() : void
      {
         this.initData();
      }
      
      public function clear() : void
      {
         this._info.PropBag.removeEventListener(BagEvent.UPDATE,this.updateBag);
         this._info.Bag.removeEventListener(BagEvent.UPDATE,this.updateBag);
         this._info = null;
         this._propBag = null;
         this._equipmentBag = null;
      }
   }
}

