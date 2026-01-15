package ddt.view.academyCommon.graduate
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.vo.AlertInfo;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.AcademyManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.text.TextFormat;
   
   public class ApprenticeGraduate extends BaseAlerFrame implements Disposeable
   {
      
      protected var _textBG:Bitmap;
      
      protected var _alertInfo:AlertInfo;
      
      protected var _explainText:FilterFrameText;
      
      protected var _tieleText:FilterFrameText;
      
      protected var _nameLabel:TextFormat;
      
      public function ApprenticeGraduate()
      {
         super();
         this.initContent();
         this.initEvent();
      }
      
      protected function initContent() : void
      {
         this._alertInfo = new AlertInfo();
         this._alertInfo.title = LanguageMgr.GetTranslation("ddt.view.academyCommon.graduate.ApprenticeGraduate");
         this._alertInfo.submitLabel = LanguageMgr.GetTranslation("ddt.view.academyCommon.academyRequest.AcademyRequestApprenticeFrame.submitLabel");
         this._alertInfo.showCancel = false;
         info = this._alertInfo;
         this._textBG = ComponentFactory.Instance.creatBitmap("asset.academyCommon.Graduate.graduateTitle");
         addToContent(this._textBG);
         this._tieleText = ComponentFactory.Instance.creatComponentByStylename("academyCommon.graduate.ApprenticeGraduate.titleText");
         this._tieleText.htmlText = LanguageMgr.GetTranslation("ddt.view.academyCommon.graduate.ApprenticeGraduate.title");
         addToContent(this._tieleText);
         this._explainText = ComponentFactory.Instance.creatComponentByStylename("academyCommon.graduate.ApprenticeGraduate.explainText");
         this._explainText.htmlText = LanguageMgr.GetTranslation("ddt.view.academyCommon.graduate.ApprenticeGraduate.explain");
         addToContent(this._explainText);
         this.update();
      }
      
      public function show() : void
      {
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_DYNAMIC_LAYER,false,LayerManager.ALPHA_BLOCKGOUND);
      }
      
      protected function initEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__frameEvent);
      }
      
      protected function update() : void
      {
      }
      
      protected function __frameEvent(event:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         switch(event.responseCode)
         {
            case FrameEvent.SUBMIT_CLICK:
            case FrameEvent.ENTER_CLICK:
               AcademyManager.Instance.recommends();
            case FrameEvent.ESC_CLICK:
            case FrameEvent.CLOSE_CLICK:
            case FrameEvent.CANCEL_CLICK:
               this.dispose();
         }
      }
      
      override public function dispose() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__frameEvent);
         if(Boolean(this._textBG))
         {
            ObjectUtils.disposeObject(this._textBG);
            this._textBG = null;
         }
         if(Boolean(this._explainText))
         {
            this._explainText.dispose();
            this._explainText = null;
         }
         if(Boolean(this._tieleText))
         {
            this._tieleText.dispose();
            this._tieleText = null;
         }
         this._nameLabel = null;
         super.dispose();
      }
   }
}

