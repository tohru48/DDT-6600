package enchant.data
{
   import ddt.data.BagInfo;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.player.SelfInfo;
   import ddt.events.BagEvent;
   import ddt.manager.PlayerManager;
   import flash.events.EventDispatcher;
   import flash.utils.Dictionary;
   import road7th.data.DictionaryData;
   import store.events.StoreBagEvent;
   import store.events.UpdateItemEvent;
   
   public class EnchantModel extends EventDispatcher
   {
      
      private var _canEnchantEquipList:DictionaryData;
      
      private var _canEnchantPropList:DictionaryData;
      
      private var _info:SelfInfo;
      
      private var _equipmentBag:DictionaryData;
      
      private var _propBag:DictionaryData;
      
      public function EnchantModel()
      {
         super();
         this._info = PlayerManager.Instance.Self;
         this._equipmentBag = this._info.Bag.items;
         this._propBag = this._info.PropBag.items;
         this.initData();
         this.initEvent();
      }
      
      public function get canEnchantEquipList() : DictionaryData
      {
         return this._canEnchantEquipList;
      }
      
      public function get canEnchantPropList() : DictionaryData
      {
         return this._canEnchantPropList;
      }
      
      private function initData() : void
      {
         this._canEnchantEquipList = new DictionaryData();
         this._canEnchantPropList = new DictionaryData();
         this.initEquipProData(this._equipmentBag,true);
         this.initEquipProData(this._propBag,false);
      }
      
      private function initEquipProData(bag:DictionaryData, isEquip:Boolean) : void
      {
         var item:InventoryItemInfo = null;
         var infoItem:InventoryItemInfo = null;
         var arr:Array = new Array();
         for each(item in bag)
         {
            if(isEquip)
            {
               if(item.isCanEnchant() && item.getRemainDate() > 0)
               {
                  if(item.Place < 17)
                  {
                     this._canEnchantEquipList.add(this._canEnchantEquipList.length,item);
                  }
                  else
                  {
                     arr.push(item);
                  }
               }
            }
            else if(item.getRemainDate() > 0 && item.CategoryID == 11 && int(item.Property1) == 104)
            {
               this._canEnchantPropList.add(this._canEnchantPropList.length,item);
            }
         }
         if(isEquip)
         {
            for each(infoItem in arr)
            {
               this._canEnchantEquipList.add(this._canEnchantEquipList.length,infoItem);
            }
         }
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
               this.removeFrom(i,this._canEnchantEquipList);
            }
            else
            {
               this.removeFrom(i,this._canEnchantPropList);
            }
         }
      }
      
      private function __updateEquip(item:InventoryItemInfo) : void
      {
         if(item.isCanEnchant() && item.getRemainDate() > 0)
         {
            this.updateDic(this._canEnchantEquipList,item);
         }
         else
         {
            this.removeFrom(item,this._canEnchantEquipList);
         }
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
      
      private function __updateProp(item:InventoryItemInfo) : void
      {
         if(item.getRemainDate() > 0 && item.CategoryID == 11 && int(item.Property1) == 104)
         {
            this.updateDic(this._canEnchantPropList,item);
         }
         else
         {
            this.removeFrom(item,this._canEnchantPropList);
         }
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
   }
}

