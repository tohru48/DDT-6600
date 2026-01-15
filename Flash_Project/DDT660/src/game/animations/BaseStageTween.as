package game.animations
{
   import flash.display.DisplayObject;
   import flash.geom.Point;
   
   public class BaseStageTween implements IStageTween
   {
      
      protected var _target:Point;
      
      protected var _prepared:Boolean = false;
      
      protected var _isFinished:Boolean;
      
      public function BaseStageTween(data:TweenObject = null)
      {
         super();
         this._isFinished = false;
         if(Boolean(data))
         {
            this.initData(data);
         }
      }
      
      public function get type() : String
      {
         return "BaseStageTween";
      }
      
      public function initData(data:TweenObject) : void
      {
         if(!data)
         {
            return;
         }
         this.copyPropertyFromData(data);
         this._prepared = true;
      }
      
      public function update(movie:DisplayObject) : Point
      {
         return null;
      }
      
      public function set target(value:Point) : void
      {
         this._target = value;
         this._prepared = true;
      }
      
      public function get target() : Point
      {
         return this._target;
      }
      
      public function copyPropertyFromData(data:TweenObject) : void
      {
         var prop:String = null;
         for each(prop in this.propertysNeed)
         {
            if(Boolean(data[prop]))
            {
               this[prop] = data[prop];
            }
         }
      }
      
      protected function get propertysNeed() : Array
      {
         return ["target"];
      }
      
      public function get isFinished() : Boolean
      {
         return this._isFinished;
      }
   }
}

