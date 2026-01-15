package ddt.view.common.church
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.vo.AlertInfo;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddtBuried.BuriedManager;
   import flash.display.Bitmap;
   
   public class ChurchInviteFrame extends BaseAlerFrame
   {
      
      private var _inviteName:String;
      
      private var _roomid:int;
      
      private var _password:String;
      
      private var _sceneIndex:int;
      
      private var _name_txt:FilterFrameText;
      
      private var _bmTitle:Bitmap;
      
      private var _bmMsg:Bitmap;
      
      private var _alertInfo:AlertInfo;
      
      public function ChurchInviteFrame()
      {
         super();
         this.initialize();
      }
      
      private function initialize() : void
      {
         cancelButtonStyle = "core.simplebt";
         submitButtonStyle = "core.simplebt";
         this._alertInfo = new AlertInfo();
         this._alertInfo.moveEnable = false;
         info = this._alertInfo;
         this.escEnable = true;
         addEventListener(FrameEvent.RESPONSE,this.onFrameResponse);
      }
      
      private function confirmSubmit() : void
      {
         SoundManager.instance.play("008");
         SocketManager.Instance.out.sendEnterRoom(this._roomid,this._password,this._sceneIndex);
         this.dispose();
      }
      
      private function onFrameResponse(evt:FrameEvent) : void
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
      
      public function set msgInfo(value:Object) : void
      {
         var fwidth:int = 0;
         this._inviteName = value["inviteName"];
         this._roomid = value["roomID"];
         this._password = value["pwd"];
         this._sceneIndex = value["sceneIndex"];
         this._name_txt = ComponentFactory.Instance.creatComponentByStylename("common.church.ChurchInviteFrameInfoAsset");
         this._name_txt.text = this._inviteName;
         addToContent(this._name_txt);
         this._bmTitle = ComponentFactory.Instance.creatBitmap("asset.church.churchInviteTitleAsset");
         addToContent(this._bmTitle);
         this._bmMsg = ComponentFactory.Instance.creatBitmap("asset.church.churchInviteMsgAsset");
         addToContent(this._bmMsg);
         this._bmMsg.x = this._name_txt.textWidth + this._name_txt.x + 10;
         fwidth = this._name_txt.textWidth + this._bmMsg.width + 60;
         width = fwidth;
         this._bmTitle.x = (fwidth - this._bmTitle.width) / 2 - 30;
      }
      
      public function show() : void
      {
         if(!BuriedManager.Instance.isOpening)
         {
            LayerManager.Instance.addToLayer(this,LayerManager.STAGE_TOP_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
         }
      }
      
      override public function dispose() : void
      {
         super.dispose();
         removeEventListener(FrameEvent.RESPONSE,this.onFrameResponse);
         this._alertInfo = null;
         ObjectUtils.disposeObject(this._name_txt);
         this._name_txt = null;
         ObjectUtils.disposeObject(this._bmTitle);
         this._bmTitle = null;
         ObjectUtils.disposeObject(this._bmMsg);
         this._bmMsg = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

