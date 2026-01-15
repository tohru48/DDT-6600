package ddt.view.tips
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.tip.BaseTip;
   import com.pickgliss.utils.ObjectUtils;
   import flash.text.TextFormat;
   
   public class PropTxtTip extends BaseTip
   {
      
      protected var property_txt:FilterFrameText;
      
      protected var detail_txt:FilterFrameText;
      
      protected var _bg:ScaleBitmapImage;
      
      private var _tempData:Object;
      
      private var _oriW:int;
      
      private var _oriH:int;
      
      public function PropTxtTip()
      {
         super();
      }
      
      override protected function init() : void
      {
         mouseChildren = false;
         mouseEnabled = false;
         super.init();
         this._bg = ComponentFactory.Instance.creat("core.GoodsTipBg");
         this.property_txt = ComponentFactory.Instance.creat("core.PerpertyTxt");
         this.detail_txt = ComponentFactory.Instance.creat("core.DetailTxt");
         var txtW:int = this.detail_txt.width;
         this.detail_txt.multiline = true;
         this.detail_txt.wordWrap = true;
         this.detail_txt.width = txtW;
         this.detail_txt.selectable = false;
         this.property_txt.selectable = false;
         this.tipbackgound = this._bg;
         this._oriW = 184;
         this._oriH = 90;
      }
      
      override protected function addChildren() : void
      {
         super.addChildren();
         if(Boolean(this.property_txt))
         {
            addChild(this.property_txt);
         }
         if(Boolean(this.detail_txt))
         {
            addChild(this.detail_txt);
            this.updateWH();
         }
      }
      
      override public function get tipData() : Object
      {
         return this._tempData;
      }
      
      override public function set tipData(data:Object) : void
      {
         if(data is PropTxtTipInfo)
         {
            this._tempData = data;
            this.visible = true;
            this.propertyText(data.property);
            this.detailText(data.detail);
            this.propertyTextColor(data.color);
         }
         else
         {
            this.visible = false;
         }
      }
      
      override public function dispose() : void
      {
         ObjectUtils.disposeObject(this.property_txt);
         this.property_txt = null;
         ObjectUtils.disposeObject(this.detail_txt);
         this.detail_txt = null;
         super.dispose();
      }
      
      private function propertyTextColor(color:uint) : void
      {
         var format:TextFormat = this.property_txt.getTextFormat();
         format.color = color;
         this.property_txt.setTextFormat(format);
      }
      
      private function propertyText(value:String) : void
      {
         this.property_txt.text = value;
         this.updateWidth();
      }
      
      protected function updateWidth() : void
      {
         if(this.property_txt.x + this.property_txt.width >= this._oriW)
         {
            this._bg.width = this.property_txt.x + this.property_txt.width + 2;
         }
         else
         {
            this._bg.width = this._oriW;
         }
         _width = this._bg.width;
      }
      
      private function detailText(value:String) : void
      {
         this.detail_txt.text = value;
         this.updateWH();
      }
      
      protected function updateWH() : void
      {
         if(this.detail_txt.y + this.detail_txt.height >= this._oriH)
         {
            this._bg.height = this.detail_txt.y + this.detail_txt.height + 2;
         }
         else
         {
            this._bg.height = this._oriH;
         }
         _height = this._bg.height;
      }
   }
}

