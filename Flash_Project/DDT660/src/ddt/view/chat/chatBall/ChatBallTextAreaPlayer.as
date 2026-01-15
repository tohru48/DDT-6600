package ddt.view.chat.chatBall
{
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   
   public class ChatBallTextAreaPlayer extends ChatBallTextAreaBase
   {
      
      private const _SMALL_W:int = 80;
      
      private const _MIDDLE_W:int = 100;
      
      private const _BIG_H:int = 70;
      
      private const _BIG_W:int = 120;
      
      protected var hiddenTF:TextField;
      
      private var _textWidth:int;
      
      private var _indexOfEnd:int;
      
      public function ChatBallTextAreaPlayer()
      {
         super();
      }
      
      override protected function initView() : void
      {
         tf.autoSize = TextFieldAutoSize.LEFT;
         tf.multiline = true;
         tf.wordWrap = true;
         addChild(tf);
         tf.x = 0;
         tf.y = 0;
      }
      
      override public function set text(value:String) : void
      {
         tf.htmlText = value;
         value = tf.text;
         this.chooseSize(value);
         tf.text = value;
         tf.width = this._textWidth;
         if(tf.height >= this._BIG_H)
         {
            tf.height = this._BIG_H;
         }
         this._indexOfEnd = 0;
         if(tf.numLines > 4)
         {
            this._indexOfEnd = tf.getLineOffset(4) - 3;
            value = value.substring(0,this._indexOfEnd) + "...";
         }
         tf.text = value;
      }
      
      protected function chooseSize(message:String) : void
      {
         this._indexOfEnd = -1;
         var format:TextFormat = tf.defaultTextFormat;
         this.hiddenTF = new TextField();
         this.setTextField(this.hiddenTF);
         format.letterSpacing = 1;
         this.hiddenTF.defaultTextFormat = format;
         format.align = TextFormatAlign.CENTER;
         tf.defaultTextFormat = format;
         this.hiddenTF.text = message;
         var _width:int = this.hiddenTF.textWidth;
         if(_width < this._SMALL_W)
         {
            this._textWidth = this._SMALL_W;
            return;
         }
         if(_width < this._SMALL_W * 2 + 10)
         {
            this._textWidth = this._MIDDLE_W;
            return;
         }
         this._textWidth = this._BIG_W;
      }
      
      override public function get width() : Number
      {
         return tf.width;
      }
      
      override public function get height() : Number
      {
         return tf.height;
      }
      
      public function setTextField(tf:TextField) : void
      {
         tf.autoSize = TextFieldAutoSize.LEFT;
      }
      
      override public function dispose() : void
      {
         this.hiddenTF = null;
      }
   }
}

