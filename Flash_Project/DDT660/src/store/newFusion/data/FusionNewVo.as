package store.newFusion.data
{
   import com.pickgliss.ui.controls.cell.INotSameHeightListCellData;
   import ddt.data.BagInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.manager.ItemManager;
   import ddt.manager.PlayerManager;
   
   public class FusionNewVo implements INotSameHeightListCellData
   {
      
      public static const WEAPON_TYPE:int = 1;
      
      public static const JEWELLRY_TYPE:int = 2;
      
      public static const AVATAR_TYPE:int = 3;
      
      public static const DRILL_TYPE:int = 4;
      
      public static const COMBINE_TYPE:int = 5;
      
      public static const OTHER_TYPE:int = 6;
      
      private var _equipBag:BagInfo = PlayerManager.Instance.Self.getBag(BagInfo.EQUIPBAG);
      
      private var _propBag:BagInfo = PlayerManager.Instance.Self.getBag(BagInfo.PROPBAG);
      
      public var FusionID:int;
      
      public var Reward:int;
      
      public var Item1:int;
      
      public var Count1:int;
      
      public var Item2:int;
      
      public var Count2:int;
      
      public var Item3:int;
      
      public var Count3:int;
      
      public var Item4:int;
      
      public var Count4:int;
      
      public var Formula:int;
      
      private var _FusionRate:int;
      
      public var FusionType:int;
      
      public function FusionNewVo()
      {
         super();
      }
      
      public function get fusionItemInfo() : ItemTemplateInfo
      {
         return ItemManager.Instance.getTemplateById(this.Reward);
      }
      
      public function get isNeedItem1() : Boolean
      {
         return this.Item1 != -1 && this.Count1 > 0;
      }
      
      public function get item1Count() : int
      {
         var equipCount:int = this._equipBag.getBagItemCountByTemplateId(this.Item1);
         var propCount:int = this._propBag.getItemCountByTemplateId(this.Item1);
         return equipCount + propCount;
      }
      
      public function get isNeedItem2() : Boolean
      {
         return this.Item2 != -1 && this.Count2 > 0;
      }
      
      public function get item2Count() : int
      {
         var equipCount:int = this._equipBag.getBagItemCountByTemplateId(this.Item2);
         var propCount:int = this._propBag.getItemCountByTemplateId(this.Item2);
         return equipCount + propCount;
      }
      
      public function get isNeedItem3() : Boolean
      {
         return this.Item3 != -1 && this.Count3 > 0;
      }
      
      public function get item3Count() : int
      {
         var equipCount:int = this._equipBag.getBagItemCountByTemplateId(this.Item3);
         var propCount:int = this._propBag.getItemCountByTemplateId(this.Item3);
         return equipCount + propCount;
      }
      
      public function get isNeedItem4() : Boolean
      {
         return this.Item4 != -1 && this.Count4 > 0;
      }
      
      public function get item4Count() : int
      {
         var equipCount:int = this._equipBag.getBagItemCountByTemplateId(this.Item4);
         var propCount:int = this._propBag.getItemCountByTemplateId(this.Item4);
         return equipCount + propCount;
      }
      
      public function get canFusionCount() : int
      {
         var item1CanCount:int = int.MAX_VALUE;
         if(this.isNeedItem1)
         {
            item1CanCount = this.item1Count / this.Count1;
         }
         var item2CanCount:int = int.MAX_VALUE;
         if(this.isNeedItem2)
         {
            item2CanCount = this.item2Count / this.Count2;
         }
         var item3CanCount:int = int.MAX_VALUE;
         if(this.isNeedItem3)
         {
            item3CanCount = this.item3Count / this.Count3;
         }
         var item4CanCount:int = int.MAX_VALUE;
         if(this.isNeedItem4)
         {
            item4CanCount = this.item4Count / this.Count4;
         }
         var tmp:int = Math.min(item1CanCount,item2CanCount,item3CanCount,item4CanCount);
         return tmp == int.MAX_VALUE ? 0 : tmp;
      }
      
      public function get FusionRate() : int
      {
         return this._FusionRate;
      }
      
      public function set FusionRate(value:int) : void
      {
         this._FusionRate = value / 1000 > 1 ? int(value / 1000) : 1;
      }
      
      public function getItemInfoByIndex(index:int) : ItemTemplateInfo
      {
         if(!this["isNeedItem" + index])
         {
            return null;
         }
         return ItemManager.Instance.getTemplateById(this["Item" + index]);
      }
      
      public function getItemNeedCount(index:int) : int
      {
         return this["Count" + index];
      }
      
      public function getItemHadCount(index:int) : int
      {
         return this["item" + index + "Count"];
      }
      
      public function getCellHeight() : Number
      {
         return 26;
      }
      
      public function isNeedPopBindTipWindow(num:int) : Boolean
      {
         var unbindCanCount:int = this.getCanFusionCountByBindType(1);
         var bindCanCount:int = this.getCanFusionCountByBindType(2);
         if(num > unbindCanCount + bindCanCount)
         {
            return true;
         }
         return false;
      }
      
      public function getCanFusionCountByBindType(bindType:int) : int
      {
         var item1CanCount:int = int.MAX_VALUE;
         if(this.isNeedItem1)
         {
            item1CanCount = this.getItemCountByIndexBindType(1,bindType) / this.Count1;
         }
         var item2CanCount:int = int.MAX_VALUE;
         if(this.isNeedItem2)
         {
            item2CanCount = this.getItemCountByIndexBindType(2,bindType) / this.Count2;
         }
         var item3CanCount:int = int.MAX_VALUE;
         if(this.isNeedItem3)
         {
            item3CanCount = this.getItemCountByIndexBindType(3,bindType) / this.Count3;
         }
         var item4CanCount:int = int.MAX_VALUE;
         if(this.isNeedItem4)
         {
            item4CanCount = this.getItemCountByIndexBindType(4,bindType) / this.Count4;
         }
         var tmp:int = Math.min(item1CanCount,item2CanCount,item3CanCount,item4CanCount);
         return tmp == int.MAX_VALUE ? 0 : tmp;
      }
      
      private function getItemCountByIndexBindType(index:int, bindType:int) : int
      {
         var equipCount:int = this._equipBag.getBagItemCountByTemplateIdBindType(this["Item" + index],bindType);
         var propCount:int = this._propBag.getItemCountByTemplateIdBindType(this["Item" + index],bindType);
         return equipCount + propCount;
      }
   }
}

