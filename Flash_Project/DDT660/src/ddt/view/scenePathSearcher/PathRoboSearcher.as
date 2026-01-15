package ddt.view.scenePathSearcher
{
   import ddt.utils.Geometry;
   import flash.geom.Point;
   
   public class PathRoboSearcher implements PathIPathSearcher
   {
      
      private static var LEFT:Number = -1;
      
      private static var RIGHT:Number = 1;
      
      private var step:Number;
      
      private var maxCount:Number;
      
      private var maxDistance:Number;
      
      private var stepTurnNum:Number;
      
      public function PathRoboSearcher(step:Number, maxDistance:Number, num:Number = 4)
      {
         super();
         this.step = step;
         this.maxDistance = maxDistance;
         this.maxCount = Math.ceil(maxDistance / step) * 2;
         this.stepTurnNum = num;
      }
      
      public function setStepTurnNum(num:Number) : void
      {
         this.stepTurnNum = num;
      }
      
      public function search(from:Point, end:Point, hittest:PathIHitTester) : Array
      {
         var notGoPath:Array = [from,from];
         if(from.equals(end))
         {
            return notGoPath;
         }
         var leftPath:Array = new Array();
         var rightPath:Array = new Array();
         var left:Boolean = this.searchWithWish(from,end,hittest,LEFT,leftPath);
         var right:Boolean = this.searchWithWish(from,end,hittest,RIGHT,rightPath);
         if(left && right)
         {
            if(leftPath.length < rightPath.length)
            {
               return leftPath;
            }
            return rightPath;
         }
         if(left)
         {
            return leftPath;
         }
         if(right)
         {
            return rightPath;
         }
         return notGoPath;
      }
      
      private function searchWithWish(from:Point, tto:Point, tester:PathIHitTester, wish:Number, nodes:Array) : Boolean
      {
         var midTo:Point = null;
         var midSearch:Boolean = false;
         var reverseNodes:Array = null;
         var success:Boolean = false;
         var lastZhuanze:Point = null;
         var minReplaceD:Number = NaN;
         var i:Number = NaN;
         var rp:Point = null;
         if(tester.isHit(tto))
         {
            tto = this.findReversseNearestBlankPoint(from,tto,tester);
            if(tto == null)
            {
               return false;
            }
            if(tester.isHit(from))
            {
               nodes.push(from);
               nodes.push(tto);
               return true;
            }
         }
         else if(tester.isHit(from))
         {
            midTo = this.findReversseNearestBlankPoint(tto,from,tester);
            if(midTo == null)
            {
               return false;
            }
            midSearch = this.searchWithWish(midTo,tto,tester,wish,nodes);
            if(midSearch)
            {
               nodes.splice(0,0,from);
               return true;
            }
            return false;
         }
         if(Point.distance(from,tto) > this.maxDistance)
         {
            nodes.push(from);
            tto = this.findFarestBlankPoint(from,tto,tester);
            if(tto == null)
            {
               return false;
            }
            nodes.push(tto);
            return true;
         }
         var aheadSearch:Boolean = this.doSearchWithWish(from,tto,tester,wish,nodes);
         if(!aheadSearch)
         {
            return false;
         }
         if(nodes.length > 4)
         {
            reverseNodes = new Array();
            success = this.doSearchWithWish(tto,nodes[0],tester,0 - wish,reverseNodes);
            if(success)
            {
               lastZhuanze = Point(reverseNodes[reverseNodes.length - 2]);
               minReplaceD = this.step;
               for(i = 1; i < nodes.length - 1; i++)
               {
                  rp = Point(nodes[i]);
                  if(Point.distance(rp,lastZhuanze) < minReplaceD)
                  {
                     nodes.splice(1,i,lastZhuanze);
                     return true;
                  }
               }
            }
         }
         return true;
      }
      
      private function findFarestBlankPoint(from:Point, tto:Point, t:PathIHitTester) : Point
      {
         var tp:Point = null;
         if(t.isHit(from))
         {
            return this.findReversseNearestBlankPoint(tto,from,t);
         }
         var heading:Number = this.countHeading(from,tto);
         var dist:Number = Point.distance(from,tto);
         var lastFrom:Point = from;
         while(!t.isHit(from))
         {
            lastFrom = from;
            from = Geometry.nextPoint(from,heading,this.step);
            dist -= this.step;
            if(dist <= 0)
            {
               return null;
            }
         }
         from = lastFrom;
         var turn:Number = Math.PI / 8;
         for(var i:Number = 1; i < 8; i++)
         {
            tp = Geometry.nextPoint(from,heading + i * turn,this.step * 2);
            if(!t.isHit(tp))
            {
               return tp;
            }
            tp = Geometry.nextPoint(from,heading - i * turn,this.step * 2);
            if(!t.isHit(tp))
            {
               return tp;
            }
         }
         return from;
      }
      
      private function findReversseNearestBlankPoint(from:Point, tto:Point, t:PathIHitTester) : Point
      {
         var tp:Point = null;
         var heading:Number = this.countHeading(tto,from);
         var dist:Number = Point.distance(tto,from);
         while(t.isHit(tto))
         {
            tto = Geometry.nextPoint(tto,heading,this.step);
            dist -= this.step;
            if(dist <= 0)
            {
               return null;
            }
         }
         var turn:Number = Math.PI / 12;
         heading += Math.PI;
         for(var i:Number = 1; i < 12; i++)
         {
            tp = Geometry.nextPoint(tto,heading + i * turn,this.step * 2);
            if(!t.isHit(tp))
            {
               return tp;
            }
            tp = Geometry.nextPoint(tto,heading - i * turn,this.step * 2);
            if(!t.isHit(tp))
            {
               return tp;
            }
         }
         return tto;
      }
      
      private function doSearchWithWish(from:Point, tto:Point, tester:PathIHitTester, wish:Number, nodes:Array) : Boolean
      {
         var headingToEnd:Number = NaN;
         var dir:Number = NaN;
         var bb:Number = NaN;
         var tp:Point = null;
         var lastFrom:Point = null;
         var distanceToEnd:Number = NaN;
         var finded:Boolean = false;
         var i:Number = NaN;
         nodes.push(from);
         var angle:Number = wish * Math.PI / this.stepTurnNum;
         var startDelta:Number = wish * Math.PI / 2;
         var count:Number = 1;
         var maxDistance:Number = this.step;
         var heading:Number = this.countHeading(from,tto);
         var lastDistanceToEnd:Number = Point.distance(from,tto);
         while(true)
         {
            if(!(lastDistanceToEnd > maxDistance && count++ < this.maxCount))
            {
               if(count <= this.maxCount)
               {
                  nodes.push(tto);
                  return true;
               }
               return false;
            }
            headingToEnd = this.countHeading(from,tto);
            dir = heading - startDelta;
            bb = this.bearing(headingToEnd,dir);
            if(wish > 0 && bb < 0 || wish < 0 && bb > 0)
            {
               dir = headingToEnd;
            }
            tp = Geometry.nextPoint(from,dir,this.step);
            lastFrom = from;
            if(tester.isHit(tp))
            {
               finded = false;
               for(i = 2; i < this.stepTurnNum * 2; i++)
               {
                  dir += angle;
                  tp = Geometry.nextPoint(from,dir,this.step);
                  if(!tester.isHit(tp))
                  {
                     from = tp;
                     distanceToEnd = Point.distance(from,tto);
                     finded = true;
                     break;
                  }
               }
               if(!finded)
               {
                  break;
               }
            }
            else
            {
               from = tp;
               distanceToEnd = Point.distance(from,tto);
            }
            if(Math.abs(this.bearing(heading,dir)) > 0.01)
            {
               nodes.push(lastFrom);
               heading = dir;
            }
            lastDistanceToEnd = distanceToEnd;
         }
         nodes.splice(0);
         return false;
      }
      
      private function countHeading(p1:Point, p2:Point) : Number
      {
         return Math.atan2(p2.y - p1.y,p2.x - p1.x);
      }
      
      private function bearing(base:Number, heading:Number) : Number
      {
         var b:Number = heading - base;
         b = (b + Math.PI * 4) % (Math.PI * 2);
         if(b < -Math.PI)
         {
            b += Math.PI * 2;
         }
         else if(b > Math.PI)
         {
            b -= Math.PI * 2;
         }
         return b;
      }
   }
}

