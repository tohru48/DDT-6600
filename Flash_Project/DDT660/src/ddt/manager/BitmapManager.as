package ddt.manager
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import ddt.display.BitmapObject;
   import ddt.display.BitmapShape;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.IBitmapDrawable;
   import flash.geom.Matrix;
   import flash.geom.Point;
   
   public class BitmapManager implements Disposeable
   {
      
      public static const GameView:String = "GameView";
      
      private static const destPoint:Point = new Point();
      
      private static var _mgrPool:Object = new Object();
      
      private var _bitmapPool:Object;
      
      private var _len:int;
      
      public var name:String = "BitmapManager";
      
      public var linkCount:int = 0;
      
      public function BitmapManager()
      {
         super();
         this._bitmapPool = new Object();
      }
      
      public static function hasMgr(name:String) : Boolean
      {
         return _mgrPool.hasOwnProperty(name);
      }
      
      private static function registerMgr(name:String, mgr:BitmapManager) : void
      {
         _mgrPool[name] = mgr;
      }
      
      private static function removeMgr(name:String) : void
      {
         if(hasMgr(name))
         {
            delete _mgrPool[name];
         }
      }
      
      public static function getBitmapMgr(name:String) : BitmapManager
      {
         var mgr:BitmapManager = null;
         if(hasMgr(name))
         {
            mgr = _mgrPool[name];
            ++mgr.linkCount;
            return mgr;
         }
         mgr = new BitmapManager();
         mgr.name = name;
         ++mgr.linkCount;
         registerMgr(name,mgr);
         return mgr;
      }
      
      public function dispose() : void
      {
         --this.linkCount;
         if(this.linkCount <= 0)
         {
            this.destory();
         }
      }
      
      private function destory() : void
      {
         var key:String = null;
         var bitmap:BitmapObject = null;
         removeMgr(this.name);
         for(key in this._bitmapPool)
         {
            bitmap = this._bitmapPool[key];
            bitmap.destory();
            delete this._bitmapPool[key];
         }
         this._bitmapPool = null;
      }
      
      public function creatBitmapShape(name:String, matrix:Matrix = null, repeat:Boolean = true, smooth:Boolean = false) : BitmapShape
      {
         return new BitmapShape(this.getBitmap(name),matrix,repeat,smooth);
      }
      
      public function hasBitmap(name:String) : Boolean
      {
         return this._bitmapPool.hasOwnProperty(name);
      }
      
      public function getBitmap(name:String) : BitmapObject
      {
         var bitmap:BitmapObject = null;
         if(this.hasBitmap(name))
         {
            bitmap = this._bitmapPool[name];
            ++bitmap.linkCount;
            return bitmap;
         }
         bitmap = this.createBitmap(name);
         bitmap.manager = this;
         ++bitmap.linkCount;
         return bitmap;
      }
      
      private function createBitmap(name:String) : BitmapObject
      {
         var bitmap:BitmapObject = null;
         var display:* = ComponentFactory.Instance.creat(name);
         if(display is BitmapData)
         {
            bitmap = new BitmapObject(display.width,display.height,true,0);
            bitmap.copyPixels(display,display.rect,destPoint);
            bitmap.linkName = name;
            this.addBitmap(bitmap);
            return bitmap;
         }
         if(display is Bitmap)
         {
            bitmap = new BitmapObject(display.bitmapData.width,display.bitmapData.height,true,0);
            bitmap.copyPixels(display.bitmapData,display.bitmapData.rect,destPoint);
            bitmap.linkName = name;
            this.addBitmap(bitmap);
            return bitmap;
         }
         if(display is DisplayObject)
         {
            bitmap = new BitmapObject(display.width,display.height,true,0);
            bitmap.draw(display as IBitmapDrawable);
            bitmap.linkName = name;
            this.addBitmap(bitmap);
            return bitmap;
         }
         return null;
      }
      
      private function addBitmap(bitmap:BitmapObject) : void
      {
         if(!this.hasBitmap(bitmap.linkName))
         {
            ++this._len;
         }
         bitmap.linkCount = 0;
         bitmap.manager = this;
         this._bitmapPool[bitmap.linkName] = bitmap;
      }
      
      private function removeBitmap(bitmap:BitmapObject) : void
      {
         if(this.hasBitmap(bitmap.linkName))
         {
            --this._len;
         }
         delete this._bitmapPool[bitmap.linkName];
      }
   }
}

