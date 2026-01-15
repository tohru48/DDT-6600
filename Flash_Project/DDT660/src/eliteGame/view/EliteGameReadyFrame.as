package eliteGame.view
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SoundManager;
   import eliteGame.EliteGameController;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class EliteGameReadyFrame extends Frame
   {
      
      private var _firstLine:FilterFrameText;
      
      private var _mapNameTitle:FilterFrameText;
      
      private var _mapName:FilterFrameText;
      
      private var _timeTitle:FilterFrameText;
      
      private var _time:FilterFrameText;
      
      private var _readyTip:FilterFrameText;
      
      private var _readyBtn:TextButton;
      
      private var _leftTime:int = 30;
      
      private var _timer:Timer;
      
      public function EliteGameReadyFrame()
      {
         super();
         this.initView();
      }
      
      private function initView() : void
      {
         titleText = LanguageMgr.GetTranslation("eliteGame.readyFrame.title");
         this._firstLine = ComponentFactory.Instance.creatComponentByStylename("ddteliteGame.readyFrame.firstLine");
         this._mapNameTitle = ComponentFactory.Instance.creatComponentByStylename("ddteliteGame.readyFrame.mapNameTitle");
         this._mapName = ComponentFactory.Instance.creatComponentByStylename("ddteliteGame.readyFrame.mapName");
         this._timeTitle = ComponentFactory.Instance.creatComponentByStylename("ddteliteGame.readyFrame.timeTitle");
         this._time = ComponentFactory.Instance.creatComponentByStylename("ddteliteGame.readyFrame.time");
         this._readyTip = ComponentFactory.Instance.creatComponentByStylename("ddteliteGame.readyFrame.readyTip");
         this._readyBtn = ComponentFactory.Instance.creatComponentByStylename("ddteliteGame.readyFrame.readyBtn");
         addToContent(this._firstLine);
         addToContent(this._mapNameTitle);
         addToContent(this._mapName);
         addToContent(this._timeTitle);
         addToContent(this._time);
         addToContent(this._readyTip);
         addToContent(this._readyBtn);
         this._firstLine.text = LanguageMgr.GetTranslation("eliteGame.readyFrame.firstLine");
         this._mapNameTitle.text = LanguageMgr.GetTranslation("FPSView.as.InviteAlertPanel.map");
         this._mapName.text = LanguageMgr.GetTranslation("tank.manager.MapManager.random");
         this._timeTitle.text = LanguageMgr.GetTranslation("FPSView.as.InviteAlertPanel.huihetime");
         this._time.text = "10" + LanguageMgr.GetTranslation("FPSView.as.InviteAlertPanel.second");
         this._readyTip.text = LanguageMgr.GetTranslation("eliteGame.readyFrame.alert",this._leftTime);
         this._readyBtn.text = LanguageMgr.GetTranslation("eliteGame.readyFrame.readyOk");
         this._timer = new Timer(1000);
         this._timer.addEventListener(TimerEvent.TIMER,this.__timerhandler);
         this._timer.start();
         addEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         this._readyBtn.addEventListener(MouseEvent.CLICK,this.__clickHandler);
      }
      
      protected function __timerhandler(event:TimerEvent) : void
      {
         --this._leftTime;
         this._readyTip.text = LanguageMgr.GetTranslation("eliteGame.readyFrame.alert",this._leftTime);
      }
      
      protected function __clickHandler(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         EliteGameController.Instance.joinChampionEliteGame();
         this.dispose();
      }
      
      protected function __responseHandler(event:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         switch(event.responseCode)
         {
            case FrameEvent.ESC_CLICK:
            case FrameEvent.CLOSE_CLICK:
               this.dispose();
         }
      }
      
      override public function dispose() : void
      {
         EliteGameController.Instance.setReadyFrame();
         this._timer.removeEventListener(TimerEvent.TIMER,this.__timerhandler);
         this._timer = null;
         removeEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         this._readyBtn.removeEventListener(MouseEvent.CLICK,this.__clickHandler);
         if(Boolean(this._firstLine))
         {
            ObjectUtils.disposeObject(this._firstLine);
         }
         this._firstLine = null;
         if(Boolean(this._mapNameTitle))
         {
            ObjectUtils.disposeObject(this._mapNameTitle);
         }
         this._mapNameTitle = null;
         if(Boolean(this._mapName))
         {
            ObjectUtils.disposeObject(this._mapName);
         }
         this._mapName = null;
         if(Boolean(this._timeTitle))
         {
            ObjectUtils.disposeObject(this._timeTitle);
         }
         this._timeTitle = null;
         if(Boolean(this._time))
         {
            ObjectUtils.disposeObject(this._time);
         }
         this._time = null;
         if(Boolean(this._readyTip))
         {
            ObjectUtils.disposeObject(this._readyTip);
         }
         this._readyTip = null;
         if(Boolean(this._readyBtn))
         {
            ObjectUtils.disposeObject(this._readyBtn);
         }
         this._readyBtn = null;
         super.dispose();
      }
   }
}

