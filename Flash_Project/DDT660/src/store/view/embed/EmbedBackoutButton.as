package store.view.embed
{
   import bagAndInfo.cell.DragEffect;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.interfaces.IDragable;
   import flash.events.MouseEvent;
   import flash.filters.ColorMatrixFilter;
   
   public class EmbedBackoutButton extends TextButton implements IDragable
   {
      
      private var _enabel:Boolean;
      
      private var _dragTarget:EmbedStoneCell;
      
      private var myColorMatrix_filter:ColorMatrixFilter;
      
      private var lightingFilter:ColorMatrixFilter;
      
      public var isAction:Boolean;
      
      public function EmbedBackoutButton()
      {
         super();
         this.init();
      }
      
      override protected function init() : void
      {
         super.init();
         buttonMode = true;
         this.addBackoutBtnEvent();
         this.myColorMatrix_filter = ComponentFactory.Instance.creatFilters("ddtstore.StoreEmbedBG.MyColorFilter")[0];
         this.lightingFilter = ComponentFactory.Instance.creatFilters("ddtstore.StoreEmbedBG.LightFilter")[0];
      }
      
      private function __mouseOver(evt:MouseEvent) : void
      {
         this.filters = [this.lightingFilter];
      }
      
      private function __mouseOut(evt:MouseEvent) : void
      {
         this.filters = null;
      }
      
      public function dragStop(effect:DragEffect) : void
      {
         this.mouseEnabled = true;
         this.isAction = false;
      }
      
      override public function set enable(b:Boolean) : void
      {
         super.enable = b;
         buttonMode = b;
         if(b)
         {
            this.addBackoutBtnEvent();
            this.filters = null;
         }
         else
         {
            this.removeBackoutBtnEvent();
            this.filters = [this.myColorMatrix_filter];
         }
      }
      
      public function getSource() : IDragable
      {
         return this;
      }
      
      public function getDragData() : Object
      {
         return this;
      }
      
      private function removeBackoutBtnEvent() : void
      {
         removeEventListener(MouseEvent.MOUSE_OVER,this.__mouseOver);
         removeEventListener(MouseEvent.MOUSE_OUT,this.__mouseOut);
      }
      
      private function addBackoutBtnEvent() : void
      {
         addEventListener(MouseEvent.MOUSE_OVER,this.__mouseOver);
         addEventListener(MouseEvent.MOUSE_OUT,this.__mouseOut);
      }
      
      override public function dispose() : void
      {
         super.dispose();
         this.removeBackoutBtnEvent();
         if(Boolean(this._dragTarget))
         {
            ObjectUtils.disposeObject(this._dragTarget);
         }
         this._dragTarget = null;
         this.lightingFilter = null;
         this.myColorMatrix_filter = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

