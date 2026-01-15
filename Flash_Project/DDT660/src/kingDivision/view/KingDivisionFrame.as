package kingDivision.view
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.SelectedButton;
   import com.pickgliss.ui.controls.SelectedButtonGroup;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.SoundManager;
   import ddt.manager.StateManager;
   import ddt.manager.TimeManager;
   import ddt.states.StateType;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import game.GameManager;
   import kingDivision.KingDivisionManager;
   import room.RoomManager;
   import room.model.RoomInfo;
   import store.HelpFrame;
   
   public class KingDivisionFrame extends Frame
   {
      
      private static const THISZONE:int = 0;
      
      private static const ALLZONE:int = 1;
      
      private var _outSideFrame:Bitmap;
      
      private var _thisZone:SelectedButton;
      
      private var _allZone:SelectedButton;
      
      private var _tabSelectedButtonGroup:SelectedButtonGroup;
      
      private var _titleImg:Bitmap;
      
      private var _helpBtn:BaseButton;
      
      private var _quaFrame:QualificationsFrame;
      
      private var _proBar:ProgressBarView;
      
      private var _ranFrame:RankingRoundView;
      
      private var _stateNo:Boolean;
      
      public function KingDivisionFrame()
      {
         super();
         this.initView();
         this.addEvent();
      }
      
      private function initView() : void
      {
         this._tabSelectedButtonGroup = new SelectedButtonGroup();
         this._outSideFrame = ComponentFactory.Instance.creatBitmap("asset.kingdivision.frameImg");
         this._titleImg = ComponentFactory.Instance.creatBitmap("asset.kingdivision.title");
         this._thisZone = ComponentFactory.Instance.creatComponentByStylename("kingdivision.kingdivisionFrame.thisZoneTabBtn");
         this._allZone = ComponentFactory.Instance.creatComponentByStylename("kingdivision.kingdivisionFrame.allZoneTabBtn");
         this._helpBtn = ComponentFactory.Instance.creat("kingdivision.kingdivisionFrame.helpBtn");
         this._proBar = ComponentFactory.Instance.creatCustomObject("kingDivisionFrame.progressBarView");
         addToContent(this._outSideFrame);
         addToContent(this._thisZone);
         addToContent(this._allZone);
         addToContent(this._helpBtn);
         addToContent(this._proBar);
         addToContent(this._titleImg);
         this._tabSelectedButtonGroup.addSelectItem(this._thisZone);
         this._tabSelectedButtonGroup.addSelectItem(this._allZone);
         this.selectShow();
      }
      
      private function addEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         this._tabSelectedButtonGroup.addEventListener(Event.CHANGE,this.__changeHandler);
         this._helpBtn.addEventListener(MouseEvent.CLICK,this.__onHelpClick);
         GameManager.Instance.addEventListener(GameManager.START_LOAD,this.__onStartLoad);
      }
      
      private function removeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         this._tabSelectedButtonGroup.removeEventListener(Event.CHANGE,this.__changeHandler);
         this._helpBtn.removeEventListener(MouseEvent.CLICK,this.__onHelpClick);
         GameManager.Instance.removeEventListener(GameManager.START_LOAD,this.__onStartLoad);
      }
      
      protected function __onStartLoad(event:Event) : void
      {
         var roomInfo:RoomInfo = RoomManager.Instance.current;
         if(GameManager.Instance.Current == null)
         {
            return;
         }
         this.dispose();
         StateManager.setState(StateType.ROOM_LOADING,GameManager.Instance.Current);
      }
      
      private function __changeHandler(e:Event) : void
      {
         this.defaultShowThisZoneView();
      }
      
      private function selectShow() : void
      {
         if(KingDivisionManager.Instance.states < 2)
         {
            KingDivisionManager.Instance.zoneIndex = THISZONE;
            this.timeShowView(KingDivisionManager.Instance.dateArr,THISZONE);
            this._tabSelectedButtonGroup.selectIndex = 0;
         }
         else
         {
            KingDivisionManager.Instance.isThisZoneWin = false;
            KingDivisionManager.Instance.zoneIndex = ALLZONE;
            this._proBar.updateZoneImg(ALLZONE);
            this.timeShowView(KingDivisionManager.Instance.allDateArr,ALLZONE);
            this._tabSelectedButtonGroup.selectIndex = 1;
         }
      }
      
      private function defaultShowThisZoneView() : void
      {
         switch(this._tabSelectedButtonGroup.selectIndex)
         {
            case THISZONE:
               if(this._stateNo)
               {
                  return;
               }
               if(KingDivisionManager.Instance.model.states == 2)
               {
                  KingDivisionManager.Instance.isThisZoneWin = true;
               }
               KingDivisionManager.Instance.zoneIndex = THISZONE;
               this._proBar.updateZoneImg(THISZONE);
               this.timeShowView(KingDivisionManager.Instance.dateArr,THISZONE);
               break;
            case ALLZONE:
               if(KingDivisionManager.Instance.model.states < 2 && this._tabSelectedButtonGroup.selectIndex == 1)
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.kingDivision.allzoneTip"));
                  this._stateNo = true;
                  this._tabSelectedButtonGroup.selectIndex = 0;
                  return;
               }
               this._stateNo = false;
               KingDivisionManager.Instance.isThisZoneWin = false;
               KingDivisionManager.Instance.zoneIndex = ALLZONE;
               this._proBar.updateZoneImg(ALLZONE);
               this.timeShowView(KingDivisionManager.Instance.allDateArr,ALLZONE);
               break;
         }
      }
      
      private function timeShowView(dateArr:Array, zone:int) : void
      {
         if(dateArr == null)
         {
            return;
         }
         var dates:Date = TimeManager.Instance.Now();
         if(dateArr[0] == dates.date)
         {
            if(Boolean(this._quaFrame))
            {
               ObjectUtils.disposeObject(this._quaFrame);
               this._quaFrame = null;
            }
            this._quaFrame = ComponentFactory.Instance.creatCustomObject("kingDivisionFrame.qualificationsFrame");
            addToContent(this._quaFrame);
            this._quaFrame.progressBarView = this._proBar;
            this._quaFrame.setDateStages(dateArr);
         }
         else
         {
            if(Boolean(this._ranFrame))
            {
               ObjectUtils.disposeObject(this._ranFrame);
               this._ranFrame = null;
            }
            this._ranFrame = ComponentFactory.Instance.creatCustomObject("kingDivisionFrame.rankingRoundView");
            addToContent(this._ranFrame);
            this._ranFrame.progressBarView = this._proBar;
            this._ranFrame.zone = zone;
            this._ranFrame.setDateStages(dateArr);
         }
         if(Boolean(this._titleImg))
         {
            this._titleImg.bitmapData.dispose();
            ObjectUtils.disposeObject(this._titleImg);
            this._titleImg = null;
         }
         this._titleImg = ComponentFactory.Instance.creatBitmap("asset.kingdivision.title");
         addToContent(this._titleImg);
      }
      
      protected function __onHelpClick(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         var helpBd:DisplayObject = ComponentFactory.Instance.creat("kingdivision.HelpPrompt");
         var helpPage:HelpFrame = ComponentFactory.Instance.creat("kingdivision.HelpFrame");
         helpPage.setView(helpBd);
         helpPage.titleText = LanguageMgr.GetTranslation("store.view.HelpButtonText");
         LayerManager.Instance.addToLayer(helpPage,LayerManager.STAGE_DYANMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      private function __responseHandler(evt:FrameEvent) : void
      {
         if(evt.responseCode == FrameEvent.CLOSE_CLICK || evt.responseCode == FrameEvent.ESC_CLICK)
         {
            SoundManager.instance.play("008");
            this.dispose();
         }
      }
      
      public function get qualificationsFrame() : QualificationsFrame
      {
         return this._quaFrame;
      }
      
      public function get rankingRoundView() : RankingRoundView
      {
         return this._ranFrame;
      }
      
      override public function dispose() : void
      {
         this._stateNo = false;
         KingDivisionManager.Instance.openFrame = false;
         this.removeEvent();
         ObjectUtils.disposeAllChildren(this);
         super.dispose();
         this._titleImg = null;
         this._thisZone = null;
         this._allZone = null;
         this._tabSelectedButtonGroup = null;
         this._titleImg = null;
         this._helpBtn = null;
         this._quaFrame = null;
         this._proBar = null;
         this._ranFrame = null;
      }
   }
}

