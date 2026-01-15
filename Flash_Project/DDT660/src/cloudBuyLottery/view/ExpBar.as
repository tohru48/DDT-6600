package cloudBuyLottery.view
{
   import cloudBuyLottery.CloudBuyLotteryManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   
   public class ExpBar extends Sprite implements Disposeable
   {
      
      protected var _groudPic:Bitmap;
      
      protected var _curPic:Bitmap;
      
      private var _totalLen:int;
      
      protected var _expBarTxt:FilterFrameText;
      
      protected var _maskMC:Sprite;
      
      private var _per:Number = 0;
      
      public var curNum:int = 0;
      
      public var totalNum:int = 0;
      
      public var id:int;
      
      public var stylename:String;
      
      protected var _oldX:int;
      
      public function ExpBar()
      {
         super();
         this.initView();
      }
      
      public function beginChanges() : void
      {
      }
      
      public function commitChanges() : void
      {
      }
      
      public function initView() : void
      {
         this._groudPic = ComponentFactory.Instance.creatBitmap("asset.cloudbuy.expBack");
         addChild(this._groudPic);
         this._curPic = ComponentFactory.Instance.creatBitmap("asset.cloudbuy.expFrome");
         addChild(this._curPic);
         this._expBarTxt = ComponentFactory.Instance.creatComponentByStylename("cloudbuy.expBarTxt");
         this._expBarTxt.text = "0";
         addChild(this._expBarTxt);
         this._maskMC = new Sprite();
         this._maskMC.graphics.beginFill(0);
         this._maskMC.graphics.drawRect(15,1,152,this._groudPic.height);
         this._maskMC.graphics.endFill();
         addChild(this._maskMC);
         this._maskMC.alpha = 0.2;
         this._curPic.mask = this._maskMC;
         this._oldX = this._curPic.x;
         var num:int = CloudBuyLotteryManager.Instance.model.maxNum - CloudBuyLotteryManager.Instance.model.currentNum;
         this.initBar(num,CloudBuyLotteryManager.Instance.model.maxNum);
      }
      
      public function initBar(i:int, total:int, isFull:Boolean = false) : void
      {
         if(isFull)
         {
            this._curPic.x = this._oldX;
            this._expBarTxt.text = "0" + "/" + "0";
            return;
         }
         if(i == 0)
         {
            this._curPic.x = this._oldX;
            this._expBarTxt.text = String(i) + "/" + total;
            return;
         }
         if(this._curPic.x != this._oldX)
         {
            this._curPic.x = this._oldX;
         }
         this._expBarTxt.text = String(i) + "/" + total;
         this.curNum = i;
         this.totalNum = total;
         this._per = this.curNum / this.totalNum;
         this._curPic.x += this._per * (this._groudPic.width - 30);
      }
      
      public function upData(cur:int) : void
      {
         this.curNum += cur;
         this._per = Number(this.curNum / this.totalNum);
         this._expBarTxt.text = String(this.curNum);
         this._curPic.x += this._per * (this._curPic.width - 80);
      }
      
      public function dispose() : void
      {
         while(Boolean(numChildren))
         {
            ObjectUtils.disposeObject(getChildAt(0));
         }
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

