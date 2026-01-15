package church.view.weddingRoom.frame
{
   import church.controller.ChurchRoomController;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.SelectedButton;
   import com.pickgliss.ui.controls.SelectedButtonGroup;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.vo.AlertInfo;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.ChurchManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.ServerConfigManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class WeddingRoomContinuationView extends BaseAlerFrame
   {
      
      private var _bg:ScaleBitmapImage;
      
      private var _controller:ChurchRoomController;
      
      private var _alertInfo:AlertInfo;
      
      private var _roomContinuationTime1SelectedBtn:SelectedButton;
      
      private var _roomContinuationTime2SelectedBtn:SelectedButton;
      
      private var _roomContinuationTime3SelectedBtn:SelectedButton;
      
      private var _roomCreateTime1Txt:FilterFrameText;
      
      private var _roomCreateTime2Txt:FilterFrameText;
      
      private var _roomCreateTime3Txt:FilterFrameText;
      
      private var _roomCreateMoney1Txt:FilterFrameText;
      
      private var _roomCreateMoney2Txt:FilterFrameText;
      
      private var _roomCreateMoney3Txt:FilterFrameText;
      
      private var _roomContinuationTimeGroup:SelectedButtonGroup;
      
      private var _alert:BaseAlerFrame;
      
      public function WeddingRoomContinuationView()
      {
         super();
         this.initialize();
      }
      
      public function get controller() : ChurchRoomController
      {
         return this._controller;
      }
      
      public function set controller(value:ChurchRoomController) : void
      {
         this._controller = value;
      }
      
      protected function initialize() : void
      {
         this.setView();
         this.setEvent();
      }
      
      private function setView() : void
      {
         cancelButtonStyle = "core.simplebt";
         submitButtonStyle = "core.simplebt";
         this._alertInfo = new AlertInfo("",LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"));
         this._alertInfo.moveEnable = false;
         this._alertInfo.title = LanguageMgr.GetTranslation("church.room.WeddingRoomContinuationView.title");
         info = this._alertInfo;
         this.escEnable = true;
         this._bg = ComponentFactory.Instance.creatComponentByStylename("church.room.continuationRoomFrameBgAsset");
         addToContent(this._bg);
         this._roomContinuationTime1SelectedBtn = ComponentFactory.Instance.creat("asset.church.roomCreateTimeSelectedBtn");
         addToContent(this._roomContinuationTime1SelectedBtn);
         PositionUtils.setPos(this._roomContinuationTime1SelectedBtn,"church.view.roomContinuationCreateTime1Btn.pos");
         this._roomContinuationTime2SelectedBtn = ComponentFactory.Instance.creat("asset.church.roomCreateTimeSelectedBtn");
         addToContent(this._roomContinuationTime2SelectedBtn);
         PositionUtils.setPos(this._roomContinuationTime2SelectedBtn,"church.view.roomContinuationCreateTime2Btn.pos");
         this._roomContinuationTime3SelectedBtn = ComponentFactory.Instance.creat("asset.church.roomCreateTimeSelectedBtn");
         addToContent(this._roomContinuationTime3SelectedBtn);
         PositionUtils.setPos(this._roomContinuationTime3SelectedBtn,"church.view.roomContinuationCreateTime3Btn.pos");
         this._roomContinuationTimeGroup = new SelectedButtonGroup(false);
         this._roomContinuationTimeGroup.addSelectItem(this._roomContinuationTime1SelectedBtn);
         this._roomContinuationTimeGroup.addSelectItem(this._roomContinuationTime2SelectedBtn);
         this._roomContinuationTimeGroup.addSelectItem(this._roomContinuationTime3SelectedBtn);
         this._roomContinuationTimeGroup.selectIndex = 0;
         this._roomCreateTime1Txt = ComponentFactory.Instance.creatComponentByStylename("asset.church.roomCreateTime");
         this._roomCreateTime2Txt = ComponentFactory.Instance.creatComponentByStylename("asset.church.roomCreateTime");
         this._roomCreateTime3Txt = ComponentFactory.Instance.creatComponentByStylename("asset.church.roomCreateTime");
         addToContent(this._roomCreateTime1Txt);
         addToContent(this._roomCreateTime2Txt);
         addToContent(this._roomCreateTime3Txt);
         PositionUtils.setPos(this._roomCreateTime1Txt,"church.view.roomContinuationCreateTime1Txt.pos");
         PositionUtils.setPos(this._roomCreateTime2Txt,"church.view.roomContinuationCreateTime2Txt.pos");
         PositionUtils.setPos(this._roomCreateTime3Txt,"church.view.roomContinuationCreateTime3Txt.pos");
         this._roomCreateTime1Txt.text = LanguageMgr.GetTranslation("church.weddingRoom.frame.roomCreateTime",2);
         this._roomCreateTime2Txt.text = LanguageMgr.GetTranslation("church.weddingRoom.frame.roomCreateTime",3);
         this._roomCreateTime3Txt.text = LanguageMgr.GetTranslation("church.weddingRoom.frame.roomCreateTime",4);
         this._roomCreateMoney1Txt = ComponentFactory.Instance.creatComponentByStylename("asset.church.roomCreateMoney");
         this._roomCreateMoney2Txt = ComponentFactory.Instance.creatComponentByStylename("asset.church.roomCreateMoney");
         this._roomCreateMoney3Txt = ComponentFactory.Instance.creatComponentByStylename("asset.church.roomCreateMoney");
         addToContent(this._roomCreateMoney1Txt);
         addToContent(this._roomCreateMoney2Txt);
         addToContent(this._roomCreateMoney3Txt);
         PositionUtils.setPos(this._roomCreateMoney1Txt,"church.view.roomContinuationCreateMoney1Txt.pos");
         PositionUtils.setPos(this._roomCreateMoney2Txt,"church.view.roomContinuationCreateMoney2Txt.pos");
         PositionUtils.setPos(this._roomCreateMoney3Txt,"church.view.roomContinuationCreateMoney3Txt.pos");
         this._roomCreateMoney1Txt.text = LanguageMgr.GetTranslation("church.weddingRoom.frame.roomCreateMoney",int(PlayerManager.Instance.merryDiscountArr[0]) > 0 ? PlayerManager.Instance.merryDiscountArr[0] : ServerConfigManager.instance.weddingMoney[0]);
         this._roomCreateMoney2Txt.text = LanguageMgr.GetTranslation("church.weddingRoom.frame.roomCreateMoney",int(PlayerManager.Instance.merryDiscountArr[1]) > 0 ? PlayerManager.Instance.merryDiscountArr[1] : ServerConfigManager.instance.weddingMoney[1]);
         this._roomCreateMoney3Txt.text = LanguageMgr.GetTranslation("church.weddingRoom.frame.roomCreateMoney",int(PlayerManager.Instance.merryDiscountArr[2]) > 0 ? PlayerManager.Instance.merryDiscountArr[2] : ServerConfigManager.instance.weddingMoney[2]);
      }
      
      private function setEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.onFrameResponse);
         this._roomContinuationTime1SelectedBtn.addEventListener(MouseEvent.CLICK,this.onBtnClick);
         this._roomContinuationTime2SelectedBtn.addEventListener(MouseEvent.CLICK,this.onBtnClick);
         this._roomContinuationTime3SelectedBtn.addEventListener(MouseEvent.CLICK,this.onBtnClick);
      }
      
      private function onBtnClick(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
      }
      
      private function onFrameResponse(evt:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         switch(evt.responseCode)
         {
            case FrameEvent.CANCEL_CLICK:
            case FrameEvent.CLOSE_CLICK:
            case FrameEvent.ESC_CLICK:
               this.dispose();
               break;
            case FrameEvent.ENTER_CLICK:
            case FrameEvent.SUBMIT_CLICK:
               this.confirmSubmit();
         }
      }
      
      private function confirmSubmit() : void
      {
         if(this.checkMoney() && Boolean(ChurchManager.instance.currentRoom))
         {
            this._controller.roomContinuation(this._roomContinuationTimeGroup.selectIndex + 2);
         }
         this.dispose();
      }
      
      private function checkMoney() : Boolean
      {
         var temp:int = int(PlayerManager.Instance.merryDiscountArr[this._roomContinuationTimeGroup.selectIndex]) > 0 ? int(PlayerManager.Instance.merryDiscountArr[this._roomContinuationTimeGroup.selectIndex]) : int(ServerConfigManager.instance.weddingMoney[this._roomContinuationTimeGroup.selectIndex]);
         if(PlayerManager.Instance.Self.Money < temp)
         {
            LeavePageManager.showFillFrame();
            this.dispose();
            return false;
         }
         return true;
      }
      
      public function show() : void
      {
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      private function removeView() : void
      {
         this._alertInfo = null;
         if(Boolean(this._alert))
         {
            if(Boolean(this._alert.parent))
            {
               this._alert.parent.removeChild(this._alert);
            }
            this._alert.dispose();
         }
         this._alert = null;
         if(Boolean(this._bg))
         {
            if(Boolean(this._bg.parent))
            {
               this._bg.parent.removeChild(this._bg);
            }
         }
         this._bg = null;
         if(Boolean(this._roomContinuationTime1SelectedBtn))
         {
            if(Boolean(this._roomContinuationTime1SelectedBtn.parent))
            {
               this._roomContinuationTime1SelectedBtn.parent.removeChild(this._roomContinuationTime1SelectedBtn);
            }
            this._roomContinuationTime1SelectedBtn.dispose();
         }
         this._roomContinuationTime1SelectedBtn = null;
         if(Boolean(this._roomContinuationTime2SelectedBtn))
         {
            if(Boolean(this._roomContinuationTime2SelectedBtn.parent))
            {
               this._roomContinuationTime2SelectedBtn.parent.removeChild(this._roomContinuationTime2SelectedBtn);
            }
            this._roomContinuationTime2SelectedBtn.dispose();
         }
         this._roomContinuationTime2SelectedBtn = null;
         if(Boolean(this._roomContinuationTime3SelectedBtn))
         {
            if(Boolean(this._roomContinuationTime3SelectedBtn.parent))
            {
               this._roomContinuationTime3SelectedBtn.parent.removeChild(this._roomContinuationTime3SelectedBtn);
            }
            this._roomContinuationTime3SelectedBtn.dispose();
         }
         this._roomContinuationTime3SelectedBtn = null;
         if(Boolean(this._roomContinuationTimeGroup))
         {
            this._roomContinuationTimeGroup.dispose();
         }
         this._roomContinuationTimeGroup = null;
         if(Boolean(this._roomCreateTime1Txt))
         {
            ObjectUtils.disposeObject(this._roomCreateTime1Txt);
         }
         this._roomCreateTime1Txt = null;
         if(Boolean(this._roomCreateTime2Txt))
         {
            ObjectUtils.disposeObject(this._roomCreateTime2Txt);
         }
         this._roomCreateTime2Txt = null;
         if(Boolean(this._roomCreateTime3Txt))
         {
            ObjectUtils.disposeObject(this._roomCreateTime3Txt);
         }
         this._roomCreateTime3Txt = null;
         if(Boolean(this._roomCreateMoney1Txt))
         {
            ObjectUtils.disposeObject(this._roomCreateMoney1Txt);
         }
         this._roomCreateMoney1Txt = null;
         if(Boolean(this._roomCreateMoney2Txt))
         {
            ObjectUtils.disposeObject(this._roomCreateMoney2Txt);
         }
         this._roomCreateMoney2Txt = null;
         if(Boolean(this._roomCreateMoney3Txt))
         {
            ObjectUtils.disposeObject(this._roomCreateMoney3Txt);
         }
         this._roomCreateMoney3Txt = null;
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
         dispatchEvent(new Event(Event.CLOSE));
      }
      
      private function removeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.onFrameResponse);
         if(Boolean(this._roomContinuationTime1SelectedBtn))
         {
            this._roomContinuationTime1SelectedBtn.removeEventListener(MouseEvent.CLICK,this.onBtnClick);
         }
         if(Boolean(this._roomContinuationTime2SelectedBtn))
         {
            this._roomContinuationTime2SelectedBtn.removeEventListener(MouseEvent.CLICK,this.onBtnClick);
         }
         if(Boolean(this._roomContinuationTime3SelectedBtn))
         {
            this._roomContinuationTime3SelectedBtn.removeEventListener(MouseEvent.CLICK,this.onBtnClick);
         }
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         super.dispose();
         this.removeView();
      }
   }
}

