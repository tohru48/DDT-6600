package times
{
   import com.greensock.TweenLite;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import times.updateView.TimesUpdateView;
   
   public class TimesUpdateFrame extends Frame
   {
      
      private var _bg:ScaleBitmapImage;
      
      private var _view:TimesUpdateView;
      
      public function TimesUpdateFrame()
      {
         super();
         titleText = LanguageMgr.GetTranslation("AlertDialog.updateGongGao");
         this._bg = ComponentFactory.Instance.creatComponentByStylename("timesUpdate.frameBg");
         addToContent(this._bg);
         this._view = new TimesUpdateView(TimesManager.Instance.updateContentList);
         PositionUtils.setPos(this._view,"timesUpdate.frame.viewPos");
         addToContent(this._view);
         addEventListener(FrameEvent.RESPONSE,this.__responseHandler);
      }
      
      private function __responseHandler(evt:FrameEvent) : void
      {
         if(evt.responseCode == FrameEvent.CLOSE_CLICK || evt.responseCode == FrameEvent.ESC_CLICK)
         {
            SoundManager.instance.play("008");
            this.delayDispose();
         }
      }
      
      private function delayDispose() : void
      {
         TweenLite.to(this,0.5,{
            "x":900,
            "y":265,
            "scaleX":0.1,
            "scaleY":0.1,
            "onComplete":this.delayCompleteHandler
         });
      }
      
      private function delayCompleteHandler() : void
      {
         this.dispose();
      }
      
      override public function dispose() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         super.dispose();
         this._bg = null;
         this._view = null;
      }
   }
}

