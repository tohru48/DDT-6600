package game.view.playerThumbnail
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.Bitmap;
   import flash.display.Shape;
   import flash.display.Sprite;
   
   public class BossBloodItem extends Sprite implements Disposeable
   {
      
      private var _totalBlood:Number;
      
      private var _bloodNum:Number;
      
      private var _maskShape:Shape;
      
      private var _HPTxt:FilterFrameText;
      
      private var _bg:Bitmap;
      
      private var _rateTxt:FilterFrameText;
      
      public function BossBloodItem(totalBlood:Number)
      {
         super();
         this._totalBlood = totalBlood;
         this._bloodNum = totalBlood;
         this._bg = ComponentFactory.Instance.creatBitmap("asset.game.bossHpStripAsset");
         addChild(this._bg);
         this._maskShape = new Shape();
         this._maskShape.x = 13;
         this._maskShape.y = 7;
         this._maskShape.graphics.beginFill(0,1);
         this._maskShape.graphics.drawRect(0,0,120,25);
         this._maskShape.graphics.endFill();
         this._bg.mask = this._maskShape;
         addChild(this._maskShape);
         this._rateTxt = ComponentFactory.Instance.creatComponentByStylename("asset.bossHPStripRateTxt");
         addChild(this._rateTxt);
         this._rateTxt.text = "100%";
      }
      
      public function set bloodNum(value:Number) : void
      {
         if(value < 0)
         {
            value = 0;
         }
         else if(value > this._totalBlood)
         {
            value = this._totalBlood;
         }
         this._bloodNum = value;
         this.updateView();
      }
      
      public function updateBlood(current:Number, max:Number) : void
      {
         this._bloodNum = current;
         if(this._bloodNum < 0)
         {
            this._bloodNum = 0;
         }
         this._totalBlood = max;
         if(this._totalBlood < this._bloodNum)
         {
            this._totalBlood = this._bloodNum;
         }
         this.updateView();
      }
      
      private function updateView() : void
      {
         var rate:int = this.getRate(this._bloodNum,this._totalBlood);
         this._rateTxt.text = rate.toString() + "%";
         this._maskShape.width = 120 * (rate / 100);
         this._bg.mask = this._maskShape;
      }
      
      private function getRate(value1:Number, value2:Number) : int
      {
         var rate:Number = value1 / value2 * 100;
         if(rate > 0 && rate < 1)
         {
            rate = 1;
         }
         return int(rate);
      }
      
      public function dispose() : void
      {
         removeChild(this._bg);
         this._bg.bitmapData.dispose();
         this._bg = null;
         removeChild(this._maskShape);
         this._maskShape = null;
         if(Boolean(this._HPTxt))
         {
            this._HPTxt.dispose();
            this._HPTxt = null;
         }
         ObjectUtils.disposeObject(this._rateTxt);
         this._rateTxt = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

