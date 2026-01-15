package overSeasCommunity.vietnam.view.screenshot
{
   import com.pickgliss.ui.core.Disposeable;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.geom.Rectangle;
   
   public class Camera extends Sprite implements Disposeable
   {
      
      private var _bitmapData:BitmapData;
      
      private var _image:Bitmap;
      
      private var _imageContainer:Sprite;
      
      private var _cameraBorder:Sprite;
      
      public function Camera()
      {
         super();
         this.init();
         this.addEvent();
      }
      
      private function init() : void
      {
         this._cameraBorder = new Sprite();
         this._imageContainer = new Sprite();
      }
      
      private function addEvent() : void
      {
         this._cameraBorder.addEventListener(Event.RESIZE,this.__resize);
      }
      
      private function removeEvent() : void
      {
         this._cameraBorder.removeEventListener(Event.RESIZE,this.__resize);
      }
      
      private function __resize(event:Event) : void
      {
      }
      
      private function generateImage() : void
      {
         if(this._imageContainer.numChildren > 0)
         {
            this._imageContainer.removeChildAt(0);
         }
         if(Boolean(this._bitmapData))
         {
            this._bitmapData.dispose();
            this._bitmapData = null;
         }
         this._image = null;
         var clipRect:Rectangle = new Rectangle(x,y,width,height);
         this._bitmapData = this.drawImage(clipRect);
         this._image = new Bitmap(this._bitmapData);
         this._imageContainer.addChild(this._image);
      }
      
      public function drawImage(clipRect:Rectangle) : BitmapData
      {
         var bitmapData:BitmapData = new BitmapData(clipRect.width,clipRect.height,true,0);
         bitmapData.draw(stage,null,null,null,clipRect);
         return bitmapData;
      }
      
      public function dispose() : void
      {
         this.removeEvent();
      }
   }
}

