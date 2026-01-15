package im
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.vo.AlertInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PathManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.ServerManager;
   import ddt.manager.SoundManager;
   import ddt.utils.FilterWordManager;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.KeyboardEvent;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   import flash.net.URLVariables;
   import flash.ui.Keyboard;
   import road7th.utils.StringHelper;
   
   public class InviteDialogFrame extends AddFriendFrame
   {
      
      private var _userName:String;
      
      private var _inviteCaption:String;
      
      private var _inputBG:Scale9CornerImage;
      
      private var _text:String;
      
      private var _initText:String;
      
      public function InviteDialogFrame()
      {
         super();
      }
      
      override protected function initContainer() : void
      {
         _alertInfo = new AlertInfo();
         _alertInfo.title = LanguageMgr.GetTranslation("im.InviteDialogFrame.name");
         _alertInfo.showCancel = false;
         _alertInfo.submitLabel = LanguageMgr.GetTranslation("im.InviteDialogFrame.send");
         info = _alertInfo;
         this._inputBG = ComponentFactory.Instance.creatComponentByStylename("im.InviteDialogFrame.inputBg");
         addToContent(this._inputBG);
         _inputText = ComponentFactory.Instance.creat("IM.InviteDialogFrame.Textinput");
         _inputText.wordWrap = true;
         _inputText.maxChars = 50;
         this.setText(LanguageMgr.GetTranslation("IM.InviteDialogFrame.info",ServerManager.Instance.zoneName));
         _inputText.setSelection(_inputText.text.length,_inputText.text.length);
         addToContent(_inputText);
         _inputText.addEventListener(Event.CHANGE,this.__inputChange);
      }
      
      protected function __inputChange(event:Event) : void
      {
         if(_inputText.text.length > 0)
         {
            this._text = _inputText.text;
         }
         else
         {
            this._text = this._initText;
         }
      }
      
      public function setInfo(value:String) : void
      {
         this._userName = value;
      }
      
      public function setText(value:String = "") : void
      {
         _inputText.text = value;
         this._initText = this._text = value;
         _inputText.setSelection(_inputText.text.length,_inputText.text.length);
      }
      
      override protected function __fieldKeyDown(event:KeyboardEvent) : void
      {
         if(event.keyCode == Keyboard.ENTER)
         {
            this.submit();
            SoundManager.instance.play("008");
         }
         else if(event.keyCode == Keyboard.ESCAPE)
         {
            hide();
            SoundManager.instance.play("008");
         }
         event.stopImmediatePropagation();
         event.stopPropagation();
      }
      
      override protected function submit() : void
      {
         var req:URLRequest = null;
         var data:URLVariables = null;
         var loader:URLLoader = null;
         var req1:URLRequest = null;
         var toServerData:URLVariables = null;
         var loader1:URLLoader = null;
         if(!StringHelper.isNullOrEmpty(PathManager.CommunityInvite()))
         {
            if(!FilterWordManager.isGotForbiddenWords(this._text))
            {
               req = new URLRequest(PathManager.CommunityInvite());
               data = new URLVariables();
               data["fuid"] = String(PlayerManager.Instance.Self.LoginName);
               data["fnick"] = PlayerManager.Instance.Self.NickName;
               data["tuid"] = this._userName;
               data["inviteCaption"] = this._text;
               data["rid"] = PlayerManager.Instance.Self.ID;
               data["serverid"] = String(ServerManager.Instance.AgentID);
               data["rnd"] = Math.random();
               req.data = data;
               loader = new URLLoader(req);
               loader.load(req);
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("im.IMView.inviteInfo"));
               req1 = new URLRequest(PathManager.solveRequestPath("LogInviteFriends.ashx"));
               toServerData = new URLVariables();
               toServerData["Username"] = PlayerManager.Instance.Self.NickName;
               toServerData["InviteUsername"] = this._userName;
               toServerData["IsSucceed"] = false;
               req1.data = toServerData;
               loader1 = new URLLoader(req1);
               loader1.load(req1);
               loader1.addEventListener(IOErrorEvent.IO_ERROR,this.onIOError);
               this.dispose();
            }
            else
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("im.IMView.inviteInfo1"));
            }
         }
      }
      
      private function onIOError(e:IOErrorEvent) : void
      {
      }
      
      public function show() : void
      {
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.ALPHA_BLOCKGOUND);
      }
      
      override public function dispose() : void
      {
         this._text = null;
         _inputText.removeEventListener(Event.CHANGE,this.__inputChange);
         if(Boolean(this._inputBG))
         {
            this._inputBG.dispose();
         }
         this._inputBG = null;
         super.dispose();
      }
   }
}

