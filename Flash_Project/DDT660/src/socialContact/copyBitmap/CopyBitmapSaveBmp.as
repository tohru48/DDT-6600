package socialContact.copyBitmap
{
   import com.pickgliss.toplevel.StageReferance;
   import flash.display.BitmapData;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.utils.ByteArray;
   
   public class CopyBitmapSaveBmp
   {
      
      private var _jpgEncder:JPGEncoder = new JPGEncoder();
      
      private var _bitmapData:BitmapData;
      
      public function CopyBitmapSaveBmp()
      {
         super();
      }
      
      public function copyBmp(startX:int, startY:int, endX:int, endY:int) : void
      {
         var bmpData:BitmapData = new BitmapData(StageReferance.stage.stageWidth,StageReferance.stage.stageHeight);
         bmpData.draw(StageReferance.stage);
         this._bitmapData = new BitmapData(Math.abs(endX - startX),Math.abs(endY - startY));
         var x:int = startX < endX ? startX : endX;
         var y:int = startY < endY ? startY : endY;
         this._bitmapData.copyPixels(bmpData,new Rectangle(x,y,Math.abs(endX - startX),Math.abs(endY - startY)),new Point(0,0));
         bmpData.dispose();
         bmpData = null;
      }
      
      public function get bitmapData() : ByteArray
      {
         return this._jpgEncder.encode(this._bitmapData);
      }
   }
}

