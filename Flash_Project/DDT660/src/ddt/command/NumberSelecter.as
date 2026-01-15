package ddt.command
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.Image;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.SoundManager;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.ui.Keyboard;
   
   public class NumberSelecter extends Sprite implements Disposeable
   {
      
      public static const NUMBER_CLOSE:String = "number_close";
      
      public static const NUMBER_ENTER:String = "number_enter";
      
      private var _minNum:int;
      
      private var _maxNum:int;
      
      private var _num:int;
      
      private var _reduceBtn:BaseButton;
      
      private var _addBtn:BaseButton;
      
      private var numText:FilterFrameText;
      
      private var _ennable:Boolean = true;
      
      public function NumberSelecter(min:int = 1, max:int = 99)
      {
         super();
         this._minNum = min;
         this._maxNum = max;
         this.init();
         this.initEvents();
      }
      
      public function get ennable() : Boolean
      {
         return this._ennable;
      }
      
      public function set ennable(value:Boolean) : void
      {
         this._ennable = value;
         if(!this._ennable)
         {
            this._reduceBtn.enable = this._addBtn.enable = this._ennable;
            this.numText.mouseEnabled = false;
         }
      }
      
      private function init() : void
      {
         var bg:Image = ComponentFactory.Instance.creatComponentByStylename("ddtcore.NumberSelecterTextBg");
         addChild(bg);
         this._reduceBtn = ComponentFactory.Instance.creatComponentByStylename("ddtcore.NumberSelecterDownButton");
         addChild(this._reduceBtn);
         this._addBtn = ComponentFactory.Instance.creatComponentByStylename("ddtcore.NumberSelecterUpButton");
         addChild(this._addBtn);
         this.numText = ComponentFactory.Instance.creatComponentByStylename("ddtcore.NumberSelecterText");
         addChild(this.numText);
         this._num = 1;
         this.updateView();
      }
      
      private function initEvents() : void
      {
         this._reduceBtn.addEventListener(MouseEvent.CLICK,this.reduceBtnClickHandler);
         this._addBtn.addEventListener(MouseEvent.CLICK,this.addBtnClickHandler);
         this.numText.addEventListener(MouseEvent.CLICK,this.clickHandler);
         this.numText.addEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDown);
         this.numText.addEventListener(Event.CHANGE,this.changeHandler);
         addEventListener(Event.ADDED_TO_STAGE,this.addtoStageHandler);
      }
      
      private function removeEvents() : void
      {
         this._reduceBtn.removeEventListener(MouseEvent.CLICK,this.reduceBtnClickHandler);
         this._addBtn.removeEventListener(MouseEvent.CLICK,this.addBtnClickHandler);
         this.numText.removeEventListener(MouseEvent.CLICK,this.clickHandler);
         this.numText.removeEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDown);
         this.numText.removeEventListener(Event.CHANGE,this.changeHandler);
         removeEventListener(Event.ADDED_TO_STAGE,this.addtoStageHandler);
      }
      
      private function addtoStageHandler(e:Event) : void
      {
         this.setFocus();
      }
      
      private function clickHandler(evt:MouseEvent) : void
      {
         evt.stopImmediatePropagation();
      }
      
      private function changeHandler(evt:Event) : void
      {
         this.number = int(this.numText.text);
      }
      
      private function onKeyDown(evt:KeyboardEvent) : void
      {
         SoundManager.instance.play("008");
         evt.stopImmediatePropagation();
         if(evt.keyCode == Keyboard.ENTER)
         {
            this.number = int(this.numText.text);
            dispatchEvent(new Event(NUMBER_ENTER,true));
         }
         if(evt.keyCode == Keyboard.ESCAPE)
         {
            dispatchEvent(new Event(NUMBER_CLOSE));
         }
      }
      
      private function reduceBtnClickHandler(evt:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this.number -= 1;
      }
      
      private function addBtnClickHandler(evt:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this.number += 1;
      }
      
      public function setFocus() : void
      {
         if(stage.focus != this.numText)
         {
            this.numText.text = "";
            this.numText.appendText(String(this._num));
            stage.focus = this.numText;
         }
      }
      
      public function set maximum(value:int) : void
      {
         this._maxNum = value;
         this.number = this._num;
      }
      
      public function set minimum(value:int) : void
      {
         this._minNum = value;
         this.number = this._num;
      }
      
      public function set number(value:int) : void
      {
         if(value < this._minNum)
         {
            value = this._minNum;
         }
         else if(value > this._maxNum)
         {
            value = this._maxNum;
         }
         this._num = value;
         this.updateView();
         dispatchEvent(new Event(Event.CHANGE));
      }
      
      public function get number() : int
      {
         return this._num;
      }
      
      private function updateView() : void
      {
         this.numText.text = this._num.toString();
         this._reduceBtn.enable = this._num > this._minNum;
         this._addBtn.enable = this._num < this._maxNum;
      }
      
      public function dispose() : void
      {
         this.removeEvents();
         if(Boolean(this._reduceBtn))
         {
            ObjectUtils.disposeObject(this._reduceBtn);
         }
         this._reduceBtn = null;
         if(Boolean(this._addBtn))
         {
            ObjectUtils.disposeObject(this._addBtn);
         }
         this._addBtn = null;
         if(Boolean(this.numText))
         {
            ObjectUtils.disposeObject(this.numText);
         }
         this.numText = null;
         ObjectUtils.disposeAllChildren(this);
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

