package overSeasCommunity.vietnam.view
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.TextInput;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.vo.AlertInfo;
   import ddt.data.player.PlayerInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SoundManager;
   
   public class ResumeShareView extends BaseAlerFrame
   {
      
      private var _commentInput:TextInput;
      
      private var _player:PlayerInfo;
      
      public function ResumeShareView()
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
         info.submitLabel = LanguageMgr.GetTranslation("tank.menu.community.share");
         this.escEnable = true;
         this._commentInput = ComponentFactory.Instance.creat("community.ResumeShare.textInput");
         addToContent(this._commentInput);
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
               this.dispose();
         }
      }
      
      public function set player(value:PlayerInfo) : void
      {
         this._player = value;
      }
      
      private function confirmSubmit() : void
      {
         var comment:String = this._commentInput.text;
      }
   }
}

