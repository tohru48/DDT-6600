package game.animations
{
   import game.view.map.MapView;
   
   public class DirectionMovingAnimation extends BaseAnimate
   {
      
      public static const UP:String = "up";
      
      public static const DOWN:String = "down";
      
      public static const LEFT:String = "left";
      
      public static const RIGHT:String = "right";
      
      private var _dir:String;
      
      public function DirectionMovingAnimation(dir:String)
      {
         super();
         this._dir = dir;
         _level = AnimationLevel.MIDDLE;
      }
      
      override public function cancel() : void
      {
         _finished = true;
      }
      
      override public function update(movie:MapView) : Boolean
      {
         switch(this._dir)
         {
            case RIGHT:
               movie.x -= 18;
               break;
            case LEFT:
               movie.x += 18;
               break;
            case UP:
               movie.y += 18;
               break;
            case DOWN:
               movie.y -= 18;
               break;
            default:
               return false;
         }
         return true;
      }
   }
}

