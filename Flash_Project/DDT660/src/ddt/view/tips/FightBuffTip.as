package ddt.view.tips
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.tip.BaseTip;
   import com.pickgliss.utils.ObjectUtils;
   import flash.text.TextFormat;
   
   public class FightBuffTip extends BaseTip
   {
      
      private var buff_txt:FilterFrameText;
      
      private var detail_txt:FilterFrameText;
      
      private var _bg:ScaleBitmapImage;
      
      private var _tempData:Object;
      
      private var _oriW:int;
      
      private var _oriH:int;
      
      private var _state:int;
      
      public function FightBuffTip()
      {
         super();
      }
      
      override protected function init() : void
      {
         super.init();
         this._bg = ComponentFactory.Instance.creat("core.GoodsTipBg");
         this.buff_txt = ComponentFactory.Instance.creat("core.FightBuffTxt");
         this.detail_txt = ComponentFactory.Instance.creat("core.FightBuffDetailTxt");
         var txtW:int = this.detail_txt.width;
         this.detail_txt.multiline = true;
         this.detail_txt.wordWrap = true;
         this.detail_txt.width = txtW;
         this.detail_txt.selectable = false;
         this.buff_txt.selectable = false;
         this.tipbackgound = this._bg;
         this._oriW = 172;
         this._oriH = 60;
      }
      
      override protected function addChildren() : void
      {
         super.addChildren();
         if(Boolean(this.buff_txt))
         {
            addChild(this.buff_txt);
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
         }
         else
         {
            this.visible = false;
         }
      }
      
      override public function dispose() : void
      {
         ObjectUtils.disposeObject(this.buff_txt);
         this.buff_txt = null;
         ObjectUtils.disposeObject(this.detail_txt);
         this.detail_txt = null;
         super.dispose();
      }
      
      private function propertyTextColor(color:uint) : void
      {
         var format:TextFormat = this.buff_txt.getTextFormat();
         format.color = color;
         this.buff_txt.setTextFormat(format);
      }
      
      private function propertyText(value:String) : void
      {
         this.buff_txt.text = value;
      }
      
      private function detailText(value:String) : void
      {
         this.detail_txt.htmlText = value;
         this.updateWH();
      }
      
      private function updateWH() : void
      {
         if(this.detail_txt.y + this.detail_txt.height >= this._oriH)
         {
            this._bg.height = this.detail_txt.y + this.detail_txt.height + 2;
         }
         else
         {
            this._bg.height = this._oriH;
         }
         this._bg.width = this._oriW;
         _width = this._bg.width;
         _height = this._bg.height;
      }
   }
}

