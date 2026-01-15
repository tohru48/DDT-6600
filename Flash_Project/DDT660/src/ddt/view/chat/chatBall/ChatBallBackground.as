package ddt.view.chat.chatBall
{
   import flash.display.MovieClip;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class ChatBallBackground extends MovieClip
   {
      
      private var paopaomc:MovieClip;
      
      private var _baseTextArea:Rectangle;
      
      private var _scale:Number;
      
      private var _direction:Point;
      
      public function ChatBallBackground(paopaoMC:MovieClip)
      {
         super();
         this._scale = 1;
         this.paopaomc = paopaoMC;
         addChild(this.paopaomc);
         this.paopaomc.bg.rtTopPoint.parent.removeChild(this.paopaomc.bg.rtTopPoint);
         this._baseTextArea = new Rectangle(this.paopaomc.bg.rtTopPoint.x,this.paopaomc.bg.rtTopPoint.y,this.paopaomc.bg.rtTopPoint.width,this.paopaomc.bg.rtTopPoint.height);
         this.direction = new Point(-1,-1);
      }
      
      public function fitSize(size:Point) : void
      {
         var tempScaleWidth:Number = size.x / this._baseTextArea.width;
         var tempScaleHeight:Number = size.y / this._baseTextArea.height;
         if(tempScaleWidth > tempScaleHeight)
         {
            this.scale = tempScaleWidth;
         }
         else
         {
            this.scale = tempScaleHeight;
         }
         this.update();
      }
      
      public function set direction(value:Point) : void
      {
         if(x == 0)
         {
            x = -1;
         }
         if(y == 0)
         {
            y = -1;
         }
         if(this._direction == value)
         {
            return;
         }
         this._direction = value;
         if(this._direction == null)
         {
            return;
         }
         if(this._direction.x > 0)
         {
            this.paopaomc.scaleX = this._scale;
         }
         else
         {
            this.paopaomc.scaleX = this._scale;
         }
         if(this._direction.y > 0)
         {
            this.paopaomc.scaleY = -this._scale;
         }
         else
         {
            this.paopaomc.scaleY = this._scale;
         }
         this.update();
      }
      
      public function get direction() : Point
      {
         return this._direction;
      }
      
      protected function set scale(value:Number) : void
      {
         if(this._scale == value)
         {
            return;
         }
         this._scale = value;
         if(this.paopaomc.scaleX > 0)
         {
            this.paopaomc.scaleX = value;
         }
         else
         {
            this.paopaomc.scaleX = -value;
         }
         if(this.paopaomc.scaleY > 0)
         {
            this.paopaomc.scaleY = value;
         }
         else
         {
            this.paopaomc.scaleY = -value;
         }
         this.update();
      }
      
      protected function get scale() : Number
      {
         return this._scale;
      }
      
      public function get textArea() : Rectangle
      {
         var textArea:Rectangle = new Rectangle();
         if(this.paopaomc.scaleX > 0)
         {
            textArea.x = this._baseTextArea.x * this.scale;
         }
         else
         {
            textArea.x = -this._baseTextArea.right * this.scale;
         }
         if(this.paopaomc.scaleY > 0)
         {
            textArea.y = this._baseTextArea.y * this.scale;
         }
         else
         {
            textArea.y = -this._baseTextArea.bottom * this.scale;
         }
         textArea.width = this._baseTextArea.width * Math.abs(this.scale);
         textArea.height = this._baseTextArea.height * Math.abs(this.scale);
         return textArea;
      }
      
      public function drawTextArea() : void
      {
      }
      
      private function update() : void
      {
      }
      
      public function dispose() : void
      {
         this._baseTextArea = null;
         this.paopaomc = null;
      }
   }
}

