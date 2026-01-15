package equipretrieve.effect
{
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   
   public class MovieClipControl extends EventDispatcher
   {
      
      private var _movieArr:Array = new Array();
      
      private var _evtSprite:Sprite = new Sprite();
      
      private var _total:int;
      
      private var _currentInt:int;
      
      private var _arrInt:int;
      
      public function MovieClipControl(total:int)
      {
         super();
         this._total = total;
      }
      
      public function addMovies(view:MovieClip, goInt:int, totalInt:int) : void
      {
         var obj:Object = new Object();
         view.visible = false;
         view.stop();
         obj.view = view;
         obj.goInt = goInt;
         obj.totalInt = totalInt + goInt;
         this._movieArr.push(obj);
      }
      
      public function startMovie() : void
      {
         this._currentInt = 0;
         this._arrInt = this._movieArr.length;
         this._evtSprite.addEventListener(Event.ENTER_FRAME,this._inFrame);
      }
      
      private function _inFrame(e:Event) : void
      {
         this._currentInt += 1;
         if(this._currentInt >= this._total)
         {
            this._allMovieClipOver();
            return;
         }
         for(var i:int = 0; i < this._arrInt; i++)
         {
            if(this._movieArr[i].goInt == this._currentInt)
            {
               this._movieArr[i].view.visible = true;
               this._movieArr[i].view.play();
            }
            else if(this._movieArr[i].totalInt == this._currentInt)
            {
               this._movieArr[i].view.visible = false;
               this._movieArr[i].view.stop();
            }
         }
      }
      
      private function _allMovieClipOver() : void
      {
         dispatchEvent(new Event(Event.COMPLETE));
         this._evtSprite.removeEventListener(Event.ENTER_FRAME,this._inFrame);
         for(var i:int = 0; i < this._arrInt; i++)
         {
            this._movieArr[i].view.visible = false;
            this._movieArr[i].view.stop();
         }
         this._removeAllView();
      }
      
      private function _removeAllView() : void
      {
         this._evtSprite = null;
         this._movieArr = null;
      }
   }
}

