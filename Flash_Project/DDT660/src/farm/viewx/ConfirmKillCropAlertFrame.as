package farm.viewx
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.vo.AlertInfo;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import farm.view.compose.event.SelectComposeItemEvent;
   import flash.display.DisplayObject;
   
   public class ConfirmKillCropAlertFrame extends BaseAlerFrame
   {
      
      private var _addBtn:BaseButton;
      
      private var _removeBtn:BaseButton;
      
      private var _msgTxt:FilterFrameText;
      
      private var _bgTitle:DisplayObject;
      
      private var _cropName:String;
      
      private var _fieldId:int = -1;
      
      public function ConfirmKillCropAlertFrame()
      {
         super();
         var alertInfo:AlertInfo = new AlertInfo();
         alertInfo.title = LanguageMgr.GetTranslation("ddt.farms.killCropComfirmNumPnlTitle");
         alertInfo.bottomGap = 37;
         alertInfo.buttonGape = 65;
         alertInfo.customPos = ComponentFactory.Instance.creat("farm.confirmComposeAlertBtnPos");
         this.info = alertInfo;
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         this._bgTitle = ComponentFactory.Instance.creat("assets.farm.titleSmall");
         addChild(this._bgTitle);
         PositionUtils.setPos(this._bgTitle,PositionUtils.creatPoint("farm.confirmComposeAlertTitlePos"));
         this._msgTxt = ComponentFactory.Instance.creat("farm.killCrop.msgtext");
         addToContent(this._msgTxt);
      }
      
      public function cropName(value:String, isAutomatic:Boolean = false) : void
      {
         this._cropName = value;
         if(isAutomatic)
         {
            this._msgTxt.text = LanguageMgr.GetTranslation("ddt.farms.comfirmKillCropMsg2",this._cropName);
         }
         else
         {
            this._msgTxt.text = LanguageMgr.GetTranslation("ddt.farms.comfirmKillCropMsg",this._cropName);
         }
      }
      
      public function set fieldId(value:int) : void
      {
         this._fieldId = value;
      }
      
      private function initEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__framePesponse);
      }
      
      protected function __framePesponse(event:FrameEvent) : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__framePesponse);
         SoundManager.instance.play("008");
         switch(event.responseCode)
         {
            case FrameEvent.ENTER_CLICK:
            case FrameEvent.SUBMIT_CLICK:
               dispatchEvent(new SelectComposeItemEvent(SelectComposeItemEvent.KILLCROP_CLICK,this._fieldId));
               break;
            case FrameEvent.CLOSE_CLICK:
            case FrameEvent.CANCEL_CLICK:
         }
         this.dispose();
      }
      
      private function removeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__framePesponse);
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         if(Boolean(this._msgTxt))
         {
            ObjectUtils.disposeObject(this._msgTxt);
            this._msgTxt = null;
         }
         super.dispose();
      }
   }
}

