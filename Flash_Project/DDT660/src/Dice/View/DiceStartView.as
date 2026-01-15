package Dice.View
{
   import Dice.Controller.DiceController;
   import Dice.Event.DiceEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   
   public class DiceStartView extends Sprite implements Disposeable
   {
      
      private var _type:int;
      
      private var _result:int;
      
      private var _leftArr:Array = [];
      
      private var _rightArr:Array = [];
      
      private var _rule:Array = [];
      
      private var _left:int;
      
      private var _right:int;
      
      public function DiceStartView()
      {
         super();
         this.preInitialize();
      }
      
      public function play(type:int, result:int) : void
      {
         this._type = type;
         this._result = result;
         if(this._type == 1)
         {
            this._left = int(Math.random() * 6) + 1;
            if(this._left >= result)
            {
               this._left = 1;
            }
            if(this._result - this._left >= 7)
            {
               this._right = this._result - 6;
               this._left = this._result - this._right;
            }
            else
            {
               this._right = this._result - this._left;
            }
            this._leftArr[this._left - 1].addEventListener(Event.ENTER_FRAME,this.__onEnterFrame);
            this._leftArr[this._left - 1].gotoAndPlay(2);
            this._rightArr[this._right - 1].gotoAndPlay(2);
            addChild(this._leftArr[this._left - 1]);
            addChild(this._rightArr[this._right - 1]);
         }
         else
         {
            this._left = this._result;
            this._leftArr[this._left - 1].addEventListener(Event.ENTER_FRAME,this.__onEnterFrame);
            this._leftArr[this._left - 1].gotoAndPlay(2);
            addChild(this._leftArr[this._left - 1]);
         }
      }
      
      private function __onEnterFrame(event:Event) : void
      {
         var _target:MovieClip = event.currentTarget as MovieClip;
         if(_target.currentLabel == "endLabel")
         {
            DiceController.Instance.dispatchEvent(new DiceEvent(DiceEvent.MOVIE_FINISH));
            _target.removeEventListener(Event.ENTER_FRAME,this.__onEnterFrame);
            _target.stop();
         }
      }
      
      public function removeAllMovie() : void
      {
         for(var i:int = 0; i < this._leftArr.length; i++)
         {
            if(Boolean(this._leftArr[i].parent))
            {
               removeChild(this._leftArr[i]);
            }
            if(Boolean(this._rightArr[i].parent))
            {
               removeChild(this._rightArr[i]);
            }
         }
      }
      
      private function preInitialize() : void
      {
         for(var i:int = 0; i < 6; i++)
         {
            this._leftArr[i] = ComponentFactory.Instance.creat("asset.dice.movie" + (i + 1));
            this._leftArr[i].x = 50;
            this._rightArr[i] = ComponentFactory.Instance.creat("asset.dice.movie" + (i + 7));
         }
      }
      
      public function dispose() : void
      {
         ObjectUtils.disposeObject(this._rightArr[0]);
         this._rightArr[0] = null;
         ObjectUtils.disposeObject(this._rightArr[1]);
         this._rightArr[1] = null;
         ObjectUtils.disposeObject(this._rightArr[2]);
         this._rightArr[2] = null;
         ObjectUtils.disposeObject(this._rightArr[3]);
         this._rightArr[3] = null;
         ObjectUtils.disposeObject(this._rightArr[4]);
         this._rightArr[4] = null;
         ObjectUtils.disposeObject(this._rightArr[5]);
         this._rightArr[5] = null;
         ObjectUtils.disposeObject(this._leftArr[0]);
         this._leftArr[0] = null;
         ObjectUtils.disposeObject(this._leftArr[1]);
         this._leftArr[1] = null;
         ObjectUtils.disposeObject(this._leftArr[2]);
         this._leftArr[2] = null;
         ObjectUtils.disposeObject(this._leftArr[3]);
         this._leftArr[3] = null;
         ObjectUtils.disposeObject(this._leftArr[4]);
         this._leftArr[4] = null;
         ObjectUtils.disposeObject(this._leftArr[5]);
         this._leftArr[5] = null;
      }
   }
}

