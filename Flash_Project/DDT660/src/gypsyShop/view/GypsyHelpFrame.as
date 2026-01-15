package gypsyShop.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.vo.AlertInfo;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import flash.display.MovieClip;
   
   public class GypsyHelpFrame extends BaseAlerFrame
   {
      
      private var _mc:MovieClip;
      
      public function GypsyHelpFrame()
      {
         super();
      }
      
      override protected function init() : void
      {
         super.init();
         var alertInfo:AlertInfo = new AlertInfo(LanguageMgr.GetTranslation("tank.game.GameView.gypsyHelpTitle"));
         alertInfo.showCancel = false;
         info = alertInfo;
         this._mc = ComponentFactory.Instance.creat("gypsy.help");
         this._mc.x = -7;
         this._mc.y = 1;
         addToContent(this._mc);
      }
      
      override public function dispose() : void
      {
         ObjectUtils.disposeObject(this._mc);
         this._mc = null;
         super.dispose();
      }
   }
}

