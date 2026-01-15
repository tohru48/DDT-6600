package wonderfulActivity.items
{
   import activeEvents.data.ActiveEventsInfo;
   import baglocked.BaglockedManager;
   import calendar.CalendarEvent;
   import calendar.CalendarManager;
   import calendar.view.ActivityDetail;
   import calendar.view.goodsExchange.GoodsExchangeView;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.LoaderEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import wonderfulActivity.WonderfulActivityManager;
   import wonderfulActivity.views.IRightView;
   
   public class LimitActivityView extends Sprite implements IRightView
   {
      
      public static const PICC_PRICE:int = 10000;
      
      private var _container:Sprite;
      
      private var _back:DisplayObject;
      
      private var _scrollList:ScrollPanel;
      
      private var _content:VBox;
      
      private var _detail:ActivityDetail;
      
      private var _goodsExchange:GoodsExchangeView;
      
      private var _titleField:FilterFrameText;
      
      private var _buttonBack:DisplayObject;
      
      private var _getButton:BaseButton;
      
      private var _exchangeButton:BaseButton;
      
      private var _piccBtn:BaseButton;
      
      private var _activityInfo:ActiveEventsInfo;
      
      private var tagId:int;
      
      public function LimitActivityView(id:int)
      {
         super();
         this.tagId = id;
      }
      
      public function init() : void
      {
         this.configUI();
         this.addEvent();
         this.setData();
      }
      
      private function configUI() : void
      {
         this._container = new Sprite();
         PositionUtils.setPos(this._container,"wonderful.limitActivity.ContentPos");
         this._back = ComponentFactory.Instance.creatComponentByStylename("ddtcalendar.ActivityStateBg");
         this._container.addChild(this._back);
         this._titleField = ComponentFactory.Instance.creatComponentByStylename("ddtcalendar.ActivityStateTitleField");
         this._container.addChild(this._titleField);
         this._detail = ComponentFactory.Instance.creatCustomObject("ddtcalendar.ActivityDetail");
         this._buttonBack = ComponentFactory.Instance.creatComponentByStylename("ddtcalendar.ActivityState.GetButtonBackBg");
         this._container.addChild(this._buttonBack);
         this._getButton = ComponentFactory.Instance.creatComponentByStylename("ddtcalendar.ActivityState.GetButton");
         this._getButton.visible = false;
         this._container.addChild(this._getButton);
         this._exchangeButton = ComponentFactory.Instance.creatComponentByStylename("ddtcalendar.ActivityState.exchangeButton");
         this._exchangeButton.visible = false;
         this._container.addChild(this._exchangeButton);
         this._piccBtn = ComponentFactory.Instance.creatComponentByStylename("ddtcalendar.ActivityState.PiccBtn");
         this._container.addChild(this._piccBtn);
         this._content = ComponentFactory.Instance.creatComponentByStylename("ddtcalendar.ActivityState.Vbox");
         this._content.addChild(this._detail);
         this._scrollList = ComponentFactory.Instance.creatComponentByStylename("ddtcalendar.ActivityDetailList");
         this._scrollList.setView(this._content);
         this._container.addChild(this._scrollList);
         this._goodsExchange = new GoodsExchangeView();
         PositionUtils.setPos(this._goodsExchange,"ddtcalendarGrid.GoodsExchangeView.GoodsExchangeViewPos");
         this._content.addChild(this._goodsExchange);
         addChild(this._container);
      }
      
      private function addEvent() : void
      {
         this._getButton.addEventListener(MouseEvent.CLICK,this.__getAward);
         this._exchangeButton.addEventListener(MouseEvent.CLICK,this.__exchange);
         this._piccBtn.addEventListener(MouseEvent.CLICK,this.__piccHandler);
         this._goodsExchange.addEventListener(CalendarEvent.ExchangeGoodsChange,this.__ExchangeGoodsChangeHandler);
      }
      
      protected function __piccHandler(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         var alert:BaseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("ActivityState.confirm.content",PICC_PRICE),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,false,false,LayerManager.ALPHA_BLOCKGOUND);
         alert.moveEnable = false;
         alert.addEventListener(FrameEvent.RESPONSE,this.__responseHandler);
      }
      
      protected function __responseHandler(event:FrameEvent) : void
      {
         var alert2:BaseAlerFrame = null;
         var alert:BaseAlerFrame = event.currentTarget as BaseAlerFrame;
         alert.removeEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         if(event.responseCode == FrameEvent.ENTER_CLICK || event.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            if(PlayerManager.Instance.Self.Money >= PICC_PRICE)
            {
               SocketManager.Instance.out.sendPicc(this._activityInfo.ActiveID,PICC_PRICE);
            }
            else
            {
               alert2 = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("poorNote"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,false,false,LayerManager.BLCAK_BLOCKGOUND);
               alert2.moveEnable = false;
               alert2.addEventListener(FrameEvent.RESPONSE,this.__poorManResponse);
            }
         }
         ObjectUtils.disposeObject(alert);
      }
      
      private function __poorManResponse(event:FrameEvent) : void
      {
         var alert:BaseAlerFrame = event.currentTarget as BaseAlerFrame;
         alert.removeEventListener(FrameEvent.RESPONSE,this.__poorManResponse);
         if(event.responseCode == FrameEvent.ENTER_CLICK || event.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            LeavePageManager.leaveToFillPath();
         }
         ObjectUtils.disposeObject(alert);
      }
      
      private function __back(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         CalendarManager.getInstance().closeActivity();
      }
      
      private function __getAward(event:MouseEvent) : void
      {
         var loader:BaseLoader = null;
         var alert:BaseAlerFrame = null;
         SoundManager.instance.play("008");
         if(this._activityInfo.ActiveType == ActiveEventsInfo.COMMON)
         {
            if(this._detail.getInputField().text == "" && this._activityInfo.HasKey == 1)
            {
               alert = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("tank.movement.MovementRightView.pass"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),true,false,false,2);
               alert.info.showCancel = false;
               return;
            }
            loader = CalendarManager.getInstance().reciveActivityAward(this._activityInfo,this._detail.getInputField().text);
            loader.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
            loader.addEventListener(LoaderEvent.COMPLETE,this.__activityLoadComplete);
            this._detail.getInputField().text = "";
            if(this._activityInfo.HasKey == 1)
            {
               this._getButton.enable = true;
            }
            else
            {
               this._getButton.enable = !this._activityInfo.isAttend;
            }
         }
         else if(this._activityInfo.ActiveType == ActiveEventsInfo.SENIOR_PLAYER)
         {
            SocketManager.Instance.out.sendActivePullDown(this._activityInfo.ActiveID,this._detail.getInputField().text);
         }
      }
      
      private function __exchange(event:MouseEvent) : void
      {
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         SoundManager.instance.playButtonSound();
         this._goodsExchange.sendGoods();
      }
      
      private function __activityLoadComplete(event:LoaderEvent) : void
      {
         var loader:BaseLoader = event.currentTarget as BaseLoader;
         loader.removeEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         loader.removeEventListener(LoaderEvent.COMPLETE,this.__activityLoadComplete);
         if(this._activityInfo.HasKey == 1)
         {
            this._getButton.enable = true;
         }
         else
         {
            this._getButton.enable = !this._activityInfo.isAttend;
         }
      }
      
      private function __onLoadError(event:LoaderEvent) : void
      {
         var loader:BaseLoader = event.currentTarget as BaseLoader;
         loader.removeEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         loader.removeEventListener(LoaderEvent.COMPLETE,this.__activityLoadComplete);
         this._getButton.enable = !this._activityInfo.isAttend;
      }
      
      public function setData() : void
      {
         this._activityInfo = WonderfulActivityManager.Instance.getActiveEventsInfoByID(this.tagId);
         if(Boolean(this._activityInfo))
         {
            this._piccBtn.visible = false;
            this._titleField.text = this._activityInfo.Title;
            if(this._activityInfo.ActiveType == ActiveEventsInfo.GOODS_EXCHANGE)
            {
               this.hideDetailView();
               this.showGoodsExchangeView();
            }
            else
            {
               this.hideGoodsExchangeView();
               this.showDetailView();
               if(this._activityInfo.HasKey == 1 || this._activityInfo.HasKey == 2 || this._activityInfo.HasKey == 3 || this._activityInfo.HasKey == 6 || this._activityInfo.HasKey == 7)
               {
                  this._getButton.visible = true;
                  if(this._activityInfo.HasKey == 1)
                  {
                     this._getButton.enable = true;
                  }
                  else
                  {
                     this._getButton.enable = !this._activityInfo.isAttend;
                  }
               }
               else
               {
                  this._getButton.visible = false;
               }
               if(this._activityInfo.ActiveType == ActiveEventsInfo.COMMON || this._activityInfo.ActiveType == ActiveEventsInfo.PICC)
               {
                  if(this._activityInfo.ActiveType == ActiveEventsInfo.PICC)
                  {
                     this._getButton.visible = false;
                     this._piccBtn.visible = true;
                  }
               }
            }
         }
         else
         {
            this._piccBtn.visible = false;
            this._getButton.visible = false;
         }
         this._scrollList.invalidateViewport();
      }
      
      private function showGoodsExchangeView() : void
      {
         if(!this._goodsExchange)
         {
            this._goodsExchange = new GoodsExchangeView();
            this._goodsExchange.addEventListener(CalendarEvent.ExchangeGoodsChange,this.__ExchangeGoodsChangeHandler);
            this._goodsExchange.setData(this._activityInfo);
            this._exchangeButton.visible = true;
            this._content.addChild(this._goodsExchange);
         }
         else
         {
            this._goodsExchange.setData(this._activityInfo);
            this._exchangeButton.visible = true;
         }
      }
      
      private function hideGoodsExchangeView() : void
      {
         if(Boolean(this._goodsExchange))
         {
            this._exchangeButton.visible = false;
            this._goodsExchange.removeEventListener(CalendarEvent.ExchangeGoodsChange,this.__ExchangeGoodsChangeHandler);
            ObjectUtils.disposeObject(this._goodsExchange);
            this._goodsExchange = null;
         }
      }
      
      private function __ExchangeGoodsChangeHandler(event:CalendarEvent) : void
      {
         if(event.enable == false)
         {
            this._exchangeButton.enable = false;
         }
         else
         {
            this._exchangeButton.enable = true;
         }
      }
      
      private function showDetailView() : void
      {
         if(!this._detail)
         {
            this._detail = new ActivityDetail();
            this._detail.setData(this._activityInfo);
            this._getButton.visible = true;
            this._content.addChild(this._detail);
            this._content.height = this._detail.height;
         }
         else
         {
            this._detail.setData(this._activityInfo);
            this._getButton.visible = true;
            this._content.height = this._detail.height;
         }
      }
      
      private function hideDetailView() : void
      {
         if(Boolean(this._detail))
         {
            this._getButton.visible = false;
            ObjectUtils.disposeObject(this._detail);
            this._detail = null;
         }
      }
      
      private function removeEvent() : void
      {
         this._getButton.removeEventListener(MouseEvent.CLICK,this.__getAward);
         this._exchangeButton.removeEventListener(MouseEvent.CLICK,this.__exchange);
         this._piccBtn.removeEventListener(MouseEvent.CLICK,this.__piccHandler);
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         ObjectUtils.disposeObject(this._back);
         this._back = null;
         ObjectUtils.disposeObject(this._piccBtn);
         this._piccBtn = null;
         ObjectUtils.disposeObject(this._titleField);
         this._titleField = null;
         ObjectUtils.disposeObject(this._buttonBack);
         this._buttonBack = null;
         ObjectUtils.disposeObject(this._getButton);
         this._getButton = null;
         ObjectUtils.disposeObject(this._exchangeButton);
         this._exchangeButton = null;
         ObjectUtils.disposeObject(this._detail);
         this._detail = null;
         ObjectUtils.disposeObject(this._scrollList);
         this._scrollList = null;
         ObjectUtils.disposeObject(this._container);
         this._container = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
         if(Boolean(this._goodsExchange))
         {
            ObjectUtils.disposeObject(this._goodsExchange);
            this._goodsExchange = null;
         }
      }
      
      public function content() : Sprite
      {
         return this;
      }
      
      public function setState(type:int, id:int) : void
      {
      }
   }
}

