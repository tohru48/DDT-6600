package ddt.command
{
   import com.pickgliss.ui.core.Component;
   import com.pickgliss.ui.core.TransformableComponent;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.DisplayObject;
   import flash.display.Shape;
   
   public class StripTip extends TransformableComponent
   {
      
      private var _view:DisplayObject;
      
      private var _mouseActiveObjectShape:Shape;
      
      public function StripTip()
      {
         super();
      }
      
      override protected function init() : void
      {
         this._mouseActiveObjectShape = new Shape();
         this._mouseActiveObjectShape.graphics.beginFill(65280,0);
         this._mouseActiveObjectShape.graphics.drawRect(0,0,100,100);
         this._mouseActiveObjectShape.graphics.endFill();
         super.init();
      }
      
      override protected function addChildren() : void
      {
         super.addChildren();
         addChild(this._mouseActiveObjectShape);
      }
      
      public function setView(view:DisplayObject) : void
      {
         this._view = view;
         addChild(this._view);
      }
      
      override protected function onProppertiesUpdate() : void
      {
         super.onProppertiesUpdate();
         if(Boolean(_changedPropeties[Component.P_height]) || Boolean(_changedPropeties[Component.P_width]))
         {
            this._mouseActiveObjectShape.width = _width;
            this._mouseActiveObjectShape.height = _height;
         }
      }
      
      override public function dispose() : void
      {
         super.dispose();
         if(Boolean(this._mouseActiveObjectShape))
         {
            ObjectUtils.disposeObject(this._mouseActiveObjectShape);
         }
         this._mouseActiveObjectShape = null;
         if(Boolean(this._view))
         {
            ObjectUtils.disposeObject(this._view);
         }
         this._view = null;
         ObjectUtils.disposeAllChildren(this);
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

