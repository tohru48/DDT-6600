package ringStation.view
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SoundManager;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class HelpView extends Frame
   {
      
      private var _view:Sprite;
      
      private var _bg:Scale9CornerImage;
      
      private var _submitButton:TextButton;
      
      private var _helpInfo:FilterFrameText;
      
      public function HelpView()
      {
         super();
         this.initView();
         this.addEvent();
      }
      
      private function initView() : void
      {
         this._view = new Sprite();
         titleText = LanguageMgr.GetTranslation("ddt.ringstation.helpTitle");
         this._bg = ComponentFactory.Instance.creatComponentByStylename("ringStation.helpView.frameBg");
         this._view.addChild(this._bg);
         this._helpInfo = ComponentFactory.Instance.creatComponentByStylename("ringStation.helpView.infoText");
         this._helpInfo.text = LanguageMgr.GetTranslation("ddt.ringstation.helpInfo");
         this._view.addChild(this._helpInfo);
         this._submitButton = ComponentFactory.Instance.creat("ringStation.helpView.sumitBtn");
         this._submitButton.text = LanguageMgr.GetTranslation("ok");
         this._view.addChild(this._submitButton);
         addToContent(this._view);
         enterEnable = true;
         escEnable = true;
      }
      
      private function addEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this._response);
         this._submitButton.addEventListener(MouseEvent.CLICK,this.__submit);
      }
      
      private function __submit(e:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this.close();
      }
      
      private function _response(e:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         if(e.responseCode == FrameEvent.CLOSE_CLICK || e.responseCode == FrameEvent.ESC_CLICK || e.responseCode == FrameEvent.ENTER_CLICK)
         {
            this.close();
         }
      }
      
      private function close() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this._response);
         this._submitButton.removeEventListener(MouseEvent.CLICK,this.__submit);
         ObjectUtils.disposeObject(this._view);
         ObjectUtils.disposeObject(this);
      }
      
      override public function dispose() : void
      {
         super.dispose();
         removeEventListener(FrameEvent.RESPONSE,this._response);
         if(Boolean(this._submitButton))
         {
            this._submitButton.removeEventListener(MouseEvent.CLICK,this.__submit);
            ObjectUtils.disposeObject(this._submitButton);
         }
         this._submitButton = null;
         if(Boolean(this._bg))
         {
            this._bg.dispose();
            this._bg = null;
         }
         if(Boolean(this._view))
         {
            ObjectUtils.disposeObject(this._view);
            this._view = null;
         }
         if(Boolean(this._helpInfo))
         {
            ObjectUtils.disposeObject(this._helpInfo);
            this._helpInfo = null;
         }
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

