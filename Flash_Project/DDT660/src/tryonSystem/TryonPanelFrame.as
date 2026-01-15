package tryonSystem
{
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.vo.AlertInfo;
   import ddt.manager.LanguageMgr;
   import ddt.utils.PositionUtils;
   
   public class TryonPanelFrame extends BaseAlerFrame
   {
      
      private var _control:TryonSystemController;
      
      private var _view:TryonPanelView;
      
      public function TryonPanelFrame()
      {
         super();
         var alertInfo:AlertInfo = new AlertInfo(LanguageMgr.GetTranslation("ddt.tryonSystem.title"),"","",true,false);
         alertInfo.submitLabel = LanguageMgr.GetTranslation("ok");
         alertInfo.moveEnable = false;
         info = alertInfo;
      }
      
      public function set controller(control:TryonSystemController) : void
      {
         this._control = control;
         this.initView();
      }
      
      public function initView() : void
      {
         this._view = new TryonPanelView(this._control,this);
         PositionUtils.setPos(this._view,"quest.tryon.tryonPanelPos");
         addToContent(this._view);
      }
      
      override public function dispose() : void
      {
         this._view.dispose();
         this._view = null;
         this._control = null;
         super.dispose();
      }
   }
}

