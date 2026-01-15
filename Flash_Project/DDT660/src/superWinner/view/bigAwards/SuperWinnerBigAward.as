package superWinner.view.bigAwards
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   
   public class SuperWinnerBigAward extends Sprite implements Disposeable
   {
      
      private var _type:uint;
      
      private var _awardNumTxt:FilterFrameText;
      
      private const MAX_AWARD_NUM:Array = [32,16,8,4,2,1];
      
      public function SuperWinnerBigAward($type:uint)
      {
         this._type = $type;
         super();
         this.init();
      }
      
      private function init() : void
      {
         var img:Bitmap = ComponentFactory.Instance.creatBitmap("asset.superWinner.bigAward" + this.awardType);
         addChild(img);
         this._awardNumTxt = ComponentFactory.Instance.creatComponentByStylename("superWinner.bigAwardTxt");
         addChild(this._awardNumTxt);
         this._awardNumTxt.text = "0/" + this.MAX_AWARD_NUM[this.awardType - 1];
      }
      
      public function set awardNum(val:uint) : void
      {
         this._awardNumTxt.text = val + "/" + this.MAX_AWARD_NUM[this.awardType - 1];
      }
      
      public function get awardType() : uint
      {
         return this._type;
      }
      
      public function dispose() : void
      {
         ObjectUtils.removeChildAllChildren(this);
      }
   }
}

