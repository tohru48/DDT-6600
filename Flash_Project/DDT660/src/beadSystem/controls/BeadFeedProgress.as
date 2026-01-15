package beadSystem.controls
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Component;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ClassUtils;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.manager.PlayerManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.utils.Dictionary;
   
   public class BeadFeedProgress extends Component
   {
      
      protected var _background:Bitmap;
      
      protected var _thuck:Component;
      
      protected var _graphics_thuck:Bitmap;
      
      protected var _progressLabel:FilterFrameText;
      
      protected var _star:MovieClip;
      
      private var _progressBarMask:Sprite;
      
      private var _scaleValue:Number;
      
      private var _total:int = 50;
      
      private var _taskFrames:Dictionary;
      
      private var _currentExp:int;
      
      private var _upLevelExp:int;
      
      private var _currentLevel:int;
      
      private var _currentFrame:int;
      
      public function BeadFeedProgress()
      {
         super();
         this.intView();
      }
      
      private function intView() : void
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
         this._star.y = this._progressBarMask.height / 2;
         addChild(this._star);
         this._progressLabel = ComponentFactory.Instance.creatComponentByStylename("ddtstore.info.StoreStrengthProgressText");
         addChild(this._progressLabel);
         this._scaleValue = this._graphics_thuck.width / this._total;
         this.resetProgress();
      }
      
      public function set currentExp(value:int) : void
      {
         this._currentExp = value;
      }
      
      public function set upLevelExp(value:int) : void
      {
         this._upLevelExp = value;
      }
      
      public function resetProgress() : void
      {
         tipData = "0/0";
         this._progressLabel.text = "0%";
         this._currentExp = 0;
         this._upLevelExp = 0;
         this._currentFrame = 0;
         this._currentLevel = -1;
         this.setMask(0);
         this.setStarVisible(false);
         this._taskFrames = new Dictionary();
      }
      
      public function intProgress(info:InventoryItemInfo) : void
      {
         var rate:Number = NaN;
         var tempFrame:int = 0;
         this._currentFrame = 0;
         this._currentLevel = 5;
         if(this._upLevelExp > 0 && this._currentExp < this._upLevelExp)
         {
            rate = this._currentExp / this._upLevelExp;
            tempFrame = Math.floor(rate * this._total);
            if(tempFrame < 1 && rate > 0)
            {
               tempFrame = 1;
            }
            this._currentFrame = tempFrame;
         }
         this.setMask(this._currentFrame);
         this.setExpPercent();
         this.setStarVisible(false);
         this._taskFrames = new Dictionary();
      }
      
      public function setProgress(info:InventoryItemInfo) : void
      {
         if(this._currentLevel == 6)
         {
            this._taskFrames[0] = this._total;
            this._currentLevel = 6;
         }
         var rate:Number = this._currentExp / this._upLevelExp;
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
      
      private function startProgress() : void
      {
         this.addEventListener(Event.ENTER_FRAME,this.__startFrame);
      }
      
      private function __startFrame(event:Event) : void
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
               event.stopImmediatePropagation();
            }
         }
      }
      
      private function setExpPercent() : void
      {
         var expPercent:Number = NaN;
         if(this._currentExp == 0 || int(PlayerManager.Instance.Self.embedUpLevelCell.itemInfo.Hole1) == 19)
         {
            this._progressLabel.text = "0%";
         }
         else
         {
            expPercent = int(this._currentExp / this._upLevelExp * 100);
            if(isNaN(expPercent))
            {
               expPercent = 0;
            }
            this._progressLabel.text = expPercent + "%";
         }
         if(isNaN(this._currentExp))
         {
            this._currentExp = 0;
         }
         if(isNaN(this._upLevelExp))
         {
            this._upLevelExp = 0;
         }
         if(int(PlayerManager.Instance.Self.embedUpLevelCell.itemInfo.Hole1) == 19)
         {
            tipData = this._currentExp + "/" + 0;
         }
         else
         {
            tipData = this._currentExp + "/" + this._upLevelExp;
         }
      }
      
      private function setStarVisible(value:Boolean) : void
      {
         this._star.visible = value;
      }
      
      private function setMask(value:Number) : void
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
   }
}

