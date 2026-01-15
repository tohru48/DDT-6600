package oldPlayerRegress.view.itemView
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SoundManager;
   
   public class WelFrameView extends Frame
   {
      
      private var _frameBg:Scale9CornerImage;
      
      private var _frameInfo:FilterFrameText;
      
      public function WelFrameView()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         titleText = LanguageMgr.GetTranslation("ddt.regress.welView.Privilege");
         this._frameBg = ComponentFactory.Instance.creatComponentByStylename("regress.privilege.FrameBg");
         this._frameInfo = ComponentFactory.Instance.creatComponentByStylename("regress.privilege.frameInfo");
         this._frameInfo.text = LanguageMgr.GetTranslation("ddt.regress.welview.PrivilegeFrameInfo");
         addToContent(this._frameBg);
         addToContent(this._frameInfo);
      }
      
      private function initEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__frameEventHandler);
      }
      
      private function __frameEventHandler(event:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         switch(event.responseCode)
         {
            case FrameEvent.ESC_CLICK:
            case FrameEvent.CLOSE_CLICK:
               this.dispose();
         }
      }
      
      private function removeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__frameEventHandler);
      }
      
      override public function dispose() : void
      {
         super.dispose();
         this.removeEvent();
         if(Boolean(this._frameBg))
         {
            this._frameBg.dispose();
            this._frameBg = null;
         }
      }
   }
}

