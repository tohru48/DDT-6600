package wonderfulActivity.newActivity.ExchangeAct
{
   import baglocked.BaglockedManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import wonderfulActivity.WonderfulActivityManager;
   import wonderfulActivity.data.GmActivityInfo;
   import wonderfulActivity.data.SendGiftInfo;
   import wonderfulActivity.views.IRightView;
   
   public class ExchangeActView extends Sprite implements IRightView
   {
      
      private var _back:DisplayObject;
      
      private var _titleField:FilterFrameText;
      
      private var _buttonBack:DisplayObject;
      
      private var _exchangeButton:BaseButton;
      
      private var _container:Sprite;
      
      private var _actId:String;
      
      private var _activityInfo:GmActivityInfo;
      
      private var _goodsExchange:ExchangeGoodsView;
      
      public function ExchangeActView(id:String)
      {
         super();
         this._actId = id;
      }
      
      public function init() : void
      {
         this.initView();
         this.addEvent();
         this.initData();
         this.initViewWithData();
      }
      
      private function initView() : void
      {
         this._container = new Sprite();
         PositionUtils.setPos(this._container,"wonderful.limitActivity.ContentPos");
         this._back = ComponentFactory.Instance.creatComponentByStylename("ddtcalendar.ActivityStateBg");
         this._container.addChild(this._back);
         this._titleField = ComponentFactory.Instance.creatComponentByStylename("ddtcalendar.ActivityStateTitleField");
         this._container.addChild(this._titleField);
         this._buttonBack = ComponentFactory.Instance.creatComponentByStylename("ddtcalendar.ActivityState.GetButtonBackBg");
         this._container.addChild(this._buttonBack);
         this._exchangeButton = ComponentFactory.Instance.creatComponentByStylename("ddtcalendar.ActivityState.exchangeButton");
         this._container.addChild(this._exchangeButton);
         this._goodsExchange = new ExchangeGoodsView();
         PositionUtils.setPos(this._goodsExchange,"wonderful.exchangeGoodsView");
         this._container.addChild(this._goodsExchange);
         addChild(this._container);
      }
      
      private function initData() : void
      {
         this._activityInfo = WonderfulActivityManager.Instance.activityData[this._actId];
      }
      
      private function initViewWithData() : void
      {
         if(!this._activityInfo)
         {
            return;
         }
         this._titleField.text = this._activityInfo.activityName;
         this._goodsExchange.setData(this._activityInfo);
      }
      
      public function setState(type:int, id:int) : void
      {
      }
      
      public function content() : Sprite
      {
         return this;
      }
      
      private function addEvent() : void
      {
         this._exchangeButton.addEventListener(MouseEvent.CLICK,this.__exchange);
         this._goodsExchange.addEventListener(ExchangeGoodsEvent.ExchangeGoodsChange,this.__ExchangeGoodsChangeHandler);
      }
      
      private function __ExchangeGoodsChangeHandler(event:ExchangeGoodsEvent) : void
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
      
      private function __exchange(event:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         var sendInfoVec:Vector.<SendGiftInfo> = new Vector.<SendGiftInfo>();
         var sendInfo:SendGiftInfo = new SendGiftInfo();
         sendInfo.activityId = this._activityInfo.activityId;
         var giftIdArr:Array = new Array();
         for(var i:int = 0; i < this._goodsExchange.count; i++)
         {
            giftIdArr.push(this._activityInfo.giftbagArray[this._goodsExchange.selectedIndex].giftbagId);
         }
         sendInfo.giftIdArr = giftIdArr;
         sendInfoVec.push(sendInfo);
         SocketManager.Instance.out.sendWonderfulActivityGetReward(sendInfoVec);
      }
      
      private function removeEvent() : void
      {
         this._exchangeButton.removeEventListener(MouseEvent.CLICK,this.__exchange);
         this._goodsExchange.removeEventListener(ExchangeGoodsEvent.ExchangeGoodsChange,this.__ExchangeGoodsChangeHandler);
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         if(Boolean(this._back))
         {
            ObjectUtils.disposeObject(this._back);
         }
         this._back = null;
         if(Boolean(this._titleField))
         {
            ObjectUtils.disposeObject(this._titleField);
         }
         this._titleField = null;
         if(Boolean(this._buttonBack))
         {
            ObjectUtils.disposeObject(this._buttonBack);
         }
         this._buttonBack = null;
         if(Boolean(this._exchangeButton))
         {
            ObjectUtils.disposeObject(this._exchangeButton);
         }
         this._exchangeButton = null;
      }
   }
}

