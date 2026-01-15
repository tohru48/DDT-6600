package store.view.embed
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.TransformableComponent;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.BitmapData;
   import flash.display.Graphics;
   import flash.geom.Matrix;
   
   public class HoleExpBar extends TransformableComponent
   {
      
      private static const P_Rate:String = "p_rate";
      
      private var thickness:int = 3;
      
      private var _rate:Number = 0;
      
      private var _back:BitmapData;
      
      private var _thumb:BitmapData;
      
      private var _rateField:FilterFrameText;
      
      public function HoleExpBar()
      {
         super();
         this.configUI();
      }
      
      private function configUI() : void
      {
         this._back = ComponentFactory.Instance.creatBitmapData("asset.ddtstore.EmbedHoleExpBack");
         this._thumb = ComponentFactory.Instance.creatBitmapData("asset.ddtstore.EmbedHoleExpThumb");
         this._rateField = ComponentFactory.Instance.creatComponentByStylename("ddttore.StoreEmbedBG.ExpRateFieldText");
         addChild(this._rateField);
         _width = this._back.width;
         _height = this._back.height;
         this.draw();
      }
      
      override public function set visible(value:Boolean) : void
      {
         super.visible = value;
      }
      
      override public function draw() : void
      {
         var w:int = 0;
         var matrix:Matrix = null;
         super.draw();
         var pen:Graphics = graphics;
         pen.clear();
         pen.beginBitmapFill(this._back);
         pen.drawRect(0,0,_width,_height);
         pen.endFill();
         if(_width > this.thickness * 3 && _height > this.thickness * 3 && this._rate > 0)
         {
            w = _width - this.thickness * 2;
            matrix = new Matrix();
            matrix.translate(this.thickness,this.thickness);
            pen.beginBitmapFill(this._thumb,matrix);
            pen.drawRect(this.thickness,this.thickness,w * this._rate,_height - this.thickness * 2);
            pen.endFill();
         }
         this._rateField.text = int(this._rate * 100) + "%";
      }
      
      public function setProgress(value:int, max:int = 100) : void
      {
         this._rate = value / max;
         this._rate = this._rate > 1 ? 1 : this._rate;
         onPropertiesChanged(P_Rate);
      }
      
      override public function dispose() : void
      {
         if(Boolean(this._back))
         {
            ObjectUtils.disposeObject(this._back);
            this._back = null;
         }
         if(Boolean(this._thumb))
         {
            ObjectUtils.disposeObject(this._thumb);
            this._thumb = null;
         }
         if(Boolean(this._rateField))
         {
            ObjectUtils.disposeObject(this._rateField);
         }
         this._rateField = null;
         super.dispose();
      }
   }
}

