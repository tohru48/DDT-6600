package game.animations
{
   import flash.display.DisplayObject;
   import flash.geom.Point;
   
   public class StrShockingLinearTween extends StrLinearTween
   {
      
      protected var shockingX:int;
      
      protected var shockingY:int;
      
      protected var shockingFreq:uint = 1;
      
      protected var life:uint;
      
      public function StrShockingLinearTween(data:TweenObject = null)
      {
         super(data);
         this.life = 0;
      }
      
      override public function get type() : String
      {
         return "StrShockingLinearTween";
      }
      
      override public function copyPropertyFromData(data:TweenObject) : void
      {
         this.shockingX = data.shockingX;
         this.shockingY = data.shockingY;
         duration = data.duration;
         target = data.target;
         speed = data.speed;
      }
      
      override public function update(movie:DisplayObject) : Point
      {
         var result:Point = super.update(movie);
         if(!result)
         {
            return null;
         }
         if(this.life == duration)
         {
            _isFinished = true;
            return result;
         }
         if(this.life == 0)
         {
            result.x += this.shockingX;
            this.shockingX = -this.shockingX;
            result.y += this.shockingY;
            this.shockingY = -this.shockingY;
         }
         ++this.life;
         if(this.life % this.shockingFreq == 0)
         {
            result.x += this.shockingX * 2;
            this.shockingX = -this.shockingX;
            result.y += this.shockingY * 2;
            this.shockingY = -this.shockingY;
         }
         return result;
      }
      
      override protected function get propertysNeed() : Array
      {
         return ["target","speed","shockingX","shockingY","shockingFreq"];
      }
   }
}

