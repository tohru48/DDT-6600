package magpieBridge.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.vo.AlertInfo;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import flash.display.MovieClip;
   
   public class MagpieHelpView extends BaseAlerFrame
   {
      
      private var _mc:MovieClip;
      
      public function MagpieHelpView()
      {
         super();
      }
      
      override protected function init() : void
      {
         super.init();
         var alerInfo:AlertInfo = new AlertInfo(LanguageMgr.GetTranslation("store.view.HelpButtonText"),LanguageMgr.GetTranslation("shop.PresentFrame.OkBtnText"));
         alerInfo.showCancel = false;
         info = alerInfo;
         this._mc = ComponentFactory.Instance.creat("asset.magpieView.helpInfo");
         this._mc.x = -7;
         this._mc.y = 1;
         addToContent(this._mc);
      }
      
      override public function dispose() : void
      {
         ObjectUtils.disposeObject(this._mc);
         super.dispose();
      }
   }
}

