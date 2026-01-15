package magicHouse
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.text.FilterFrameText;
   import ddt.manager.LanguageMgr;
   import ddt.utils.PositionUtils;
   
   public class MagicHouseTipFrame extends Frame
   {
      
      private var _tipTxt:FilterFrameText;
      
      private var _okBtn:TextButton;
      
      private var _cancelBtn:TextButton;
      
      public function MagicHouseTipFrame()
      {
         super();
         this.initView();
      }
      
      private function initView() : void
      {
         this._tipTxt = ComponentFactory.Instance.creatComponentByStylename("magichouse.tipFrame.tipText");
         addToContent(this._tipTxt);
         this._okBtn = ComponentFactory.Instance.creatComponentByStylename("magichouse.chargeBoxframe.confirmBtn");
         this._okBtn.text = LanguageMgr.GetTranslation("shop.PresentFrame.OkBtnText");
         PositionUtils.setPos(this._okBtn,"magicHouse.tipFrame.OkBtnPos");
         addToContent(this._okBtn);
         this._cancelBtn = ComponentFactory.Instance.creatComponentByStylename("magichouse.chargeBoxframe.cancleBtn");
         this._cancelBtn.text = LanguageMgr.GetTranslation("shop.PresentFrame.CancelBtnText");
         PositionUtils.setPos(this._cancelBtn,"magicHouse.tipFrame.CancekBtnPos");
         addToContent(this._cancelBtn);
      }
      
      public function get okBtn() : TextButton
      {
         return this._okBtn;
      }
      
      public function get cancelBtn() : TextButton
      {
         return this._cancelBtn;
      }
      
      public function setTipText(str:String) : void
      {
         this._tipTxt.text = str;
      }
      
      public function setTipHtmlText(str:String) : void
      {
         this._tipTxt.htmlText = str;
      }
      
      public function setFrameWidth($w:int) : void
      {
         this.width = $w;
      }
      
      public function setFrameHeight($h:int) : void
      {
         this.height = $h;
      }
      
      override public function dispose() : void
      {
         super.dispose();
      }
   }
}

