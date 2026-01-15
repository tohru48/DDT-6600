package ddt.view.scenePathSearcher
{
   import flash.events.EventDispatcher;
   import flash.geom.Point;
   
   public class SceneScene extends EventDispatcher
   {
      
      private var _hitTester:PathIHitTester;
      
      private var _pathSearcher:PathIPathSearcher;
      
      private var _x:Number;
      
      private var _y:Number;
      
      public function SceneScene()
      {
         super();
         this._pathSearcher = new PathRoboSearcher(18,1000,8);
         this._x = 0;
         this._y = 0;
      }
      
      public function get HitTester() : PathIHitTester
      {
         return this._hitTester;
      }
      
      public function get x() : Number
      {
         return this._x;
      }
      
      public function get y() : Number
      {
         return this._y;
      }
      
      public function set position(value:Point) : void
      {
         if(value.x != this._x || value.y != this._y)
         {
            this._x = value.x;
            this._y = value.y;
         }
      }
      
      public function get position() : Point
      {
         return new Point(this._x,this._y);
      }
      
      public function setPathSearcher(path:PathIPathSearcher) : void
      {
         this._pathSearcher = path;
      }
      
      public function setHitTester(tester:PathIHitTester) : void
      {
         this._hitTester = tester;
      }
      
      public function hit(local:Point) : Boolean
      {
         return this._hitTester.isHit(local);
      }
      
      public function searchPath(from:Point, to:Point) : Array
      {
         return this._pathSearcher.search(from,to,this._hitTester);
      }
      
      public function localToGlobal(point:Point) : Point
      {
         return new Point(point.x + this._x,point.y + this._y);
      }
      
      public function globalToLocal(point:Point) : Point
      {
         return new Point(point.x - this._x,point.y - this._y);
      }
      
      public function dispose() : void
      {
         this._hitTester = null;
         this._pathSearcher = null;
      }
   }
}

