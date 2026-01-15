package ddt.view.common.church
{
   import bagAndInfo.info.PlayerInfoViewControl;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.image.MutipleImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.text.TextArea;
   import com.pickgliss.ui.vo.AlertInfo;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.ChatManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import road7th.utils.StringHelper;
   
   public class ChurchProposeResponseFrame extends BaseAlerFrame
   {
      
      private var _spouseID:int;
      
      private var _spouseName:String;
      
      private var _love:String;
      
      private var _bg:MutipleImage;
      
      private var _loveTxt:TextArea;
      
      private var _answerId:int;
      
      private var _nameText:FilterFrameText;
      
      private var _name_txt:FilterFrameText;
      
      private var _btnLookEquip:TextButton;
      
      private var _alertInfo:AlertInfo;
      
      public function ChurchProposeResponseFrame()
      {
         super();
         this.initialize();
      }
      
      private function initialize() : void
      {
         cancelButtonStyle = "core.simplebt";
         submitButtonStyle = "core.simplebt";
         this._alertInfo = new AlertInfo();
         this._alertInfo.title = LanguageMgr.GetTranslation("tank.view.common.church.ProposeResponseFrame.titleText");
         this._alertInfo.submitLabel = LanguageMgr.GetTranslation("accept");
         this._alertInfo.cancelLabel = LanguageMgr.GetTranslation("refuse");
         this._alertInfo.moveEnable = false;
         info = this._alertInfo;
         this._bg = ComponentFactory.Instance.creatComponentByStylename("church.ProposeResponseAsset.bg");
         addToContent(this._bg);
         this._nameText = ComponentFactory.Instance.creat("common.church.txtChurchProposeResponseAsset.nameText");
         addToContent(this._nameText);
         this._name_txt = ComponentFactory.Instance.creat("common.church.txtChurchProposeResponseAsset");
         addToContent(this._name_txt);
         this._btnLookEquip = ComponentFactory.Instance.creat("common.church.btnLookEquipAsset");
         this._btnLookEquip.text = LanguageMgr.GetTranslation("common.church.btnLookEquipAsset.text");
         this._btnLookEquip.addEventListener(MouseEvent.CLICK,this.__lookEquip);
         addToContent(this._btnLookEquip);
         this._loveTxt = ComponentFactory.Instance.creat("common.church.txtChurchProposeResponseMsgAsset");
         addToContent(this._loveTxt);
         addEventListener(FrameEvent.RESPONSE,this.onFrameResponse);
      }
      
      private function onFrameResponse(evt:FrameEvent) : void
      {
         switch(evt.responseCode)
         {
            case FrameEvent.CANCEL_CLICK:
            case FrameEvent.CLOSE_CLICK:
            case FrameEvent.ESC_CLICK:
               SoundManager.instance.play("008");
               this.__cancel();
               break;
            case FrameEvent.ENTER_CLICK:
            case FrameEvent.SUBMIT_CLICK:
               SoundManager.instance.play("008");
               this.confirmSubmit();
         }
      }
      
      public function get answerId() : int
      {
         return this._answerId;
      }
      
      public function set answerId(value:int) : void
      {
         this._answerId = value;
      }
      
      public function get love() : String
      {
         return this._love;
      }
      
      public function set love(value:String) : void
      {
         this._love = value;
         this._loveTxt.text = Boolean(this._love) ? this._love : "";
      }
      
      public function get spouseName() : String
      {
         return this._spouseName;
      }
      
      public function set spouseName(value:String) : void
      {
         this._spouseName = value;
         this._nameText.text = this._spouseName;
         this._name_txt.text = LanguageMgr.GetTranslation("ddt.view.common.church.ProposeResponse");
      }
      
      public function get spouseID() : int
      {
         return this._spouseID;
      }
      
      public function set spouseID(value:int) : void
      {
         this._spouseID = value;
      }
      
      private function __lookEquip(evt:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         PlayerInfoViewControl.viewByID(this.spouseID);
      }
      
      private function confirmSubmit() : void
      {
         SocketManager.Instance.out.sendProposeRespose(true,this.spouseID,this.answerId);
         this.dispose();
      }
      
      private function __cancel() : void
      {
         SocketManager.Instance.out.sendProposeRespose(false,this.spouseID,this.answerId);
         var msg:String = StringHelper.rePlaceHtmlTextField(LanguageMgr.GetTranslation("tank.view.common.church.ProposeResponseFrame.msg",this.spouseName));
         ChatManager.Instance.sysChatRed(msg);
         this.dispose();
      }
      
      public function show() : void
      {
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_TOP_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      override public function dispose() : void
      {
         super.dispose();
         removeEventListener(FrameEvent.RESPONSE,this.onFrameResponse);
         ObjectUtils.disposeObject(this._bg);
         this._bg = null;
         this._loveTxt = null;
         ObjectUtils.disposeObject(this._nameText);
         this._nameText = null;
         ObjectUtils.disposeObject(this._name_txt);
         this._name_txt = null;
         ObjectUtils.disposeObject(this._btnLookEquip);
         this._btnLookEquip = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
         dispatchEvent(new Event(Event.CLOSE));
      }
   }
}

