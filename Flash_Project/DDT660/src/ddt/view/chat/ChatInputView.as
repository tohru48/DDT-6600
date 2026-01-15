package ddt.view.chat
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.vo.AlertInfo;
   import ddt.data.player.FriendListPlayer;
   import ddt.manager.ChatManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PathManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import ddt.utils.Helpers;
   import email.manager.MailManager;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.utils.getTimer;
   import im.IMController;
   import room.RoomManager;
   
   public class ChatInputView extends Sprite
   {
      
      public static const ADMIN_NOTICE:int = 8;
      
      public static const BIG_BUGLE:uint = 0;
      
      public static const CHURCH_CHAT:int = 9;
      
      public static const CONSORTIA:uint = 3;
      
      public static const CROSS_BUGLE:uint = 15;
      
      public static const CROSS_NOTICE:uint = 12;
      
      public static const CURRENT:uint = 5;
      
      public static const DEFENSE_TIP:int = 10;
      
      public static const DEFY_AFFICHE:uint = 11;
      
      public static const HOTSPRING_ROOM:uint = 13;
      
      public static const PRIVATE:uint = 2;
      
      public static const SMALL_BUGLE:uint = 1;
      
      public static const SYS_NOTICE:uint = 6;
      
      public static const SYS_TIP:uint = 7;
      
      public static const TEAM:uint = 4;
      
      public static const GM_NOTICE:uint = 14;
      
      public static const WORLDBOSS_ROOM:uint = 20;
      
      public static const CHRISTMAS_CHAT:uint = 25;
      
      public static const SUPERWINNER_CHAT:uint = 26;
      
      public static const COMPLEX_NOTICE:uint = 21;
      
      private var _preChannel:int = -1;
      
      private var _bg:Bitmap;
      
      private var _btnEnter:BaseButton;
      
      private var _channel:int = 0;
      
      private var _channelBtn:Sprite;
      
      private var _channelPanel:ChatChannelPanel;
      
      private var _channelState:ScaleFrameImage;
      
      private var _faceBtn:BaseButton;
      
      private var _facePanel:ChatFacePanel;
      
      private var _fastReplyBtn:BaseButton;
      
      private var _fastReplyPanel:ChatFastReplyPanel;
      
      private var _friendListBtn:BaseButton;
      
      private var _friendListPanel:ChatFriendListPanel;
      
      private var _inputField:ChatInputField;
      
      private var _lastRecentSendTime:int = -30000;
      
      private var _lastSendChatTime:int = -30000;
      
      private var _chatPrivateFrame:ChatPrivateFrame;
      
      private var _friendListPanelPos:Point;
      
      private var _fastReplyPanelPos:Point;
      
      private var _facePanelPos:Point;
      
      private var _channelPanelPos:Point;
      
      private var _imBtnInGame:SimpleBitmapButton;
      
      private var _faceBtnInGame:SimpleBitmapButton;
      
      private var _fastReplyBtnInGame:SimpleBitmapButton;
      
      private var channelII:uint;
      
      public function ChatInputView()
      {
         super();
         this.init();
         this.initEvent();
      }
      
      public function set enableGameState(value:Boolean) : void
      {
         if(value)
         {
            this._facePanelPos.x -= 23;
            addChild(this._fastReplyBtnInGame);
            addChild(this._faceBtnInGame);
            addChild(this._imBtnInGame);
            if(Boolean(this._faceBtn.parent))
            {
               removeChild(this._faceBtn);
            }
            if(Boolean(this._fastReplyBtn.parent))
            {
               removeChild(this._fastReplyBtn);
            }
            if(Boolean(this._friendListBtn.parent))
            {
               removeChild(this._friendListBtn);
            }
         }
         else
         {
            this._facePanelPos.x += 23;
            if(Boolean(this._fastReplyBtnInGame.parent))
            {
               removeChild(this._fastReplyBtnInGame);
            }
            if(Boolean(this._faceBtnInGame.parent))
            {
               removeChild(this._faceBtnInGame);
            }
            if(Boolean(this._imBtnInGame.parent))
            {
               removeChild(this._imBtnInGame);
            }
            addChild(this._faceBtn);
            addChild(this._fastReplyBtn);
            addChild(this._friendListBtn);
         }
      }
      
      public function savePreChannel() : void
      {
         if(this._channel == TEAM)
         {
            this._preChannel = CURRENT;
         }
         this._preChannel = CURRENT;
      }
      
      public function revertChannel() : void
      {
         if(this._preChannel != -1)
         {
            this.channel = this._preChannel;
            this._preChannel = -1;
         }
      }
      
      public function get fastReplyPanel() : ChatFastReplyPanel
      {
         return this._fastReplyPanel;
      }
      
      public function set channel($channel:int) : void
      {
         ChatManager.Instance.view.addChild(this);
         ChatManager.Instance.setFocus();
         if(this._channel == $channel)
         {
            return;
         }
         this._channel = $channel;
         this._channelState.setFrame(this._channel == ChatInputView.WORLDBOSS_ROOM ? 5 + 1 : this._channel + 1);
         this._inputField.channel = this._channel;
         if(this._channel == PRIVATE)
         {
            this._chatPrivateFrame = ComponentFactory.Instance.creatComponentByStylename("chat.PrivateFrame");
            if(PathManager.crossServerChatSwitch)
            {
               this._chatPrivateFrame.height = 215;
            }
            else
            {
               this._chatPrivateFrame.height = 155;
            }
            this._chatPrivateFrame.info = new AlertInfo(LanguageMgr.GetTranslation("tank.view.scenechatII.PrivateChatIIView.privatename"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"));
            this._chatPrivateFrame.addEventListener(FrameEvent.RESPONSE,this.__frameEventHandler);
            LayerManager.Instance.addToLayer(this._chatPrivateFrame,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.ALPHA_BLOCKGOUND);
         }
      }
      
      private function __onCustomSetPrivateChatTo(e:ChatEvent) : void
      {
         this._channel = int(e.data.channel);
         this._channelState.setFrame(this._channel + 1);
         this._inputField.channel = this._channel;
         ChatManager.Instance.setFocus();
         this.setPrivateChatTo(e.data.nickName);
      }
      
      private function __frameEventHandler(e:FrameEvent) : void
      {
         var name:String = null;
         var areainfo:Object = null;
         SoundManager.instance.play("008");
         switch(e.responseCode)
         {
            case FrameEvent.SUBMIT_CLICK:
            case FrameEvent.ENTER_CLICK:
               name = (e.currentTarget as ChatPrivateFrame).currentFriend;
               areainfo = (e.currentTarget as ChatPrivateFrame).currentAreaInfo;
               if(!name)
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.chat.SelectPlayerChatView.name"));
                  return;
               }
               this.setPrivateChatTo(name,0,areainfo);
               break;
            case FrameEvent.ESC_CLICK:
            case FrameEvent.CLOSE_CLICK:
            case FrameEvent.CANCEL_CLICK:
               this.channel = CURRENT;
         }
         this._chatPrivateFrame.dispose();
         this._chatPrivateFrame = null;
         ChatManager.Instance.setFocus();
      }
      
      public function set faceEnabled(value:Boolean) : void
      {
         this._faceBtn.enable = value;
         this._faceBtnInGame.enable = value;
      }
      
      public function getCurrentInputChannel() : int
      {
         if(this._channel != CURRENT)
         {
            return this._channel;
         }
         var result:int = this._channel;
         switch(ChatManager.Instance.state)
         {
            case ChatManager.CHAT_WEDDINGROOM_STATE:
               result = CHURCH_CHAT;
               break;
            case ChatManager.CHAT_HOTSPRING_ROOM_VIEW:
            case ChatManager.CHAT_HOTSPRING_ROOM_GOLD_VIEW:
            case ChatManager.CHAT_LITTLEGAME:
               result = int(HOTSPRING_ROOM);
               break;
            case ChatManager.CHAT_ACADEMY_VIEW:
               result = int(CURRENT);
               break;
            case ChatManager.CHAT_WORLDBOS_ROOM:
               result = int(WORLDBOSS_ROOM);
               break;
            case ChatManager.SUPER_WINNER_ROOM:
               result = int(SUPERWINNER_CHAT);
         }
         return result;
      }
      
      public function get inputField() : ChatInputField
      {
         return this._inputField;
      }
      
      public function sendCurrentText() : void
      {
         this._inputField.sendCurrnetText();
      }
      
      public function setInputText(txt:String) : void
      {
         this._inputField.setInputText(txt);
      }
      
      public function setPrivateChatTo(nickname:String, uid:int = 0, info:Object = null) : void
      {
         if(Boolean(this._friendListPanel.parent))
         {
            this._friendListPanel.parent.removeChild(this._friendListPanel);
         }
         this._channel = PRIVATE;
         this._channelState.setFrame(this._channel + 1);
         this._inputField.channel = this._channel;
         this._inputField.setPrivateChatName(nickname,uid,info);
         if(ChatManager.Instance.visibleSwitchEnable)
         {
            ChatManager.Instance.view.addChild(this);
         }
      }
      
      public function hidePanel() : void
      {
         if(Boolean(this._channelPanel.parent))
         {
            this._channelPanel.parent.removeChild(this._channelPanel);
         }
         if(Boolean(this._friendListPanel.parent))
         {
            this._friendListPanel.parent.removeChild(this._friendListPanel);
         }
         if(Boolean(this._fastReplyPanel.parent))
         {
            this._fastReplyPanel.parent.removeChild(this._fastReplyPanel);
         }
         if(Boolean(this._facePanel.parent))
         {
            this._facePanel.parent.removeChild(this._facePanel);
         }
      }
      
      public function showFastReplypanel() : void
      {
         this._fastReplyPanel.setText();
      }
      
      private function __panelBtnClick(e:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         e.stopImmediatePropagation();
         switch(e.currentTarget)
         {
            case this._channelBtn:
               this.showPanel(this._channelPanel,this._channelPanelPos);
               break;
            case this._friendListBtn:
               this.showPanel(this._friendListPanel,this._friendListPanelPos);
               this._friendListPanel.refreshAllList();
               break;
            case this._fastReplyBtn:
            case this._fastReplyBtnInGame:
               this.showPanel(this._fastReplyPanel,this._fastReplyPanelPos);
               break;
            case this._faceBtn:
            case this._faceBtnInGame:
               this.showPanel(this._facePanel,this._facePanelPos);
               break;
            case this._imBtnInGame:
               if(PlayerManager.Instance.Self.Grade < 11)
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.functionLimitTip",11));
                  return;
               }
               IMController.Instance.switchVisible();
               break;
         }
      }
      
      private function showPanel(target:ChatBasePanel, pos:Point) : void
      {
         target.x = localToGlobal(new Point(pos.x,pos.y)).x;
         target.y = localToGlobal(new Point(pos.x,pos.y)).y;
         target.setVisible = true;
      }
      
      private function __onChannelSelected(e:ChatEvent) : void
      {
         this.channel = int(e.data);
      }
      
      private function __onEnterClick(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this.sendCurrentText();
      }
      
      private function __onFaceSelect(event:Event) : void
      {
         ChatManager.Instance.sendFace(this._facePanel.selected);
      }
      
      private function __onFastSelect(event:Event) : void
      {
         this.setInputText(this._fastReplyPanel.selectedWrod);
         this.sendCurrentText();
      }
      
      private function __onInputTextChanged(event:ChatEvent) : void
      {
         var ifCanSend:Boolean = false;
         if(event.data == "ping.zhu" || event.data == "weiqiang.huang")
         {
            MailManager.Instance.switchVisible();
            return;
         }
         var data:ChatData = new ChatData();
         data.channel = this.channelII = this.getCurrentInputChannel();
         data.msg = String(event.data);
         data.sender = PlayerManager.Instance.Self.NickName;
         data.senderID = PlayerManager.Instance.Self.ID;
         data.receiver = this._inputField.privateChatName;
         data.sender = ChatFormats.replaceUnacceptableChar(data.sender);
         data.receiver = ChatFormats.replaceUnacceptableChar(this._inputField.privateChatName);
         data.zoneID = PlayerManager.Instance.Self.ZoneID;
         if(data.channel == ChatInputView.CURRENT)
         {
            if(Boolean(RoomManager.Instance.current) && ChatManager.Instance.output.isInGame())
            {
               if(RoomManager.Instance.isTransnationalFight())
               {
                  ChatManager.Instance.sysChatYellow(LanguageMgr.GetTranslation("ddt.transnational.cannotchat"));
                  return;
               }
            }
         }
         if(Boolean(this._inputField.privateChatInfo) && !(this._inputField.privateChatInfo is FriendListPlayer))
         {
            data.zoneID = this._inputField.privateChatInfo.areaID;
            data.zoneName = this._inputField.privateChatInfo.areaName;
         }
         if(this.checkCanSendChannel(data))
         {
            ifCanSend = false;
            ifCanSend = data.channel == CROSS_BUGLE || data.channel == BIG_BUGLE || data.channel == SMALL_BUGLE || this.checkCanSendTime();
            if(ifCanSend)
            {
               ChatManager.Instance.sendChat(data);
               if(data.channel != BIG_BUGLE && data.channel != SMALL_BUGLE && data.channel != CROSS_BUGLE)
               {
                  data.msg = Helpers.enCodeString(data.msg);
                  ChatManager.Instance.chat(data);
               }
            }
         }
         ChatManager.Instance.output.currentOffset = 0;
      }
      
      private function checkCanSendChannel(data:ChatData) : Boolean
      {
         if(data.channel == ChatInputView.PRIVATE && data.receiver == PlayerManager.Instance.Self.NickName && data.zoneID == PlayerManager.Instance.Self.ZoneID)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.manager.ChatManagerII.cannot"));
            return false;
         }
         if(data.channel == ChatInputView.CONSORTIA && PlayerManager.Instance.Self.ConsortiaID == 0)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.manager.ChatManagerII.you"));
            return false;
         }
         if(data.channel == ChatInputView.TEAM)
         {
            if(ChatManager.Instance.state != ChatManager.CHAT_ROOM_STATE && ChatManager.Instance.state != ChatManager.CHAT_GAME_STATE && ChatManager.Instance.state != ChatManager.CHAT_GAMEOVER_STATE && ChatManager.Instance.state != ChatManager.CHAT_DUNGEON_STATE && ChatManager.Instance.state != ChatManager.CHAT_GAME_LOADING)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.manager.ChatManagerII.now"));
               return false;
            }
         }
         return true;
      }
      
      private function checkCanSendTime() : Boolean
      {
         if(this.channelII == CHURCH_CHAT)
         {
            if(getTimer() - this._lastSendChatTime < 5000)
            {
               ChatManager.Instance.sysChatRed(LanguageMgr.GetTranslation("tank.view.chat.ChatInput.time1"));
               return false;
            }
            this._lastSendChatTime = getTimer();
         }
         else
         {
            if(getTimer() - this._lastSendChatTime < 1000)
            {
               ChatManager.Instance.sysChatRed(LanguageMgr.GetTranslation("tank.view.chat.ChatInput.time2"));
               return false;
            }
            this._lastSendChatTime = getTimer();
         }
         if(this._channel != CURRENT)
         {
            return true;
         }
         if(getTimer() - this._lastRecentSendTime < 30000)
         {
            if((ChatManager.Instance.state == ChatManager.CHAT_WEDDINGLIST_STATE || ChatManager.Instance.state == ChatManager.CHAT_DUNGEONLIST_STATE || ChatManager.Instance.state == ChatManager.CHAT_ROOMLIST_STATE || ChatManager.Instance.state == ChatManager.CHAT_HALL_STATE || ChatManager.Instance.state == ChatManager.CHAT_CONSORTIA_CHAT_VIEW || ChatManager.Instance.state == ChatManager.CHAT_CLUB_STATE || ChatManager.Instance.state == ChatManager.CHAT_CIVIL_VIEW || ChatManager.Instance.state == ChatManager.CHAT_TOFFLIST_VIEW || ChatManager.Instance.state == ChatManager.CHAT_ACADEMY_VIEW || ChatManager.Instance.state == ChatManager.CHAT_HOTSPRING_VIEW || ChatManager.Instance.state == ChatManager.CHAT_LITTLEHALL || ChatManager.Instance.state == ChatManager.CHAT_FARM) && this._channel == CURRENT)
            {
               ChatManager.Instance.sysChatRed(LanguageMgr.GetTranslation("tank.view.chat.ChatInputView.channel"));
               return false;
            }
            this._lastRecentSendTime = getTimer();
         }
         else
         {
            this._lastRecentSendTime = getTimer();
         }
         return true;
      }
      
      private function init() : void
      {
         this._channelBtn = new Sprite();
         this._bg = ComponentFactory.Instance.creatBitmap("asset.chat.InputBg");
         this._channelState = ComponentFactory.Instance.creatComponentByStylename("chat.ChannelState");
         this._btnEnter = ComponentFactory.Instance.creatComponentByStylename("chat.InputEnterBtn");
         this._friendListBtn = ComponentFactory.Instance.creatComponentByStylename("chat.InputFriendListBtn");
         this._fastReplyBtn = ComponentFactory.Instance.creatComponentByStylename("chat.InputFastReplyBtn");
         this._faceBtn = ComponentFactory.Instance.creatComponentByStylename("chat.InputFaceBtn");
         this._faceBtnInGame = ComponentFactory.Instance.creatComponentByStylename("chat.InputFaceInGameBtn");
         this._fastReplyBtnInGame = ComponentFactory.Instance.creatComponentByStylename("chat.InputFastReplyInGameBtn");
         this._imBtnInGame = ComponentFactory.Instance.creatComponentByStylename("chat.InputIMBtn");
         this._inputField = ComponentFactory.Instance.creatCustomObject("chat.InputField");
         this._channelPanel = ComponentFactory.Instance.creatCustomObject("chat.ChannelPanel");
         this._channelPanelPos = ComponentFactory.Instance.creatCustomObject("chat.ChannelPanelPosT" + this._channelPanel.btnLen);
         this._facePanel = ComponentFactory.Instance.creatCustomObject("chat.FacePanel");
         this._facePanelPos = ComponentFactory.Instance.creatCustomObject("chat.FacePanelPos");
         this._fastReplyPanel = ComponentFactory.Instance.creatCustomObject("chat.FastReplyPanel");
         this._fastReplyPanelPos = ComponentFactory.Instance.creatCustomObject("chat.FastReplyPanelPos");
         this._friendListPanel = ComponentFactory.Instance.creatCustomObject("chat.FriendListPanel");
         this._friendListPanelPos = ComponentFactory.Instance.creatCustomObject("chat.FriendListPanelPos");
         this._btnEnter.tipData = LanguageMgr.GetTranslation("chat.Send");
         this._friendListBtn.tipData = LanguageMgr.GetTranslation("chat.FriendList");
         this._fastReplyBtnInGame.tipData = this._fastReplyBtn.tipData = LanguageMgr.GetTranslation("chat.FastReply");
         this._faceBtnInGame.tipData = this._faceBtn.tipData = LanguageMgr.GetTranslation("chat.Expression");
         this._imBtnInGame.tipData = LanguageMgr.GetTranslation("chat.Friend");
         this._channelState.setFrame(1);
         this._friendListPanel.setup(this.setPrivateChatTo,false);
         addChild(this._bg);
         addChild(this._btnEnter);
         addChild(this._friendListBtn);
         addChild(this._fastReplyBtn);
         addChild(this._faceBtn);
         addChild(this._inputField);
         addChild(this._channelBtn);
         this._channelBtn.addChild(this._channelState);
      }
      
      private function initEvent() : void
      {
         this._channelBtn.buttonMode = true;
         this._channelPanel.addEventListener(ChatEvent.INPUT_CHANNEL_CHANNGED,this.__onChannelSelected);
         this._fastReplyPanel.addEventListener(Event.SELECT,this.__onFastSelect);
         this._facePanel.addEventListener(Event.SELECT,this.__onFaceSelect);
         this._channelBtn.addEventListener(MouseEvent.CLICK,this.__panelBtnClick);
         this._friendListBtn.addEventListener(MouseEvent.CLICK,this.__panelBtnClick);
         this._fastReplyBtn.addEventListener(MouseEvent.CLICK,this.__panelBtnClick);
         this._faceBtn.addEventListener(MouseEvent.CLICK,this.__panelBtnClick);
         this._faceBtnInGame.addEventListener(MouseEvent.CLICK,this.__panelBtnClick);
         this._fastReplyBtnInGame.addEventListener(MouseEvent.CLICK,this.__panelBtnClick);
         this._imBtnInGame.addEventListener(MouseEvent.CLICK,this.__panelBtnClick);
         this._inputField.addEventListener(ChatEvent.INPUT_CHANNEL_CHANNGED,this.__onChannelSelected);
         this._inputField.addEventListener(ChatEvent.INPUT_TEXT_CHANGED,this.__onInputTextChanged);
         this._inputField.addEventListener(ChatEvent.CUSTOM_SET_PRIVATE_CHAT_TO,this.__onCustomSetPrivateChatTo);
         this._btnEnter.addEventListener(MouseEvent.CLICK,this.__onEnterClick);
      }
   }
}

