package store.view.strength
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Component;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ClassUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.utils.Dictionary;
   import store.data.StoreEquipExperience;
   
   public class StoreStrengthProgress extends Component
   {
      
      protected var _background:Bitmap;
      
      protected var _thuck:Component;
      
      protected var _graphics_thuck:Bitmap;
      
      protected var _progressLabel:FilterFrameText;
      
      protected var _star:MovieClip;
      
      protected var _max:Number = 0;
      
      protected var _currentFrame:int;
      
      private var _strengthenLevel:int;
      
      private var _strengthenExp:int;
      
      private var _progressBarMask:Sprite;
      
      private var _scaleValue:Number;
      
      private var _taskFrames:Dictionary;
      
      private var _total:int = 50;
      
      public function StoreStrengthProgress()
      {
         super();
         this.initView();
      }
      
      protected function initView() : void
      {
         this._background = ComponentFactory.Instance.creatBitmap("asset.ddtstore.StrengthenSpaceProgress");
         PositionUtils.setPos(this._background,"asset.ddtstore.StrengthenSpaceProgressBgPos");
         addChild(this._background);
         this._thuck = ComponentFactory.Instance.creatComponentByStylename("ddtstore.info.thunck");
         addChild(this._thuck);
         this._graphics_thuck = ComponentFactory.Instance.creatBitmap("asset.ddtstore.StrengthenColorStrip");
         addChild(this._graphics_thuck);
         this.initMask();
         this._star = ClassUtils.CreatInstance("asset.strengthen.star");
         this._star.y = this._progressBarMask.y + this._progressBarMask.height / 2;
         addChild(this._star);
         this._progressLabel = ComponentFactory.Instance.creatComponentByStylename("ddtstore.info.StoreStrengthProgressText");
         addChild(this._progressLabel);
         this._scaleValue = this._graphics_thuck.width / this._total;
         this.resetProgress();
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
               this.dispatchEvent(new Event(StoreIIStrengthBG.WEAPONUPGRADESPLAY));
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
      
      private function initMask() : void
      {
         this._progressBarMask = new Sprite();
         this._progressBarMask.graphics.beginFill(16777215,1);
         this._progressBarMask.graphics.drawRect(0,0,this._graphics_thuck.width,this._graphics_thuck.height);
         this._progressBarMask.graphics.endFill();
         this._graphics_thuck.cacheAsBitmap = true;
         this._graphics_thuck.mask = this._progressBarMask;
         addChild(this._progressBarMask);
      }
      
      private function setStarVisible(value:Boolean) : void
      {
         this._star.visible = value;
      }
      
      public function getStarVisible() : Boolean
      {
         return this._star.visible;
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
      
      public function initProgress(info:InventoryItemInfo) : void
      {
         var rate:Number = NaN;
         var tempFrame:int = 0;
         this._currentFrame = 0;
         this._strengthenExp = info.StrengthenExp;
         this._strengthenLevel = info.StrengthenLevel;
         this._max = StoreEquipExperience.expericence[this._strengthenLevel + 1];
         if(this._max > 0 && this._strengthenExp < this._max)
         {
            rate = this._strengthenExp / this._max;
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
      
      public function setProgress(info:InventoryItemInfo) : void
      {
         if(this._strengthenLevel != info.StrengthenLevel)
         {
            this._taskFrames[0] = this._total;
            this._strengthenLevel = info.StrengthenLevel;
         }
         this._strengthenExp = info.StrengthenExp;
         this._max = StoreEquipExperience.expericence[this._strengthenLevel + 1];
         var rate:Number = this._strengthenExp / this._max;
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
         var expPercent:Number = NaN;
         if(this._strengthenExp == 0 || this._strengthenLevel == 0)
         {
            this._progressLabel.text = "0%";
         }
         else
         {
            expPercent = StoreEquipExperience.getExpPercent(this._strengthenLevel,this._strengthenExp);
            if(isNaN(expPercent))
            {
               expPercent = 0;
            }
            this._progressLabel.text = expPercent + "%";
         }
         if(this._strengthenLevel >= 12)
         {
            tipData = "0/0";
         }
         else
         {
            if(isNaN(this._strengthenExp))
            {
               this._strengthenExp = 0;
            }
            if(isNaN(this._max))
            {
               this._max = 0;
            }
            tipData = this._strengthenExp + "/" + this._max;
         }
      }
      
      public function resetProgress() : void
      {
         tipData = "0/0";
         this._progressLabel.text = "0%";
         this._strengthenExp = 0;
         this._max = 0;
         this._currentFrame = 0;
         this._strengthenLevel = -1;
         this.setMask(0);
         this.setStarVisible(false);
         this._taskFrames = new Dictionary();
      }
      
      override public function dispose() : void
      {
         ObjectUtils.disposeObject(this._graphics_thuck);
         this._graphics_thuck = null;
         ObjectUtils.disposeObject(this._background);
         this._background = null;
         ObjectUtils.disposeObject(this._thuck);
         this._thuck = null;
         ObjectUtils.disposeObject(this._progressLabel);
         this._progressLabel = null;
         if(Boolean(this._progressBarMask))
         {
            ObjectUtils.disposeObject(this._progressBarMask);
         }
         if(this.hasEventListener(Event.ENTER_FRAME))
         {
            this.removeEventListener(Event.ENTER_FRAME,this.__startFrame);
         }
         super.dispose();
      }
   }
}

