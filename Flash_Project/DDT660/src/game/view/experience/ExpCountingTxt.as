package game.view.experience
{
   import com.greensock.TweenLite;
   import com.greensock.easing.Quad;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.SoundManager;
   import flash.display.Sprite;
   import flash.events.Event;
   
   public class ExpCountingTxt extends Sprite implements Disposeable
   {
      
      protected var _text:*;
      
      protected var _value:Number;
      
      protected var _targetValue:Number;
      
      protected var _style:String;
      
      protected var _filters:Array;
      
      protected var _plus:String;
      
      public var maxValue:int = 2147483647;
      
      public function ExpCountingTxt(textStyle:String, textFilterStr:String)
      {
         super();
         this._style = textStyle;
         this._filters = textFilterStr.split(",");
         this.init();
      }
      
      public function get value() : Number
      {
         return this._value;
      }
      
      public function set value(value:Number) : void
      {
         this._value = value;
      }
      
      public function get targetValue() : Number
      {
         return this._targetValue;
      }
      
      protected function init() : void
      {
         this._text = ComponentFactory.Instance.creatComponentByStylename(this._style);
         this._value = 0;
         this._targetValue = 0;
         this._plus = "+";
         this._text.text = this._plus + String(this._value) + " ";
         var arr:Array = [];
         for(var i:int = 0; i < this._filters.length; i++)
         {
            arr.push(ComponentFactory.Instance.model.getSet(this._filters[i]));
         }
         this._text.filters = arr;
         addChild(this._text);
      }
      
      public function updateNum(newValue:Number, isAdd:Boolean = true) : void
      {
         if(isAdd)
         {
            this._targetValue += newValue;
         }
         else
         {
            this._targetValue = newValue;
         }
         if(this._targetValue > this.maxValue)
         {
            this._targetValue = this.maxValue;
         }
         TweenLite.killTweensOf(this);
         TweenLite.to(this,0.5,{
            "value":this._targetValue,
            "ease":Quad.easeOut,
            "onUpdate":this.updateText,
            "onComplete":this.complete
         });
         dispatchEvent(new Event(Event.CHANGE));
      }
      
      protected function updateText() : void
      {
         var tempStr:String = null;
         if(!this._text)
         {
            return;
         }
         var str:String = this._text.text;
         if(this._value < 0)
         {
            tempStr = String(Math.round(this._value)) + " ";
         }
         else
         {
            tempStr = this._plus + String(Math.round(this._value)) + " ";
         }
         if(Boolean(tempStr.indexOf("+")) && Boolean(tempStr.indexOf("-")))
         {
            tempStr = tempStr.replace("-");
         }
         if(str != "+0 " && tempStr != str)
         {
            SoundManager.instance.play("143");
         }
         this._text.text = tempStr;
      }
      
      public function complete(e:Event = null) : void
      {
         this._value = this._targetValue;
         this.updateText();
         dispatchEvent(new Event(Event.COMPLETE));
      }
      
      public function dispose() : void
      {
         ObjectUtils.disposeObject(this._text);
         this._text = null;
         this._filters = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

