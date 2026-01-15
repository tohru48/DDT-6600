package roomList.movingNotification
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.text.TextFormat;
   import flash.utils.Timer;
   
   public class MovingNotificationView extends Sprite
   {
      
      private var _list:Array;
      
      private var _mask:Shape;
      
      private var _currentIndex:uint;
      
      private var _currentMovingFFT:FilterFrameText;
      
      private var _textFields:Vector.<FilterFrameText> = new Vector.<FilterFrameText>();
      
      private var _keyWordTF:TextFormat;
      
      private var _timer:Timer;
      
      public function MovingNotificationView()
      {
         super();
         this.init();
      }
      
      private function init() : void
      {
         this._currentIndex = 0;
         this._timer = new Timer(15000);
         scrollRect = ComponentFactory.Instance.creatCustomObject("roomList.MovingNotification.DisplayRect");
         this._keyWordTF = ComponentFactory.Instance.model.getSet("roomList.MovingNotificationKeyWordTF");
      }
      
      public function get list() : Array
      {
         return this._list;
      }
      
      public function set list(value:Array) : void
      {
         if(Boolean(value) && this._list != value)
         {
            this._list = value;
            this.updateTextFields();
            this.updateCurrentTTF();
         }
         if(Boolean(this._list))
         {
            this._timer.addEventListener(TimerEvent.TIMER,this.stopEnterFrame);
            addEventListener(Event.ENTER_FRAME,this.moveFFT);
         }
      }
      
      private function stopEnterFrame(event:TimerEvent) : void
      {
         this._timer.stop();
         addEventListener(Event.ENTER_FRAME,this.moveFFT);
      }
      
      private function clearTextFields() : void
      {
         var textField:FilterFrameText = this._textFields.shift();
         while(textField != null)
         {
            ObjectUtils.disposeObject(textField);
            textField = this._textFields.shift();
         }
      }
      
      private function updateTextFields() : void
      {
         var tf:FilterFrameText = null;
         var str:String = null;
         var left:Vector.<uint> = null;
         var right:Vector.<uint> = null;
         this.clearTextFields();
         for(var i:int = 0; i < this._list.length; i++)
         {
            tf = ComponentFactory.Instance.creatComponentByStylename("asset.ddtroomList.MovingNotificationText");
            str = this._list[i];
            left = new Vector.<uint>();
            right = new Vector.<uint>();
            while(str.indexOf("{") > -1)
            {
               left.push(str.indexOf("{"));
               right.push(str.indexOf("}"));
               str = str.replace("{","");
               str = str.replace("}","");
            }
            tf.text = str;
            while(left.length > 0)
            {
               tf.setTextFormat(this._keyWordTF,left.shift(),right.shift() - 1);
            }
            this._textFields.push(tf);
            if(!contains(tf))
            {
               addChildAt(tf,0);
            }
         }
      }
      
      private function updateCurrentTTF() : void
      {
         this._currentIndex = Math.round(Math.random() * (this._list.length - 1));
         this._currentMovingFFT = this._textFields[this._currentIndex];
      }
      
      private function moveFFT(e:Event) : void
      {
         if(Boolean(this._currentMovingFFT))
         {
            this._currentMovingFFT.y -= 1;
            if(this._currentMovingFFT.y == 0)
            {
               this._timer.start();
               removeEventListener(Event.ENTER_FRAME,this.moveFFT);
            }
            if(this._currentMovingFFT.y < -(this._currentMovingFFT.textHeight + 2))
            {
               this._currentMovingFFT.y = 22;
               this.updateCurrentTTF();
            }
         }
      }
      
      public function dispose() : void
      {
         removeEventListener(Event.ENTER_FRAME,this.moveFFT);
         this._timer.stop();
         this.clearTextFields();
         ObjectUtils.disposeAllChildren(this);
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

