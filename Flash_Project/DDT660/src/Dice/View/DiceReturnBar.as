package Dice.View
{
   import Dice.Controller.DiceController;
   import Dice.DiceManager;
   import Dice.Event.DiceEvent;
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
   
   public class DiceReturnBar extends Sprite implements Disposeable
   {
      
      private var _bg:Bitmap;
      
      private var _stretchBtn:SelectedButton;
      
      private var _returnBtn:BaseButton;
      
      private var _pos:Point;
      
      public function DiceReturnBar()
      {
         super();
         this.initialize();
         this.addEvent();
      }
      
      private function initialize() : void
      {
         this._bg = ComponentFactory.Instance.creatBitmap("asset.dice.returnBarBG");
         this._stretchBtn = ComponentFactory.Instance.creatComponentByStylename("asset.dice.returnBar.stretchBtn");
         this._returnBtn = ComponentFactory.Instance.creatComponentByStylename("asset.dice.returnBar.returnBtn");
         this._pos = ComponentFactory.Instance.creatCustomObject("asset.dice.returnBar.position");
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
         DiceController.Instance.isPlayDownMovie = false;
         DiceController.Instance.isFirst = true;
         DiceManager.Instance.dispatchEvent(new DiceEvent(DiceEvent.RETURN_DICE));
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

