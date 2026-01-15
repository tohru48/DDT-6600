package vip.view
{
   import baglocked.BaglockedManager;
   import com.greensock.TweenMax;
   import com.pickgliss.effect.EffectManager;
   import com.pickgliss.effect.EffectTypes;
   import com.pickgliss.effect.IEffect;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.SelectedButton;
   import com.pickgliss.ui.controls.SelectedButtonGroup;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.Image;
   import com.pickgliss.ui.image.MutipleImage;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.events.PlayerPropertyEvent;
   import ddt.manager.BossBoxManager;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.ServerConfigManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import ddt.view.bossbox.AwardsView;
   import ddt.view.bossbox.AwardsViewII;
   import ddt.view.bossbox.VipInfoTipBox;
   import ddtBuried.BuriedManager;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import road7th.data.DictionaryData;
   import vip.VipController;
   
   public class GiveYourselfOpenView extends Sprite implements Disposeable
   {
      
      public static var vip_reward_arr:Array;
      
      public static const VIP_LEVEL1:String = "112112";
      
      public static const VIP_LEVEL2:String = "112113";
      
      public static const VIP_LEVEL3:String = "112114";
      
      public static const VIP_LEVEL4:String = "112115";
      
      public static const VIP_LEVEL5:String = "112116";
      
      public static const VIP_LEVEL6:String = "112117";
      
      public static const VIP_LEVEL7:String = "112118";
      
      public static const VIP_LEVEL8:String = "112119";
      
      public static const VIP_LEVEL9:String = "112120";
      
      public static const VIP_LEVEL10:String = "112204";
      
      public static const VIP_LEVEL11:String = "112205";
      
      public static const VIP_LEVEL12:String = "112206";
      
      public static var _vipChestsArr:Array = [VIP_LEVEL1,VIP_LEVEL2,VIP_LEVEL3,VIP_LEVEL4,VIP_LEVEL5,VIP_LEVEL6,VIP_LEVEL7,VIP_LEVEL8,VIP_LEVEL9,VIP_LEVEL10,VIP_LEVEL11,VIP_LEVEL12];
      
      public static var millisecondsPerDay:int = 1000 * 60 * 60 * 24;
      
      private static const ONE_MONTH_PAY:int = ServerConfigManager.instance.VIPRenewalPrice[0];
      
      private static const THREE_MONTH_PAY:int = ServerConfigManager.instance.VIPRenewalPrice[1];
      
      private static const HALF_YEAR_PAY:int = ServerConfigManager.instance.VIPRenewalPrice[2];
      
      private var _BG:MutipleImage;
      
      protected var _showPayMoneyBG:Image;
      
      protected var _openVipBtn:BaseButton;
      
      protected var _renewalVipBtn:BaseButton;
      
      protected var _rewardBtn:BaseButton;
      
      private var _rewardEffet:IEffect;
      
      protected var _rewardShin:Scale9CornerImage;
      
      protected var _money:FilterFrameText;
      
      protected var _isSelf:Boolean;
      
      private var _halfYearBtn:SelectedButton;
      
      private var _threeMonthBtn:SelectedButton;
      
      private var _oneMonthBtn:SelectedButton;
      
      protected var _vipPrivilegeTxt:VipPrivilegeTxt;
      
      private var _vipPrivilegeTxtBg:Image;
      
      private var _openVipTimeBtnGroup:SelectedButtonGroup;
      
      private var _selectedBtnImage:Image;
      
      public var discountCode:int;
      
      private var _halfYearTxt:FilterFrameText;
      
      private var _threeMonthTxt:FilterFrameText;
      
      private var _oneMonthTxt:FilterFrameText;
      
      private var awards:AwardsViewII;
      
      private var alertFrame:BaseAlerFrame;
      
      private var _vipInfoTipBox:VipInfoTipBox;
      
      private var _confirmFrame:BaseAlerFrame;
      
      private var _moneyConfirm:BaseAlerFrame;
      
      protected var days:int = 0;
      
      protected var payNum:int = 0;
      
      protected var time:String = "";
      
      public function GiveYourselfOpenView($discountCode:int = 0)
      {
         super();
         this.discountCode = $discountCode;
         this._init();
      }
      
      public static function getVipinfo() : Array
      {
         var info:ItemTemplateInfo = null;
         vip_reward_arr = new Array();
         for(var i:int = 0; i < _vipChestsArr[i]; i++)
         {
            info = ItemManager.Instance.getTemplateById(_vipChestsArr[i]);
            vip_reward_arr.push(info);
         }
         return vip_reward_arr;
      }
      
      private function _init() : void
      {
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         this._isSelf = true;
         this.initContent();
         this.addTextAndBtn();
         this.upPayMoneyText();
         this.showOpenOrRenewal();
         this.rewardBtnCanUse();
      }
      
      private function initContent() : void
      {
         this._BG = ComponentFactory.Instance.creatComponentByStylename("GiveYourselfOpenView.BGI");
         this._halfYearBtn = ComponentFactory.Instance.creatComponentByStylename("ddtvip.halfYearBtn");
         this._threeMonthBtn = ComponentFactory.Instance.creatComponentByStylename("ddtvip.threeMonthBtn");
         this._oneMonthBtn = ComponentFactory.Instance.creatComponentByStylename("ddtvip.oneMonthBtn");
         this._halfYearTxt = ComponentFactory.Instance.creatComponentByStylename("GiveYourselfOpenView.halfYearTxt");
         this._threeMonthTxt = ComponentFactory.Instance.creatComponentByStylename("GiveYourselfOpenView.threeMonthTxt");
         this._oneMonthTxt = ComponentFactory.Instance.creatComponentByStylename("GiveYourselfOpenView.oneMonthTxt");
         this._halfYearTxt.htmlText = LanguageMgr.GetTranslation("ddt.vipView.halfYearDiscount",int(PlayerManager.Instance.vipPriceArr[2]) > 0 ? PlayerManager.Instance.vipPriceArr[2] : HALF_YEAR_PAY);
         this._threeMonthTxt.htmlText = LanguageMgr.GetTranslation("ddt.vipView.threeMonthDiscount",int(PlayerManager.Instance.vipPriceArr[1]) > 0 ? PlayerManager.Instance.vipPriceArr[1] : THREE_MONTH_PAY);
         this._oneMonthTxt.htmlText = LanguageMgr.GetTranslation("ddt.vipView.oneMonthDiscount",int(PlayerManager.Instance.vipPriceArr[0]) > 0 ? PlayerManager.Instance.vipPriceArr[0] : ONE_MONTH_PAY);
         this._vipPrivilegeTxtBg = ComponentFactory.Instance.creatComponentByStylename("vip.VipPrivilegeTxtBg");
         this._vipPrivilegeTxt = ComponentFactory.Instance.creatCustomObject("vip.vipPrivilegeTxt");
         this._vipPrivilegeTxt.AlertContent = 6;
         this._selectedBtnImage = ComponentFactory.Instance.creatComponentByStylename("vip.LevelPrivilegeView.selectedBtnImage");
         addChild(this._BG);
         addChild(this._halfYearBtn);
         addChild(this._threeMonthBtn);
         addChild(this._oneMonthBtn);
         addChild(this._halfYearTxt);
         addChild(this._threeMonthTxt);
         addChild(this._oneMonthTxt);
         addChild(this._vipPrivilegeTxtBg);
         addChild(this._vipPrivilegeTxt);
         addChild(this._selectedBtnImage);
         this._openVipTimeBtnGroup = new SelectedButtonGroup();
         this._openVipTimeBtnGroup.addSelectItem(this._halfYearBtn);
         this._openVipTimeBtnGroup.addSelectItem(this._threeMonthBtn);
         this._openVipTimeBtnGroup.addSelectItem(this._oneMonthBtn);
         this._openVipTimeBtnGroup.selectIndex = 0;
      }
      
      private function addTextAndBtn() : void
      {
         this._money = ComponentFactory.Instance.creat("GiveYourselfOpenView.money");
         this._openVipBtn = ComponentFactory.Instance.creatComponentByStylename("GiveYourselfOpenView.openVipBtn");
         this._renewalVipBtn = ComponentFactory.Instance.creatComponentByStylename("GiveYourselfOpenView.renewalVipBtn");
         this._rewardBtn = ComponentFactory.Instance.creatComponentByStylename("GiveYourselfOpenView.rewardBtn");
         this._rewardShin = ComponentFactory.Instance.creatComponentByStylename("rewardBtn.shin");
         this._rewardEffet = EffectManager.Instance.creatEffect(EffectTypes.ALPHA_SHINER_ANIMATION,this._rewardBtn);
         addChild(this._openVipBtn);
         addChild(this._renewalVipBtn);
         addChild(this._rewardBtn);
         addChild(this._rewardShin);
         this._rewardShin.mouseChildren = false;
         this._rewardShin.mouseEnabled = false;
         this._money.text = PlayerManager.Instance.Self.Money + LanguageMgr.GetTranslation("money");
      }
      
      protected function showOpenOrRenewal() : void
      {
         if(this._isSelf)
         {
            if(PlayerManager.Instance.Self.VIPExp <= 0 && !PlayerManager.Instance.Self.IsVIP)
            {
               this._openVipBtn.visible = true;
               this._renewalVipBtn.visible = false;
            }
            else
            {
               this._openVipBtn.visible = false;
               this._renewalVipBtn.visible = true;
            }
         }
         else
         {
            this._openVipBtn.visible = true;
            this._renewalVipBtn.visible = false;
         }
      }
      
      protected function rewardBtnCanUse() : void
      {
         if(this._isSelf && PlayerManager.Instance.Self.IsVIP)
         {
            if(PlayerManager.Instance.Self.canTakeVipReward)
            {
               this._rewardBtn.visible = true;
               this._rewardShin.alpha = 1;
               this._rewardShin.visible = true;
               TweenMax.to(this._rewardShin,0.5,{
                  "alpha":0,
                  "yoyo":true,
                  "repeat":-1
               });
               PositionUtils.setPos(this._openVipBtn,"vip.rewardState.OpenRenewalBtnPos");
               PositionUtils.setPos(this._renewalVipBtn,"vip.rewardState.OpenRenewalBtnPos");
            }
            else
            {
               this._rewardBtn.visible = false;
               this._rewardShin.visible = false;
               TweenMax.killTweensOf(this._rewardShin);
               PositionUtils.setPos(this._openVipBtn,"vip.normalState.OpenRenewalBtnPos");
               PositionUtils.setPos(this._renewalVipBtn,"vip.normalState.OpenRenewalBtnPos");
            }
         }
         else
         {
            this._rewardBtn.visible = false;
            this._rewardShin.visible = false;
            TweenMax.killTweensOf(this._rewardShin);
            PositionUtils.setPos(this._openVipBtn,"vip.normalState.OpenRenewalBtnPos");
            PositionUtils.setPos(this._renewalVipBtn,"vip.normalState.OpenRenewalBtnPos");
         }
      }
      
      private function initEvent() : void
      {
         this._openVipBtn.addEventListener(MouseEvent.CLICK,this.__openVip);
         this._renewalVipBtn.addEventListener(MouseEvent.CLICK,this.__openVip);
         this._openVipTimeBtnGroup.addEventListener(Event.CHANGE,this.__upPayNum);
         this._rewardBtn.addEventListener(MouseEvent.CLICK,this.__reward);
         PlayerManager.Instance.Self.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__propertyChange);
      }
      
      private function removeEvent() : void
      {
         this._openVipBtn.removeEventListener(MouseEvent.CLICK,this.__openVip);
         this._renewalVipBtn.removeEventListener(MouseEvent.CLICK,this.__openVip);
         this._openVipTimeBtnGroup.removeEventListener(Event.CHANGE,this.__upPayNum);
         this._rewardBtn.removeEventListener(MouseEvent.CLICK,this.__reward);
         PlayerManager.Instance.Self.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__propertyChange);
      }
      
      private function __reward(evt:MouseEvent) : void
      {
         var incream:int = 0;
         var date:Date = null;
         var nowDate:Date = null;
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.canTakeVipReward || PlayerManager.Instance.Self.IsVIP == false)
         {
            this._vipInfoTipBox = ComponentFactory.Instance.creat("vip.VipInfoTipFrame");
            this._vipInfoTipBox.escEnable = true;
            this._vipInfoTipBox.vipAwardGoodsList = this.getVIPInfoTip(BossBoxManager.instance.inventoryItemList);
            this._vipInfoTipBox.addEventListener(FrameEvent.RESPONSE,this.__responseVipInfoTipHandler);
            LayerManager.Instance.addToLayer(this._vipInfoTipBox,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
         }
         else
         {
            incream = 0;
            date = PlayerManager.Instance.Self.systemDate as Date;
            if(date.day == 0)
            {
               incream = 1;
            }
            else
            {
               incream = 8 - date.day;
            }
            nowDate = new Date(date.getTime() + incream * millisecondsPerDay);
            this.alertFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("ddt.vip.vipView.cueDateScript",nowDate.month + 1,nowDate.date),LanguageMgr.GetTranslation("ok"),"",false,false,false,LayerManager.ALPHA_BLOCKGOUND);
            this.alertFrame.moveEnable = false;
            this.alertFrame.addEventListener(FrameEvent.RESPONSE,this.__alertHandler);
         }
      }
      
      private function __alertHandler(evt:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         this.alertFrame.removeEventListener(FrameEvent.RESPONSE,this.__alertHandler);
         if(Boolean(this.alertFrame) && Boolean(this.alertFrame.parent))
         {
            this.alertFrame.parent.removeChild(this.alertFrame);
         }
         if(Boolean(this.alertFrame))
         {
            this.alertFrame.dispose();
         }
         this.alertFrame = null;
      }
      
      private function __responseVipInfoTipHandler(evt:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         this._vipInfoTipBox.removeEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         switch(evt.responseCode)
         {
            case FrameEvent.CLOSE_CLICK:
            case FrameEvent.ESC_CLICK:
               this._vipInfoTipBox.dispose();
               this._vipInfoTipBox = null;
               break;
            case FrameEvent.ENTER_CLICK:
               this.showAwards(this._vipInfoTipBox.selectCellInfo);
               this._vipInfoTipBox.dispose();
               this._vipInfoTipBox = null;
         }
      }
      
      private function __responseHandler(evt:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         this.awards.removeEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         switch(evt.responseCode)
         {
            case FrameEvent.CLOSE_CLICK:
            case FrameEvent.ESC_CLICK:
               this.awards.dispose();
               this.awards = null;
         }
      }
      
      private function showAwards(para:ItemTemplateInfo) : void
      {
         this.awards = ComponentFactory.Instance.creat("vip.awardFrame");
         this.awards.escEnable = true;
         this.awards.boxType = 2;
         this.awards.vipAwardGoodsList = this._getStrArr(BossBoxManager.instance.inventoryItemList);
         this.awards.addEventListener(AwardsView.HAVEBTNCLICK,this.__sendReward);
         this.awards.addEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         LayerManager.Instance.addToLayer(this.awards,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      private function __sendReward(evt:Event) : void
      {
         SoundManager.instance.play("008");
         SocketManager.Instance.out.sendDailyAward(3);
         this.awards.removeEventListener(AwardsView.HAVEBTNCLICK,this.__sendReward);
         this.awards.dispose();
         PlayerManager.Instance.Self.canTakeVipReward = false;
         this.rewardBtnCanUse();
      }
      
      private function __propertyChange(evt:PlayerPropertyEvent) : void
      {
         if(Boolean(evt.changedProperties["Money"]))
         {
            this._money.text = PlayerManager.Instance.Self.Money + LanguageMgr.GetTranslation("money");
         }
         if(Boolean(evt.changedProperties["isVip"]) || Boolean(evt.changedProperties["canTakeVipReward"]))
         {
            this.showOpenOrRenewal();
            this.rewardBtnCanUse();
         }
      }
      
      private function __upPayNum(e:Event) : void
      {
         SoundManager.instance.play("008");
         this.upPayMoneyText();
      }
      
      protected function __openVip(evt:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         var msg:String = LanguageMgr.GetTranslation("ddt.vip.vipView.confirmforSelf",this.time,this.payNum);
         this._confirmFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("ddt.vip.vipFrame.ConfirmTitle"),msg,LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,true,true,LayerManager.BLCAK_BLOCKGOUND,null,"SimpleAlert",30,true);
         this._confirmFrame.moveEnable = false;
         this._confirmFrame.addEventListener(FrameEvent.RESPONSE,this.__confirm);
      }
      
      private function __moneyConfirmHandler(evt:FrameEvent) : void
      {
         this._moneyConfirm.removeEventListener(FrameEvent.RESPONSE,this.__moneyConfirmHandler);
         switch(evt.responseCode)
         {
            case FrameEvent.ENTER_CLICK:
            case FrameEvent.SUBMIT_CLICK:
               LeavePageManager.leaveToFillPath();
         }
         this._moneyConfirm.dispose();
         if(Boolean(this._moneyConfirm.parent))
         {
            this._moneyConfirm.parent.removeChild(this._moneyConfirm);
         }
         this._moneyConfirm = null;
      }
      
      private function __confirm(evt:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         switch(evt.responseCode)
         {
            case FrameEvent.SUBMIT_CLICK:
            case FrameEvent.ENTER_CLICK:
               if(BuriedManager.Instance.checkMoney(this._confirmFrame.isBand,this.payNum))
               {
                  return;
               }
               this.sendVip();
               this.upPayMoneyText();
               break;
         }
         this._confirmFrame.removeEventListener(FrameEvent.RESPONSE,this.__confirm);
         this._confirmFrame.dispose();
         if(Boolean(this._confirmFrame.parent))
         {
            this._confirmFrame.parent.removeChild(this._confirmFrame);
         }
      }
      
      protected function sendVip() : void
      {
         this.days = 0;
         switch(this._openVipTimeBtnGroup.selectIndex)
         {
            case 2:
               this.days = 30;
               break;
            case 1:
               this.days = 30 * 3;
               break;
            case 0:
               this.days = 30 * 6;
         }
         this.send();
      }
      
      protected function send() : void
      {
         VipController.instance.sendOpenVip(PlayerManager.Instance.Self.NickName,this.days,this._confirmFrame.isBand);
      }
      
      protected function upPayMoneyText() : void
      {
         this.payNum = 0;
         this.time = "";
         this.payNum = PlayerManager.Instance.vipPriceArr[2 - this._openVipTimeBtnGroup.selectIndex];
         switch(this._openVipTimeBtnGroup.selectIndex)
         {
            case 2:
               this.time = "1 Ay";
               this._vipPrivilegeTxt.AlertContent = 1;
               break;
            case 1:
               this.time = "3 Ay";
               this._vipPrivilegeTxt.AlertContent = 4;
               break;
            case 0:
               this.time = "6 Ay";
               this._vipPrivilegeTxt.AlertContent = 6;
         }
      }
      
      private function _getStrArr(dic:DictionaryData) : Array
      {
         return dic[_vipChestsArr[PlayerManager.Instance.Self.VIPLevel - 1]];
      }
      
      private function getVIPInfoTip(dic:DictionaryData) : Array
      {
         var resultGoodsArray:Array = null;
         return PlayerManager.Instance.Self.VIPLevel == 12 ? [ItemManager.Instance.getTemplateById(int(_vipChestsArr[PlayerManager.Instance.Self.VIPLevel - 2])),ItemManager.Instance.getTemplateById(int(_vipChestsArr[PlayerManager.Instance.Self.VIPLevel - 1]))] : [ItemManager.Instance.getTemplateById(int(_vipChestsArr[PlayerManager.Instance.Self.VIPLevel - 1])),ItemManager.Instance.getTemplateById(int(_vipChestsArr[PlayerManager.Instance.Self.VIPLevel]))];
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         ObjectUtils.disposeObject(this._halfYearBtn);
         this._halfYearBtn = null;
         ObjectUtils.disposeObject(this._threeMonthBtn);
         this._threeMonthBtn = null;
         ObjectUtils.disposeObject(this._oneMonthBtn);
         this._oneMonthBtn = null;
         ObjectUtils.disposeObject(this._halfYearTxt);
         this._halfYearTxt = null;
         ObjectUtils.disposeObject(this._threeMonthTxt);
         this._threeMonthTxt = null;
         ObjectUtils.disposeObject(this._oneMonthTxt);
         this._oneMonthTxt = null;
         ObjectUtils.disposeObject(this._vipPrivilegeTxt);
         this._vipPrivilegeTxt = null;
         ObjectUtils.disposeObject(this._vipPrivilegeTxtBg);
         this._vipPrivilegeTxtBg = null;
         ObjectUtils.disposeObject(this._selectedBtnImage);
         this._selectedBtnImage = null;
         if(Boolean(this._rewardEffet))
         {
            this._rewardEffet.dispose();
         }
         this._rewardEffet = null;
         if(Boolean(this._openVipBtn))
         {
            ObjectUtils.disposeObject(this._openVipBtn);
         }
         this._openVipBtn = null;
         if(Boolean(this._BG))
         {
            ObjectUtils.disposeObject(this._BG);
         }
         this._BG = null;
         if(Boolean(this._money))
         {
            ObjectUtils.disposeObject(this._money);
         }
         this._money = null;
         if(Boolean(this._showPayMoneyBG))
         {
            ObjectUtils.disposeObject(this._showPayMoneyBG);
         }
         this._showPayMoneyBG = null;
         if(Boolean(this._confirmFrame))
         {
            this._confirmFrame.dispose();
         }
         this._confirmFrame = null;
         if(Boolean(this._moneyConfirm))
         {
            this._moneyConfirm.dispose();
         }
         this._moneyConfirm = null;
         if(Boolean(this._renewalVipBtn))
         {
            ObjectUtils.disposeObject(this._renewalVipBtn);
         }
         this._renewalVipBtn = null;
         if(Boolean(this._rewardBtn))
         {
            ObjectUtils.disposeObject(this._rewardBtn);
         }
         this._rewardBtn = null;
         if(Boolean(this.alertFrame))
         {
            this.alertFrame.dispose();
         }
         this.alertFrame = null;
         if(Boolean(this._rewardShin))
         {
            TweenMax.killTweensOf(this._rewardShin);
         }
         if(Boolean(this._rewardShin))
         {
            ObjectUtils.disposeObject(this._rewardShin);
         }
         this._rewardShin = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

