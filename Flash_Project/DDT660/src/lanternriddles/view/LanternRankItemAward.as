package lanternriddles.view
{
   import bagAndInfo.cell.BagCell;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.manager.ItemManager;
   import flash.display.Sprite;
   import lanternriddles.data.LanternAwardInfo;
   
   public class LanternRankItemAward extends Sprite
   {
      
      private static var AWARD_NUM:int = 3;
      
      private var _awardVec:Vector.<BagCell>;
      
      public function LanternRankItemAward()
      {
         super();
         this.initView();
      }
      
      private function initView() : void
      {
         var award:BagCell = null;
         this._awardVec = new Vector.<BagCell>();
         for(var i:int = 0; i < AWARD_NUM; i++)
         {
            award = new BagCell(i,null,true,null,false);
            award.BGVisible = false;
            award.setContentSize(28,28);
            award.x = i * 35;
            award.y = 3;
            addChild(award);
            this._awardVec.push(award);
         }
      }
      
      public function set info(infoVec:Vector.<LanternAwardInfo>) : void
      {
         var i:int = 0;
         var item:InventoryItemInfo = null;
         for(i = 0; i < infoVec.length; i++)
         {
            item = new InventoryItemInfo();
            item.TemplateID = infoVec[i].TempId;
            item.IsBinds = infoVec[i].IsBind;
            item.ValidDate = infoVec[i].ValidDate;
            this._awardVec[i].info = ItemManager.fill(item);
            this._awardVec[i].setCount(infoVec[i].AwardNum);
         }
      }
      
      public function dispose() : void
      {
         var i:int = 0;
         if(Boolean(this._awardVec))
         {
            for(i = 0; i < AWARD_NUM; i++)
            {
               this._awardVec[i].dispose();
               this._awardVec[i] = null;
            }
            this._awardVec.length = 0;
            this._awardVec = null;
         }
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
   }
}

