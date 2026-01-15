package game.view.smallMap
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.events.Event;
   import road7th.utils.MovieClipWrapper;
   
   public class GameTurnButton extends TextButton
   {
      
      private var _turnShine:MovieClipWrapper;
      
      private var _container:DisplayObjectContainer;
      
      public var isFirst:Boolean = true;
      
      public function GameTurnButton(container:DisplayObjectContainer)
      {
         this._container = container;
         super();
      }
      
      override protected function init() : void
      {
         var shineMovie:MovieClip = null;
         super.init();
         shineMovie = ComponentFactory.Instance.creat("asset.game.smallmap.TurnShine");
         shineMovie.x = 27;
         shineMovie.y = 7;
         this._turnShine = new MovieClipWrapper(shineMovie);
      }
      
      public function shine() : void
      {
         if(parent == null && Boolean(this._container))
         {
            this._container.addChild(this);
         }
         if(Boolean(this._turnShine) && Boolean(this._turnShine.movie))
         {
            addChildAt(this._turnShine.movie,0);
            this._turnShine.addEventListener(Event.COMPLETE,this.__shineComplete);
            this._turnShine.gotoAndPlay(1);
         }
      }
      
      private function __shineComplete(evt:Event) : void
      {
         this._turnShine.removeEventListener(Event.COMPLETE,this.__shineComplete);
         if(Boolean(this._turnShine.movie.parent))
         {
            this._turnShine.movie.parent.removeChild(this._turnShine.movie);
         }
      }
      
      override public function get width() : Number
      {
         if(Boolean(_back))
         {
            return _back.width;
         }
         return 60;
      }
      
      override public function dispose() : void
      {
         this._container = null;
         if(Boolean(this._turnShine))
         {
            this._turnShine.removeEventListener(Event.COMPLETE,this.__shineComplete);
            ObjectUtils.disposeObject(this._turnShine);
            this._turnShine = null;
         }
         super.dispose();
      }
   }
}

