package overSeasCommunity.vietnam.view
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.vo.AlertInfo;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   
   public class EffortShareFrame extends BaseAlerFrame
   {
      
      private var _shareIcon:Bitmap;
      
      private var _text:FilterFrameText;
      
      private var _effortInfo:String;
      
      private var _effortName:FilterFrameText;
      
      public function EffortShareFrame()
      {
         super();
         addEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         this.initView();
      }
      
      override public function dispose() : void
      {
         if(Boolean(this._shareIcon))
         {
            ObjectUtils.disposeObject(this._shareIcon);
         }
         this._shareIcon = null;
         if(Boolean(this._text))
         {
            ObjectUtils.disposeObject(this._text);
         }
         this._text = null;
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
      
      public function get effortInfo() : String
      {
         return this._effortInfo;
      }
      
      public function set effortInfo(value:String) : void
      {
         this._effortInfo = value;
      }
      
      private function initView() : void
      {
         submitButtonStyle = "core.simplebt";
         info = new AlertInfo();
         info.submitLabel = LanguageMgr.GetTranslation("sure");
         this._shareIcon = ComponentFactory.Instance.creatBitmap("asset.community.EffortShareIcon");
         addToContent(this._shareIcon);
         this._text = ComponentFactory.Instance.creat("community.EffortShareFrame.alertTxt");
         this._text.text = LanguageMgr.GetTranslation("community.effort.share.desc");
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
               this.dispose();
         }
      }
      
      private function confirmSubmit() : void
      {
         var message:String = LanguageMgr.GetTranslation("community.effort.share.message",this._effortInfo);
         var desc:String = LanguageMgr.GetTranslation("community.effort.share.desc");
      }
   }
}

