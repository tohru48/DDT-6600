package road7th.math
{
   import flash.geom.Point;
   
   public class XLine
   {
      
      protected var list:Array;
      
      protected var fix:Boolean = true;
      
      protected var fixValue:Number = 1;
      
      public function XLine(... rest)
      {
         super();
         this.line = rest;
      }
      
      public static function ToString(param1:Array) : String
      {
         var p:Point = null;
         var value:Array = param1;
         var rlt:String = "";
         try
         {
            for each(p in value)
            {
               rlt += p.x + ":" + p.y + ",";
            }
         }
         catch(e:Error)
         {
         }
         return rlt;
      }
      
      public static function parse(param1:String) : Array
      {
         var temp:Array = null;
         var nums:Array = null;
         var i:int = 0;
         var str:String = param1;
         var list:Array = new Array();
         try
         {
            temp = str.match(/([-]?\d+[\.]?\d*)/g);
            nums = new Array();
            i = 0;
            while(i < temp.length)
            {
               list.push(new Point(Number(temp[i]),Number(temp[i + 1])));
               i += 2;
            }
         }
         catch(e:Error)
         {
         }
         return list;
      }
      
      public function set line(param1:Array) : void
      {
         this.list = param1;
         if(this.list == null || this.list.length == 0)
         {
            this.fix = true;
            this.fixValue = 1;
         }
         else if(this.list.length == 1)
         {
            this.fix = true;
            this.fixValue = this.list[0].y;
         }
         else if(this.list.length == 2 && this.list[0].y == this.list[1].y)
         {
            this.fix = true;
            this.fixValue = this.list[0].y;
         }
         else
         {
            this.fix = false;
         }
      }
      
      public function get line() : Array
      {
         return this.list;
      }
      
      public function interpolate(param1:Number) : Number
      {
         var _loc2_:Point = null;
         var _loc3_:Point = null;
         var _loc4_:int = 0;
         if(!this.fix)
         {
            _loc4_ = 1;
            while(_loc4_ < this.list.length)
            {
               _loc3_ = this.list[_loc4_];
               _loc2_ = this.list[_loc4_ - 1];
               if(_loc3_.x > param1)
               {
                  break;
               }
               _loc4_++;
            }
            return interpolatePointByX(_loc2_,_loc3_,param1);
         }
         return this.fixValue;
      }
   }
}

