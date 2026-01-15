package ddt.view
{
   import com.greensock.TweenLite;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.SelectedButton;
   import com.pickgliss.ui.core.Disposeable;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class SimpleReturnBar extends Sprite implements Disposeable
   {
      
      private var _bg:Bitmap;
      
      private var _stretchBtn:SelectedButton;
      
      private var _returnBtn:BaseButton;
      
      private var _returnCell:Function;
      
      public var stopTo:Number;
      
      public var moveTo:Number;
      
      public function SimpleReturnBar()
      {
         super();
         this.init();
         this.initEvent();
      }
      
      private function init() : void
      {
         this._bg = ComponentFactory.Instance.creatBitmap("asset.ddtcore.returnBarBG");
         this._stretchBtn = ComponentFactory.Instance.creatComponentByStylename("asset.simpleReturnBar.stretchBtn");
         this._returnBtn = ComponentFactory.Instance.creatComponentByStylename("asset.simpleReturnBar.returnBtn");
         addChild(this._bg);
         addChild(this._stretchBtn);
         addChild(this._returnBtn);
      }
      
      private function initEvent() : void
      {
         this._stretchBtn.addEventListener(MouseEvent.CLICK,this.__onStretchBtnClick);
         this._returnBtn.addEventListener(MouseEvent.CLICK,this.__onReturnClick);
      }
      
      private function __onStretchBtnClick(event:MouseEvent) : void
      {
         TweenLite.killTweensOf(this);
         TweenLite.to(this,0.5,{"x":(this._stretchBtn.selected ? this.moveTo : this.stopTo)});
      }
      
      private function __onReturnClick(event:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         if(this._returnCell != null)
         {
            this._returnCell();
         }
      }
      
      private function removeEvent() : void
      {
         this._stretchBtn.removeEventListener(MouseEvent.CLICK,this.__onStretchBtnClick);
         this._returnBtn.removeEventListener(MouseEvent.CLICK,this.__onReturnClick);
      }
      
      public function set returnCell(cell:Function) : void
      {
         this._returnCell = cell;
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         this._returnCell = null;
      }
   }
}

