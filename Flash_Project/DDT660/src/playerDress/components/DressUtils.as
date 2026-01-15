package playerDress.components
{
   import ddt.data.EquipType;
   import ddt.data.goods.InventoryItemInfo;
   
   public class DressUtils
   {
      
      public function DressUtils()
      {
         super();
      }
      
      public static function getBagItems($id:int, $isIndex:Boolean = false) : int
      {
         var numArr:Array = [0,2,4,11,1,3,5,13];
         if(!$isIndex)
         {
            return numArr[$id] != null ? int(numArr[$id]) : -1;
         }
         return numArr.indexOf($id);
      }
      
      public static function isDress(item:InventoryItemInfo) : Boolean
      {
         switch(item.CategoryID)
         {
            case EquipType.HEAD:
            case EquipType.GLASS:
            case EquipType.HAIR:
            case EquipType.EFF:
            case EquipType.CLOTH:
            case EquipType.FACE:
            case EquipType.SUITS:
            case EquipType.WING:
               return true;
            default:
               return false;
         }
      }
      
      public static function findItemPlace(item:InventoryItemInfo) : int
      {
         switch(item.CategoryID)
         {
            case EquipType.HEAD:
               return 0;
            case EquipType.GLASS:
               return 1;
            case EquipType.HAIR:
               return 2;
            case EquipType.EFF:
               return 3;
            case EquipType.CLOTH:
               return 4;
            case EquipType.FACE:
               return 5;
            case EquipType.SUITS:
               return 11;
            case EquipType.WING:
               return 13;
            default:
               return item.Place;
         }
      }
      
      public static function hasNoAddition(item:InventoryItemInfo) : Boolean
      {
         if(item.isGold == false && item.StrengthenLevel <= 0 && item.AttackCompose <= 0 && item.DefendCompose <= 0 && item.AgilityCompose <= 0 && item.LuckCompose <= 0 && item.Hole5Level <= 0 && item.Hole6Level <= 0 && item.Hole1 <= 0 && item.Hole2 <= 0 && item.Hole3 <= 0 && item.Hole4 <= 0 && item.Hole5 <= 0 && item.Hole6 <= 0 && item.Hole5Exp <= 0 && item.Hole6Exp <= 0 && item.StrengthenExp <= 0 && item.latentEnergyCurStr == "0,0,0,0")
         {
            return true;
         }
         return false;
      }
      
      public static function getBagGoodsCategoryIDSort(CategoryID:uint) : int
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
   }
}

