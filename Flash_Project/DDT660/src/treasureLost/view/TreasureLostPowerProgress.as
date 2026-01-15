package treasureLost.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Component;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class TreasureLostPowerProgress extends Component
   {
      
      private var _pBar:Bitmap;
      
      private var _energyProgressBarFrame:Bitmap;
      
      private var _energyProgressBar:Bitmap;
      
      private var _energyProgressBarBitmapData:BitmapData;
      
      private var _energyTxt:FilterFrameText;
      
      private var _rectangle:Rectangle = new Rectangle();
      
      private var _progressBg:Bitmap;
      
      private var _progressTxt:Bitmap;
      
      public function TreasureLostPowerProgress()
      {
         super();
         this.initView();
      }
      
      private function initView() : void
      {
         this._progressBg = ComponentFactory.Instance.creatBitmap("treasureLost.powerBg");
         addChild(this._progressBg);
         this._progressTxt = ComponentFactory.Instance.creatBitmap("treasureLost.powerTxt");
         addChild(this._progressTxt);
         this._energyProgressBarFrame = ComponentFactory.Instance.creatBitmap("treasureLost.powerProgressBg");
         addChild(this._energyProgressBarFrame);
         this._pBar = ComponentFactory.Instance.creatBitmap("treasureLost.powerProgressTxtBg");
         this._energyProgressBar = new Bitmap();
         this._energyProgressBar.x = this._pBar.x;
         this._energyProgressBar.y = this._pBar.y;
         addChild(this._energyProgressBar);
         this._energyTxt = ComponentFactory.Instance.creatComponentByStylename("hall.playerInfo.energyTxt");
         PositionUtils.setPos(this._energyTxt,"treasureLost.powerProgresstxtPos");
         addChild(this._energyTxt);
      }
      
      public function showProgressBar(energyNum:int, allNum:int) : void
      {
         this._energyTxt.text = energyNum + "/" + allNum;
         this._rectangle.x = 0;
         this._rectangle.y = 0;
         this._rectangle.height = this._pBar.height;
         this._rectangle.width = Math.ceil(energyNum / allNum * this._pBar.width);
         if(this._rectangle.height <= 0)
         {
            this._rectangle.height = 1;
         }
         if(this._rectangle.width <= 0)
         {
            this._rectangle.width = 1;
         }
         this._energyProgressBarBitmapData = new BitmapData(this._rectangle.width,this._rectangle.height,true,0);
         this._energyProgressBarBitmapData.copyPixels(this._pBar.bitmapData,this._rectangle,new Point(0,0));
         this._energyProgressBar.bitmapData = this._energyProgressBarBitmapData;
      }
      
      override public function dispose() : void
      {
         if(Boolean(this._energyProgressBar) && Boolean(this._energyProgressBar.bitmapData))
         {
            this._energyProgressBar.bitmapData.dispose();
         }
         this._energyProgressBar = null;
         if(Boolean(this._energyProgressBarFrame))
         {
            ObjectUtils.disposeObject(this._energyProgressBarFrame);
            this._energyProgressBarFrame = null;
         }
         if(Boolean(this._energyTxt))
         {
            ObjectUtils.disposeObject(this._energyTxt);
            this._energyTxt = null;
         }
         if(Boolean(this._progressBg))
         {
            ObjectUtils.disposeObject(this._progressBg);
            this._progressBg = null;
         }
         if(Boolean(this._progressTxt))
         {
            ObjectUtils.disposeObject(this._progressTxt);
            this._progressTxt = null;
         }
         if(Boolean(this._pBar))
         {
            ObjectUtils.disposeObject(this._pBar);
            this._pBar = null;
         }
         if(Boolean(this._energyProgressBarBitmapData))
         {
            ObjectUtils.disposeObject(this._energyProgressBarBitmapData);
            this._energyProgressBarBitmapData = null;
         }
         if(Boolean(this._rectangle))
         {
            this._rectangle = null;
         }
         super.dispose();
      }
   }
}

