package zodiac
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.events.Event;
   
   public class ZodiacFrame extends Frame
   {
      
      private var _bg:ScaleBitmapImage;
      
      private var _mainView:ZodiacMainView;
      
      private var _rollingView:ZodiacRollingView;
      
      public function ZodiacFrame()
      {
         super();
         escEnable = true;
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         titleText = LanguageMgr.GetTranslation("zodiac.mainframe.title");
         this._bg = ComponentFactory.Instance.creatComponentByStylename("zodiac.zodiacMainFrame.bg");
         addToContent(this._bg);
         this._mainView = new ZodiacMainView();
         PositionUtils.setPos(this._mainView,"zodiac.mainview.mainview.pos");
         addToContent(this._mainView);
         this._rollingView = new ZodiacRollingView();
         PositionUtils.setPos(this._rollingView,"zodiac.rollingview.rollingview.pos");
         addToContent(this._rollingView);
         this._mainView.setViewIndex(ZodiacManager.instance.getCurrentIndex());
      }
      
      private function initEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__response);
      }
      
      private function removeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__response);
      }
      
      private function __response(e:FrameEvent) : void
      {
         if(e.responseCode == FrameEvent.CLOSE_CLICK || e.responseCode == FrameEvent.ESC_CLICK)
         {
            SoundManager.instance.play("008");
            if(ZodiacManager.instance.inRolling)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("zodiac.mainview.inrolling"));
               return;
            }
            dispatchEvent(new Event(Event.CLOSE));
            ZodiacManager.instance.frameDispose();
         }
      }
      
      public function get mainView() : ZodiacMainView
      {
         return this._mainView;
      }
      
      public function get rollingView() : ZodiacRollingView
      {
         return this._rollingView;
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         ObjectUtils.removeChildAllChildren(this);
         super.dispose();
      }
   }
}

