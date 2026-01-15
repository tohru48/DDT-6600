package overSeasCommunity.vietnam.view
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.vo.AlertInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   
   public class WeddingSharePanel extends BaseAlerFrame
   {
      
      private var _alertInfo:AlertInfo;
      
      private var _weddingImage:Bitmap;
      
      private var _descTxt:FilterFrameText;
      
      private var _shareDesc:String;
      
      public function WeddingSharePanel()
      {
         super();
         this.initialize();
      }
      
      private function initialize() : void
      {
         this._shareDesc = LanguageMgr.GetTranslation("community.church.wedding.desc",PlayerManager.Instance.Self.SpouseName);
         this.setView();
         this.setEvent();
      }
      
      private function setView() : void
      {
         cancelButtonStyle = "core.simplebt";
         submitButtonStyle = "core.simplebt";
         this._alertInfo = new AlertInfo();
         this._alertInfo.title = LanguageMgr.GetTranslation("community.WeddingSharePanel.titleText");
         this._alertInfo.moveEnable = true;
         info = this._alertInfo;
         this.escEnable = true;
         this._weddingImage = ComponentFactory.Instance.creatBitmap("asset.community.church.wedding");
         addToContent(this._weddingImage);
         this._descTxt = ComponentFactory.Instance.creat("community.church.wedding.destTxt");
         this._descTxt.text = this._shareDesc;
         addToContent(this._descTxt);
      }
      
      private function setEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.onFrameResponse);
      }
      
      private function removeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.onFrameResponse);
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
               break;
            case FrameEvent.ENTER_CLICK:
            case FrameEvent.SUBMIT_CLICK:
               this.confirmSubmit();
               this.dispose();
         }
      }
      
      private function confirmSubmit() : void
      {
         var message:String = LanguageMgr.GetTranslation("community.church.wedding.message");
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
   }
}

