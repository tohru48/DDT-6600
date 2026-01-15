package dayActivity.view
{
   import com.greensock.TweenLite;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.controls.Frame;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import hallIcon.HallIconManager;
   
   public class DdtImportantFrame extends Frame
   {
      
      private var _view:DdtImportantView;
      
      public function DdtImportantFrame()
      {
         super();
         titleText = LanguageMgr.GetTranslation("AlertDialog.ddtImportant");
         this._view = new DdtImportantView();
         addToContent(this._view);
         PositionUtils.setPos(this._view,"day.ddtImportantAdv.viewPos");
         addEventListener(FrameEvent.RESPONSE,this.__responseHandler);
      }
      
      protected function __responseHandler(event:FrameEvent) : void
      {
         if(event.responseCode == FrameEvent.CLOSE_CLICK || event.responseCode == FrameEvent.ESC_CLICK)
         {
            SoundManager.instance.play("008");
            if(HallIconManager.instance.model.firstRechargeIsOpen)
            {
               TweenLite.to(this,0.5,{
                  "x":900,
                  "y":307,
                  "scaleX":0.1,
                  "scaleY":0.1,
                  "onComplete":this.delayCompleteHandler
               });
            }
            else
            {
               TweenLite.to(this,0.5,{
                  "x":900,
                  "y":235,
                  "scaleX":0.1,
                  "scaleY":0.1,
                  "onComplete":this.delayCompleteHandler
               });
            }
         }
      }
      
      private function delayCompleteHandler() : void
      {
         this.dispose();
      }
      
      override public function dispose() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         super.dispose();
         this._view = null;
      }
   }
}

