package ddt.view.scenePathSearcher
{
   import ddt.utils.Geometry;
   import flash.display.Sprite;
   import flash.geom.Point;
   
   public class PathMapHitTester implements PathIHitTester
   {
      
      private var mc:Sprite;
      
      public function PathMapHitTester(mesh:Sprite)
      {
         super();
         this.mc = mesh;
      }
      
      public function isHit(point:Point) : Boolean
      {
         var g:Point = this.mc.localToGlobal(point);
         return this.mc.hitTestPoint(g.x,g.y,true);
      }
      
      public function getNextMoveAblePoint(point:Point, angle:Number, step:Number, max:Number) : Point
      {
         var dist:Number = 0;
         while(this.isHit(point))
         {
            point = Geometry.nextPoint(point,angle,step);
            dist += step;
            if(dist > max)
            {
               return null;
            }
         }
         return point;
      }
   }
}

