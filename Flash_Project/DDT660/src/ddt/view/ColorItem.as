package ddt.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.SelectedButton;
   import flash.display.Bitmap;
   import flash.events.MouseEvent;
   
   public class ColorItem extends SelectedButton
   {
      
      private var _color:uint;
      
      private var _over:Bitmap;
      
      public function ColorItem()
      {
         super();
      }
      
      public function setup(color:uint) : void
      {
         this._color = color;
         this.init();
         this.initEvent();
      }
      
      override protected function init() : void
      {
         super.init();
         graphics.beginFill(this._color,0);
         graphics.drawRect(0,0,16,16);
         graphics.endFill();
         this._over = ComponentFactory.Instance.creatBitmap("asset.ddtshop.ColorItemOver");
         this._over.visible = false;
         addChild(this._over);
      }
      
      private function initEvent() : void
      {
         addEventListener(MouseEvent.MOUSE_OVER,this.__mouseOver);
         addEventListener(MouseEvent.MOUSE_OUT,this.__mouseOut);
      }
      
      private function removeEvents() : void
      {
         removeEventListener(MouseEvent.MOUSE_OVER,this.__mouseOver);
         removeEventListener(MouseEvent.MOUSE_OUT,this.__mouseOut);
      }
      
      private function __mouseOver(evt:MouseEvent) : void
      {
         this._over.visible = true;
      }
      
      private function __mouseOut(evt:MouseEvent) : void
      {
         this._over.visible = false;
      }
      
      public function getColor() : uint
      {
         return this._color;
      }
      
      override public function dispose() : void
      {
         super.dispose();
         this.removeEvents();
         if(Boolean(this._over.parent))
         {
            this._over.parent.removeChild(this._over);
         }
      }
   }
}

