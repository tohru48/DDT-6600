package ddt.view.scenePathSearcher
{
   import flash.geom.Point;
   
   public class PathNode
   {
      
      public var costFromStart:int = 0;
      
      public var costToGoal:int = 0;
      
      public var totalCost:int = 0;
      
      public var location:Point;
      
      public var parent:PathNode;
      
      public function PathNode()
      {
         super();
      }
      
      public function equals(node:PathNode) : Boolean
      {
         return node.location.equals(this.location);
      }
      
      public function toString() : String
      {
         return "x=" + this.location.x + " y=" + this.location.y + " G=" + this.costFromStart + " H=" + this.costToGoal + " F=" + this.totalCost;
      }
   }
}

