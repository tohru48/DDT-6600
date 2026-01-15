package gradeAwardsBoxBtn
{
   import bagAndInfo.BagAndInfoManager;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.events.BagEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import flash.events.MouseEvent;
   import gradeAwardsBoxBtn.model.GradeAwardsBoxModel;
   import gradeAwardsBoxBtn.model.RemainingTimeManager;
   import gradeAwardsBoxBtn.view.GradeAwardsBoxSprite;
   import gradeAwardsBoxBtn.view.GradeAwardsFlyIntoBagView;
   import hall.HallStateView;
   
   public class GradeAwardsBoxButtonManager
   {
      
      private static var instance:GradeAwardsBoxButtonManager;
      
      private const ON_FRAME_CLOSE:String = "ofc";
      
      private var _gradeAwardsBoxSprite:GradeAwardsBoxSprite;
      
      public function GradeAwardsBoxButtonManager(single:inner)
      {
         super();
      }
      
      public static function getInstance() : GradeAwardsBoxButtonManager
      {
         if(!instance)
         {
            instance = new GradeAwardsBoxButtonManager(new inner());
         }
         return instance;
      }
      
      public function init() : void
      {
         BagAndInfoManager.Instance.registerOnPreviewFrameCloseHandler(this.ON_FRAME_CLOSE,this.gradeAwardsFlyIntoBag);
         this._gradeAwardsBoxSprite = GradeAwardsBoxSprite.getInstance();
         this._gradeAwardsBoxSprite.addEventListener(MouseEvent.CLICK,this.onGradeAwardsClickHandler);
         PlayerManager.Instance.Self.PropBag.addEventListener(BagEvent.UPDATE,this.onGoodsUpdated);
      }
      
      private function gradeAwardsFlyIntoBag(infos:Array) : void
      {
         new GradeAwardsFlyIntoBagView().onFrameClose(infos);
         var GABModel:GradeAwardsBoxModel = GradeAwardsBoxModel.getInstance();
         var info:InventoryItemInfo = GABModel.getGradeAwardsBoxInfo();
         this.updateGradeAwardsBtn(info);
      }
      
      public function setHall(hall:HallStateView) : void
      {
         this._gradeAwardsBoxSprite.setHall(hall);
         var __info:InventoryItemInfo = GradeAwardsBoxModel.getInstance().getGradeAwardsBoxInfo();
         this.updateGradeAwardsBtn(__info);
      }
      
      protected function onGradeAwardsClickHandler(me:MouseEvent) : void
      {
         var itemInfo:InventoryItemInfo = GradeAwardsBoxModel.getInstance().getGradeAwardsBoxInfo();
         var gradeAwardsBoxNeedLevel:Number = itemInfo.NeedLevel;
         var canGainAwards:int = GradeAwardsBoxModel.getInstance().canGainGradeAwardsOnButtonClicked(itemInfo);
         switch(canGainAwards)
         {
            case 0:
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.over"));
               break;
            case 1:
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.hall.gradeBox.needLevel",gradeAwardsBoxNeedLevel));
               return;
            case 2:
         }
         this._gradeAwardsBoxSprite.hide();
         if(itemInfo != null)
         {
            SocketManager.Instance.out.sendItemOpenUp(itemInfo.BagType,itemInfo.Place);
            this.checkLast(itemInfo);
         }
      }
      
      protected function onGoodsUpdated(e:BagEvent) : void
      {
         this.updateGradeAwardsBtn(GradeAwardsBoxModel.getInstance().getGradeAwardsBoxInfo());
      }
      
      private function updateGradeAwardsBtn(info:InventoryItemInfo = null) : void
      {
         if(this._gradeAwardsBoxSprite == null)
         {
            return;
         }
         if(GradeAwardsBoxModel.getInstance().isShowGradeAwardsBtn(info))
         {
            this._gradeAwardsBoxSprite.show(info,GradeAwardsBoxModel.getInstance().canGain(info));
            this.onButtonShown(info);
         }
         else
         {
            this._gradeAwardsBoxSprite.hide();
            this.onButtonHide();
            this.checkLast(info);
         }
      }
      
      private function onButtonShown(info:InventoryItemInfo) : void
      {
         var timeString:String = null;
         if(this._gradeAwardsBoxSprite.isVisible)
         {
            timeString = GradeAwardsBoxModel.getInstance().getRemainTime(info);
            this._gradeAwardsBoxSprite.updateText(timeString);
            if(!RemainingTimeManager.getInstance().isRuning())
            {
               RemainingTimeManager.getInstance().funOnTimer = this.onTimer;
               RemainingTimeManager.getInstance().start();
            }
         }
      }
      
      private function onButtonHide() : void
      {
         if(!this._gradeAwardsBoxSprite.isVisible)
         {
            RemainingTimeManager.getInstance().stop();
         }
      }
      
      private function onTimer() : void
      {
         var timeString:String = null;
         var shining:Boolean = false;
         var info:InventoryItemInfo = GradeAwardsBoxModel.getInstance().getGradeAwardsBoxInfo();
         if(GradeAwardsBoxModel.getInstance().isShowGradeAwardsBtn(info))
         {
            if(!this._gradeAwardsBoxSprite.isVisible)
            {
               shining = GradeAwardsBoxModel.getInstance().canGain(info);
               this._gradeAwardsBoxSprite.show(info,shining);
            }
            timeString = GradeAwardsBoxModel.getInstance().getRemainTime(info);
            this._gradeAwardsBoxSprite.updateText(timeString);
         }
         else
         {
            RemainingTimeManager.getInstance().stop();
            this._gradeAwardsBoxSprite.hide();
            this.checkLast(info);
         }
      }
      
      private function checkLast(itemInfo:InventoryItemInfo) : void
      {
         if(itemInfo == null)
         {
            return;
         }
         if(GradeAwardsBoxModel.getInstance().isTheLastBoxBtn(itemInfo))
         {
            RemainingTimeManager.getInstance().stop();
            this._gradeAwardsBoxSprite.removeEventListener(MouseEvent.CLICK,this.onGradeAwardsClickHandler);
            this._gradeAwardsBoxSprite.dispose();
            this._gradeAwardsBoxSprite = null;
         }
      }
      
      public function dispose() : void
      {
         PlayerManager.Instance.Self.PropBag.removeEventListener(BagEvent.UPDATE,this.onGoodsUpdated);
         BagAndInfoManager.Instance.unregisterOnPreviewFrameCloseHandler(this.ON_FRAME_CLOSE);
         RemainingTimeManager.getInstance().stop();
         if(this._gradeAwardsBoxSprite != null)
         {
            this._gradeAwardsBoxSprite.removeEventListener(MouseEvent.CLICK,this.onGradeAwardsClickHandler);
            this._gradeAwardsBoxSprite = null;
         }
         instance = null;
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
