package bagAndInfo.bag.ring
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   
   public class RingSystemTip extends Sprite implements Disposeable
   {
       
      
      private var _addition:Vector.<FilterFrameText>;
      
      private var _ringBitmap:Vector.<Bitmap>;
      
      public function RingSystemTip()
      {
         super();
         this._addition = new Vector.<FilterFrameText>(4);
         this._ringBitmap = new Vector.<Bitmap>(4);
         this.initView();
      }
      
      private function initView() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < this._addition.length)
         {
            this._ringBitmap[_loc1_] = ComponentFactory.Instance.creat("asset.bagAndInfo.bag.RingSystem.tipIcon");
            addChild(this._ringBitmap[_loc1_]);
            this._addition[_loc1_] = ComponentFactory.Instance.creatComponentByStylename("bagAndInfo.bag.RingSystemView.tipData");
            addChild(this._addition[_loc1_]);
            _loc1_++;
         }
      }
      
      public function setAdditiontext(param1:Array) : void
      {
         var _loc3_:int = 0;
         var _loc2_:Number = 0;
         _loc3_ = 0;
         while(_loc3_ < this._addition.length)
         {
            _loc2_ = param1[_loc3_] * 0.01;
            this._addition[_loc3_].text = "+" + int(_loc2_);
            this._addition[_loc3_].y = _loc3_ * 23 - 3;
            this._ringBitmap[_loc3_].y = _loc3_ * 23;
            _loc3_++;
         }
      }
      
      public function dispose() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < this._addition.length)
         {
            ObjectUtils.disposeObject(this._addition[_loc1_]);
            this._addition[_loc1_] = null;
            _loc1_++;
         }
      }
   }
}
