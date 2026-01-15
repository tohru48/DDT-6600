package DDPlay
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class DDPlayExchangeFrame extends Frame
   {
      
      private var _bg:ScaleBitmapImage;
      
      private var _exchangeBtn:SimpleBitmapButton;
      
      private var _chooseNum:DDPlayExchangeNumberSekecter;
      
      private var _exchangeNum:Bitmap;
      
      private var _currentScore:FilterFrameText;
      
      private var _currentScoreBg:Bitmap;
      
      private var _currentScore2:FilterFrameText;
      
      private var _score:int;
      
      private var _fold:int;
      
      public function DDPlayExchangeFrame()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         escEnable = true;
         this._fold = DDPlayManaer.Instance.exchangeFold;
         this.titleText = LanguageMgr.GetTranslation("tank.ddPlay.exchangeFrame.title");
         this._bg = ComponentFactory.Instance.creatComponentByStylename("DDPlay.exchange.frame.background");
         this._exchangeBtn = ComponentFactory.Instance.creatComponentByStylename("DDPlay.exchange.frame.frameBtn");
         this._chooseNum = ComponentFactory.Instance.creatComponentByStylename("DDPlay.exchange.frame.NumberSelecter");
         this._exchangeNum = ComponentFactory.Instance.creatBitmap("DDPlay.exchange.exchangeNumber");
         this._currentScoreBg = ComponentFactory.Instance.creatBitmap("DDPlay.exchange.currentScoreBg");
         this._currentScore = ComponentFactory.Instance.creatComponentByStylename("DDPlay.exchange.frame.currentScoreTxt");
         this._currentScore.text = LanguageMgr.GetTranslation("tank.ddPlay.exchangeFrame.currentScore");
         this._currentScore2 = ComponentFactory.Instance.creatComponentByStylename("DDPlay.exchange.frame.currentScoreTxt2");
         this._score = DDPlayManaer.Instance.DDPlayScore;
         this._currentScore2.text = this._score.toString();
         this._chooseNum.valueLimit = 0 + "," + Math.floor(this._score / this._fold);
         this._chooseNum.currentValue = Math.floor(this._score / this._fold);
         addToContent(this._bg);
         addToContent(this._exchangeBtn);
         addToContent(this._chooseNum);
         addToContent(this._exchangeNum);
         addToContent(this._currentScoreBg);
         addToContent(this._currentScore);
         addToContent(this._currentScore2);
      }
      
      private function initEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         this._exchangeBtn.addEventListener(MouseEvent.CLICK,this.__exchange);
         DDPlayManaer.Instance.addEventListener(DDPlayManaer.UPDATE_SCORE,this.__updateScore);
         this._chooseNum.addEventListener(Event.CHANGE,this.__numberChange);
      }
      
      private function removeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         if(Boolean(this._exchangeBtn))
         {
            this._exchangeBtn.removeEventListener(MouseEvent.CLICK,this.__exchange);
            this._chooseNum.removeEventListener(Event.CHANGE,this.__numberChange);
         }
         DDPlayManaer.Instance.removeEventListener(DDPlayManaer.UPDATE_SCORE,this.__updateScore);
      }
      
      private function __numberChange(e:Event) : void
      {
         SoundManager.instance.play("008");
      }
      
      private function __updateScore(e:Event) : void
      {
         this._score = DDPlayManaer.Instance.DDPlayScore;
         this._currentScore2.text = this._score.toString();
         this._chooseNum.valueLimit = 0 + "," + Math.floor(this._score / this._fold);
         this._chooseNum.currentValue = Math.floor(this._score / this._fold);
      }
      
      private function __exchange(e:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(this._chooseNum.currentValue * this._fold > this._score || this._chooseNum.currentValue == 0)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.ddPlay.exchangeFrame.scoreNotEnough"));
            return;
         }
         SocketManager.Instance.out.DDPlayExchange(this._chooseNum.currentValue);
      }
      
      private function __responseHandler(e:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         if(e.responseCode == FrameEvent.CLOSE_CLICK || e.responseCode == FrameEvent.ESC_CLICK)
         {
            this.dispose();
         }
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         ObjectUtils.disposeObject(this._bg);
         this._bg = null;
         ObjectUtils.disposeObject(this._exchangeBtn);
         this._exchangeBtn = null;
         ObjectUtils.disposeObject(this._chooseNum);
         this._chooseNum = null;
         ObjectUtils.disposeObject(this._exchangeNum);
         this._exchangeNum = null;
         ObjectUtils.disposeObject(this._currentScore);
         this._currentScore = null;
         ObjectUtils.disposeObject(this._currentScoreBg);
         this._currentScoreBg = null;
         ObjectUtils.disposeObject(this._currentScore2);
         this._currentScore2 = null;
         super.dispose();
      }
   }
}

