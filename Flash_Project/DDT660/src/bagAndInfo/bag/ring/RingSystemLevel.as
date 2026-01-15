package bagAndInfo.bag.ring
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import flash.display.Bitmap;
   import flash.display.Shape;
   import flash.display.Sprite;
   
   public class RingSystemLevel extends Sprite implements Disposeable
   {
       
      
      private var _icon:Bitmap;
      
      private var _level:FilterFrameText;
      
      private var _levelBg:Bitmap;
      
      private var _progress:Bitmap;
      
      private var _mask:Shape;
      
      private var _exp:FilterFrameText;
      
      private var _infoText:FilterFrameText;
      
      public function RingSystemLevel()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         this._icon = ComponentFactory.Instance.creat("asset.bagAndInfo.bag.RingSystemView.OpenBtn");
         this._icon.x = 23;
         this._icon.y = 2;
         addChild(this._icon);
         this._level = ComponentFactory.Instance.creatComponentByStylename("bagAndInfo.bag.RingSystemView.levelText");
         addChild(this._level);
         this.creatProgress();
         this._exp = ComponentFactory.Instance.creatComponentByStylename("bagAndInfo.bag.RingSystemView.expText");
         addChild(this._exp);
         this._infoText = ComponentFactory.Instance.creatComponentByStylename("bagAndInfo.bag.RingSystemView.infoText");
         this._infoText.text = LanguageMgr.GetTranslation("ddt.bagandinfo.ringSystem.infoText1");
         addChild(this._infoText);
      }
      
      private function creatProgress() : void
      {
         this._progress = ComponentFactory.Instance.creat("asset.bagAndInfo.bag.RingSystem.levelProgress");
         addChild(this._progress);
         this._levelBg = ComponentFactory.Instance.creat("asset.bagAndInfo.bag.RingSystem.levelProgressBg");
         addChild(this._levelBg);
         this._mask = new Shape();
         this._mask.graphics.beginFill(0,0.5);
         this._mask.graphics.drawRect(this._progress.x - this._progress.width,this._progress.y,this._progress.width,this._progress.height);
         this._mask.graphics.endFill();
         addChild(this._mask);
         this._progress.mask = this._mask;
      }
      
      public function setProgress(param1:int, param2:int, param3:int) : void
      {
         this._level.text = LanguageMgr.GetTranslation("ddt.bagandinfo.ringSystem.levelText",param2);
         this._mask.x += param1 * this._progress.width / param3;
         this._exp.text = param1 + "/" + param3;
      }
      
      private function initEvent() : void
      {
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         ObjectUtils.disposeObject(this._icon);
         this._icon = null;
         ObjectUtils.disposeObject(this._level);
         this._level = null;
         ObjectUtils.disposeObject(this._levelBg);
         this._levelBg = null;
         ObjectUtils.disposeObject(this._mask);
         this._mask = null;
         ObjectUtils.disposeObject(this._progress);
         this._progress = null;
         ObjectUtils.disposeObject(this._exp);
         this._exp = null;
         ObjectUtils.disposeObject(this._infoText);
         this._infoText = null;
      }
      
      private function removeEvent() : void
      {
      }
   }
}
