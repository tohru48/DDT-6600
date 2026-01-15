package latentEnergy
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   
   public class LatentEnergyTipItem extends Sprite implements Disposeable
   {
      
      private var _icon:Bitmap;
      
      private var _txt:FilterFrameText;
      
      public function LatentEnergyTipItem()
      {
         super();
         this._icon = ComponentFactory.Instance.creatBitmap("asset.latentEnergy.tipIcon");
         addChild(this._icon);
         this._txt = ComponentFactory.Instance.creatComponentByStylename("latentEnergy.tipItemTxt");
         addChild(this._txt);
      }
      
      public function setView(type:int, value:int) : void
      {
         var pro:String = LanguageMgr.GetTranslation("ddt.latentEnergy.proListTxt").split(",")[type];
         this._txt.text = LanguageMgr.GetTranslation("ddt.latentEnergy.tipItemTxt",pro,value.toString());
      }
      
      public function dispose() : void
      {
         ObjectUtils.disposeObject(this._icon);
         this._icon = null;
         ObjectUtils.disposeObject(this._txt);
         this._txt = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

