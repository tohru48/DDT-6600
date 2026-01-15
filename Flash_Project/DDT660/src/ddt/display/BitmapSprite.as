package ddt.display
{
   import com.pickgliss.ui.core.Disposeable;
   import flash.display.Graphics;
   import flash.display.Sprite;
   import flash.geom.Matrix;
   
   public class BitmapSprite extends Sprite implements Disposeable
   {
      
      protected var _bitmap:BitmapObject;
      
      protected var _matrix:Matrix;
      
      protected var _repeat:Boolean;
      
      protected var _smooth:Boolean;
      
      protected var _w:int;
      
      protected var _h:int;
      
      public function BitmapSprite(bitmap:BitmapObject = null, matrix:Matrix = null, repeat:Boolean = true, smooth:Boolean = false)
      {
         super();
         this._bitmap = bitmap;
         this._matrix = matrix;
         this._repeat = repeat;
         this._smooth = smooth;
         this.configUI();
      }
      
      public function set bitmapObject(val:BitmapObject) : void
      {
         var bitmap:BitmapObject = this._bitmap;
         this._bitmap = val;
         this.drawBitmap();
         if(Boolean(bitmap))
         {
            bitmap.dispose();
         }
      }
      
      public function get bitmapObject() : BitmapObject
      {
         return this._bitmap;
      }
      
      protected function drawBitmap() : void
      {
         var pen:Graphics = null;
         graphics.clear();
         if(Boolean(this._bitmap))
         {
            pen = graphics;
            pen.beginBitmapFill(this._bitmap,this._matrix,this._repeat,this._smooth);
            pen.drawRect(0,0,this._bitmap.width,this._bitmap.height);
            pen.endFill();
         }
      }
      
      protected function configUI() : void
      {
         this.drawBitmap();
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
            this._bitmap = null;
         }
      }
   }
}

