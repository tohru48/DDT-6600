package gradeAwardsBoxBtn.view
{
   import bagAndInfo.cell.BagCell;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.MovieImage;
   import com.pickgliss.ui.image.ScaleLeftRightImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.InventoryItemInfo;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import gradeAwardsBoxBtn.ui.GradeAwardsBoxBitmapTitle;
   import hall.HallStateView;
   
   public class GradeAwardsBoxSprite extends Sprite implements Disposeable
   {
      
      private static var instance:GradeAwardsBoxSprite;
      
      private var _gradeAwardsBoxBtn:MovieImage;
      
      private var _gradeBottomTimeTips:FilterFrameText;
      
      private var _gradeBG:ScaleLeftRightImage;
      
      private var _gradeBD:GradeAwardsBoxBitmapTitle;
      
      private var _gradeAwardsItem:BagCell;
      
      private var _isVisible:Boolean = false;
      
      private var _hall:HallStateView;
      
      public function GradeAwardsBoxSprite(single:inner)
      {
         super();
         this.init();
      }
      
      public static function getInstance() : GradeAwardsBoxSprite
      {
         if(!instance)
         {
            instance = new GradeAwardsBoxSprite(new inner());
         }
         return instance;
      }
      
      private function init() : void
      {
         this._gradeAwardsBoxBtn = ComponentFactory.Instance.creatComponentByStylename("asset.hall.gradeAwardsBoxBtn");
         this._gradeBD = new GradeAwardsBoxBitmapTitle();
         this._gradeBD.init();
         this._gradeBD._gradeBitmap = this._gradeAwardsBoxBtn.movie.getChildAt(1) as Bitmap;
         this._gradeBottomTimeTips = ComponentFactory.Instance.creat("bossbox.gradeAwardBoxStyle");
         this._gradeBG = ComponentFactory.Instance.creatComponentByStylename("hall.timeBox.LeftRightBG");
         this._gradeAwardsItem = new BagCell(0);
         this._gradeAwardsItem.alpha = 0;
         this._gradeAwardsItem.x = 10;
         this._gradeAwardsItem.y = 8;
         this._gradeAwardsItem.buttonMode = true;
         this._gradeAwardsItem.useHandCursor = true;
         addChild(this._gradeAwardsBoxBtn);
         addChild(this._gradeBG);
         addChild(this._gradeBottomTimeTips);
         addChild(this._gradeAwardsItem);
         this._gradeAwardsBoxBtn.buttonMode = true;
         this._gradeAwardsBoxBtn.useHandCursor = true;
         x = 12;
         y = 162;
      }
      
      public function updateText($text:String) : void
      {
         this._gradeBottomTimeTips.text = $text;
         this._gradeBottomTimeTips.x = (this._gradeBG.width - this._gradeBottomTimeTips.width) * 0.5 + 1 - 9;
      }
      
      public function show(info:InventoryItemInfo, shining:Boolean) : void
      {
         var movie:MovieClip = null;
         if(this._hall != null)
         {
            if(this._gradeBottomTimeTips == null)
            {
               return;
            }
            if(this._gradeAwardsItem == null)
            {
               return;
            }
            this._gradeAwardsItem.info = info;
            this._gradeBD.setBitmapData(info.NeedLevel);
            movie = this._gradeAwardsBoxBtn.movie.getChildAt(2) as MovieClip;
            if(shining)
            {
               movie.visible = true;
               movie.play();
            }
            else
            {
               movie.visible = false;
               movie.stop();
            }
            this._hall.addChild(this);
            this._isVisible = true;
         }
      }
      
      public function hide() : void
      {
         if(this._hall == null)
         {
            return;
         }
         this._isVisible = false;
      }
      
      public function dispose() : void
      {
         ObjectUtils.disposeObject(this._gradeBD);
         this._gradeBD = null;
         ObjectUtils.disposeObject(this._gradeAwardsBoxBtn);
         this._gradeAwardsBoxBtn = null;
         ObjectUtils.disposeObject(this._gradeBG);
         this._gradeBG = null;
         ObjectUtils.disposeObject(this._gradeBottomTimeTips);
         this._gradeBottomTimeTips = null;
         ObjectUtils.disposeObject(this._gradeAwardsItem);
         this._gradeAwardsItem = null;
         while(instance.numChildren > 0)
         {
            instance.removeChildAt(0);
         }
         this._hall = null;
         instance = null;
      }
      
      public function setHall(value:HallStateView) : void
      {
         this._hall = value;
      }
      
      public function get isVisible() : Boolean
      {
         return this._isVisible;
      }
   }
}

class inner
{
   
   public function inner()
   {
      super();
   }
}
