package church.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.vo.AlertInfo;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import flash.text.TextFieldAutoSize;
   
   public class ChurchAlertFrame extends BaseAlerFrame
   {
      
      private var _txt:FilterFrameText;
      
      public function ChurchAlertFrame()
      {
         super();
         var alerInfo:AlertInfo = new AlertInfo("İpucu",LanguageMgr.GetTranslation("shop.PresentFrame.OkBtnText"),LanguageMgr.GetTranslation("shop.PresentFrame.CancelBtnText"));
         info = alerInfo;
         this._txt = ComponentFactory.Instance.creatComponentByStylename("FrameTitleTextStyle");
         this._txt.autoSize = TextFieldAutoSize.NONE;
         this._txt.width = 300;
         this._txt.height = 150;
         this._txt.x = 48;
         this._txt.y = 48;
         this._txt.wordWrap = true;
         this._txt.multiline = true;
         addToContent(this._txt);
      }
      
      public function setTxt(str:String) : void
      {
         this._txt.text = str;
      }
      
      override public function dispose() : void
      {
         ObjectUtils.disposeObject(this._txt);
         this._txt = null;
         super.dispose();
      }
   }
}

