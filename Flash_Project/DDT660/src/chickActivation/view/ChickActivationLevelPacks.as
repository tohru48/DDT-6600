package chickActivation.view
{
   import chickActivation.ChickActivationManager;
   import chickActivation.event.ChickActivationEvent;
   import chickActivation.model.ChickActivationModel;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ClassUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.manager.PlayerManager;
   import ddt.utils.PositionUtils;
   import ddt.view.tips.GoodTipInfo;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   
   public class ChickActivationLevelPacks extends Sprite implements Disposeable
   {
      
      public var packsLevelArr:Array = [{"level":5},{"level":10},{"level":25},{"level":30},{"level":40},{"level":45},{"level":48},{"level":50},{"level":55},{"level":60}];
      
      private var _arrData:Array;
      
      private var _progressLine1:Bitmap;
      
      private var _progressLine2:Bitmap;
      
      private var _drawProgress1Data:BitmapData;
      
      private var _drawProgress2Data:BitmapData;
      
      public function ChickActivationLevelPacks()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         var i:int = 0;
         var sp:LevelPacksComponent = null;
         var goodTipInfo:GoodTipInfo = null;
         var packsLevelBitmap:Bitmap = null;
         var packsMovie:MovieClip = null;
         var itemInfo:InventoryItemInfo = null;
         this._progressLine1 = ComponentFactory.Instance.creatBitmap("assets.chickActivation.levelPacksProgressBg");
         PositionUtils.setPos(this._progressLine1,"chickActivation.progressLinePos1");
         addChild(this._progressLine1);
         this._progressLine2 = ComponentFactory.Instance.creatBitmap("assets.chickActivation.levelPacksProgressBg");
         PositionUtils.setPos(this._progressLine2,"chickActivation.progressLinePos2");
         addChild(this._progressLine2);
         this._drawProgress1Data = ComponentFactory.Instance.creatBitmapData("assets.chickActivation.levelPacksProgress1");
         this._drawProgress2Data = ComponentFactory.Instance.creatBitmapData("assets.chickActivation.levelPacksProgress2");
         var levelDataArr:Array = ChickActivationManager.instance.model.itemInfoList[12];
         for(i = 0; i < this.packsLevelArr.length; i++)
         {
            sp = new LevelPacksComponent();
            goodTipInfo = new GoodTipInfo();
            if(Boolean(levelDataArr))
            {
               itemInfo = ChickActivationManager.instance.model.getInventoryItemInfo(levelDataArr[i]);
               goodTipInfo.itemInfo = itemInfo;
            }
            sp.tipData = goodTipInfo;
            packsLevelBitmap = ComponentFactory.Instance.creatBitmap("assets.chickActivation.packsLevel_" + this.packsLevelArr[i].level);
            PositionUtils.setPos(packsLevelBitmap,"chickActivation.packsLevelBitmapPos");
            packsMovie = ClassUtils.CreatInstance("assets.chickActivation.packsMovie");
            packsMovie.gotoAndStop(1);
            PositionUtils.setPos(packsMovie,"chickActivation.packsMoviePos");
            packsMovie.mouseChildren = false;
            packsMovie.mouseEnabled = false;
            sp.levelIndex = i + 1;
            sp.addChild(packsLevelBitmap);
            sp.addChild(packsMovie);
            sp.x = i % 5 * 116;
            sp.y = int(i / 5) * 80;
            addChild(sp);
            this.packsLevelArr[i].movie = packsMovie;
            this.packsLevelArr[i].sp = sp;
         }
      }
      
      private function initEvent() : void
      {
         this.addEventListener(MouseEvent.CLICK,this.__levelItemsClickHandler);
      }
      
      private function __levelItemsClickHandler(evt:MouseEvent) : void
      {
         var component:LevelPacksComponent = null;
         var levelIndex:int = 0;
         if(evt.target is LevelPacksComponent)
         {
            component = LevelPacksComponent(evt.target);
            if(component.isGray)
            {
               levelIndex = LevelPacksComponent(evt.target).levelIndex;
               dispatchEvent(new ChickActivationEvent(ChickActivationEvent.CLICK_LEVELPACKS,levelIndex));
            }
         }
      }
      
      public function update() : void
      {
         var levelIndex:int = 0;
         var grade:int = 0;
         var i:int = 0;
         var j:int = 0;
         var movie:MovieClip = null;
         var bool:Boolean = false;
         var model:ChickActivationModel = ChickActivationManager.instance.model;
         var day:int = model.getRemainingDay();
         if(model.isKeyOpened > 0 && day > 0)
         {
            levelIndex = -1;
            grade = PlayerManager.Instance.Self.Grade;
            for(i = 0; i < this.packsLevelArr.length; i++)
            {
               if(this.packsLevelArr[i].level <= grade)
               {
                  levelIndex = i;
               }
            }
            if(levelIndex == -1)
            {
               return;
            }
            if(levelIndex > 4)
            {
               this.updateProgressLine(this._progressLine1,4);
               this.updateProgressLine(this._progressLine2,levelIndex - 5);
            }
            else
            {
               this.updateProgressLine(this._progressLine1,levelIndex);
            }
            for(j = 0; j <= levelIndex; j++)
            {
               movie = MovieClip(this.packsLevelArr[j].movie);
               bool = ChickActivationManager.instance.model.getGainLevel(j + 1);
               if(bool)
               {
                  movie.gotoAndStop(1);
                  LevelPacksComponent(this.packsLevelArr[j].sp).buttonGrayFilters(bool);
               }
               else
               {
                  movie.gotoAndStop(2);
                  LevelPacksComponent(this.packsLevelArr[j].sp).buttonGrayFilters(bool);
               }
            }
         }
      }
      
      private function updateProgressLine(_progressLine:Bitmap, _phases:int) : void
      {
         if(_phases < 0)
         {
            return;
         }
         for(var i:int = 0; i <= _phases; i++)
         {
            _progressLine.bitmapData.copyPixels(this._drawProgress1Data,this._drawProgress1Data.rect,new Point(116 * i,0),null,null,true);
            if(i != 0)
            {
               _progressLine.bitmapData.copyPixels(this._drawProgress2Data,this._drawProgress2Data.rect,new Point(116 * (i - 1) + this._drawProgress1Data.width - 7,2),null,null,true);
            }
         }
      }
      
      private function removeEvent() : void
      {
         this.removeEventListener(MouseEvent.CLICK,this.__levelItemsClickHandler);
      }
      
      public function dispose() : void
      {
         var i:int = 0;
         this.removeEvent();
         if(Boolean(this.packsLevelArr))
         {
            for(i = 0; i < this.packsLevelArr.length; i++)
            {
               if(Boolean(this.packsLevelArr[i].sp))
               {
                  ObjectUtils.disposeAllChildren(this.packsLevelArr[i].sp);
                  ObjectUtils.disposeObject(this.packsLevelArr[i].sp);
                  this.packsLevelArr[i].sp = null;
               }
            }
            this.packsLevelArr = null;
         }
         ObjectUtils.disposeObject(this._progressLine1);
         this._progressLine1 = null;
         ObjectUtils.disposeObject(this._progressLine2);
         this._progressLine2 = null;
         ObjectUtils.disposeObject(this._drawProgress1Data);
         this._drawProgress1Data = null;
         ObjectUtils.disposeObject(this._drawProgress2Data);
         this._drawProgress2Data = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

