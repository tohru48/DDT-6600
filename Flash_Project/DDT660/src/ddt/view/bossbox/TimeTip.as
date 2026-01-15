package ddt.view.bossbox
{
   import com.pickgliss.ui.core.TransformableComponent;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.Sprite;
   
   public class TimeTip extends TransformableComponent
   {
      
      private var _closeBox:Sprite;
      
      private var _delayText:Sprite;
      
      public function TimeTip()
      {
         super();
      }
      
      public function setView(close:Sprite, text:Sprite) : void
      {
         this._closeBox = close;
         this._delayText = text;
         addChild(this._closeBox);
      }
      
      public function get closeBox() : Sprite
      {
         return this._closeBox;
      }
      
      public function get delayText() : Sprite
      {
         return this._delayText;
      }
      
      override public function dispose() : void
      {
         super.dispose();
         if(Boolean(this._closeBox))
         {
            ObjectUtils.disposeObject(this._closeBox);
         }
         this._closeBox = null;
         if(Boolean(this._delayText))
         {
            ObjectUtils.disposeObject(this._delayText);
         }
         this._delayText = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

