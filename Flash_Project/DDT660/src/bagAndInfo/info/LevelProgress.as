package bagAndInfo.info
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Component;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Graphics;
   import flash.geom.Matrix;
   
   public class LevelProgress extends Component
   {
      
      public static const Progress:String = "progress";
      
      protected var _background:Bitmap;
      
      protected var _thuck:Component;
      
      protected var _graphics_thuck:BitmapData;
      
      protected var _value:Number = 0;
      
      protected var _max:Number = 100;
      
      protected var _progressLabel:FilterFrameText;
      
      public function LevelProgress()
      {
         super();
         _height = 10;
         _width = 10;
         this.initView();
         this.drawProgress();
      }
      
      protected function initView() : void
      {
         this._background = ComponentFactory.Instance.creatBitmap("bagAndInfo.info.Background_Progress1");
         addChild(this._background);
         this._thuck = ComponentFactory.Instance.creatComponentByStylename("bagAndInfo.info.thunck");
         addChild(this._thuck);
         this._graphics_thuck = ComponentFactory.Instance.creatBitmapData("bagAndInfo.info.Bitmap_thuck1");
         this._progressLabel = ComponentFactory.Instance.creatComponentByStylename("bagAndInfo.info.LevelProgressText");
         addChild(this._progressLabel);
      }
      
      public function setProgress(value:Number, max:Number) : void
      {
         if(isNaN(value))
         {
            value = 0;
         }
         if(this._value != value || this._max != max)
         {
            this._value = value;
            this._max = max;
            this.drawProgress();
         }
      }
      
      protected function drawProgress() : void
      {
         var rate:Number = this._value / this._max > 1 ? 1 : this._value / this._max;
         var pen:Graphics = this._thuck.graphics;
         pen.clear();
         if(rate >= 0)
         {
            this._progressLabel.text = Math.floor(rate * 10000) / 100 + "%";
            pen.beginBitmapFill(this._graphics_thuck,new Matrix(128 / 123));
            pen.drawRect(0,0,(_width + 20) * rate,_height - 8);
            pen.endFill();
         }
      }
      
      public function set labelText(value:String) : void
      {
         this._progressLabel.text = value;
      }
      
      override public function dispose() : void
      {
         ObjectUtils.disposeObject(this._graphics_thuck);
         this._graphics_thuck = null;
         ObjectUtils.disposeObject(this._background);
         this._background = null;
         ObjectUtils.disposeObject(this._thuck);
         this._thuck = null;
         ObjectUtils.disposeObject(this._progressLabel);
         this._progressLabel = null;
         super.dispose();
      }
   }
}

