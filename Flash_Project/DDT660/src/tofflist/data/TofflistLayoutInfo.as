package tofflist.data
{
   import flash.geom.Point;
   
   public class TofflistLayoutInfo
   {
      
      public var TitleHLinePoint:Vector.<Point>;
      
      public var TitleTextPoint:Vector.<Point>;
      
      public var TitleTextString:Array;
      
      public function TofflistLayoutInfo()
      {
         super();
         this.TitleHLinePoint = new Vector.<Point>();
         this.TitleTextPoint = new Vector.<Point>();
      }
      
      public function set titleHLinePt(value:String) : void
      {
         this.TitleHLinePoint = this.parseValue(value);
      }
      
      public function set titleTextPt(value:String) : void
      {
         this.TitleTextPoint = this.parseValue(value);
      }
      
      private function parseValue(value:String) : Vector.<Point>
      {
         var p:String = null;
         var pt:Point = null;
         var result:Vector.<Point> = new Vector.<Point>();
         var pts:Array = value.split("|");
         for each(p in pts)
         {
            pt = new Point(p.split(",")[0],p.split(",")[1]);
            result.push(pt);
         }
         return result;
      }
   }
}

