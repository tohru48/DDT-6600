package store.data
{
   import ddt.data.goods.InventoryItemInfo;
   import ddt.manager.ItemManager;
   import flash.utils.getTimer;
   
   public class PreviewInfoII
   {
      
      private var _info:InventoryItemInfo;
      
      private var _rate:int;
      
      public function PreviewInfoII()
      {
         super();
         this._info = new InventoryItemInfo();
      }
      
      public function data(id:int, beginDate:Number = 7) : void
      {
         this._info.TemplateID = id;
         ItemManager.fill(this._info);
         this._info.BeginDate = String(getTimer());
         this._info.ValidDate = beginDate;
         this._info.IsJudge = true;
      }
      
      public function setComposeProperty(agilityCompose:int, attackCompose:int, defendCompose:int, luckCompose:int) : void
      {
         this._info.AgilityCompose = agilityCompose;
         this._info.AttackCompose = attackCompose;
         this._info.DefendCompose = defendCompose;
         this._info.LuckCompose = luckCompose;
      }
      
      public function get info() : InventoryItemInfo
      {
         return this._info;
      }
      
      public function set rate($rate:int) : void
      {
         this._rate = $rate;
      }
      
      public function get rate() : int
      {
         return this._rate;
      }
   }
}

