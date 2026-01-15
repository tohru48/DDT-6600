package ddt.manager
{
   import cardSystem.CardControl;
   import cardSystem.data.CardInfo;
   import cardSystem.data.GrooveInfo;
   import com.pickgliss.debug.DebugStats;
   import com.pickgliss.toplevel.StageReferance;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import ddt.data.ConsortiaDutyType;
   import ddt.data.EquipType;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.data.player.PlayerInfo;
   import ddt.data.socket.ePackageType;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.states.StateType;
   import ddt.utils.ChatHelper;
   import ddt.utils.FilterWordManager;
   import ddt.utils.Helpers;
   import ddt.view.caddyII.CaddyModel;
   import ddt.view.chat.ChatData;
   import ddt.view.chat.ChatEvent;
   import ddt.view.chat.ChatFormats;
   import ddt.view.chat.ChatInputView;
   import ddt.view.chat.ChatModel;
   import ddt.view.chat.ChatOutputView;
   import ddt.view.chat.ChatView;
   import ddt.view.chat.chat_system;
   import flash.events.ErrorEvent;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.utils.ByteArray;
   import flashP2P.FlashP2PManager;
   import flashP2P.event.StreamEvent;
   import game.GameManager;
   import hall.event.NewHallEvent;
   import im.IMController;
   import newTitle.NewTitleManager;
   import newYearRice.NewYearRiceManager;
   import road7th.comm.PackageIn;
   import road7th.comm.PackageOut;
   import road7th.data.DictionaryData;
   import road7th.utils.StringHelper;
   import room.RoomManager;
   import shop.view.NewShopBugleView;
   import trainer.data.Step;
   
   use namespace chat_system;
   
   public final class ChatManager extends EventDispatcher
   {
      
      private static var _instance:ChatManager;
      
      public static const CHAT_HALL_STATE:int = 0;
      
      public static const CHAT_GAME_STATE:int = 1;
      
      public static const CHAT_CLUB_STATE:int = 2;
      
      public static const CHAT_WEDDINGLIST_STATE:int = 3;
      
      public static const CHAT_WEDDINGROOM_STATE:int = 4;
      
      public static const CHAT_ROOM_STATE:int = 5;
      
      public static const CHAT_ROOMLIST_STATE:int = 6;
      
      public static const CHAT_DUNGEONLIST_STATE:int = 7;
      
      public static const CHAT_GAMEOVER_STATE:int = 8;
      
      public static const CHAT_GAME_LOADING:int = 9;
      
      public static const CHAT_DUNGEON_STATE:int = 10;
      
      public static const CHAT_CONSORTIA_CHAT_VIEW:int = 12;
      
      public static const CHAT_CONSORTIA_ALL:int = 13;
      
      public static const CHAT_CIVIL_VIEW:int = 14;
      
      public static const CHAT_TOFFLIST_VIEW:int = 15;
      
      public static const CHAT_SHOP_STATE:int = 16;
      
      public static const CHAT_HOTSPRING_VIEW:int = 17;
      
      public static const CHAT_HOTSPRING_ROOM_VIEW:int = 18;
      
      public static const CHAT_HOTSPRING_ROOM_GOLD_VIEW:int = 19;
      
      public static const CHAT_TRAINER_STATE:int = 20;
      
      public static const CHAT_GAMEOVER_TROPHY:int = 21;
      
      public static const CHAT_TRAINER_ROOM_LOADING:int = 22;
      
      public static const CHAT_LITTLEHALL:int = 26;
      
      public static const CHAT_LITTLEGAME:int = 24;
      
      public static const CHAT_FARM:int = 27;
      
      public static const CHAT_FIGHT_LIB:int = 23;
      
      public static const CHAT_ACADEMY_VIEW:int = 25;
      
      private static const CHAT_LEVEL:int = 1;
      
      public static const CHAT_WORLDBOS_ROOM:int = 28;
      
      public static const CHAT_CHRISTMAS_ROOM:int = 21;
      
      public static const CHAT_CONSORTIABATTLE_SCENE:int = 29;
      
      public static const CHAT_SEVENDOUBLEGAME_SECENE:int = 30;
      
      public static const CHAT_ESCORT_SECENE:int = 31;
      
      public static const CHAT_TREASURE_STATE:int = 30;
      
      public static const SUPER_WINNER_ROOM:int = 31;
      
      public static const CHAT_CATCH_INSECT:int = 32;
      
      public static var SHIELD_NOTICE:Boolean = false;
      
      public static var HALL_CHAT_LOCK:Boolean = true;
      
      private var _shopBugle:NewShopBugleView;
      
      private var _isFastInvite:Boolean = false;
      
      private var _isFastAuction:Boolean = false;
      
      public var chatDisabled:Boolean = false;
      
      private var _chatView:ChatView;
      
      private var _model:ChatModel;
      
      private var _state:int = -1;
      
      private var _visibleSwitchEnable:Boolean = false;
      
      private var _focusFuncEnabled:Boolean = true;
      
      private var fpsContainer:DebugStats;
      
      private var _firstsetup:Boolean = true;
      
      public var notAgain:Boolean = false;
      
      public function ChatManager()
      {
         super();
      }
      
      public static function get Instance() : ChatManager
      {
         if(_instance == null)
         {
            _instance = new ChatManager();
         }
         return _instance;
      }
      
      public function chat(data:ChatData, needFormat:Boolean = true) : void
      {
         if(this.chatDisabled)
         {
            return;
         }
         if(needFormat)
         {
            data.msg = StringHelper.reverseHtmlTextField(data.msg);
            data.msg = FilterWordManager.filterWrodFromServer(data.msg);
            if(data.channel != ChatInputView.COMPLEX_NOTICE)
            {
               ChatFormats.formatChatStyle(data);
            }
            else
            {
               ChatFormats.formatComplexChatStyle(data);
            }
         }
         data.htmlMessage = Helpers.deCodeString(data.htmlMessage);
         this._model.addChat(data);
      }
      
      public function addTimePackTip(packName:String) : void
      {
         var data:ChatData = new ChatData();
         data.type = ChatFormats.CLICK_TIME_GIFTPACK;
         data.channel = ChatInputView.SYS_TIP;
         data.msg = LanguageMgr.GetTranslation("ddt.timeGiftPack.tip",packName);
         ChatManager.Instance.chat(data);
      }
      
      public function get isInGame() : Boolean
      {
         return this.output.isInGame();
      }
      
      public function set focusFuncEnabled(value:Boolean) : void
      {
         this._focusFuncEnabled = value;
      }
      
      public function get focusFuncEnabled() : Boolean
      {
         return this._focusFuncEnabled;
      }
      
      public function get input() : ChatInputView
      {
         return this._chatView.input;
      }
      
      public function set inputChannel(channel:int) : void
      {
         this._chatView.input.channel = channel;
      }
      
      public function get lock() : Boolean
      {
         return this._chatView.output.isLock;
      }
      
      public function set lock(value:Boolean) : void
      {
         this._chatView.output.isLock = value;
      }
      
      public function get model() : ChatModel
      {
         return this._model;
      }
      
      public function get output() : ChatOutputView
      {
         return this._chatView.output;
      }
      
      public function set outputChannel(channel:int) : void
      {
         this._chatView.output.channel = channel;
      }
      
      public function privateChatTo(nickname:String, id:int = 0, info:Object = null) : void
      {
         this._chatView.input.setPrivateChatTo(nickname,id,info);
      }
      
      public function sendBugle(msg:String, type:int, isFastInvite:Boolean = false) : void
      {
         this._isFastInvite = isFastInvite;
         if(PlayerManager.Instance.Self.PropBag.getItemCountByTemplateId(type,true) <= 0)
         {
            if(Boolean(ShopManager.Instance.getMoneyShopItemByTemplateID(type)))
            {
               this.input.setInputText(msg);
            }
            this.sysChatYellow(LanguageMgr.GetTranslation("tank.manager.ChatManager.tool"));
            if(!this._shopBugle || !this._shopBugle.info)
            {
               this._shopBugle = new NewShopBugleView(type);
            }
            else if(this._shopBugle.type != type)
            {
               this._shopBugle.dispose();
               this._shopBugle = null;
               this._shopBugle = new NewShopBugleView(type);
            }
         }
         else
         {
            msg = Helpers.enCodeString(msg);
            if(type == EquipType.T_SBUGLE && !isFastInvite)
            {
               SocketManager.Instance.out.sendSBugle(msg);
            }
            else if(type == EquipType.T_BBUGLE)
            {
               SocketManager.Instance.out.sendBBugle(msg,type);
            }
            else if(type == EquipType.T_CBUGLE)
            {
               SocketManager.Instance.out.sendCBugle(msg);
            }
            else if(isFastInvite)
            {
               if(Boolean(NewYearRiceManager.instance.model.openFrameView))
               {
                  SocketManager.Instance.out.sendInviteYearFoodRoom(false,PlayerManager.Instance.Self.ID,true);
                  return;
               }
               SocketManager.Instance.out.sendFastInviteCall();
            }
         }
      }
      
      public function sendFastAuctionBugle(id:int, type:int = 11101) : void
      {
         if(PlayerManager.Instance.Self.PropBag.getItemCountByTemplateId(type,true) <= 0)
         {
            this.sysChatYellow(LanguageMgr.GetTranslation("tank.manager.ChatManager.tool"));
            if(!this._shopBugle || !this._shopBugle.info)
            {
               this._shopBugle = new NewShopBugleView(type);
            }
            else if(this._shopBugle.type != type)
            {
               this._shopBugle.dispose();
               this._shopBugle = null;
               this._shopBugle = new NewShopBugleView(type);
            }
         }
         else
         {
            SocketManager.Instance.out.sendFastAuctionBugle(id);
         }
      }
      
      public function sendChat($chat:ChatData) : void
      {
         var i:int = 0;
         if($chat.msg == "showDebugStatus -fps")
         {
            if(!this.fpsContainer)
            {
               this.fpsContainer = new DebugStats();
               LayerManager.Instance.addToLayer(this.fpsContainer,LayerManager.STAGE_TOP_LAYER);
            }
            else
            {
               if(Boolean(this.fpsContainer.parent))
               {
                  this.fpsContainer.parent.removeChild(this.fpsContainer);
               }
               this.fpsContainer = null;
            }
            return;
         }
         if($chat.msg == "updateFlashP2PKey")
         {
            for(i = 0; i < PlayerManager.Instance.onlineFriendList.length; i++)
            {
               SocketManager.Instance.out.sendPeerID(PlayerManager.Instance.Self.ZoneID,PlayerManager.Instance.onlineFriendList[i].ID,"");
            }
            return;
         }
         if(GameManager.GAME_CAN_NOT_EXIT_SEND_LOG == 1 && $chat.msg == "发_送_日_志")
         {
            GameManager.Instance.gameView.logTimeHandler();
         }
         if(this.chatDisabled)
         {
            return;
         }
         if($chat.channel == ChatInputView.PRIVATE)
         {
            if($chat.zoneID == -1 || $chat.zoneID == PlayerManager.Instance.Self.ZoneID)
            {
               this.sendPrivateMessage($chat.receiver,$chat.msg,$chat.receiverID,false);
            }
            else
            {
               this.sendAreaPrivateMessage($chat.receiver,$chat.msg,$chat.zoneID);
            }
         }
         else if($chat.channel == ChatInputView.CROSS_BUGLE)
         {
            this.sendBugle($chat.msg,EquipType.T_CBUGLE);
         }
         else if($chat.channel == ChatInputView.BIG_BUGLE)
         {
            this.sendBugle($chat.msg,EquipType.T_BBUGLE);
         }
         else if($chat.channel == ChatInputView.SMALL_BUGLE)
         {
            this.sendBugle($chat.msg,EquipType.T_SBUGLE);
         }
         else if($chat.channel == ChatInputView.CONSORTIA)
         {
            this.sendMessage($chat.channel,$chat.sender,$chat.msg,false);
            dispatchEvent(new ChatEvent(ChatEvent.SEND_CONSORTIA));
         }
         else if($chat.channel == ChatInputView.TEAM)
         {
            this.sendMessage($chat.channel,$chat.sender,$chat.msg,true);
         }
         else if($chat.channel == ChatInputView.CURRENT)
         {
            this.sendMessage($chat.channel,$chat.sender,$chat.msg,false);
         }
         else if($chat.channel == ChatInputView.CHURCH_CHAT)
         {
            this.sendMessage($chat.channel,$chat.sender,$chat.msg,false);
         }
         else if($chat.channel == ChatInputView.HOTSPRING_ROOM)
         {
            this.sendMessage($chat.channel,$chat.sender,$chat.msg,false);
         }
         else if($chat.channel == ChatInputView.WORLDBOSS_ROOM)
         {
            this.sendMessage($chat.channel,$chat.sender,$chat.msg,false);
         }
         else if($chat.channel == ChatInputView.CHRISTMAS_CHAT)
         {
            this.sendMessage($chat.channel,$chat.sender,$chat.msg,false);
         }
         else if($chat.channel == ChatInputView.SUPERWINNER_CHAT)
         {
            this.sendMessage($chat.channel,$chat.sender,$chat.msg,false);
         }
      }
      
      public function sendFace(faceid:int) : void
      {
         SocketManager.Instance.out.sendFace(faceid);
      }
      
      public function setFocus() : void
      {
         this._chatView.input.inputField.setFocus();
      }
      
      public function releaseFocus() : void
      {
         StageReferance.stage.focus = StageReferance.stage;
      }
      
      public function setup() : void
      {
         if(this._firstsetup)
         {
            if(Boolean(this._chatView))
            {
               throw new ErrorEvent("ChatManager setup Error :",false,false,"");
            }
            this.initView();
            this.initEvent();
         }
      }
      
      public function get state() : int
      {
         return this._state;
      }
      
      public function set state($state:int) : void
      {
         if(this._state == $state)
         {
            return;
         }
         this._state = $state;
         this._chatView.state = this._state;
      }
      
      public function switchVisible() : void
      {
         if(this._visibleSwitchEnable)
         {
            if(Boolean(this._chatView.input.parent))
            {
               this._chatView.input.parent.removeChild(this._chatView.input);
               this._chatView.output.functionEnabled = false;
               this._chatView.input.fastReplyPanel.isEditing = false;
               StageReferance.stage.focus = null;
            }
            else
            {
               this._chatView.addChild(this.input);
               this._chatView.output.functionEnabled = true;
               this._chatView.input.inputField.setFocus();
            }
         }
         this._chatView.input.hidePanel();
      }
      
      public function sysChatRed(message:String) : void
      {
         var chatData:ChatData = new ChatData();
         chatData.channel = ChatInputView.SYS_NOTICE;
         chatData.msg = StringHelper.trim(message);
         this.chat(chatData);
      }
      
      public function sysChatYellow(message:String) : void
      {
         var chatData:ChatData = new ChatData();
         chatData.channel = ChatInputView.SYS_TIP;
         chatData.msg = StringHelper.trim(message);
         this.chat(chatData);
      }
      
      public function sysChatLinkYellow(message:String) : void
      {
         var chatData:ChatData = new ChatData();
         chatData.type = ChatFormats.CLICK_EFFORT;
         chatData.channel = ChatInputView.SYS_TIP;
         chatData.msg = StringHelper.trim(message);
         this.chat(chatData);
      }
      
      public function sysChatAmaranth(message:String) : void
      {
         var chatData:ChatData = new ChatData();
         chatData.channel = ChatInputView.GM_NOTICE;
         chatData.msg = StringHelper.trim(message);
         this.chat(chatData);
      }
      
      public function sysChatNotAgain(message:String) : void
      {
         var chatData:ChatData = new ChatData();
         chatData.type = ChatFormats.CLICK_NO_TIP;
         chatData.channel = ChatInputView.SYS_TIP;
         chatData.msg = StringHelper.trim(message);
         this.chat(chatData);
      }
      
      public function get view() : ChatView
      {
         return this._chatView;
      }
      
      public function get visibleSwitchEnable() : Boolean
      {
         return this._visibleSwitchEnable;
      }
      
      public function set visibleSwitchEnable(value:Boolean) : void
      {
         if(this._visibleSwitchEnable == value)
         {
            return;
         }
         this._visibleSwitchEnable = value;
      }
      
      private function __bBugle(event:CrazyTankSocketEvent) : void
      {
         if(PlayerManager.Instance.Self.Grade <= CHAT_LEVEL)
         {
            return;
         }
         var pkg:PackageIn = event.pkg as PackageIn;
         var cm:ChatData = new ChatData();
         cm.bigBuggleType = pkg.readInt();
         cm.channel = ChatInputView.BIG_BUGLE;
         cm.senderID = pkg.readInt();
         cm.receiver = "";
         cm.sender = pkg.readUTF();
         cm.msg = pkg.readUTF();
         this.chat(cm);
      }
      
      private function __bugleBuyHandler(event:CrazyTankSocketEvent) : void
      {
         if(PlayerManager.Instance.Self.Grade <= CHAT_LEVEL)
         {
            return;
         }
         var pkg:PackageIn = event.pkg;
         pkg.position = SocketManager.PACKAGE_CONTENT_START_INDEX;
         var successType:int = pkg.readInt();
         var buyFrom:int = pkg.readInt();
         if(buyFrom == 3 && successType == 1)
         {
            if(!this._isFastInvite)
            {
               this.input.sendCurrentText();
            }
            else
            {
               this.sendBugle("",EquipType.T_SBUGLE,true);
            }
         }
         else if(buyFrom == 5 && successType >= 1)
         {
            dispatchEvent(new Event(CrazyTankSocketEvent.BUY_BEAD));
         }
      }
      
      private function __cBugle(event:CrazyTankSocketEvent) : void
      {
         if(PlayerManager.Instance.Self.Grade <= CHAT_LEVEL)
         {
            return;
         }
         var pkg:PackageIn = event.pkg as PackageIn;
         var cm:ChatData = new ChatData();
         cm.channel = ChatInputView.CROSS_BUGLE;
         cm.zoneID = pkg.readInt();
         cm.senderID = pkg.readInt();
         cm.receiver = "";
         cm.sender = pkg.readUTF();
         cm.msg = pkg.readUTF();
         cm.zoneName = pkg.readUTF();
         this.chat(cm);
      }
      
      private function __consortiaChat(event:CrazyTankSocketEvent) : void
      {
         var c:int = 0;
         var cm:ChatData = null;
         if(PlayerManager.Instance.Self.Grade <= CHAT_LEVEL)
         {
            return;
         }
         var pkg:PackageIn = event.pkg as PackageIn;
         if(pkg.clientId != PlayerManager.Instance.Self.ID)
         {
            c = pkg.readByte();
            cm = new ChatData();
            cm.channel = ChatInputView.CONSORTIA;
            cm.senderID = pkg.clientId;
            cm.receiver = "";
            cm.sender = pkg.readUTF();
            cm.msg = pkg.readUTF();
            this.chatCheckSelf(cm);
         }
      }
      
      private function __defyAffiche(event:CrazyTankSocketEvent) : void
      {
         if(PlayerManager.Instance.Self.Grade <= CHAT_LEVEL)
         {
            return;
         }
         var pkg:PackageIn = event.pkg as PackageIn;
         var cm:ChatData = new ChatData();
         cm.msg = pkg.readUTF();
         cm.channel = ChatInputView.DEFY_AFFICHE;
         this.chatCheckSelf(cm);
      }
      
      private function __getItemMsgHandler(event:CrazyTankSocketEvent) : void
      {
         var txt:String = null;
         var battle_str:String = null;
         var goodname:String = null;
         var itemName:String = null;
         var str:String = null;
         if(PlayerManager.Instance.Self.Grade <= CHAT_LEVEL)
         {
            return;
         }
         var pkg:PackageIn = event.pkg as PackageIn;
         var nickName:String = pkg.readUTF();
         var battle_type:int = pkg.readInt();
         var templateID:int = pkg.readInt();
         var isbinds:Boolean = pkg.readBoolean();
         var isBroadcast:int = pkg.readInt();
         var goodNum:int = pkg.readInt();
         if(battle_type == 0)
         {
            battle_str = LanguageMgr.GetTranslation("tank.game.GameView.unexpectedBattle");
         }
         else if(battle_type == 2)
         {
            battle_str = LanguageMgr.GetTranslation("tank.game.GameView.RouletteBattle");
         }
         else if(battle_type == 1)
         {
            battle_str = LanguageMgr.GetTranslation("tank.game.GameView.dungeonBattle");
         }
         else if(battle_type == 3)
         {
            battle_str = LanguageMgr.GetTranslation("tank.game.GameView.CaddyBattle");
         }
         else if(battle_type == 4)
         {
            battle_str = LanguageMgr.GetTranslation("tank.game.GameView.beadBattle");
         }
         else if(battle_type == 5)
         {
            battle_str = LanguageMgr.GetTranslation("tank.game.GameView.GiftBattle");
         }
         else if(battle_type == 11)
         {
            battle_str = LanguageMgr.GetTranslation("tank.game.GameView.BlessBattle");
         }
         else if(battle_type == 14)
         {
            battle_str = LanguageMgr.GetTranslation("tank.game.GameView.celebrationBattle");
         }
         else if(battle_type == 16)
         {
            itemName = ItemManager.Instance.getTemplateById(templateID).Name;
            battle_str = LanguageMgr.GetTranslation("tank.game.GameView.gypsyShopBought",nickName,itemName);
         }
         if(isBroadcast == 1)
         {
            txt = LanguageMgr.GetTranslation("tank.game.GameView.getgoodstip.broadcast","[" + nickName + "]",battle_str);
         }
         else if(isBroadcast == 2)
         {
            txt = LanguageMgr.GetTranslation("tank.game.GameView.getgoodstip",nickName,battle_str);
         }
         else if(isBroadcast == 3)
         {
            str = pkg.readUTF();
            txt = LanguageMgr.GetTranslation("tank.manager.congratulateGain","[" + nickName + "]",str);
            CaddyModel.instance.appendAwardsInfo(nickName,templateID,false,"",-1,battle_type);
         }
         else if(isBroadcast == 4)
         {
            txt = battle_str;
         }
         var itemInfo:ItemTemplateInfo = ItemManager.Instance.getTemplateById(templateID);
         if(itemInfo.Property1 != "31")
         {
            goodname = "[" + itemInfo.Name + "]";
         }
         else
         {
            goodname = "[" + itemInfo.Name + "-" + BeadTemplateManager.Instance.GetBeadInfobyID(templateID).Name + "Lv" + BeadTemplateManager.Instance.GetBeadInfobyID(templateID).BaseLevel + "]";
         }
         var data:ChatData = new ChatData();
         data.channel = ChatInputView.SYS_NOTICE;
         data.msg = txt + goodname + "x" + goodNum;
         var channelTag:Array = ChatFormats.getTagsByChannel(data);
         txt = StringHelper.rePlaceHtmlTextField(txt);
         var nameTag:String = ChatFormats.creatBracketsTag(txt,ChatFormats.CLICK_USERNAME);
         var goodTag:String = ChatFormats.creatGoodTag("[" + itemInfo.Name + "]" + "x" + goodNum,ChatFormats.CLICK_GOODS,itemInfo.TemplateID,itemInfo.Quality,isbinds,data);
         data.htmlMessage = channelTag[0] + nameTag + goodTag + channelTag[1] + "<BR>";
         data.htmlMessage = Helpers.deCodeString(data.htmlMessage);
         this._model.addChat(data);
      }
      
      private function __goodLinkGetHandler(e:CrazyTankSocketEvent) : void
      {
         var cardGroove:GrooveInfo = null;
         var guid:String = null;
         var cardInfo:CardInfo = null;
         var guid2:String = null;
         if(PlayerManager.Instance.Self.Grade <= CHAT_LEVEL)
         {
            return;
         }
         var info:InventoryItemInfo = new InventoryItemInfo();
         var pkg:PackageIn = e.pkg;
         var type:int = pkg.readInt();
         if(type == 4)
         {
            cardGroove = new GrooveInfo();
            guid = pkg.readUTF();
            cardGroove.CardId = pkg.readInt();
            cardGroove.Place = pkg.readInt();
            cardGroove.Type = pkg.readInt();
            cardGroove.Level = pkg.readInt();
            cardGroove.GP = pkg.readInt();
            if(Boolean(CardControl.Instance.model.GrooveInfoVector))
            {
               CardControl.Instance.model.GrooveInfoVector[cardGroove.Place] = cardGroove;
            }
            else
            {
               CardControl.Instance.model.tempCardGroove = cardGroove;
            }
            this.model.addCardGrooveLink(guid,cardGroove);
            this.output.contentField.chat_system::showCardGrooveLinkGoodsInfo(cardGroove,1);
            return;
         }
         if(type == 5)
         {
            cardInfo = new CardInfo();
            guid2 = pkg.readUTF();
            cardInfo.TemplateID = pkg.readInt();
            cardInfo.CardType = pkg.readInt();
            cardInfo.Attack = pkg.readInt();
            cardInfo.Defence = pkg.readInt();
            cardInfo.Agility = pkg.readInt();
            cardInfo.Luck = pkg.readInt();
            cardInfo.Damage = pkg.readInt();
            cardInfo.Guard = pkg.readInt();
            cardInfo.Place = 6;
            this.model.addCardInfoLink(guid2,cardInfo);
            this.output.contentField.chat_system::showCardInfoLinkGoodsInfo(cardInfo,1);
            return;
         }
         var gUid:String = pkg.readUTF();
         info.TemplateID = pkg.readInt();
         ItemManager.fill(info);
         info.ItemID = pkg.readInt();
         info.StrengthenLevel = pkg.readInt();
         info.AttackCompose = pkg.readInt();
         info.AgilityCompose = pkg.readInt();
         info.LuckCompose = pkg.readInt();
         info.DefendCompose = pkg.readInt();
         if(EquipType.isMagicStone(info.CategoryID))
         {
            info.Attack = info.AttackCompose;
            info.Defence = info.DefendCompose;
            info.Agility = info.AgilityCompose;
            info.Luck = info.LuckCompose;
            info.Level = info.StrengthenLevel;
            info.MagicAttack = pkg.readInt();
            info.MagicDefence = pkg.readInt();
         }
         else
         {
            pkg.readInt();
            pkg.readInt();
         }
         info.ValidDate = pkg.readInt();
         info.IsBinds = pkg.readBoolean();
         info.IsJudge = pkg.readBoolean();
         info.IsUsed = pkg.readBoolean();
         if(info.IsUsed)
         {
            info.BeginDate = pkg.readUTF();
         }
         info.Hole1 = pkg.readInt();
         info.Hole2 = pkg.readInt();
         info.Hole3 = pkg.readInt();
         info.Hole4 = pkg.readInt();
         info.Hole5 = pkg.readInt();
         info.Hole6 = pkg.readInt();
         info.Hole = pkg.readUTF();
         info.Pic = pkg.readUTF();
         info.RefineryLevel = pkg.readInt();
         info.DiscolorValidDate = pkg.readDateString();
         info.Hole5Level = pkg.readByte();
         info.Hole5Exp = pkg.readInt();
         info.Hole6Level = pkg.readByte();
         info.Hole6Exp = pkg.readInt();
         info.isGold = pkg.readBoolean();
         if(info.isGold)
         {
            info.goldValidDate = pkg.readInt();
            info.goldBeginTime = pkg.readDateString();
         }
         info.MagicLevel = pkg.readInt();
         this.model.addLink(gUid,info);
         this.output.contentField.chat_system::showLinkGoodsInfo(info,1);
      }
      
      private function __p2pPrivateChat(event:StreamEvent) : void
      {
         if(PlayerManager.Instance.Self.Grade <= CHAT_LEVEL)
         {
            return;
         }
         var pkg:ByteArray = event.readByteArray;
         var cm:ChatData = new ChatData();
         cm.channel = ChatInputView.PRIVATE;
         cm.receiverID = pkg.readInt();
         cm.receiver = pkg.readUTF();
         cm.sender = pkg.readUTF();
         cm.senderID = pkg.readInt();
         cm.msg = pkg.readUTF();
         cm.isAutoReply = pkg.readBoolean();
         this.chatCheckSelf(cm);
         if(cm.senderID != PlayerManager.Instance.Self.ID)
         {
            IMController.Instance.saveRecentContactsID(cm.senderID);
         }
         else if(cm.receiverID != PlayerManager.Instance.Self.ID)
         {
            IMController.Instance.saveRecentContactsID(cm.receiverID);
         }
      }
      
      private function __privateChat(event:CrazyTankSocketEvent) : void
      {
         var cm:ChatData = null;
         if(PlayerManager.Instance.Self.Grade <= CHAT_LEVEL)
         {
            return;
         }
         var pkg:PackageIn = event.pkg;
         if(Boolean(pkg.clientId))
         {
            cm = new ChatData();
            cm.channel = ChatInputView.PRIVATE;
            cm.receiverID = pkg.readInt();
            cm.senderID = pkg.clientId;
            cm.receiver = pkg.readUTF();
            cm.sender = pkg.readUTF();
            cm.msg = pkg.readUTF();
            cm.isAutoReply = pkg.readBoolean();
            this.chatCheckSelf(cm);
            if(cm.senderID != PlayerManager.Instance.Self.ID)
            {
               IMController.Instance.saveRecentContactsID(cm.senderID);
            }
            else if(cm.receiverID != PlayerManager.Instance.Self.ID)
            {
               IMController.Instance.saveRecentContactsID(cm.receiverID);
            }
         }
      }
      
      private function __areaPrivateChat(event:CrazyTankSocketEvent) : void
      {
         if(PlayerManager.Instance.Self.Grade <= CHAT_LEVEL)
         {
            return;
         }
         var pkg:PackageIn = event.pkg;
         var cm:ChatData = new ChatData();
         cm.channel = ChatInputView.PRIVATE;
         cm.zoneName = pkg.readUTF();
         cm.sender = pkg.readUTF();
         cm.msg = pkg.readUTF();
         cm.zoneID = pkg.readInt();
         if(SharedManager.Instance.transregionalblackList[cm.sender] != null)
         {
            return;
         }
         this.chatCheckSelf(cm);
      }
      
      private function __receiveFace(evt:CrazyTankSocketEvent) : void
      {
         if(PlayerManager.Instance.Self.Grade <= CHAT_LEVEL)
         {
            return;
         }
         var data:Object = {};
         data.playerid = evt.pkg.clientId;
         data.faceid = evt.pkg.readInt();
         data.delay = evt.pkg.readInt();
         dispatchEvent(new ChatEvent(ChatEvent.SHOW_FACE,data));
      }
      
      private function __sBugle(event:CrazyTankSocketEvent) : void
      {
         if(PlayerManager.Instance.Self.Grade <= CHAT_LEVEL)
         {
            return;
         }
         var pkg:PackageIn = event.pkg as PackageIn;
         var cm:ChatData = new ChatData();
         cm.channel = ChatInputView.SMALL_BUGLE;
         cm.senderID = pkg.readInt();
         cm.receiver = "";
         cm.sender = pkg.readUTF();
         cm.msg = pkg.readUTF();
         this.chat(cm);
      }
      
      private function __fastInviteCall(event:CrazyTankSocketEvent) : void
      {
         var pkg:PackageIn = event.pkg as PackageIn;
         var cm:ChatData = new ChatData();
         cm.type = ChatFormats.CLICK_FASTINVITE;
         cm.channel = ChatInputView.SMALL_BUGLE;
         cm.senderID = pkg.readInt();
         cm.receiver = "";
         cm.sender = pkg.readUTF();
         cm.msg = pkg.readUTF();
         cm.roomId = pkg.readInt();
         cm.password = pkg.readUTF();
         this.chat(cm);
      }
      
      private function __fastAuctionBugle(event:CrazyTankSocketEvent) : void
      {
         var pkg:PackageIn = event.pkg as PackageIn;
         var cm:ChatData = new ChatData();
         cm.type = ChatFormats.CLICK_FASTAUCTION;
         cm.channel = ChatInputView.SMALL_BUGLE;
         cm.receiver = "";
         cm.playerCharacterID = pkg.readInt();
         cm.sender = pkg.readUTF();
         cm.auctionID = pkg.readInt();
         cm.teamplateID = pkg.readInt();
         cm.itemCount = pkg.readInt();
         cm.mouthful = pkg.readInt();
         cm.payType = pkg.readInt();
         cm.price = pkg.readInt();
         cm.rise = pkg.readInt();
         cm.validDate = pkg.readInt();
         cm.auctionGoodName = ItemManager.Instance.getTemplateById(cm.teamplateID).Name;
         cm.msg = "【" + cm.sender + "】" + LanguageMgr.GetTranslation("tank.auctionHouse.view.AuctionSellLeftView.bugleTxt",cm.price,cm.mouthful,cm.auctionGoodName,cm.itemCount);
         this.chat(cm);
      }
      
      private function __sceneChat(event:CrazyTankSocketEvent) : void
      {
         if(PlayerManager.Instance.Self.Grade <= CHAT_LEVEL)
         {
            return;
         }
         var pkg:PackageIn = event.pkg as PackageIn;
         var cm:ChatData = new ChatData();
         cm.zoneID = pkg.readInt();
         cm.channel = pkg.readByte();
         if(pkg.readBoolean())
         {
            cm.channel = ChatInputView.TEAM;
         }
         cm.senderID = pkg.clientId;
         cm.receiver = "";
         cm.sender = pkg.readUTF();
         cm.msg = pkg.readUTF();
         this.chatCheckSelf(cm);
         this.addRecentContacts(cm.senderID);
      }
      
      private function addRecentContacts(id:int) : void
      {
         if(StateManager.currentStateType == StateType.DUNGEON_ROOM || StateManager.currentStateType == StateType.CHALLENGE_ROOM || StateManager.currentStateType == StateType.MATCH_ROOM || StateManager.currentStateType == StateType.MISSION_ROOM || StateManager.currentStateType == StateType.GAME_LOADING)
         {
            if(RoomManager.Instance.isIdenticalRoom(id))
            {
               IMController.Instance.saveRecentContactsID(id);
            }
         }
         else if(StateManager.currentStateType == StateType.FIGHTING)
         {
            if(GameManager.Instance.isIdenticalGame(id))
            {
               IMController.Instance.saveRecentContactsID(id);
            }
         }
      }
      
      private function __sysNotice(event:CrazyTankSocketEvent) : void
      {
         var links:Array = null;
         var caddy:int = 0;
         var name:String = null;
         var id:int = 0;
         var zone:String = null;
         if(PlayerManager.Instance.Self.Grade <= CHAT_LEVEL)
         {
            return;
         }
         var type:int = event.pkg.readInt();
         var msg:String = event.pkg.readUTF();
         var o:ChatData = new ChatData();
         var isReadKey:Boolean = false;
         switch(type)
         {
            case 0:
               o.channel = ChatInputView.GM_NOTICE;
               break;
            case 1:
            case 5:
            case 20:
            case 21:
               isReadKey = true;
            case 2:
            case 6:
            case 7:
               o.channel = ChatInputView.SYS_TIP;
               break;
            case 3:
               o.channel = ChatInputView.SYS_NOTICE;
               break;
            case 8:
               o.channel = ChatInputView.CONSORTIA;
               break;
            case 10:
            case 11:
            case 18:
            case 19:
               isReadKey = true;
            case 13:
               o.zoneID = event.pkg.readInt();
               o.channel = ChatInputView.CROSS_NOTICE;
               break;
            case 12:
               o.zoneID = event.pkg.readInt();
               o.channel = ChatInputView.CROSS_NOTICE;
               break;
            case 9:
               o.channel = ChatInputView.SYS_TIP;
               break;
            default:
               o.channel = ChatInputView.SYS_TIP;
         }
         if(Boolean(event) && Boolean(event.pkg.bytesAvailable))
         {
            links = ChatHelper.chat_system::readGoodsLinks(event.pkg,isReadKey);
         }
         o.type = type;
         o.zoneName = PlayerManager.Instance.getAreaNameByAreaID(o.zoneID);
         o.msg = StringHelper.rePlaceHtmlTextField(msg);
         o.link = links;
         this.chat(o);
         if(type == 12 && Boolean(event.pkg.bytesAvailable))
         {
            caddy = event.pkg.readInt();
            if(caddy > 0)
            {
               name = event.pkg.readUTF();
               id = event.pkg.readInt();
               zone = event.pkg.readUTF();
               if(name != PlayerManager.Instance.Self.NickName)
               {
                  CaddyModel.instance.appendAwardsInfo(name,id,true,zone,o.zoneID,caddy);
               }
            }
         }
      }
      
      private function chatCheckSelf(data:ChatData) : void
      {
         var b:DictionaryData = null;
         var player:PlayerInfo = null;
         if(!PlayerManager.Instance.Self.IsWeakGuildFinish(Step.CONSORTIA_CHAT) && TaskManager.instance.getQuestDataByID(344) && data.channel == ChatInputView.CONSORTIA)
         {
            SocketManager.Instance.out.sendQuestCheck(344,1,0);
            SocketManager.Instance.out.syncWeakStep(Step.CONSORTIA_CHAT);
         }
         if(data.zoneID != -1 && data.zoneID != PlayerManager.Instance.Self.ZoneID)
         {
            if(data.sender != PlayerManager.Instance.Self.NickName || data.zoneID != PlayerManager.Instance.Self.ZoneID)
            {
               this.chat(data);
               return;
            }
         }
         else if(data.sender != PlayerManager.Instance.Self.NickName)
         {
            if(data.channel == ChatInputView.CONSORTIA)
            {
               b = PlayerManager.Instance.blackList;
               for each(player in b)
               {
                  if(player.NickName == data.sender)
                  {
                     return;
                  }
               }
            }
            this.chat(data);
         }
      }
      
      protected function __onPlayerOnline(event:NewHallEvent) : void
      {
         var pkg:PackageIn = event.pkg;
         var name:String = pkg.readUTF();
         var titleID:int = pkg.readInt();
         var title:String = NewTitleManager.instance.titleInfo[titleID].Name;
         var data:ChatData = new ChatData();
         data.channel = ChatInputView.COMPLEX_NOTICE;
         data.childChannelArr = [ChatInputView.SYS_TIP,titleID,ChatInputView.SYS_TIP];
         data.msg = LanguageMgr.GetTranslation("hall.player.online",title,name);
         this.chat(data);
      }
      
      private function initEvent() : void
      {
         if(!SHIELD_NOTICE)
         {
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.FAST_INVITE_CALL,this.__fastInviteCall);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.S_BUGLE,this.__sBugle);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.FAST_AUCTION_BUGLE,this.__fastAuctionBugle);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.B_BUGLE,this.__bBugle);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.C_BUGLE,this.__cBugle);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.GET_ITEM_MESS,this.__getItemMsgHandler);
            IMController.Instance.addEventListener(IMController.ISFUBLISH,this.__yearFoodIsFublish);
         }
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.CHAT_PERSONAL,this.__privateChat);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.AREA_CHAT,this.__areaPrivateChat);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.SCENE_CHAT,this.__sceneChat);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.CONSORTIA_CHAT,this.__consortiaChat);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.SCENE_FACE,this.__receiveFace);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.SYS_NOTICE,this.__sysNotice);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.DEFY_AFFICHE,this.__defyAffiche);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.BUY_GOODS,this.__bugleBuyHandler);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.LINKGOODSINFO_GET,this.__goodLinkGetHandler);
         SocketManager.Instance.addEventListener(NewHallEvent.PLAYERONLINE,this.__onPlayerOnline);
         FlashP2PManager.Instance.addEventListener(StreamEvent.PRIVATE_MSG,this.__p2pPrivateChat);
      }
      
      private function __yearFoodIsFublish(event:Event) : void
      {
         var cm:ChatData = new ChatData();
         cm.type = ChatFormats.NEWYEARFOOD;
         cm.channel = ChatInputView.SMALL_BUGLE;
         cm.senderID = NewYearRiceManager.instance.model.playerID;
         cm.receiver = "";
         cm.sender = NewYearRiceManager.instance.model.playerName;
         cm.msg = "【" + cm.sender + "】" + LanguageMgr.GetTranslation("tank.newyearFood.view.bugleTxt");
         this.chat(cm);
      }
      
      private function initView() : void
      {
         ChatFormats.setup();
         this._model = new ChatModel();
         this._chatView = ComponentFactory.Instance.creatCustomObject("chat.View");
         this.state = CHAT_HALL_STATE;
         this.inputChannel = ChatInputView.CURRENT;
         this.outputChannel = ChatOutputView.CHAT_OUPUT_CURRENT;
      }
      
      private function sendMessage(channelid:int, fromnick:String, msg:String, team:Boolean) : void
      {
         msg = Helpers.enCodeString(msg);
         var pkg:PackageOut = new PackageOut(ePackageType.SCENE_CHAT);
         pkg.writeByte(channelid);
         pkg.writeBoolean(team);
         pkg.writeUTF(fromnick);
         pkg.writeUTF(msg);
         SocketManager.Instance.out.sendPackage(pkg);
      }
      
      public function sendPrivateMessage(toNick:String, msg:String, toId:Number = 0, isAutoReply:Boolean = false) : void
      {
         var pkg:PackageOut = null;
         if(PathManager.flashP2PEbable && PlayerManager.Instance.findPlayer(toId).peerID != "")
         {
            msg = Helpers.enCodeString(msg);
            FlashP2PManager.Instance.sendPlivateMsg(PlayerManager.Instance.findPlayer(toId).peerID,toNick,msg,toId,isAutoReply);
         }
         else
         {
            msg = Helpers.enCodeString(msg);
            pkg = new PackageOut(ePackageType.CHAT_PERSONAL);
            pkg.writeInt(toId);
            pkg.writeUTF(toNick);
            pkg.writeUTF(PlayerManager.Instance.Self.NickName);
            pkg.writeUTF(msg);
            pkg.writeBoolean(isAutoReply);
            SocketManager.Instance.out.sendPackage(pkg);
         }
         if(Boolean(RoomManager.Instance.current) && !RoomManager.Instance.current.isCrossZone)
         {
            IMController.Instance.saveRecentContactsID(toId);
         }
      }
      
      public function sendAreaPrivateMessage(toNick:String, msg:String, zoneID:int = -1) : void
      {
         msg = Helpers.enCodeString(msg);
         var pkg:PackageOut = new PackageOut(ePackageType.AREA_CHAT);
         pkg.writeInt(zoneID);
         pkg.writeUTF(msg);
         pkg.writeUTF(toNick);
         SocketManager.Instance.out.sendPackage(pkg);
      }
      
      public function sendOldPlayerLoginPrompt(pkg:PackageIn) : void
      {
         var tmpName:String = pkg.readUTF();
         var chatData:ChatData = new ChatData();
         chatData.channel = ChatInputView.COMPLEX_NOTICE;
         chatData.childChannelArr = [ChatInputView.SYS_TIP,ChatInputView.GM_NOTICE];
         chatData.type = ChatFormats.CLICK_INVITE_OLD_PLAYER;
         chatData.msg = LanguageMgr.GetTranslation("oldPlayer.login.promptTxt",tmpName);
         chatData.receiver = tmpName;
         if(PlayerManager.Instance.Self.ConsortiaID != 0 && ConsortiaDutyManager.GetRight(PlayerManager.Instance.Self.Right,ConsortiaDutyType._2_Invite))
         {
            chatData.msg += "|" + LanguageMgr.GetTranslation("oldPlayer.login.promptTxt2");
         }
         this.chat(chatData);
      }
   }
}

