package ddt.display
{
   import com.pickgliss.ui.core.Disposeable;
   import flash.display.Graphics;
   import flash.display.Shape;
   import flash.geom.Matrix;
   
   public class BitmapShape extends Shape implements Disposeable
   {
      
      private var _bitmap:BitmapObject;
      
      private var _matrix:Matrix;
      
      private var _repeat:Boolean;
      
      private var _smooth:Boolean;
      
      public function BitmapShape(bitmap:BitmapObject = null, matrix:Matrix = null, repeat:Boolean = true, smooth:Boolean = false)
      {
         super();
         this._bitmap = bitmap;
         this._matrix = matrix;
         this._repeat = repeat;
         this._smooth = smooth;
         this.draw();
      }
      
      public function set bitmapObject(val:BitmapObject) : void
      {
      }
      
      public function get bitmapObject() : BitmapObject
      {
         return this._bitmap;
      }
      
      protected function draw() : void
      {
         var pen:Graphics = null;
         if(Boolean(this._bitmap))
         {
            pen = graphics;
            pen.clear();
            pen.beginBitmapFill(this._bitmap,this._matrix,this._repeat,this._smooth);
            pen.drawRect(0,0,this._bitmap.width,this._bitmap.height);
            pen.endFill();
         }
      }
      
      public function dispose() : void
      {
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
         if(Boolean(this._bitmap))
         {
            this._bitmap.dispose();
         }
      }
   }
}

