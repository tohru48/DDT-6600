package wonderfulActivity.newActivity.GetRewardAct
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import wonderfulActivity.WonderfulActivityManager;
   import wonderfulActivity.data.GmActivityInfo;
   import wonderfulActivity.data.SendGiftInfo;
   import wonderfulActivity.newActivity.AnnouncementAct.AnnouncementDetailView;
   import wonderfulActivity.views.IRightView;
   
   public class GetRewardActView extends Sprite implements IRightView
   {
      
      private var _actId:String;
      
      private var _back:DisplayObject;
      
      private var _titleField:FilterFrameText;
      
      private var _buttonBack:DisplayObject;
      
      private var _detailView:AnnouncementDetailView;
      
      private var _getButton:BaseButton;
      
      private var _scrollList:ScrollPanel;
      
      private var _content:VBox;
      
      private var _activityInfo:GmActivityInfo;
      
      public function GetRewardActView(id:String)
      {
         super();
         this._actId = id;
      }
      
      public function init() : void
      {
         this.initView();
         this.addEvent();
         this.initData();
         this.initViewWithData();
      }
      
      private function addEvent() : void
      {
         this._getButton.addEventListener(MouseEvent.CLICK,this.__getRewardHandler);
      }
      
      protected function __getRewardHandler(event:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         var sendInfoVec:Vector.<SendGiftInfo> = new Vector.<SendGiftInfo>();
         var sendInfo:SendGiftInfo = new SendGiftInfo();
         sendInfo.activityId = this._activityInfo.activityId;
         var giftIdArr:Array = new Array();
         giftIdArr.push(this._activityInfo.giftbagArray[0].giftbagId);
         sendInfo.giftIdArr = giftIdArr;
         sendInfoVec.push(sendInfo);
         SocketManager.Instance.out.sendWonderfulActivityGetReward(sendInfoVec);
      }
      
      private function removeEvent() : void
      {
         this._getButton.removeEventListener(MouseEvent.CLICK,this.__getRewardHandler);
      }
      
      private function initView() : void
      {
         this._back = ComponentFactory.Instance.creatComponentByStylename("ddtcalendar.ActivityStateBg");
         addChild(this._back);
         PositionUtils.setPos(this._back,"wonderful.getRewardView.backPos");
         this._titleField = ComponentFactory.Instance.creatComponentByStylename("ddtcalendar.ActivityStateTitleField");
         addChild(this._titleField);
         PositionUtils.setPos(this._titleField,"wonderful.getRewardView.titlePos");
         this._buttonBack = ComponentFactory.Instance.creatComponentByStylename("ddtcalendar.ActivityState.GetButtonBackBg");
         addChild(this._buttonBack);
         PositionUtils.setPos(this._buttonBack,"wonderful.getRewardView.buttonBackPos");
         this._detailView = new AnnouncementDetailView();
         this._content = ComponentFactory.Instance.creatComponentByStylename("ddtcalendar.ActivityState.Vbox");
         this._content.addChild(this._detailView);
         this._scrollList = ComponentFactory.Instance.creatComponentByStylename("ddtcalendar.ActivityDetailList");
         this._scrollList.setView(this._content);
         addChild(this._scrollList);
         PositionUtils.setPos(this._scrollList,"wonderful.getRewardView.detailViewPos");
         this._getButton = ComponentFactory.Instance.creatComponentByStylename("ddtcalendar.ActivityState.GetButton");
         addChild(this._getButton);
         PositionUtils.setPos(this._getButton,"wonderful.getRewardView.getButtonPos");
      }
      
      private function initViewWithData() : void
      {
         if(!this._activityInfo)
         {
            return;
         }
         this._titleField.text = this._activityInfo.activityName;
         this._detailView.setData(this._activityInfo);
         this._content.arrange();
         this._scrollList.invalidateViewport();
      }
      
      private function initData() : void
      {
         this._activityInfo = WonderfulActivityManager.Instance.activityData[this._actId];
      }
      
      public function setState(type:int, id:int) : void
      {
      }
      
      public function content() : Sprite
      {
         return this;
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         if(Boolean(this._back))
         {
            ObjectUtils.disposeObject(this._back);
         }
         this._back = null;
         if(Boolean(this._titleField))
         {
            ObjectUtils.disposeObject(this._titleField);
         }
         this._titleField = null;
         if(Boolean(this._buttonBack))
         {
            ObjectUtils.disposeObject(this._buttonBack);
         }
         this._buttonBack = null;
         if(Boolean(this._detailView))
         {
            ObjectUtils.disposeObject(this._detailView);
         }
         this._detailView = null;
         if(Boolean(this._scrollList))
         {
            ObjectUtils.disposeObject(this._scrollList);
         }
         this._scrollList = null;
         if(Boolean(this._content))
         {
            ObjectUtils.disposeObject(this._content);
         }
         this._content = null;
         if(Boolean(this._getButton))
         {
            ObjectUtils.disposeObject(this._getButton);
         }
         this._getButton = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

