package Dice.View
{
   import Dice.Controller.DiceController;
   import Dice.Event.DiceEvent;
   import Dice.VO.DiceAwardInfo;
   import com.greensock.TweenLite;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class DiceLuckIntegralView extends Sprite implements Disposeable
   {
      
      private var _bg:ScaleFrameImage;
      
      private var _level:ScaleFrameImage;
      
      private var _luckBar:Bitmap;
      
      private var _grayBar:Bitmap;
      
      private var _caption:Bitmap;
      
      private var _luckIntegral:FilterFrameText;
      
      private var _shape:Shape;
      
      private var _yellowIris:MovieClip;
      
      private var _starlight:MovieClip;
      
      private var _progressEffect:MovieClip;
      
      private var _container:Sprite;
      
      private var _maxIntegral:int;
      
      private var _currentIntegral:int = 0;
      
      private var _tip:DiceTreasureBoxTip;
      
      public function DiceLuckIntegralView()
      {
         super();
         this.preInitialize();
         this.initialize();
         this.addEvent();
      }
      
      private function preInitialize() : void
      {
         this._bg = ComponentFactory.Instance.creatComponentByStylename("asset.dice.luckIntegral.BG");
         this._yellowIris = ComponentFactory.Instance.creat("asset.dice.yellowIris");
         this._starlight = ComponentFactory.Instance.creat("asset.dice.starlight");
         this._progressEffect = ComponentFactory.Instance.creat("asset.dice.progressEffect");
         this._luckBar = ComponentFactory.Instance.creatBitmap("asset.dice.luckIntegral.luckBar");
         this._grayBar = ComponentFactory.Instance.creatBitmap("asset.dice.luckIntegral.grayBar");
         this._caption = ComponentFactory.Instance.creatBitmap("asset.dice.luckIntegral.caption");
         this._level = ComponentFactory.Instance.creatComponentByStylename("asset.dice.luckIntegral.TreasureBox");
         this._luckIntegral = ComponentFactory.Instance.creatComponentByStylename("asset.dice.luckIntegral.number");
         this._tip = ComponentFactory.Instance.creatCustomObject("asset.dice.treasureBox.tip");
         this._container = new Sprite();
         this._container.cacheAsBitmap = true;
         this._shape = new Shape();
         this._shape.cacheAsBitmap = true;
         with(this._shape.graphics)
         {
            beginFill(16777215);
            drawRect(0,0,_luckBar.width,_luckBar.height + 8);
            endFill();
         }
      }
      
      private function initialize() : void
      {
         addChild(this._grayBar);
         this._container.addChild(this._luckBar);
         this._container.addChild(this._progressEffect);
         addChild(this._container);
         addChild(this._shape);
         addChild(this._bg);
         addChild(this._caption);
         addChild(this._luckIntegral);
         addChild(this._yellowIris);
         this._yellowIris.mouseChildren = false;
         this._yellowIris.mouseEnabled = false;
         PositionUtils.setPos(this._yellowIris,"asset.dice.yellowIris.position");
         addChild(this._level);
         addChild(this._starlight);
         this._starlight.mouseChildren = false;
         this._starlight.mouseEnabled = false;
         PositionUtils.setPos(this._starlight,"asset.dice.starlight.position");
         this._shape.x = this._grayBar.x - this._shape.width + 5;
         this._shape.y = this._grayBar.y - 4;
         this._progressEffect.y = this._shape.y + 19;
         this._progressEffect.x = this._shape.x + this._shape.width;
         this._container.mask = this._shape;
         this.setIntegralLevel = DiceController.Instance.LuckIntegralLevel;
         this.setIntegral = DiceController.Instance.LuckIntegral;
      }
      
      private function addEvent() : void
      {
         this._level.addEventListener(MouseEvent.ROLL_OVER,this.__onLevelRollOver);
         this._level.addEventListener(MouseEvent.ROLL_OUT,this.__onLevelRollOut);
         DiceController.Instance.addEventListener(DiceEvent.CHANGED_LUCKINTEGRAL_LEVEL,this.__onLuckIntegralLevelChanged);
         DiceController.Instance.addEventListener(DiceEvent.CHANGED_LUCKINTEGRAL,this.__onLuckIntegralChanged);
      }
      
      private function removeEvent() : void
      {
         this._level.addEventListener(MouseEvent.ROLL_OVER,this.__onLevelRollOver);
         this._level.addEventListener(MouseEvent.ROLL_OUT,this.__onLevelRollOut);
         DiceController.Instance.removeEventListener(DiceEvent.CHANGED_LUCKINTEGRAL_LEVEL,this.__onLuckIntegralLevelChanged);
         DiceController.Instance.removeEventListener(DiceEvent.CHANGED_LUCKINTEGRAL,this.__onLuckIntegralChanged);
      }
      
      private function __onLevelRollOver(event:MouseEvent) : void
      {
         if(this._tip.parent == null)
         {
            this._tip.update();
            addChild(this._tip);
         }
      }
      
      private function __onLevelRollOut(event:MouseEvent) : void
      {
         if(Boolean(this._tip.parent))
         {
            removeChild(this._tip);
         }
      }
      
      private function __onLuckIntegralChanged(event:DiceEvent) : void
      {
         this.setIntegral = DiceController.Instance.LuckIntegral;
      }
      
      private function __onLuckIntegralLevelChanged(event:DiceEvent) : void
      {
         this.setIntegralLevel = DiceController.Instance.LuckIntegralLevel;
      }
      
      public function resetLuckBar(preIntegral:int, maxIntegral:int) : void
      {
         this._maxIntegral = maxIntegral;
         this.setIntegral = preIntegral;
      }
      
      public function set setIntegral(integral:int) : void
      {
         var rate:Number = NaN;
         var current:Number = NaN;
         this._currentIntegral = integral;
         current = this._currentIntegral - (DiceController.Instance.AwardLevelInfo[DiceController.Instance.LuckIntegralLevel - 1] as DiceAwardInfo != null ? (DiceController.Instance.AwardLevelInfo[DiceController.Instance.LuckIntegralLevel - 1] as DiceAwardInfo).integral : 0);
         this._luckIntegral.text = String(current) + " / " + String(this._maxIntegral);
         rate = current / this._maxIntegral;
         rate = this._luckBar.width * rate;
         TweenLite.killTweensOf(this._shape);
         TweenLite.to(this._shape,1,{
            "x":this._luckBar.x - this._luckBar.width + rate,
            "onUpdate":this.onMoveEffect
         });
         this._shape.x = this._luckBar.x - this._luckBar.width + rate;
      }
      
      private function onMoveEffect() : void
      {
         if(Boolean(this._shape) && Boolean(this._progressEffect))
         {
            this._progressEffect.x = this._shape.x + this._shape.width;
         }
      }
      
      public function set setIntegralLevel(level:int) : void
      {
         if(level >= 0 && level < 5)
         {
            this._bg.setFrame(level + 1);
            this._level.setFrame(level + 1);
            this._maxIntegral = (DiceController.Instance.AwardLevelInfo[level] as DiceAwardInfo).integral - (DiceController.Instance.AwardLevelInfo[level - 1] as DiceAwardInfo != null ? (DiceController.Instance.AwardLevelInfo[level - 1] as DiceAwardInfo).integral : 0);
         }
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         TweenLite.killTweensOf(this._shape);
         ObjectUtils.disposeObject(this._yellowIris);
         this._yellowIris = null;
         ObjectUtils.disposeObject(this._starlight);
         this._starlight = null;
         ObjectUtils.disposeObject(this._bg);
         this._bg = null;
         ObjectUtils.disposeObject(this._grayBar);
         this._grayBar = null;
         ObjectUtils.disposeObject(this._luckBar);
         this._luckBar = null;
         ObjectUtils.disposeObject(this._caption);
         this._caption = null;
         ObjectUtils.disposeObject(this._level);
         this._level = null;
         ObjectUtils.disposeObject(this._luckIntegral);
         this._luckIntegral = null;
         ObjectUtils.disposeObject(this._shape);
         this._shape = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

