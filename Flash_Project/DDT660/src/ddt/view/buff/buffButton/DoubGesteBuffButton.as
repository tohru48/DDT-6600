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
   
   public class DoubGesteBuffButton extends BuffButton
   {
      
      public function DoubGesteBuffButton()
      {
         super("asset.core.doubleGesteAsset");
         info = new BuffInfo(BuffInfo.DOUBLE_GESTE);
      }
      
      override protected function __onclick(evt:MouseEvent) : void
      {
         var alert:BaseAlerFrame = null;
         if(Setting)
         {
            return;
         }
         super.__onclick(evt);
         ShowTipManager.Instance.removeCurrentTip();
         if(!checkBagLocked())
         {
            return;
         }
         if(!(_info && _info.IsExist))
         {
            alert = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.MyConsortiaTax.info"),LanguageMgr.GetTranslation("tank.view.buff.doubleExp",ShopManager.Instance.getMoneyShopItemByTemplateID(_info.buffItemInfo.TemplateID).getItemPrice(1).moneyValue),"",LanguageMgr.GetTranslation("cancel"),false,false,false,LayerManager.ALPHA_BLOCKGOUND,null,"SimpleAlert",30,true);
         }
         else
         {
            alert = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.MyConsortiaTax.info"),LanguageMgr.GetTranslation("tank.view.buff.addPrice",ShopManager.Instance.getMoneyShopItemByTemplateID(_info.buffItemInfo.TemplateID).getItemPrice(1).moneyValue),"",LanguageMgr.GetTranslation("cancel"),false,false,false,LayerManager.ALPHA_BLOCKGOUND,null,"SimpleAlert",30,true);
         }
         Setting = true;
         alert.addEventListener(FrameEvent.RESPONSE,__onBuyResponse);
      }
   }
}

