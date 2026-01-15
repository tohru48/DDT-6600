package beadSystem.views
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.TextInput;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.vo.AlertInfo;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.manager.LanguageMgr;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.ui.Keyboard;
   
   public class BeadFeedInfoFrame extends BaseAlerFrame
   {
      
      private var _showInfo:FilterFrameText;
      
      private var _prompt:FilterFrameText;
      
      private var _yes:FilterFrameText;
      
      private var _inputBg:Scale9CornerImage;
      
      private var _textInput:TextInput;
      
      public var isBind:Boolean;
      
      public var itemInfo:InventoryItemInfo;
      
      private var _beadName:String;
      
      public function BeadFeedInfoFrame()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         info = new AlertInfo(LanguageMgr.GetTranslation("AlertDialog.Info"));
         this._showInfo = ComponentFactory.Instance.creatComponentByStylename("beadSystem.feedBeadShowInfoOneFeed");
         addToContent(this._showInfo);
         this._prompt = ComponentFactory.Instance.creatComponentByStylename("beadSystem.feedBeadShowTipOneFeed");
         this._prompt.htmlText = LanguageMgr.GetTranslation("ddt.beadSystem.feedBeadAlertTip");
         addToContent(this._prompt);
         this._yes = ComponentFactory.Instance.creatComponentByStylename("beadSystem.feedBeadShowTipYES");
         this._yes.htmlText = LanguageMgr.GetTranslation("ddt.beadSystem.feedBeadAlertTipYES");
         addToContent(this._yes);
         this._inputBg = ComponentFactory.Instance.creatComponentByStylename("beadSystem.feedBeadInputBg");
         addToContent(this._inputBg);
         this._textInput = ComponentFactory.Instance.creatComponentByStylename("beadSystem.textinput");
         addToContent(this._textInput);
      }
      
      public function setBeadName(name:String) : void
      {
         this._showInfo.htmlText = LanguageMgr.GetTranslation("ddt.beadSystem.feedBeadAlertInfo","[" + name + "]");
      }
      
      private function initEvent() : void
      {
         this._textInput.addEventListener(KeyboardEvent.KEY_DOWN,this.__onTextInputKeyDown);
      }
      
      private function removeEvent() : void
      {
         this._textInput.removeEventListener(KeyboardEvent.KEY_DOWN,this.__onTextInputKeyDown);
      }
      
      private function __onTextInputKeyDown(event:KeyboardEvent) : void
      {
         if(event.keyCode == Keyboard.ENTER)
         {
            dispatchEvent(new FrameEvent(FrameEvent.SUBMIT_CLICK));
            event.stopPropagation();
         }
      }
      
      private function __confirmhandler(event:MouseEvent) : void
      {
         dispatchEvent(new FrameEvent(FrameEvent.SUBMIT_CLICK));
      }
      
      private function __cancelHandler(event:MouseEvent) : void
      {
         dispatchEvent(new FrameEvent(FrameEvent.CANCEL_CLICK));
      }
      
      override public function dispose() : void
      {
         super.dispose();
         this.removeEvent();
         if(Boolean(this._showInfo))
         {
            this._showInfo.dispose();
            this._showInfo = null;
         }
         if(Boolean(this._prompt))
         {
            this._prompt.dispose();
            this._prompt = null;
         }
         if(Boolean(this._yes))
         {
            this._yes.dispose();
            this._yes = null;
         }
         if(Boolean(this._inputBg))
         {
            this._inputBg.dispose();
            this._inputBg = null;
         }
         if(Boolean(this._textInput))
         {
            this._textInput.dispose();
            this._textInput = null;
         }
      }
      
      public function get textInput() : TextInput
      {
         return this._textInput;
      }
   }
}

