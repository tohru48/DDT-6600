package bagAndInfo.bag
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.SelectedCheckButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class BagArrangeTipSprite extends Sprite implements Disposeable
   {
      
      private var _bg:ScaleBitmapImage;
      
      private var _contentTxt:FilterFrameText;
      
      private var _bagArrangeCheckBtn:SelectedCheckButton;
      
      private var _arrangeAdd:Boolean;
      
      public function BagArrangeTipSprite()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      public function get arrangeAdd() : Boolean
      {
         return this._arrangeAdd;
      }
      
      public function set arrangeAdd(value:Boolean) : void
      {
         this._arrangeAdd = value;
      }
      
      private function initEvent() : void
      {
         addEventListener(MouseEvent.ROLL_OUT,this.__outHandler);
         this._bagArrangeCheckBtn.addEventListener(MouseEvent.CLICK,this.__btnSelectedHandler);
      }
      
      protected function __btnSelectedHandler(event:MouseEvent) : void
      {
         this._arrangeAdd = this._bagArrangeCheckBtn.selected;
      }
      
      protected function __outHandler(event:MouseEvent) : void
      {
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
      
      protected function __overHandler(event:MouseEvent) : void
      {
         if(Boolean(parent))
         {
            parent.addChild(this);
         }
      }
      
      private function removeEvent() : void
      {
         this._bagArrangeCheckBtn.removeEventListener(MouseEvent.CLICK,this.__btnSelectedHandler);
         removeEventListener(MouseEvent.ROLL_OUT,this.__outHandler);
      }
      
      private function initView() : void
      {
         this._bg = ComponentFactory.Instance.creatComponentByStylename("core.commonTipBg");
         this._contentTxt = ComponentFactory.Instance.creatComponentByStylename("bagArrangeText");
         this._contentTxt.text = LanguageMgr.GetTranslation("tank.view.bagII.BagIIView.bagArrangeBtn");
         this._bagArrangeCheckBtn = ComponentFactory.Instance.creatComponentByStylename("bagArrangeCheckBox");
         addChild(this._bg);
         addChild(this._bagArrangeCheckBtn);
         addChild(this._contentTxt);
         this.updateTransform();
      }
      
      protected function updateTransform() : void
      {
         this._bg.width = this._contentTxt.width + 40;
         this._bg.height = this._contentTxt.height + 12;
         this._contentTxt.x = this._bg.x + 25;
         this._contentTxt.y = this._bg.y + 6;
      }
      
      public function dispose() : void
      {
         ObjectUtils.disposeObject(this._bg);
         this._bg = null;
         ObjectUtils.disposeObject(this._contentTxt);
         this._contentTxt = null;
         ObjectUtils.disposeObject(this._bagArrangeCheckBtn);
         this._bagArrangeCheckBtn = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

