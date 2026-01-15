package gypsyShop.model
{
   import ddt.manager.PlayerManager;
   
   public class GypsyPurchaseModel
   {
      
      private static var instance:GypsyPurchaseModel;
      
      private var _useBindRmbTicket:Boolean = false;
      
      private var _showAlertHonourRefresh:Boolean = true;
      
      private var _showAlertRmbTicketBuy:Boolean = true;
      
      public function GypsyPurchaseModel(single:inner)
      {
         super();
      }
      
      public static function getInstance() : GypsyPurchaseModel
      {
         if(!instance)
         {
            instance = new GypsyPurchaseModel(new inner());
         }
         return instance;
      }
      
      public function updateIsUseBindRmbTicket(isBind:Boolean) : void
      {
         this._useBindRmbTicket = isBind;
      }
      
      public function updateShowAlertHonourRefresh(show:Boolean) : void
      {
         this._showAlertHonourRefresh = show;
      }
      
      public function updateShowAlertRmbTicketBuy(show:Boolean) : void
      {
         this._showAlertRmbTicketBuy = show;
      }
      
      public function isShowRmbTicketBuyAgain() : Boolean
      {
         return this._showAlertRmbTicketBuy;
      }
      
      public function isShowHonourRefreshAgain() : Boolean
      {
         return this._showAlertHonourRefresh;
      }
      
      public function getUseBind() : Boolean
      {
         return this._useBindRmbTicket;
      }
      
      public function getRmbTicketNeeded(id:int) : int
      {
         var len:int = 0;
         var list:Vector.<GypsyItemData> = GypsyShopModel.getInstance().itemDataList;
         if(list == null)
         {
            return 0;
         }
         len = int(list.length);
         for(var i:int = 0; i < len; i++)
         {
            if(list[i].id == id)
            {
               if(list[i].unit == 1)
               {
                  return list[i].price;
               }
            }
         }
         return 0;
      }
      
      public function getHonourNeeded() : int
      {
         return GypsyShopModel.getInstance().getNeedMoneyTotal();
      }
      
      public function isBindMoneyEnough(id:int) : Boolean
      {
         if(PlayerManager.Instance.Self.BandMoney < this.getRmbTicketNeeded(id))
         {
            return false;
         }
         return true;
      }
      
      public function isMoneyEnough(id:int) : Boolean
      {
         if(PlayerManager.Instance.Self.Money < this.getRmbTicketNeeded(id))
         {
            return false;
         }
         return true;
      }
      
      public function isHonourEnough() : Boolean
      {
         return PlayerManager.Instance.Self.myHonor >= GypsyPurchaseModel.getInstance().getHonourNeeded();
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
