package Dice.VO
{
   import flash.geom.Point;
   
   public class DiceCellInfo
   {
      
      private var _position:Point;
      
      private var _vertices1:Point;
      
      private var _vertices2:Point;
      
      private var _vertices3:Point;
      
      private var _centerPosition:Point;
      
      public function DiceCellInfo()
      {
         super();
         this._position = new Point();
         this._centerPosition = new Point();
         this._vertices1 = new Point(0,0);
         this._vertices2 = new Point(0,0);
         this._vertices3 = new Point(0,0);
      }
      
      public function get CellCenterPosition() : Point
      {
         return this._centerPosition;
      }
      
      public function set centerPosition(value:String) : void
      {
         var arr:Array = value.split(",");
         this._centerPosition.x = int(arr[0]);
         this._centerPosition.y = int(arr[1]);
      }
      
      public function get Position() : Point
      {
         return this._position;
      }
      
      public function set position(value:String) : void
      {
         var arr:Array = value.split(",");
         this._position.x = int(arr[0]);
         this._position.y = int(arr[1]);
      }
      
      public function set verticesString(value:String) : void
      {
         var arr:Array = value.split(",");
         this._vertices1.x = arr[0] == null ? 0 : Number(arr[0]);
         this._vertices1.y = arr[1] == null ? 0 : Number(arr[1]);
         this._vertices2.x = arr[2] == null ? 0 : Number(arr[2]);
         this._vertices2.y = arr[3] == null ? 0 : Number(arr[3]);
         this._vertices3.x = arr[4] == null ? 0 : Number(arr[4]);
         this._vertices3.y = arr[5] == null ? 0 : Number(arr[5]);
      }
      
      public function get vertices1() : Point
      {
         return this._vertices1;
      }
      
      public function get vertices2() : Point
      {
         return this._vertices2;
      }
      
      public function get vertices3() : Point
      {
         return this._vertices3;
      }
      
      public function dispose() : void
      {
         this._position = null;
         this._vertices1 = null;
         this._vertices2 = null;
         this._vertices3 = null;
      }
   }
}

