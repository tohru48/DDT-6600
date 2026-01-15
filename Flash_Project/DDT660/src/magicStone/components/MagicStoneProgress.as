package magicStone.components
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Component;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.Bitmap;
   
   public class MagicStoneProgress extends Component
   {
      
      private var _progressBg:Bitmap;
      
      private var _progress:Bitmap;
      
      private var _progressMask:Bitmap;
      
      private var _progressTxt:FilterFrameText;
      
      public function MagicStoneProgress()
      {
         super();
         this.initView();
         this.setData(0,0);
      }
      
      private function initView() : void
      {
         this._progress = ComponentFactory.Instance.creat("magicStone.colorStrip");
         addChild(this._progress);
         this._progressBg = ComponentFactory.Instance.creat("magicStone.spaceProgress");
         addChild(this._progressBg);
         this._progressMask = ComponentFactory.Instance.creat("magicStone.spaceProgress");
         addChild(this._progressMask);
         this._progress.mask = this._progressMask;
         this._progressTxt = ComponentFactory.Instance.creatComponentByStylename("magicStone.progressTxt");
         addChild(this._progressTxt);
         tipStyle = "ddt.view.tips.OneLineTip";
         tipDirctions = "7";
         tipGapV = 20;
      }
      
      public function setData(completed:int, total:int) : void
      {
         this._progressMask.scaleX = completed / total;
         tipData = completed + "/" + total;
         this._progressTxt.text = int(completed / total * 100) + "%";
      }
      
      override public function dispose() : void
      {
         ObjectUtils.disposeObject(this._progress);
         this._progress = null;
         ObjectUtils.disposeObject(this._progressBg);
         this._progressBg = null;
         ObjectUtils.disposeObject(this._progressMask);
         this._progressMask = null;
         ObjectUtils.disposeObject(this._progressTxt);
         this._progressTxt = null;
         super.dispose();
      }
   }
}

