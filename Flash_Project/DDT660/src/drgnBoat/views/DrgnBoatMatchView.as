package drgnBoat.views
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.text.FilterFrameText;
   import ddt.manager.InviteManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import drgnBoat.DrgnBoatManager;
   import flash.display.Bitmap;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class DrgnBoatMatchView extends Frame
   {
      
      private var _bg:Bitmap;
      
      private var _carImg:Bitmap;
      
      private var _typeTextIcon:Bitmap;
      
      private var _tipTxtIcon:Bitmap;
      
      private var _leftTxt:FilterFrameText;
      
      private var _rightTxt:FilterFrameText;
      
      private var _timeTxt:FilterFrameText;
      
      private var _cancelBtn:SimpleBitmapButton;
      
      private var _countDown:int = 9;
      
      private var _timer:Timer;
      
      private var _isDispose:Boolean = false;
      
      public function DrgnBoatMatchView()
      {
         super();
         this.initView();
         this.initEvent();
         this._timer = new Timer(1000);
         this._timer.addEventListener(TimerEvent.TIMER,this.timerHandler,false,0,true);
         this._timer.start();
         InviteManager.Instance.enabled = false;
      }
      
      private function initView() : void
      {
         titleText = LanguageMgr.GetTranslation("drgnBoat.match.title");
         this._bg = ComponentFactory.Instance.creatBitmap("drgnBoat.matchView.bg");
         this._typeTextIcon = ComponentFactory.Instance.creatBitmap("drgnBoat.matchView.txtIcon");
         this._tipTxtIcon = ComponentFactory.Instance.creatBitmap("drgnBoat.matchView.tipTxtIcon");
         this._carImg = ComponentFactory.Instance.creatBitmap("drgnBoat.matchView.car" + DrgnBoatManager.instance.carStatus);
         this._leftTxt = ComponentFactory.Instance.creatComponentByStylename("drgnBoat.race.matchViewTipTxt");
         this._leftTxt.text = LanguageMgr.GetTranslation("escort.frame.matchViewTipTxt");
         this._rightTxt = ComponentFactory.Instance.creatComponentByStylename("drgnBoat.race.matchView.rightTxt");
         this._rightTxt.text = LanguageMgr.GetTranslation("drgnBoat.match.description");
         this._timeTxt = ComponentFactory.Instance.creatComponentByStylename("drgnBoat.race.matchView.timeTxt");
         this._timeTxt.text = "0" + this._countDown;
         this._cancelBtn = ComponentFactory.Instance.creatComponentByStylename("drgnBoat.matchView.cancelBtn");
         addToContent(this._bg);
         addToContent(this._typeTextIcon);
         addToContent(this._tipTxtIcon);
         addToContent(this._carImg);
         addToContent(this._leftTxt);
         addToContent(this._rightTxt);
         addToContent(this._timeTxt);
         addToContent(this._cancelBtn);
      }
      
      private function initEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.cancelMatchHandler);
         this._cancelBtn.addEventListener(MouseEvent.CLICK,this.onCancel,false,0,true);
         DrgnBoatManager.instance.addEventListener(DrgnBoatManager.CANCEL_GAME,this.cancelGameHandler);
      }
      
      private function cancelMatchHandler(event:FrameEvent) : void
      {
         if(event.responseCode == FrameEvent.ESC_CLICK || event.responseCode == FrameEvent.CANCEL_CLICK || event.responseCode == FrameEvent.CLOSE_CLICK)
         {
            SoundManager.instance.play("008");
            SocketManager.Instance.out.sendEscortCancelGame();
         }
      }
      
      private function cancelGameHandler(event:Event) : void
      {
         this.dispose();
      }
      
      private function onCancel(event:MouseEvent) : void
      {
         dispatchEvent(new FrameEvent(FrameEvent.CANCEL_CLICK));
      }
      
      private function timerHandler(event:TimerEvent) : void
      {
         --this._countDown;
         if(this._countDown < 0)
         {
            this._countDown = 9;
         }
         this._timeTxt.text = "0" + this._countDown;
      }
      
      private function removeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.cancelMatchHandler);
         this._cancelBtn.removeEventListener(MouseEvent.CLICK,this.onCancel);
         DrgnBoatManager.instance.removeEventListener(DrgnBoatManager.CANCEL_GAME,this.cancelGameHandler);
      }
      
      override public function dispose() : void
      {
         if(this._isDispose)
         {
            return;
         }
         this.removeEvent();
         if(Boolean(this._timer))
         {
            this._timer.stop();
            this._timer.removeEventListener(TimerEvent.TIMER,this.timerHandler);
         }
         this._timer = null;
         super.dispose();
         this._bg = null;
         this._carImg = null;
         this._typeTextIcon = null;
         this._tipTxtIcon = null;
         this._leftTxt = null;
         this._rightTxt = null;
         this._timeTxt = null;
         this._cancelBtn = null;
         InviteManager.Instance.enabled = true;
         this._isDispose = true;
      }
   }
}

