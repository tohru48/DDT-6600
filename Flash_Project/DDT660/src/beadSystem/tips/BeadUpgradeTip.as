package beadSystem.tips
{
   import beadSystem.views.BeadUpgradeTipView;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.manager.BeadTemplateManager;
   import ddt.view.tips.GoodTip;
   import ddt.view.tips.GoodTipInfo;
   
   public class BeadUpgradeTip extends GoodTip
   {
      
      private var _upgradeBeadTip:BeadUpgradeTipView;
      
      public function BeadUpgradeTip()
      {
         super();
      }
      
      override protected function init() : void
      {
         super.init();
      }
      
      override protected function addChildren() : void
      {
         super.addChildren();
      }
      
      override public function set tipData(data:Object) : void
      {
         super.tipData = data;
         this.beadUpgradeTip(data as GoodTipInfo);
      }
      
      override public function showTip(info:ItemTemplateInfo, typeIsSecond:Boolean = false) : void
      {
         super.showTip(info,typeIsSecond);
      }
      
      private function beadUpgradeTip(pTipInfo:GoodTipInfo) : void
      {
         var tInfo:InventoryItemInfo = null;
         var tGoodTipInfo:GoodTipInfo = null;
         var itemInfo:InventoryItemInfo = null;
         if(Boolean(pTipInfo))
         {
            itemInfo = pTipInfo.itemInfo as InventoryItemInfo;
         }
         if(Boolean(itemInfo) && itemInfo.Hole1 < 19)
         {
            tGoodTipInfo = new GoodTipInfo();
            tInfo = new InventoryItemInfo();
            ObjectUtils.copyProperties(tInfo,itemInfo);
            tInfo.Hole1 += 1;
            tInfo.TemplateID = BeadTemplateManager.Instance.GetBeadTemplateIDByLv(tInfo.Hole1,itemInfo.TemplateID);
            tGoodTipInfo.itemInfo = tInfo;
            tGoodTipInfo.beadName = tInfo.Name + "-" + BeadTemplateManager.Instance.GetBeadInfobyID(tInfo.TemplateID).Name + "Lv" + tInfo.Hole1;
            if(!this._upgradeBeadTip)
            {
               this._upgradeBeadTip = new BeadUpgradeTipView();
            }
            this._upgradeBeadTip.x = _tipbackgound.x + _tipbackgound.width + 35;
            if(!this.contains(this._upgradeBeadTip))
            {
               addChild(this._upgradeBeadTip);
            }
            this._upgradeBeadTip.tipData = tGoodTipInfo;
         }
         else
         {
            if(Boolean(this._upgradeBeadTip))
            {
               ObjectUtils.disposeObject(this._upgradeBeadTip);
            }
            this._upgradeBeadTip = null;
         }
      }
      
      override public function dispose() : void
      {
         super.dispose();
         if(Boolean(this._upgradeBeadTip))
         {
            ObjectUtils.disposeObject(this._upgradeBeadTip);
         }
         this._upgradeBeadTip = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

