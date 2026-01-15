package kingDivision.view
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.SelectedButtonGroup;
   import com.pickgliss.ui.controls.SelectedCheckButton;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.events.Event;
   import kingDivision.KingDivisionManager;
   
   public class RewardView extends Frame
   {
      
      private static const THISZONE:int = 0;
      
      private static const ALLZONE:int = 1;
      
      private var _bg:Bitmap;
      
      private var _thisZoneBtn:SelectedCheckButton;
      
      private var _allZoneBtn:SelectedCheckButton;
      
      private var _selectedBtnGroup:SelectedButtonGroup;
      
      private var _rewardList:RewardList;
      
      private var _rewardPanel:ScrollPanel;
      
      public function RewardView()
      {
         super();
         this.initView();
         this.addEvent();
      }
      
      private function initView() : void
      {
         this._selectedBtnGroup = new SelectedButtonGroup(false,1);
         titleText = LanguageMgr.GetTranslation("kingDivision.rewardView.titleName");
         this._bg = ComponentFactory.Instance.creatBitmap("asset.rewardView.bg");
         this._thisZoneBtn = ComponentFactory.Instance.creatComponentByStylename("rewardView.thisZoneBtn");
         this._selectedBtnGroup.addSelectItem(this._thisZoneBtn);
         this._allZoneBtn = ComponentFactory.Instance.creatComponentByStylename("rewardView.allZoneBtn");
         this._selectedBtnGroup.addSelectItem(this._allZoneBtn);
         this._rewardList = ComponentFactory.Instance.creatComponentByStylename("kingDivision.RewardList");
         this._rewardPanel = ComponentFactory.Instance.creatComponentByStylename("assets.rewardView.consorPanel");
         this._rewardPanel.setView(this._rewardList);
         addToContent(this._bg);
         addToContent(this._thisZoneBtn);
         addToContent(this._allZoneBtn);
         addToContent(this._rewardPanel);
         this._selectedBtnGroup.selectIndex = 0;
         KingDivisionManager.Instance.model.goodsZone = 0;
         this.updateRewardList();
      }
      
      private function addEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         this._selectedBtnGroup.addEventListener(Event.CHANGE,this.__typeChange);
      }
      
      private function removeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         this._selectedBtnGroup.removeEventListener(Event.CHANGE,this.__typeChange);
      }
      
      private function __typeChange(evt:Event) : void
      {
         this.defaultShowThisZoneView();
      }
      
      private function defaultShowThisZoneView() : void
      {
         switch(this._selectedBtnGroup.selectIndex)
         {
            case THISZONE:
               KingDivisionManager.Instance.model.goodsZone = 0;
               this.updateRewardList();
               break;
            case ALLZONE:
               KingDivisionManager.Instance.model.goodsZone = 1;
               this.updateRewardList();
         }
      }
      
      private function updateRewardList() : void
      {
         if(Boolean(this._rewardList))
         {
            ObjectUtils.disposeObject(this._rewardList);
            this._rewardList = null;
         }
         if(Boolean(this._rewardPanel))
         {
            ObjectUtils.disposeObject(this._rewardPanel);
            this._rewardPanel = null;
         }
         this._rewardList = ComponentFactory.Instance.creatComponentByStylename("kingDivision.RewardList");
         this._rewardPanel = ComponentFactory.Instance.creatComponentByStylename("assets.rewardView.consorPanel");
         this._rewardPanel.setView(this._rewardList);
         addToContent(this._rewardPanel);
      }
      
      private function __responseHandler(evt:FrameEvent) : void
      {
         if(evt.responseCode == FrameEvent.CLOSE_CLICK || evt.responseCode == FrameEvent.ESC_CLICK)
         {
            SoundManager.instance.play("008");
            this.dispose();
         }
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         ObjectUtils.disposeObject(this._thisZoneBtn);
         this._thisZoneBtn = null;
         ObjectUtils.disposeObject(this._allZoneBtn);
         this._allZoneBtn = null;
         ObjectUtils.disposeObject(this._rewardList);
         this._rewardList = null;
         ObjectUtils.disposeObject(this._rewardPanel);
         this._rewardPanel = null;
         super.dispose();
      }
   }
}

