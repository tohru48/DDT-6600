package ddt.view.sceneCharacter
{
   import flash.display.Bitmap;
   import flash.display.Sprite;
   
   public class SceneCharacterBase extends Sprite
   {
      
      private var _frameBitmap:Vector.<Bitmap>;
      
      private var _sceneCharacterActionItem:SceneCharacterActionItem;
      
      private var _frameIndex:int = Math.random() * 7;
      
      public function SceneCharacterBase(frameBitmap:Vector.<Bitmap>)
      {
         super();
         this._frameBitmap = frameBitmap;
         this.initialize();
      }
      
      private function initialize() : void
      {
      }
      
      public function update() : void
      {
         if(this._frameIndex < this._sceneCharacterActionItem.frames.length)
         {
            this.loadFrame(this._sceneCharacterActionItem.frames[this._frameIndex++]);
         }
         else if(this._sceneCharacterActionItem.repeat)
         {
            this._frameIndex = 0;
         }
      }
      
      private function loadFrame(frameIndex:int) : void
      {
         if(frameIndex >= this._frameBitmap.length)
         {
            frameIndex = this._frameBitmap.length - 1;
         }
         if(Boolean(this._frameBitmap) && Boolean(this._frameBitmap[frameIndex]))
         {
            if(this.numChildren > 0 && Boolean(this.getChildAt(0)))
            {
               removeChildAt(0);
            }
            addChild(this._frameBitmap[frameIndex]);
         }
      }
      
      public function set sceneCharacterActionItem(value:SceneCharacterActionItem) : void
      {
         this._sceneCharacterActionItem = value;
         this._frameIndex = 0;
      }
      
      public function get sceneCharacterActionItem() : SceneCharacterActionItem
      {
         return this._sceneCharacterActionItem;
      }
      
      public function dispose() : void
      {
         while(numChildren > 0)
         {
            removeChildAt(0);
         }
         while(Boolean(this._frameBitmap) && this._frameBitmap.length > 0)
         {
            this._frameBitmap[0].bitmapData.dispose();
            this._frameBitmap[0].bitmapData = null;
            this._frameBitmap.shift();
         }
         this._frameBitmap = null;
         if(Boolean(this._sceneCharacterActionItem))
         {
            this._sceneCharacterActionItem.dispose();
         }
         this._sceneCharacterActionItem = null;
      }
   }
}

