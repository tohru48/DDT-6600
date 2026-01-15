package store.forge.wishBead
{
   import ddt.data.BagInfo;
   import ddt.data.EquipType;
   import ddt.data.analyze.WishInfoAnalyzer;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import road7th.data.DictionaryData;
   
   public class WishBeadManager extends EventDispatcher
   {
      
      private static var _instance:WishBeadManager;
      
      public static const EQUIP_MOVE:String = "wishBead_equip_move";
      
      public static const EQUIP_MOVE2:String = "wishBead_equip_move2";
      
      public static const ITEM_MOVE:String = "wishBead_item_move";
      
      public static const ITEM_MOVE2:String = "wishBead_item_move2";
      
      public var wishInfoList:Vector.<WishChangeInfo>;
      
      public function WishBeadManager(target:IEventDispatcher = null)
      {
         super(target);
      }
      
      public static function get instance() : WishBeadManager
      {
         if(_instance == null)
         {
            _instance = new WishBeadManager();
         }
         return _instance;
      }
      
      public function getCanWishBeadData() : BagInfo
      {
         var item:InventoryItemInfo = null;
         var infoItem:InventoryItemInfo = null;
         var equipBaglist:DictionaryData = PlayerManager.Instance.Self.Bag.items;
         var wishBeadBagList:BagInfo = new BagInfo(BagInfo.EQUIPBAG,21);
         var arr:Array = new Array();
         for each(item in equipBaglist)
         {
            if(item.StrengthenLevel >= 12 && (item.CategoryID == EquipType.ARM || item.CategoryID == EquipType.CLOTH || item.CategoryID == EquipType.HEAD))
            {
               if(item.Place < 17)
               {
                  wishBeadBagList.addItem(item);
               }
               else
               {
                  arr.push(item);
               }
            }
         }
         for each(infoItem in arr)
         {
            wishBeadBagList.addItem(infoItem);
         }
         return wishBeadBagList;
      }
      
      public function getWishBeadItemData() : BagInfo
      {
         var item:InventoryItemInfo = null;
         var proBaglist:DictionaryData = PlayerManager.Instance.Self.PropBag.items;
         var wishBeadBagList:BagInfo = new BagInfo(BagInfo.PROPBAG,21);
         for each(item in proBaglist)
         {
            if(item.TemplateID == EquipType.WISHBEAD_ATTACK || item.TemplateID == EquipType.WISHBEAD_DEFENSE || item.TemplateID == EquipType.WISHBEAD_AGILE)
            {
               wishBeadBagList.addItem(item);
            }
         }
         return wishBeadBagList;
      }
      
      public function getIsEquipMatchWishBead(wishBeadId:int, equipId:int, isShowTip:Boolean) : Boolean
      {
         switch(wishBeadId)
         {
            case EquipType.WISHBEAD_ATTACK:
               if(equipId == EquipType.ARM)
               {
                  return true;
               }
               if(isShowTip)
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("wishBeadMainView.noMatchTipTxt"));
               }
               return false;
               break;
            case EquipType.WISHBEAD_DEFENSE:
               if(equipId == EquipType.CLOTH)
               {
                  return true;
               }
               if(isShowTip)
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("wishBeadMainView.noMatchTipTxt2"));
               }
               return false;
               break;
            case EquipType.WISHBEAD_AGILE:
               if(equipId == EquipType.HEAD)
               {
                  return true;
               }
               if(isShowTip)
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("wishBeadMainView.noMatchTipTxt3"));
               }
               return false;
               break;
            default:
               return false;
         }
      }
      
      public function getwishInfo(analyzer:WishInfoAnalyzer) : void
      {
         this.wishInfoList = analyzer._wishChangeInfo;
      }
      
      public function getWishInfoByTemplateID(id:int, categoryID:int) : WishChangeInfo
      {
         var info:WishChangeInfo = null;
         var temp:WishChangeInfo = null;
         for each(info in this.wishInfoList)
         {
            if(info.OldTemplateId == id)
            {
               return info;
            }
            if(info.OldTemplateId == -1 && info.CategoryID == categoryID)
            {
               temp = info;
            }
         }
         return temp;
      }
   }
}

