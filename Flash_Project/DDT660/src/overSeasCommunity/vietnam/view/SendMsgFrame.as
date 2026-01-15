package overSeasCommunity.vietnam.view
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.controls.TextInput;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SoundManager;
   import flash.events.MouseEvent;
   import overSeasCommunity.vietnam.CommunityManager;
   
   public class SendMsgFrame extends Frame
   {
      
      private var _textInput:TextInput;
      
      private var _sendBtn:TextButton;
      
      private var _tragetId:int;
      
      public function SendMsgFrame()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         if(Boolean(this._sendBtn))
         {
            this._sendBtn.dispose();
         }
         this._sendBtn = null;
         super.dispose();
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
      
      private function removeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         this._sendBtn.removeEventListener(MouseEvent.CLICK,this.__sendClick);
      }
      
      private function initView() : void
      {
         this._sendBtn = ComponentFactory.Instance.creatComponentByStylename("community.SendMsgFrame.sendBtn");
         this._sendBtn.text = LanguageMgr.GetTranslation("tank.menu.community.send");
         addToContent(this._sendBtn);
         this.escEnable = true;
         this._textInput = ComponentFactory.Instance.creat("community.sendmsg.textInput");
         addToContent(this._textInput);
      }
      
      private function initEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         this._sendBtn.addEventListener(MouseEvent.CLICK,this.__sendClick);
      }
      
      private function __sendClick(evt:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         CommunityManager.Instance.sendNotice(this._tragetId,this._textInput.text);
         this.dispose();
      }
      
      private function __responseHandler(evt:FrameEvent) : void
      {
         switch(evt.responseCode)
         {
            case FrameEvent.CANCEL_CLICK:
            case FrameEvent.CLOSE_CLICK:
            case FrameEvent.ESC_CLICK:
               SoundManager.instance.play("008");
               this.dispose();
         }
      }
      
      public function set friendId(userId:int) : void
      {
         this._tragetId = userId;
      }
      
      public function show() : void
      {
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_TOP_LAYER,true,LayerManager.ALPHA_BLOCKGOUND);
      }
   }
}

