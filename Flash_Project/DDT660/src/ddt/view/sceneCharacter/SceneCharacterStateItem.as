package ddt.view.sceneCharacter
{
   import flash.display.Bitmap;
   
   public class SceneCharacterStateItem
   {
      
      private var _type:String;
      
      private var _sceneCharacterSet:SceneCharacterSet;
      
      private var _sceneCharacterActionSet:SceneCharacterActionSet;
      
      private var _sceneCharacterSynthesis:SceneCharacterSynthesis;
      
      private var _sceneCharacterBase:SceneCharacterBase;
      
      private var _frameBitmap:Vector.<Bitmap>;
      
      private var _sceneCharacterActionItem:SceneCharacterActionItem;
      
      private var _sceneCharacterDirection:SceneCharacterDirection;
      
      public function SceneCharacterStateItem(type:String, sceneCharacterSet:SceneCharacterSet, sceneCharacterActionSet:SceneCharacterActionSet)
      {
         super();
         this._type = type;
         this._sceneCharacterSet = sceneCharacterSet;
         this._sceneCharacterActionSet = sceneCharacterActionSet;
      }
      
      public function update() : void
      {
         if(!this._sceneCharacterSet || !this._sceneCharacterActionSet)
         {
            return;
         }
         if(Boolean(this._sceneCharacterSynthesis))
         {
            this._sceneCharacterSynthesis.dispose();
         }
         this._sceneCharacterSynthesis = null;
         this._sceneCharacterSynthesis = new SceneCharacterSynthesis(this._sceneCharacterSet,this.sceneCharacterSynthesisCallBack);
      }
      
      private function sceneCharacterSynthesisCallBack(frameBitmap:Vector.<Bitmap>) : void
      {
         this._frameBitmap = frameBitmap;
         if(Boolean(this._sceneCharacterBase))
         {
            this._sceneCharacterBase.dispose();
         }
         this._sceneCharacterBase = null;
         this._sceneCharacterBase = new SceneCharacterBase(this._frameBitmap);
         this._sceneCharacterBase.sceneCharacterActionItem = this._sceneCharacterActionItem = this._sceneCharacterActionSet.dataSet[0];
      }
      
      public function set setSceneCharacterActionType(type:String) : void
      {
         var item:SceneCharacterActionItem = this._sceneCharacterActionSet.getItem(type);
         if(Boolean(item))
         {
            this._sceneCharacterActionItem = item;
         }
         this._sceneCharacterBase.sceneCharacterActionItem = this._sceneCharacterActionItem;
      }
      
      public function get setSceneCharacterActionType() : String
      {
         return this._sceneCharacterActionItem.type;
      }
      
      public function set sceneCharacterDirection(value:SceneCharacterDirection) : void
      {
         if(this._sceneCharacterDirection == value)
         {
            return;
         }
         this._sceneCharacterDirection = value;
      }
      
      public function get type() : String
      {
         return this._type;
      }
      
      public function set type(value:String) : void
      {
         this._type = value;
      }
      
      public function get sceneCharacterSet() : SceneCharacterSet
      {
         return this._sceneCharacterSet;
      }
      
      public function set sceneCharacterSet(value:SceneCharacterSet) : void
      {
         this._sceneCharacterSet = value;
      }
      
      public function get sceneCharacterBase() : SceneCharacterBase
      {
         return this._sceneCharacterBase;
      }
      
      public function dispose() : void
      {
         if(Boolean(this._sceneCharacterSet))
         {
            this._sceneCharacterSet.dispose();
         }
         this._sceneCharacterSet = null;
         if(Boolean(this._sceneCharacterActionSet))
         {
            this._sceneCharacterActionSet.dispose();
         }
         this._sceneCharacterActionSet = null;
         if(Boolean(this._sceneCharacterSynthesis))
         {
            this._sceneCharacterSynthesis.dispose();
         }
         this._sceneCharacterSynthesis = null;
         if(Boolean(this._sceneCharacterBase))
         {
            this._sceneCharacterBase.dispose();
         }
         this._sceneCharacterBase = null;
         if(Boolean(this._sceneCharacterActionItem))
         {
            this._sceneCharacterActionItem.dispose();
         }
         this._sceneCharacterActionItem = null;
         this._sceneCharacterDirection = null;
         while(Boolean(this._frameBitmap) && this._frameBitmap.length > 0)
         {
            this._frameBitmap[0].bitmapData.dispose();
            this._frameBitmap[0].bitmapData = null;
            this._frameBitmap.shift();
         }
         this._frameBitmap = null;
      }
      
      public function get frameBitmap() : Vector.<Bitmap>
      {
         return this._frameBitmap;
      }
   }
}

