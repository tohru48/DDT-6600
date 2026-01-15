package ddt.view.chat.chatBall
{
   import flash.text.StyleSheet;
   import flash.text.TextFieldAutoSize;
   import road7th.utils.StringHelper;
   
   public class ChatBallTextAreaNPC extends ChatBallTextAreaBase
   {
      
      private var _plainString:String;
      
      protected const maxTxtWidth:int = 140;
      
      public function ChatBallTextAreaNPC()
      {
         super();
      }
      
      override protected function initView() : void
      {
         super.initView();
      }
      
      override public function set text(value:String) : void
      {
         clear();
         _text = value;
         _text = "<p>" + _text + "</p>";
         this._plainString = StringHelper.rePlaceHtmlTextField(_text);
         this.setFormat();
         tf.autoSize = TextFieldAutoSize.LEFT;
         tf.width = this.maxTxtWidth;
         tf.htmlText = _text;
         this.fitScale();
      }
      
      protected function setFormat() : void
      {
         var style:StyleSheet = new StyleSheet();
         style.parseCSS("p{font-size:12px;text-align:center;font-weight:normal;}" + ".red{color:#FF0000}" + ".blue{color:#0000FF}" + ".green{color:#00FF00}");
         tf.styleSheet = style;
      }
      
      protected function fitScale() : void
      {
         var length:int = 0;
         var count:int = 0;
         var line:int = tf.numLines;
         for(var i:int = 0; i < line; i++)
         {
            length = tf.getLineLength(i) + 2;
            if(count < length)
            {
               count = length;
            }
         }
         if(count < 8)
         {
            tf.width = count * 17;
         }
         else
         {
            tf.width = this.maxTxtWidth;
         }
      }
   }
}

