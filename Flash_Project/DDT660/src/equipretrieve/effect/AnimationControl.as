package equipretrieve.effect
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   
   public class AnimationControl extends EventDispatcher
   {
      
      private var _movieArr:Array = new Array();
      
      private var _movieokNum:int = 0;
      
      private var _movieokTotal:int = 0;
      
      public function AnimationControl(target:IEventDispatcher = null)
      {
         super(target);
      }
      
      public function addMovies(anim:EventDispatcher) : void
      {
         this._movieArr.push(anim);
      }
      
      public function startMovie() : void
      {
         this._movieokTotal = this._movieArr.length;
         for(var i:int = 0; i < this._movieokTotal; i++)
         {
            this._movieArr[i].movieStart();
            this._movieArr[i].addEventListener(Event.COMPLETE,this._movieArrComplete);
         }
      }
      
      private function _movieArrComplete(e:Event) : void
      {
         e.currentTarget.removeEventListener(Event.COMPLETE,this._movieArrComplete);
         this._movieokNum += 1;
         if(this._movieokNum == this._movieokTotal)
         {
            this._movieArr = null;
            this._movieokNum = 0;
            dispatchEvent(new Event(Event.COMPLETE));
         }
      }
   }
}

