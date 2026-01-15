package overSeasCommunity.vietnam.view
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.vo.AlertInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import overSeasCommunity.vietnam.CommunityManager;
   
   public class InviteJoinFrame extends BaseAlerFrame
   {
      
      private var _bg:Bitmap;
      
      private var _text:FilterFrameText;
      
      private var _UserName:String;
      
      private var _tragetId:int;
      
      public function InviteJoinFrame()
      {
         super();
         addEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         this.initView();
      }
      
      override public function dispose() : void
      {
         super.dispose();
         this.removeEvent();
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
      
      private function removeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__responseHandler);
      }
      
      private function initView() : void
      {
         submitButtonStyle = "core.simplebt";
         info = new AlertInfo();
         info.submitLabel = LanguageMgr.GetTranslation("sure");
         info.title = LanguageMgr.GetTranslation("community.inviteJoin.title");
         this.escEnable = true;
         this._text = ComponentFactory.Instance.creat("community.inviteJoin.alertTxt");
         this._text.text = LanguageMgr.GetTranslation("community.inviteJoin.descTip",PlayerManager.Instance.Self.NickName,this._UserName);
         addToContent(this._text);
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
               break;
            case FrameEvent.ENTER_CLICK:
            case FrameEvent.SUBMIT_CLICK:
               SoundManager.instance.play("008");
               this.confirmSubmit();
         }
      }
      
      public function show() : void
      {
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_TOP_LAYER,true,LayerManager.ALPHA_BLOCKGOUND);
      }
      
      private function confirmSubmit() : void
      {
         CommunityManager.Instance.sendNotice(this._tragetId,this._text.text);
         this.dispose();
      }
      
      public function set friendId(userId:int) : void
      {
         this._tragetId = userId;
      }
      
      public function set UserName(value:String) : void
      {
         this._UserName = value;
      }
   }
}

