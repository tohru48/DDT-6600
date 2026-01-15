package ddt.display
{
   import com.pickgliss.ui.core.Disposeable;
   import ddt.manager.BitmapManager;
   import flash.display.BitmapData;
   
   public class BitmapObject extends BitmapData implements Disposeable
   {
      
      public var linkName:String = "BitmapObject";
      
      public var linkCount:int = 0;
      
      public var manager:BitmapManager;
      
      public function BitmapObject(width:int, height:int, transparent:Boolean = true, fillColor:uint = 4294967295)
      {
         super(width,height,transparent,fillColor);
      }
      
      override public function dispose() : void
      {
         --this.linkCount;
      }
      
      public function destory() : void
      {
         this.manager = null;
         super.dispose();
      }
   }
}

