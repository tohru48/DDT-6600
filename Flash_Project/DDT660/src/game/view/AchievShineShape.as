package game.view
{
   import flash.display.GradientType;
   import flash.display.Graphics;
   import flash.display.Shape;
   
   public class AchievShineShape extends Shape
   {
      
      private var _color:int = 0;
      
      private var _radius:int;
      
      private var _alphas:Array;
      
      private var _ratios:Array;
      
      public function AchievShineShape()
      {
         super();
      }
      
      public function setColor(color:int) : void
      {
         this._color = color;
         this.draw();
      }
      
      private function draw() : void
      {
         var pen:Graphics = graphics;
         pen.clear();
         pen.beginGradientFill(GradientType.RADIAL,[this._color,this._color],this._alphas,this._ratios);
         pen.drawCircle(0,0,this._radius);
         pen.endFill();
      }
      
      public function set radius(val:int) : void
      {
         this._radius = val;
         this.draw();
      }
      
      public function set alphas(val:String) : void
      {
         this._alphas = val.split(",");
         this.draw();
      }
      
      public function set ratios(val:String) : void
      {
         this._ratios = val.split(",");
         this.draw();
      }
   }
}

