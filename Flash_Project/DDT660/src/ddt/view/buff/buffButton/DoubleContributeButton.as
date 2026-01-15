package ddt.view.buff.buffButton
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.ShowTipManager;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import ddt.data.BuffInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.ShopManager;
   import flash.events.MouseEvent;
   
   public class DoubleContributeButton extends BuffButton
   {
      
      public function DoubleContributeButton()
      {
         super("asset.core.doubleContribute");
         info = new BuffInfo(BuffInfo.DOUBLE_CONTRIBUTE);
      }
      
      override protected function __onclick(evt:MouseEvent) : void
      {
         var alert:BaseAlerFrame = null;
         if(Setting)
         {
            return;
         }
         ShowTipManager.Instance.removeCurrentTip();
         super.__onclick(evt);
         if(!checkBagLocked())
         {
            return;
         }
         if(!(_info && _info.IsExist))
         {
            alert = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.MyConsortiaTax.info"),LanguageMgr.GetTranslation("tank.view.buff.doubleExp",ShopManager.Instance.getMoneyShopItemByTemplateID(_info.buffItemInfo.TemplateID).getItemPrice(1).moneyValue),"",LanguageMgr.GetTranslation("cancel"),false,false,false,LayerManager.ALPHA_BLOCKGOUND,null,"SimpleAlert",30,true,AlertManager.SELECTBTN);
         }
         else
         {
            alert = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.MyConsortiaTax.info"),LanguageMgr.GetTranslation("tank.view.buff.addPrice",ShopManager.Instance.getMoneyShopItemByTemplateID(_info.buffItemInfo.TemplateID).getItemPrice(1).moneyValue),"",LanguageMgr.GetTranslation("cancel"),false,false,false,LayerManager.ALPHA_BLOCKGOUND,null,"SimpleAlert",30,true,AlertManager.SELECTBTN);
         }
         Setting = true;
         alert.addEventListener(FrameEvent.RESPONSE,__onBuyResponse);
      }
      
      override public function dispose() : void
      {
         Setting = false;
         super.dispose();
      }
   }
}

