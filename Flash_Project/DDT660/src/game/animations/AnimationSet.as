package game.animations
{
   import game.view.map.MapView;
   
   public class AnimationSet
   {
      
      private var _map:MapView;
      
      private var _running:Boolean;
      
      private var _current:IAnimate;
      
      private var _stageWidth:Number;
      
      private var _stageHeight:Number;
      
      private var _minX:Number;
      
      private var _minY:Number;
      
      public function AnimationSet(map:MapView, stageWidth:Number, stageHeight:Number)
      {
         super();
         this._map = map;
         this._running = true;
         this._current = null;
         this._stageHeight = stageHeight;
         this._stageWidth = stageWidth;
         this._minX = -this._map.width + stageWidth;
         this._minY = -this._map.height + stageHeight;
      }
      
      public function get stageWidth() : Number
      {
         return this._stageWidth;
      }
      
      public function get stageHeight() : Number
      {
         return this._stageHeight;
      }
      
      public function get map() : MapView
      {
         return this._map;
      }
      
      public function get minX() : Number
      {
         return this._minX;
      }
      
      public function get minY() : Number
      {
         return this._minY;
      }
      
      public function get current() : IAnimate
      {
         return this._current;
      }
      
      public function addAnimation(anit:IAnimate) : void
      {
         if(Boolean(this._current))
         {
            if(this._current.level <= anit.level && Boolean(this._current.canReplace(anit)))
            {
               this._current.cancel();
               this._current = anit;
               this._current.prepare(this);
            }
         }
         else
         {
            this._current = anit;
            this._current.prepare(this);
         }
      }
      
      public function pause() : void
      {
         this._running = false;
      }
      
      public function play() : void
      {
         this._running = true;
      }
      
      public function dispose() : void
      {
         if(Boolean(this._current))
         {
            this._current.cancel();
            this._current = null;
         }
         this._map = null;
      }
      
      public function clear() : void
      {
         if(Boolean(this._current))
         {
            this._current.cancel();
         }
         this._current = null;
      }
      
      public function update() : Boolean
      {
         if(this._running && Boolean(this._current))
         {
            if(this._current.canAct())
            {
               if(this._current.update(this._map))
               {
                  return true;
               }
               this._current = null;
            }
            else
            {
               this._current = null;
            }
         }
         return false;
      }
   }
}

