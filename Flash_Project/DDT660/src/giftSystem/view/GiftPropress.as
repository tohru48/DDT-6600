package giftSystem.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Component;
   import com.pickgliss.ui.image.MovieImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.BitmapData;
   import flash.display.Graphics;
   import flash.geom.Matrix;
   
   public class GiftPropress extends Component
   {
      
      private var _backgound:MovieImage;
      
      private var _thuck:Component;
      
      private var _graphics_thuck:BitmapData;
      
      private var _value:Number = 0;
      
      private var _max:Number = 100;
      
      private var _propgressLabel:FilterFrameText;
      
      public function GiftPropress()
      {
         super();
         _height = 10;
         _width = 10;
         this.initView();
         this.drawProgress();
      }
      
      private function initView() : void
      {
         this._backgound = ComponentFactory.Instance.creatComponentByStylename("ddtGiftGoodItem.levelBG");
         addChild(this._backgound);
         this._thuck = ComponentFactory.Instance.creatComponentByStylename("gift.info.thunck");
         addChild(this._thuck);
         this._graphics_thuck = ComponentFactory.Instance.creatBitmapData("gift.info.Bitmap_thuck1");
         this._propgressLabel = ComponentFactory.Instance.creatComponentByStylename("gift.info.LevelProgressText");
         addChild(this._propgressLabel);
      }
      
      public function setProgress(value:Number, max:Number) : void
      {
         if(this._value != value || this._max != max)
         {
            this._value = value;
            this._max = max;
            this.drawProgress();
         }
      }
      
      private function drawProgress() : void
      {
         var rate:Number = this._value / this._max > 1 ? 1 : this._value / this._max;
         var pen:Graphics = this._thuck.graphics;
         pen.clear();
         if(rate >= 0)
         {
            this._propgressLabel.text = Math.floor(rate * 10000) / 100 + "%";
            pen.beginBitmapFill(this._graphics_thuck,new Matrix(128 / 123));
            pen.drawRect(0,0,(_width + 20) * rate,_height - 4);
            pen.endFill();
         }
      }
      
      public function set labelText(value:String) : void
      {
         this._propgressLabel.text = value;
      }
      
      override public function dispose() : void
      {
         ObjectUtils.disposeObject(this._graphics_thuck);
         this._graphics_thuck = null;
         ObjectUtils.disposeObject(this._thuck);
         this._thuck = null;
         ObjectUtils.disposeObject(this._propgressLabel);
         this._propgressLabel = null;
         ObjectUtils.disposeObject(this._backgound);
         this._backgound = null;
         super.dispose();
      }
   }
}

