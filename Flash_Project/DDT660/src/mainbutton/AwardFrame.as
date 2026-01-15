package mainbutton
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.UIModuleLoader;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.image.MutipleImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.UIModuleTypes;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.manager.BossBoxManager;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.DatetimeHelper;
   import ddt.view.UIModuleSmallLoading;
   import ddt.view.bossbox.AwardsView;
   import ddt.view.bossbox.AwardsViewII;
   import ddt.view.bossbox.VipInfoTipBox;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import road7th.data.DictionaryData;
   import vip.VipController;
   import vip.view.VipViewFrame;
   
   public class AwardFrame extends Frame
   {
      
      private var _text:FilterFrameText;
      
      private var _topImgBG:MutipleImage;
      
      private var _vipBtn:BaseButton;
      
      private var _vipInfoTipBox:VipInfoTipBox;
      
      private var awards:AwardsViewII;
      
      private var alertFrame:BaseAlerFrame;
      
      public function AwardFrame()
      {
         super();
         this.initView();
         this.addEvent();
      }
      
      private function initView() : void
      {
         titleText = LanguageMgr.GetTranslation("ddt.getReward");
         this._text = ComponentFactory.Instance.creatComponentByStylename("mainbtn.award.text");
         this._text.htmlText = LanguageMgr.GetTranslation("ddt.Reward.get");
         addToContent(this._text);
         this._topImgBG = ComponentFactory.Instance.creatComponentByStylename("mainbtn.award.topBg");
         addToContent(this._topImgBG);
         this._vipBtn = ComponentFactory.Instance.creatComponentByStylename("mainbtn.award.vipBigButton");
         addToContent(this._vipBtn);
      }
      
      private function addEvent() : void
      {
         this._vipBtn.addEventListener(MouseEvent.CLICK,this.__vipOpen);
         addEventListener(FrameEvent.RESPONSE,this.__confirmResponse);
      }
      
      private function __vipOpen(e:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this.showVipPackage();
      }
      
      private function showVipPackage() : void
      {
         var incream:int = 0;
         var date:Date = null;
         var nowDate:Date = null;
         if(PlayerManager.Instance.Self.canTakeVipReward || PlayerManager.Instance.Self.IsVIP == false)
         {
            if(VipController.loadComplete)
            {
               this._vipInfoTipBox = ComponentFactory.Instance.creat("vip.VipInfoTipFrame");
               this._vipInfoTipBox.escEnable = true;
               this._vipInfoTipBox.vipAwardGoodsList = this.getVIPInfoTip(BossBoxManager.instance.inventoryItemList);
               this._vipInfoTipBox.addEventListener(FrameEvent.RESPONSE,this.__responseVipInfoTipHandler);
               LayerManager.Instance.addToLayer(this._vipInfoTipBox,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
            }
            else if(VipController.useFirst)
            {
               UIModuleSmallLoading.Instance.progress = 0;
               UIModuleSmallLoading.Instance.show();
               UIModuleSmallLoading.Instance.addEventListener(Event.CLOSE,this.__onClose);
               UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__progressShow);
               UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__complainShow);
               UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.VIP_VIEW);
               VipController.useFirst = false;
            }
         }
         else
         {
            incream = 0;
            date = PlayerManager.Instance.Self.systemDate as Date;
            nowDate = new Date();
            nowDate.setTime(nowDate.getTime() + DatetimeHelper.millisecondsPerDay);
            this.alertFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("ddt.vip.vipView.cueDateScript",nowDate.month + 1,nowDate.date),LanguageMgr.GetTranslation("ok"),"",false,false,false,LayerManager.ALPHA_BLOCKGOUND);
            this.alertFrame.moveEnable = false;
            this.alertFrame.addEventListener(FrameEvent.RESPONSE,this.__alertHandler);
         }
      }
      
      private function getVIPInfoTip(dic:DictionaryData) : Array
      {
         var resultGoodsArray:Array = null;
         return PlayerManager.Instance.Self.VIPLevel == 12 ? [ItemManager.Instance.getTemplateById(int(VipViewFrame._vipChestsArr[PlayerManager.Instance.Self.VIPLevel - 2])),ItemManager.Instance.getTemplateById(int(VipViewFrame._vipChestsArr[PlayerManager.Instance.Self.VIPLevel - 1]))] : [ItemManager.Instance.getTemplateById(int(VipViewFrame._vipChestsArr[PlayerManager.Instance.Self.VIPLevel - 1])),ItemManager.Instance.getTemplateById(int(VipViewFrame._vipChestsArr[PlayerManager.Instance.Self.VIPLevel]))];
      }
      
      private function __responseVipInfoTipHandler(event:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         this._vipInfoTipBox.removeEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         switch(event.responseCode)
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
      
      private function __onClose(event:Event) : void
      {
         UIModuleSmallLoading.Instance.hide();
         UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__onClose);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__progressShow);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__complainShow);
      }
      
      private function __progressShow(event:UIModuleEvent) : void
      {
         if(event.module == UIModuleTypes.VIP_VIEW)
         {
            UIModuleSmallLoading.Instance.progress = event.loader.progress * 100;
         }
      }
      
      private function __complainShow(event:UIModuleEvent) : void
      {
         if(event.module == UIModuleTypes.VIP_VIEW)
         {
            UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__onClose);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__progressShow);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__complainShow);
            UIModuleSmallLoading.Instance.hide();
            VipController.loadComplete = true;
            this.showVipPackage();
         }
      }
      
      private function __alertHandler(event:FrameEvent) : void
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
      
      private function __responseHandler(event:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         this.awards.removeEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         switch(event.responseCode)
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
         this.awards.addEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         this.awards.addEventListener(AwardsView.HAVEBTNCLICK,this.__sendReward);
         LayerManager.Instance.addToLayer(this.awards,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      private function _getStrArr(dic:DictionaryData) : Array
      {
         return dic[VipViewFrame._vipChestsArr[PlayerManager.Instance.Self.VIPLevel - 1]];
      }
      
      private function __sendReward(event:Event) : void
      {
         SoundManager.instance.play("008");
         SocketManager.Instance.out.sendDailyAward(3);
         this.awards.removeEventListener(AwardsView.HAVEBTNCLICK,this.__sendReward);
         this.awards.dispose();
         PlayerManager.Instance.Self.canTakeVipReward = false;
      }
      
      private function __confirmResponse(evt:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         removeEventListener(FrameEvent.RESPONSE,this.__confirmResponse);
         switch(evt.responseCode)
         {
            case FrameEvent.CLOSE_CLICK:
               this.dispose();
               break;
            case FrameEvent.ESC_CLICK:
               this.dispose();
         }
      }
      
      override public function dispose() : void
      {
         ObjectUtils.disposeObject(this._text);
         this._text = null;
         if(Boolean(this._topImgBG))
         {
            ObjectUtils.disposeObject(this._topImgBG);
         }
         this._topImgBG = null;
         if(Boolean(this._vipBtn))
         {
            ObjectUtils.disposeObject(this._vipBtn);
         }
         this._vipBtn = null;
         super.dispose();
      }
   }
}

