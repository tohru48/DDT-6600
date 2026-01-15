package magicHouse.magicCollection
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Component;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ClassUtils;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.utils.Dictionary;
   import magicHouse.MagicHouseManager;
   
   public class MagicHouseUpgradeProgress extends Component
   {
      
      private static const MAXLEVEL:int = 5;
      
      private var _background:Bitmap;
      
      protected var _graphics_thuck:Bitmap;
      
      protected var _progressLabel:FilterFrameText;
      
      protected var _star:MovieClip;
      
      private var _progressBarMask:Sprite;
      
      private var _total:int = 50;
      
      private var _scaleValue:Number;
      
      protected var _max:Number = 0;
      
      private var _exp:int;
      
      protected var _currentFrame:int;
      
      private var _taskFrames:Dictionary;
      
      private var _level:int;
      
      public function MagicHouseUpgradeProgress()
      {
         super();
         this.initView();
      }
      
      private function initView() : void
      {
         this._background = ComponentFactory.Instance.creatBitmap("magichouse.upgradeprogress.bg");
         addChild(this._background);
         this._graphics_thuck = ComponentFactory.Instance.creatBitmap("magichouse.upgradeprogress.progress");
         addChild(this._graphics_thuck);
         this.initMask();
         this._star = ClassUtils.CreatInstance("magichouse.upgradeprogress.light");
         this._star.y = this._progressBarMask.y + this._progressBarMask.height / 2;
         addChild(this._star);
         this._progressLabel = ComponentFactory.Instance.creatComponentByStylename("magichouse.collectionItem.upgradeProgressText");
         addChild(this._progressLabel);
         this._scaleValue = this._graphics_thuck.width / this._total;
         this.resetProgress();
      }
      
      private function initMask() : void
      {
         this._progressBarMask = new Sprite();
         this._progressBarMask.graphics.beginFill(16777215,1);
         this._progressBarMask.graphics.drawRect(7,5,this._graphics_thuck.width,this._graphics_thuck.height);
         this._progressBarMask.graphics.endFill();
         this._graphics_thuck.cacheAsBitmap = true;
         this._graphics_thuck.mask = this._progressBarMask;
         addChild(this._progressBarMask);
      }
      
      private function startProgress() : void
      {
         this.addEventListener(Event.ENTER_FRAME,this.__startFrame);
      }
      
      private function __startFrame(e:Event) : void
      {
         ++this._currentFrame;
         this.setMask(this._currentFrame);
         var frameNum:int = 0;
         if(this._taskFrames.hasOwnProperty(0))
         {
            frameNum = int(this._taskFrames[0]);
         }
         if(frameNum == 0 && Boolean(this._taskFrames.hasOwnProperty(1)))
         {
            frameNum = int(this._taskFrames[1]);
         }
         if(this._currentFrame >= frameNum)
         {
            if(frameNum >= this._total)
            {
               this._currentFrame = 0;
               this._taskFrames[0] = 0;
            }
            else
            {
               this._taskFrames[1] = 0;
               this.removeEventListener(Event.ENTER_FRAME,this.__startFrame);
               this.setStarVisible(false);
               e.stopImmediatePropagation();
            }
         }
      }
      
      public function resetProgress() : void
      {
         tipData = "0/0";
         this._progressLabel.text = "0%";
         this._exp = 0;
         this._max = 0;
         this._currentFrame = 0;
         this._level = -1;
         this.setMask(0);
         this.setStarVisible(false);
         this._taskFrames = new Dictionary();
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
            if(tempWidth >= this._graphics_thuck.width)
            {
               tempWidth %= this._graphics_thuck.width;
            }
            this._progressBarMask.width = tempWidth;
         }
         this._star.x = this._progressBarMask.x + this._progressBarMask.width;
      }
      
      private function setStarVisible(value:Boolean) : void
      {
         this._star.visible = value;
      }
      
      public function getStarVisible() : Boolean
      {
         return this._star.visible;
      }
      
      public function initProgress($lv:int, $exp:int) : void
      {
         var rate:Number = NaN;
         var tempFrame:int = 0;
         this._currentFrame = 0;
         this._exp = $exp;
         this._level = $lv;
         if(this._level != MAXLEVEL)
         {
            this._max = MagicHouseManager.instance.levelUpNumber[this._level];
         }
         else
         {
            this._max = 0;
         }
         if(this._max > 0 && this._exp < this._max)
         {
            rate = this._exp / this._max;
            tempFrame = Math.floor(rate * this._total);
            if(tempFrame < 1 && rate > 0)
            {
               tempFrame = 1;
            }
            this._currentFrame = tempFrame;
         }
         this.setMask(this._currentFrame);
         this.setExpPercent();
         this._taskFrames = new Dictionary();
         if(this.hasEventListener(Event.ENTER_FRAME))
         {
            this.removeEventListener(Event.ENTER_FRAME,this.__startFrame);
         }
         this.setStarVisible(false);
      }
      
      public function setProgress($lv:int, $exp:int) : void
      {
         if(this._level != $lv)
         {
            this._taskFrames[0] = this._total;
            this._level = $lv;
         }
         this._exp = $exp;
         if(this._level != MAXLEVEL)
         {
            this._max = MagicHouseManager.instance.levelUpNumber[this._level];
         }
         else
         {
            this._max = 0;
         }
         var rate:Number = this._exp / this._max;
         var tempFrame:int = Math.floor(rate * this._total);
         if(tempFrame < 1 && rate > 0)
         {
            tempFrame = 1;
         }
         if(this._currentFrame == tempFrame)
         {
            if(Boolean(this._taskFrames[0]) && int(this._taskFrames[0]) != 0)
            {
               this.setStarVisible(true);
               this._taskFrames[1] = tempFrame;
               this.startProgress();
            }
         }
         else
         {
            this.setStarVisible(true);
            this._taskFrames[1] = tempFrame;
            this.startProgress();
         }
         this.setExpPercent();
      }
      
      public function setExpPercent() : void
      {
         this._progressLabel.text = this._exp + "/" + this._max;
         if(this._level >= MAXLEVEL)
         {
            tipData = "0/0";
         }
         else
         {
            if(isNaN(this._exp))
            {
               this._exp = 0;
            }
            if(isNaN(this._max))
            {
               this._max = 0;
            }
            tipData = this._exp + "/" + this._max;
         }
      }
      
      override public function dispose() : void
      {
         if(Boolean(this._background))
         {
            ObjectUtils.disposeObject(this._background);
         }
         this._background = null;
         if(Boolean(this._graphics_thuck))
         {
            ObjectUtils.disposeObject(this._graphics_thuck);
         }
         this._graphics_thuck = null;
         if(Boolean(this._progressLabel))
         {
            ObjectUtils.disposeObject(this._progressLabel);
         }
         this._progressLabel = null;
         if(Boolean(this._star))
         {
            ObjectUtils.disposeObject(this._star);
         }
         this._star = null;
         if(Boolean(this._progressBarMask))
         {
            ObjectUtils.disposeObject(this._progressBarMask);
         }
         this._progressBarMask = null;
         if(this.hasEventListener(Event.ENTER_FRAME))
         {
            this.removeEventListener(Event.ENTER_FRAME,this.__startFrame);
         }
         super.dispose();
      }
   }
}

