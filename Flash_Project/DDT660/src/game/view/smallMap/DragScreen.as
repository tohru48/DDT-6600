package game.view.smallMap
{
   import flash.display.Graphics;
   import flash.display.Sprite;
   
   public class DragScreen extends Sprite
   {
      
      private var _w:int = 60;
      
      private var _h:int = 60;
      
      private var _colors:Array = [16711680,65280,255];
      
      public function DragScreen(w:int, h:int)
      {
         super();
         this._w = w < 1 ? 1 : w;
         this._h = h < 1 ? 1 : h;
         buttonMode = true;
         this.drawBackground();
      }
      
      private function drawBackground() : void
      {
         var pen:Graphics = graphics;
         pen.clear();
         var colorIndex:int = int(Math.random() * 3);
         pen.lineStyle(2,this._colors[colorIndex]);
         pen.beginFill(16777215,0);
         pen.drawRect(0,0,this._w,this._h);
         pen.endFill();
      }
      
      override public function set width(value:Number) : void
      {
         if(this._w != value)
         {
            this._w = value < 1 ? 1 : int(value);
            this.drawBackground();
         }
      }
      
      override public function set height(value:Number) : void
      {
         if(this._h != value)
         {
            this._h = value < 1 ? 1 : int(value);
            this.drawBackground();
         }
      }
      
      public function dispose() : void
      {
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

