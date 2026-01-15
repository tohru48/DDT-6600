package groupPurchase.view
{
   import bagAndInfo.cell.BagCell;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.manager.ItemManager;
   import ddt.utils.PositionUtils;
   import flash.display.Sprite;
   import groupPurchase.GroupPurchaseManager;
   import groupPurchase.data.GroupPurchaseAwardInfo;
   
   public class GroupPurchaseAwardView extends Sprite implements Disposeable
   {
      
      private var _awardList:Object;
      
      public function GroupPurchaseAwardView()
      {
         super();
         this._awardList = GroupPurchaseManager.instance.awardInfoList;
         for(var i:int = 1; i <= 12; i++)
         {
            this.createAwardCell(i);
         }
      }
      
      private function createAwardCell(index:int) : void
      {
         var awardCell:BagCell = null;
         var itemInfo:InventoryItemInfo = null;
         var awardInfo:GroupPurchaseAwardInfo = this._awardList[index];
         if(Boolean(awardInfo))
         {
            awardCell = new BagCell(1,null,true,null,false);
            awardCell.tipGapH = 0;
            awardCell.tipGapV = 0;
            itemInfo = new InventoryItemInfo();
            itemInfo.TemplateID = awardInfo.TemplateID;
            ItemManager.fill(itemInfo);
            itemInfo.StrengthenLevel = awardInfo.StrengthenLevel;
            itemInfo.AttackCompose = awardInfo.AttackCompose;
            itemInfo.DefendCompose = awardInfo.DefendCompose;
            itemInfo.LuckCompose = awardInfo.LuckCompose;
            itemInfo.AgilityCompose = awardInfo.AgilityCompose;
            itemInfo.IsBinds = awardInfo.IsBind;
            itemInfo.ValidDate = awardInfo.ValidDate;
            itemInfo.Count = awardInfo.Count;
            awardCell.info = itemInfo;
            if(itemInfo.Count > 1)
            {
               awardCell.setCount(itemInfo.Count);
            }
            PositionUtils.setPos(awardCell,"groupPurchase.awardCellPos" + index);
            addChild(awardCell);
         }
      }
      
      public function dispose() : void
      {
         ObjectUtils.disposeAllChildren(this);
         this._awardList = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

