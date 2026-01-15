package petsBag.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Component;
   import com.pickgliss.ui.image.ScaleLeftRightImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.PetExperience;
   import ddt.manager.LanguageMgr;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.Shape;
   
   public class PetExpProgress extends Component
   {
      
      private var _backGround:Bitmap;
      
      private var _gpItem:ScaleLeftRightImage;
      
      private var _maxGpItem:ScaleLeftRightImage;
      
      private var _gpMask:Shape;
      
      private var _maxGpMask:Shape;
      
      private var _gp:Number = 0;
      
      private var _maxGp:Number = 100;
      
      private var _progressLabel:FilterFrameText;
      
      public function PetExpProgress()
      {
         super();
         _height = 10;
         _width = 10;
         this.initView();
      }
      
      override public function get tipData() : Object
      {
         return _tipData;
      }
      
      private function initView() : void
      {
         this._backGround = ComponentFactory.Instance.creatBitmap("assets.petsBag.Background_Progress1");
         addChild(this._backGround);
         this._gpItem = ComponentFactory.Instance.creatComponentByStylename("petsBag.thuck.Graphic");
         addChild(this._gpItem);
         this._gpMask = this.creatMask(this._gpItem);
         addChild(this._gpMask);
         this._maxGpItem = ComponentFactory.Instance.creatComponentByStylename("petsBag.thuck.maxGraphic");
         addChild(this._maxGpItem);
         this._maxGpMask = this.creatMask(this._maxGpItem);
         addChild(this._maxGpMask);
         this._progressLabel = ComponentFactory.Instance.creatComponentByStylename("petsBag.info.LevelProgressText");
         addChild(this._progressLabel);
      }
      
      private function creatMask(source:DisplayObject) : Shape
      {
         var result:Shape = null;
         result = new Shape();
         result.graphics.beginFill(16711680,1);
         result.graphics.drawRect(0,0,source.width,source.height);
         result.graphics.endFill();
         result.x = source.x;
         result.y = source.y;
         source.mask = result;
         return result;
      }
      
      public function setProgress(value:Number, max:Number) : void
      {
         if(this._gp != value || this._maxGp != max)
         {
            this._gp = value;
            this._maxGp = max;
            this.drawProgress();
         }
      }
      
      public function noPet() : void
      {
         this._maxGpItem.visible = false;
         this._gpItem.visible = false;
         this._progressLabel.visible = false;
      }
      
      private function drawProgress() : void
      {
         var max_width:Number = NaN;
         var lv:int = PetExperience.getLevelByGP(this._gp);
         var x:int = this._gp - PetExperience.expericence[lv - 1];
         var y:int = PetExperience.expericence[lv >= PetExperience.MAX_LEVEL ? PetExperience.MAX_LEVEL - 1 : lv] - PetExperience.expericence[lv - 1];
         var z:int = this._maxGp - this._gp;
         max_width = y == 0 ? 0 : x / y;
         var gp_width:Number = y == 0 ? 0 : (x + z) / y;
         this._gpMask.width = this._gpItem.width * gp_width;
         this._maxGpMask.width = this._maxGpItem.width * max_width;
         _tipData = [x,y].join("/") + LanguageMgr.GetTranslation("ddt.petbag.petExpProgressTip",z);
         this._progressLabel.text = [x,y].join("/");
      }
      
      override public function dispose() : void
      {
         ObjectUtils.disposeObject(this._gpItem);
         this._gpItem = null;
         ObjectUtils.disposeObject(this._backGround);
         this._backGround = null;
         ObjectUtils.disposeObject(this._progressLabel);
         this._progressLabel = null;
         ObjectUtils.disposeObject(this._gpItem);
         this._gpItem = null;
         ObjectUtils.disposeObject(this._maxGpItem);
         this._maxGpItem = null;
         ObjectUtils.disposeObject(this._gpMask);
         this._gpMask = null;
         ObjectUtils.disposeObject(this._maxGpMask);
         this._maxGpMask = null;
         ObjectUtils.disposeAllChildren(this);
         super.dispose();
      }
   }
}

