package im
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.BitmapLoader;
   import com.pickgliss.loader.DisplayLoader;
   import com.pickgliss.loader.LoadResourceManager;
   import com.pickgliss.loader.LoaderEvent;
   import com.pickgliss.loader.UIModuleLoader;
   import com.pickgliss.toplevel.StageReferance;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import consortion.ConsortionModelControl;
   import ddt.bagStore.BagStore;
   import ddt.data.CMFriendInfo;
   import ddt.data.InviteInfo;
   import ddt.data.UIModuleTypes;
   import ddt.data.analyze.LoadCMFriendList;
   import ddt.data.analyze.RecentContactsAnalyze;
   import ddt.data.player.ConsortiaPlayerInfo;
   import ddt.data.player.FriendListPlayer;
   import ddt.data.player.PlayerInfo;
   import ddt.data.player.SelfInfo;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.events.PlayerPropertyEvent;
   import ddt.manager.ChatManager;
   import ddt.manager.GameInSocketOut;
   import ddt.manager.InviteManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PathManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.PlayerTipManager;
   import ddt.manager.SharedManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.StateManager;
   import ddt.states.StateType;
   import ddt.utils.FilterWordManager;
   import ddt.utils.RequestVairableCreater;
   import ddt.view.UIModuleSmallLoading;
   import ddt.view.tips.PlayerTip;
   import ddtBuried.BuriedManager;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.InteractiveObject;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.TimerEvent;
   import flash.geom.Point;
   import flash.net.URLVariables;
   import flash.text.TextField;
   import flash.text.TextFieldType;
   import flash.utils.Dictionary;
   import flash.utils.Timer;
   import game.GameManager;
   import gypsyShop.ctrl.GypsyShopManager;
   import im.chatFrame.PrivateChatFrame;
   import im.info.CustomInfo;
   import im.info.PresentRecordInfo;
   import im.messagebox.MessageBox;
   import invite.ResponseInviteFrame;
   import luckStar.manager.LuckStarManager;
   import newYearRice.NewYearRiceManager;
   import road7th.comm.PackageIn;
   import road7th.data.DictionaryData;
   import road7th.utils.StringHelper;
   import room.RoomManager;
   import room.model.RoomInfo;
   import roomList.RoomListEnumerate;
   import trainer.data.Step;
   import wonderfulActivity.WonderfulActivityManager;
   
   public class IMController extends EventDispatcher
   {
      
      private static var _instance:IMController;
      
      public static const HAS_NEW_MESSAGE:String = "hasNewMessage";
      
      public static const NO_MESSAGE:String = "nomessage";
      
      public static const ALERT_MESSAGE:String = "alertMessage";
      
      public static const MAX_MESSAGE_IN_BOX:int = 10;
      
      public static const ISFUBLISH:String = "isFublish";
      
      private var _existChat:Vector.<PresentRecordInfo>;
      
      private var _imview:IMView;
      
      private var _currentPlayer:PlayerInfo;
      
      private var _panels:Dictionary;
      
      private var _name:String;
      
      private var _baseAlerFrame:BaseAlerFrame;
      
      private var _isShow:Boolean;
      
      private var _recentContactsList:Array;
      
      private var _isLoadRecentContacts:Boolean;
      
      private var _titleType:int;
      
      private var _loader:DisplayLoader;
      
      private var _icon:Bitmap;
      
      public var isLoadComplete:Boolean = false;
      
      public var privateChatFocus:Boolean;
      
      public var changeID:int;
      
      public var cancelflashState:Boolean;
      
      public var customInfo:CustomInfo;
      
      public var deleteCustomID:int;
      
      private var _talkTimer:Timer = new Timer(1000);
      
      private var _privateFrame:PrivateChatFrame;
      
      private var _lastId:int;
      
      private var _changeInfo:PlayerInfo;
      
      private var _messageBox:MessageBox;
      
      private var _timer:Timer;
      
      private var _groupFrame:FriendGroupFrame;
      
      private var _tempLock:Boolean;
      
      private var _id:int;
      
      private var _groupId:int;
      
      private var _groupName:String;
      
      private var _isAddCMFriend:Boolean = true;
      
      private var _deleteRecentContact:int;
      
      private var _likeFriendList:Array;
      
      public function IMController()
      {
         super();
         this._existChat = new Vector.<PresentRecordInfo>();
      }
      
      public static function get Instance() : IMController
      {
         if(_instance == null)
         {
            _instance = new IMController();
         }
         return _instance;
      }
      
      public function setup() : void
      {
         PlayerManager.Instance.addEventListener(IMEvent.ADDNEW_FRIEND,this.__addNewFriend);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.GAME_INVITE,this.__receiveInvite);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.FRIEND_RESPONSE,this.__friendResponse);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.ONE_ON_ONE_TALK,this.__privateTalkHandler);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.ADD_CUSTOM_FRIENDS,this.__addCustomHandler);
         NewYearRiceManager.instance.addEventListener(CrazyTankSocketEvent.YEARFOODROOMINVITE,this.__yearFoodRoomInvite);
         addEventListener(PlayerTip.CHALLENGE,this.__onChanllengeClick);
         if(PathManager.CommunityExist())
         {
            this.loadIcon();
         }
      }
      
      protected function __onChanllengeClick(e:Event) : void
      {
         if(PlayerTipManager.instance.info.Grade < 12)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.roomlist.cantBeChallenged"));
            return;
         }
         if(PlayerTipManager.instance.info.playerState.StateID == 0 && PlayerTipManager.instance.info is FriendListPlayer)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.roomlist.friendOffline"));
            return;
         }
         var i:int = int(Math.random() * RoomListEnumerate.PREWORD.length);
         GameInSocketOut.sendCreateRoom(RoomListEnumerate.PREWORD[i],RoomInfo.CHALLENGE_ROOM,2,"");
         RoomManager.Instance.tempInventPlayerID = PlayerTipManager.instance.info.ID;
      }
      
      private function __yearFoodRoomInvite(event:CrazyTankSocketEvent) : void
      {
         var alert1:BaseAlerFrame = null;
         var pkg:PackageIn = event.pkg;
         NewYearRiceManager.instance.model.playerID = pkg.readInt();
         NewYearRiceManager.instance.model.playerName = pkg.readUTF();
         var isPublish:Boolean = pkg.readBoolean();
         if(this.getInviteState() && InviteManager.Instance.enabled && !isPublish)
         {
            alert1 = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("NewYearRiceMainView.view.Invite",NewYearRiceManager.instance.model.playerName),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,false,false,1);
            alert1.addEventListener(FrameEvent.RESPONSE,this.__inviteNewYearRice);
         }
         else
         {
            dispatchEvent(new Event(ISFUBLISH));
         }
      }
      
      private function __inviteNewYearRice(e:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         var alert:BaseAlerFrame = e.currentTarget as BaseAlerFrame;
         alert.removeEventListener(FrameEvent.RESPONSE,this.__inviteNewYearRice);
         alert.disposeChildren = true;
         alert.dispose();
         alert = null;
         if(e.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            SocketManager.Instance.out.sendInviteYearFoodRoom(true,NewYearRiceManager.instance.model.playerID);
         }
      }
      
      protected function __addCustomHandler(event:CrazyTankSocketEvent) : void
      {
         var temp2:int = 0;
         var temp4:int = 0;
         var pkg:PackageIn = event.pkg;
         var type:int = pkg.readByte();
         var bol:Boolean = pkg.readBoolean();
         var id:int = pkg.readInt();
         var name:String = pkg.readUTF();
         switch(type)
         {
            case 1:
               if(bol)
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("IM.addCustom.success",name));
                  this.customInfo = new CustomInfo();
                  this.customInfo.ID = id;
                  this.customInfo.Name = name;
                  dispatchEvent(new IMEvent(IMEvent.ADD_NEW_GROUP));
               }
               else
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("IM.addCustom.fail",name));
               }
               break;
            case 2:
               if(bol)
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("IM.deleteCustom.success",name));
                  PlayerManager.Instance.deleteCustomGroup(id);
                  for(temp2 = 0; temp2 < PlayerManager.Instance.customList.length; temp2++)
                  {
                     if(PlayerManager.Instance.customList[temp2].ID == id)
                     {
                        PlayerManager.Instance.customList.splice(temp2,1);
                        break;
                     }
                  }
                  this.deleteCustomID = id;
                  dispatchEvent(new IMEvent(IMEvent.DELETE_GROUP));
               }
               else
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("IM.deleteCustom.fail",name));
               }
               break;
            case 3:
               if(bol)
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("IM.alertCustom.success"));
                  this.customInfo = new CustomInfo();
                  this.customInfo.ID = id;
                  this.customInfo.Name = name;
                  for(temp4 = 0; temp4 < PlayerManager.Instance.customList.length; temp4++)
                  {
                     if(PlayerManager.Instance.customList[temp4].ID == id)
                     {
                        PlayerManager.Instance.customList[temp4].Name = name;
                        break;
                     }
                  }
                  dispatchEvent(new IMEvent(IMEvent.UPDATE_GROUP));
               }
               else
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("IM.alertCustom.fail"));
               }
         }
      }
      
      public function checkHasNew(id:int) : Boolean
      {
         for(var i:int = 0; i < this._existChat.length; i++)
         {
            if(id == this._existChat[i].id && this._existChat[i].exist == PresentRecordInfo.UNREAD)
            {
               return true;
            }
         }
         return false;
      }
      
      private function __privateTalkHandler(event:CrazyTankSocketEvent) : void
      {
         var tempInfo:PresentRecordInfo = null;
         var n:int = 0;
         var pkg:PackageIn = event.pkg;
         var playerId:int = pkg.readInt();
         var playerName:String = pkg.readUTF();
         var date:Date = pkg.readDate();
         var content:String = pkg.readUTF();
         var autoReply:Boolean = pkg.readBoolean();
         for(var i:int = 0; i < this._existChat.length; i++)
         {
            if(this._existChat[i].id == playerId)
            {
               tempInfo = this._existChat[i];
               tempInfo.addMessage(playerName,date,content);
               if(playerName != PlayerManager.Instance.Self.NickName)
               {
                  if(!this._talkTimer.running && this._privateFrame != null)
                  {
                     SoundManager.instance.play("200");
                     this._talkTimer.start();
                     this._talkTimer.addEventListener(TimerEvent.TIMER,this.__stopTalkTime);
                  }
                  this._existChat.splice(i,1);
                  this._existChat.unshift(tempInfo);
               }
               break;
            }
         }
         if(tempInfo == null)
         {
            tempInfo = new PresentRecordInfo();
            tempInfo.id = playerId;
            tempInfo.addMessage(playerName,date,content);
            this._existChat.unshift(tempInfo);
         }
         this.saveInShared(tempInfo);
         this.getMessage();
         this.saveRecentContactsID(tempInfo.id);
         if(this._privateFrame != null && this._privateFrame.parent && this._privateFrame.playerInfo.ID == playerId)
         {
            for(n = 0; n < this._existChat.length; n++)
            {
               if(this._existChat[n].id == playerId)
               {
                  this._privateFrame.addMessage(this._existChat[n].lastMessage);
                  this._existChat[n].exist = PresentRecordInfo.SHOW;
                  break;
               }
            }
         }
         else
         {
            this.setExist(playerId,PresentRecordInfo.UNREAD);
            this.changeID = playerId;
            this.cancelflashState = false;
            dispatchEvent(new Event(HAS_NEW_MESSAGE));
         }
         if(PlayerManager.Instance.Self.playerState.AutoReply != "" && playerName != PlayerManager.Instance.Self.NickName && !autoReply)
         {
            SocketManager.Instance.out.sendOneOnOneTalk(playerId,FilterWordManager.filterWrod(PlayerManager.Instance.Self.playerState.AutoReply),true);
         }
      }
      
      private function __stopTalkTime(event:TimerEvent) : void
      {
         this._talkTimer.stop();
         this._talkTimer.removeEventListener(TimerEvent.TIMER,this.__stopTalkTime);
      }
      
      private function setExist(id:int, exist:int) : void
      {
         for(var i:int = 0; i < this._existChat.length; i++)
         {
            if(this._existChat[i].id == id)
            {
               this._existChat[i].exist = exist;
               break;
            }
         }
      }
      
      public function alertPrivateFrame(id:int = 0) : void
      {
         var i:int;
         var messages:Vector.<String> = null;
         var tempInfo:PresentRecordInfo = null;
         if(this._privateFrame == null)
         {
            this._privateFrame = ComponentFactory.Instance.creatComponentByStylename("privateChatFrame");
         }
         if(!PlayerManager.Instance.Self.IsWeakGuildFinish(Step.IM_OPEN))
         {
            return;
         }
         if(id == 0 && (this._existChat.length == 0 || this._existChat.length == 1 && this._privateFrame.parent))
         {
            return;
         }
         if(id != 0 && this._lastId == id)
         {
            return;
         }
         if(Boolean(this._privateFrame.parent))
         {
            this.setExist(this._lastId,PresentRecordInfo.HIDE);
            this._privateFrame.parent.removeChild(this._privateFrame);
         }
         if(id != 0)
         {
            this._changeInfo = PlayerManager.Instance.findPlayer(id);
            this._lastId = id;
         }
         else
         {
            this._changeInfo = PlayerManager.Instance.findPlayer(this._existChat[0].id);
            this._lastId = this._existChat[0].id;
         }
         try
         {
            this._privateFrame.playerInfo = this._changeInfo;
         }
         catch(e:Error)
         {
            SocketManager.Instance.out.sendItemEquip(_changeInfo.ID,false);
            _changeInfo.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,__IDChange);
         }
         for(i = 0; i < this._existChat.length; i++)
         {
            if(this._existChat[i].id == this._lastId)
            {
               this._existChat[i].exist = PresentRecordInfo.SHOW;
               messages = this._existChat[i].messages;
               this._privateFrame.addAllMessage(messages);
               tempInfo = this._existChat[i];
               this.changeID = this._existChat[i].id;
               dispatchEvent(new Event(ALERT_MESSAGE));
               this._existChat.splice(i,1);
               this._existChat.push(tempInfo);
               break;
            }
         }
         if(!this.hasUnreadMessage())
         {
            dispatchEvent(new Event(NO_MESSAGE));
         }
         this.getMessage();
         this.saveRecentContactsID(id);
         LayerManager.Instance.addToLayer(this._privateFrame,LayerManager.GAME_TOP_LAYER,true);
      }
      
      public function cancelFlash() : void
      {
         this.cancelflashState = true;
         dispatchEvent(new Event(NO_MESSAGE));
      }
      
      public function hasUnreadMessage() : Boolean
      {
         for(var i:int = 0; i < this._existChat.length; i++)
         {
            if(this._existChat[i].exist == PresentRecordInfo.UNREAD)
            {
               return true;
            }
         }
         return false;
      }
      
      protected function __IDChange(event:PlayerPropertyEvent) : void
      {
         this._changeInfo.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__IDChange);
         this._privateFrame.playerInfo = this._changeInfo;
      }
      
      public function hidePrivateFrame(id:int) : void
      {
         StageReferance.stage.focus = StageReferance.stage;
         for(var i:int = 0; i < this._existChat.length; i++)
         {
            if(id == this._existChat[i].id)
            {
               break;
            }
            if(i == this._existChat.length - 1)
            {
               this.createPresentRecordInfo(id);
            }
         }
         if(this._existChat.length == 0)
         {
            this.createPresentRecordInfo(id);
         }
         this._lastId = 0;
         if(Boolean(this._privateFrame.parent))
         {
            this._privateFrame.parent.removeChild(this._privateFrame);
         }
         this.setExist(id,PresentRecordInfo.HIDE);
      }
      
      private function createPresentRecordInfo(id:int) : void
      {
         var tempInfo:PresentRecordInfo = null;
         tempInfo = new PresentRecordInfo();
         tempInfo.id = id;
         tempInfo.exist = PresentRecordInfo.HIDE;
         this._existChat.push(tempInfo);
      }
      
      public function disposePrivateFrame(id:int) : void
      {
         StageReferance.stage.focus = StageReferance.stage;
         this._lastId = 0;
         if(Boolean(this._privateFrame.parent))
         {
            this._privateFrame.parent.removeChild(this._privateFrame);
         }
         this.removePrivateMessage(id);
      }
      
      public function removePrivateMessage(id:int) : void
      {
         for(var i:int = 0; i < this._existChat.length; i++)
         {
            if(this._existChat[i].id == id)
            {
               this.changeID = id;
               dispatchEvent(new Event(ALERT_MESSAGE));
               this._existChat.splice(i,1);
               break;
            }
         }
         if(!this.hasUnreadMessage())
         {
            dispatchEvent(new Event(NO_MESSAGE));
         }
      }
      
      private function saveInShared(tempInfo:PresentRecordInfo) : void
      {
         var message:Vector.<Object> = null;
         if(SharedManager.Instance.privateChatRecord[tempInfo.id] == null)
         {
            SharedManager.Instance.privateChatRecord[tempInfo.id] = tempInfo.recordMessage;
         }
         else
         {
            message = SharedManager.Instance.privateChatRecord[tempInfo.id];
            if(message != tempInfo.recordMessage)
            {
               message.push(tempInfo.lastRecordMessage);
            }
            SharedManager.Instance.privateChatRecord[tempInfo.id] = message;
         }
         SharedManager.Instance.save();
      }
      
      public function showMessageBox(obj:DisplayObject) : void
      {
         var pos:Point = null;
         if(this._messageBox == null)
         {
            this._messageBox = new MessageBox();
            this._timer = new Timer(200);
            this._timer.addEventListener(TimerEvent.TIMER,this.__timerHandler);
         }
         if(this.getMessage().length > 0)
         {
            LayerManager.Instance.addToLayer(this._messageBox,LayerManager.GAME_TOP_LAYER);
            pos = obj.localToGlobal(new Point(0,0));
            this._messageBox.y = pos.y - this._messageBox.height;
            this._messageBox.x = pos.x - this._messageBox.width / 2 + obj.width / 2;
            if(this._messageBox.x + this._messageBox.width > StageReferance.stageWidth)
            {
               this._messageBox.x = StageReferance.stageWidth - this._messageBox.width - 10;
            }
         }
         this._timer.stop();
      }
      
      public function getMessage() : Vector.<PresentRecordInfo>
      {
         var i:int = 0;
         var temp:Vector.<PresentRecordInfo> = new Vector.<PresentRecordInfo>();
         if(Boolean(this._messageBox))
         {
            for(i = 0; i < this._existChat.length; i++)
            {
               if(this._existChat[i].exist != PresentRecordInfo.SHOW)
               {
                  temp.push(this._existChat[i]);
               }
               if(temp.length == MAX_MESSAGE_IN_BOX)
               {
                  break;
               }
            }
            this._messageBox.message = temp;
         }
         return temp;
      }
      
      protected function __timerHandler(event:TimerEvent) : void
      {
         if(!this._messageBox.overState)
         {
            this._messageBox.parent.removeChild(this._messageBox);
            this._timer.stop();
         }
      }
      
      public function hideMessageBox() : void
      {
         if(this._messageBox && this._messageBox.parent && Boolean(this._timer))
         {
            this._timer.reset();
            this._timer.start();
         }
      }
      
      public function setupRecentContactsList() : void
      {
         if(!this._recentContactsList)
         {
            this._recentContactsList = [];
         }
         this._recentContactsList = SharedManager.Instance.recentContactsID[PlayerManager.Instance.Self.ID];
         this._isLoadRecentContacts = true;
      }
      
      public function switchVisible() : void
      {
         UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__onUIModuleComplete);
         UIModuleSmallLoading.Instance.progress = 0;
         UIModuleSmallLoading.Instance.show();
         UIModuleSmallLoading.Instance.addEventListener(Event.CLOSE,this.__onClose);
         UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__onProgress);
         UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.IM);
      }
      
      public function get icon() : Bitmap
      {
         return this._loader.content as Bitmap;
      }
      
      private function loadIcon() : void
      {
         this._loader = LoadResourceManager.Instance.creatAndStartLoad(PathManager.CommunityIcon(),BaseLoader.BITMAP_LOADER) as BitmapLoader;
      }
      
      private function __friendResponse(evt:CrazyTankSocketEvent) : void
      {
         var str:String = null;
         var id:int = evt.pkg.clientId;
         var idtemp:int = evt.pkg.readInt();
         var _nick:String = evt.pkg.readUTF();
         var isSameCity:Boolean = evt.pkg.readBoolean();
         if(isSameCity)
         {
            str = LanguageMgr.GetTranslation("tank.view.im.IMController.sameCityfriend");
            str = str.replace(/r/g,"[" + _nick + "]");
         }
         else
         {
            str = "[" + _nick + "]" + LanguageMgr.GetTranslation("tank.view.im.IMController.friend");
         }
         ChatManager.Instance.sysChatYellow(str);
      }
      
      private function __onProgress(event:UIModuleEvent) : void
      {
         UIModuleSmallLoading.Instance.progress = event.loader.progress * 100;
      }
      
      private function __onClose(event:Event) : void
      {
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__onUIModuleComplete);
         UIModuleSmallLoading.Instance.hide();
         UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__onClose);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__onProgress);
      }
      
      private function __addNewFriend(evt:IMEvent) : void
      {
         this._currentPlayer = evt.data as PlayerInfo;
      }
      
      private function privateChat() : void
      {
         if(this._currentPlayer != null)
         {
            ChatManager.Instance.privateChatTo(this._currentPlayer.NickName,this._currentPlayer.ID);
         }
      }
      
      public function set isShow(value:Boolean) : void
      {
         this._isShow = value;
      }
      
      private function hide() : void
      {
         this._imview.dispose();
         this._imview = null;
      }
      
      private function show() : void
      {
         this._imview = null;
         if(this._imview == null)
         {
            this._imview = ComponentFactory.Instance.creat("IMFrame");
            this._imview.addEventListener(FrameEvent.RESPONSE,this.__imviewEvent);
         }
         LayerManager.Instance.addToLayer(this._imview,LayerManager.GAME_DYNAMIC_LAYER,false);
      }
      
      private function __onUIModuleComplete(event:UIModuleEvent) : void
      {
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__onUIModuleComplete);
         UIModuleSmallLoading.Instance.hide();
         if(event.module == UIModuleTypes.IM)
         {
            if(this._isLoadRecentContacts)
            {
               PlayerManager.Instance.addEventListener(PlayerManager.RECENT_CONTAST_COMPLETE,this.__recentContactsComplete);
               this.loadRecentContacts();
            }
            else
            {
               if(!this.isLoadComplete)
               {
                  return;
               }
               if(this._isShow)
               {
                  this.hide();
               }
               else
               {
                  this.show();
                  this._isShow = true;
                  this._isLoadRecentContacts = false;
               }
            }
         }
      }
      
      private function __recentContactsComplete(event:Event) : void
      {
         PlayerManager.Instance.removeEventListener(PlayerManager.RECENT_CONTAST_COMPLETE,this.__recentContactsComplete);
         if(!this.isLoadComplete)
         {
            return;
         }
         if(this._isShow)
         {
            this.hide();
         }
         else
         {
            this.show();
            this._isShow = true;
            this._isLoadRecentContacts = false;
         }
      }
      
      private function __receiveInvite(evt:CrazyTankSocketEvent) : void
      {
         var pkg:PackageIn = null;
         var info:InviteInfo = null;
         if(this.getInviteState() && InviteManager.Instance.enabled)
         {
            if(PlayerManager.Instance.Self.Grade < 4)
            {
               return;
            }
            if(!SharedManager.Instance.showInvateWindow)
            {
               return;
            }
            pkg = evt.pkg;
            info = new InviteInfo();
            info.playerid = pkg.readInt();
            info.roomid = pkg.readInt();
            info.mapid = pkg.readInt();
            info.secondType = pkg.readByte();
            info.gameMode = pkg.readByte();
            info.hardLevel = pkg.readByte();
            info.levelLimits = pkg.readByte();
            info.nickname = pkg.readUTF();
            info.IsVip = pkg.readBoolean();
            info.VIPLevel = pkg.readInt();
            info.RN = pkg.readUTF();
            info.password = pkg.readUTF();
            info.barrierNum = pkg.readInt();
            info.isOpenBoss = pkg.readBoolean();
            if(info.gameMode > 2 && PlayerManager.Instance.Self.Grade < GameManager.MinLevelDuplicate)
            {
               return;
            }
            if(LuckStarManager.Instance.openState)
            {
               return;
            }
            if(Boolean(WonderfulActivityManager.Instance.frame) && BuriedManager.Instance.isOpening)
            {
               return;
            }
            this.startReceiveInvite(info);
         }
      }
      
      private function startReceiveInvite(info:InviteInfo) : void
      {
         if(BuriedManager.Instance.isOpening)
         {
            return;
         }
         SoundManager.instance.play("018");
         var lastFocusObject:InteractiveObject = StageReferance.stage.focus;
         var response:ResponseInviteFrame = ResponseInviteFrame.newInvite(info);
         response.show();
         if(lastFocusObject is TextField)
         {
            if(TextField(lastFocusObject).type == TextFieldType.INPUT)
            {
               StageReferance.stage.focus = lastFocusObject;
            }
         }
      }
      
      private function getInviteState() : Boolean
      {
         if(!SharedManager.Instance.showInvateWindow)
         {
            return false;
         }
         if(BagStore.instance.storeOpenAble)
         {
            return false;
         }
         if(GypsyShopManager.getInstance().gypsyShopFrameIsShowing)
         {
            return false;
         }
         switch(StateManager.currentStateType)
         {
            case StateType.MAIN:
            case StateType.ROOM_LIST:
            case StateType.DUNGEON_LIST:
               return true;
            default:
               return false;
         }
      }
      
      public function set titleType(value:int) : void
      {
         this._titleType = value;
      }
      
      public function get titleType() : int
      {
         return this._titleType;
      }
      
      public function addFriend(name:String) : void
      {
         if(this.isMaxFriend())
         {
            return;
         }
         this._name = name;
         if(!this.checkFriendExist(this._name))
         {
            this.alertGroupFrame(this._name);
         }
      }
      
      public function isMaxFriend() : Boolean
      {
         var len:int = 0;
         if(PlayerManager.Instance.Self.IsVIP)
         {
            len = PlayerManager.Instance.Self.VIPLevel + 2;
         }
         if(PlayerManager.Instance.friendList.length >= 200 + len * 50)
         {
            this._baseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("tank.view.im.IMController.addFriend",200 + len * 50),"","",false,false,false,LayerManager.ALPHA_BLOCKGOUND);
            this._baseAlerFrame.addEventListener(FrameEvent.RESPONSE,this.__close);
            return true;
         }
         return false;
      }
      
      private function alertGroupFrame(name:String) : void
      {
         if(this._groupFrame == null)
         {
            this._groupFrame = ComponentFactory.Instance.creatComponentByStylename("friendGroupFrame");
            this._groupFrame.nickName = name;
         }
         LayerManager.Instance.addToLayer(this._groupFrame,LayerManager.STAGE_DYANMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
         this._tempLock = ChatManager.Instance.lock;
         StageReferance.stage.focus = this._groupFrame;
      }
      
      public function clearGroupFrame() : void
      {
         this._groupFrame = null;
      }
      
      private function __close(event:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         if(Boolean(this._baseAlerFrame))
         {
            this._baseAlerFrame.removeEventListener(FrameEvent.RESPONSE,this.__close);
            this._baseAlerFrame.dispose();
            this._baseAlerFrame = null;
         }
      }
      
      public function addBlackList(name:String) : void
      {
         if(PlayerManager.Instance.blackList.length >= 100)
         {
            this._baseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("tank.view.im.IMController.addBlackList"),"","",false,false,false,LayerManager.ALPHA_BLOCKGOUND);
            this._baseAlerFrame.addEventListener(FrameEvent.RESPONSE,this.__closeII);
            return;
         }
         this._name = name;
         if(!this.checkBlackListExit(name))
         {
            if(Boolean(this._baseAlerFrame))
            {
               this._baseAlerFrame.removeEventListener(FrameEvent.RESPONSE,this.__frameEventII);
               this._baseAlerFrame.dispose();
               this._baseAlerFrame = null;
            }
            this._baseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("tank.view.im.IMController.issure"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),true,true,true);
            this._baseAlerFrame.addEventListener(FrameEvent.RESPONSE,this.__frameEvent);
            this._tempLock = ChatManager.Instance.lock;
         }
      }
      
      private function __closeII(event:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         if(Boolean(this._baseAlerFrame))
         {
            this._baseAlerFrame.removeEventListener(FrameEvent.RESPONSE,this.__closeII);
            this._baseAlerFrame.dispose();
            this._baseAlerFrame = null;
         }
      }
      
      private function __frameEvent(evt:FrameEvent) : void
      {
         if(StateManager.currentStateType == StateType.MAIN)
         {
            ChatManager.Instance.lock = this._tempLock;
         }
         switch(evt.responseCode)
         {
            case FrameEvent.SUBMIT_CLICK:
            case FrameEvent.ENTER_CLICK:
               if(Boolean(this._baseAlerFrame))
               {
                  this._baseAlerFrame.removeEventListener(FrameEvent.RESPONSE,this.__frameEvent);
                  this._baseAlerFrame.dispose();
                  this._baseAlerFrame = null;
               }
               this.__addBlack();
               break;
            case FrameEvent.CANCEL_CLICK:
            case FrameEvent.CLOSE_CLICK:
            case FrameEvent.ESC_CLICK:
               if(Boolean(this._baseAlerFrame))
               {
                  this._baseAlerFrame.removeEventListener(FrameEvent.RESPONSE,this.__frameEvent);
                  this._baseAlerFrame.dispose();
                  this._baseAlerFrame = null;
               }
         }
      }
      
      private function __frameEventII(evt:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         if(StateManager.currentStateType == StateType.MAIN)
         {
            ChatManager.Instance.lock = this._tempLock;
         }
         switch(evt.responseCode)
         {
            case FrameEvent.SUBMIT_CLICK:
            case FrameEvent.ENTER_CLICK:
               if(Boolean(this._baseAlerFrame))
               {
                  this._baseAlerFrame.removeEventListener(FrameEvent.RESPONSE,this.__frameEventII);
                  this._baseAlerFrame.dispose();
                  this._baseAlerFrame = null;
               }
               this.alertGroupFrame(this._name);
               break;
            case FrameEvent.CANCEL_CLICK:
            case FrameEvent.CLOSE_CLICK:
            case FrameEvent.ESC_CLICK:
               if(Boolean(this._baseAlerFrame))
               {
                  this._baseAlerFrame.removeEventListener(FrameEvent.RESPONSE,this.__frameEventII);
                  this._baseAlerFrame.dispose();
                  this._baseAlerFrame = null;
               }
         }
      }
      
      private function __addBlack() : void
      {
         SoundManager.instance.play("008");
         SocketManager.Instance.out.sendAddFriend(this._name,1);
         this._name = "";
      }
      
      private function __addFriend() : void
      {
         SoundManager.instance.play("008");
         SocketManager.Instance.out.sendAddFriend(this._name,0);
         this._name = "";
      }
      
      public function deleteFriend(id:int, isDeleteBlack:Boolean = false) : void
      {
         this._id = id;
         this.disposeAlert();
         if(!isDeleteBlack)
         {
            this._baseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("tank.view.im.IMFriendItem.deleteFriend"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),true,true,true,LayerManager.ALPHA_BLOCKGOUND);
            this._baseAlerFrame.addEventListener(FrameEvent.RESPONSE,this.__frameEventIII);
         }
         else
         {
            this._baseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("tank.view.im.IMBlackItem.sure"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),true,true,true,LayerManager.ALPHA_BLOCKGOUND);
            this._baseAlerFrame.addEventListener(FrameEvent.RESPONSE,this.__frameEventIII);
         }
      }
      
      public function deleteGroup(groupId:int, groupName:String) : void
      {
         this._groupId = groupId;
         this._groupName = groupName;
         this.disposeAlert();
         this._baseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("tank.view.im.IMGourp.sure",groupName),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),true,true,true,LayerManager.ALPHA_BLOCKGOUND);
         this._baseAlerFrame.addEventListener(FrameEvent.RESPONSE,this.__deleteGroupEvent);
      }
      
      private function __deleteGroupEvent(event:FrameEvent) : void
      {
         switch(event.responseCode)
         {
            case FrameEvent.SUBMIT_CLICK:
            case FrameEvent.ENTER_CLICK:
               this.disposeAlert();
               SocketManager.Instance.out.sendCustomFriends(2,this._groupId,this._groupName);
               break;
            case FrameEvent.CANCEL_CLICK:
            case FrameEvent.CLOSE_CLICK:
            case FrameEvent.ESC_CLICK:
               this.disposeAlert();
         }
      }
      
      private function __frameEventIII(evt:FrameEvent) : void
      {
         switch(evt.responseCode)
         {
            case FrameEvent.SUBMIT_CLICK:
            case FrameEvent.ENTER_CLICK:
               this.disposeAlert();
               SocketManager.Instance.out.sendDelFriend(this._id);
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.im.IMController.success"));
               this._id = -1;
               break;
            case FrameEvent.CANCEL_CLICK:
            case FrameEvent.CLOSE_CLICK:
            case FrameEvent.ESC_CLICK:
               this.disposeAlert();
         }
      }
      
      private function disposeAlert() : void
      {
         if(Boolean(this._baseAlerFrame))
         {
            this._baseAlerFrame.removeEventListener(FrameEvent.RESPONSE,this.__frameEventIII);
            this._baseAlerFrame.dispose();
            this._baseAlerFrame = null;
         }
      }
      
      private function checkBlackListExit(s:String) : Boolean
      {
         var i:PlayerInfo = null;
         if(s == PlayerManager.Instance.Self.NickName)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.im.IMController.cannot"));
            return true;
         }
         var f:DictionaryData = PlayerManager.Instance.blackList;
         for each(i in f)
         {
            if(i.NickName == s)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.im.IMController.thisplayer"));
               return true;
            }
         }
         return false;
      }
      
      private function checkFriendExist(s:String) : Boolean
      {
         var i:PlayerInfo = null;
         var b:DictionaryData = null;
         var j:PlayerInfo = null;
         if(!s)
         {
            return true;
         }
         if(s.toLowerCase() == PlayerManager.Instance.Self.NickName.toLowerCase())
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.im.IMController.cannotAddSelfFriend"));
            return true;
         }
         var f:DictionaryData = PlayerManager.Instance.friendList;
         for each(i in f)
         {
            if(i.NickName == s)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.im.IMController.chongfu"));
               return true;
            }
         }
         b = PlayerManager.Instance.blackList;
         for each(j in b)
         {
            if(j.NickName == s)
            {
               this._name = s;
               this._baseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("tank.view.im.IMController.thisone"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,true,true,LayerManager.ALPHA_BLOCKGOUND);
               this._baseAlerFrame.addEventListener(FrameEvent.RESPONSE,this.__frameEventII);
               return true;
            }
         }
         return false;
      }
      
      public function isFriend(name:String) : Boolean
      {
         var i:PlayerInfo = null;
         var f:DictionaryData = PlayerManager.Instance.friendList;
         for each(i in f)
         {
            if(i.NickName == name)
            {
               return true;
            }
         }
         return false;
      }
      
      public function isBlackList(name:String) : Boolean
      {
         var j:PlayerInfo = null;
         var b:DictionaryData = PlayerManager.Instance.blackList;
         for each(j in b)
         {
            if(j.NickName == name)
            {
               return true;
            }
         }
         return false;
      }
      
      private function __imviewEvent(event:FrameEvent) : void
      {
         if(event.responseCode == FrameEvent.CLOSE_CLICK || event.responseCode == FrameEvent.ESC_CLICK)
         {
            SoundManager.instance.play("008");
            this.hide();
         }
      }
      
      public function createConsortiaLoader() : void
      {
         var args:URLVariables = null;
         var loader:BaseLoader = null;
         if(!StringHelper.isNullOrEmpty(PathManager.CommunityFriendList()))
         {
            args = RequestVairableCreater.creatWidthKey(true);
            args["uid"] = PlayerManager.Instance.Account.Account;
            loader = LoadResourceManager.Instance.createLoader(PathManager.CommunityFriendList(),BaseLoader.REQUEST_LOADER,args);
            loader.analyzer = new LoadCMFriendList(this.setupCMFriendList);
            loader.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
            LoadResourceManager.Instance.startLoad(loader);
         }
      }
      
      private function setupCMFriendList(analyzer:LoadCMFriendList) : void
      {
         dispatchEvent(new Event(Event.COMPLETE));
         if(PlayerManager.Instance.Self.IsFirst == 1 && this._isAddCMFriend)
         {
            this.cmFriendAddToFriend();
         }
      }
      
      private function cmFriendAddToFriend() : void
      {
         var i:CMFriendInfo = null;
         this._isAddCMFriend = false;
         var cmFriends:DictionaryData = PlayerManager.Instance.CMFriendList;
         var friends:DictionaryData = PlayerManager.Instance.friendList;
         for each(i in cmFriends)
         {
            if(i.IsExist && !friends[i.UserId])
            {
               SocketManager.Instance.out.sendAddFriend(i.NickName,0,true);
               cmFriends.remove(i.UserName);
            }
         }
      }
      
      private function __onLoadError(event:LoaderEvent) : void
      {
      }
      
      public function loadRecentContacts() : void
      {
         var args:URLVariables = RequestVairableCreater.creatWidthKey(true);
         args["id"] = PlayerManager.Instance.Self.ID;
         args["recentContacts"] = this.getFullRecentContactsID();
         var loader:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("IMRecentContactsList.ashx"),BaseLoader.REQUEST_LOADER,args);
         loader.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.LoadingBuddyListFailure");
         loader.analyzer = new RecentContactsAnalyze(PlayerManager.Instance.setupRecentContacts);
         loader.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         LoadResourceManager.Instance.startLoad(loader);
         this._isLoadRecentContacts = false;
      }
      
      public function get recentContactsList() : Array
      {
         return this._recentContactsList;
      }
      
      public function getFullRecentContactsID() : String
      {
         var recentContact:int = 0;
         var _fullRecentContactsID:String = "";
         for each(recentContact in this._recentContactsList)
         {
            if(recentContact != 0)
            {
               _fullRecentContactsID += String(recentContact) + ",";
            }
         }
         _fullRecentContactsID = _fullRecentContactsID.substr(0,_fullRecentContactsID.length - 1);
         if(_fullRecentContactsID == "")
         {
            _fullRecentContactsID = "0";
         }
         return _fullRecentContactsID;
      }
      
      public function saveRecentContactsID(ID:int = 0) : void
      {
         if(!this._recentContactsList)
         {
            this._recentContactsList = [];
         }
         if(ID == PlayerManager.Instance.Self.ID)
         {
            return;
         }
         if(this._recentContactsList.length < 20)
         {
            if(this.testIdentical(ID) != -1)
            {
               this._recentContactsList.splice(this.testIdentical(ID),1);
            }
            this._recentContactsList.unshift(ID);
         }
         else
         {
            if(this.testIdentical(ID) != -1)
            {
               this._recentContactsList.splice(this.testIdentical(ID),1);
            }
            else
            {
               this._recentContactsList.splice(-1,1);
            }
            this._recentContactsList.unshift(ID);
         }
         SharedManager.Instance.recentContactsID[String(PlayerManager.Instance.Self.ID)] = this._recentContactsList;
         SharedManager.Instance.save();
         this._isLoadRecentContacts = true;
      }
      
      public function deleteRecentContacts(ID:int = 0) : void
      {
         if(!this._recentContactsList)
         {
            return;
         }
         this._deleteRecentContact = ID;
         if(Boolean(this._baseAlerFrame))
         {
            this._baseAlerFrame.removeEventListener(FrameEvent.RESPONSE,this.__deleteRecentContact);
            this._baseAlerFrame.dispose();
            this._baseAlerFrame = null;
         }
         this._baseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("im.IMController.deleteRecentContactsInfo"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),true,true,true,LayerManager.ALPHA_BLOCKGOUND);
         this._baseAlerFrame.addEventListener(FrameEvent.RESPONSE,this.__deleteRecentContact);
      }
      
      private function __deleteRecentContact(event:FrameEvent) : void
      {
         switch(event.responseCode)
         {
            case FrameEvent.SUBMIT_CLICK:
            case FrameEvent.ENTER_CLICK:
               if(Boolean(this._baseAlerFrame))
               {
                  this._baseAlerFrame.removeEventListener(FrameEvent.RESPONSE,this.__deleteRecentContact);
                  this._baseAlerFrame.dispose();
                  this._baseAlerFrame = null;
               }
               if(this.testIdentical(this._deleteRecentContact) != -1)
               {
                  this._recentContactsList.splice(this.testIdentical(this._deleteRecentContact),1);
                  if(this._deleteRecentContact != 0)
                  {
                     PlayerManager.Instance.deleteRecentContact(this._deleteRecentContact);
                  }
               }
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.im.IMController.success"));
               SharedManager.Instance.recentContactsID[String(PlayerManager.Instance.Self.ID)] = this._recentContactsList;
               SharedManager.Instance.save();
               this._isLoadRecentContacts = true;
               break;
            case FrameEvent.ESC_CLICK:
            case FrameEvent.CLOSE_CLICK:
            case FrameEvent.CANCEL_CLICK:
               if(Boolean(this._baseAlerFrame))
               {
                  this._baseAlerFrame.removeEventListener(FrameEvent.RESPONSE,this.__deleteRecentContact);
                  this._baseAlerFrame.dispose();
                  this._baseAlerFrame = null;
               }
         }
      }
      
      public function testIdentical(id:int) : int
      {
         var i:int = 0;
         if(Boolean(this._recentContactsList))
         {
            for(i = 0; i < this._recentContactsList.length; i++)
            {
               if(this._recentContactsList[i] == id)
               {
                  return i;
               }
            }
         }
         return -1;
      }
      
      public function getRecentContactsStranger() : Array
      {
         var i:FriendListPlayer = null;
         var tempArray:Array = [];
         for each(i in PlayerManager.Instance.recentContacts)
         {
            if(this.testAlikeName(i.NickName))
            {
               tempArray.push(i);
            }
         }
         return tempArray;
      }
      
      public function testAlikeName(name:String) : Boolean
      {
         var temList:Array = [];
         temList = PlayerManager.Instance.friendList.list;
         temList = temList.concat(PlayerManager.Instance.blackList.list);
         temList = temList.concat(ConsortionModelControl.Instance.model.memberList.list);
         for(var i:int = 0; i < temList.length; i++)
         {
            if(temList[i] is FriendListPlayer && (temList[i] as FriendListPlayer).NickName == name)
            {
               return false;
            }
            if(temList[i] is ConsortiaPlayerInfo && (temList[i] as ConsortiaPlayerInfo).NickName == name)
            {
               return false;
            }
         }
         return true;
      }
      
      public function sortAcademyPlayer(list:Array) : Array
      {
         var i:PlayerInfo = null;
         var j:PlayerInfo = null;
         var temp:Array = [];
         var self:SelfInfo = PlayerManager.Instance.Self;
         if(self.getMasterOrApprentices().length <= 0)
         {
            return list;
         }
         var myAcademyPlayers:DictionaryData = self.getMasterOrApprentices();
         if(self.getMasterOrApprentices().length > 0)
         {
            for each(i in list)
            {
               if(Boolean(myAcademyPlayers[i.ID]) && i.ID != self.ID)
               {
                  if(i.ID == self.masterID)
                  {
                     temp.unshift(i);
                  }
                  else
                  {
                     temp.push(i);
                  }
               }
            }
            for each(j in temp)
            {
               list.splice(list.indexOf(j),1);
            }
         }
         return temp.concat(list);
      }
      
      public function addTransregionalblackList(name:String) : void
      {
         SharedManager.Instance.transregionalblackList[name] = name;
         SharedManager.Instance.save();
      }
      
      public function set likeFriendList(value:Array) : void
      {
         this._likeFriendList = value;
      }
      
      public function get likeFriendList() : Array
      {
         return this._likeFriendList;
      }
   }
}

