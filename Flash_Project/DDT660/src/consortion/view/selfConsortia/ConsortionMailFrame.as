package consortion.view.selfConsortia
{
   import baglocked.BaglockedManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.controls.TextInput;
   import com.pickgliss.ui.image.MovieImage;
   import com.pickgliss.ui.image.MutipleImage;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.text.TextArea;
   import consortion.ConsortionModelControl;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.FilterWordManager;
   import flash.display.Bitmap;
   import flash.events.MouseEvent;
   import flash.events.TextEvent;
   
   public class ConsortionMailFrame extends Frame
   {
      
      public static const MAIL_PAY:int = 1000;
      
      private var _topWord:MutipleImage;
      
      private var _explain:Bitmap;
      
      private var _send:TextButton;
      
      private var _close:TextButton;
      
      private var _recevier:FilterFrameText;
      
      private var _topic:TextInput;
      
      private var _content:TextArea;
      
      private var _bg:ScaleBitmapImage;
      
      private var _addresseeText:FilterFrameText;
      
      private var _subjectText:FilterFrameText;
      
      private var _addresseeInputText:FilterFrameText;
      
      private var _subjectInputText:FilterFrameText;
      
      private var _textAreaBG:MovieImage;
      
      private var _line:MutipleImage;
      
      private var _contentBG:MutipleImage;
      
      private var _explainText:FilterFrameText;
      
      private var _explainText1:FilterFrameText;
      
      private var _explainText2:FilterFrameText;
      
      public function ConsortionMailFrame()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         escEnable = true;
         disposeChildren = true;
         titleText = LanguageMgr.GetTranslation("ddt.consortion.mailFrame.title");
         this._bg = ComponentFactory.Instance.creatComponentByStylename("consortion.consortionMailFrame.bg");
         this._topWord = ComponentFactory.Instance.creatComponentByStylename("consortion.consortionMailFrame.titleBG");
         this._addresseeText = ComponentFactory.Instance.creatComponentByStylename("consortion.consortionMailFrame.addresseeText");
         this._addresseeText.text = LanguageMgr.GetTranslation("consortion.consortionMailFrame.addresseeText");
         this._subjectText = ComponentFactory.Instance.creatComponentByStylename("consortion.consortionMailFrame.subjectText");
         this._subjectText.text = LanguageMgr.GetTranslation("consortion.consortionMailFrame.subjectText");
         this._textAreaBG = ComponentFactory.Instance.creatComponentByStylename("consortion.mail.bg");
         this._line = ComponentFactory.Instance.creatComponentByStylename("consortion.mail.line");
         this._contentBG = ComponentFactory.Instance.creatComponentByStylename("consortion.mailFrame.contentBG");
         this._send = ComponentFactory.Instance.creatComponentByStylename("consortion.mailFrame.send");
         this._close = ComponentFactory.Instance.creatComponentByStylename("consortion.mailFrame.close");
         this._recevier = ComponentFactory.Instance.creatComponentByStylename("consortion.mailFrame.recevier");
         this._topic = ComponentFactory.Instance.creatComponentByStylename("consortion.mailFrame.title");
         this._content = ComponentFactory.Instance.creatComponentByStylename("consortion.mailFrame.content");
         this._content.textField.maxChars = 200;
         this._explainText = ComponentFactory.Instance.creatComponentByStylename("consortion.consortionMailFrame.explainText");
         this._explainText.text = LanguageMgr.GetTranslation("consortion.consortionMailFrame.explainText");
         this._explainText1 = ComponentFactory.Instance.creatComponentByStylename("consortion.consortionMailFrame.explainText1");
         this._explainText1.text = LanguageMgr.GetTranslation("consortion.consortionMailFrame.explainText1");
         this._explainText2 = ComponentFactory.Instance.creatComponentByStylename("consortion.consortionMailFrame.explainText3");
         this._explainText2.text = LanguageMgr.GetTranslation("consortion.consortionMailFrame.explainText3");
         addToContent(this._bg);
         addToContent(this._topWord);
         addToContent(this._addresseeText);
         addToContent(this._subjectText);
         addToContent(this._textAreaBG);
         addToContent(this._line);
         addToContent(this._contentBG);
         addToContent(this._send);
         addToContent(this._close);
         addToContent(this._recevier);
         addToContent(this._topic);
         addToContent(this._content);
         addToContent(this._explainText);
         addToContent(this._explainText1);
         addToContent(this._explainText2);
         this._send.text = LanguageMgr.GetTranslation("send");
         this._close.text = LanguageMgr.GetTranslation("cancel");
         this._recevier.text = LanguageMgr.GetTranslation("ddt.consortion.mailFrame.all");
         this._topic.textField.maxChars = 16;
      }
      
      private function initEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         this._content.textField.addEventListener(TextEvent.TEXT_INPUT,this._contentInputHandler);
         this._send.addEventListener(MouseEvent.CLICK,this.__sendHandler);
         this._close.addEventListener(MouseEvent.CLICK,this.__closeHandler);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.CONSORTION_MAIL,this.__consortionMailResponse);
      }
      
      private function removeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         this._content.textField.removeEventListener(TextEvent.TEXT_INPUT,this._contentInputHandler);
         this._send.removeEventListener(MouseEvent.CLICK,this.__sendHandler);
         this._close.removeEventListener(MouseEvent.CLICK,this.__closeHandler);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.CONSORTION_MAIL,this.__consortionMailResponse);
      }
      
      private function __consortionMailResponse(event:CrazyTankSocketEvent) : void
      {
         var bool:Boolean = event.pkg.readBoolean();
         if(bool)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.consortion.mailFrame.success"));
            ConsortionModelControl.Instance.getConsortionList(ConsortionModelControl.Instance.selfConsortionComplete,1,6,PlayerManager.Instance.Self.consortiaInfo.ConsortiaName,-1,-1,-1,PlayerManager.Instance.Self.consortiaInfo.ConsortiaID);
            this.dispose();
         }
         else
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.consortion.mailFrame.fail"));
            this._send.enable = true;
         }
      }
      
      private function __responseHandler(event:FrameEvent) : void
      {
         if(event.responseCode == FrameEvent.CLOSE_CLICK || event.responseCode == FrameEvent.ESC_CLICK)
         {
            SoundManager.instance.play("008");
            this.dispose();
         }
      }
      
      private function _contentInputHandler(event:TextEvent) : void
      {
         if(this._content.text.length > 300)
         {
            event.preventDefault();
         }
      }
      
      private function __sendHandler(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         if(PlayerManager.Instance.Self.consortiaInfo.Riches < MAIL_PAY)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.consortion.mailFrame.noEnagth"));
            return;
         }
         if(FilterWordManager.IsNullorEmpty(this._topic.text))
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.emailII.WritingView.topic"));
            return;
         }
         if(this._content.text.length > 300)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.emailII.WritingView.contentLength"));
            return;
         }
         var topic:String = FilterWordManager.filterWrod(this._topic.text);
         var content:String = FilterWordManager.filterWrod(this._content.text);
         SocketManager.Instance.out.sendConsortionMail(topic,content);
         this._send.enable = false;
      }
      
      private function __closeHandler(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this.dispose();
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         super.dispose();
         this._bg = null;
         this._topWord = null;
         this._addresseeText = null;
         this._subjectText = null;
         this._textAreaBG = null;
         this._line = null;
         this._contentBG = null;
         this._send = null;
         this._close = null;
         this._recevier = null;
         this._topic = null;
         this._content = null;
         this._explainText = null;
         this._explainText1 = null;
         this._explainText2 = null;
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
   }
}

