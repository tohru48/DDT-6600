package socialContact.microcobol
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.LoadResourceManager;
   import com.pickgliss.toplevel.StageReferance;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.text.TextArea;
   import com.pickgliss.ui.vo.AlertInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PathManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.ServerManager;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.net.URLVariables;
   
   public class MicrocobolFrame extends BaseAlerFrame
   {
      
      private var _alertInfo:AlertInfo;
      
      private var _textBg:Bitmap;
      
      private var _inputText:TextArea;
      
      private var _infoText:FilterFrameText;
      
      private const _maxChatNum:int = 140;
      
      private const _addYNum:int = 6;
      
      private var _textOldY:int;
      
      private var _issueBt:BaseButton;
      
      public function MicrocobolFrame()
      {
         super();
         this.initialize();
      }
      
      protected function initialize() : void
      {
         this.setView();
         this.setEvent();
      }
      
      private function setView() : void
      {
         submitButtonStyle = "core.simplebt";
         this._alertInfo = new AlertInfo(LanguageMgr.GetTranslation("tank.view.im.microcobol.tip"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,false);
         this._alertInfo.moveEnable = false;
         info = this._alertInfo;
         this.escEnable = true;
         this._textBg = ComponentFactory.Instance.creatBitmap("microBlog.TextArea");
         addToContent(this._textBg);
         this._inputText = ComponentFactory.Instance.creatComponentByStylename("Microcobol.inputText");
         addToContent(this._inputText);
         this._infoText = ComponentFactory.Instance.creatComponentByStylename("Microcobol.InfoText");
         this._textOldY = this._infoText.y;
         this._inputTextChange();
         addToContent(this._infoText);
         this._issueBt = ComponentFactory.Instance.creatComponentByStylename("MicroBlog.IssueBt");
         addToContent(this._issueBt);
      }
      
      public function show() : void
      {
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.ALPHA_BLOCKGOUND);
         if(Boolean(this._inputText))
         {
            StageReferance.stage.focus = this._inputText.textField;
         }
      }
      
      public function setList(arr:Array) : void
      {
      }
      
      private function _inputTextChange(e:Event = null) : void
      {
         var str:String = "";
         if(this._inputText.text.length > this._maxChatNum)
         {
            this._infoText.setFrame(2);
            str = LanguageMgr.GetTranslation("socialContact.microcobol.infoTextII");
            str = str.replace(/r/g,String(this._inputText.text.length - this._maxChatNum));
         }
         else
         {
            this._infoText.setFrame(2);
            str = LanguageMgr.GetTranslation("socialContact.microcobol.infoTextIII");
            str = str.replace(/r/g,String(this._maxChatNum - this._inputText.text.length));
         }
         this._infoText.htmlText = str;
         this._infoText.y = this._textOldY;
      }
      
      private function _clickIssueBt(e:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(this._inputText.text.length == 0)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("socialContact.microcobol.infoTextI"));
            return;
         }
         if(this._inputText.text.length > this._maxChatNum)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("socialContact.microcobol.infoTextTooLong"));
            return;
         }
         var uv:URLVariables = new URLVariables();
         uv.serverId = ServerManager.Instance.AgentID;
         uv.fuid = PlayerManager.Instance.Account.Account;
         uv.inviteCaption = this._inputText.text;
         uv.ran = Math.random();
         uv.screenshot = "";
         var load:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.getMicrocobolPath(),BaseLoader.REQUEST_LOADER,uv);
         LoadResourceManager.Instance.startLoad(load);
         MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("socialContact.microcobol.succeed"));
         this.dispose();
         dispatchEvent(new Event("submit"));
      }
      
      private function removeView() : void
      {
         super.dispose();
      }
      
      private function setEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.onFrameResponse);
         this._inputText.addEventListener(Event.CHANGE,this._inputTextChange);
         this._issueBt.addEventListener(MouseEvent.CLICK,this._clickIssueBt);
      }
      
      private function removeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.onFrameResponse);
         this._inputText.removeEventListener(Event.CHANGE,this._inputTextChange);
         this._issueBt.removeEventListener(MouseEvent.CLICK,this._clickIssueBt);
      }
      
      private function onFrameResponse(evt:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         switch(evt.responseCode)
         {
            case FrameEvent.CANCEL_CLICK:
            case FrameEvent.CLOSE_CLICK:
            case FrameEvent.ESC_CLICK:
               this.dispose();
               dispatchEvent(new Event("close"));
               break;
            case FrameEvent.ENTER_CLICK:
            case FrameEvent.SUBMIT_CLICK:
               this.dispose();
               dispatchEvent(new Event("submit"));
         }
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         this.removeView();
         super.dispose();
         this._alertInfo = null;
         this._textBg = null;
         this._inputText = null;
         this._infoText = null;
         this._issueBt = null;
      }
   }
}

