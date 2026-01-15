package chickActivation.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.Sprite;
   
   public class ChickActivationCoinsView extends Sprite implements Disposeable
   {
      
      private static const MAX_NUM_WIDTH:int = 8;
      
      private static const WIDTH:int = 15;
      
      private var _num:Vector.<ScaleFrameImage>;
      
      private var len:int = 1;
      
      private var coinsNum:int;
      
      public function ChickActivationCoinsView()
      {
         super();
         this._num = new Vector.<ScaleFrameImage>();
         this.setupCount();
      }
      
      public function set count(value:int) : void
      {
         if(this.coinsNum == value)
         {
            return;
         }
         this.initCoinsStyle();
         this.coinsNum = value;
         this.updateCount();
      }
      
      private function setupCount() : void
      {
         while(this.len > this._num.length)
         {
            this._num.unshift(this.createCoinsNum(10));
         }
         while(this.len < this._num.length)
         {
            ObjectUtils.disposeObject(this._num.shift());
         }
         var cha:int = MAX_NUM_WIDTH - this.len;
         var numX:int = cha / 2 * WIDTH;
         for(var i:int = 0; i < this.len; i++)
         {
            this._num[i].x = numX;
            numX += WIDTH;
         }
      }
      
      private function updateCount() : void
      {
         var length:int = int(this.coinsNum.toString().length);
         if(length != this.len)
         {
            this.len = length;
            this.setupCount();
         }
         this.initCoinsStyle();
      }
      
      private function initCoinsStyle() : void
      {
         var arr:Array = this.coinsNum.toString().split("");
         this.updateCoinsView(arr);
      }
      
      private function updateCoinsView(arr:Array) : void
      {
         for(var i:int = 0; i < this.len; i++)
         {
            if(arr[i] == 0)
            {
               arr[i] = 10;
            }
            this._num[i].setFrame(arr[i]);
         }
      }
      
      private function play() : void
      {
      }
      
      private function createCoinsNum(frame:int = 0) : ScaleFrameImage
      {
         var num:ScaleFrameImage = ComponentFactory.Instance.creatComponentByStylename("chickActivation.CoinsNum");
         num.setFrame(frame);
         addChild(num);
         return num;
      }
      
      public function dispose() : void
      {
         if(Boolean(this._num))
         {
            while(Boolean(this._num.length))
            {
               ObjectUtils.disposeObject(this._num.shift());
            }
            this._num = null;
         }
      }
   }
}

