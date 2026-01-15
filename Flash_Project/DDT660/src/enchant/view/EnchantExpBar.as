package enchant.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Component;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   
   public class EnchantExpBar extends Component
   {
      
      private var _progressBg:Bitmap;
      
      private var _progressColorBg:Bitmap;
      
      private var _progressBarMask:Sprite;
      
      private var _scaleValue:Number;
      
      private var _total:int = 50;
      
      private var _currentFrame:int;
      
      private var _destFrame:int;
      
      private var _isUpGrade:Boolean;
      
      private var _curExp:int;
      
      private var _sumExp:int;
      
      private var _starMc:MovieClip;
      
      private var _progressCompleteMc:MovieClip;
      
      private var _progressTxt:FilterFrameText;
      
      public var upGradeFunc:Function;
      
      public function EnchantExpBar()
      {
         super();
         this.initView();
      }
      
      private function initView() : void
      {
         tipDirctions = "3,0";
         tipStyle = "ddt.view.tips.OneLineTip";
         this._progressBg = ComponentFactory.Instance.creat("enchant.progress.bg");
         addChild(this._progressBg);
         this._progressColorBg = ComponentFactory.Instance.creat("enchant.progressColor.bg");
         addChild(this._progressColorBg);
         this._progressBarMask = new Sprite();
         this._progressBarMask.graphics.beginFill(16777215,1);
         this._progressBarMask.graphics.drawRect(this._progressColorBg.x,this._progressColorBg.y,this._progressColorBg.width,this._progressColorBg.height);
         this._progressBarMask.graphics.endFill();
         this._progressBarMask.width = 0;
         this._progressColorBg.cacheAsBitmap = true;
         this._progressColorBg.mask = this._progressBarMask;
         addChild(this._progressBarMask);
         this._starMc = ComponentFactory.Instance.creat("enchant.starMc");
         addChild(this._starMc);
         this._starMc.visible = false;
         this._progressTxt = ComponentFactory.Instance.creatComponentByStylename("ddt.store.view.exalt.StoreExaltProgressBar.percentage");
         addChild(this._progressTxt);
         PositionUtils.setPos(this._progressTxt,"enchant.percentTxtPos");
         this._scaleValue = this._progressColorBg.width / this._total;
         width = this._progressBg.width;
         height = this._progressBg.height;
         this.initPercentAndTip();
      }
      
      public function initPercentAndTip() : void
      {
         this.setMask(0);
         this._progressTxt.text = "0%";
         tipData = "0/0";
      }
      
      public function initProgress(curExp:Number, sumExp:Number) : void
      {
         var rate:Number = NaN;
         var tempFrame:int = 0;
         this._currentFrame = 0;
         if(sumExp > 0 && curExp < sumExp)
         {
            rate = curExp / sumExp;
            tempFrame = Math.floor(rate * this._total);
            if(tempFrame < 1 && rate > 0)
            {
               tempFrame = 1;
            }
            this._currentFrame = tempFrame;
         }
         this.setMask(this._currentFrame);
         this.setExpPercent(curExp,sumExp);
         this._starMc.visible = false;
      }
      
      public function setExpPercent(curExp:Number, sumExp:Number) : void
      {
         tipData = curExp + "/" + sumExp;
         var percent:Number = sumExp == 0 ? 100 : Number((curExp / sumExp * 10000 / 100).toFixed(2));
         this._progressTxt.text = percent + "%";
      }
      
      public function setMask(value:Number) : void
      {
         var tempWidth:Number = value * this._scaleValue;
         if(isNaN(tempWidth) || tempWidth == 0)
         {
            this._progressBarMask.width = 0;
         }
         else
         {
            if(tempWidth >= this._progressColorBg.width)
            {
               tempWidth %= this._progressColorBg.width;
            }
            this._progressBarMask.width = tempWidth;
         }
         this._starMc.x = this._progressBarMask.x + this._progressBarMask.width;
      }
      
      public function updateProgress(curExp:int, sumExp:int, isUpGrade:Boolean = false) : void
      {
         this._isUpGrade = isUpGrade;
         this._curExp = curExp;
         this._sumExp = sumExp;
         var rate:Number = curExp / sumExp;
         var tempFrame:int = this._isUpGrade ? this._total : int(Math.floor(rate * this._total));
         if(tempFrame < 1 && rate > 0)
         {
            tempFrame = 1;
         }
         if(this._isUpGrade)
         {
            this.setExpPercent(sumExp,sumExp);
         }
         else
         {
            this.setExpPercent(curExp,sumExp);
         }
         if(this._currentFrame != tempFrame)
         {
            this._destFrame = tempFrame;
            this._starMc.visible = true;
            addEventListener(Event.ENTER_FRAME,this.__frameHandler);
         }
      }
      
      protected function __frameHandler(event:Event) : void
      {
         ++this._currentFrame;
         this.setMask(this._currentFrame);
         if(this._currentFrame >= this._destFrame)
         {
            removeEventListener(Event.ENTER_FRAME,this.__frameHandler);
            this._starMc.visible = false;
            if(this._destFrame >= this._total)
            {
               this._currentFrame = 0;
               this.removeProgressCompleteMc();
               this.showProgressCompleteMc();
            }
         }
      }
      
      protected function __completeFrameHandler(event:Event) : void
      {
         if(Boolean(this._progressCompleteMc) && this._progressCompleteMc.currentFrame == this._progressCompleteMc.totalFrames)
         {
            this.removeProgressCompleteMc();
            this._progressTxt.text = 0 + "%";
            this.setMask(0);
            if(this.upGradeFunc != null)
            {
               this.upGradeFunc();
            }
            this.updateProgress(this._curExp,this._sumExp);
         }
      }
      
      private function removeProgressCompleteMc() : void
      {
         if(Boolean(this._progressCompleteMc) && Boolean(this._progressCompleteMc.parent))
         {
            this._progressCompleteMc.removeEventListener(Event.ENTER_FRAME,this.__completeFrameHandler);
            this._progressCompleteMc.stop();
            this._progressCompleteMc.parent.removeChild(this._progressCompleteMc);
            this._progressCompleteMc = null;
         }
      }
      
      private function showProgressCompleteMc() : void
      {
         this._progressCompleteMc = ComponentFactory.Instance.creat("enchant.progressCompleteMc");
         addChildAt(this._progressCompleteMc,3);
         this._progressCompleteMc.addEventListener(Event.ENTER_FRAME,this.__completeFrameHandler);
      }
      
      override public function dispose() : void
      {
         this.removeProgressCompleteMc();
         removeEventListener(Event.ENTER_FRAME,this.__frameHandler);
         if(Boolean(this._starMc))
         {
            this._starMc.stop();
            ObjectUtils.disposeObject(this._starMc);
            this._starMc = null;
         }
         ObjectUtils.disposeObject(this._progressTxt);
         this._progressTxt = null;
         ObjectUtils.disposeObject(this._progressBg);
         this._progressBg = null;
         ObjectUtils.disposeObject(this._progressColorBg);
         this._progressColorBg = null;
         this._progressBarMask.graphics.clear();
         ObjectUtils.disposeObject(this._progressBarMask);
         this._progressBarMask = null;
         super.dispose();
      }
   }
}

