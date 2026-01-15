package equipretrieve.effect
{
   import flash.display.DisplayObject;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import flash.filters.GlowFilter;
   
   public dynamic class GlowFilterAnimation extends EventDispatcher
   {
      
      private var _blurFilter:GlowFilter;
      
      private var _view:DisplayObject;
      
      private var _movieArr:Array;
      
      private var _nowMovieID:int = 0;
      
      private var _overHasFilter:Boolean;
      
      public function GlowFilterAnimation(target:IEventDispatcher = null)
      {
         super(target);
      }
      
      public function start(view:DisplayObject, overHasFilter:Boolean = false, color:uint = 16711680, alpha:Number = 1, blurX:Number = 6, blurY:Number = 6, strength:Number = 2, quality:int = 1, inner:Boolean = false, knockout:Boolean = false) : void
      {
         this._movieArr = new Array();
         this._blurFilter = new GlowFilter(color,alpha,blurX,blurY,strength,quality,inner,knockout);
         this._view = view;
         this._overHasFilter = overHasFilter;
      }
      
      public function addMovie(blurX:Number, blurY:Number, timeFrame:int, strength:int = 2) : void
      {
         var obj:Object = new Object();
         obj.blurX = blurX;
         obj.blurY = blurY;
         obj.strength = strength;
         obj.time = timeFrame;
         obj.blurSpeedX = 0;
         obj.blurSpeedY = 0;
         this._movieArr.push(obj);
      }
      
      public function movieStart() : void
      {
         if(this._movieArr == null || this._movieArr.length < 1 || this._view == null)
         {
            return;
         }
         this._nowMovieID = 0;
         this._refeshSpeed();
         this._view.addEventListener(Event.ENTER_FRAME,this._inframe);
      }
      
      private function _inframe(e:Event) : void
      {
         this._blurFilter.blurX += this._movieArr[this._nowMovieID].blurSpeedX;
         this._blurFilter.blurY += this._movieArr[this._nowMovieID].blurSpeedY;
         this._view.filters = [this._blurFilter];
         this._movieArr[this._nowMovieID].time -= 1;
         if(this._movieArr[this._nowMovieID].time == 0)
         {
            if(this._nowMovieID < this._movieArr.length - 1)
            {
               this._nowMovieID += 1;
               this._refeshSpeed();
            }
            else
            {
               this._view.removeEventListener(Event.ENTER_FRAME,this._inframe);
               this._movieOver();
            }
         }
      }
      
      private function _refeshSpeed() : void
      {
         this._movieArr[this._nowMovieID].blurSpeedX = (this._movieArr[this._nowMovieID].blurX - this._blurFilter.blurX) / this._movieArr[this._nowMovieID].time;
         this._movieArr[this._nowMovieID].blurSpeedY = (this._movieArr[this._nowMovieID].blurY - this._blurFilter.blurY) / this._movieArr[this._nowMovieID].time;
      }
      
      private function _movieOver() : void
      {
         if(this._overHasFilter == false)
         {
            this._view.filters = null;
         }
         this._blurFilter = null;
         this._view = null;
         this._movieArr = null;
         this._nowMovieID = 0;
         dispatchEvent(new Event(Event.COMPLETE));
      }
   }
}

