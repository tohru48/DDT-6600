package game.view
{
   import flash.display.Sprite;
   
   public class CheckCodeMixedBack extends Sprite
   {
      
      private static const CUVER_MAX:int = 10;
      
      private static const PointNum:int = 20;
      
      private static const CuverNum:int = 20;
      
      private var _width:Number;
      
      private var _height:Number;
      
      private var _color:uint;
      
      private var _renderBox:Sprite;
      
      private var masker:Sprite;
      
      public function CheckCodeMixedBack($width:Number, $height:Number, $color:Number)
      {
         super();
         this._color = $color;
         this._height = $height;
         this._width = $width;
         this._renderBox = new Sprite();
         addChild(this._renderBox);
         this.createPoint();
         this.creatCurver();
         this.render();
      }
      
      private function createPoint() : void
      {
         this._renderBox.graphics.beginFill(this._color,0.5);
         for(var i:int = 0; i < PointNum; i++)
         {
            this._renderBox.graphics.drawCircle(Math.random() * this._width,Math.random() * this._height,Math.random() * 1.5);
         }
         this._renderBox.graphics.endFill();
      }
      
      private function creatCurver() : void
      {
         var rW:Number = NaN;
         var rH:Number = NaN;
         this._renderBox.graphics.lineStyle(1,this._color,0.5);
         for(var i:int = 0; i < CuverNum; i++)
         {
            rW = Math.random() * this._width;
            rH = Math.random() * this._height;
            this._renderBox.graphics.moveTo(rW + (Math.random() * CUVER_MAX - CUVER_MAX),rH + (Math.random() * CUVER_MAX - CUVER_MAX));
            this._renderBox.graphics.curveTo(rW + (Math.random() * CUVER_MAX - CUVER_MAX),rH + (Math.random() * CUVER_MAX - CUVER_MAX),rW,rH);
         }
         this._renderBox.graphics.endFill();
      }
      
      private function render() : void
      {
         addChild(this._renderBox);
      }
   }
}

