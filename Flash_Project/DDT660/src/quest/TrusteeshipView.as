package quest
{
   import baglocked.BaglockedManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.Image;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.command.QuickUseFrame;
   import ddt.command.StripTip;
   import ddt.data.EquipType;
   import ddt.data.quest.QuestInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.TimeManager;
   import ddtBuried.BuriedManager;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import kingBless.KingBlessManager;
   
   public class TrusteeshipView extends Sprite implements Disposeable
   {
      
      private var _spiritImage:Bitmap;
      
      private var _spiritValueTxtBg:Image;
      
      private var _speedUpBg:Bitmap;
      
      private var _spiritValueTxt:FilterFrameText;
      
      private var _speedUpTipTxt:FilterFrameText;
      
      private var _speedUpTimeTxt:FilterFrameText;
      
      private var _speedUpBtn:SimpleBitmapButton;
      
      private var _startCancelBtn:TextButton;
      
      private var _buyBtn:SimpleBitmapButton;
      
      private var _buyBtnStrip:StripTip;
      
      private var _timer:Timer;
      
      private var _count:int;
      
      private var _questInfo:QuestInfo;
      
      private var _callback:Function;
      
      private var _questBtn:BaseButton;
      
      private var _confirmFrame:BaseAlerFrame;
      
      public function TrusteeshipView()
      {
         super();
         this._timer = new Timer(1000);
         this._timer.addEventListener(TimerEvent.TIMER,this.timerHandler,false,0,true);
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         this._spiritImage = ComponentFactory.Instance.creatBitmap("asset.trusteeship.spiritImage");
         this._spiritValueTxtBg = ComponentFactory.Instance.creatComponentByStylename("trusteeship.spiritTxtBg");
         this._spiritValueTxtBg.tipData = LanguageMgr.GetTranslation("ddt.trusteeship.maxSpiritTipTxt",TrusteeshipManager.instance.maxSpiritValue);
         this._speedUpBg = ComponentFactory.Instance.creatBitmap("asset.trusteeship.speedUpBg");
         this._spiritValueTxt = ComponentFactory.Instance.creatComponentByStylename("trusteeship.spiritValueTxt");
         this.refreshSpiritTxt();
         this._speedUpTipTxt = ComponentFactory.Instance.creatComponentByStylename("trusteeship.speedUpTipTxt");
         this._speedUpTipTxt.text = LanguageMgr.GetTranslation("ddt.trusteeship.speedUpTipTxt");
         this._speedUpTimeTxt = ComponentFactory.Instance.creatComponentByStylename("trusteeship.speedUpTimeTxt");
         this._speedUpBtn = ComponentFactory.Instance.creatComponentByStylename("trusteeship.speedUpBtn");
         this._startCancelBtn = ComponentFactory.Instance.creatComponentByStylename("trusteeship.startCancelBtn");
         this._startCancelBtn.text = LanguageMgr.GetTranslation("ddt.trusteeship.startTxt");
         this._buyBtn = ComponentFactory.Instance.creatComponentByStylename("trusteeship.buyBtn");
         this._buyBtn.tipData = LanguageMgr.GetTranslation("ddt.trusteeship.buySpiritBtnTipTxt");
         this._buyBtnStrip = ComponentFactory.Instance.creatCustomObject("trusteeship.buyBtnStrip");
         this._buyBtnStrip.tipData = LanguageMgr.GetTranslation("ddt.trusteeship.buySpiritBtnTipTxt");
         this.refreshBuyBtn(null);
         addChild(this._spiritImage);
         addChild(this._spiritValueTxtBg);
         addChild(this._speedUpBg);
         addChild(this._spiritValueTxt);
         addChild(this._speedUpTipTxt);
         addChild(this._speedUpTimeTxt);
         addChild(this._speedUpBtn);
         addChild(this._startCancelBtn);
         addChild(this._buyBtn);
         addChild(this._buyBtnStrip);
      }
      
      private function refreshBuyBtn(event:Event) : void
      {
         this._buyBtn.enable = true;
         this._buyBtnStrip.visible = false;
      }
      
      private function refreshSpiritTxt() : void
      {
         this._spiritValueTxt.text = TrusteeshipManager.instance.spiritValue.toString();
      }
      
      private function initEvent() : void
      {
         this._startCancelBtn.addEventListener(MouseEvent.CLICK,this.startCancelHandler,false,0,true);
         this._speedUpBtn.addEventListener(MouseEvent.CLICK,this.speedUpHandler,false,0,true);
         this._buyBtn.addEventListener(MouseEvent.CLICK,this.buyHandler);
         TrusteeshipManager.instance.addEventListener(TrusteeshipManager.UPDATE_ALL_DATA,this.updateAllDataHandler);
         TrusteeshipManager.instance.addEventListener(TrusteeshipManager.UPDATE_SPIRIT_VALUE,this.updateSpiritValueHandler);
         KingBlessManager.instance.addEventListener(KingBlessManager.UPDATE_MAIN_EVENT,this.refreshBuyBtn);
      }
      
      private function updateAllDataHandler(event:Event) : void
      {
         if(!this.visible)
         {
            return;
         }
         this.refreshSpiritTxt();
         this.refreshView(this._questInfo,this._callback,this._questBtn);
      }
      
      private function updateSpiritValueHandler(event:Event) : void
      {
         if(!this.visible)
         {
            return;
         }
         this.refreshSpiritTxt();
      }
      
      private function startCancelHandler(event:MouseEvent) : void
      {
         var msg:String = null;
         var cost:int = 0;
         var quick:QuickUseFrame = null;
         var needNum:int = 0;
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         if(this._speedUpBtn.visible)
         {
            msg = LanguageMgr.GetTranslation("ddt.trusteeship.cancelTipTxt");
         }
         else
         {
            if(!TrusteeshipManager.instance.isCanStart())
            {
               if(TrusteeshipManager.instance.isHasTrusteeshipQuestUnaviable())
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.trusteeship.refreshTrusteeshipStateTxt"));
               }
               else
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.trusteeship.cannotStartTipTxt"));
               }
               return;
            }
            cost = this._questInfo.TrusteeshipCost;
            if(TrusteeshipManager.instance.spiritValue < cost)
            {
               quick = ComponentFactory.Instance.creat("ddtcore.QuickUseFrame");
               needNum = (100 - TrusteeshipManager.instance.spiritValue) / 20;
               quick.setItemInfo(EquipType.ENERGY_SOLUTION,cost,1,needNum);
               return;
            }
            msg = LanguageMgr.GetTranslation("ddt.trusteeship.startTipTxt",this._questInfo.TrusteeshipNeedTime,cost);
         }
         this._confirmFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),msg,LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),true,true,true,LayerManager.BLCAK_BLOCKGOUND);
         this._confirmFrame.moveEnable = false;
         this._confirmFrame.addEventListener(FrameEvent.RESPONSE,this.__confirmStartCancel);
      }
      
      private function __confirmStartCancel(evt:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         this._confirmFrame.removeEventListener(FrameEvent.RESPONSE,this.__confirmStartCancel);
         this._confirmFrame = null;
         if(evt.responseCode == FrameEvent.SUBMIT_CLICK || evt.responseCode == FrameEvent.ENTER_CLICK)
         {
            if(this._speedUpBtn.visible)
            {
               SocketManager.Instance.out.sendTrusteeshipCancel(this._questInfo.id);
            }
            else
            {
               SocketManager.Instance.out.sendTrusteeshipStart(this._questInfo.id);
            }
         }
      }
      
      private function speedUpHandler(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         var minute:int = this._count / (TimeManager.Minute_TICKS / 1000);
         var second:int = this._count % (TimeManager.Minute_TICKS / 1000);
         var needTime:int = minute + (second > 0 ? 1 : 0);
         var needMoney:int = needTime * TrusteeshipManager.instance.speedUpOneMinNeedMoney;
         if(KingBlessManager.instance.openType > 0)
         {
            needMoney = 0;
            SocketManager.Instance.out.sendTrusteeshipSpeedUp(this._questInfo.id,false);
            return;
         }
         var msg:String = LanguageMgr.GetTranslation("ddt.trusteeship.speedUpCostTipTxt",needMoney);
         this._confirmFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),msg,LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),true,true,true,LayerManager.BLCAK_BLOCKGOUND,null,"SimpleAlert",30,true);
         this._confirmFrame.moveEnable = false;
         this._confirmFrame.addEventListener(FrameEvent.RESPONSE,this.__confirmSpeedUp);
      }
      
      private function __confirmSpeedUp(evt:FrameEvent) : void
      {
         var minute:int = 0;
         var second:int = 0;
         var needTime:int = 0;
         var needMoney:int = 0;
         SoundManager.instance.play("008");
         if(evt.responseCode == FrameEvent.SUBMIT_CLICK || evt.responseCode == FrameEvent.ENTER_CLICK)
         {
            minute = this._count / (TimeManager.Minute_TICKS / 1000);
            second = this._count % (TimeManager.Minute_TICKS / 1000);
            needTime = minute + (second > 0 ? 1 : 0);
            needMoney = needTime * TrusteeshipManager.instance.speedUpOneMinNeedMoney;
            if(BuriedManager.Instance.checkMoney(evt.currentTarget.isBand,needMoney))
            {
               return;
            }
            SocketManager.Instance.out.sendTrusteeshipSpeedUp(this._questInfo.id,this._confirmFrame.isBand);
            this._confirmFrame.removeEventListener(FrameEvent.RESPONSE,this.__confirmSpeedUp);
            this._confirmFrame = null;
         }
      }
      
      private function buyHandler(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         if(TrusteeshipManager.instance.spiritValue >= TrusteeshipManager.instance.maxSpiritValue)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.trusteeship.maxSpiritCannotBuyTxt"));
            return;
         }
         var msg:String = LanguageMgr.GetTranslation("ddt.trusteeship.buySpiritCostTipTxt",TrusteeshipManager.instance.buyOnceNeedMoney,TrusteeshipManager.instance.buyOnceSpiritValue);
         this._confirmFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),msg,LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),true,true,true,LayerManager.BLCAK_BLOCKGOUND,null,"SimpleAlert",30,true);
         this._confirmFrame.moveEnable = false;
         this._confirmFrame.addEventListener(FrameEvent.RESPONSE,this.__confirmBuySpirit);
      }
      
      private function __confirmBuySpirit(evt:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         if(evt.responseCode == FrameEvent.SUBMIT_CLICK || evt.responseCode == FrameEvent.ENTER_CLICK)
         {
            if(BuriedManager.Instance.checkMoney(this._confirmFrame.isBand,TrusteeshipManager.instance.buyOnceNeedMoney))
            {
               return;
            }
            SocketManager.Instance.out.sendTrusteeshipBuySpirit(this._confirmFrame.isBand);
         }
         this._confirmFrame.removeEventListener(FrameEvent.RESPONSE,this.__confirmBuySpirit);
         this._confirmFrame.dispose();
         this._confirmFrame = null;
      }
      
      public function refreshView(questInfo:QuestInfo, callback:Function, questBtn:BaseButton) : void
      {
         var endTimestamp:Number = NaN;
         var nowTimestamp:Number = NaN;
         this._questInfo = questInfo;
         this._callback = callback;
         this._questBtn = questBtn;
         if(this._questInfo.isCompleted)
         {
            this.taskCompleteState();
            return;
         }
         var vo:TrusteeshipDataVo = TrusteeshipManager.instance.getTrusteeshipInfo(this._questInfo.id);
         if(!vo)
         {
            this._questBtn.visible = true;
            this._speedUpBg.visible = false;
            this._speedUpTipTxt.visible = false;
            this._speedUpTimeTxt.visible = false;
            this._speedUpBtn.visible = false;
            this._startCancelBtn.visible = true;
            this._startCancelBtn.text = LanguageMgr.GetTranslation("ddt.trusteeship.startTxt");
            this._timer.stop();
         }
         else
         {
            this._questBtn.visible = false;
            this._speedUpBg.visible = true;
            this._speedUpTipTxt.visible = true;
            this._speedUpTimeTxt.visible = true;
            this._speedUpBtn.visible = true;
            this._startCancelBtn.visible = true;
            this._startCancelBtn.text = LanguageMgr.GetTranslation("ddt.trusteeship.cancelTxt");
            endTimestamp = vo.endTime.getTime();
            nowTimestamp = TimeManager.Instance.Now().getTime();
            this._count = int((endTimestamp - nowTimestamp) / 1000);
            if(this._count > 0)
            {
               this._speedUpTimeTxt.text = this.getTimeStr(this._count);
               this._timer.reset();
               this._timer.start();
            }
            else
            {
               this.taskCompleteState();
            }
         }
      }
      
      public function clearSome() : void
      {
         this._questInfo = null;
         this._callback = null;
         this._questBtn = null;
         this._timer.stop();
      }
      
      private function taskCompleteState() : void
      {
         this._timer.stop();
         this._speedUpBg.visible = false;
         this._speedUpTipTxt.visible = false;
         this._speedUpTimeTxt.visible = false;
         this._speedUpBtn.visible = false;
         this._startCancelBtn.visible = false;
         if(this._callback != null)
         {
            this._callback(true);
         }
         this._callback = null;
      }
      
      private function timerHandler(event:TimerEvent) : void
      {
         --this._count;
         if(this._count <= 0)
         {
            this.taskCompleteState();
         }
         else
         {
            this._speedUpTimeTxt.text = this.getTimeStr(this._count);
         }
      }
      
      private function getTimeStr(count:int) : String
      {
         var hour:int = count / (TimeManager.HOUR_TICKS / 1000);
         var hourRest:int = count % (TimeManager.HOUR_TICKS / 1000);
         var minute:int = hourRest / (TimeManager.Minute_TICKS / 1000);
         var second:int = hourRest % (TimeManager.Minute_TICKS / 1000);
         return LanguageMgr.GetTranslation("ddt.trusteeship.speedUpTimeTxt",this.getTimeStrOO(hour),this.getTimeStrOO(minute),this.getTimeStrOO(second));
      }
      
      private function getTimeStrOO(value:int) : String
      {
         if(value == 0)
         {
            return "00";
         }
         if(value < 10)
         {
            return "0" + value;
         }
         return value.toString();
      }
      
      private function removeEvent() : void
      {
         if(Boolean(this._startCancelBtn))
         {
            this._startCancelBtn.removeEventListener(MouseEvent.CLICK,this.startCancelHandler);
         }
         if(Boolean(this._speedUpBtn))
         {
            this._speedUpBtn.removeEventListener(MouseEvent.CLICK,this.speedUpHandler);
         }
         if(Boolean(this._buyBtn))
         {
            this._buyBtn.removeEventListener(MouseEvent.CLICK,this.buyHandler);
         }
         TrusteeshipManager.instance.removeEventListener(TrusteeshipManager.UPDATE_ALL_DATA,this.updateAllDataHandler);
         TrusteeshipManager.instance.removeEventListener(TrusteeshipManager.UPDATE_SPIRIT_VALUE,this.updateSpiritValueHandler);
         KingBlessManager.instance.removeEventListener(KingBlessManager.UPDATE_MAIN_EVENT,this.refreshBuyBtn);
      }
      
      public function dispose() : void
      {
         if(Boolean(this._timer))
         {
            this._timer.stop();
            this._timer.removeEventListener(TimerEvent.TIMER,this.timerHandler);
         }
         this._timer = null;
         this._questInfo = null;
         this._callback = null;
         this._questBtn = null;
         this.removeEvent();
         ObjectUtils.disposeAllChildren(this);
         this._spiritImage = null;
         this._spiritValueTxtBg = null;
         this._speedUpBg = null;
         this._spiritValueTxt = null;
         this._speedUpTipTxt = null;
         this._speedUpTimeTxt = null;
         this._speedUpBtn = null;
         this._startCancelBtn = null;
         this._buyBtn = null;
         this._buyBtnStrip = null;
         if(Boolean(this._confirmFrame))
         {
            this._confirmFrame.removeEventListener(FrameEvent.RESPONSE,this.__confirmBuySpirit);
            this._confirmFrame.removeEventListener(FrameEvent.RESPONSE,this.__confirmSpeedUp);
            this._confirmFrame.removeEventListener(FrameEvent.RESPONSE,this.__confirmStartCancel);
            ObjectUtils.disposeObject(this._confirmFrame);
         }
         this._confirmFrame = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

