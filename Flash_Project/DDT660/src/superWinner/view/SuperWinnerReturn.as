package superWinner.view
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
   import superWinner.event.SuperWinnerEvent;
   import superWinner.manager.SuperWinnerManager;
   
   public class SuperWinnerReturn extends Sprite implements Disposeable
   {
      
      private var _bg:Bitmap;
      
      private var _stretchBtn:SelectedButton;
      
      private var _returnBtn:BaseButton;
      
      private var _pos:Point;
      
      public function SuperWinnerReturn()
      {
         super();
         this.initialize();
         this.addEvent();
      }
      
      private function initialize() : void
      {
         this._bg = ComponentFactory.Instance.creatBitmap("asset.superWinner.returnBarBG");
         this._stretchBtn = ComponentFactory.Instance.creatComponentByStylename("asset.superWinner.returnBar.stretchBtn");
         this._returnBtn = ComponentFactory.Instance.creatComponentByStylename("asset.superWinner.returnBar.returnBtn");
         this._pos = ComponentFactory.Instance.creatCustomObject("asset.superWinner.returnBar.position");
         addChild(this._bg);
         addChild(this._stretchBtn);
         addChild(this._returnBtn);
      }
      
      public function dispachReturnEvent() : void
      {
         this._returnBtn.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
      }
      
      private function addEvent() : void
      {
         this._stretchBtn.addEventListener(MouseEvent.CLICK,this.__onStretchBtnClick);
         this._returnBtn.addEventListener(MouseEvent.CLICK,this.__onReturnClick);
      }
      
      private function __onStretchBtnClick(event:MouseEvent) : void
      {
         var tl:TweenLite = null;
         tl = TweenLite.to(this,0.5,{
            "x":(this._stretchBtn.selected ? this._pos.y : this._pos.x),
            "onComplete":function():void
            {
               tl.kill();
            }
         });
      }
      
      private function __onReturnClick(event:MouseEvent) : void
      {
         SuperWinnerManager.instance.dispatchEvent(new SuperWinnerEvent(SuperWinnerEvent.RETURN_HALL));
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

