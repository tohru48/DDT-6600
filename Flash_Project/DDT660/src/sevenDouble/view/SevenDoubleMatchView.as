package sevenDouble.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.vo.AlertInfo;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.InviteManager;
   import ddt.manager.LanguageMgr;
   import flash.display.Bitmap;
   import flash.events.MouseEvent;
   import room.view.roomView.SingleRoomViewForSeven;
   import sevenDouble.SevenDoubleManager;
   
   public class SevenDoubleMatchView extends SingleRoomViewForSeven
   {
      
      private var _carImg:Bitmap;
      
      public function SevenDoubleMatchView()
      {
         super();
         info = new AlertInfo(LanguageMgr.GetTranslation("sevenDouble.frame.matchViewTitleTxt"),"","",false,false);
         _model = ComponentFactory.Instance.creatComponentByStylename("sevenDouble.matchViewtextIcon");
         addToContent(_model);
         _cancelBtn = ComponentFactory.Instance.creatComponentByStylename("sevenDouble.matchViewCancelBtn");
         addToContent(_cancelBtn);
         _cancelBtn.addEventListener(MouseEvent.CLICK,__onCancel,false,0,true);
         _chatBtn.visible = false;
         InviteManager.Instance.enabled = false;
         _isCancelWait = false;
      }
      
      override protected function createRightView() : void
      {
         this._carImg = ComponentFactory.Instance.creatBitmap("asset.sevenDouble.matchView.car" + SevenDoubleManager.instance.carStatus);
         addToContent(this._carImg);
         _explain = ComponentFactory.Instance.creatComponentByStylename("sevenDouble.frame.matchViewTipTxt");
         _explain.text = LanguageMgr.GetTranslation("sevenDouble.frame.matchViewTipTxt");
         addToContent(_explain);
      }
      
      override public function dispose() : void
      {
         _cancelBtn.removeEventListener(MouseEvent.CLICK,__onCancel);
         ObjectUtils.disposeObject(this._carImg);
         this._carImg = null;
         super.dispose();
         InviteManager.Instance.enabled = true;
      }
   }
}

