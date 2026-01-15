package giftSystem.element
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.TextInput;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class ChooseNum extends Sprite implements Disposeable
   {
      
      public static const NUMBER_IS_CHANGE:String = "numberIsChange";
      
      private var _leftBtn:BaseButton;
      
      private var _rightBtn:BaseButton;
      
      private var _numShow:TextInput;
      
      private var _number:int;
      
      public function ChooseNum()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      public function set number(value:int) : void
      {
         this._number = value;
         this._numShow.text = this._number.toString();
         dispatchEvent(new Event(NUMBER_IS_CHANGE));
      }
      
      public function get number() : int
      {
         return this._number;
      }
      
      private function initView() : void
      {
         this._leftBtn = ComponentFactory.Instance.creatComponentByStylename("core.ddtshop.ShopDownButton");
         this._rightBtn = ComponentFactory.Instance.creatComponentByStylename("core.ddtshop.ShopUpButton");
         PositionUtils.setPos(this._leftBtn,"giftSystem.leftBtnPos");
         PositionUtils.setPos(this._rightBtn,"giftSystem.rightBtnPos");
         this._numShow = ComponentFactory.Instance.creatComponentByStylename("ChooseNum.numShow");
         this._numShow.textField.restrict = "0-9";
         this._numShow.textField.maxChars = 4;
         addChild(this._leftBtn);
         addChild(this._rightBtn);
         addChild(this._numShow);
         this.number = 1;
      }
      
      private function drawSprit() : Sprite
      {
         var sp:Sprite = null;
         sp = new Sprite();
         sp.graphics.beginFill(0,0);
         sp.graphics.drawRect(0,0,28,28);
         sp.graphics.endFill();
         sp.buttonMode = true;
         return sp;
      }
      
      private function initEvent() : void
      {
         this._leftBtn.addEventListener(MouseEvent.CLICK,this.__leftClick);
         this._rightBtn.addEventListener(MouseEvent.CLICK,this.__rightClick);
         this._numShow.addEventListener(Event.CHANGE,this.__numberChange);
      }
      
      private function __rightClick(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(this.number == 9999)
         {
            return;
         }
         ++this.number;
      }
      
      private function __leftClick(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(this.number == 1)
         {
            return;
         }
         --this.number;
      }
      
      private function removeEvent() : void
      {
         this._leftBtn.removeEventListener(MouseEvent.CLICK,this.__leftClick);
         this._rightBtn.removeEventListener(MouseEvent.CLICK,this.__rightClick);
         this._numShow.addEventListener(Event.CHANGE,this.__numberChange);
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         ObjectUtils.disposeAllChildren(this);
         this._leftBtn = null;
         this._rightBtn = null;
         this._numShow = null;
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
      
      protected function __numberChange(event:Event) : void
      {
         if(this._numShow.text == "" || parseInt(this._numShow.text) == 0)
         {
            this.number = 1;
         }
         else
         {
            this.number = parseInt(this._numShow.text);
         }
      }
   }
}

