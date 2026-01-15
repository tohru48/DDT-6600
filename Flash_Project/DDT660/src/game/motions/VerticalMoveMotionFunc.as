package game.motions
{
   public class VerticalMoveMotionFunc extends BaseMotionFunc
   {
      
      private var speed:int;
      
      public function VerticalMoveMotionFunc(paramsObject:Object)
      {
         super(paramsObject);
      }
      
      override public function getVectorByTime(t:int) : Object
      {
         _result = new Object();
         _result.x = this.speed;
         return _result;
      }
   }
}

