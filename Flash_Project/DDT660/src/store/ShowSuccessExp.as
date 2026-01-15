package store
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.command.StripTip;
   import ddt.manager.LanguageMgr;
   import ddt.utils.PositionUtils;
   import flash.display.Sprite;
   
   public class ShowSuccessExp extends Sprite
   {
      
      private var _bg:ScaleFrameImage;
      
      private var _showTxtI:FilterFrameText;
      
      private var _showTxtIII:FilterFrameText;
      
      private var _showTxtIV:FilterFrameText;
      
      private var _showTxtVIP:FilterFrameText;
      
      private var _showTxtILabel:FilterFrameText;
      
      private var _showTxtIIILabel:FilterFrameText;
      
      private var _showTxtIVLabel:FilterFrameText;
      
      private var _showTxtVipLabel:FilterFrameText;
      
      private var _showStripI:StripTip;
      
      private var _showStripIII:StripTip;
      
      private var _showStripIV:StripTip;
      
      private var _showStripVIP:StripTip;
      
      public function ShowSuccessExp()
      {
         super();
         this._init();
      }
      
      private function _init() : void
      {
         this._bg = ComponentFactory.Instance.creatComponentByStylename("ddtstore.StoreIIStrengthBg.ShowSuccessExpBg");
         this._bg.setFrame(1);
         this._showTxtI = ComponentFactory.Instance.creatComponentByStylename("ddtstore.StoreIIStrengthBg.SuccessExpTextBasic");
         this._showTxtI.text = "0";
         this._showTxtIII = ComponentFactory.Instance.creatComponentByStylename("ddtstore.StoreIIStrengthBg.SuccessExpTextGuild");
         this._showTxtIII.text = "0";
         this._showTxtIV = ComponentFactory.Instance.creatComponentByStylename("ddtstore.StoreIIStrengthBg.SuccessExpTextTotal");
         this._showTxtIV.text = "0";
         this._showTxtILabel = ComponentFactory.Instance.creatComponentByStylename("ddtstore.StoreIIStrengthBg.SuccessExpTextBasicLabel");
         this._showTxtILabel.text = LanguageMgr.GetTranslation("store.Strength.SuccessExp.BasicText");
         this._showTxtIIILabel = ComponentFactory.Instance.creatComponentByStylename("ddtstore.StoreIIStrengthBg.SuccessExpTextGuildLabel");
         this._showTxtIIILabel.text = LanguageMgr.GetTranslation("store.Strength.SuccessExp.GuildText");
         this._showTxtIVLabel = ComponentFactory.Instance.creatComponentByStylename("ddtstore.StoreIIStrengthBg.SuccessExpTextTotalLabel");
         this._showTxtIVLabel.text = LanguageMgr.GetTranslation("store.Strength.SuccessExp.TotalText");
         this._showStripI = ComponentFactory.Instance.creatCustomObject("ddtstore.view.basallevelStrip");
         this._showStripIII = ComponentFactory.Instance.creatCustomObject("ddtstore.view.consortiaStrip");
         this._showStripIV = ComponentFactory.Instance.creatCustomObject("ddtstore.view.percentageStrip");
         addChild(this._bg);
         addChild(this._showTxtI);
         addChild(this._showTxtIII);
         addChild(this._showTxtIV);
         addChild(this._showTxtILabel);
         addChild(this._showTxtIIILabel);
         addChild(this._showTxtIVLabel);
         addChild(this._showStripI);
         addChild(this._showStripIII);
         addChild(this._showStripIV);
      }
      
      public function showVIPRate() : void
      {
         this._bg.setFrame(2);
         this._showTxtVIP = ComponentFactory.Instance.creatComponentByStylename("ddtstore.StoreIIStrengthBg.SuccessExpTextVip");
         this._showTxtVIP.text = "0";
         this._showTxtVipLabel = ComponentFactory.Instance.creatComponentByStylename("ddtstore.StoreIIStrengthBg.SuccessExpTextVipLabel");
         this._showTxtVipLabel.text = LanguageMgr.GetTranslation("store.Strength.SuccessExp.VipText");
         this._showStripVIP = ComponentFactory.Instance.creatCustomObject("ddtstore.view.VIPStrip");
         PositionUtils.setPos(this._showStripI,"ddtstore.view.showStripIExpPos");
         this._showStripI.width -= 10;
         PositionUtils.setPos(this._showStripIII,"ddtstore.view.showStripIIIExpPos");
         this._showStripIII.width -= 10;
         PositionUtils.setPos(this._showStripIV,"ddtstore.view.showStripIVExpPos");
         this._showStripIV.width -= 10;
         PositionUtils.setPos(this._showStripVIP,"ddtstore.view.showStripVIPExpPos");
         this._showStripVIP.width -= 10;
         addChild(this._showTxtVIP);
         addChild(this._showTxtVipLabel);
         addChild(this._showStripVIP);
      }
      
      public function showAllTips(strI:String, strIII:String, strIV:String) : void
      {
         this._showStripI.tipData = strI;
         this._showStripIII.tipData = strIII;
         this._showStripIV.tipData = strIV;
      }
      
      public function showVIPTip(tipData:String) : void
      {
         this._showStripVIP.tipData = tipData;
      }
      
      public function showAllNum(numI:Number, numIII:Number, numVIP:Number, numIV:Number) : void
      {
         numI = this.formatNumber(numI);
         numIII = this.formatNumber(numIII);
         numVIP = this.formatNumber(numVIP);
         numIV = this.formatNumber(numIV);
         this._showTxtI.text = String(numI);
         this._showTxtIII.text = String(numIII);
         this._showTxtVIP.text = String(numVIP);
         this._showTxtIV.text = String(numIV);
      }
      
      private function formatNumber(num:Number) : Number
      {
         return Math.round(num * 10) / 10;
      }
      
      public function dispose() : void
      {
         if(Boolean(this._bg))
         {
            ObjectUtils.disposeObject(this._bg);
         }
         if(Boolean(this._showTxtI))
         {
            ObjectUtils.disposeObject(this._showTxtI);
         }
         if(Boolean(this._showTxtIII))
         {
            ObjectUtils.disposeObject(this._showTxtIII);
         }
         if(Boolean(this._showTxtIV))
         {
            ObjectUtils.disposeObject(this._showTxtIV);
         }
         if(Boolean(this._showTxtVIP))
         {
            ObjectUtils.disposeObject(this._showTxtVIP);
         }
         if(Boolean(this._showStripI))
         {
            ObjectUtils.disposeObject(this._showStripI);
         }
         if(Boolean(this._showStripIII))
         {
            ObjectUtils.disposeObject(this._showStripIII);
         }
         if(Boolean(this._showStripIV))
         {
            ObjectUtils.disposeObject(this._showStripIV);
         }
         if(Boolean(this._showStripVIP))
         {
            ObjectUtils.disposeObject(this._showStripVIP);
         }
         if(Boolean(this._showTxtILabel))
         {
            ObjectUtils.disposeObject(this._showTxtILabel);
         }
         if(Boolean(this._showTxtIIILabel))
         {
            ObjectUtils.disposeObject(this._showTxtIIILabel);
         }
         if(Boolean(this._showTxtIVLabel))
         {
            ObjectUtils.disposeObject(this._showTxtIVLabel);
         }
         if(Boolean(this._showTxtVipLabel))
         {
            ObjectUtils.disposeObject(this._showTxtVipLabel);
         }
         this._bg = null;
         this._showTxtI = null;
         this._showTxtIII = null;
         this._showTxtIV = null;
         this._showTxtVIP = null;
         this._showStripI = null;
         this._showStripIII = null;
         this._showStripIV = null;
         this._showStripVIP = null;
         this._showTxtILabel = null;
         this._showTxtIIILabel = null;
         this._showTxtIVLabel = null;
         this._showTxtVipLabel = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

