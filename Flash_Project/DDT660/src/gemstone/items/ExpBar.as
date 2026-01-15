package gemstone.items
{
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
      
      protected var _curPicContent:Sprite;
      
      private var _totalLen:int;
      
      protected var _expBarTxt:FilterFrameText;
      
      protected var _maskMC:Sprite;
      
      private var _per:Number = 0;
      
      public var curNum:int = 0;
      
      public var totalNum:int = 0;
      
      public var id:int;
      
      public var stylename:String;
      
      protected var _oldX:int;
      
      private var _totalViewWidth:int;
      
      public function ExpBar()
      {
         super();
         this.initView();
      }
      
      public function initView() : void
      {
         this._groudPic = ComponentFactory.Instance.creatBitmap("gemstone.expBack");
         addChild(this._groudPic);
         this._curPic = ComponentFactory.Instance.creatBitmap("gemstone.expFrome");
         addChild(this._curPic);
         this._expBarTxt = ComponentFactory.Instance.creatComponentByStylename("expBarTxt");
         this._expBarTxt.text = "0";
         addChild(this._expBarTxt);
         this._maskMC = new Sprite();
         this._maskMC.graphics.beginFill(0);
         this._maskMC.graphics.drawRect(5,1,211,this._groudPic.height);
         this._maskMC.graphics.endFill();
         addChild(this._maskMC);
         this._maskMC.alpha = 0.2;
         this._curPic.mask = this._maskMC;
         this._oldX = this._curPic.x;
         var _minX:int = this._oldX;
         var _maxX:int = this._maskMC.width + this._oldX;
         this._totalViewWidth = _maxX - _minX;
      }
      
      public function beginChanges() : void
      {
      }
      
      public function commitChanges() : void
      {
      }
      
      public function initBar(i:int, total:int, isFull:Boolean = false) : void
      {
         this.totalNum = total;
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
         this._per = this.curNum / this.totalNum;
         this._curPic.x += this._per * (this._groudPic.width - 10);
      }
      
      public function upData(cur:int) : void
      {
         this.curNum += cur;
         this._per = Number(this.curNum / this.totalNum);
         this._per > 1 && 1;
         this._expBarTxt.text = String(this.curNum);
         this._curPic.x = this._oldX + this._per * this._totalViewWidth;
         this._expBarTxt.text = this.curNum.toString() + "/" + this.totalNum.toString();
      }
      
      public function dispose() : void
      {
         while(Boolean(numChildren))
         {
            ObjectUtils.disposeObject(getChildAt(0));
         }
         this._groudPic = null;
         this._curPic = null;
         this._curPicContent = null;
         this._expBarTxt = null;
         this._maskMC = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

