package overSeasCommunity.overseas.view
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.toplevel.StageReferance;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.SelectedCheckButton;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.text.TextArea;
   import com.pickgliss.ui.vo.AlertInfo;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.SharedManager;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import overSeasCommunity.overseas.controllers.BaseCommunityController;
   import overSeasCommunity.overseas.model.BaseCommunityModel;
   
   public class CommunityFrame extends BaseAlerFrame
   {
      
      private var _inputBG:Bitmap;
      
      private var _SNSFrameBg1:Scale9CornerImage;
      
      private var _shareBtn:TextButton;
      
      private var _visibleBtn:SelectedCheckButton;
      
      private var _text:FilterFrameText;
      
      private var _textinput:FilterFrameText;
      
      private var _alertInfo:AlertInfo;
      
      private var _textInputBgPoint:Point;
      
      private var _inputText:TextArea;
      
      private var _model:BaseCommunityModel;
      
      private var _control:BaseCommunityController;
      
      public function CommunityFrame()
      {
         super();
         this.initView();
         this.addEvent();
      }
      
      public function get control() : BaseCommunityController
      {
         return this._control;
      }
      
      public function set control(value:BaseCommunityController) : void
      {
         this._control = value;
      }
      
      public function get model() : BaseCommunityModel
      {
         return this._model;
      }
      
      public function set model(value:BaseCommunityModel) : void
      {
         this._model = value;
      }
      
      private function initView() : void
      {
         submitButtonStyle = "core.simplebt";
         this._alertInfo = new AlertInfo(LanguageMgr.GetTranslation("ddt.view.SnsFrame.titleText"),LanguageMgr.GetTranslation("ddt.view.SnsFrame.shareBtnText"),LanguageMgr.GetTranslation("cancel"),true,true);
         this._alertInfo.moveEnable = false;
         info = this._alertInfo;
         this.escEnable = true;
         this._inputBG = ComponentFactory.Instance.creatBitmap("ddt.view.SNSFrameBg");
         addToContent(this._inputBG);
         this._inputText = ComponentFactory.Instance.creatComponentByStylename("Microcobol.inputText");
         addToContent(this._inputText);
         this._textInputBgPoint = ComponentFactory.Instance.creatCustomObject("core.SNSFramePoint");
         this._inputText.x = this._textInputBgPoint.x;
         this._inputText.y = this._textInputBgPoint.y;
         if(Boolean(this._inputText))
         {
            StageReferance.stage.focus = this._inputText.textField;
         }
         this._text = ComponentFactory.Instance.creat("core.SNSFrameViewText");
         this.addToContent(this._text);
         this._visibleBtn = ComponentFactory.Instance.creatComponentByStylename("core.SNSFrameCheckBox");
         this._visibleBtn.text = LanguageMgr.GetTranslation("ddt.view.SnsFrame.visibleBtnText");
         this._visibleBtn.selected = SharedManager.Instance.autoSnsSend;
         this.addToContent(this._visibleBtn);
      }
      
      private function addEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__frameEventHandler);
         this._inputText.addEventListener(MouseEvent.CLICK,this._clickInputText);
         this._visibleBtn.addEventListener(MouseEvent.CLICK,this.__visibleBtnClick);
         StageReferance.stage.addEventListener(MouseEvent.CLICK,this._clickStage);
      }
      
      private function removeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__frameEventHandler);
         this._inputText.removeEventListener(MouseEvent.CLICK,this._clickInputText);
         if(Boolean(this._visibleBtn))
         {
            this._visibleBtn.removeEventListener(MouseEvent.CLICK,this.__visibleBtnClick);
         }
         StageReferance.stage.removeEventListener(MouseEvent.CLICK,this._clickStage);
      }
      
      private function _clickInputText(e:MouseEvent) : void
      {
         this._inputText.removeEventListener(MouseEvent.CLICK,this._clickInputText);
         this._inputText.text = "";
      }
      
      private function _clickStage(e:MouseEvent) : void
      {
         if(this._inputText.text == "" && StageReferance.stage.focus != this._inputText.textField)
         {
            this._inputText.text = this._control.getSayStr();
         }
      }
      
      protected function __shareBtnClick(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this._control.sendDynamic();
         this.feedSuccess();
      }
      
      protected function __visibleBtnClick(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         SharedManager.Instance.autoSnsSend = this._visibleBtn.selected;
      }
      
      private function __frameEventHandler(evt:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         switch(evt.responseCode)
         {
            case FrameEvent.CANCEL_CLICK:
            case FrameEvent.CLOSE_CLICK:
            case FrameEvent.ESC_CLICK:
               this.dispose();
               dispatchEvent(new Event("close"));
               break;
            case FrameEvent.ENTER_CLICK:
            case FrameEvent.SUBMIT_CLICK:
               this._control.sendDynamic();
               this.feedSuccess();
               dispatchEvent(new Event("submit"));
         }
      }
      
      public function set receptionistTxt($txt:String) : void
      {
         if(this._text.text == $txt)
         {
            return;
         }
         this._text.text = $txt;
      }
      
      public function show() : void
      {
         if(SharedManager.Instance.autoSnsSend)
         {
            this._control.sendDynamic();
            this.feedSuccess();
         }
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.ALPHA_BLOCKGOUND);
         if(Boolean(this._inputText))
         {
            this._inputText.text = this._control.getSayStr();
         }
      }
      
      private function feedSuccess() : void
      {
         MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("socialContact.microcobol.succeed"));
         this.dispose();
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         super.dispose();
         ObjectUtils.disposeObject(this._text);
         this._text = null;
         this._inputText = null;
         ObjectUtils.disposeObject(this._textinput);
         this._textinput = null;
         ObjectUtils.disposeObject(this._shareBtn);
         this._shareBtn = null;
         ObjectUtils.disposeObject(this._visibleBtn);
         this._visibleBtn = null;
         ObjectUtils.disposeObject(this._inputBG);
         this._inputBG = null;
         ObjectUtils.disposeObject(this._SNSFrameBg1);
         this._SNSFrameBg1 = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

