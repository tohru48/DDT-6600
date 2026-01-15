package texpSystem.view
{
   import com.pickgliss.ui.controls.BaseButton;
   import ddt.manager.ItemManager;
   import ddt.view.tips.GoodTipInfo;
   
   public class TexpBuyButton extends BaseButton
   {
      
      private var _itemID:int;
      
      public function TexpBuyButton()
      {
         super();
      }
      
      public function setup(itemID:int) : void
      {
         this._itemID = itemID;
         this.initTip();
      }
      
      private function initTip() : void
      {
         var goodInfo:GoodTipInfo = new GoodTipInfo();
         goodInfo.itemInfo = ItemManager.Instance.getTemplateById(this._itemID);
         goodInfo.isBalanceTip = false;
         goodInfo.typeIsSecond = false;
         tipData = goodInfo;
      }
      
      override public function dispose() : void
      {
         super.dispose();
      }
   }
}

