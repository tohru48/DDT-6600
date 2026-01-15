package pyramid.view
{
   import com.greensock.TweenLite;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.SelectedButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import pyramid.PyramidManager;
   import pyramid.event.PyramidEvent;
   
   public class PyramidReturnBar extends Sprite implements Disposeable
   {
      
      private var _bg:Bitmap;
      
      private var _stretchBtn:SelectedButton;
      
      private var _returnBtn:BaseButton;
      
      private var _pos:Point;
      
      public function PyramidReturnBar()
      {
         super();
         this.initialize();
         this.addEvent();
      }
      
      private function initialize() : void
      {
         this._bg = ComponentFactory.Instance.creatBitmap("asset.pyramid.returnBarBG");
         this._stretchBtn = ComponentFactory.Instance.creatComponentByStylename("asset.pyramid.returnBar.stretchBtn");
         this._returnBtn = ComponentFactory.Instance.creatComponentByStylename("asset.pyramid.returnBar.returnBtn");
         this._pos = ComponentFactory.Instance.creatCustomObject("asset.pyramid.returnBar.position");
         addChild(this._bg);
         addChild(this._stretchBtn);
         addChild(this._returnBtn);
      }
      
      private function addEvent() : void
      {
         this._stretchBtn.addEventListener(MouseEvent.CLICK,this.__onStretchBtnClick);
         this._returnBtn.addEventListener(MouseEvent.CLICK,this.__onReturnClick);
      }
      
      private function __onStretchBtnClick(event:MouseEvent) : void
      {
         TweenLite.to(this,0.5,{"x":(this._stretchBtn.selected ? this._pos.y : this._pos.x)});
      }
      
      private function __onReturnClick(event:MouseEvent) : void
      {
         PyramidManager.instance.dispatchEvent(new PyramidEvent(PyramidEvent.RETURN_PYRAMID));
      }
      
      private function removeEvent() : void
      {
         this._stretchBtn.removeEventListener(MouseEvent.CLICK,this.__onStretchBtnClick);
         this._returnBtn.removeEventListener(MouseEvent.CLICK,this.__onReturnClick);
      }
      
      public function dispose() : void
      {
         ObjectUtils.disposeObject(this._bg);
         this._bg = null;
         ObjectUtils.disposeObject(this._stretchBtn);
         this._stretchBtn = null;
         ObjectUtils.disposeObject(this._returnBtn);
         this._returnBtn = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

