package ddt.view.scenePathSearcher
{
   import flash.geom.Point;
   
   public class PathAstarSearcher implements PathIPathSearcher
   {
      
      private var open_list:Array;
      
      private var close_list:Array;
      
      private var path_arr:Array;
      
      private var setOut_point:PathAstarPoint;
      
      private var aim_point:PathAstarPoint;
      
      private var current_point:PathAstarPoint;
      
      private var step_len:int;
      
      private var hittest:PathIHitTester;
      
      private var record_start_point:PathAstarPoint;
      
      public function PathAstarSearcher(n:int)
      {
         super();
         this.step_len = n;
      }
      
      public function search(from:Point, end:Point, hittest:PathIHitTester) : Array
      {
         this.aim_point = new PathAstarPoint(end.x,end.y);
         this.record_start_point = new PathAstarPoint(from.x,from.y);
         var xModify:int = 0;
         var yModify:int = 0;
         if(end.x > from.x)
         {
            xModify = from.x - (this.step_len - Math.abs(end.x - from.x) % this.step_len);
         }
         else
         {
            xModify = from.x + (this.step_len - Math.abs(end.x - from.x) % this.step_len);
         }
         if(end.y > from.y)
         {
            yModify = from.y - (this.step_len - Math.abs(end.y - from.y) % this.step_len);
         }
         else
         {
            yModify = from.y + (this.step_len - Math.abs(end.y - from.y) % this.step_len);
         }
         this.setOut_point = new PathAstarPoint(xModify,yModify);
         this.current_point = this.setOut_point;
         this.hittest = hittest;
         this.init();
         this.findPath();
         return this.path_arr;
      }
      
      private function init() : void
      {
         this.open_list = new Array();
         this.close_list = new Array();
         this.path_arr = new Array();
      }
      
      private function findPath() : void
      {
         var nodes:Array = null;
         var g_tmp:Number = NaN;
         var f_tmp:Number = NaN;
         var h_tmp:Number = NaN;
         var i:int = 0;
         this.open_list.push(this.setOut_point);
         var goon:Boolean = true;
         while(this.open_list.length > 0 && goon)
         {
            this.current_point = this.open_list.shift();
            if(this.current_point.x == this.aim_point.x && this.current_point.y == this.aim_point.y)
            {
               goon = false;
               this.aim_point = nodes[i];
               this.aim_point.source_point = this.current_point;
               break;
            }
            nodes = new Array();
            nodes = this.createNode(this.current_point);
            g_tmp = 0;
            f_tmp = 0;
            h_tmp = 0;
            for(i = 0; i < nodes.length; i++)
            {
               if(nodes[i].x == this.aim_point.x && nodes[i].y == this.aim_point.y)
               {
                  goon = false;
                  this.aim_point = nodes[i];
                  this.aim_point.source_point = this.current_point;
                  break;
               }
               if(this.existInArray(this.open_list,nodes[i]) == -1 && this.existInArray(this.close_list,nodes[i]) == -1)
               {
                  if(!this.hittest.isHit(nodes[i]))
                  {
                     nodes[i].source_point = this.current_point;
                     g_tmp = this.getEvaluateG(nodes[i]);
                     h_tmp = this.getEvaluateH(nodes[i]);
                     this.setEvaluate(nodes[i],g_tmp,h_tmp);
                     this.open_list.push(nodes[i]);
                  }
               }
               else if(this.existInArray(this.open_list,nodes[i]) != -1)
               {
                  g_tmp = this.getEvaluateG(nodes[i]);
                  h_tmp = this.getEvaluateH(nodes[i]);
                  f_tmp = g_tmp + h_tmp;
                  if(f_tmp < nodes[i].f)
                  {
                     nodes[i].source_point = this.current_point;
                     this.setEvaluate(nodes[i],g_tmp,h_tmp);
                  }
               }
               else
               {
                  g_tmp = this.getEvaluateG(nodes[i]);
                  h_tmp = this.getEvaluateH(nodes[i]);
                  f_tmp = g_tmp + h_tmp;
                  if(f_tmp < nodes[i].f)
                  {
                     nodes[i].source_point = this.current_point;
                     this.setEvaluate(nodes[i],g_tmp,h_tmp);
                     this.open_list.push(nodes[i]);
                     this.close_list.splice(this.existInArray(this.close_list,nodes[i]),1);
                  }
               }
            }
            this.close_list.push(this.current_point);
            this.open_list.sortOn("f",Array.NUMERIC);
            if(this.open_list.length > 30)
            {
               this.open_list = this.open_list.slice(0,30);
            }
         }
         this.createPath();
      }
      
      private function createPath() : void
      {
         var this_point:PathAstarPoint = new PathAstarPoint();
         this_point = this.aim_point;
         while(this_point != this.setOut_point)
         {
            this.path_arr.unshift(this_point);
            if(this_point.source_point == null)
            {
               this.path_arr = new Array();
               this.path_arr.push(this.record_start_point,this.record_start_point);
               return;
            }
            this_point = this_point.source_point;
         }
         this.path_arr.splice(0,0,this.record_start_point);
      }
      
      private function setEvaluate(point:PathAstarPoint, g:Number, h:Number) : void
      {
         point.g = g;
         point.h = h;
         point.f = point.g + point.h;
      }
      
      private function getEvaluateG(point:PathAstarPoint) : int
      {
         var g_tmp:int = 0;
         if(this.current_point.x == point.x || this.current_point.y == point.y)
         {
            g_tmp = 10;
         }
         else
         {
            g_tmp = 14;
         }
         return g_tmp + this.current_point.g;
      }
      
      private function getEvaluateH(point:PathAstarPoint) : int
      {
         return Math.abs(this.aim_point.x - point.x) * 10 + Math.abs(this.aim_point.y - point.y) * 10;
      }
      
      private function createNode(point:PathAstarPoint) : Array
      {
         var arr:Array = new Array();
         arr.push(new PathAstarPoint(point.x,point.y - this.step_len));
         arr.push(new PathAstarPoint(point.x - this.step_len,point.y));
         arr.push(new PathAstarPoint(point.x + this.step_len,point.y));
         arr.push(new PathAstarPoint(point.x,point.y + this.step_len));
         arr.push(new PathAstarPoint(point.x - this.step_len,point.y - this.step_len));
         arr.push(new PathAstarPoint(point.x + this.step_len,point.y - this.step_len));
         arr.push(new PathAstarPoint(point.x - this.step_len,point.y + this.step_len));
         arr.push(new PathAstarPoint(point.x + this.step_len,point.y + this.step_len));
         return arr;
      }
      
      private function existInArray(arr:Array, point:PathAstarPoint) : int
      {
         var n:int = -1;
         for(var i:int = 0; i < arr.length; i++)
         {
            if(arr[i].x == point.x && arr[i].y == point.y)
            {
               n = i;
               break;
            }
         }
         return n;
      }
   }
}

