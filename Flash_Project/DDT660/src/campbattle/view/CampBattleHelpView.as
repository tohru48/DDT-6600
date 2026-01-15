package campbattle.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.vo.AlertInfo;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   
   public class CampBattleHelpView extends BaseAlerFrame
   {
      
      private var _mc:MovieClip;
      
      private var _scrollPanel:ScrollPanel;
      
      private var _back:Bitmap;
      
      public function CampBattleHelpView()
      {
         super();
      }
      
      override protected function init() : void
      {
         super.init();
         var alerInfo:AlertInfo = new AlertInfo(LanguageMgr.GetTranslation("store.view.HelpButtonText"),"",LanguageMgr.GetTranslation("shop.PresentFrame.OkBtnText"));
         info = alerInfo;
         this._back = ComponentFactory.Instance.creat("camp.battle.back");
         addToContent(this._back);
         this._scrollPanel = ComponentFactory.Instance.creatComponentByStylename("ddtCampBattle.views.helpViewScroll");
         addToContent(this._scrollPanel);
         this._mc = ComponentFactory.Instance.creat("camp.battle.helpdes");
         this._scrollPanel.setView(this._mc);
         this._scrollPanel.invalidateViewport();
      }
      
      override public function dispose() : void
      {
         while(Boolean(this._mc.numChildren))
         {
            ObjectUtils.disposeObject(this._mc.getChildAt(0));
         }
         ObjectUtils.disposeObject(this._mc);
         super.dispose();
         this._mc = null;
      }
   }
}

