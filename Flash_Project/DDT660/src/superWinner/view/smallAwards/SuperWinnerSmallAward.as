package superWinner.view.smallAwards
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   
   public class SuperWinnerSmallAward extends Sprite implements Disposeable
   {
      
      private var _type:uint;
      
      private var _awardNumTxt:FilterFrameText;
      
      public function SuperWinnerSmallAward($type:uint)
      {
         this._type = $type;
         super();
         this.init();
      }
      
      private function init() : void
      {
         var img:Bitmap = ComponentFactory.Instance.creatBitmap("asset.superWinner.smallAward" + this.awardType);
         addChild(img);
         this._awardNumTxt = ComponentFactory.Instance.creatComponentByStylename("superWinner.smallAwardTxt");
         addChild(this._awardNumTxt);
         this._awardNumTxt.text = "0";
      }
      
      public function set awardNum(val:uint) : void
      {
         this._awardNumTxt.text = val + "";
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

