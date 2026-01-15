package superWinner.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   
   public class DicesBanner extends Sprite implements Disposeable
   {
      
      private var _diceArr:Vector.<MovieClip> = new Vector.<MovieClip>(6,true);
      
      private var _space:Number;
      
      public function DicesBanner(space:Number = 37.8)
      {
         super();
         this._space = space;
         this.init();
      }
      
      private function init() : void
      {
         var dice:MovieClip = null;
         for(var i:int = 0; i < 6; i++)
         {
            dice = ComponentFactory.Instance.creat("asset.superWinner.smallDice");
            dice.x = i * this._space;
            dice.gotoAndStop(6);
            this._diceArr[i] = dice;
            addChild(dice);
         }
      }
      
      public function showLastDices(val:Vector.<int>) : void
      {
         for(var i:uint = 0; i < 6; i++)
         {
            this._diceArr[i].gotoAndStop(val[i]);
         }
      }
      
      public function dispose() : void
      {
         this._diceArr = null;
         ObjectUtils.removeChildAllChildren(this);
      }
   }
}

