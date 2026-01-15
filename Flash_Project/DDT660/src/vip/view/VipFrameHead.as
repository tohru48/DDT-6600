package vip.view
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.MovieImage;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.text.GradientText;
   import com.pickgliss.utils.DisplayUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.events.PlayerPropertyEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.ServerConfigManager;
   import ddt.manager.SoundManager;
   import ddt.view.PlayerPortraitView;
   import ddt.view.common.VipLevelIcon;
   import ddt.view.tips.OneLineTip;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import vip.VipController;
   
   public class VipFrameHead extends Sprite implements Disposeable
   {
      
      private static var eachLevelEXP:Array = [0,150,350,700,1250,2050,3050,4250,5650];
      
      private var _topBG:DisplayObject;
      
      private var _selfName:FilterFrameText;
      
      private var _vipName:GradientText;
      
      private var _vipIcon:VipLevelIcon;
      
      private var _ClockImg:Bitmap;
      
      private var _dueTime:FilterFrameText;
      
      private var _vipLevelProgress:VipLevelProgress;
      
      private var _vipHelpBtn:TextButton;
      
      private var _vipRuleDescriptionBtn:TextButton;
      
      private var _selfLevel:FilterFrameText;
      
      private var _nextLevel:FilterFrameText;
      
      private var _dueDataWord:FilterFrameText;
      
      private var _dueData:FilterFrameText;
      
      private var _DueTipSprite:Sprite;
      
      private var _DueTip:OneLineTip;
      
      private var _portrait:PlayerPortraitView;
      
      private var _isVipRechargeShow:Boolean = false;
      
      private var _descriptionFrame:Frame;
      
      private var _frameBg:Scale9CornerImage;
      
      private var _okBtn:TextButton;
      
      private var _contenttxt:MovieImage;
      
      private var _discountDateTxt:FilterFrameText;
      
      private var _helpFrame:VIPHelpFrame;
      
      public function VipFrameHead(isVipRechargeShow:Boolean = false)
      {
         super();
         this._isVipRechargeShow = isVipRechargeShow;
         this.init();
      }
      
      private function init() : void
      {
         if(this._isVipRechargeShow)
         {
            this._topBG = ComponentFactory.Instance.creatComponentByStylename("VIPFrame.topReChargeBG");
         }
         else
         {
            this._topBG = ComponentFactory.Instance.creatComponentByStylename("VIPFrame.topBG");
         }
         this._selfName = ComponentFactory.Instance.creat("VipStatusView.name");
         this._vipIcon = ComponentFactory.Instance.creatCustomObject("VipStatusView.vipIcon");
         this._ClockImg = ComponentFactory.Instance.creatBitmap("asset.vip.timeBitmap");
         this._dueTime = ComponentFactory.Instance.creat("VIPFrame.dueTime");
         this._discountDateTxt = ComponentFactory.Instance.creatComponentByStylename("VipStatusView.discountDateTxt");
         this._discountDateTxt.text = PlayerManager.Instance.vipDiscountTime;
         this._vipLevelProgress = ComponentFactory.Instance.creat("VIPFrame.vipLevelProgress");
         if(!this._isVipRechargeShow)
         {
            this._dueDataWord = ComponentFactory.Instance.creatComponentByStylename("VipStatusView.dueDateFontTxt");
            this._dueDataWord.text = LanguageMgr.GetTranslation("ddt.vip.dueDateFontTxt");
            this._dueData = ComponentFactory.Instance.creat("VipStatusView.dueDate");
            this._vipHelpBtn = ComponentFactory.Instance.creatComponentByStylename("VipStatusView.vipHelp");
            this._vipHelpBtn.text = LanguageMgr.GetTranslation("ddt.vip.vipHelpBtn");
            this._vipRuleDescriptionBtn = ComponentFactory.Instance.creatComponentByStylename("vipHead.RuleDescriptionBtn");
            this._vipRuleDescriptionBtn.text = LanguageMgr.GetTranslation("ddt.vip.vipFrameHead.VipPrivilegeTxt");
         }
         this._selfLevel = ComponentFactory.Instance.creat("VipStatusView.selfLevel");
         this._nextLevel = ComponentFactory.Instance.creat("VipStatusView.nextLevel");
         this._portrait = ComponentFactory.Instance.creatCustomObject("vip.PortraitView",["right"]);
         this._portrait.info = PlayerManager.Instance.Self;
         addChild(this._topBG);
         addChild(this._portrait);
         addChild(this._vipLevelProgress);
         if(!this._isVipRechargeShow)
         {
            addChild(this._vipRuleDescriptionBtn);
            addChild(this._dueDataWord);
            addChild(this._dueData);
         }
         addChild(this._selfLevel);
         addChild(this._nextLevel);
         this.addTipSprite();
         this.upView();
         this.addEvent();
      }
      
      private function addTipSprite() : void
      {
         this._DueTipSprite = new Sprite();
         this._DueTipSprite.graphics.beginFill(0,0);
         this._DueTipSprite.graphics.drawRect(0,0,this._vipLevelProgress.width,this._vipLevelProgress.height);
         this._DueTipSprite.graphics.endFill();
         var pos:Point = ComponentFactory.Instance.creatCustomObject("Vip.DueTipSpritePos");
         this._DueTipSprite.x = pos.x;
         this._DueTipSprite.y = pos.y;
         addChild(this._DueTipSprite);
         this._DueTip = new OneLineTip();
         addChild(this._DueTip);
         this._DueTip.x = this._DueTipSprite.x;
         this._DueTip.y = this._DueTipSprite.y + 25;
         this._DueTip.visible = false;
      }
      
      private function addEvent() : void
      {
         PlayerManager.Instance.Self.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__propertyChange);
         if(Boolean(this._vipHelpBtn))
         {
            this._vipHelpBtn.addEventListener(MouseEvent.CLICK,this.__showHelpFrame);
         }
         if(Boolean(this._vipRuleDescriptionBtn))
         {
            this._vipRuleDescriptionBtn.addEventListener(MouseEvent.CLICK,this.__helpHandler);
         }
         this._DueTipSprite.addEventListener(MouseEvent.MOUSE_OVER,this.__showDueTip);
         this._DueTipSprite.addEventListener(MouseEvent.MOUSE_OUT,this.__hideDueTip);
      }
      
      private function __helpHandler(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this._descriptionFrame = ComponentFactory.Instance.creatComponentByStylename("vip.VipPrivilegeFrame");
         LayerManager.Instance.addToLayer(this._descriptionFrame,LayerManager.GAME_TOP_LAYER,true,LayerManager.ALPHA_BLOCKGOUND);
      }
      
      private function __helpFrameRespose(event:FrameEvent) : void
      {
         if(event.responseCode == FrameEvent.CLOSE_CLICK || event.responseCode == FrameEvent.ESC_CLICK)
         {
            SoundManager.instance.play("008");
            this.disposeHelpFrame();
         }
      }
      
      private function __closeHelpFrame(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
      }
      
      private function disposeHelpFrame() : void
      {
         this._okBtn.removeEventListener(MouseEvent.CLICK,this.__closeHelpFrame);
         this._descriptionFrame.dispose();
         this._okBtn = null;
         this._contenttxt = null;
         this._descriptionFrame = null;
      }
      
      private function removeEvent() : void
      {
         PlayerManager.Instance.Self.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__propertyChange);
         if(Boolean(this._vipHelpBtn))
         {
            this._vipHelpBtn.removeEventListener(MouseEvent.CLICK,this.__showHelpFrame);
         }
         if(Boolean(this._DueTipSprite))
         {
            this._DueTipSprite.removeEventListener(MouseEvent.MOUSE_OVER,this.__showDueTip);
            this._DueTipSprite.removeEventListener(MouseEvent.MOUSE_OUT,this.__hideDueTip);
         }
      }
      
      private function __showDueTip(evt:MouseEvent) : void
      {
         this._DueTip.visible = true;
      }
      
      private function __hideDueTip(evt:MouseEvent) : void
      {
         this._DueTip.visible = false;
      }
      
      private function __showHelpFrame(evt:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this._helpFrame = ComponentFactory.Instance.creatComponentByStylename("vip.viphelpFrame");
         this._helpFrame.show();
         this._helpFrame.addEventListener(FrameEvent.RESPONSE,this.__responseHandler);
      }
      
      protected function __responseHandler(event:FrameEvent) : void
      {
         this._helpFrame.removeEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         SoundManager.instance.play("008");
         switch(event.responseCode)
         {
            case FrameEvent.CLOSE_CLICK:
            case FrameEvent.ESC_CLICK:
               this._helpFrame.dispose();
               this._helpFrame = null;
         }
      }
      
      private function __propertyChange(evt:PlayerPropertyEvent) : void
      {
         if(Boolean(evt.changedProperties["isVip"]) || Boolean(evt.changedProperties["VipExpireDay"]) || Boolean(evt.changedProperties["VIPNextLevelDaysNeeded"]))
         {
            this.upView();
         }
      }
      
      private function upView() : void
      {
         var need:int = 0;
         var date:Date = null;
         var exp:int = 0;
         if(PlayerManager.Instance.Self.VIPLevel != 12 && PlayerManager.Instance.Self.IsVIP)
         {
            need = ServerConfigManager.instance.VIPExpNeededForEachLv[PlayerManager.Instance.Self.VIPLevel] - PlayerManager.Instance.Self.VIPExp;
            this._DueTip.tipData = LanguageMgr.GetTranslation("ddt.vip.dueTime.tip",need,PlayerManager.Instance.Self.VIPLevel + 1);
         }
         else if(!PlayerManager.Instance.Self.IsVIP)
         {
            this._DueTip.tipData = LanguageMgr.GetTranslation("ddt.vip.vipIcon.reduceVipExp");
         }
         else
         {
            this._DueTip.tipData = LanguageMgr.GetTranslation("ddt.vip.vipIcon.upGradFull");
         }
         if(!PlayerManager.Instance.Self.IsVIP && PlayerManager.Instance.Self.VIPExp <= 0)
         {
            this._DueTip.tipData = LanguageMgr.GetTranslation("ddt.vip.vipFrame.youarenovip");
         }
         this._selfName.text = PlayerManager.Instance.Self.NickName;
         if(PlayerManager.Instance.Self.IsVIP)
         {
            if(Boolean(this._vipName))
            {
               ObjectUtils.disposeObject(this._vipName);
            }
            this._vipName = VipController.instance.getVipNameTxt(100,PlayerManager.Instance.Self.typeVIP);
            this._vipName.textSize = 18;
            this._vipName.x = this._selfName.x;
            this._vipName.y = this._selfName.y;
            this._vipName.text = this._selfName.text;
            addChild(this._vipName);
            DisplayUtils.removeDisplay(this._selfName);
         }
         else
         {
            addChild(this._selfName);
            DisplayUtils.removeDisplay(this._vipName);
         }
         this._vipIcon.setInfo(PlayerManager.Instance.Self,true,true);
         if(PlayerManager.Instance.Self.IsVIP)
         {
            this._vipIcon.x = this._vipName.x + this._vipName.textWidth + 5;
         }
         else
         {
            this._vipIcon.x = this._selfName.x + this._selfName.textWidth + 5;
         }
         addChild(this._vipIcon);
         this._selfLevel.text = "LV:" + PlayerManager.Instance.Self.VIPLevel;
         this._nextLevel.text = "LV:" + (PlayerManager.Instance.Self.VIPLevel + 1);
         if(!this._isVipRechargeShow)
         {
            date = PlayerManager.Instance.Self.VIPExpireDay as Date;
            this._dueData.text = date.fullYear + "-" + (date.month + 1) + "-" + date.date;
         }
         if(!PlayerManager.Instance.Self.IsVIP && !this._isVipRechargeShow)
         {
            this._dueData.text = "";
         }
         if(PlayerManager.Instance.Self.VIPLevel == 12)
         {
            this._nextLevel.text = "";
         }
         if(!PlayerManager.Instance.Self.IsVIP && PlayerManager.Instance.Self.VIPExp <= 0)
         {
            this._dueTime.text = 0 + LanguageMgr.GetTranslation("shop.ShopIIShoppingCarItem.day");
         }
         else
         {
            this._dueTime.text = PlayerManager.Instance.Self.VIPNextLevelDaysNeeded + LanguageMgr.GetTranslation("shop.ShopIIShoppingCarItem.day");
         }
         var now:int = 0;
         var max:int = 0;
         var curLevel:int = PlayerManager.Instance.Self.VIPLevel;
         if(PlayerManager.Instance.Self.VIPLevel == 12)
         {
            exp = ServerConfigManager.instance.VIPExpNeededForEachLv[11] - ServerConfigManager.instance.VIPExpNeededForEachLv[10];
            this._vipLevelProgress.setProgress(1,1);
            this._vipLevelProgress.labelText = exp + "/" + exp;
         }
         else
         {
            now = PlayerManager.Instance.Self.VIPExp - ServerConfigManager.instance.VIPExpNeededForEachLv[curLevel - 1];
            max = ServerConfigManager.instance.VIPExpNeededForEachLv[curLevel] - ServerConfigManager.instance.VIPExpNeededForEachLv[curLevel - 1];
            this._vipLevelProgress.setProgress(now,max);
            this._vipLevelProgress.labelText = now + "/" + max;
         }
         this.grayOrLightVIP();
      }
      
      private function grayOrLightVIP() : void
      {
         if(!PlayerManager.Instance.Self.IsVIP)
         {
            this._vipIcon.filters = ComponentFactory.Instance.creatFilters("grayFilter");
            this._vipLevelProgress.filters = ComponentFactory.Instance.creatFilters("grayFilter");
         }
         else
         {
            this._vipIcon.filters = null;
            this._vipLevelProgress.filters = null;
         }
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         if(Boolean(this._topBG))
         {
            ObjectUtils.disposeObject(this._topBG);
         }
         this._topBG = null;
         if(Boolean(this._vipIcon))
         {
            ObjectUtils.disposeObject(this._vipIcon);
         }
         this._vipIcon = null;
         if(Boolean(this._ClockImg))
         {
            ObjectUtils.disposeObject(this._ClockImg);
         }
         this._ClockImg = null;
         if(Boolean(this._dueTime))
         {
            ObjectUtils.disposeObject(this._dueTime);
         }
         this._dueTime = null;
         if(Boolean(this._vipLevelProgress))
         {
            ObjectUtils.disposeObject(this._vipLevelProgress);
         }
         this._vipLevelProgress = null;
         if(Boolean(this._vipHelpBtn))
         {
            ObjectUtils.disposeObject(this._vipHelpBtn);
            this._vipHelpBtn = null;
         }
         if(Boolean(this._selfLevel))
         {
            ObjectUtils.disposeObject(this._selfLevel);
         }
         this._selfLevel = null;
         if(Boolean(this._nextLevel))
         {
            ObjectUtils.disposeObject(this._nextLevel);
         }
         this._nextLevel = null;
         if(Boolean(this._vipName))
         {
            ObjectUtils.disposeObject(this._vipName);
         }
         this._vipName = null;
         if(Boolean(this._DueTipSprite))
         {
            ObjectUtils.disposeObject(this._DueTipSprite);
         }
         this._DueTipSprite = null;
         if(Boolean(this._DueTip))
         {
            ObjectUtils.disposeObject(this._DueTip);
         }
         this._DueTip = null;
         if(Boolean(this._dueDataWord))
         {
            ObjectUtils.disposeObject(this._dueDataWord);
         }
         this._dueDataWord = null;
         if(Boolean(this._dueData))
         {
            ObjectUtils.disposeObject(this._dueData);
         }
         this._dueData = null;
         if(Boolean(this._helpFrame))
         {
            this._helpFrame.dispose();
         }
         this._helpFrame = null;
         if(Boolean(this._vipRuleDescriptionBtn))
         {
            this._vipRuleDescriptionBtn.dispose();
         }
         this._vipRuleDescriptionBtn = null;
         if(Boolean(parent))
         {
            this.parent.removeChild(this);
         }
         ObjectUtils.disposeObject(this._portrait);
      }
   }
}

