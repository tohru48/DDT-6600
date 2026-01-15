package church.view.invite
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.ListPanel;
   import com.pickgliss.ui.controls.SelectedButtonGroup;
   import com.pickgliss.ui.controls.SelectedTextButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.vo.AlertInfo;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.player.ConsortiaPlayerInfo;
   import ddt.data.player.PlayerInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SoundManager;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import invite.data.InvitePlayerInfo;
   
   public class ChurchInviteView extends BaseAlerFrame
   {
      
      private var _bg:Scale9CornerImage;
      
      private var _controller:ChurchInviteController;
      
      private var _model:ChurchInviteModel;
      
      private var _alertInfo:AlertInfo;
      
      private var _currentTab:int;
      
      private var _refleshCount:int;
      
      private var _listPanel:ListPanel;
      
      private var _inviteFriendBtn:SelectedTextButton;
      
      private var _inviteConsortiaBtn:SelectedTextButton;
      
      private var _btnGroup:SelectedButtonGroup;
      
      private var _currentList:Array;
      
      public function ChurchInviteView()
      {
         super();
         this.setView();
      }
      
      private function setView() : void
      {
         this._refleshCount = 0;
         cancelButtonStyle = "core.simplebt";
         submitButtonStyle = "core.simplebt";
         this._alertInfo = new AlertInfo();
         this._alertInfo.title = LanguageMgr.GetTranslation("tank.invite.InviteView.request");
         this._alertInfo.cancelLabel = LanguageMgr.GetTranslation("tank.invite.InviteView.close");
         this._alertInfo.submitLabel = LanguageMgr.GetTranslation("tank.invite.InviteView.list");
         info = this._alertInfo;
         this.escEnable = true;
         this._bg = ComponentFactory.Instance.creat("church.ChurchInviteView.guestListBg");
         addToContent(this._bg);
         this._inviteFriendBtn = ComponentFactory.Instance.creat("church.room.inviteFriendBtnAsset");
         this._inviteFriendBtn.text = LanguageMgr.GetTranslation("tank.view.chat.ChatInputView.friend");
         addToContent(this._inviteFriendBtn);
         this._inviteConsortiaBtn = ComponentFactory.Instance.creat("church.room.inviteConsortiaBtnAsset");
         this._inviteConsortiaBtn.text = LanguageMgr.GetTranslation("tank.view.chat.ChannelListSelectView.consortia");
         addToContent(this._inviteConsortiaBtn);
         this._listPanel = ComponentFactory.Instance.creatComponentByStylename("church.room.invitePlayerListAsset");
         addToContent(this._listPanel);
         this._btnGroup = new SelectedButtonGroup();
         this._btnGroup.addSelectItem(this._inviteFriendBtn);
         this._btnGroup.addSelectItem(this._inviteConsortiaBtn);
         this._btnGroup.selectIndex = 0;
      }
      
      private function setEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.onFrameResponse);
         if(Boolean(this._model))
         {
            this._model.addEventListener(ChurchInviteModel.LIST_UPDATE,this.listUpdate);
         }
         if(Boolean(this._btnGroup))
         {
            this._btnGroup.addEventListener(Event.CHANGE,this.__changeHandler);
         }
         if(Boolean(this._inviteFriendBtn))
         {
            this._inviteFriendBtn.addEventListener(MouseEvent.CLICK,this.__soundPlay);
         }
         if(Boolean(this._inviteConsortiaBtn))
         {
            this._inviteConsortiaBtn.addEventListener(MouseEvent.CLICK,this.__soundPlay);
         }
      }
      
      private function onFrameResponse(evt:FrameEvent) : void
      {
         switch(evt.responseCode)
         {
            case FrameEvent.CANCEL_CLICK:
            case FrameEvent.CLOSE_CLICK:
            case FrameEvent.ESC_CLICK:
               SoundManager.instance.play("008");
               this.hide();
               break;
            case FrameEvent.ENTER_CLICK:
            case FrameEvent.SUBMIT_CLICK:
               this.sumbitConfirm();
         }
      }
      
      private function sumbitConfirm(evt:MouseEvent = null) : void
      {
         SoundManager.instance.play("008");
         this._controller.refleshList(this._currentTab);
      }
      
      private function __changeHandler(event:Event) : void
      {
         SoundManager.instance.play("008");
         switch(this._btnGroup.selectIndex)
         {
            case 0:
               if(this._currentTab == 0)
               {
                  return;
               }
               this._currentTab = 0;
               break;
            case 1:
               if(this._currentTab == 1)
               {
                  return;
               }
               this._currentTab = 1;
               break;
         }
         this._controller.refleshList(this._currentTab);
      }
      
      private function listUpdate(evt:Event = null) : void
      {
         var inviteInfo:InvitePlayerInfo = null;
         var plyeetInfo:PlayerInfo = null;
         var inviteInfoII:InvitePlayerInfo = null;
         var plyeetInfoII:ConsortiaPlayerInfo = null;
         var playerInfo:PlayerInfo = null;
         var obj:Object = null;
         this._currentList = [];
         for(var i:int = 0; i < this._model.currentList.length; i++)
         {
            if(this._model.currentList[i] is PlayerInfo)
            {
               inviteInfo = new InvitePlayerInfo();
               plyeetInfo = this._model.currentList[i] as PlayerInfo;
               inviteInfo.NickName = plyeetInfo.NickName;
               inviteInfo.Sex = plyeetInfo.Sex;
               inviteInfo.Grade = plyeetInfo.Grade;
               inviteInfo.Repute = plyeetInfo.Repute;
               inviteInfo.WinCount = plyeetInfo.WinCount;
               inviteInfo.TotalCount = plyeetInfo.TotalCount;
               inviteInfo.FightPower = plyeetInfo.FightPower;
               inviteInfo.ID = plyeetInfo.ID;
               inviteInfo.Offer = plyeetInfo.Offer;
               inviteInfo.typeVIP = plyeetInfo.typeVIP;
               inviteInfo.invited = false;
               this._currentList.push(inviteInfo);
            }
            else if(this._model.currentList[i] is ConsortiaPlayerInfo)
            {
               inviteInfoII = new InvitePlayerInfo();
               plyeetInfoII = this._model.currentList[i] as ConsortiaPlayerInfo;
               inviteInfoII.NickName = plyeetInfoII.NickName;
               inviteInfoII.Sex = plyeetInfoII.Sex;
               inviteInfoII.Grade = plyeetInfoII.Grade;
               inviteInfoII.Repute = plyeetInfoII.Repute;
               inviteInfoII.WinCount = plyeetInfoII.WinCount;
               inviteInfoII.TotalCount = plyeetInfoII.TotalCount;
               inviteInfoII.FightPower = plyeetInfoII.FightPower;
               inviteInfoII.ID = plyeetInfoII.ID;
               inviteInfoII.Offer = plyeetInfoII.Offer;
               inviteInfoII.typeVIP = plyeetInfoII.typeVIP;
               inviteInfoII.invited = false;
               this._currentList.push(inviteInfoII);
            }
         }
         this._listPanel.vectorListModel.clear();
         for(var j:int = 0; j < this._model.currentList.length; j++)
         {
            playerInfo = this._currentList[j] as PlayerInfo;
            obj = this.changeData(playerInfo,j + 1);
            this._listPanel.vectorListModel.insertElementAt(obj,j);
         }
         this._listPanel.list.updateListView();
      }
      
      private function __soundPlay(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
      }
      
      private function changeData(info:PlayerInfo, index:int) : Object
      {
         var obj:Object = new Object();
         obj["playerInfo"] = info;
         obj["index"] = index;
         return obj;
      }
      
      public function show() : void
      {
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_DYNAMIC_LAYER,true);
         this.setEvent();
         this.listUpdate();
         this._controller.refleshList(this._currentTab);
      }
      
      public function hide() : void
      {
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
      
      public function get model() : ChurchInviteModel
      {
         return this._model;
      }
      
      public function set model(value:ChurchInviteModel) : void
      {
         this._model = value;
      }
      
      public function get controller() : ChurchInviteController
      {
         return this._controller;
      }
      
      public function set controller(value:ChurchInviteController) : void
      {
         this._controller = value;
      }
      
      private function removeEvent() : void
      {
         if(Boolean(this._model))
         {
            this._model.removeEventListener(ChurchInviteModel.LIST_UPDATE,this.listUpdate);
         }
         removeEventListener(FrameEvent.RESPONSE,this.onFrameResponse);
         if(Boolean(this._btnGroup))
         {
            this._btnGroup.removeEventListener(Event.CHANGE,this.__changeHandler);
         }
         if(Boolean(this._inviteFriendBtn))
         {
            this._inviteFriendBtn.removeEventListener(MouseEvent.CLICK,this.__soundPlay);
         }
         if(Boolean(this._inviteConsortiaBtn))
         {
            this._inviteConsortiaBtn.removeEventListener(MouseEvent.CLICK,this.__soundPlay);
         }
      }
      
      private function removeView() : void
      {
         this._controller = null;
         this._model = null;
         this._alertInfo = null;
         ObjectUtils.disposeObject(this._bg);
         this._bg = null;
         ObjectUtils.disposeObject(this._listPanel);
         this._listPanel = null;
         ObjectUtils.disposeObject(this._inviteFriendBtn);
         this._inviteFriendBtn = null;
         ObjectUtils.disposeObject(this._inviteConsortiaBtn);
         this._inviteConsortiaBtn = null;
         if(Boolean(this._btnGroup))
         {
            this._btnGroup.dispose();
         }
         this._btnGroup = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
         dispatchEvent(new Event(Event.CLOSE));
      }
      
      override public function dispose() : void
      {
         super.dispose();
         this.removeEvent();
         this.removeView();
      }
   }
}

