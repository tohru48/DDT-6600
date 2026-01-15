package consortion.view.selfConsortia
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.text.FilterFrameTextWithTips;
   import com.pickgliss.ui.text.GradientText;
   import com.pickgliss.utils.DisplayUtils;
   import com.pickgliss.utils.ObjectUtils;
   import consortion.ConsortionModel;
   import consortion.ConsortionModelControl;
   import consortion.event.ConsortionEvent;
   import ddt.data.ConsortiaInfo;
   import ddt.events.PlayerPropertyEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.text.TextFormat;
   import road7th.utils.StringHelper;
   import vip.VipController;
   
   public class ConsortionInfoView extends Sprite implements Disposeable
   {
      
      private var _badgeBtn:BuyBadgeButton;
      
      private var _shopIcon:BuildingLevelItem;
      
      private var _storeIcon:BuildingLevelItem;
      
      private var _bankIcon:BuildingLevelItem;
      
      private var _skillIcon:BuildingLevelItem;
      
      private var _infoWordBG:Scale9CornerImage;
      
      private var _bg:Bitmap;
      
      private var _consortionName:FilterFrameText;
      
      private var _level:ScaleFrameImage;
      
      private var _consortionNameInput:FilterFrameText;
      
      private var _chairmanName:FilterFrameText;
      
      private var _vipChairman:GradientText;
      
      private var _count:FilterFrameText;
      
      private var _riches:FilterFrameText;
      
      private var _honor:FilterFrameText;
      
      private var _repute:FilterFrameText;
      
      private var _weekPay:FilterFrameTextWithTips;
      
      private var _consortiaInfo:ConsortiaInfo;
      
      private var _BG2:ScaleBitmapImage;
      
      private var _chairmanText:FilterFrameText;
      
      private var _numberText:FilterFrameText;
      
      private var _richesText:FilterFrameText;
      
      private var _exploitText:FilterFrameText;
      
      private var _rankingText:FilterFrameText;
      
      private var _holdText:FilterFrameText;
      
      private var _chairmanTextInputBg:Scale9CornerImage;
      
      private var _numberTextInputBg:Scale9CornerImage;
      
      private var _richesTextInputBg:Scale9CornerImage;
      
      private var _exploitTextInputBg:Scale9CornerImage;
      
      private var _rankingTextInputBg:Scale9CornerImage;
      
      private var _holdTextInputBg:Scale9CornerImage;
      
      public function ConsortionInfoView()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         this._badgeBtn = new BuyBadgeButton();
         PositionUtils.setPos(this._badgeBtn,"consortiaBadgeBtn.pos");
         this._shopIcon = new BuildingLevelItem(ConsortionModel.SHOP);
         PositionUtils.setPos(this._shopIcon,"shopIcon.pos");
         this._storeIcon = new BuildingLevelItem(ConsortionModel.STORE);
         PositionUtils.setPos(this._storeIcon,"storeIcon.pos");
         this._bankIcon = new BuildingLevelItem(ConsortionModel.BANK);
         PositionUtils.setPos(this._bankIcon,"bankIcon.pos");
         this._skillIcon = new BuildingLevelItem(ConsortionModel.SKILL);
         PositionUtils.setPos(this._skillIcon,"skillIcon.pos");
         this._infoWordBG = ComponentFactory.Instance.creat("consortion.wordBG");
         this._bg = ComponentFactory.Instance.creatBitmap("asset.consortion.level");
         this._level = ComponentFactory.Instance.creatComponentByStylename("consortion.level");
         this._consortionName = ComponentFactory.Instance.creatComponentByStylename("consortion.nameText");
         this._consortionName.text = LanguageMgr.GetTranslation("tank.consortionClub.MemberListTitleText1.text");
         this._consortionNameInput = ComponentFactory.Instance.creatComponentByStylename("consortion.nameInputText");
         this._chairmanName = ComponentFactory.Instance.creatComponentByStylename("consortion.chairmanName");
         this._BG2 = ComponentFactory.Instance.creatComponentByStylename("consortion.consortionInfoView.bg");
         this._chairmanText = ComponentFactory.Instance.creatComponentByStylename("consortion.chairmanText");
         this._chairmanText.text = LanguageMgr.GetTranslation("tanl.consortion.chairmanText.text");
         this._numberText = ComponentFactory.Instance.creatComponentByStylename("consortion.numberText");
         this._numberText.text = LanguageMgr.GetTranslation("tanl.consortion.numberText.text");
         this._richesText = ComponentFactory.Instance.creatComponentByStylename("consortion.richesText");
         this._richesText.text = LanguageMgr.GetTranslation("tanl.consortion.richesText.text");
         this._exploitText = ComponentFactory.Instance.creatComponentByStylename("consortion.exploitText");
         this._exploitText.text = LanguageMgr.GetTranslation("tanl.consortion.exploitText.text");
         this._rankingText = ComponentFactory.Instance.creatComponentByStylename("consortion.rankingText");
         this._rankingText.text = LanguageMgr.GetTranslation("tanl.consortion.rankingText.text");
         this._holdText = ComponentFactory.Instance.creatComponentByStylename("consortion.holdText");
         this._holdText.text = LanguageMgr.GetTranslation("tanl.consortion.holdText.text");
         this._chairmanTextInputBg = ComponentFactory.Instance.creat("consortion.chairmanTextInputBg");
         this._numberTextInputBg = ComponentFactory.Instance.creat("consortion.numberTextInputBg");
         this._richesTextInputBg = ComponentFactory.Instance.creat("consortion.richesTextInputBg");
         this._exploitTextInputBg = ComponentFactory.Instance.creat("consortion.exploitTextInputBg");
         this._rankingTextInputBg = ComponentFactory.Instance.creat("consortion.rankingTextInputBg");
         this._holdTextInputBg = ComponentFactory.Instance.creat("consortion.holdTextInputBg");
         this._count = ComponentFactory.Instance.creatComponentByStylename("consortion.count");
         this._riches = ComponentFactory.Instance.creatComponentByStylename("consortion.riches");
         this._honor = ComponentFactory.Instance.creatComponentByStylename("consortion.offer");
         this._repute = ComponentFactory.Instance.creatComponentByStylename("consortion.repute");
         this._weekPay = ComponentFactory.Instance.creatComponentByStylename("consortion.weekPay");
         this._weekPay.mouseEnabled = true;
         this._weekPay.selectable = false;
         addChild(this._badgeBtn);
         addChild(this._shopIcon);
         addChild(this._storeIcon);
         addChild(this._bankIcon);
         addChild(this._skillIcon);
         addChild(this._infoWordBG);
         addChild(this._bg);
         addChild(this._level);
         addChild(this._consortionName);
         addChild(this._consortionNameInput);
         addChild(this._BG2);
         addChild(this._chairmanText);
         addChild(this._numberText);
         addChild(this._richesText);
         addChild(this._exploitText);
         addChild(this._rankingText);
         addChild(this._holdText);
         addChild(this._chairmanTextInputBg);
         addChild(this._numberTextInputBg);
         addChild(this._richesTextInputBg);
         addChild(this._exploitTextInputBg);
         addChild(this._rankingTextInputBg);
         addChild(this._holdTextInputBg);
         addChild(this._count);
         addChild(this._riches);
         addChild(this._honor);
         addChild(this._repute);
         addChild(this._weekPay);
         this.consortionInfo = PlayerManager.Instance.Self.consortiaInfo;
      }
      
      private function initEvent() : void
      {
         PlayerManager.Instance.Self.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this._consortiaInfoChange);
         PlayerManager.Instance.Self.consortiaInfo.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__consortiaInfoPropChange);
         ConsortionModelControl.Instance.model.addEventListener(ConsortionEvent.LEVEL_UP_RULE_CHANGE,this._levelUpRuleChange);
      }
      
      private function removeEvent() : void
      {
         PlayerManager.Instance.Self.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this._consortiaInfoChange);
         PlayerManager.Instance.Self.consortiaInfo.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__consortiaInfoPropChange);
         ConsortionModelControl.Instance.model.removeEventListener(ConsortionEvent.LEVEL_UP_RULE_CHANGE,this._levelUpRuleChange);
      }
      
      private function _levelUpRuleChange(event:ConsortionEvent) : void
      {
         this.setWeekyPay();
      }
      
      private function _consortiaInfoChange(event:PlayerPropertyEvent) : void
      {
         if(Boolean(event.changedProperties["consortiaInfo"]))
         {
            this.consortionInfo = PlayerManager.Instance.Self.consortiaInfo;
         }
      }
      
      private function __consortiaInfoPropChange(event:PlayerPropertyEvent) : void
      {
         this.consortionInfo = PlayerManager.Instance.Self.consortiaInfo;
      }
      
      private function setWeekyPay() : void
      {
         if(this._consortiaInfo && this._consortiaInfo.Level != 0 && ConsortionModelControl.Instance.model.levelUpData != null)
         {
            this._weekPay.text = String(ConsortionModelControl.Instance.model.getLevelData(this._consortiaInfo.Level).Deduct);
            if(this._weekPay.text != "")
            {
               this._weekPay.mouseEnabled = true;
            }
            else
            {
               this._weekPay.mouseEnabled = false;
            }
            this._weekPay.tipData = StringHelper.parseTime(this._consortiaInfo.DeductDate,7);
         }
      }
      
      private function set consortionInfo(info:ConsortiaInfo) : void
      {
         var textFormat:TextFormat = null;
         this._consortiaInfo = info;
         if(info.ConsortiaID != 0)
         {
            this._shopIcon.mouseChildren = this._shopIcon.mouseEnabled = this._storeIcon.mouseChildren = this._storeIcon.mouseEnabled = this._bankIcon.mouseChildren = this._bankIcon.mouseEnabled = this._skillIcon.mouseChildren = this._skillIcon.mouseEnabled = true;
            this._shopIcon.tipData = info.ShopLevel;
            this._storeIcon.tipData = info.SmithLevel;
            this._bankIcon.tipData = info.StoreLevel;
            this._skillIcon.tipData = info.BufferLevel;
            this._level.setFrame(info.Level);
            this._consortionNameInput.text = info.ConsortiaName;
            if(info.ChairmanIsVIP)
            {
               ObjectUtils.disposeObject(this._vipChairman);
               this._vipChairman = VipController.instance.getVipNameTxt(142,info.ChairmanTypeVIP);
               textFormat = new TextFormat();
               textFormat.align = "center";
               textFormat.bold = true;
               this._vipChairman.textField.defaultTextFormat = textFormat;
               this._vipChairman.textSize = 16;
               this._vipChairman.x = this._chairmanName.x;
               this._vipChairman.y = this._chairmanName.y - 3;
               if(info.ChairmanName.length > 10)
               {
                  this._vipChairman.text = info.ChairmanName.substring(0,10) + "...";
               }
               else
               {
                  this._vipChairman.text = info.ChairmanName;
               }
               addChild(this._vipChairman);
               DisplayUtils.removeDisplay(this._chairmanName);
            }
            else
            {
               if(info.ChairmanName.length > 10)
               {
                  this._chairmanName.text = info.ChairmanName.substring(0,10) + "...";
               }
               else
               {
                  this._chairmanName.text = info.ChairmanName;
               }
               addChild(this._chairmanName);
               DisplayUtils.removeDisplay(this._vipChairman);
            }
            this._count.text = String(info.Count);
            this._riches.text = String(info.Riches);
            this._honor.text = String(info.Honor);
            this._repute.text = String(info.Repute);
            this._badgeBtn.badgeID = info.BadgeID;
            this.setWeekyPay();
         }
         else
         {
            this._weekPay.mouseEnabled = false;
            this._shopIcon.mouseChildren = this._shopIcon.mouseEnabled = this._storeIcon.mouseChildren = this._storeIcon.mouseEnabled = this._bankIcon.mouseChildren = this._bankIcon.mouseEnabled = this._skillIcon.mouseChildren = this._skillIcon.mouseEnabled = false;
         }
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         if(Boolean(this._badgeBtn))
         {
            ObjectUtils.disposeObject(this._badgeBtn);
         }
         this._badgeBtn = null;
         ObjectUtils.disposeAllChildren(this);
         this._shopIcon = null;
         this._storeIcon = null;
         this._bankIcon = null;
         this._skillIcon = null;
         if(Boolean(this._infoWordBG))
         {
            ObjectUtils.disposeObject(this._infoWordBG);
         }
         this._infoWordBG = null;
         if(Boolean(this._bg))
         {
            this._bg.bitmapData.dispose();
            this._bg.bitmapData = null;
         }
         this._bg = null;
         if(Boolean(this._BG2))
         {
            ObjectUtils.disposeObject(this._BG2);
         }
         if(Boolean(this._level))
         {
            ObjectUtils.disposeObject(this._level);
         }
         if(Boolean(this._consortionName))
         {
            ObjectUtils.disposeObject(this._consortionName);
         }
         if(Boolean(this._consortionNameInput))
         {
            ObjectUtils.disposeObject(this._consortionNameInput);
         }
         if(Boolean(this._chairmanName))
         {
            ObjectUtils.disposeObject(this._chairmanName);
         }
         if(Boolean(this._vipChairman))
         {
            ObjectUtils.disposeObject(this._vipChairman);
         }
         if(Boolean(this._chairmanText))
         {
            ObjectUtils.disposeObject(this._chairmanText);
         }
         if(Boolean(this._numberText))
         {
            ObjectUtils.disposeObject(this._numberText);
         }
         if(Boolean(this._richesText))
         {
            ObjectUtils.disposeObject(this._richesText);
         }
         if(Boolean(this._exploitText))
         {
            ObjectUtils.disposeObject(this._exploitText);
         }
         if(Boolean(this._rankingText))
         {
            ObjectUtils.disposeObject(this._rankingText);
         }
         if(Boolean(this._holdText))
         {
            ObjectUtils.disposeObject(this._holdText);
         }
         this._BG2 = null;
         this._level = null;
         this._consortionName = null;
         this._consortionNameInput = null;
         this._chairmanName = null;
         this._vipChairman = null;
         this._chairmanText = null;
         this._numberText = null;
         this._richesText = null;
         this._exploitText = null;
         this._rankingText = null;
         this._holdText = null;
         if(Boolean(this._chairmanTextInputBg))
         {
            ObjectUtils.disposeObject(this._chairmanTextInputBg);
         }
         this._chairmanTextInputBg = null;
         if(Boolean(this._numberTextInputBg))
         {
            ObjectUtils.disposeObject(this._numberTextInputBg);
         }
         this._numberTextInputBg = null;
         if(Boolean(this._richesTextInputBg))
         {
            ObjectUtils.disposeObject(this._richesTextInputBg);
         }
         this._richesTextInputBg = null;
         if(Boolean(this._exploitTextInputBg))
         {
            ObjectUtils.disposeObject(this._exploitTextInputBg);
         }
         this._exploitTextInputBg = null;
         if(Boolean(this._rankingTextInputBg))
         {
            ObjectUtils.disposeObject(this._rankingTextInputBg);
         }
         this._rankingTextInputBg = null;
         if(Boolean(this._holdTextInputBg))
         {
            ObjectUtils.disposeObject(this._holdTextInputBg);
         }
         this._holdTextInputBg = null;
         this._count = null;
         this._riches = null;
         this._honor = null;
         this._repute = null;
         this._weekPay = null;
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
   }
}

