package ddt.view.tips
{
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.tip.ITransformableTip;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   
   public class PreviewTip extends Sprite implements Disposeable, ITransformableTip
   {
      
      private var _tipData:Object;
      
      public function PreviewTip()
      {
         super();
      }
      
      public function get tipWidth() : int
      {
         return width;
      }
      
      public function set tipWidth(w:int) : void
      {
      }
      
      public function get tipHeight() : int
      {
         return height;
      }
      
      public function set tipHeight(h:int) : void
      {
      }
      
      public function get tipData() : Object
      {
         return this._tipData;
      }
      
      public function set tipData(data:Object) : void
      {
         if(!data || data is DisplayObject == false)
         {
            return;
         }
         if(data == this._tipData)
         {
            return;
         }
         this._tipData = data;
         ObjectUtils.disposeAllChildren(this);
         addChild(this._tipData as DisplayObject);
      }
      
      public function asDisplayObject() : DisplayObject
      {
         return this;
      }
      
      public function dispose() : void
      {
         ObjectUtils.disposeAllChildren(this);
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

