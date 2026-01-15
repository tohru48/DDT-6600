package game.animations
{
   import flash.geom.Point;
   
   public dynamic class TweenObject
   {
      
      public var speed:uint;
      
      public var duration:uint;
      
      private var _x:Number;
      
      private var _y:Number;
      
      private var _strategy:String;
      
      public function TweenObject(data:Object = null)
      {
         var prop:* = undefined;
         super();
         for(prop in data)
         {
            this[prop] = data[prop];
         }
      }
      
      public function set x(value:Number) : void
      {
         this._x = value;
      }
      
      public function get x() : Number
      {
         return this._x;
      }
      
      public function set y(value:Number) : void
      {
         this._y = value;
      }
      
      public function get y() : Number
      {
         return this._y;
      }
      
      public function set target(value:Point) : void
      {
         this._x = value.x;
         this._y = value.y;
      }
      
      public function get target() : Point
      {
         return new Point(this._x,this._y);
      }
      
      public function set strategy(value:String) : void
      {
         this._strategy = value;
      }
      
      public function get strategy() : String
      {
         if(Boolean(this._strategy))
         {
            return this._strategy;
         }
         return "default";
      }
   }
}

