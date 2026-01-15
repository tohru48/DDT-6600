package giftSystem.view
{
   import bagAndInfo.BagAndInfoManager;
   import com.pickgliss.effect.AlphaShinerAnimation;
   import com.pickgliss.effect.EffectColorType;
   import com.pickgliss.effect.EffectManager;
   import com.pickgliss.effect.EffectTypes;
   import com.pickgliss.effect.IEffect;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.MutipleImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.player.PlayerInfo;
   import ddt.events.PlayerPropertyEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import ddt.view.PlayerPortraitView;
   import email.manager.MailManager;
   import email.view.EmailEvent;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import giftSystem.GiftController;
   
   public class GiftBannerView extends Sprite implements Disposeable
   {
      
      private var BG:MutipleImage;
      
      private var _portrait:PlayerPortraitView;
      
      private var _name:FilterFrameText;
      
      private var _level:FilterFrameText;
      
      private var _levelBg:Bitmap;
      
      private var _charmNum:FilterFrameText;
      
      private var _levelProgress:GiftPropress;
      
      private var _totalGiftShow:FilterFrameText;
      
      private var _totalGiftShowNum:FilterFrameText;
      
      private var _goEmail:BaseButton;
      
      private var _emailShine:IEffect;
      
      private var _totalGiftBackground:MutipleImage;
      
      private var _totalGiftBackground1:Bitmap;
      
      private var _info:PlayerInfo;
      
      public function GiftBannerView()
      {
         super();
         this.init();
      }
      
      private function init() : void
      {
         this.BG = ComponentFactory.Instance.creatComponentByStylename("GiftBannerView.BG");
         this._portrait = ComponentFactory.Instance.creatCustomObject("gift.GiftBannerPortrait",["right"]);
         this._name = ComponentFactory.Instance.creatComponentByStylename("GiftBannerView.name");
         this._level = ComponentFactory.Instance.creatComponentByStylename("GiftBannerView.level");
         this._levelBg = ComponentFactory.Instance.creatBitmap("asset.ddtgift.level");
         this._charmNum = ComponentFactory.Instance.creatComponentByStylename("GiftBannerView.charmNum");
         this._levelProgress = ComponentFactory.Instance.creatComponentByStylename("GiftBannerView.levelProgress");
         this._totalGiftBackground = ComponentFactory.Instance.creatComponentByStylename("asset.giftBannerView.presentBG");
         this._totalGiftBackground1 = ComponentFactory.Instance.creatBitmap("asset.ddtgiftGoodItem.BG1");
         this._totalGiftShow = ComponentFactory.Instance.creatComponentByStylename("GiftBannerView.totalGiftShow");
         this._totalGiftShowNum = ComponentFactory.Instance.creatComponentByStylename("GiftBannerView.totalGiftShowNum");
         this._goEmail = ComponentFactory.Instance.creatComponentByStylename("GiftBannerView.goEmail");
         var data:Object = new Object();
         data[AlphaShinerAnimation.BLUR_WIDTH] = 6;
         data[AlphaShinerAnimation.COLOR] = EffectColorType.YELLOW;
         this._emailShine = EffectManager.Instance.creatEffect(EffectTypes.ALPHA_SHINER_ANIMATION,this._goEmail,data);
         addChild(this.BG);
         addChild(this._portrait);
         addChild(this._name);
         addChild(this._level);
         addChild(this._levelBg);
         addChild(this._charmNum);
         addChild(this._levelProgress);
         addChild(this._totalGiftBackground);
         addChild(this._totalGiftBackground1);
         addChild(this._totalGiftShow);
         addChild(this._totalGiftShowNum);
         addChild(this._goEmail);
      }
      
      protected function __updateEmail(event:EmailEvent) : void
      {
         if(MailManager.Instance.Model.hasUnReadGiftEmail())
         {
            this._emailShine.play();
         }
         else
         {
            this._emailShine.stop();
         }
      }
      
      private function __goToEmail(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         MailManager.Instance.switchVisible();
         BagAndInfoManager.Instance.hideGiftFrame();
         MailManager.Instance.isOpenFromBag = true;
      }
      
      public function set info(value:PlayerInfo) : void
      {
         if(this._info == value)
         {
            return;
         }
         if(Boolean(this._info))
         {
            this._info.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__upView);
            PlayerManager.Instance.removeEventListener(PlayerManager.SELF_GIFT_INFO_CHANGE,this.__upView);
         }
         this._info = value;
         this._portrait.info = this._info;
         this._info.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__upView);
         PlayerManager.Instance.addEventListener(PlayerManager.SELF_GIFT_INFO_CHANGE,this.__upView);
         if(GiftController.Instance.canActive)
         {
            this.__updateEmail(null);
            MailManager.Instance.Model.addEventListener(EmailEvent.INIT_EMAIL,this.__updateEmail);
         }
         this.upView();
      }
      
      private function __upView(event:Event) : void
      {
         this.upView();
      }
      
      private function upView() : void
      {
         this._name.text = this._info.NickName;
         this._level.text = LanguageMgr.GetTranslation("ddt.giftSystem.GiftBannerView.giftLvel",this._info.charmLevel);
         this._charmNum.text = LanguageMgr.GetTranslation("ddt.giftSystem.GiftGoodItem.charmNum");
         var current:int = this._info.charmGP - PlayerInfo.CHARM_LEVEL_ALL_EXP[this._info.charmLevel - 1];
         this._totalGiftShow.text = LanguageMgr.GetTranslation("ddt.giftSystem.GiftBannerView.giftShow");
         this._totalGiftShowNum.text = this._info.giftSum.toString();
         this._levelProgress.setProgress(current,PlayerInfo.CHARM_LEVEL_NEED_EXP[this._info.charmLevel]);
         if(this._info.charmLevel == 100)
         {
            this._levelProgress.setProgress(1,1);
         }
         if(GiftController.Instance.canActive)
         {
            this._levelProgress.tipStyle = "ddt.view.tips.OneLineTip";
            this._levelProgress.tipDirctions = "3,7,6";
            this._levelProgress.tipGapV = 4;
            if(current >= 0 && this._info.charmLevel < 100)
            {
               this._levelProgress.tipData = current + "/" + PlayerInfo.CHARM_LEVEL_NEED_EXP[this._info.charmLevel];
            }
            else if(this._info.charmLevel == 100)
            {
               this._levelProgress.tipData = PlayerInfo.CHARM_LEVEL_NEED_EXP[99] + current + "/" + PlayerInfo.CHARM_LEVEL_NEED_EXP[99];
            }
         }
         this._levelProgress.labelText = this._info.charmGP.toString();
         if(GiftController.Instance.canActive && !GiftController.Instance.inChurch)
         {
            this._goEmail.enable = true;
            this._goEmail.addEventListener(MouseEvent.CLICK,this.__goToEmail);
         }
         else
         {
            this._goEmail.enable = false;
         }
      }
      
      public function dispose() : void
      {
         GiftController.Instance.inChurch = false;
         this._goEmail.removeEventListener(MouseEvent.CLICK,this.__goToEmail);
         this._info.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__upView);
         MailManager.Instance.Model.removeEventListener(EmailEvent.INIT_EMAIL,this.__updateEmail);
         PlayerManager.Instance.removeEventListener(PlayerManager.SELF_GIFT_INFO_CHANGE,this.__upView);
         if(Boolean(this.BG))
         {
            ObjectUtils.disposeObject(this.BG);
         }
         this.BG = null;
         if(Boolean(this._portrait))
         {
            this._portrait.dispose();
         }
         this._portrait = null;
         if(Boolean(this._name))
         {
            ObjectUtils.disposeObject(this._name);
         }
         this._name = null;
         if(Boolean(this._level))
         {
            ObjectUtils.disposeObject(this._level);
         }
         this._level = null;
         if(Boolean(this._levelBg))
         {
            ObjectUtils.disposeObject(this._levelBg);
         }
         this._levelBg = null;
         if(Boolean(this._charmNum))
         {
            ObjectUtils.disposeObject(this._charmNum);
         }
         this._charmNum = null;
         if(Boolean(this._levelProgress))
         {
            ObjectUtils.disposeObject(this._levelProgress);
         }
         this._levelProgress = null;
         if(Boolean(this._totalGiftBackground))
         {
            ObjectUtils.disposeObject(this._totalGiftBackground);
         }
         this._totalGiftBackground = null;
         if(Boolean(this._totalGiftBackground1))
         {
            ObjectUtils.disposeObject(this._totalGiftBackground1);
         }
         this._totalGiftBackground1 = null;
         if(Boolean(this._totalGiftShow))
         {
            ObjectUtils.disposeObject(this._totalGiftShow);
         }
         this._totalGiftShow = null;
         if(Boolean(this._goEmail))
         {
            ObjectUtils.disposeObject(this._goEmail);
         }
         this._goEmail = null;
         if(Boolean(this._emailShine))
         {
            EffectManager.Instance.removeEffect(this._emailShine);
         }
         this._emailShine = null;
         if(Boolean(this._totalGiftShowNum))
         {
            ObjectUtils.disposeObject(this._totalGiftShowNum);
         }
         this._totalGiftShowNum = null;
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
   }
}

