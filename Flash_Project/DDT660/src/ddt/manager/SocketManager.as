package ddt.manager
{
	import baglocked.data.BagLockedEvent;
	import boguAdventure.model.BoguAdventureType;
	import bombKing.data.BombKingType;
	import bombKing.event.BombKingEvent;
	import catchInsect.event.CatchInsectEvent;
	import chickActivation.ChickActivationType;
	import com.pickgliss.events.FrameEvent;
	import com.pickgliss.loader.LoaderSavingManager;
	import com.pickgliss.ui.AlertManager;
	import com.pickgliss.ui.LayerManager;
	import com.pickgliss.ui.controls.alert.BaseAlerFrame;
	import com.pickgliss.utils.ObjectUtils;
	import consumeRank.data.ConsumeRankEvent;
	import ddt.data.socket.*;
	import ddt.events.CrazyTankSocketEvent;
	import ddt.events.GypsyShopEvent;
	import ddt.events.WorshipTheMoonEvent;
	import ddt.view.CheckCodeFrame;
	import entertainmentMode.data.EntertainmentPackageType;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.external.ExternalInterface;
	import flowerGiving.data.FlowerGivingType;
	import flowerGiving.events.FlowerGivingEvent;
	import growthPackage.GrowthPackageType;
	import hall.event.NewHallEvent;
	import halloween.data.HalloweenType;
	import horseRace.data.HorseRacePackageType;
	import itemActivityGift.ItemActivityGiftType;
	import kingDivision.data.KingDivisionPackageType;
	import kingDivision.event.KingDivisionEvent;
	import labyrinth.data.LabyrinthPackageType;
	import littleGame.LittleGamePacketQueue;
	import littleGame.data.LittleGamePackageInType;
	import littleGame.events.LittleGameSocketEvent;
	import magicHouse.MagicHousePackageType;
	import magicStone.data.MagicStoneEvent;
	import magicStone.data.MagicStoneType;
	import magpieBridge.event.MagpieBridgeEvent;
	import newChickenBox.model.NewChickenBoxPackageType;
	import petsBag.controller.PetBagController;
	import playerDress.data.PlayerDressEvent;
	import playerDress.data.PlayerDressType;
	import quest.TrusteeshipPackageType;
	import rescue.data.RescueEvent;
	import rescue.data.RescueType;
	import ringStation.event.RingStationEvent;
	import road7th.comm.ByteSocket;
	import road7th.comm.PackageIn;
	import road7th.comm.SocketEvent;
	import room.transnational.TransnationalPackageType;
	import worldboss.model.WorldBossPackageType;
	import zodiac.ZodiacPackageType;
	
	public class SocketManager extends EventDispatcher
	{
		
		private static var _instance:SocketManager;
		
		public static const PACKAGE_CONTENT_START_INDEX:int = 20;
		
		private var _socket:ByteSocket;
		
		private var _out:GameSocketOut;
		
		private var _isLogin:Boolean;
		
		public function SocketManager()
		{
			super();
			this._socket = new ByteSocket();
			this._socket.addEventListener(Event.CONNECT,this.__socketConnected);
			this._socket.addEventListener(Event.CLOSE,this.__socketClose);
			this._socket.addEventListener(SocketEvent.DATA,this.__socketData);
			this._socket.addEventListener(ErrorEvent.ERROR,this.__socketError);
			this._out = new GameSocketOut(this._socket);
		}
		
		public static function get Instance() : SocketManager
		{
			if(_instance == null)
			{
				_instance = new SocketManager();
			}
			return _instance;
		}
		
		public function set isLogin(value:Boolean) : void
		{
			this._isLogin = value;
		}
		
		public function get isLogin() : Boolean
		{
			return this._isLogin;
		}
		
		public function get socket() : ByteSocket
		{
			return this._socket;
		}
		
		public function get out() : GameSocketOut
		{
			return this._out;
		}
		
		public function connect(ip:String, port:Number) : void
		{
			this._socket.connect(ip,port);
		}
		
		private function __socketConnected(event:Event) : void
		{
			dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CONNECT_SUCCESS));
			this.out.sendLogin(PlayerManager.Instance.Account);
		}
		
		private function __socketClose(event:Event) : void
		{
			LeavePageManager.forcedToLoginPath(LanguageMgr.GetTranslation("tank.manager.RoomManager.break"));
			this.errorAlert(LanguageMgr.GetTranslation("tank.manager.RoomManager.break"));
		}
		
		private function __socketError(event:ErrorEvent) : void
		{
			this.errorAlert(LanguageMgr.GetTranslation("tank.manager.RoomManager.false"));
			CheckCodeFrame.Instance.close();
			ServerManager.Instance.refreshFlag = false;
		}
		
		private function __systemAlertResponse(evt:FrameEvent) : void
		{
			SoundManager.instance.play("008");
			var frame:BaseAlerFrame = evt.currentTarget as BaseAlerFrame;
			frame.addEventListener(FrameEvent.RESPONSE,this.__systemAlertResponse);
			frame.dispose();
			if(Boolean(frame.parent))
			{
				frame.parent.removeChild(frame);
			}
		}
		
		public function testWishBead() : void
		{
			dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.WISHBEADEQUIP));
		}
		
		private function __socketData(event:SocketEvent) : void
		{
			var pkg:PackageIn = null;
			var type:int = 0;
			var msg:String = null;
			var systemAlert:BaseAlerFrame = null;
			try
			{
				pkg = event.data;
				switch(pkg.code)
				{
					case ePackageType.RSAKEY:
						break;
					case ePackageType.SYS_MESSAGE:
						type = pkg.readInt();
						msg = pkg.readUTF();
						if(msg == "" || msg == null)
						{
							return;
						}
						if(msg.substr(0,5) == "撮合成功!")
						{
							StateManager.getInGame_Step_2 = true;
						}
						switch(type)
						{
							case 0:
								if(msg == "MissionLucreDecrease")
								{
									msg = LanguageMgr.GetTranslation("MissionLucreDecrease.info");
								}
								MessageTipManager.getInstance().show(msg,0,true);
								ChatManager.Instance.sysChatYellow(msg);
								break;
							case 1:
								MessageTipManager.getInstance().show(msg,0,true);
								ChatManager.Instance.sysChatRed(msg);
								break;
							case 2:
								ChatManager.Instance.sysChatYellow(msg);
								break;
							case 3:
								ChatManager.Instance.sysChatRed(msg);
								break;
							case 4:
								systemAlert = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),msg,LanguageMgr.GetTranslation("ok"),"",false,true,true,LayerManager.ALPHA_BLOCKGOUND);
								systemAlert.addEventListener(FrameEvent.RESPONSE,this.__systemAlertResponse);
								break;
							case 5:
								ChatManager.Instance.sysChatYellow(msg);
								break;
							case 6:
								ChatManager.Instance.sysChatLinkYellow(msg);
								break;
							case 7:
								PetBagController.instance().pushMsg(msg);
								break;
							case 8:
								ChatManager.Instance.sysChatAmaranth(msg);
								break;
							case 9:
								if(!ChatManager.Instance.notAgain)
								{
									MessageTipManager.getInstance().show(msg,0,true);
									ChatManager.Instance.sysChatNotAgain(msg);
								}
						}
						break;
					case ePackageType.NEW_HALL:
						this.setNewHallInfo(pkg);
						break;
					case ePackageType.SHOW_HIDE_TITLE:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.SHOW_HIDE_TITLE,pkg));
						break;
					case ePackageType.OLD_PLAYER_LOGIN:
						ChatManager.Instance.sendOldPlayerLoginPrompt(pkg);
						break;
					case ePackageType.RING_STATION:
						this.setRingStationInfo(pkg);
						break;
					case ePackageType.DAILY_AWARD:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.DAILY_AWARD,pkg));
						break;
					case ePackageType.WONDERFUL_ACTIVITY:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.WONDERFUL_ACTIVITY,pkg));
						break;
					case ePackageType.WONDERFUL_ACTIVITY_INIT:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.WONDERFUL_ACTIVITY_INIT,pkg));
						break;
					case ePackageType.LOGIN:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.LOGIN,pkg));
						break;
					case ePackageType.KIT_USER:
						this.kitUser(pkg.readUTF());
						break;
					case ePackageType.UPDATE_PLAYER_PROPERTY:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.UPDATE_PLAYER_PROPERTY,pkg));
						break;
					case ePackageType.PING:
						this.out.sendPint();
						break;
					case ePackageType.EDITION_ERROR:
						this.cleanLocalFile(pkg.readUTF());
						break;
					case ePackageType.WISHBEADEQUIP:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.WISHBEADEQUIP,pkg));
						break;
					case ePackageType.BAG_LOCKED:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.BAG_LOCKED,pkg));
						break;
					case ePackageType.SCENE_ADD_USER:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.SCENE_ADD_USER,pkg));
						break;
					case ePackageType.SCENE_REMOVE_USER:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.SCENE_REMOVE_USER,pkg));
						break;
					case ePackageType.GAME_ROOM:
						this.createGameRoomEvent(pkg);
						break;
					case ePackageType.GAME_CMD:
						this.createGameEvent(pkg);
						break;
					case ePackageType.FIGHTFOOTBALLTIMETAKEOUT:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.FIGHTFOOTBALLTIME_CMD,pkg));
						break;
					case ePackageType.FIGHTFOOTBALLTIMEACTIVE:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.FIGHTFOOTBALLTIME_ACTIVE,pkg));
						break;
					case ePackageType.SCENE_CHANNEL_CHANGE:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.SCENE_CHANNEL_CHANGE,pkg));
						break;
					case ePackageType.LEAGUE_START_NOTICE:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.POPUP_LEAGUESTART_NOTICE,pkg));
						break;
					case ePackageType.GAME_MISSION_START:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.GAME_MISSION_START,pkg));
						break;
					case ePackageType.SCENE_CHAT:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.SCENE_CHAT,pkg));
						break;
					case ePackageType.SCENE_FACE:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.SCENE_FACE,pkg));
						break;
					case ePackageType.DELETE_GOODS:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.DELETE_GOODS,pkg));
						break;
					case ePackageType.BUY_GOODS:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.BUY_GOODS,pkg));
						break;
					case ePackageType.CHANGE_PLACE_GOODS:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CHANGE_GOODS_PLACE,pkg));
						break;
					case ePackageType.CHAIN_EQUIP:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CHAIN_EQUIP,pkg));
						break;
					case ePackageType.UNCHAIN_EQUIP:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.UNCHAIN_EQUIP,pkg));
						break;
					case ePackageType.SEND_MAIL:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.SEND_EMAIL,pkg));
						break;
					case ePackageType.DELETE_MAIL:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.DELETE_MAIL,pkg));
						break;
					case ePackageType.GET_MAIL_ATTACHMENT:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.GET_MAIL_ATTACHMENT,pkg));
						break;
					case ePackageType.MAIL_CANCEL:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.MAIL_CANCEL,pkg));
						break;
					case ePackageType.SEll_GOODS:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.SELL_GOODS,pkg));
						break;
					case ePackageType.UPDATE_COUPONS:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.UPDATE_COUPONS,pkg));
						break;
					case ePackageType.ITEM_STORE:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.ITEM_STORE,pkg));
						break;
					case ePackageType.BATTLE_GROUND:
						this.battleGoundHander(pkg);
						break;
					case ePackageType.UPDATE_PRIVATE_INFO:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.UPDATE_PRIVATE_INFO,pkg));
						break;
					case ePackageType.UPDATE_PLAYER_INFO:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.UPDATE_PLAYER_INFO,pkg));
						break;
					case ePackageType.GRID_PROP:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.GRID_PROP,pkg));
						break;
					case ePackageType.EQUIP_CHANGE:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.EQUIP_CHANGE,pkg));
						break;
					case ePackageType.GRID_GOODS:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.GRID_GOODS,pkg));
						break;
					case ePackageType.NETWORK:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.NETWORK,pkg));
						break;
					case ePackageType.GAME_TAKE_TEMP:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.GAME_TAKE_TEMP,pkg));
						break;
					case ePackageType.SCENE_USERS_LIST:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.SCENE_USERS_LIST,pkg));
						break;
					case ePackageType.GAME_INVITE:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.GAME_INVITE,pkg));
						break;
					case ePackageType.S_BUGLE:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.S_BUGLE,pkg));
						break;
					case ePackageType.B_BUGLE:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.B_BUGLE,pkg));
						break;
					case ePackageType.C_BUGLE:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.C_BUGLE,pkg));
						break;
					case ePackageType.DEFY_AFFICHE:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.DEFY_AFFICHE,pkg));
						break;
					case ePackageType.CHAT_PERSONAL:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CHAT_PERSONAL,pkg));
						break;
					case ePackageType.AREA_CHAT:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.AREA_CHAT,pkg));
						break;
					case ePackageType.ITEM_COMPOSE:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.ITEM_COMPOSE,pkg));
						break;
					case ePackageType.ITEM_ADVANCE:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.ITEM_ADVANCE,pkg));
						break;
					case ePackageType.ITEM_STRENGTHEN:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.ITEM_STRENGTH,pkg));
						break;
					case ePackageType.ITEM_TRANSFER:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.ITEM_TRANSFER,pkg));
						break;
					case ePackageType.ITEM_FUSION_PREVIEW:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.ITEM_FUSION_PREVIEW,pkg));
						break;
					case ePackageType.ITEM_REFINERY_PREVIEW:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.ITEM_REFINERY_PREVIEW,pkg));
						break;
					case ePackageType.RUNE_COMMAND:
						this.handleBeadPkg(pkg);
						break;
					case ePackageType.OPEN_FIVE_SIX_HOLE:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.OPEN_FIVE_SIX_HOLE_EMEBED,pkg));
						break;
					case ePackageType.ITEM_FUSION:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.ITEM_FUSION,pkg));
						break;
					case ePackageType.QUEST_MANU_GET:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.QUEST_MANU_GET,pkg));
						break;
					case ePackageType.QUEST_UPDATE:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.QUEST_UPDATE,pkg));
						break;
					case ePackageType.QUSET_OBTAIN:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.QUEST_OBTAIN,pkg));
						break;
					case ePackageType.QUEST_CHECK:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.QUEST_CHECK,pkg));
						break;
					case ePackageType.QUEST_FINISH:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.QUEST_FINISH,pkg));
						break;
					case ePackageType.ITEM_OBTAIN:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.ITEM_OBTAIN,pkg));
						break;
					case ePackageType.ITEM_CONTINUE:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.ITEM_CONTINUE,pkg));
						break;
					case ePackageType.SYS_DATE:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.SYS_DATE,pkg));
						break;
					case ePackageType.ITEM_EQUIP:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.ITEM_EQUIP,pkg));
						break;
					case ePackageType.MATE_ONLINE_TIME:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.MATE_ONLINE_TIME,pkg));
						break;
					case ePackageType.SYS_NOTICE:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.SYS_NOTICE,pkg));
						break;
					case ePackageType.MAIL_RESPONSE:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.MAIL_RESPONSE,pkg));
						break;
					case ePackageType.AUCTION_REFRESH:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.AUCTION_REFRESH,pkg));
						break;
					case ePackageType.CHECK_CODE:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CHECK_CODE,pkg));
						break;
					case ePackageType.QUEST_ONEKEYFINISH:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.QUEST_ONEKEYFINISH,pkg));
						break;
					case ePackageType.SEARCH_GOODS:
						this.buriedEvents(pkg);
						break;
					case ePackageType.IM_CMD:
						this.createIMEvent(pkg);
						break;
					case ePackageType.ELITEGAME:
						this.createEliteGameEvent(pkg);
						break;
					case ePackageType.CONSORTIA_CMD:
						this.createConsortiaEvent(pkg);
						break;
					case ePackageType.CONSORTIA_RESPONSE:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CONSORTIA_RESPONSE,pkg));
						break;
					case ePackageType.CONSORTIA_MAIL_MESSAGE:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CONSORTIA_MAIL_MESSAGE,pkg));
						break;
					case ePackageType.CID_CHECK:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CID_CHECK,pkg));
						break;
					case ePackageType.ENTHRALL_LIGHT:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.ENTHRALL_LIGHT,pkg));
						break;
					case ePackageType.BUFF_OBTAIN:
						if(pkg.clientId == PlayerManager.Instance.Self.ID)
						{
							dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.BUFF_OBTAIN,pkg));
						}
						else
						{
							QueueManager.addQueue(new CrazyTankSocketEvent(CrazyTankSocketEvent.BUFF_OBTAIN,pkg));
						}
						break;
					case ePackageType.BUFF_ADD:
						if(pkg.clientId == PlayerManager.Instance.Self.ID)
						{
							dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.BUFF_ADD,pkg));
						}
						else
						{
							QueueManager.addQueue(new CrazyTankSocketEvent(CrazyTankSocketEvent.BUFF_ADD,pkg));
						}
						break;
					case ePackageType.BUFF_UPDATE:
						if(pkg.clientId == PlayerManager.Instance.Self.ID)
						{
							dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.BUFF_UPDATE,pkg));
						}
						else
						{
							QueueManager.addQueue(new CrazyTankSocketEvent(CrazyTankSocketEvent.BUFF_UPDATE,pkg));
						}
						break;
					case ePackageType.USE_COLOR_CARD:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.USE_COLOR_CARD,pkg));
						break;
					case ePackageType.AUCTION_UPDATE:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.AUCTION_UPDATE,pkg));
						break;
					case ePackageType.GOODS_PRESENT:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.GOODS_PRESENT,pkg));
						break;
					case ePackageType.GOODS_COUNT:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.GOODS_COUNT,pkg));
						break;
					case ePackageType.UPDATE_SHOP:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.REALlTIMES_ITEMS_BY_DISCOUNT,pkg));
						break;
					case ePackageType.MARRYINFO_GET:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.MARRYINFO_GET,pkg));
						break;
					case ePackageType.MARRY_STATUS:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.MARRY_STATUS,pkg));
						break;
					case ePackageType.MARRY_ROOM_CREATE:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.MARRY_ROOM_CREATE,pkg));
						break;
					case ePackageType.MARRY_ROOM_LOGIN:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.MARRY_ROOM_LOGIN,pkg));
						break;
					case ePackageType.MARRY_SCENE_LOGIN:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.MARRY_SCENE_LOGIN,pkg));
						break;
					case ePackageType.PLAYER_ENTER_MARRY_ROOM:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.PLAYER_ENTER_MARRY_ROOM,pkg));
						break;
					case ePackageType.PLAYER_EXIT_MARRY_ROOM:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.PLAYER_EXIT_MARRY_ROOM,pkg));
						break;
					case ePackageType.MARRY_APPLY:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.MARRY_APPLY,pkg));
						break;
					case ePackageType.MARRY_APPLY_REPLY:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.MARRY_APPLY_REPLY,pkg));
						break;
					case ePackageType.DIVORCE_APPLY:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.DIVORCE_APPLY,pkg));
						break;
					case ePackageType.MARRY_ROOM_STATE:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.MARRY_ROOM_STATE,pkg));
						break;
					case ePackageType.MARRY_ROOM_DISPOSE:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.MARRY_ROOM_DISPOSE,pkg));
						break;
					case ePackageType.MARRY_ROOM_UPDATE:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.MARRY_ROOM_UPDATE,pkg));
						break;
					case ePackageType.MARRYPROP_GET:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.MARRYPROP_GET,pkg));
						break;
					case ePackageType.MARRY_CMD:
						this.createChurchEvent(pkg);
						break;
					case ePackageType.AMARRYINFO_REFRESH:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.AMARRYINFO_REFRESH,pkg));
						break;
					case ePackageType.MARRYINFO_ADD:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.MARRYINFO_ADD,pkg));
						break;
					case ePackageType.LINKREQUEST_GOODS:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.LINKGOODSINFO_GET,pkg));
						break;
					case CrazyTankPackageType.INSUFFICIENT_MONEY:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.INSUFFICIENT_MONEY,pkg));
						break;
					case ePackageType.GET_ITEM_MESS:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.GET_ITEM_MESS,pkg));
						break;
					case ePackageType.USER_ANSWER:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.USER_ANSWER,pkg));
						break;
					case ePackageType.MARRY_SCENE_CHANGE:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.MARRY_SCENE_CHANGE,pkg));
						break;
					case ePackageType.HOTSPRING_CMD:
						this.createHotSpringEvent(pkg);
						break;
					case ePackageType.HOTSPRING_ROOM_CREATE:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.HOTSPRING_ROOM_CREATE,pkg));
						break;
					case ePackageType.HOTSPRING_ROOM_ENTER:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.HOTSPRING_ROOM_ENTER,pkg));
						break;
					case ePackageType.HOTSPRING_ROOM_ADD_OR_UPDATE:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.HOTSPRING_ROOM_ADD_OR_UPDATE,pkg));
						break;
					case ePackageType.HOTSPRING_ROOM_REMOVE:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.HOTSPRING_ROOM_REMOVE,pkg));
						break;
					case ePackageType.HOTSPRING_ROOM_LIST_GET:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.HOTSPRING_ROOM_LIST_GET,pkg));
						break;
					case ePackageType.HOTSPRING_ROOM_PLAYER_ADD:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.HOTSPRING_ROOM_PLAYER_ADD,pkg));
						break;
					case ePackageType.HOTSPRING_ROOM_PLAYER_REMOVE:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.HOTSPRING_ROOM_PLAYER_REMOVE,pkg));
						break;
					case ePackageType.HOTSPRING_ROOM_PLAYER_REMOVE_NOTICE:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.HOTSPRING_ROOM_PLAYER_REMOVE_NOTICE,pkg));
						break;
					case ePackageType.HOTSPRING_ROOM_ENTER_CONFIRM:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.HOTSPRING_ROOM_ENTER_CONFIRM,pkg));
						break;
					case ePackageType.GET_TIME_BOX:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.GET_TIME_BOX,pkg));
						break;
					case ePackageType.GET_TIME_BOX_INFO:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.GET_TIME_BOX_INFO,pkg));
						break;
					case ePackageType.ACHIEVEMENT_UPDATE:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.ACHIEVEMENT_UPDATE,pkg));
						break;
					case ePackageType.ACHIEVEMENT_FINISH:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.ACHIEVEMENT_FINISH,pkg));
						break;
					case ePackageType.ACHIEVEMENT_INIT:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.ACHIEVEMENT_INIT,pkg));
						break;
					case ePackageType.ACHIEVEMENTDATA_INIT:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.ACHIEVEMENTDATA_INIT,pkg));
						break;
					case ePackageType.USER_RANK:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.USER_RANK,pkg));
						break;
					case ePackageType.FIGHT_NPC:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.FIGHT_NPC,pkg));
						break;
					case ePackageType.LOTTERY_ALTERNATE_LIST:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.LOTTERY_ALTERNATE_LIST,pkg));
						break;
					case ePackageType.LOTTERY_GET_ITEM:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.LOTTERY_GET_ITEM,pkg));
						break;
					case ePackageType.CADDY_GET_AWARDS:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CADDY_GET_AWARDS,pkg));
						break;
					case ePackageType.CADDY_CONVERTED_ALL:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CADDY_GET_CONVERTED,pkg));
						break;
					case ePackageType.CADDY_EXCHANGE_ALL:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CADDY_GET_EXCHANGEALL,pkg));
						break;
					case ePackageType.CADDY_GET_BADLUCK:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CADDY_GET_BADLUCK,pkg));
						break;
					case ePackageType.LOOKUP_EFFORT:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.LOOKUP_EFFORT,pkg));
						break;
					case ePackageType.LOTTERY_FINISH:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.OFFERPACK_COMPLETE,pkg));
						break;
					case ePackageType.QQTIPS_GET_INFO:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.QQTIPS_GET_INFO,pkg));
						break;
					case ePackageType.EDICTUM_GET_SERVION:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.EDICTUM_GET_VERSION,pkg));
						break;
					case ePackageType.FEEDBACK_REPLY:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.FEEDBACK_REPLY,pkg));
						break;
					case ePackageType.ANSWERBOX_QUESTIN:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.ANSWERBOX_QUESTIN,pkg));
						break;
					case ePackageType.VIP_RENEWAL:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.VIP_IS_OPENED,pkg));
						break;
					case ePackageType.USE_CHANGE_COLOR_SHELL:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.USE_COLOR_SHELL,pkg));
						break;
					case AcademyPackageType.ACADEMY_FATHER:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.APPRENTICE_SYSTEM_ANSWER,pkg));
						break;
					case ePackageType.ITEM_OPENUP:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.ITEM_OPENUP,pkg));
						break;
					case ePackageType.GET_DYNAMIC:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.GET_DYNAMIC,pkg));
						break;
					case ePackageType.USER_GET_GIFTS:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.USER_GET_GIFTS,pkg));
						break;
					case ePackageType.USER_SEND_GIFTS:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.USER_SEND_GIFTS,pkg));
						break;
					case ePackageType.USER_UPDATE_GIFT:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.USER_UPDATE_GIFT,pkg));
						break;
					case ePackageType.WEEKLY_CLICK_CNT:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.WEEKLY_CLICK_CNT,pkg));
						break;
					case ePackageType.USER_RELOAD_GIFT:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.USER_RELOAD_GIFT,pkg));
						break;
					case ePackageType.ACTIVE_PULLDOWN:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.ACTIVE_PULLDOWN,pkg));
						break;
					case ePackageType.CARDS_SOUL:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CARDS_SOUL,pkg));
						break;
					case ePackageType.CARDS_DATA:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CARDS_DATA,pkg));
						break;
					case ePackageType.CARD_RESET:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CARD_RESET,pkg));
						break;
					case ePackageType.CARDS_SLOT:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.GET_CARD,pkg));
						break;
					case ePackageType.GET_PLAYER_CARD:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CARDS_PLAYER_DATA,pkg));
						break;
					case ePackageType.LOAD_RESOURCE:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.LOAD_RESOURCE,pkg));
						break;
					case ePackageType.CHAT_FILTERING_FRIENDS_SHARE:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CHAT_FILTERING_FRIENDS_SHARE,pkg));
						break;
					case ePackageType.LOTTERY_OPEN_BOX:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.LOTTERY_OPNE,pkg));
						break;
					case ePackageType.DAILYRECORD:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.DAILYRECORD,pkg));
						break;
					case ePackageType.TEXP:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.TEXP,pkg));
						break;
					case ePackageType.LITTLEGAME_COMMAND:
						this.createLittleGameEvent(pkg);
						break;
					case ePackageType.LITTLEGAME_ACTIVED:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.LITTLEGAME_ACTIVED,pkg));
						break;
					case ePackageType.USER_LUCKYNUM:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.USER_LUCKYNUM,pkg));
						break;
					case ePackageType.LEFT_GUN_ROULETTE:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.LEFT_GUN_ROULETTE,pkg));
						break;
					case ePackageType.LEFT_GUN_ROULETTE_START:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.LEFT_GUN_ROULETTE_START,pkg));
						break;
					case ePackageType.OPTION_CHANGE:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.OPTION_CHANGE,pkg));
						break;
					case ePackageType.LOTTERY_AWARD:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.LUCKY_LOTTERY,pkg));
						break;
					case ePackageType.CAN_CARD_LOTTERY:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.GOTO_CARD_LOTTERY,pkg));
						break;
					case ePackageType.PET:
						this.handlePetPkg(pkg);
						break;
					case ePackageType.FARM:
						this.handFarmPkg(pkg);
						break;
					case ePackageType.USE_CHANGE_SEX:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CHANGE_SEX,pkg));
						break;
					case ePackageType.WORLDBOSS_CMD:
						this.createWorldBossEvent(pkg);
						break;
					case ePackageType.LUCKSTONE_CONFIG:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.LUCKLYSTONE_ACTIVITY,pkg));
						break;
					case ePackageType.RELOAD_XML:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.RELOAD_XML,pkg));
						break;
					case ePackageType.NEWCHICKENBOX_SYS:
						this.createNewChickenBoxEvent(pkg);
						break;
					case ePackageType.DICE_SYSTEM:
						this.createDiceSystemEvent(pkg);
						break;
					case ePackageType.TOTEM:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.TOTEM,pkg));
						break;
					case ePackageType.NEWCHICKENBOX_SYS:
						this.createNewChickenBoxEvent(pkg);
						break;
					case ePackageType.FIGHT_SPIRIT:
						this.fightSpirit(pkg);
						break;
					case ePackageType.LABYRINTH:
						this.labyrinthPkg(pkg);
						break;
					case ePackageType.LUCKSTONE_RANK_LIMIT:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.LUCKSTONE_RANK_LIMIT,pkg));
						break;
					case ePackageType.RECHARGE:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CUMULATECHARGE_OPEN,pkg));
						break;
					case ePackageType.FIRSTRECHARGE:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.FIRSTRECHARGE_OPEN,pkg));
						break;
					case ePackageType.HONOR_UP_COUNT:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.HONOR_UP_COUNT,pkg));
						break;
					case ePackageType.KING_BLESS_MAIN:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.KING_BLESS_MAIN,pkg));
						break;
					case ePackageType.KING_BLESS_UPDATE_BUFF_DATA:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.KING_BLESS_UPDATE_BUFF_DATA,pkg));
						break;
					case ePackageType.TRUSTEESHIP:
						this.trusteeshipPkg(pkg);
						break;
					case ePackageType.TREASURE_IN:
						this.treasurePkgHandler(pkg);
						break;
					case ePackageType.AREA_INFO_UPDATE:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.AREA_INFO_UPDATE,pkg));
						break;
					case ePackageType.EVERYDAY_ACTIVEPOINT:
						this.dayActivity(pkg);
						break;
					case ePackageType.LATENT_ENERGY:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.LATENT_ENERGY,pkg));
						break;
					case ePackageType.NECKLACE_STRENGTH:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.NECKLACE_STRENGTH,pkg));
						break;
					case ePackageType.CONSORTIA_BATTLE:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CONSORTIA_BATTLE,pkg));
						break;
					case ePackageType.DRAGON_BOAT:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.DRAGON_BOAT,pkg));
						break;
					case ePackageType.REQUEST_FRIENDS_PAY:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.REQUEST_FRIENDS_PAY,pkg));
						break;
					case ePackageType.CAMPBATTLE:
						this.CampBattleHander(pkg);
						break;
					case ePackageType.OLDPLAYER_REGRESS:
						this.oldPlayerRegressHandle(pkg);
						break;
					case ePackageType.FIND_BACK_INCOME:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.Find_Back_Income,pkg));
						break;
					case ePackageType.GROUP_PURCHASE:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.GROUP_PURCHASE,pkg));
						break;
					case ePackageType.UPDATE_LOGIN_FIGHTPOWER:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.UPDATE_LOGIN_FIGHTPOWER,pkg));
						break;
					case ePackageType.SEVEN_DOUBLE:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.SEVEN_DOUBLE_ESCORT,pkg));
						break;
					case ePackageType.SEPARATE_ACTIVITY:
						this.separateActivityHandler(pkg);
						break;
					case ePackageType.MISSION_ENERGY:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.MISSION_ENERGY,pkg));
						break;
					case ePackageType.BAGLOCK_PWD:
						dispatchEvent(new BagLockedEvent(BagLockedEvent.GET_BACK_LOCK_PWD,pkg));
						break;
					case ePackageType.DEL_QUESTION:
						dispatchEvent(new BagLockedEvent(BagLockedEvent.DEL_QUESTION,pkg));
						break;
					case ePackageType.TRANSNATIONALFIGHT_ACTIVED:
						this.transnationalHandle(pkg);
						break;
					case ePackageType.ACTIVITY_SYSTEM:
						this.activitySystem(pkg);
						break;
					case ePackageType.ACTIVITY_PACKAGE:
						this.activityPackageHandler(pkg);
						break;
					case ePackageType.UPDATE_SHOPLIMIT_COUNT:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.UPDATE_SHOPLIMIT_COUNT,pkg));
						break;
					case ePackageType.ACCUMULATIVELOGIN_AWARD:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.ACCUMULATIVELOGIN_AWARD,pkg));
						break;
					case ePackageType.AVATAR_COLLECTION:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.AVATAR_COLLECTION,pkg));
						break;
					case ePackageType.PLAYER_DRESS:
						this.playerDressHandler(pkg);
						break;
					case ePackageType.PEER_ID:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.PEER_ID,pkg));
						break;
					case ePackageType.FLOWER_GIVING:
						this.flowerGivingHandler(pkg);
						break;
					case ePackageType.MAGIC_STONE:
						this.magicStoneHandler(pkg);
						break;
					case ePackageType.CONSUME_RANK:
						dispatchEvent(new ConsumeRankEvent(ConsumeRankEvent.UPDATE,pkg));
						break;
					case ePackageType.HORSE:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.HORSE,pkg));
						break;
					case ePackageType.BOMB_KING:
						this.bombKingHandler(pkg);
						break;
					case ePackageType.COLLECTION_TASK:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.COLLECTION_TASK,pkg));
						break;
					case ePackageType.TOTAL_CHARGE:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.TOTAL_CHARGE,pkg));
						break;
					case ePackageType.FOOD_ACTIVITY:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.FOOD_ACTIVITY,pkg));
						break;
					case ePackageType.FAST_AUCTION_SMALL_BUGLE:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.FAST_AUCTION_BUGLE,pkg));
						break;
					case ePackageType.KING_DIVISION:
						this.kingDivisionHandler(pkg);
						break;
					case ePackageType.SHOP_BUYLIMITEDCOUNT:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.SHOP_BUYLIMITEDCOUNT,pkg));
						break;
					case ePackageType.DEED_MAIN:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.DEED_MAIN,pkg));
						break;
					case ePackageType.DEED_UPDATE_BUFF_DATA:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.DEED_UPDATE_BUFF_DATA,pkg));
						break;
					case ePackageType.MAGPIE_BRIDGE:
						this.magpieBridgeHandler(pkg);
						break;
					case ePackageType.CRYPTBOSS:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CRYPTBOSS,pkg));
						break;
					case ePackageType.WORSHIP_THE_MOON_MID_AUTUMN:
						this.worshipTheMoon(pkg);
						break;
					case ePackageType.RESCUE:
						this.rescueHandler(pkg);
						break;
					case ePackageType.MYSTERY_SHOP:
						this.gypsyShopHander(pkg);
						break;
					case ePackageType.ITEM_ENCHANT:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.ITEM_ENCHANT,pkg));
						break;
					case ePackageType.DROP_MOVIE:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.DROP_GOODS,pkg));
						break;
					case ePackageType.MAGIC_STONE_MONSTER_INFO:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.MAGIC_STONE_MONSTER_INFO,pkg));
						break;
					case ePackageType.HORSERACE:
						dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.HORSERACE_CMD,pkg));
				}
			}
			catch(err:Error)
			{
				SocketManager.Instance.out.sendErrorMsg(err.message + "\r\n" + err.getStackTrace());
			}
		}
		
		private function worshipTheMoon(pkg:PackageIn) : void
		{
			var type:int = pkg.readByte();
			switch(type)
			{
				case WorshipTheMoonPackageType.AWARDS_LIST:
					dispatchEvent(new WorshipTheMoonEvent(WorshipTheMoonEvent.AWARDS_LIST,pkg));
					break;
				case WorshipTheMoonPackageType.FREE_COUNT:
					dispatchEvent(new WorshipTheMoonEvent(WorshipTheMoonEvent.FREE_COUNT,pkg));
					break;
				case WorshipTheMoonPackageType.WORSHIP_THE_MOON:
					dispatchEvent(new WorshipTheMoonEvent(WorshipTheMoonEvent.WORSHIP_THE_MOON,pkg));
					break;
				case WorshipTheMoonPackageType.IS_ACTIVITY_OPEN:
					dispatchEvent(new WorshipTheMoonEvent(WorshipTheMoonEvent.IS_ACTIVITY_OPEN,pkg));
			}
		}
		
		private function magpieBridgeHandler(pkg:PackageIn) : void
		{
			var cmd:int = pkg.readByte();
			switch(cmd)
			{
				case MagpieBridgePackageType.ENTER_MAGPIEBRIDGE:
					dispatchEvent(new MagpieBridgeEvent(MagpieBridgeEvent.ENTER_MAGPIEBRIDGE,pkg));
					break;
				case MagpieBridgePackageType.ROLL_DICE:
					dispatchEvent(new MagpieBridgeEvent(MagpieBridgeEvent.ROLL_DICE,pkg));
					break;
				case MagpieBridgePackageType.BUY_COUNT:
					dispatchEvent(new MagpieBridgeEvent(MagpieBridgeEvent.BUY_COUNT,pkg));
					break;
				case MagpieBridgePackageType.GET_AWARD:
					dispatchEvent(new MagpieBridgeEvent(MagpieBridgeEvent.GET_AWARD,pkg));
					break;
				case MagpieBridgePackageType.UPDATE_PLAYERPOS:
					dispatchEvent(new MagpieBridgeEvent(MagpieBridgeEvent.UPDATE_PLAYERPOS,pkg));
					break;
				case MagpieBridgePackageType.CLOSE_ICON:
					dispatchEvent(new MagpieBridgeEvent(MagpieBridgeEvent.CLOSE_ICON,pkg));
					break;
				case MagpieBridgePackageType.MAGPIE_NUM:
					dispatchEvent(new MagpieBridgeEvent(MagpieBridgeEvent.MAGPIE_NUM,pkg));
					break;
				case MagpieBridgePackageType.OPEN:
					dispatchEvent(new MagpieBridgeEvent(MagpieBridgeEvent.OPEN,pkg));
					break;
				case MagpieBridgePackageType.PLAYMEETANINMATION:
					dispatchEvent(new MagpieBridgeEvent(MagpieBridgeEvent.PLAYMEETANINMATION,pkg));
					break;
				case MagpieBridgePackageType.SET_COUNT:
					dispatchEvent(new MagpieBridgeEvent(MagpieBridgeEvent.SET_COUNT,pkg));
			}
		}
		
		private function gypsyShopHander(pkg:PackageIn) : void
		{
			var cmd:int = pkg.readByte();
			switch(cmd)
			{
				case GypsyShopPackageType.PLAYER_INFO:
					dispatchEvent(new GypsyShopEvent(GypsyShopEvent.GOT_NEW_ITEM_LIST,pkg));
					break;
				case GypsyShopPackageType.BUY:
					dispatchEvent(new GypsyShopEvent(GypsyShopEvent.ON_BUY_RESULT,pkg));
					break;
				case GypsyShopPackageType.RARE_ITEM_INFO:
					dispatchEvent(new GypsyShopEvent(GypsyShopEvent.ON_RARE_ITEM_UPDATED,pkg));
					break;
				case GypsyShopPackageType.OPEN_INFO:
					dispatchEvent(new GypsyShopEvent(GypsyShopEvent.NPC_STATE_CHANGE,pkg));
			}
		}
		
		private function rescueHandler(pkg:PackageIn) : void
		{
			var cmd:int = pkg.readByte();
			switch(cmd)
			{
				case RescueType.IS_OPEN:
					dispatchEvent(new RescueEvent(RescueEvent.IS_OPEN,pkg));
					break;
				case RescueType.FRAME_INFO:
					dispatchEvent(new RescueEvent(RescueEvent.FRAME_INFO,pkg));
					break;
				case RescueType.BUY_ITEM:
					dispatchEvent(new RescueEvent(RescueEvent.BUY_ITEM,pkg));
					break;
				case RescueType.CHALLENGE:
					dispatchEvent(new RescueEvent(RescueEvent.CHALLENGE,pkg));
					break;
				case RescueType.CLEAN_CD:
					dispatchEvent(new RescueEvent(RescueEvent.CLEAN_CD,pkg));
					break;
				case RescueType.FIGHT_RESULT:
					dispatchEvent(new RescueEvent(RescueEvent.FIGHT_RESULT,pkg));
					break;
				case RescueType.ITEM_INFO:
					dispatchEvent(new RescueEvent(RescueEvent.ITEM_INFO,pkg));
			}
		}
		
		private function magicStoneHandler(pkg:PackageIn) : void
		{
			var cmd:int = pkg.readByte();
			switch(cmd)
			{
				case MagicStoneType.MAGIC_STONE_SCORE:
					dispatchEvent(new MagicStoneEvent(MagicStoneEvent.MAGIC_STONE_SCORE,pkg));
					break;
				case MagicStoneType.UPDATE_REMAIN_COUNT:
					dispatchEvent(new MagicStoneEvent(MagicStoneEvent.UPDATE_REMAIN_COUNT,pkg));
			}
		}
		
		private function bombKingHandler(pkg:PackageIn) : void
		{
			var cmd:int = pkg.readByte();
			switch(cmd)
			{
				case BombKingType.STATUE_INFO:
					dispatchEvent(new BombKingEvent(BombKingEvent.STATUE_INFO,pkg));
					break;
				case BombKingType.UPDATE_MAIN_FRAME:
					dispatchEvent(new BombKingEvent(BombKingEvent.UPDATE_MAIN_FRAME,pkg));
					break;
				case BombKingType.BATTLE_LOG:
					dispatchEvent(new BombKingEvent(BombKingEvent.BATTLE_LOG,pkg));
					break;
				case BombKingType.RANK_BY_PAGE:
					dispatchEvent(new BombKingEvent(BombKingEvent.RANK_BY_PAGE,pkg));
					break;
				case BombKingType.UPATE_REQUEST:
					dispatchEvent(new BombKingEvent(BombKingEvent.UPDATE_REQUEST,pkg));
					break;
				case BombKingType.SHOW_TEXT:
					dispatchEvent(new BombKingEvent(BombKingEvent.SHOW_TEXT,pkg));
					break;
				case BombKingType.SHOW_TIP:
					dispatchEvent(new BombKingEvent(BombKingEvent.SHOW_TIP,pkg));
					break;
				case BombKingType.SHOW_FRAME:
					dispatchEvent(new BombKingEvent(BombKingEvent.SHOW_FRAME,pkg));
			}
		}
		
		private function setNewHallInfo(pkg:PackageIn) : void
		{
			var cmd:int = pkg.readByte();
			switch(cmd)
			{
				case NewHallPackageType.PLAYERINFO:
					dispatchEvent(new NewHallEvent(NewHallEvent.PLAYERINFO,pkg));
					break;
				case NewHallPackageType.OTHERPLAYERINFO:
					dispatchEvent(new NewHallEvent(NewHallEvent.OTHERPLAYERINFO,pkg));
					break;
				case NewHallPackageType.PLAYEREXIT:
					dispatchEvent(new NewHallEvent(NewHallEvent.PLAYEREXIT,pkg));
					break;
				case NewHallPackageType.PLAYERMOVE:
					dispatchEvent(new NewHallEvent(NewHallEvent.PLAYERMOVE,pkg));
					break;
				case NewHallPackageType.ADDPLAYE:
					dispatchEvent(new NewHallEvent(NewHallEvent.ADDPLAYE,pkg));
					break;
				case NewHallPackageType.MODIFYDRESS:
					dispatchEvent(new NewHallEvent(NewHallEvent.MODIFYDRESS,pkg));
					break;
				case NewHallPackageType.PLAYERONLINE:
					dispatchEvent(new NewHallEvent(NewHallEvent.PLAYERONLINE,pkg));
					break;
				case NewHallPackageType.PLAYERHID:
					dispatchEvent(new NewHallEvent(NewHallEvent.PLAYERHID,pkg));
					break;
				case NewHallPackageType.UPDATEPLAYERTITLE:
					dispatchEvent(new NewHallEvent(NewHallEvent.UPDATEPLAYERTITLE,pkg));
			}
		}
		
		private function kingDivisionHandler(pkg:PackageIn) : void
		{
			var cmd:int = pkg.readByte();
			switch(cmd)
			{
				case KingDivisionPackageType.ACTIVITY_OPEN:
					dispatchEvent(new KingDivisionEvent(KingDivisionEvent.ACTIVITY_OPEN,pkg));
					break;
				case KingDivisionPackageType.CONSORTIA_MATCH_INFO:
					dispatchEvent(new KingDivisionEvent(KingDivisionEvent.CONSORTIA_MATCH_INFO,pkg));
					break;
				case KingDivisionPackageType.CONSORTIA_MATCH_SCORE:
					dispatchEvent(new KingDivisionEvent(KingDivisionEvent.CONSORTIA_MATCH_SCORE,pkg));
					break;
				case KingDivisionPackageType.CONSORTIA_MATCH_RANK:
					dispatchEvent(new KingDivisionEvent(KingDivisionEvent.CONSORTIA_MATCH_RANK,pkg));
					break;
				case KingDivisionPackageType.CONSORTIA_MATCH_AREA_RANK:
					dispatchEvent(new KingDivisionEvent(KingDivisionEvent.CONSORTIA_MATCH_AREA_RANK,pkg));
					break;
				case KingDivisionPackageType.CONSORTIA_MATCH_AREA_RANK_INFO:
					dispatchEvent(new KingDivisionEvent(KingDivisionEvent.CONSORTIA_MATCH_AREA_RANK_INFO,pkg));
			}
		}
		
		private function flowerGivingHandler(pkg:PackageIn) : void
		{
			var cmd:int = pkg.readByte();
			switch(cmd)
			{
				case FlowerGivingType.GIVE_FLOWER:
					dispatchEvent(new FlowerGivingEvent(FlowerGivingEvent.GIVE_FLOWER,pkg));
					break;
				case FlowerGivingType.FLOWER_FALL:
					dispatchEvent(new FlowerGivingEvent(FlowerGivingEvent.FLOWER_FALL,pkg));
					break;
				case FlowerGivingType.GET_RECORD:
					dispatchEvent(new FlowerGivingEvent(FlowerGivingEvent.GET_RECORD,pkg));
					break;
				case FlowerGivingType.GET_FLOWER_RANK:
					dispatchEvent(new FlowerGivingEvent(FlowerGivingEvent.GET_FLOWER_RANK,pkg));
					break;
				case FlowerGivingType.GET_REWARD:
					dispatchEvent(new FlowerGivingEvent(FlowerGivingEvent.GET_REWARD,pkg));
					break;
				case FlowerGivingType.REWARD_INFO:
					dispatchEvent(new FlowerGivingEvent(FlowerGivingEvent.REWARD_INFO,pkg));
					break;
				case FlowerGivingType.FLOWER_GIVING_OPEN:
					dispatchEvent(new FlowerGivingEvent(FlowerGivingEvent.FLOWER_GIVING_OPEN,pkg));
			}
		}
		
		private function activitySystem(pkg:PackageIn) : void
		{
			var cmd:int = int(pkg.readUnsignedByte());
			if(cmd == 101)
			{
				dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.MAGICSTONE_DOUBLESCORE,pkg,cmd));
			}
			else if(cmd == HorseRacePackageType.HORSERACE_OPEN_CLOSE)
			{
				dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.HORSERACE_OPEN_CLOSE,pkg,cmd));
			}
			else if(cmd > -1 && cmd <= 6)
			{
				dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.PYRAMID_SYSTEM,pkg,cmd));
			}
			else if(cmd >= 7 && cmd <= 13)
			{
				dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.GUILDMEMBERWEEK_SYSTEM,pkg,cmd));
			}
			else if(cmd >= 15 && cmd <= 31)
			{
				dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CHRISTMAS_SYSTEM,pkg,cmd));
			}
			else if(cmd >= 128 && cmd <= 143)
			{
				dispatchEvent(new CatchInsectEvent(CatchInsectEvent.CATCH_INSECT,pkg,cmd));
			}
			else if(cmd >= 48 && cmd <= 57)
			{
				dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.SUPER_WINNER,pkg,cmd));
			}
			else if(cmd >= 86 && cmd <= 88)
			{
				dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.GODS_ROADS,pkg,cmd));
			}
			else if(cmd >= 32 && cmd <= 36)
			{
				dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CATCHBEAST_BEGIN,pkg,cmd));
			}
			else if(cmd >= 37 && cmd <= 45)
			{
				dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.LANTERNRIDDLES_BEGIN,pkg,cmd));
			}
			else if(cmd >= 64 && cmd <= 66)
			{
				dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.LIGHTROAD_SYSTEM,pkg,cmd));
			}
			else if(cmd >= 80 && cmd <= 85)
			{
				dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.SEVENDAYTARGET_GODSROADS,pkg,cmd));
			}
			else if(cmd >= 96 && cmd <= 98)
			{
				dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.SEVENDAYTARGET_NEWPLAYERREWARD,pkg,cmd));
			}
			else if(cmd >= 102 && cmd <= 108)
			{
				dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.TREASUREPUZZLE_SYSTEM,pkg,cmd));
			}
			else if(cmd >= 112 && cmd <= 114)
			{
				dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.WITCHBLESSING_DATA,pkg,cmd));
			}
			else if(cmd >= 74 && cmd <= 76)
			{
				dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.DDPLAY_BEGIN,pkg,cmd));
			}
			else if(cmd == EntertainmentPackageType.BUY_ICON || cmd == EntertainmentPackageType.GET_SCORE)
			{
				dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.ENTERTAINMENT,pkg,cmd));
			}
			else if(cmd >= BoguAdventureType.ACTIVITY_OPEN && cmd <= BoguAdventureType.OUT_BOGUADVENTURE || cmd == BoguAdventureType.FREE_RESET)
			{
				dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.BOGU_ADVENTURE,pkg,cmd));
			}
			else if(cmd == HalloweenType.OPEN || cmd == HalloweenType.ENTER)
			{
				dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.HALLOWEEN,pkg,cmd));
			}
			else if(cmd >= 144 && cmd <= 159)
			{
				dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.TREASURELOST_SYSTEM,pkg,cmd));
			}
			else if(cmd >= 117 && cmd <= 122)
			{
				dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CLOUDBUY,pkg,cmd));
			}
			else if(cmd >= 161 && cmd <= 168)
			{
				dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.NEW_YEAR_RICE,pkg,cmd));
			}
			else if(cmd == ePackageType.VIP_MERRY_DISCOUNT)
			{
				dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.VIP_MERRY_DISCOUNT,pkg,cmd));
			}
		}
		
		private function activityPackageHandler(pkg:PackageIn) : void
		{
			var cmd:int = pkg.readInt();
			if(cmd == GrowthPackageType.GROWTHPACKAGE)
			{
				dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.GROWTHPACKAGE,pkg));
			}
			else if(cmd == ChickActivationType.CHICKACTIVATION)
			{
				dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CHICKACTIVATION_SYSTEM,pkg));
			}
			else if(cmd == ItemActivityGiftType.ITEMACTIVITYGIFT)
			{
				dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.ITEMACTIVITYGIFT_DATA,pkg));
			}
			else if(cmd == MagicHousePackageType.MAGICHOUSE)
			{
				dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.MAGICHOUSE,pkg));
			}
			else if(cmd == ZodiacPackageType.ZODIAC)
			{
				dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.ZODIAC,pkg));
			}
		}
		
		private function CSMTimeBoxHandler(pkg:PackageIn) : void
		{
			dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.GET_CSM_TIME_BOX,pkg));
		}
		
		private function CampBattleHander(pkg:PackageIn) : void
		{
			var cmd:int = pkg.readByte();
			switch(cmd)
			{
				case CampPackageType.ADD_ROLE_LIST:
					dispatchEvent(new CrazyTankSocketEvent(CampPackageType.ADD_ROLE_LIST_EVENT,pkg));
					break;
				case CampPackageType.ADD_MONSTER_LIST:
					dispatchEvent(new CrazyTankSocketEvent(CampPackageType.ADD_MONSTER_LIST_EVENT,pkg));
					break;
				case CampPackageType.INIT_SECEN:
					dispatchEvent(new CrazyTankSocketEvent(CampPackageType.INIT_SECEN_EVENT,pkg));
					break;
				case CampPackageType.ROLE_MOVE:
					dispatchEvent(new CrazyTankSocketEvent(CampPackageType.ROLE_MOVE_EVENT,pkg));
					break;
				case CampPackageType.PLAYER_STATE_CHANGE:
					dispatchEvent(new CrazyTankSocketEvent(CampPackageType.PLAYER_STATE_CHANGE_EVENT,pkg));
					break;
				case CampPackageType.MONSTER_STATE_CHANGE:
					dispatchEvent(new CrazyTankSocketEvent(CampPackageType.MONSTER_STATE_CHANGE_EVENT,pkg));
					break;
				case CampPackageType.REMOVE_ROLE:
					dispatchEvent(new CrazyTankSocketEvent(CampPackageType.REMOVE_ROLE_EVENT,pkg));
					break;
				case CampPackageType.CAPTURE_MAP:
					dispatchEvent(new CrazyTankSocketEvent(CampPackageType.CAPTURE_MAP_EVENT,pkg));
					break;
				case CampPackageType.WIN_COUNT_PTP:
					dispatchEvent(new CrazyTankSocketEvent(CampPackageType.WIN_COUNT_PTP_EVENT,pkg));
					break;
				case CampPackageType.UPDATE_SCORE:
					dispatchEvent(new CrazyTankSocketEvent(CampPackageType.UPDATE_SCORE_EVENT,pkg));
					break;
				case CampPackageType.PER_SCORE_RANK:
					dispatchEvent(new CrazyTankSocketEvent(CampPackageType.PER_SCORE_RANK_EVENT,pkg));
					break;
				case CampPackageType.CAMP_SOCER_RANK:
					dispatchEvent(new CrazyTankSocketEvent(CampPackageType.CAMP_SOCER_RANK_EVENT,pkg));
					break;
				case CampPackageType.ACTION_ISOPEN:
					dispatchEvent(new CrazyTankSocketEvent(CampPackageType.ACTION_ISOPEN_EVENT,pkg));
					break;
				case CampPackageType.DOOR_STATUS:
					dispatchEvent(new CrazyTankSocketEvent(CampPackageType.DOOR_STATUS_EVENT,pkg));
					break;
				case CampPackageType.OUT_CAMPBATTLE:
					dispatchEvent(new CrazyTankSocketEvent(CampPackageType.OUT_CAMPBATTLE_EVENT,pkg));
			}
		}
		
		private function transnationalHandle(pkg:PackageIn) : void
		{
			var cmd:int = pkg.readByte();
			switch(cmd)
			{
				case TransnationalPackageType.OPEN:
					dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.TRANSNATIONALFIGHT_ACTIVED,pkg));
					break;
				case TransnationalPackageType.OVER:
					dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.TRANSNATIONALfIGHT_OVER));
					break;
				case TransnationalPackageType.UPDATE_PLAYER:
					dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.TRANSNATIONALFIGHT_PLAYERINFO,pkg));
					break;
				case TransnationalPackageType.UPDATE_VALUE_REP:
					dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.TRANSNATIONALSCORE_UPDATA,pkg));
			}
		}
		
		private function treasurePkgHandler(pkg:PackageIn) : void
		{
			var cmd:int = pkg.readInt();
			switch(cmd)
			{
				case TreasurePackageType.IN_TREASURE:
					dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.ENTER_TREASURE,pkg));
					break;
				case TreasurePackageType.ARRANGE_FRIEND_FARM:
					dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.ARRANGE_FRIEND_FARM,pkg));
					break;
				case TreasurePackageType.END_TREASURE:
					dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.END_TREASURE,pkg));
					break;
				case TreasurePackageType.DIG:
					dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.DIG,pkg));
					break;
				case TreasurePackageType.LOGIN_ABOUT_TREASURE:
					dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.LOGIN_ABOUT_TREASURE,pkg));
					break;
				case TreasurePackageType.BEREPAIR_FRIEND_FARM_SEND:
					dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.BEREPAIR_FRIEND_FARM_SEND,pkg));
					break;
				case TreasurePackageType.START_GAME:
					dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.START_GAME_TREASURE,pkg));
			}
		}
		
		private function battleGoundHander(pkg:PackageIn) : void
		{
			var cmd:int = pkg.readByte();
			switch(cmd)
			{
				case BattleGoundPackageType.OPEN:
					dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.BATTLE_OPEN,pkg));
					break;
				case BattleGoundPackageType.OVER:
					dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.BATTLE_OVER,pkg));
					break;
				case BattleGoundPackageType.UPDATE_VALUE_REQ:
					dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.BATTLEDATA_UPDATA,pkg));
					break;
				case BattleGoundPackageType.UPDATE_VALUE_REP:
					dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.BATTLEDATA_UPDATA_REALTIME,pkg));
					break;
				case BattleGoundPackageType.UPDATE_PLAYER_DATA:
					dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.PLAYER_DATA_UPDATA,pkg));
			}
		}
		
		private function recharge(pkg:PackageIn) : void
		{
			var cmd:int = pkg.readByte();
			switch(cmd)
			{
				case RechargePackageType.CUMULATECHARGE_DATA:
					dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CUMULATECHARGE_DATA,pkg));
					break;
				case RechargePackageType.CUMULATECHARGE_OPEN:
					dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CUMULATECHARGE_OPEN,pkg));
					break;
				case RechargePackageType.CUMULATECHARGE_OVER:
					dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CUMULATECHARGE_OVER,pkg));
					break;
				case RechargePackageType.GET_SPREE:
					dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.GET_SPREE,pkg));
			}
		}
		
		private function trusteeshipPkg(pkg:PackageIn) : void
		{
			var cmd:int = pkg.readByte();
			switch(cmd)
			{
				case TrusteeshipPackageType.START:
					dispatchEvent(new CrazyTankSocketEvent(TrusteeshipPackageType.START_EVENT,pkg));
					break;
				case TrusteeshipPackageType.BUY_SPIRIT:
					dispatchEvent(new CrazyTankSocketEvent(TrusteeshipPackageType.BUY_SPIRIT_EVENT,pkg));
			}
		}
		
		private function fightSpirit(pkg:PackageIn) : void
		{
			var cmd:int = pkg.readByte();
			switch(cmd)
			{
				case FightSpiritPackageType.PLAYER_FIGHT_SPIRIT_UP:
					dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.PLAYER_FIGHT_SPIRIT_UP,pkg));
					break;
				case FightSpiritPackageType.FIGHT_SPIRIT_INIT:
					dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.FIGHT_SPIRIT_INIT,pkg));
			}
		}
		
		private function labyrinthPkg(pkg:PackageIn) : void
		{
			var cmd:int = pkg.readByte();
			switch(cmd)
			{
				case LabyrinthPackageType.REQUEST_UPDATE:
					dispatchEvent(new CrazyTankSocketEvent(LabyrinthPackageType.REQUEST_UPDATE_EVENT,pkg));
					break;
				case LabyrinthPackageType.PUSH_CLEAN_OUT_INFO:
					dispatchEvent(new CrazyTankSocketEvent(LabyrinthPackageType.PUSH_CLEAN_OUT_INFO_EVENT,pkg));
					break;
				case LabyrinthPackageType.CLEAN_OUT:
					dispatchEvent(new CrazyTankSocketEvent(LabyrinthPackageType.CLEAN_OUT_EVENT,pkg));
					break;
				case LabyrinthPackageType.TRY_AGAIN:
					dispatchEvent(new CrazyTankSocketEvent(LabyrinthPackageType.TRY_AGAIN_EVENT,pkg));
			}
		}
		
		private function handFarmPkg(pkg:PackageIn) : void
		{
			var cmd:int = pkg.readByte();
			switch(cmd)
			{
				case FarmPackageType.PAY_FIELD:
					dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.PAY_FIELD,pkg));
					break;
				case FarmPackageType.GAIN_FIELD:
					dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.GAIN_FIELD,pkg));
					break;
				case FarmPackageType.FRUSH_FIELD:
					dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.FRUSH_FIELD,pkg));
					break;
				case FarmPackageType.ENTER_FARM:
					dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.ENTER_FARM,pkg));
					break;
				case FarmPackageType.GROW_FIELD:
					dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.SEEDING,pkg));
					break;
				case FarmPackageType.COMPOSE_FOOD:
					dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.COMPOSE_FOOD,pkg));
					break;
				case FarmPackageType.ACCELERATE_FIELD:
					dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.DO_MATURE,pkg));
					break;
				case FarmPackageType.HELPER_SWITCH_FIELD:
					dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.HELPER_SWITCH,pkg));
					break;
				case FarmPackageType.KILLCROP_FIELD:
					dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.KILL_CROP,pkg));
					break;
				case FarmPackageType.HELPER_PAY_FIELD:
					dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.HELPER_PAY,pkg));
					break;
				case FarmPackageType.EXIT_FARM:
					dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.PLAYER_EXIT_FARM,pkg));
					break;
				case FarmPackageType.FARM_LAND_INFO:
					dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.FARM_LAND_INFO,pkg));
					break;
				case FarmPackageType.FARM_POULTYRLEVEL:
					dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.FARM_POULTYRLEVEL,pkg));
					break;
				case FarmPackageType.FARM_UPGRADEINITTREE:
					dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.FARM_UPGRADEINITTREE,pkg));
					break;
				case FarmPackageType.FARM_WATER:
					dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.FARM_WATER,pkg));
					break;
				case FarmPackageType.FARM_CONDENSER:
					dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.FARM_CONDENSER,pkg));
					break;
				case FarmPackageType.FARM_POULTYRFEED:
					dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.FARM_POULTYRFEED,pkg));
			}
		}
		
		private function kitUser(msg:String) : void
		{
			this._socket.close();
			if(msg.indexOf(LanguageMgr.GetTranslation("tank.manager.SocketManager.copyRight")) != -1)
			{
				LoaderSavingManager.clearFiles("*.png");
			}
			LeavePageManager.forcedToLoginPath(msg);
		}
		
		private function errorAlert(msg:String) : void
		{
			var alert:BaseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),msg,"","",true,false,false,LayerManager.BLCAK_BLOCKGOUND);
			alert.addEventListener(FrameEvent.RESPONSE,this.__onAlertClose);
			alert.moveEnable = false;
		}
		
		private function __onAlertClose(event:FrameEvent) : void
		{
			SoundManager.instance.play("008");
			event.currentTarget.removeEventListener(FrameEvent.RESPONSE,this.__onAlertClose);
			if(ExternalInterface.available && PathManager.solveAllowPopupFavorite())
			{
				if(ExternalInterface.available && PathManager.solveAllowPopupFavorite())
				{
					if(PlayerManager.Instance.Self.IsFirst <= 1)
					{
						ExternalInterface.call("setFavorite",PathManager.solveLogin(),StatisticManager.siteName,"3");
					}
					else
					{
						ExternalInterface.call("setFavorite",PathManager.solveLogin(),StatisticManager.siteName,"1");
					}
				}
			}
			LeavePageManager.leaveToLoginPath();
			ObjectUtils.disposeObject(event.currentTarget);
		}
		
		private function cleanLocalFile(msg:String) : void
		{
			this._socket.close();
			LoaderSavingManager.clearFiles("*.png");
			this.errorAlert(msg);
		}
		
		private function createEliteGameEvent(pkg:PackageIn) : void
		{
			var cmd:int = int(pkg.readUnsignedByte());
			switch(cmd)
			{
				case EliteGamePackageType.ELITE_MATCH_TYPE:
					dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.ELITE_MATCH_TYPE,pkg));
					break;
				case EliteGamePackageType.ELITE_MATCH_RANK_START:
					dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.ELITE_MATCH_RANK_START,pkg));
					break;
				case EliteGamePackageType.ELITE_MATCH_PLAYER_RANK:
					dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.ELITE_MATCH_PLAYER_RANK,pkg));
					break;
				case EliteGamePackageType.ELITE_MATCH_RANK_DETAIL:
					dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.ELITE_MATCH_RANK_DETAIL,pkg));
			}
		}
		
		private function createIMEvent(pkg:PackageIn) : void
		{
			var cmd:int = int(pkg.readUnsignedByte());
			switch(cmd)
			{
				case IMPackageType.FRIEND_ADD:
					dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.FRIEND_ADD,pkg));
					break;
				case IMPackageType.FRIEND_REMOVE:
					dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.FRIEND_REMOVE,pkg));
					break;
				case IMPackageType.FRIEND_UPDATE:
					dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.FRIEND_UPDATE,pkg));
					break;
				case IMPackageType.FRIEND_STATE:
					dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.FRIEND_STATE,pkg));
					break;
				case IMPackageType.FRIEND_RESPONSE:
					dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.FRIEND_RESPONSE,pkg));
					break;
				case IMPackageType.ONS_EQUIP:
					dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.ONS_EQUIP,pkg));
					break;
				case IMPackageType.SAME_CITY_FRIEND:
					dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.SAME_CITY_FRIEND,pkg));
					break;
				case IMPackageType.ADD_CUSTOM_FRIENDS:
					dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.ADD_CUSTOM_FRIENDS,pkg));
					break;
				case IMPackageType.ONE_ON_ONE_TALK:
					dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.ONE_ON_ONE_TALK,pkg));
			}
		}
		
		private function createChurchEvent(pkg:PackageIn) : void
		{
			var cmd:int = pkg.readByte();
			var event:CrazyTankSocketEvent = null;
			switch(cmd)
			{
				case ChurchPackageType.MOVE:
					event = new CrazyTankSocketEvent(CrazyTankSocketEvent.MOVE,pkg);
					break;
				case ChurchPackageType.HYMENEAL:
					event = new CrazyTankSocketEvent(CrazyTankSocketEvent.HYMENEAL,pkg);
					break;
				case ChurchPackageType.CONTINUATION:
					event = new CrazyTankSocketEvent(CrazyTankSocketEvent.CONTINUATION,pkg);
					break;
				case ChurchPackageType.INVITE:
					event = new CrazyTankSocketEvent(CrazyTankSocketEvent.INVITE,pkg);
					break;
				case ChurchPackageType.USEFIRECRACKERS:
					event = new CrazyTankSocketEvent(CrazyTankSocketEvent.USEFIRECRACKERS,pkg);
					break;
				case ChurchPackageType.HYMENEAL_STOP:
					event = new CrazyTankSocketEvent(CrazyTankSocketEvent.HYMENEAL_STOP,pkg);
					break;
				case ChurchPackageType.GUNSALUTE:
					event = new CrazyTankSocketEvent(CrazyTankSocketEvent.GUNSALUTE,pkg);
					break;
				case ChurchPackageType.MARRYROOMSENDGIFT:
					event = new CrazyTankSocketEvent(CrazyTankSocketEvent.MARRYROOMSENDGIFT,pkg);
			}
			if(Boolean(event))
			{
				dispatchEvent(event);
			}
		}
		
		private function buriedEvents(pkg:PackageIn) : void
		{
			var command:int = pkg.readByte();
			switch(command)
			{
				case SearchGoodsPackageType.PlayNowPosition:
					dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.PlayNowPosition,pkg));
					break;
				case SearchGoodsPackageType.BackToStart:
					dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.BackToStart,pkg));
					break;
				case SearchGoodsPackageType.QuitTakeCard:
					dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.QuitTakeCard,pkg));
					break;
				case SearchGoodsPackageType.BeforeStep:
					dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.BeforeStep,pkg));
					break;
				case SearchGoodsPackageType.FlopCard:
					dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.FlopCard,pkg));
					break;
				case SearchGoodsPackageType.GetGoods:
					dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.GetGoods,pkg));
					break;
				case SearchGoodsPackageType.PlayerEnter:
					dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.PlayerEnter,pkg));
					break;
				case SearchGoodsPackageType.PlayerRollDice:
					dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.PlayerRollDice,pkg));
					break;
				case SearchGoodsPackageType.PlayerUpgradeStartLevel:
					dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.PlayerUpgradeStartLevel,pkg));
					break;
				case SearchGoodsPackageType.ReachTheEnd:
					dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.ReachTheEnd,pkg));
					break;
				case SearchGoodsPackageType.TakeCardResponse:
					dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.TakeCardResponse,pkg));
					break;
				case SearchGoodsPackageType.RemoveEvent:
					dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.RemoveEvent,pkg));
					break;
				case SearchGoodsPackageType.OneStep:
					dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.OneStep,pkg));
			}
		}
		
		private function createLittleGameEvent(pkg:PackageIn) : void
		{
			var event:LittleGameSocketEvent = null;
			var command:int = pkg.readByte();
			if(command != LittleGamePackageInType.MOVE)
			{
			}
			switch(command)
			{
				case LittleGamePackageInType.WORLD_LIST:
					event = new LittleGameSocketEvent(LittleGameSocketEvent.WORLD_LIST,pkg);
					break;
				case LittleGamePackageInType.START_LOAD:
					event = new LittleGameSocketEvent(LittleGameSocketEvent.START_LOAD,pkg);
					dispatchEvent(event);
					return;
				case LittleGamePackageInType.ADD_SPRITE:
					event = new LittleGameSocketEvent(LittleGameSocketEvent.ADD_SPRITE,pkg);
					break;
				case LittleGamePackageInType.REMOVE_SPRITE:
					event = new LittleGameSocketEvent(LittleGameSocketEvent.REMOVE_SPRITE,pkg);
					break;
				case LittleGamePackageInType.GAME_START:
					LittleGamePacketQueue.Instance.reset();
					LittleGamePacketQueue.Instance.setLifeTime(pkg.extend2);
					LittleGamePacketQueue.Instance.startup();
					event = new LittleGameSocketEvent(LittleGameSocketEvent.GAME_START,pkg);
					break;
				case LittleGamePackageInType.MOVE:
					event = new LittleGameSocketEvent(LittleGameSocketEvent.MOVE,pkg);
					break;
				case LittleGamePackageInType.UPDATE_POS:
					event = new LittleGameSocketEvent(LittleGameSocketEvent.UPDATE_POS,pkg);
					break;
				case LittleGamePackageInType.ADD_OBJECT:
					event = new LittleGameSocketEvent(LittleGameSocketEvent.ADD_OBJECT,pkg);
					break;
				case LittleGamePackageInType.UPDATELIVINGSPROPERTY:
					event = new LittleGameSocketEvent(LittleGameSocketEvent.UPDATELIVINGSPROPERTY,pkg);
					break;
				case LittleGamePackageInType.DoAction:
					event = new LittleGameSocketEvent(LittleGameSocketEvent.DOACTION,pkg);
					break;
				case LittleGamePackageInType.DoMovie:
					event = new LittleGameSocketEvent(LittleGameSocketEvent.DOMOVIE,pkg);
					break;
				case LittleGamePackageInType.GETSCORE:
					event = new LittleGameSocketEvent(LittleGameSocketEvent.GETSCORE,pkg);
					break;
				case LittleGamePackageInType.INVOKE_OBJECT:
					event = new LittleGameSocketEvent(LittleGameSocketEvent.INVOKE_OBJECT,pkg);
					break;
				case LittleGamePackageInType.SETCLOCK:
					event = new LittleGameSocketEvent(LittleGameSocketEvent.SETCLOCK,pkg);
					break;
				case LittleGamePackageInType.PONG:
					event = new LittleGameSocketEvent(LittleGameSocketEvent.PONG,pkg);
					break;
				case LittleGamePackageInType.NET_DELAY:
					event = new LittleGameSocketEvent(LittleGameSocketEvent.NET_DELAY,pkg);
					break;
				case LittleGamePackageInType.KICK_PLAYE:
					event = new LittleGameSocketEvent(LittleGameSocketEvent.KICK_PLAYE,pkg);
			}
			if(Boolean(event))
			{
				LittleGamePacketQueue.Instance.addQueue(event);
			}
		}
		
		private function createHotSpringEvent(pkg:PackageIn) : void
		{
			var cmd:int = pkg.readByte();
			var event:CrazyTankSocketEvent = null;
			switch(cmd)
			{
				case HotSpringPackageType.TARGET_POINT:
					event = new CrazyTankSocketEvent(CrazyTankSocketEvent.HOTSPRING_ROOM_PLAYER_TARGET_POINT,pkg);
					break;
				case HotSpringPackageType.HOTSPRING_ROOM_RENEWAL_FEE:
					dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.HOTSPRING_ROOM_RENEWAL_FEE,pkg));
					break;
				case HotSpringPackageType.HOTSPRING_ROOM_INVITE:
					event = new CrazyTankSocketEvent(CrazyTankSocketEvent.HOTSPRING_ROOM_INVITE,pkg);
					break;
				case HotSpringPackageType.HOTSPRING_ROOM_TIME_UPDATE:
					event = new CrazyTankSocketEvent(CrazyTankSocketEvent.HOTSPRING_ROOM_TIME_UPDATE,pkg);
					break;
				case HotSpringPackageType.HOTSPRING_ROOM_PLAYER_CONTINUE:
					event = new CrazyTankSocketEvent(CrazyTankSocketEvent.HOTSPRING_ROOM_PLAYER_CONTINUE,pkg);
			}
			if(Boolean(event))
			{
				dispatchEvent(event);
			}
		}
		
		private function createConsortiaEvent(pkg:PackageIn) : void
		{
			var cmd:int = int(pkg.readUnsignedByte());
			switch(cmd)
			{
				case ConsortiaPackageType.CONSORTIA_TRYIN:
					dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CONSORTIA_TRYIN,pkg));
					break;
				case ConsortiaPackageType.CONSORTIA_CREATE:
					dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CONSORTIA_CREATE,pkg));
					break;
				case ConsortiaPackageType.CONSORTIA_DISBAND:
					dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CONSORTIA_DISBAND,pkg));
					break;
				case ConsortiaPackageType.CONSORTIA_RENEGADE:
					dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CONSORTIA_RENEGADE,pkg));
					break;
				case ConsortiaPackageType.CONSORTIA_TRYIN_PASS:
					dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CONSORTIA_TRYIN_PASS,pkg));
					break;
				case ConsortiaPackageType.CONSORTIA_TRYIN_DEL:
					dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CONSORTIA_TRYIN_DEL,pkg));
					break;
				case ConsortiaPackageType.CONSORTIA_RICHES_OFFER:
					dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CONSORTIA_RICHES_OFFER,pkg));
					break;
				case ConsortiaPackageType.CONSORTIA_APPLY_STATE:
					dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CONSORTIA_APPLY_STATE,pkg));
					break;
				case ConsortiaPackageType.CONSORTIA_DUTY_DELETE:
					dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CONSORTIA_DUTY_DELETE,pkg));
					break;
				case ConsortiaPackageType.CONSORTIA_DUTY_UPDATE:
					dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CONSORTIA_DUTY_UPDATE,pkg));
					break;
				case ConsortiaPackageType.CONSORTIA_INVITE:
					dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CONSORTIA_INVITE,pkg));
					break;
				case ConsortiaPackageType.CONSORTIA_INVITE_PASS:
					dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CONSORTIA_INVITE_PASS,pkg));
					break;
				case ConsortiaPackageType.CONSORTIA_DESCRIPTION_UPDATE:
					dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CONSORTIA_DESCRIPTION_UPDATE,pkg));
					break;
				case ConsortiaPackageType.CONSORTIA_PLACARD_UPDATE:
					dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CONSORTIA_PLACARD_UPDATE,pkg));
					break;
				case ConsortiaPackageType.CONSORTIA_BANCHAT_UPDATE:
					dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CONSORTIA_BANCHAT_UPDATE,pkg));
					break;
				case ConsortiaPackageType.CONSORTIA_USER_REMARK_UPDATE:
					dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CONSORTIA_USER_REMARK_UPDATE,pkg));
					break;
				case ConsortiaPackageType.CONSORTIA_USER_GRADE_UPDATE:
					dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CONSORTIA_USER_GRADE_UPDATE,pkg));
					break;
				case ConsortiaPackageType.CONSORTIA_CHAIRMAN_CHAHGE:
					dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CONSORTIA_CHAIRMAN_CHAHGE,pkg));
					break;
				case ConsortiaPackageType.CONSORTIA_CHAT:
					dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CONSORTIA_CHAT,pkg));
					break;
				case ConsortiaPackageType.CONSORTIA_LEVEL_UP:
					dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CONSORTIA_LEVEL_UP,pkg));
					break;
				case ConsortiaPackageType.CONSORTIA_TASK_RELEASE:
					dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CONSORTIA_TASK_RELEASE,pkg));
					break;
				case ConsortiaPackageType.CONSORTIA_EQUIP_CONTROL:
					dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CONSORTIA_EQUIP_CONTROL,pkg));
					break;
				case ConsortiaPackageType.POLL_CANDIDATE:
					dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.POLL_CANDIDATE,pkg));
					break;
				case ConsortiaPackageType.SKILL_SOCKET:
					dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.SKILL_SOCKET,pkg));
					break;
				case ConsortiaPackageType.CONSORTION_MAIL:
					dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CONSORTION_MAIL,pkg));
					break;
				case ConsortiaPackageType.BUY_BADGE:
					dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.BUY_BADGE,pkg));
					break;
				case ConsortiaPackageType.BOSS_OPEN_CLOSE:
					dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CONSORTIA_BOSS_OPEN_CLOSE,pkg));
					break;
				case ConsortiaPackageType.CONSORTIA_BOSS_INFO:
					dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CONSORTIA_BOSS_INFO,pkg));
			}
		}
		
		private function createGameRoomEvent(pkg:PackageIn) : void
		{
			var cmd:int = int(pkg.readUnsignedByte());
			switch(cmd)
			{
				case GameRoomPackageType.GAME_ROOM_CREATE:
					QueueManager.addQueue(new CrazyTankSocketEvent(CrazyTankSocketEvent.GAME_ROOM_CREATE,pkg));
					break;
				case GameRoomPackageType.GAME_ROOM_LOGIN:
					QueueManager.addQueue(new CrazyTankSocketEvent(CrazyTankSocketEvent.GAME_ROOM_LOGIN,pkg));
					break;
				case GameRoomPackageType.GAME_ROOM_SETUP_CHANGE:
					QueueManager.addQueue(new CrazyTankSocketEvent(CrazyTankSocketEvent.GAME_ROOM_SETUP_CHANGE,pkg));
					break;
				case GameRoomPackageType.GAME_ROOM_KICK:
					QueueManager.addQueue(new CrazyTankSocketEvent(CrazyTankSocketEvent.GAME_ROOM_KICK,pkg));
					break;
				case GameRoomPackageType.GAME_ROOM_ADDPLAYER:
					QueueManager.addQueue(new CrazyTankSocketEvent(CrazyTankSocketEvent.GAME_PLAYER_ENTER,pkg));
					break;
				case GameRoomPackageType.SINGLE_ROOM_BEGIN:
					QueueManager.addQueue(new CrazyTankSocketEvent(CrazyTankSocketEvent.SINGLE_ROOM_BEGIN,pkg));
					break;
				case GameRoomPackageType.GAME_TEAM:
					QueueManager.addQueue(new CrazyTankSocketEvent(CrazyTankSocketEvent.GAME_TEAM,pkg));
					break;
				case GameRoomPackageType.GAME_ROOM_UPDATE_PLACE:
					QueueManager.addQueue(new CrazyTankSocketEvent(CrazyTankSocketEvent.GAME_ROOM_UPDATE_PLACE,pkg));
					break;
				case GameRoomPackageType.GAME_PICKUP_CANCEL:
					QueueManager.addQueue(new CrazyTankSocketEvent(CrazyTankSocketEvent.GAME_AWIT_CANCEL,pkg));
					break;
				case GameRoomPackageType.GAME_PICKUP_STYLE:
					QueueManager.addQueue(new CrazyTankSocketEvent(CrazyTankSocketEvent.GMAE_STYLE_RECV,pkg));
					break;
				case GameRoomPackageType.GAME_PICKUP_WAIT:
					QueueManager.addQueue(new CrazyTankSocketEvent(CrazyTankSocketEvent.GAME_WAIT_RECV,pkg));
					break;
				case GameRoomPackageType.ROOM_PASS:
					dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.ROOMLIST_PASS,pkg));
					break;
				case GameRoomPackageType.GAME_PLAYER_STATE_CHANGE:
					QueueManager.addQueue(new CrazyTankSocketEvent(CrazyTankSocketEvent.GAME_PLAYER_STATE_CHANGE,pkg));
					break;
				case GameRoomPackageType.ROOMLIST_UPDATE:
					dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.GAME_ROOMLIST_UPDATE,pkg));
					break;
				case GameRoomPackageType.GAME_ROOM_REMOVEPLAYER:
					QueueManager.addQueue(new CrazyTankSocketEvent(CrazyTankSocketEvent.GAME_PLAYER_EXIT,pkg));
					break;
				case GameRoomPackageType.GAME_ROOM_FULL:
					dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.GAME_ROOM_FULL));
					break;
				case GameRoomPackageType.FAST_INVITE_CALL:
					dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.FAST_INVITE_CALL,pkg));
					break;
				case GameRoomPackageType.GAME_ENERGY_NOT_ENOUGH:
					dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.GAME_ENERGY_NOT_ENOUGH,pkg));
					break;
				case GameRoomPackageType.LAST_MISSION_FOR_WARRIORSARENA:
					dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.LAST_MISSION_FOR_WARRIORSARENA,pkg));
					break;
				case GameRoomPackageType.PASSED_WARRIORSARENA_10:
					dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.PASSED_WARRIORSARENA_10,pkg));
					break;
				case GameRoomPackageType.No_WARRIORSARENA_TICKET:
					dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.No_WARRIORSARENA_TICKET,pkg));
			}
		}
		
		private function createGameEvent(pkg:PackageIn) : void
		{
			var cmd:int = int(pkg.readUnsignedByte());
			var event:CrazyTankSocketEvent = null;
			switch(cmd)
			{
				case CrazyTankPackageType.GEM_GLOW:
					event = new CrazyTankSocketEvent(CrazyTankSocketEvent.GEM_GLOW,pkg);
					break;
				case CrazyTankPackageType.SEND_PICTURE:
					event = new CrazyTankSocketEvent(CrazyTankSocketEvent.UPDATE_BUFF,pkg);
					break;
				case CrazyTankPackageType.GAME_MISSION_PREPARE:
					event = new CrazyTankSocketEvent(CrazyTankSocketEvent.GAME_MISSION_PREPARE,pkg);
					break;
				case CrazyTankPackageType.UPDATE_BOARD_STATE:
					event = new CrazyTankSocketEvent(CrazyTankSocketEvent.UPDATE_BOARD_STATE,pkg);
					break;
				case CrazyTankPackageType.ADD_MAP_THING:
					event = new CrazyTankSocketEvent(CrazyTankSocketEvent.ADD_MAP_THING,pkg);
					break;
				case CrazyTankPackageType.BARRIER_INFO:
					event = new CrazyTankSocketEvent(CrazyTankSocketEvent.BARRIER_INFO,pkg);
					break;
				case CrazyTankPackageType.GAME_CREATE:
					QueueManager.addQueue(new CrazyTankSocketEvent(CrazyTankSocketEvent.GAME_CREATE,pkg));
					break;
				case CrazyTankPackageType.START_GAME:
					QueueManager.addQueue(new CrazyTankSocketEvent(CrazyTankSocketEvent.GAME_START,pkg));
					break;
				case CrazyTankPackageType.WANNA_LEADER:
					event = new CrazyTankSocketEvent(CrazyTankSocketEvent.GAME_WANNA_LEADER,pkg);
					break;
				case CrazyTankPackageType.FIGHTFOOTBALLTIME_TAKEOUTALL:
					event = new CrazyTankSocketEvent(CrazyTankSocketEvent.FIGHTFOOTBALLTIME_TAKEOUTALL,pkg);
					break;
				case CrazyTankPackageType.GAME_LOAD:
					QueueManager.addQueue(new CrazyTankSocketEvent(CrazyTankSocketEvent.GAME_LOAD,pkg));
					break;
				case CrazyTankPackageType.GAME_MISSION_INFO:
					QueueManager.addQueue(new CrazyTankSocketEvent(CrazyTankSocketEvent.GAME_MISSION_INFO,pkg));
					break;
				case CrazyTankPackageType.GAME_OVER:
					QueueManager.addQueue(new CrazyTankSocketEvent(CrazyTankSocketEvent.GAME_OVER,pkg));
					break;
				case CrazyTankPackageType.MISSION_OVE:
					QueueManager.addQueue(new CrazyTankSocketEvent(CrazyTankSocketEvent.MISSION_OVE,pkg));
					break;
				case CrazyTankPackageType.GAME_ALL_MISSION_OVER:
					QueueManager.addQueue(new CrazyTankSocketEvent(CrazyTankSocketEvent.GAME_ALL_MISSION_OVER,pkg));
					break;
				case CrazyTankPackageType.IS_LAST_MISSION:
					QueueManager.addQueue(new CrazyTankSocketEvent(CrazyTankSocketEvent.IS_LAST_MISSION,pkg));
					break;
				case CrazyTankPackageType.DIRECTION:
					event = new CrazyTankSocketEvent(CrazyTankSocketEvent.DIRECTION_CHANGED,pkg);
					break;
				case CrazyTankPackageType.GUN_ROTATION:
					event = new CrazyTankSocketEvent(CrazyTankSocketEvent.PLAYER_GUN_ANGLE,pkg);
					break;
				case CrazyTankPackageType.FIRE:
					event = new CrazyTankSocketEvent(CrazyTankSocketEvent.PLAYER_SHOOT,pkg);
					break;
				case CrazyTankPackageType.SYNC_LIFETIME:
					QueueManager.setLifeTime(pkg.readInt());
					break;
				case CrazyTankPackageType.MOVESTART:
					event = new CrazyTankSocketEvent(CrazyTankSocketEvent.PLAYER_START_MOVE,pkg);
					break;
				case CrazyTankPackageType.MOVESTOP:
					event = new CrazyTankSocketEvent(CrazyTankSocketEvent.PLAYER_STOP_MOVE,pkg);
					break;
				case CrazyTankPackageType.TURN:
					event = new CrazyTankSocketEvent(CrazyTankSocketEvent.PLAYER_CHANGE,pkg);
					break;
				case CrazyTankPackageType.HEALTH:
					event = new CrazyTankSocketEvent(CrazyTankSocketEvent.PLAYER_BLOOD,pkg);
					break;
				case CrazyTankPackageType.FROST:
					event = new CrazyTankSocketEvent(CrazyTankSocketEvent.PLAYER_FROST,pkg);
					break;
				case CrazyTankPackageType.NONOLE:
					event = new CrazyTankSocketEvent(CrazyTankSocketEvent.PLAYER_NONOLE,pkg);
					break;
				case CrazyTankPackageType.CHANGE_STATE:
					event = new CrazyTankSocketEvent(CrazyTankSocketEvent.CHANGE_STATE,pkg);
					break;
				case CrazyTankPackageType.PLAYER_PROPERTY:
					event = new CrazyTankSocketEvent(CrazyTankSocketEvent.PLAYER_PROPERTY,pkg);
					break;
				case CrazyTankPackageType.INVINCIBLY:
					event = new CrazyTankSocketEvent(CrazyTankSocketEvent.PLAYER_INVINCIBLY,pkg);
					break;
				case CrazyTankPackageType.VANE:
					event = new CrazyTankSocketEvent(CrazyTankSocketEvent.PLAYER_VANE,pkg);
					break;
				case CrazyTankPackageType.HIDE:
					event = new CrazyTankSocketEvent(CrazyTankSocketEvent.PLAYER_HIDE,pkg);
					break;
				case CrazyTankPackageType.CARRY:
					break;
				case CrazyTankPackageType.BECKON:
					event = new CrazyTankSocketEvent(CrazyTankSocketEvent.PLAYER_BECKON,pkg);
					break;
				case CrazyTankPackageType.FIGHTPROP:
					event = new CrazyTankSocketEvent(CrazyTankSocketEvent.PLAYER_FIGHT_PROP,pkg);
					break;
				case CrazyTankPackageType.STUNT:
					event = new CrazyTankSocketEvent(CrazyTankSocketEvent.PLAYER_STUNT,pkg);
					break;
				case CrazyTankPackageType.PROP:
					event = new CrazyTankSocketEvent(CrazyTankSocketEvent.PLAYER_PROP,pkg);
					break;
				case CrazyTankPackageType.DANDER:
					event = new CrazyTankSocketEvent(CrazyTankSocketEvent.PLAYER_DANDER,pkg);
					break;
				case CrazyTankPackageType.REDUCE_DANDER:
					event = new CrazyTankSocketEvent(CrazyTankSocketEvent.REDUCE_DANDER,pkg);
					break;
				case CrazyTankPackageType.LOAD:
					event = new CrazyTankSocketEvent(CrazyTankSocketEvent.LOAD,pkg);
					break;
				case CrazyTankPackageType.ADDATTACK:
					event = new CrazyTankSocketEvent(CrazyTankSocketEvent.PLAYER_ADDATTACK,pkg);
					break;
				case CrazyTankPackageType.ADDBALL:
					event = new CrazyTankSocketEvent(CrazyTankSocketEvent.PLAYER_ADDBAL,pkg);
					break;
				case CrazyTankPackageType.SHOOTSTRAIGHT:
					event = new CrazyTankSocketEvent(CrazyTankSocketEvent.SHOOTSTRAIGHT,pkg);
					break;
				case CrazyTankPackageType.SUICIDE:
					event = new CrazyTankSocketEvent(CrazyTankSocketEvent.SUICIDE,pkg);
					break;
				case CrazyTankPackageType.FIRE_TAG:
					event = new CrazyTankSocketEvent(CrazyTankSocketEvent.PLAYER_SHOOT_TAG,pkg);
					break;
				case CrazyTankPackageType.CHANGE_BALL:
					event = new CrazyTankSocketEvent(CrazyTankSocketEvent.CHANGE_BALL,pkg);
					break;
				case CrazyTankPackageType.PICK:
					event = new CrazyTankSocketEvent(CrazyTankSocketEvent.PLAYER_PICK_BOX,pkg);
					break;
				case CrazyTankPackageType.BLAST:
					event = new CrazyTankSocketEvent(CrazyTankSocketEvent.BOMB_DIE,pkg);
					break;
				case CrazyTankPackageType.BEAT:
					event = new CrazyTankSocketEvent(CrazyTankSocketEvent.PLAYER_BEAT,pkg);
					break;
				case CrazyTankPackageType.DISAPPEAR:
					event = new CrazyTankSocketEvent(CrazyTankSocketEvent.BOX_DISAPPEAR,pkg);
					break;
				case CrazyTankPackageType.TAKE_CARD:
					event = new CrazyTankSocketEvent(CrazyTankSocketEvent.GAME_TAKE_OUT,pkg);
					break;
				case CrazyTankPackageType.ADD_LIVING:
					event = new CrazyTankSocketEvent(CrazyTankSocketEvent.ADD_LIVING,pkg);
					break;
				case CrazyTankPackageType.PLAY_MOVIE:
					event = new CrazyTankSocketEvent(CrazyTankSocketEvent.PLAY_MOVIE,pkg);
					break;
				case CrazyTankPackageType.PLAY_SOUND:
					event = new CrazyTankSocketEvent(CrazyTankSocketEvent.PLAY_SOUND,pkg);
					break;
				case CrazyTankPackageType.LOAD_RESOURCE:
					event = new CrazyTankSocketEvent(CrazyTankSocketEvent.LOAD_RESOURCE,pkg);
					break;
				case CrazyTankPackageType.ADD_MAP_THINGS:
					event = new CrazyTankSocketEvent(CrazyTankSocketEvent.ADD_MAP_THINGS,pkg);
					break;
				case CrazyTankPackageType.LIVING_BEAT:
					event = new CrazyTankSocketEvent(CrazyTankSocketEvent.LIVING_BEAT,pkg);
					break;
				case CrazyTankPackageType.LIVING_FALLING:
					event = new CrazyTankSocketEvent(CrazyTankSocketEvent.LIVING_FALLING,pkg);
					break;
				case CrazyTankPackageType.LIVING_JUMP:
					event = new CrazyTankSocketEvent(CrazyTankSocketEvent.LIVING_JUMP,pkg);
					break;
				case CrazyTankPackageType.LIVING_MOVETO:
					event = new CrazyTankSocketEvent(CrazyTankSocketEvent.LIVING_MOVETO,pkg);
					break;
				case CrazyTankPackageType.LIVING_SAY:
					event = new CrazyTankSocketEvent(CrazyTankSocketEvent.LIVING_SAY,pkg);
					break;
				case CrazyTankPackageType.LIVING_RANGEATTACKING:
					event = new CrazyTankSocketEvent(CrazyTankSocketEvent.LIVING_RANGEATTACKING,pkg);
					break;
				case CrazyTankPackageType.SHOW_CARDS:
					event = new CrazyTankSocketEvent(CrazyTankSocketEvent.SHOW_CARDS,pkg);
					break;
				case CrazyTankPackageType.FOCUS_ON_OBJECT:
					event = new CrazyTankSocketEvent(CrazyTankSocketEvent.FOCUS_ON_OBJECT,pkg);
					break;
				case CrazyTankPackageType.GAME_MISSION_TRY_AGAIN:
					event = new CrazyTankSocketEvent(CrazyTankSocketEvent.GAME_MISSION_TRY_AGAIN,pkg);
					break;
				case CrazyTankPackageType.PLAY_INFO_IN_GAME:
					event = new CrazyTankSocketEvent(CrazyTankSocketEvent.PLAY_INFO_IN_GAME,pkg);
					QueueManager.setLifeTime(pkg.extend2);
					break;
				case CrazyTankPackageType.GAME_ROOM_INFO:
					event = new CrazyTankSocketEvent(CrazyTankSocketEvent.GAME_ROOM_INFO,pkg);
					break;
				case CrazyTankPackageType.ADD_TIP_LAYER:
					event = new CrazyTankSocketEvent(CrazyTankSocketEvent.ADD_TIP_LAYER,pkg);
					break;
				case CrazyTankPackageType.PLAY_ASIDE:
					event = new CrazyTankSocketEvent(CrazyTankSocketEvent.PLAY_ASIDE,pkg);
					break;
				case CrazyTankPackageType.FORBID_DRAG:
					event = new CrazyTankSocketEvent(CrazyTankSocketEvent.FORBID_DRAG,pkg);
					break;
				case CrazyTankPackageType.TOP_LAYER:
					event = new CrazyTankSocketEvent(CrazyTankSocketEvent.TOP_LAYER,pkg);
					break;
				case CrazyTankPackageType.CONTROL_BGM:
					event = new CrazyTankSocketEvent(CrazyTankSocketEvent.CONTROL_BGM,pkg);
					break;
				case CrazyTankPackageType.USE_DEPUTY_WEAPON:
					event = new CrazyTankSocketEvent(CrazyTankSocketEvent.USE_DEPUTY_WEAPON,pkg);
					break;
				case CrazyTankPackageType.FIGHT_LIB_INFO_CHANGE:
					event = new CrazyTankSocketEvent(CrazyTankSocketEvent.FIGHT_LIB_INFO_CHANGE,pkg);
					break;
				case CrazyTankPackageType.POPUP_QUESTION_FRAME:
					event = new CrazyTankSocketEvent(CrazyTankSocketEvent.POPUP_QUESTION_FRAME,pkg);
					break;
				case CrazyTankPackageType.PASS_STORY:
					event = new CrazyTankSocketEvent(CrazyTankSocketEvent.SHOW_PASS_STORY_BTN,pkg);
					break;
				case CrazyTankPackageType.LIVING_BOLTMOVE:
					QueueManager.addQueue(new CrazyTankSocketEvent(CrazyTankSocketEvent.LIVING_BOLTMOVE,pkg));
					break;
				case CrazyTankPackageType.CHANGE_TARGET:
					event = new CrazyTankSocketEvent(CrazyTankSocketEvent.CHANGE_TARGET,pkg);
					break;
				case CrazyTankPackageType.LIVING_SHOW_BLOOD:
					event = new CrazyTankSocketEvent(CrazyTankSocketEvent.LIVING_SHOW_BLOOD,pkg);
					break;
				case CrazyTankPackageType.TEMP_STYLE:
					event = new CrazyTankSocketEvent(CrazyTankSocketEvent.TEMP_STYLE,pkg);
					break;
				case CrazyTankPackageType.ACTION_MAPPING:
					event = new CrazyTankSocketEvent(CrazyTankSocketEvent.ACTION_MAPPING,pkg);
					break;
				case CrazyTankPackageType.FIGHT_ACHIEVEMENT:
					event = new CrazyTankSocketEvent(CrazyTankSocketEvent.FIGHT_ACHIEVEMENT,pkg);
					break;
				case CrazyTankPackageType.APPLYSKILL:
					event = new CrazyTankSocketEvent(CrazyTankSocketEvent.APPLYSKILL,pkg);
					break;
				case CrazyTankPackageType.REMOVESKILL:
					event = new CrazyTankSocketEvent(CrazyTankSocketEvent.REMOVESKILL,pkg);
					break;
				case CrazyTankPackageType.MAXFORCE_CHANGED:
					event = new CrazyTankSocketEvent(CrazyTankSocketEvent.CHANGEMAXFORCE,pkg);
					break;
				case CrazyTankPackageType.WIND_PIC:
					event = new CrazyTankSocketEvent(CrazyTankSocketEvent.WINDPIC,pkg);
					break;
				case CrazyTankPackageType.SYSMESSAGE:
					event = new CrazyTankSocketEvent(CrazyTankSocketEvent.GAMESYSMESSAGE,pkg);
					break;
				case CrazyTankPackageType.LIVING_CHAGEANGLE:
					event = new CrazyTankSocketEvent(CrazyTankSocketEvent.LIVING_CHAGEANGLE,pkg);
					break;
				case CrazyTankPackageType.PET_SKILL:
					event = new CrazyTankSocketEvent(CrazyTankSocketEvent.USE_PET_SKILL,pkg);
					break;
				case CrazyTankPackageType.PET_BUFF:
					event = new CrazyTankSocketEvent(CrazyTankSocketEvent.PET_BUFF,pkg);
					break;
				case CrazyTankPackageType.PET_BEAT:
					event = new CrazyTankSocketEvent(CrazyTankSocketEvent.PET_BEAT,pkg);
					break;
				case CrazyTankPackageType.PET_SKILL_CD:
					event = new CrazyTankSocketEvent(CrazyTankSocketEvent.PET_SKILL_CD,pkg);
					break;
				case CrazyTankPackageType.ADD_NEW_PLAYER:
					event = new CrazyTankSocketEvent(CrazyTankSocketEvent.ADD_NEW_PLAYER,pkg);
					break;
				case CrazyTankPackageType.ADD_TERRACE:
					event = new CrazyTankSocketEvent(CrazyTankSocketEvent.ADD_TERRACE,pkg);
					break;
				case CrazyTankPackageType.WISHOFDD:
					event = new CrazyTankSocketEvent(CrazyTankSocketEvent.WISHOFDD,pkg);
					break;
				case CrazyTankPackageType.PICK_BOX:
					event = new CrazyTankSocketEvent(CrazyTankSocketEvent.PICK_BOX,pkg);
					break;
				case CrazyTankPackageType.SELECT_OBJECT:
					event = new CrazyTankSocketEvent(CrazyTankSocketEvent.SELECT_OBJECT,pkg);
					break;
				case CrazyTankPackageType.COLOR_CHANGE:
					event = new CrazyTankSocketEvent(CrazyTankSocketEvent.GAME_IN_COLOR_CHANGE,pkg);
					break;
				case CrazyTankPackageType.GAME_TRUSTEESHIP:
					event = new CrazyTankSocketEvent(CrazyTankSocketEvent.GAME_TRUSTEESHIP,pkg);
					break;
				case CrazyTankPackageType.SINGLEBATTLE_STARTMATCH:
					event = new CrazyTankSocketEvent(CrazyTankSocketEvent.SINGLEBATTLE_STARTMATCH,pkg);
					break;
				case CrazyTankPackageType.REVIVE:
					event = new CrazyTankSocketEvent(CrazyTankSocketEvent.GAME_REVIVE,pkg);
					break;
				case CrazyTankPackageType.FIGHT_STATUS:
					event = new CrazyTankSocketEvent(CrazyTankSocketEvent.FIGHT_STATUS,pkg);
					break;
				case CrazyTankPackageType.SKIPNEXT:
					event = new CrazyTankSocketEvent(CrazyTankSocketEvent.SKIPNEXT,pkg);
					break;
				case CrazyTankPackageType.CLEAR_DEBUFF:
					event = new CrazyTankSocketEvent(CrazyTankSocketEvent.CLEAR_DEBUFF,pkg);
					break;
				case CrazyTankPackageType.ADD_ANIMATION:
					event = new CrazyTankSocketEvent(CrazyTankSocketEvent.ADD_ANIMATION,pkg);
					break;
				case CrazyTankPackageType.SINGBATTLE_FORCED_EXIT:
					event = new CrazyTankSocketEvent(CrazyTankSocketEvent.SINGBATTLE_FORCED_EXIT,pkg);
					break;
				case CrazyTankPackageType.ROUND_ONE_END:
					event = new CrazyTankSocketEvent(CrazyTankSocketEvent.ROUND_ONE_END,pkg);
					break;
				case CrazyTankPackageType.SKILL_INFO_INIT:
					event = new CrazyTankSocketEvent(CrazyTankSocketEvent.SKILL_INFO_INIT,pkg);
					break;
				case CrazyTankPackageType.RESCUE_ITEM_INFO:
					event = new CrazyTankSocketEvent(CrazyTankSocketEvent.RESCUE_ITEM_INFO,pkg);
					break;
				case CrazyTankPackageType.RESCUE_KING_BLESS:
					event = new CrazyTankSocketEvent(CrazyTankSocketEvent.RESCUE_KING_BLESS,pkg);
			}
			if(Boolean(event))
			{
				QueueManager.addQueue(event);
			}
		}
		
		private function handlePetPkg(pkg:PackageIn) : void
		{
			var cmd:int = int(pkg.readUnsignedByte());
			switch(cmd)
			{
				case CrazyTankPackageType.UPDATE_PET:
					dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.UPDATE_PET,pkg));
					break;
				case CrazyTankPackageType.ADD_PET_EQUIP:
					dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.ADD_PET_EQUIP,pkg));
					break;
				case CrazyTankPackageType.DEL_PET_EQUIP:
					dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.DEL_PET_EQUIP,pkg));
					break;
				case CrazyTankPackageType.REFRESH_PET:
					dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.REFRESH_PET,pkg));
					break;
				case CrazyTankPackageType.ADD_PET:
					dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.ADD_PET,pkg));
					break;
				case CrazyTankPackageType.ADD_PET_EQUIP:
					dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.ADD_PET_EQUIP,pkg));
					break;
				case FarmPackageType.BUY_PET_EXP_ITEM:
					dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.BUY_PET_EXP_ITEM,pkg));
					break;
				case CrazyTankPackageType.PET_RISINGSTAR:
					dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.PET_RISINGSTAR,pkg));
					break;
				case CrazyTankPackageType.PET_EVOLUTION:
					dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.PET_EVOLUTION,pkg));
					break;
				case CrazyTankPackageType.PET_FORMINFO:
					dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.PET_FORMINFO,pkg));
					break;
				case CrazyTankPackageType.PET_FOLLOW:
					dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.PET_FOLLOW,pkg));
					break;
				case CrazyTankPackageType.PET_WAKE:
					dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.PET_WAKE,pkg));
					break;
				case CrazyTankPackageType.EAT_PETS:
					dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.PET_EAT,pkg));
			}
		}
		
		private function createDiceSystemEvent(pkg:PackageIn) : void
		{
			var cmd:int = pkg.readByte();
			var event:CrazyTankSocketEvent = null;
			switch(cmd)
			{
				case 1:
					event = new CrazyTankSocketEvent(CrazyTankSocketEvent.DICE_ACTIVE_OPEN,pkg);
					break;
				case 2:
					event = new CrazyTankSocketEvent(CrazyTankSocketEvent.DICE_ACTIVE_CLOSE,pkg);
					break;
				case 3:
					event = new CrazyTankSocketEvent(CrazyTankSocketEvent.DICE_RECEIVE_DATA,pkg);
					break;
				case 4:
					event = new CrazyTankSocketEvent(CrazyTankSocketEvent.DICE_RECEIVE_RESULT,pkg);
			}
			if(Boolean(event))
			{
				dispatchEvent(event);
			}
		}
		
		private function createWorldBossEvent(pkg:PackageIn) : void
		{
			var cmd:int = pkg.readByte();
			var event:CrazyTankSocketEvent = null;
			switch(cmd)
			{
				case WorldBossPackageType.OPEN:
					event = new CrazyTankSocketEvent(CrazyTankSocketEvent.WORLDBOSS_INIT,pkg);
					break;
				case WorldBossPackageType.OVER:
					event = new CrazyTankSocketEvent(CrazyTankSocketEvent.WORLDBOSS_OVER,pkg);
					break;
				case WorldBossPackageType.CANENTER:
					event = new CrazyTankSocketEvent(CrazyTankSocketEvent.WORLDBOSS_ENTER,pkg);
					break;
				case WorldBossPackageType.ENTER:
					event = new CrazyTankSocketEvent(CrazyTankSocketEvent.WORLDBOSS_ROOM,pkg);
					break;
				case WorldBossPackageType.MOVE:
					event = new CrazyTankSocketEvent(CrazyTankSocketEvent.WORLDBOSS_MOVE,pkg);
					break;
				case WorldBossPackageType.WORLDBOSS_EXIT:
					event = new CrazyTankSocketEvent(CrazyTankSocketEvent.WORLDBOSS_EXIT,pkg);
					break;
				case WorldBossPackageType.WORLDBOSS_PLAYERSTAUTSUPDATE:
					event = new CrazyTankSocketEvent(CrazyTankSocketEvent.WORLDBOSS_PLAYERSTAUTSUPDATE,pkg);
					break;
				case WorldBossPackageType.WORLDBOSS_BLOOD_UPDATE:
					event = new CrazyTankSocketEvent(CrazyTankSocketEvent.WORLDBOSS_BLOOD_UPDATE,pkg);
					break;
				case WorldBossPackageType.WORLDBOSS_FIGHTOVER:
					event = new CrazyTankSocketEvent(CrazyTankSocketEvent.WORLDBOSS_FIGHTOVER,pkg);
					break;
				case WorldBossPackageType.WORLDBOSS_ROOM_CLOSE:
					event = new CrazyTankSocketEvent(CrazyTankSocketEvent.WORLDBOSS_ROOMCLOSE,pkg);
					break;
				case WorldBossPackageType.WORLDBOSS_PLAYER_REVIVE:
					event = new CrazyTankSocketEvent(CrazyTankSocketEvent.WORLDBOSS_PLAYERREVIVE,pkg);
					break;
				case WorldBossPackageType.WORLDBOSS_RANKING:
					event = new CrazyTankSocketEvent(CrazyTankSocketEvent.WORLDBOSS_RANKING,pkg);
					break;
				case WorldBossPackageType.WORLDBOSS_BUYBUFF:
					dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.UPDATE_BUFF_LEVEL,pkg));
					break;
				case WorldBossPackageType.WORLDBOSS_PRIVATE_INFO:
					event = new CrazyTankSocketEvent(CrazyTankSocketEvent.WORLDBOSS_PRIVATE_INFO,pkg);
					break;
				case WorldBossPackageType.ASSISTANT:
					event = new CrazyTankSocketEvent(CrazyTankSocketEvent.WORLDBOSS_ASSISTANT,pkg);
					break;
				case WorldBossPackageType.PlayerFightAssistant:
					event = new CrazyTankSocketEvent(CrazyTankSocketEvent.WORLDBOSS_PLAYERFIGHTASSIATANT,pkg);
			}
			if(Boolean(event))
			{
				dispatchEvent(event);
			}
		}
		
		private function handleBeadPkg(pPackageIn:PackageIn) : void
		{
			var cmd:int = pPackageIn.readByte();
			switch(cmd)
			{
				case CrazyTankPackageType.RUNE_SENDINFO_TOCLIENT:
					dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.BEAD_HOLE_INFO,pPackageIn));
					break;
				case CrazyTankPackageType.RUNE_OPENPACKAGE:
					dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.BEAD_OPEN_PACKAGE,pPackageIn));
			}
		}
		
		private function dayActivity(pkg:PackageIn) : void
		{
			var cmd:int = pkg.readByte();
			switch(cmd)
			{
				case ActivityPackageType.USEMONEYPOINT_COMPLETE:
					dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.USEMONEYPOINT_COMPLETE,pkg));
					break;
				case ActivityPackageType.GETACTIVEPOINT_REWARD:
					dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.GETACTIVEPOINT_REWARD,pkg));
					break;
				case ActivityPackageType.EVERYDAYACTIVEPOINT_DATA:
					dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.EVERYDAYACTIVEPOINT_DATA,pkg));
					break;
				case ActivityPackageType.EVERYDAYACTIVEPOINT_CHANGE:
					dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.EVERYDAYACTIVEPOINT_CHANGE,pkg));
					break;
				case ActivityPackageType.ADD_ACTIVITY_DATA_CHANGE:
					dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.ADD_ACTIVITY_DATA_CHANGE,pkg));
					break;
				case ActivityPackageType.GET_EXPBLESSED_DATA:
					dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.GET_EXPBLESSED_DATA,pkg));
			}
		}
		
		private function createNewChickenBoxEvent(pkg:PackageIn) : void
		{
			var cmd:int = pkg.readInt();
			var event:CrazyTankSocketEvent = null;
			switch(cmd)
			{
				case NewChickenBoxPackageType.CHICKENBOXOPEN:
					event = new CrazyTankSocketEvent(CrazyTankSocketEvent.NEWCHICKENBOX_OPEN,pkg);
					break;
				case NewChickenBoxPackageType.CHICKENBOXCLOSE:
					event = new CrazyTankSocketEvent(CrazyTankSocketEvent.NEWCHICKENBOX_CLOSE,pkg);
					break;
				case NewChickenBoxPackageType.GETITEMLIST:
					event = new CrazyTankSocketEvent(CrazyTankSocketEvent.GET_NEWCHICKENBOX_LIST,pkg);
					break;
				case NewChickenBoxPackageType.CANCLICKCARD:
					event = new CrazyTankSocketEvent(CrazyTankSocketEvent.CANCLICKCARDENABLE,pkg);
					break;
				case NewChickenBoxPackageType.TACKOVERCARD:
					event = new CrazyTankSocketEvent(CrazyTankSocketEvent.NEWCHICKENBOX_OPEN_CARD,pkg);
					break;
				case NewChickenBoxPackageType.EAGLEEYE:
					event = new CrazyTankSocketEvent(CrazyTankSocketEvent.NEWCHICKENBOX_OPEN_EYE,pkg);
					break;
				case NewChickenBoxPackageType.OVERSHOWITEMS:
					event = new CrazyTankSocketEvent(CrazyTankSocketEvent.OVERSHOWITEMS,pkg);
					break;
				case NewChickenBoxPackageType.ACTIVITY_OPEN:
					event = new CrazyTankSocketEvent(CrazyTankSocketEvent.LUCKYSTAR_OPEN,pkg);
					break;
				case NewChickenBoxPackageType.ACTIVITY_END:
					event = new CrazyTankSocketEvent(CrazyTankSocketEvent.LUCKYSTAR_END,pkg);
					break;
				case NewChickenBoxPackageType.ALL_GOODS_INFO:
					event = new CrazyTankSocketEvent(CrazyTankSocketEvent.LUCKYSTAR_ALLGOODS,pkg);
					break;
				case NewChickenBoxPackageType.REWARD_RECORD:
					event = new CrazyTankSocketEvent(CrazyTankSocketEvent.LUCKYSTAR_RECORD,pkg);
					break;
				case NewChickenBoxPackageType.GOODS_INFO:
					event = new CrazyTankSocketEvent(CrazyTankSocketEvent.LUCKYSTAR_GOODSINFO,pkg);
					break;
				case NewChickenBoxPackageType.PLAY_REWARD_INFO:
					event = new CrazyTankSocketEvent(CrazyTankSocketEvent.LUCKYSTAR_REWARDINFO,pkg);
					break;
				case NewChickenBoxPackageType.AWARD_RANK:
					event = new CrazyTankSocketEvent(CrazyTankSocketEvent.LUCKYSTAR_AWARDRANK,pkg);
			}
			if(Boolean(event))
			{
				dispatchEvent(event);
			}
		}
		
		private function oldPlayerRegressHandle(pkg:PackageIn) : void
		{
			var cmd:int = pkg.readByte();
			switch(cmd)
			{
				case RegressPackageType.REGRESS_PACKS:
					dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.REGRESS_PACKS,pkg));
					break;
				case RegressPackageType.REGRESS_CALL:
					dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.REGRESS_CALLAPPLY,pkg));
					break;
				case RegressPackageType.REGRESS_CHECK:
					dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.REGRESS_CHECK,pkg));
					break;
				case RegressPackageType.REGRESS_APPLYPACKS:
					dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.REGRESS_APPLYPACKS,pkg));
					break;
				case RegressPackageType.REGRESS_REVCPACKS:
					dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.REGRESS_RECVPACKS,pkg));
					break;
				case RegressPackageType.REGRESS_APPLY_ENABLE:
					dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.REGRESS_APPLY_ENABLE,pkg));
					break;
				case RegressPackageType.REGRESS_GET_TICKET:
					dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.REGRESS_GET_TICKET,pkg));
					break;
				case RegressPackageType.REGRESS_GET_TICKETINFO:
					dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.REGRESS_GET_TICKETINFO,pkg));
					break;
				case RegressPackageType.REGRESS_UPDATE_INTEGRAL:
					dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.REGRESS_UPDATE_INTEGRAL,pkg));
			}
		}
		
		private function separateActivityHandler(pkg:PackageIn) : void
		{
			var cmd:int = pkg.readByte();
			switch(cmd)
			{
				case CrazyTankPackageType.INIT_TREASURE:
					dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.INIT_TREASURE,pkg));
					break;
				case CrazyTankPackageType.PAY_FOR_HUNTING:
					dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.PAY_FOR_HUNTING,pkg));
					break;
				case CrazyTankPackageType.HUNTING_BY_SCORE:
					dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.HUNTING_BY_SCORE,pkg));
					break;
				case CrazyTankPackageType.CONVERT_SCORE:
					dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.CONVERT_SCORE,pkg));
					break;
				case CrazyTankPackageType.GET_MYSTERIOUS_DATA:
					dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.GET_MYSTERIOUS_DATA,pkg));
					break;
				case CrazyTankPackageType.DAWN_LOTTERY:
					dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.DAWN_LOTTERY,pkg));
			}
		}
		
		private function setRingStationInfo(pkg:PackageIn) : void
		{
			var cmd:int = pkg.readByte();
			switch(cmd)
			{
				case RingStationPackageType.RINGSTATION_VIEWINFO:
					dispatchEvent(new RingStationEvent(RingStationEvent.RINGSTATION_VIEWINFO,pkg));
					break;
				case RingStationPackageType.RINGSTATION_BUYCOUNTORTIME:
					dispatchEvent(new RingStationEvent(RingStationEvent.RINGSTATION_BUYCOUNTORTIME,pkg));
					break;
				case RingStationPackageType.RINGSTATION_ARMORY:
					dispatchEvent(new RingStationEvent(RingStationEvent.RINGSTATION_ARMORY,pkg));
					break;
				case RingStationPackageType.RINGSTATION_NEWBATTLEFIELD:
					dispatchEvent(new RingStationEvent(RingStationEvent.RINGSTATION_NEWBATTLEFIELD,pkg));
					break;
				case RingStationPackageType.RINGSTATION_FIGHTFLAG:
					dispatchEvent(new RingStationEvent(RingStationEvent.RINGSTATION_FIGHTFLAG,pkg));
					break;
				case RingStationPackageType.LANDERSAWARD_RECEIVE:
					dispatchEvent(new RingStationEvent(RingStationEvent.LANDERSAWARD_RECEIVE,pkg));
					break;
				case RingStationPackageType.DUNGEON_UPDATEEXP:
					dispatchEvent(new RingStationEvent(RingStationEvent.DUNGEON_UPDATEEXP,pkg));
			}
		}
		
		private function playerDressHandler(pkg:PackageIn) : void
		{
			var cmd:int = pkg.readByte();
			switch(cmd)
			{
				case PlayerDressType.CURRENT_MODEL:
					dispatchEvent(new PlayerDressEvent(PlayerDressEvent.CURRENT_MODEL,pkg));
					break;
				case PlayerDressType.GET_DRESS_MODEL:
					dispatchEvent(new PlayerDressEvent(PlayerDressEvent.GET_DRESS_MODEL,pkg));
					break;
				case PlayerDressType.LOCK_DRESSBAG:
					dispatchEvent(new PlayerDressEvent(PlayerDressEvent.LOCK_DRESSBAG,pkg));
			}
		}
		
		private function treasureHuntingHandle(pkg:PackageIn) : void
		{
			var cmd:int = pkg.readByte();
			switch(cmd)
			{
				case CrazyTankPackageType.INIT_TREASURE:
					dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.INIT_TREASURE,pkg));
					break;
				case CrazyTankPackageType.PAY_FOR_HUNTING:
					dispatchEvent(new CrazyTankSocketEvent(CrazyTankSocketEvent.PAY_FOR_HUNTING,pkg));
			}
		}
	}
}

