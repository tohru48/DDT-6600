package baglocked.phone4399
{
   import baglocked.BagLockedController;
   import baglocked.BaglockedManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.controls.TextInput;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class ConfirmNum4399Frame extends Frame
   {
      
      private var _bagLockedController:BagLockedController;
      
      private var _description:FilterFrameText;
      
      private var _numInput:TextInput;
      
      private var _countDownTxt:FilterFrameText;
      
      private var _remainTxt:FilterFrameText;
      
      private var _confirmBtn:TextButton;
      
      private var remain:int;
      
      private var _timer:Timer;
      
      public function ConfirmNum4399Frame()
      {
         super();
      }
      
      override protected function init() : void
      {
         super.init();
         this.titleText = LanguageMgr.GetTranslation("tank.view.bagII.baglocked.resetQuestion");
         this._description = ComponentFactory.Instance.creatComponentByStylename("baglocked.whiteTxt");
         this._description.text = LanguageMgr.GetTranslation("tank.view.bagII.baglocked.inputIn60s");
         PositionUtils.setPos(this._description,"bagLocked.inputIn60sPos");
         addToContent(this._description);
         this._numInput = ComponentFactory.Instance.creatComponentByStylename("baglocked.phoneTextInput");
         this._numInput.textField.restrict = "0-9";
         this._numInput.maxChars = 4;
         addToContent(this._numInput);
         this._countDownTxt = ComponentFactory.Instance.creatComponentByStylename("baglocked.whiteTxt");
         this._countDownTxt.text = LanguageMgr.GetTranslation("tank.view.bagII.baglocked.countDown");
         PositionUtils.setPos(this._countDownTxt,"bagLocked.countDownPos");
         addToContent(this._countDownTxt);
         this._remainTxt = ComponentFactory.Instance.creatComponentByStylename("baglocked.deepRedTxt");
         PositionUtils.setPos(this._remainTxt,"bagLocked.remainTxtPos");
         addToContent(this._remainTxt);
         this._confirmBtn = ComponentFactory.Instance.creatComponentByStylename("core.simplebt");
         this._confirmBtn.text = LanguageMgr.GetTranslation("tank.view.bagII.baglocked.confirm");
         PositionUtils.setPos(this._confirmBtn,"bagLocked.nextBtnPos2");
         addToContent(this._confirmBtn);
         this.remain = 60;
         this._remainTxt.text = this.remain + " " + LanguageMgr.GetTranslation("tank.timebox.second");
         this._timer = new Timer(1000,60);
         this._timer.addEventListener(TimerEvent.TIMER,this.onTimer);
         this._timer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onTimerComplete);
         this._timer.start();
         this.addEvent();
      }
      
      private function onTimer(event:TimerEvent) : void
      {
         --this.remain;
         this._remainTxt.text = this.remain + " " + LanguageMgr.GetTranslation("tank.timebox.second");
      }
      
      protected function onTimerComplete(event:TimerEvent) : void
      {
         this._timer.removeEventListener(TimerEvent.TIMER,this.onTimer);
         this._timer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.onTimerComplete);
         this._timer = null;
         this._confirmBtn.enable = false;
      }
      
      protected function __confirmBtnClick(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(this._numInput.text.length != 4)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.bagII.baglocked.msnLengthWrong"));
            return;
         }
         BaglockedManager.Instance.requestConfirm(2,this._numInput.text);
      }
      
      private function __frameEventHandler(event:FrameEvent) : void
      {
         switch(event.responseCode)
         {
            case FrameEvent.ESC_CLICK:
            case FrameEvent.CLOSE_CLICK:
               SoundManager.instance.play("008");
               this._bagLockedController.close();
         }
      }
      
      public function set bagLockedController(value:BagLockedController) : void
      {
         this._bagLockedController = value;
      }
      
      public function show() : void
      {
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      private function addEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__frameEventHandler);
         this._confirmBtn.addEventListener(MouseEvent.CLICK,this.__confirmBtnClick);
      }
      
      private function removeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__frameEventHandler);
         this._confirmBtn.removeEventListener(MouseEvent.CLICK,this.__confirmBtnClick);
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         if(Boolean(this._timer))
         {
            this._timer.removeEventListener(TimerEvent.TIMER,this.onTimer);
            this._timer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.onTimerComplete);
            this._timer = null;
         }
         ObjectUtils.disposeObject(this._description);
         this._description = null;
         ObjectUtils.disposeObject(this._numInput);
         this._numInput = null;
         ObjectUtils.disposeObject(this._countDownTxt);
         this._countDownTxt = null;
         ObjectUtils.disposeObject(this._remainTxt);
         this._remainTxt = null;
         ObjectUtils.disposeObject(this._confirmBtn);
         this._confirmBtn = null;
         super.dispose();
      }
   }
}

