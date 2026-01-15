package ddt.view.common
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.ShowTipManager;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.core.ITipedDisplay;
   import ddt.manager.SoundManager;
   import ddt.view.tips.LevelTipInfo;
   import flash.display.Bitmap;
   import flash.display.BlendMode;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.utils.Dictionary;
   import road7th.utils.MathUtils;
   
   public class LevelIcon extends Sprite implements ITipedDisplay, Disposeable
   {
      
      public static const MAX_LEVEL:int = 70;
      
      public static const MIN_LEVEL:int = 1;
      
      public static const SIZE_BIG:int = 0;
      
      public static const SIZE_SMALL:int = 1;
      
      private static const LEVEL_EFFECT_CLASSPATH:String = "asset.LevelIcon.LevelEffect_";
      
      private static const LEVEL_ICON_CLASSPATH:String = "asset.LevelIcon.Level_";
      
      private var _isBitmap:Boolean;
      
      private var _level:int;
      
      private var _levelBitmaps:Dictionary;
      
      private var _levelEffects:Dictionary;
      
      private var _levelTipInfo:LevelTipInfo;
      
      private var _tipDirctions:String;
      
      private var _tipGapH:int;
      
      private var _tipGapV:int;
      
      private var _tipStyle:String;
      
      private var _size:int;
      
      private var _bmContainer:Sprite;
      
      public function LevelIcon()
      {
         super();
         this._levelBitmaps = new Dictionary();
         this._levelEffects = new Dictionary();
         this._levelTipInfo = new LevelTipInfo();
         this._tipStyle = "core.LevelTips";
         this._tipGapV = 5;
         this._tipGapH = 5;
         this._tipDirctions = "7,6,5";
         this._size = SIZE_BIG;
         mouseChildren = true;
         mouseEnabled = false;
         this._bmContainer = new Sprite();
         this._bmContainer.buttonMode = true;
         addChild(this._bmContainer);
         ShowTipManager.Instance.addTip(this);
      }
      
      private function __click(evt:MouseEvent) : void
      {
         SoundManager.instance.play("008");
      }
      
      public function asDisplayObject() : DisplayObject
      {
         return this;
      }
      
      public function dispose() : void
      {
         var key:String = null;
         var bm:Bitmap = null;
         this._bmContainer.removeEventListener(MouseEvent.CLICK,this.__click);
         ShowTipManager.Instance.removeTip(this);
         this.clearnDisplay();
         for(key in this._levelBitmaps)
         {
            bm = this._levelBitmaps[key];
            bm.bitmapData.dispose();
            delete this._levelBitmaps[key];
         }
         this._levelBitmaps = null;
         this._levelEffects = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
      
      public function setInfo(level:int, reputeCount:int, win:int, total:int, battle:int, exploit:int, enableTip:Boolean = true, isBitmap:Boolean = true, team:int = 1) : void
      {
         var changeLevel:Boolean = this._level != level;
         this._level = MathUtils.getValueInRange(level,MIN_LEVEL,MAX_LEVEL);
         this._isBitmap = isBitmap;
         this._levelTipInfo.Level = this._level;
         this._levelTipInfo.Battle = battle;
         this._levelTipInfo.Win = win;
         this._levelTipInfo.Repute = reputeCount;
         this._levelTipInfo.Total = total;
         this._levelTipInfo.exploit = exploit;
         this._levelTipInfo.enableTip = enableTip;
         this._levelTipInfo.team = team;
         if(changeLevel)
         {
            this.updateView();
         }
      }
      
      public function setSize(size:int) : void
      {
         this._size = size;
         this.updateSize();
      }
      
      public function get tipData() : Object
      {
         return this._levelTipInfo;
      }
      
      public function set tipData(value:Object) : void
      {
         this._levelTipInfo = value as LevelTipInfo;
      }
      
      public function get tipDirctions() : String
      {
         return this._tipDirctions;
      }
      
      public function set tipDirctions(value:String) : void
      {
         this._tipDirctions = value;
      }
      
      public function get tipGapH() : int
      {
         return this._tipGapH;
      }
      
      public function set tipGapH(value:int) : void
      {
         this._tipGapH = value;
      }
      
      public function get tipGapV() : int
      {
         return this._tipGapV;
      }
      
      public function set tipGapV(value:int) : void
      {
         this._tipGapV = value;
      }
      
      public function get tipStyle() : String
      {
         return this._tipStyle;
      }
      
      public function set tipStyle(value:String) : void
      {
         this._tipStyle = value;
      }
      
      public function allowClick() : void
      {
         this._bmContainer.addEventListener(MouseEvent.CLICK,this.__click);
      }
      
      private function addCurrentLevelBitmap() : void
      {
         addChild(this._bmContainer);
         this._bmContainer.addChild(this.creatLevelBitmap(this._level));
      }
      
      private function addCurrentLevelEffect() : void
      {
         var effect:MovieClip = null;
         if(this._isBitmap)
         {
            return;
         }
         effect = this.creatLevelEffect(this._level);
         if(Boolean(effect))
         {
            effect.mouseEnabled = false;
            effect.mouseChildren = false;
            effect.play();
            if(this._level > 40)
            {
               effect.blendMode = BlendMode.ADD;
            }
            addChild(effect);
         }
      }
      
      private function clearnDisplay() : void
      {
         var mc:MovieClip = null;
         while(this._bmContainer.numChildren > 0)
         {
            this._bmContainer.removeChildAt(0);
         }
         while(numChildren > 0)
         {
            mc = getChildAt(0) as MovieClip;
            if(Boolean(mc))
            {
               mc.stop();
            }
            removeChildAt(0);
         }
      }
      
      private function creatLevelBitmap(level:int) : Bitmap
      {
         if(Boolean(this._levelBitmaps[level]))
         {
            return this._levelBitmaps[level];
         }
         var iconBitmap:Bitmap = ComponentFactory.Instance.creatBitmap(LEVEL_ICON_CLASSPATH + level.toString());
         iconBitmap.smoothing = true;
         this._levelBitmaps[level] = iconBitmap;
         return iconBitmap;
      }
      
      private function creatLevelEffect(level:int) : MovieClip
      {
         var effectLevel:int = 0;
         if(MathUtils.isInRange(level,11,20))
         {
            effectLevel = 1;
         }
         else if(MathUtils.isInRange(level,21,30))
         {
            effectLevel = 2;
         }
         else if(MathUtils.isInRange(level,31,40))
         {
            effectLevel = 3;
         }
         else if(MathUtils.isInRange(level,41,50))
         {
            effectLevel = 4;
         }
         else if(MathUtils.isInRange(level,51,60))
         {
            effectLevel = 5;
         }
         else if(MathUtils.isInRange(level,61,70))
         {
            effectLevel = 6;
         }
         if(effectLevel == 0)
         {
            return null;
         }
         if(Boolean(this._levelEffects[effectLevel]))
         {
            return this._levelEffects[effectLevel];
         }
         var levelEffect:MovieClip = ComponentFactory.Instance.creat(LEVEL_EFFECT_CLASSPATH + effectLevel.toString());
         levelEffect.stop();
         this._levelEffects[effectLevel] = levelEffect;
         return levelEffect;
      }
      
      private function updateView() : void
      {
         this.clearnDisplay();
         this.addCurrentLevelBitmap();
         this.addCurrentLevelEffect();
         this.updateSize();
      }
      
      private function updateSize() : void
      {
         if(this._size == SIZE_SMALL)
         {
            scaleX = scaleY = 0.6;
         }
         else if(this._size == SIZE_BIG)
         {
            scaleX = scaleY = 0.75;
         }
      }
   }
}

