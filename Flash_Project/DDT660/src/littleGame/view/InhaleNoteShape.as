package littleGame.view
{
   import com.pickgliss.ui.core.Disposeable;
   import ddt.ddt_internal;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import littleGame.LittleGameManager;
   
   public class InhaleNoteShape extends Bitmap implements Disposeable
   {
      
      public function InhaleNoteShape(count:int, max:int)
      {
         super(null,"auto",true);
         this.setNote(count,max);
      }
      
      public function dispose() : void
      {
         if(Boolean(bitmapData))
         {
            bitmapData.dispose();
         }
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
      
      public function setNote(count:int, max:int) : void
      {
         var bitmap:BitmapData = LittleGameManager.Instance.Current.ddt_internal::inhaleNeed.clone();
         var src:BitmapData = LittleGameManager.Instance.Current.ddt_internal::bigNum;
         var w:int = src.width / 11;
         var drawRect:Rectangle = new Rectangle(0,0,w,src.height);
         drawRect.x = max * w;
         bitmap.copyPixels(src,drawRect,new Point(290,0),null,null,true);
         if(Boolean(bitmapData))
         {
            bitmapData.dispose();
         }
         bitmapData = bitmap;
      }
   }
}

