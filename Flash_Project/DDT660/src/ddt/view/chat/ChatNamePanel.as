package ddt.view.chat
{
   import bagAndInfo.info.PlayerInfoViewControl;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.IconButton;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.image.Image;
   import ddt.data.player.PlayerInfo;
   import ddt.manager.ChatManager;
   import ddt.manager.GameInSocketOut;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PathManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.StateManager;
   import ddt.states.StateType;
   import feedback.FeedbackManager;
   import flash.events.MouseEvent;
   import game.GameManager;
   import im.IMController;
   import room.RoomManager;
   import room.model.RoomInfo;
   
   public class ChatNamePanel extends ChatBasePanel
   {
      
      public var _playerName:String;
      
      public var channel:String = "";
      
      public var message:String = "";
      
      private var _bg:Image;
      
      private var _blackListBtn:IconButton;
      
      private var _viewInfoBtn:IconButton;
      
      private var _addFriendBtn:IconButton;
      
      private var _privateChat:IconButton;
      
      private var _reportBtn:IconButton;
      
      private var _inviteBtn:IconButton;
      
      private var _btnContainer:VBox;
      
      private var _data:PlayerInfo;
      
      public function ChatNamePanel()
      {
         super();
      }
      
      override protected function init() : void
      {
         super.init();
         this._bg = ComponentFactory.Instance.creatComponentByStylename("core.commonTipBg");
         this._btnContainer = ComponentFactory.Instance.creatComponentByStylename("chat.NamePanelList");
         this._blackListBtn = ComponentFactory.Instance.creatComponentByStylename("chat.ItemBlackList");
         this._viewInfoBtn = ComponentFactory.Instance.creatComponentByStylename("chat.ItemInfo");
         this._privateChat = ComponentFactory.Instance.creatComponentByStylename("chat.ItemPrivateChat");
         this._addFriendBtn = ComponentFactory.Instance.creatComponentByStylename("chat.ItemMakeFriend");
         this._inviteBtn = ComponentFactory.Instance.creatComponentByStylename("chat.ItemInvite");
         this._privateChat = ComponentFactory.Instance.creatComponentByStylename("chat.ItemPrivateChat");
         if(PathManager.solveFeedbackEnable())
         {
            this._reportBtn = ComponentFactory.Instance.creatComponentByStylename("chat.ItemReport");
         }
         addChild(this._bg);
         addChild(this._btnContainer);
         this._btnContainer.addChild(this._blackListBtn);
         this._btnContainer.addChild(this._viewInfoBtn);
         this._btnContainer.addChild(this._addFriendBtn);
         this._btnContainer.addChild(this._privateChat);
         if(PathManager.solveFeedbackEnable())
         {
            this._btnContainer.addChild(this._reportBtn);
         }
         this._reportBtn = ComponentFactory.Instance.creatComponentByStylename("chat.ItemReport");
         this.update();
      }
      
      override protected function initEvent() : void
      {
         super.initEvent();
         this._blackListBtn.addEventListener(MouseEvent.CLICK,this.__onBtnClicked);
         this._viewInfoBtn.addEventListener(MouseEvent.CLICK,this.__onBtnClicked);
         this._addFriendBtn.addEventListener(MouseEvent.CLICK,this.__onBtnClicked);
         this._inviteBtn.addEventListener(MouseEvent.CLICK,this.__onBtnClicked);
         this._privateChat.addEventListener(MouseEvent.CLICK,this.__onBtnClicked);
      }
      
      public function get getHeight() : int
      {
         return this._bg.height;
      }
      
      private function __onBtnClicked(event:MouseEvent) : void
      {
         var roominfo:RoomInfo = null;
         switch(event.currentTarget)
         {
            case this._blackListBtn:
               IMController.Instance.addBlackList(this.playerName);
               break;
            case this._viewInfoBtn:
               PlayerInfoViewControl.viewByNickName(this.playerName);
               PlayerInfoViewControl.isOpenFromBag = false;
               break;
            case this._addFriendBtn:
               IMController.Instance.addFriend(this.playerName);
               break;
            case this._privateChat:
               ChatManager.Instance.privateChatTo(this.playerName);
               break;
            case this._reportBtn:
               if(this.channel == null || this.channel == "null")
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.chat.ChatCongratulations.text"));
               }
               else
               {
                  FeedbackManager.instance.quickReport(this.channel,this.playerName,this.message);
               }
               break;
            case this._inviteBtn:
               roominfo = RoomManager.Instance.current;
               if(Boolean(roominfo))
               {
                  if(Boolean(roominfo) && roominfo.placeCount < 1)
                  {
                     if(roominfo.players.length > 1)
                     {
                        MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.roomlist.RoomListIIBGView.room"));
                     }
                     else
                     {
                        MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.room.RoomIIView2.noplacetoinvite"));
                     }
                     return;
                  }
                  if(this.playerName == PlayerManager.Instance.Self.NickName)
                  {
                     MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.im.IMController.cannotInviteSelf"));
                     return;
                  }
                  this._data = new PlayerInfo();
                  this._data = PlayerManager.Instance.findPlayerByNickName(this._data,this.playerName);
                  if(roominfo.type == RoomInfo.MATCH_ROOM)
                  {
                     if(this.inviteLvTip(6))
                     {
                        return;
                     }
                  }
                  else if(roominfo.type == RoomInfo.CHALLENGE_ROOM)
                  {
                     if(this.inviteLvTip(12))
                     {
                        return;
                     }
                  }
                  if((roominfo.type == RoomInfo.DUNGEON_ROOM || roominfo.type == RoomInfo.ACADEMY_DUNGEON_ROOM || roominfo.type == RoomInfo.SPECIAL_ACTIVITY_DUNGEON) && this._data.Grade < GameManager.MinLevelDuplicate)
                  {
                     MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.manager.PlayerManager.gradeLow",GameManager.MinLevelDuplicate));
                     return;
                  }
                  if(roominfo.type == RoomInfo.ACTIVITY_DUNGEON_ROOM && this._data.Grade < GameManager.MinLevelActivity)
                  {
                     MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.manager.PlayerManager.activityLow"));
                     return;
                  }
                  if(this.checkLevel(this._data.Grade))
                  {
                     GameInSocketOut.sendInviteGame(this._data.ID);
                  }
               }
         }
      }
      
      public function set playerName(value:String) : void
      {
         this._playerName = value;
         this.update();
      }
      
      public function get playerName() : String
      {
         return this._playerName;
      }
      
      private function update() : void
      {
         addChild(this._bg);
         addChild(this._btnContainer);
         if(Boolean(this._privateChat.parent))
         {
            this._privateChat.parent.removeChild(this._privateChat);
         }
         if(Boolean(this._addFriendBtn.parent))
         {
            this._addFriendBtn.parent.removeChild(this._addFriendBtn);
         }
         if(Boolean(this._viewInfoBtn.parent))
         {
            this._viewInfoBtn.parent.removeChild(this._viewInfoBtn);
         }
         if(Boolean(this._blackListBtn.parent))
         {
            this._blackListBtn.parent.removeChild(this._blackListBtn);
         }
         if(Boolean(this._reportBtn.parent))
         {
            this._reportBtn.parent.removeChild(this._reportBtn);
         }
         if(PathManager.solveFeedbackEnable())
         {
         }
         if(Boolean(this._inviteBtn.parent))
         {
            this._inviteBtn.parent.removeChild(this._inviteBtn);
         }
         this._btnContainer.addChild(this._privateChat);
         if(!IMController.Instance.isFriend(this.playerName))
         {
            this._btnContainer.addChild(this._addFriendBtn);
         }
         this._btnContainer.addChild(this._viewInfoBtn);
         this._btnContainer.addChild(this._blackListBtn);
         var roominfo:RoomInfo = RoomManager.Instance.current;
         if(Boolean(roominfo) && StateManager.currentStateType != StateType.FIGHTING)
         {
            if(roominfo.type == RoomInfo.MATCH_ROOM || roominfo.type == RoomInfo.CHALLENGE_ROOM || roominfo.type == RoomInfo.DUNGEON_ROOM || roominfo.type == RoomInfo.ACADEMY_DUNGEON_ROOM || roominfo.type == RoomInfo.ACTIVITY_DUNGEON_ROOM || roominfo.type == RoomInfo.SPECIAL_ACTIVITY_DUNGEON)
            {
               if(roominfo.type != RoomInfo.SINGLE_BATTLE)
               {
                  this._btnContainer.addChild(this._inviteBtn);
               }
            }
         }
         if(Boolean(this._bg))
         {
            this._bg.width = 106;
            this._bg.height = this._btnContainer.numChildren * 22;
         }
      }
      
      private function checkLevel(level:int) : Boolean
      {
         var roominfo:RoomInfo = RoomManager.Instance.current;
         if(roominfo.type > 2)
         {
            if(level < GameManager.MinLevelDuplicate)
            {
               return false;
            }
         }
         else if(roominfo.type == 2)
         {
            if((roominfo.levelLimits - 1) * 10 > level)
            {
               return false;
            }
         }
         return true;
      }
      
      private function inviteLvTip(lv:int) : Boolean
      {
         if(this._data.Grade < lv)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.invite.InvitePlayerItem.cannot",lv));
            return true;
         }
         return false;
      }
      
      override protected function removeEvent() : void
      {
         super.removeEvent();
         this._blackListBtn.removeEventListener(MouseEvent.CLICK,this.__onBtnClicked);
         this._viewInfoBtn.removeEventListener(MouseEvent.CLICK,this.__onBtnClicked);
         this._addFriendBtn.removeEventListener(MouseEvent.CLICK,this.__onBtnClicked);
         this._privateChat.removeEventListener(MouseEvent.CLICK,this.__onBtnClicked);
      }
   }
}

