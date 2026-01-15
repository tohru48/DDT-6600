package roulette
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   
   public class LeftRouletteGlintView extends Sprite implements Disposeable
   {
      
      private var _pointArray:Array;
      
      private var _glintSp:MovieClip;
      
      public function LeftRouletteGlintView(pointArray:Array)
      {
         super();
         this.init();
         this._pointArray = pointArray;
      }
      
      private function init() : void
      {
         this.mouseEnabled = false;
         this.mouseChildren = false;
      }
      
      public function showThreeCell(value:int) : void
      {
         var rotations:Array = null;
         rotations = new Array(0,60,120,180,240,300);
         if(value >= 0 && value <= 5)
         {
            if(this._glintSp == null)
            {
               this._glintSp = ComponentFactory.Instance.creat("asset.roulette.GlintAsset");
               addChild(this._glintSp);
            }
            this._glintSp.gotoAndPlay(1);
            this._glintSp.x = this._pointArray[value].x;
            this._glintSp.y = this._pointArray[value].y;
            this._glintSp.rotation = rotations[value];
            this._glintSp.visible = true;
         }
      }
      
      public function stopGlint() : void
      {
         if(Boolean(this._glintSp))
         {
            this._glintSp.gotoAndStop(1);
            this._glintSp.visible = false;
         }
      }
      
      public function dispose() : void
      {
         if(Boolean(this._glintSp))
         {
            removeChild(this._glintSp);
         }
         this._glintSp = null;
      }
   }
}

