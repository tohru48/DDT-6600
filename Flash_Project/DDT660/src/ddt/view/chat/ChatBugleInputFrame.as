package ddt.view.chat
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.vo.AlertInfo;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.FilterWordManager;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.utils.setTimeout;
   import road7th.utils.StringHelper;
   
   public class ChatBugleInputFrame extends BaseAlerFrame
   {
      
      private var _bg:ScaleBitmapImage;
      
      private var _textBg:Scale9CornerImage;
      
      private var _textTitle:FilterFrameText;
      
      protected var _remainTxt:FilterFrameText;
      
      protected var _inputTxt:FilterFrameText;
      
      protected var _remainStr:String;
      
      public var templateID:int;
      
      public function ChatBugleInputFrame()
      {
         super();
      }
      
      override protected function init() : void
      {
         super.init();
         var alertInfo:AlertInfo = new AlertInfo(LanguageMgr.GetTranslation("chat.BugleInputFrameTitleString"));
         alertInfo.moveEnable = false;
         alertInfo.submitLabel = LanguageMgr.GetTranslation("chat.BugleInputFrame.ok.text");
         alertInfo.customPos = ComponentFactory.Instance.creatCustomObject("chat.BugleInputFrame.ok.textPos");
         info = alertInfo;
         this._bg = ComponentFactory.Instance.creatComponentByStylename("chat.BugleInputFrameBg");
         this._textBg = ComponentFactory.Instance.creatComponentByStylename("chat.BugleInputFrameTextBg");
         this._textTitle = ComponentFactory.Instance.creatComponentByStylename("chat.BugleInputTitleBitmap.text");
         this._textTitle.text = LanguageMgr.GetTranslation("chat.BugleInputFrameBg.text");
         this._remainTxt = ComponentFactory.Instance.creatComponentByStylename("chat.BugleInputFrameRemainText");
         this._inputTxt = ComponentFactory.Instance.creatComponentByStylename("chat.BugleInputFrameInputText");
         this._remainStr = LanguageMgr.GetTranslation("chat.BugleInputFrameRemainString");
         this._remainTxt.text = this._remainStr + this._inputTxt.maxChars.toString();
         addToContent(this._bg);
         addToContent(this._textBg);
         addToContent(this._textTitle);
         addToContent(this._remainTxt);
         addToContent(this._inputTxt);
         addEventListener(Event.ADDED_TO_STAGE,this.__setFocus);
      }
      
      private function initEvents() : void
      {
         _submitButton.addEventListener(MouseEvent.CLICK,__onSubmitClick);
         this._inputTxt.addEventListener(Event.CHANGE,this.__upDateRemainTxt);
         addEventListener(FrameEvent.RESPONSE,this.__onResponse);
      }
      
      private function __setFocus(e:Event) : void
      {
         setTimeout(this._inputTxt.setFocus,100);
         this.initEvents();
      }
      
      protected function __onResponse(e:FrameEvent) : void
      {
         var str:String = null;
         var reg:RegExp = null;
         switch(e.responseCode)
         {
            case FrameEvent.SUBMIT_CLICK:
               SoundManager.instance.play("008");
               if(StringHelper.trim(this._inputTxt.text).length <= 0)
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("chat.BugleInputNull"));
                  return;
               }
               str = FilterWordManager.filterWrod(this._inputTxt.text);
               reg = /\r/gm;
               str = str.replace(reg,"");
               SocketManager.Instance.out.sendBBugle(str,this.templateID);
               this._inputTxt.text = "";
               this._remainTxt.text = this._remainStr + this._inputTxt.maxChars.toString();
               if(Boolean(parent))
               {
                  parent.removeChild(this);
               }
               break;
            case FrameEvent.ESC_CLICK:
            case FrameEvent.CLOSE_CLICK:
               SoundManager.instance.play("008");
               this._inputTxt.text = "";
               this._remainTxt.text = this._remainStr + this._inputTxt.maxChars.toString();
               if(Boolean(parent))
               {
                  parent.removeChild(this);
               }
         }
      }
      
      private function __upDateRemainTxt(e:Event) : void
      {
         this._remainTxt.text = this._remainStr + String(this._inputTxt.maxChars - this._inputTxt.text.length);
      }
      
      override public function dispose() : void
      {
         removeEventListener(Event.ADDED_TO_STAGE,this.__setFocus);
         _submitButton.removeEventListener(MouseEvent.CLICK,__onSubmitClick);
         this._inputTxt.removeEventListener(Event.CHANGE,this.__upDateRemainTxt);
         removeEventListener(FrameEvent.RESPONSE,this.__onResponse);
         if(Boolean(this._bg))
         {
            ObjectUtils.disposeObject(this._bg);
         }
         this._bg = null;
         if(Boolean(this._textBg))
         {
            ObjectUtils.disposeObject(this._textBg);
         }
         this._textBg = null;
         if(Boolean(this._textTitle))
         {
            ObjectUtils.disposeObject(this._textTitle);
         }
         this._textTitle = null;
         if(Boolean(this._remainTxt))
         {
            ObjectUtils.disposeObject(this._remainTxt);
         }
         this._remainTxt = null;
         if(Boolean(this._inputTxt))
         {
            ObjectUtils.disposeObject(this._inputTxt);
         }
         this._inputTxt = null;
         super.dispose();
      }
   }
}

