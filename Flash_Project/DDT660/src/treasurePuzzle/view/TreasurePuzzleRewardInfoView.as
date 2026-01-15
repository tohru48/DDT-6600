package treasurePuzzle.view
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.controls.TextInput;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.text.TextArea;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   import treasurePuzzle.controller.TreasurePuzzleManager;
   
   public class TreasurePuzzleRewardInfoView extends Frame
   {
      
      private var _iconTxtBg:Bitmap;
      
      private var _btnBg:Bitmap;
      
      private var _btn:SimpleBitmapButton;
      
      private var _topText:FilterFrameText;
      
      private var _textinput1:TextInput;
      
      private var _textinput2:TextInput;
      
      private var _detailAddressArea:TextArea;
      
      private var _nameText:FilterFrameText;
      
      private var _phoneText:FilterFrameText;
      
      private var _addressText:FilterFrameText;
      
      private var _zhuText:FilterFrameText;
      
      public function TreasurePuzzleRewardInfoView()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         titleText = LanguageMgr.GetTranslation("treasurePuzzle.viewAlertDialog.Info");
         this._iconTxtBg = ComponentFactory.Instance.creatBitmap("treasurePuzzle.view.iconTxtBg");
         this._btnBg = ComponentFactory.Instance.creatBitmap("treasurePuzzle.view.btnBg");
         this._btn = ComponentFactory.Instance.creatComponentByStylename("treasurePuzzle.view.Rewardbtn");
         this._topText = ComponentFactory.Instance.creatComponentByStylename("treasurePuzzle.view.RewardtopText");
         this._topText.text = LanguageMgr.GetTranslation("treasurePuzzle.view.topTextInfo");
         this._textinput1 = ComponentFactory.Instance.creat("treasurePuzzle.view.RewardtextInput1");
         this._textinput1.textField.tabIndex = 0;
         this._textinput2 = ComponentFactory.Instance.creat("treasurePuzzle.view.RewardtextInput2");
         this._textinput2.textField.tabIndex = 1;
         this._detailAddressArea = ComponentFactory.Instance.creatComponentByStylename("treasurePuzzle.view.RewardsimpleTextArea");
         var rec:Rectangle = ComponentFactory.Instance.creatCustomObject("treasurePuzzle.DetailTextAreaRec");
         ObjectUtils.copyPropertyByRectangle(this._detailAddressArea,rec);
         this._nameText = ComponentFactory.Instance.creatComponentByStylename("treasurePuzzle.view.RewardNameText");
         this._phoneText = ComponentFactory.Instance.creatComponentByStylename("treasurePuzzle.view.RewardPhoneText");
         this._addressText = ComponentFactory.Instance.creatComponentByStylename("treasurePuzzle.view.RewardAddressText");
         this._nameText.text = LanguageMgr.GetTranslation("treasurePuzzle.view.nameText");
         this._phoneText.text = LanguageMgr.GetTranslation("treasurePuzzle.view.phoneText");
         this._addressText.text = LanguageMgr.GetTranslation("treasurePuzzle.view.addressText");
         this._zhuText = ComponentFactory.Instance.creatComponentByStylename("treasurePuzzle.view.zhuText");
         this._zhuText.text = LanguageMgr.GetTranslation("treasurePuzzle.view.zhuText");
         addToContent(this._iconTxtBg);
         addToContent(this._btnBg);
         addToContent(this._btn);
         addToContent(this._nameText);
         addToContent(this._phoneText);
         addToContent(this._addressText);
         addToContent(this._topText);
         addToContent(this._textinput1);
         addToContent(this._textinput2);
         addToContent(this._detailAddressArea);
         addToContent(this._zhuText);
      }
      
      private function initEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         this._btn.addEventListener(MouseEvent.CLICK,this.btnClickHandler);
      }
      
      private function __responseHandler(evt:FrameEvent) : void
      {
         if(evt.responseCode == FrameEvent.CLOSE_CLICK || evt.responseCode == FrameEvent.ESC_CLICK)
         {
            SoundManager.instance.play("008");
            this.dispose();
         }
      }
      
      private function btnClickHandler(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         SocketManager.Instance.out.treasurePuzzle_savePlayerInfo(this._textinput1.text,this._textinput2.text,this._detailAddressArea.text,TreasurePuzzleManager.Instance.currentPuzzle);
         this.dispose();
      }
      
      private function removeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         if(Boolean(this._btn))
         {
            this._btn.removeEventListener(MouseEvent.CLICK,this.btnClickHandler);
         }
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         ObjectUtils.disposeObject(this._iconTxtBg);
         this._iconTxtBg = null;
         ObjectUtils.disposeObject(this._btnBg);
         this._btnBg = null;
         ObjectUtils.disposeObject(this._btn);
         this._btn = null;
         super.dispose();
      }
   }
}

