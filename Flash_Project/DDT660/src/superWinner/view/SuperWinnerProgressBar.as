package superWinner.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import superWinner.controller.SuperWinnerController;
   import superWinner.event.SuperWinnerEvent;
   
   public class SuperWinnerProgressBar extends Sprite implements Disposeable
   {
      
      private var _movie:MovieClip;
      
      private var _outLight:MovieClip;
      
      private var _changeColor:MovieClip;
      
      private var _light1:MovieClip;
      
      private var _light2:MovieClip;
      
      public function SuperWinnerProgressBar()
      {
         super();
         this.init();
      }
      
      private function init() : void
      {
         this._movie = ComponentFactory.Instance.creat("asset.superWinner.ProgressBar");
         this._outLight = this._movie["outLight"];
         this._changeColor = this._movie["changeColor"];
         this._light1 = this._movie["light1"];
         this._light2 = this._movie["light2"];
         this.resetProgressBar();
         addChild(this._movie);
      }
      
      public function resetProgressBar() : void
      {
         this._movie.gotoAndStop(1);
         this._outLight.gotoAndStop(1);
         this._changeColor.gotoAndStop(1);
         this._light1.gotoAndStop(1);
         this._light2.gotoAndStop(1);
         this._outLight.visible = false;
         this._light1.visible = false;
         this._light2.visible = false;
      }
      
      public function playBar() : void
      {
         this._outLight.gotoAndPlay(1);
         this._light1.gotoAndPlay(1);
         this._light2.gotoAndPlay(1);
         this._outLight.visible = true;
         this._light1.visible = true;
         this._light2.visible = true;
         this._changeColor.gotoAndPlay(1);
         this._movie.gotoAndPlay(1);
         this._movie.addEventListener(Event.ENTER_FRAME,this.frameBar);
         this.filters = null;
      }
      
      private function stopBar() : void
      {
         this._movie.removeEventListener(Event.ENTER_FRAME,this.frameBar);
         this._movie.gotoAndStop(250);
         this._outLight.gotoAndStop(1);
         this._changeColor.gotoAndStop(1);
         this._light1.gotoAndStop(1);
         this._light2.gotoAndStop(1);
         this._outLight.visible = false;
         this._light1.visible = false;
         this._light2.visible = false;
      }
      
      private function frameBar(e:Event) : void
      {
         if(this._movie.currentFrame >= 250)
         {
            this.resetProgressBar();
            this.filters = ComponentFactory.Instance.creatFilters("grayFilter");
            SuperWinnerController.instance.model.dispatchEvent(new SuperWinnerEvent(SuperWinnerEvent.PROGRESS_TIMES_UP));
         }
      }
      
      public function dispose() : void
      {
         this.resetProgressBar();
         if(this._movie.hasEventListener(Event.ENTER_FRAME))
         {
            this._movie.removeEventListener(Event.ENTER_FRAME,this.frameBar);
         }
         ObjectUtils.removeChildAllChildren(this);
         this._movie = null;
         this._outLight = null;
         this._changeColor = null;
         this._light1 = null;
         this._light2 = null;
      }
   }
}

