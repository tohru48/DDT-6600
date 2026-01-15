package superWinner.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   
   public class DicesMovieSprite extends Sprite implements Disposeable
   {
      
      private const DICE_STYLE:Array = [1,0];
      
      private var _dices:MovieClip;
      
      private var _finalDices:MovieClip;
      
      private var _movieDices:MovieClip;
      
      private var _currentDices:Vector.<int>;
      
      public function DicesMovieSprite()
      {
         super();
         this.init();
      }
      
      private function init() : void
      {
         this._dices = ComponentFactory.Instance.creat("asset.superWinner.DicesMovie");
         this._finalDices = this._dices["finalDices"];
         this._movieDices = this._dices["movieDices"];
         this.resetDice();
         addChild(this._dices);
      }
      
      public function resetDice() : void
      {
         var dice:MovieClip = null;
         var mc:MovieClip = null;
         var mc2:MovieClip = null;
         this.stopMovieDices();
         this._finalDices.visible = false;
         for(var i:uint = 1; i <= 6; i++)
         {
            dice = this._finalDices["dice" + i];
            mc = dice["dice0"] as MovieClip;
            mc2 = dice["dice1"] as MovieClip;
            mc.visible = true;
            mc2.visible = true;
            mc.gotoAndStop(1);
            mc2.gotoAndStop(1);
         }
      }
      
      public function playMovie(dicePoints:Vector.<int>) : void
      {
         this.resetDice();
         this._currentDices = dicePoints;
         this._movieDices.addEventListener(Event.ENTER_FRAME,this.onFrame);
         this._movieDices.visible = true;
         this._movieDices.gotoAndPlay(1);
      }
      
      private function onFrame(e:Event) : void
      {
         var frame:MovieClip = e.currentTarget as MovieClip;
         if(frame.currentFrame >= 10)
         {
            this.stopMovieDices();
            this.showDices();
         }
      }
      
      private function stopMovieDices() : void
      {
         this._movieDices.gotoAndStop(1);
         this._movieDices.visible = false;
      }
      
      private function showDices() : void
      {
         var randomNum:uint = 0;
         var dice:MovieClip = null;
         var mc:MovieClip = null;
         this._finalDices.visible = true;
         for(var i:uint = 0; i < this._currentDices.length; i++)
         {
            randomNum = Math.round(Math.random());
            dice = this._finalDices["dice" + (i + 1)];
            dice["dice" + this.DICE_STYLE[randomNum]].visible = false;
            mc = dice["dice" + randomNum] as MovieClip;
            mc.gotoAndStop(this._currentDices[i]);
         }
      }
      
      public function dispose() : void
      {
         this._dices.removeEventListener(Event.ENTER_FRAME,this.onFrame);
         ObjectUtils.disposeAllChildren(this);
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

