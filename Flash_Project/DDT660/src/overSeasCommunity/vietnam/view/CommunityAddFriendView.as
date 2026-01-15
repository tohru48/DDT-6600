package overSeasCommunity.vietnam.view
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.vo.AlertInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   
   public class CommunityAddFriendView extends BaseAlerFrame
   {
      
      private var _bmpTip:Bitmap;
      
      public function CommunityAddFriendView()
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
         info.submitLabel = LanguageMgr.GetTranslation("tank.menu.community.AddFriend");
         this.escEnable = true;
         this._bmpTip = ComponentFactory.Instance.creatBitmap("asset.community.CommunityTip");
         addToContent(this._bmpTip);
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
      
      private function confirmSubmit() : void
      {
         var frame3:CommunityNoticeView = ComponentFactory.Instance.creat("community.CommunityNoticeView.alertFrame");
         LayerManager.Instance.addToLayer(frame3,LayerManager.GAME_TOP_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
   }
}

