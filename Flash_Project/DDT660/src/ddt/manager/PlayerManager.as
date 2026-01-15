package ddt.manager
{
   import GodSyah.SyahManager;
   import bagAndInfo.BagAndInfoManager;
   import bagAndInfo.callPropData.CallPropDataAnalyer;
   import bagAndInfo.cell.BagCell;
   import bagAndInfo.energyData.EnergyDataAnalyzer;
   import baglocked.BagLockedController;
   import beadSystem.data.BeadEvent;
   import beadSystem.model.BeadModel;
   import calendar.CalendarManager;
   import cardSystem.data.CardInfo;
   import cityWide.CityWideEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import consortion.ConsortionModelControl;
   import ddt.bagStore.BagStore;
   import ddt.data.AccountInfo;
   import ddt.data.AreaInfo;
   import ddt.data.BagInfo;
   import ddt.data.BuffInfo;
   import ddt.data.CMFriendInfo;
   import ddt.data.CheckCodeData;
   import ddt.data.EquipType;
   import ddt.data.PathInfo;
   import ddt.data.analyze.FriendListAnalyzer;
   import ddt.data.analyze.MyAcademyPlayersAnalyze;
   import ddt.data.analyze.RecentContactsAnalyze;
   import ddt.data.club.ClubInfo;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.player.FriendListPlayer;
   import ddt.data.player.PlayerInfo;
   import ddt.data.player.PlayerPropertyType;
   import ddt.data.player.PlayerState;
   import ddt.data.player.SelfInfo;
   import ddt.events.BagEvent;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.events.PlayerPropertyEvent;
   import ddt.states.StateType;
   import ddt.view.CheckCodeFrame;
   import ddt.view.caddyII.CaddyModel;
   import ddt.view.caddyII.reader.AwardsInfo;
   import ddt.view.chat.ChatData;
   import ddtBuried.BuriedEvent;
   import ddtBuried.BuriedManager;
   import fightFootballTime.manager.FightFootballTimeManager;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.TimerEvent;
   import flash.utils.ByteArray;
   import flash.utils.Timer;
   import flashP2P.FlashP2PManager;
   import game.GameManager;
   import gemstone.info.GemstListInfo;
   import gemstone.info.GemstonInitInfo;
   import giftSystem.GiftController;
   import giftSystem.data.MyGiftCellInfo;
   import im.AddCommunityFriend;
   import im.IMController;
   import im.IMEvent;
   import im.info.CustomInfo;
   import kingBless.KingBlessManager;
   import magicStone.data.MagicStoneInfo;
   import mainbutton.MainButtnController;
   import pet.date.PetEquipData;
   import pet.date.PetInfo;
   import pet.date.PetSkill;
   import petsBag.controller.PetBagController;
   import powerUp.PowerUpMovieManager;
   import ringStation.event.RingStationEvent;
   import road7th.comm.PackageIn;
   import road7th.data.DictionaryData;
   import road7th.data.DictionaryEvent;
   import road7th.utils.BitmapReader;
   import room.RoomManager;
   import roomList.PassInputFrame;
   import totem.TotemManager;
   import trainer.controller.SystemOpenPromptManager;
   import treasure.model.TreasureModel;
   
   public class PlayerManager extends EventDispatcher
   {
      
      private static var _instance:PlayerManager;
      
      public static const FRIEND_STATE_CHANGED:String = "friendStateChanged";
      
      public static const FRIENDLIST_COMPLETE:String = "friendListComplete";
      
      public static const RECENT_CONTAST_COMPLETE:String = "recentContactsComplete";
      
      public static const CIVIL_SELFINFO_CHANGE:String = "civilselfinfochange";
      
      public static const VIP_STATE_CHANGE:String = "VIPStateChange";
      
      public static const GIFT_INFO_CHANGE:String = "giftInfoChange";
      
      public static const SELF_GIFT_INFO_CHANGE:String = "selfGiftInfoChange";
      
      public static const NEW_GIFT_UPDATE:String = "newGiftUPDATE";
      
      public static const NEW_GIFT_ADD:String = "newGiftAdd";
      
      public static const FARM_BAG_UPDATE:String = "farmDataUpdate";
      
      public static const UPDATE_PLAYER_PROPERTY:String = "updatePlayerState";
      
      public static const UPDATE_PET:String = "updatePet";
      
      public static const UPDATEENERGY:String = "updateEnergy";
      
      public static var isShowPHP:Boolean = false;
      
      public static const CUSTOM_MAX:int = 10;
      
      public static var SelfStudyEnergy:Boolean = true;
      
      private var _recentContacts:DictionaryData;
      
      public var fightFootballStyle:String;
      
      public var customList:Vector.<CustomInfo>;
      
      private var _friendList:DictionaryData;
      
      private var _cmFriendList:DictionaryData;
      
      private var _blackList:DictionaryData;
      
      private var _clubPlays:DictionaryData;
      
      private var _tempList:DictionaryData;
      
      private var _mailTempList:DictionaryData;
      
      private var _myAcademyPlayers:DictionaryData;
      
      private var _sameCityList:Array;
      
      public var energyData:Object;
      
      public var callPropData:Object;
      
      private var _timer1:Timer;
      
      private var _timer2:Timer;
      
      private var _fightPower:int;
      
      private var _isReportGameProfile:Boolean;
      
      public var merryActivity:Boolean = false;
      
      private var _playerEquipCategaryIdArr:Array = [1,2,3,4,5,6,7,8,9,13,14,15,16,17,19,40];
      
      private var _self:SelfInfo;
      
      public var SelfConsortia:ClubInfo = new ClubInfo();
      
      private var _account:AccountInfo;
      
      public var vipDiscountArr:Array = ["0","0","0"];
      
      public var vipPriceArr:Array = ["0","0","0"];
      
      public var merryDiscountArr:Array = ["0","0","0","0"];
      
      public var vipActivity:Boolean = false;
      
      public var vipDiscountTime:String = "";
      
      public var merryDiscountTime:String = "";
      
      private var _areaList:DictionaryData = new DictionaryData();
      
      private var _propertyAdditions:DictionaryData;
      
      private var _whoGetCards:Boolean = false;
      
      private var tempStyle:Array = [];
      
      private var changedStyle:DictionaryData = new DictionaryData();
      
      public var gemstoneInfoList:Vector.<GemstonInitInfo>;
      
      public function PlayerManager()
      {
         super();
         this._self = new SelfInfo();
         this._clubPlays = new DictionaryData();
         this._tempList = new DictionaryData();
         this._mailTempList = new DictionaryData();
         this._timer1 = new Timer(500);
         this._timer2 = new Timer(500);
      }
      
      public static function get Instance() : PlayerManager
      {
         if(_instance == null)
         {
            _instance = new PlayerManager();
         }
         return _instance;
      }
      
      public static function readLuckyPropertyName(id:int) : String
      {
         switch(id)
         {
            case PlayerPropertyType.Exp:
               return LanguageMgr.GetTranslation("exp");
            case PlayerPropertyType.Offer:
               return LanguageMgr.GetTranslation("offer");
            case PlayerPropertyType.Attack:
               return LanguageMgr.GetTranslation("attack");
            case PlayerPropertyType.Agility:
               return LanguageMgr.GetTranslation("agility");
            case PlayerPropertyType.Damage:
               return LanguageMgr.GetTranslation("damage");
            case PlayerPropertyType.Defence:
               return LanguageMgr.GetTranslation("defence");
            case PlayerPropertyType.Luck:
               return LanguageMgr.GetTranslation("luck");
            case PlayerPropertyType.MaxHp:
               return LanguageMgr.GetTranslation("MaxHp");
            case PlayerPropertyType.Recovery:
               return LanguageMgr.GetTranslation("recovery");
            default:
               return "";
         }
      }
      
      public function get Self() : SelfInfo
      {
         return this._self;
      }
      
      public function setup(acc:AccountInfo) : void
      {
         this._account = acc;
         this.customList = new Vector.<CustomInfo>();
         this._friendList = new DictionaryData();
         this._blackList = new DictionaryData();
         this.initEvents();
      }
      
      public function get Account() : AccountInfo
      {
         return this._account;
      }
      
      public function getDressEquipPlace(info:InventoryItemInfo) : int
      {
         var toPlace:int = 0;
         var j:int = 0;
         var i:int = 0;
         if(EquipType.isWeddingRing(info) && this.Self.Bag.getItemAt(16) == null)
         {
            return 16;
         }
         var toPlaces:Array = EquipType.CategeryIdToPlace(info.CategoryID,info.Place);
         if(toPlaces.length == 1)
         {
            toPlace = int(toPlaces[0]);
         }
         else
         {
            j = 0;
            for(i = 0; i < toPlaces.length; i++)
            {
               if(PlayerManager.Instance.Self.Bag.getItemAt(toPlaces[i]) == null)
               {
                  toPlace = int(toPlaces[i]);
                  break;
               }
               j++;
               if(j == toPlaces.length)
               {
                  toPlace = int(toPlaces[0]);
               }
            }
         }
         return toPlace;
      }
      
      private function __updateInventorySlot(evt:CrazyTankSocketEvent) : void
      {
         var i:int = 0;
         var slot:int = 0;
         var isUpdate:Boolean = false;
         var item:InventoryItemInfo = null;
         var sign:Boolean = false;
         var pkg:PackageIn = evt.pkg as PackageIn;
         var bagType:int = pkg.readInt();
         var len:int = pkg.readInt();
         var bag:BagInfo = this._self.getBag(bagType);
         if(bagType == 21)
         {
            sign = true;
         }
         bag.beginChanges();
         try
         {
            for(i = 0; i < len; i++)
            {
               slot = pkg.readInt();
               isUpdate = pkg.readBoolean();
               if(isUpdate)
               {
                  item = bag.getItemAt(slot);
                  if(item == null)
                  {
                     item = new InventoryItemInfo();
                     item.Place = slot;
                  }
                  item.UserID = pkg.readInt();
                  item.ItemID = pkg.readInt();
                  item.Count = pkg.readInt();
                  item.Place = pkg.readInt();
                  if(bagType == 21)
                  {
                  }
                  item.TemplateID = pkg.readInt();
                  if(item.TemplateID == 11035)
                  {
                  }
                  item.AttackCompose = pkg.readInt();
                  item.DefendCompose = pkg.readInt();
                  item.AgilityCompose = pkg.readInt();
                  item.LuckCompose = pkg.readInt();
                  item.StrengthenLevel = pkg.readInt();
                  item.StrengthenExp = pkg.readInt();
                  item.IsBinds = pkg.readBoolean();
                  item.IsJudge = pkg.readBoolean();
                  item.BeginDate = pkg.readDateString();
                  item.ValidDate = pkg.readInt();
                  item.Color = pkg.readUTF();
                  item.Skin = pkg.readUTF();
                  item.IsUsed = pkg.readBoolean();
                  item.Hole1 = pkg.readInt();
                  item.Hole2 = pkg.readInt();
                  item.Hole3 = pkg.readInt();
                  item.Hole4 = pkg.readInt();
                  item.Hole5 = pkg.readInt();
                  item.Hole6 = pkg.readInt();
                  ItemManager.fill(item);
                  item.Pic = pkg.readUTF();
                  item.RefineryLevel = pkg.readInt();
                  item.DiscolorValidDate = pkg.readDateString();
                  item.StrengthenTimes = pkg.readInt();
                  item.Hole5Level = pkg.readByte();
                  item.Hole5Exp = pkg.readInt();
                  item.Hole6Level = pkg.readByte();
                  item.Hole6Exp = pkg.readInt();
                  item.isGold = pkg.readBoolean();
                  if(item.isGold)
                  {
                     item.goldValidDate = pkg.readInt();
                     item.goldBeginTime = pkg.readDateString();
                  }
                  item.latentEnergyCurStr = pkg.readUTF();
                  item.latentEnergyNewStr = pkg.readUTF();
                  item.latentEnergyEndTime = pkg.readDate();
                  if(EquipType.isMagicStone(item.CategoryID))
                  {
                     item.Level = item.StrengthenLevel;
                     item.Attack = item.AttackCompose;
                     item.Defence = item.DefendCompose;
                     item.Agility = item.AgilityCompose;
                     item.Luck = item.LuckCompose;
                     item.MagicAttack = pkg.readInt();
                     item.MagicDefence = pkg.readInt();
                  }
                  else
                  {
                     pkg.readInt();
                     pkg.readInt();
                  }
                  item.goodsLock = pkg.readBoolean();
                  item.MagicExp = pkg.readInt();
                  item.MagicLevel = pkg.readInt();
                  if(!item.IsUsed && bagType == BagInfo.EQUIPBAG && !BagAndInfoManager.Instance.isInBagAndInfoView && SystemOpenPromptManager.instance.isShowNewEuipTip && !BagStore.instance.isInBagStoreFrame && this._playerEquipCategaryIdArr.indexOf(item.CategoryID) != -1)
                  {
                     this.showTipWithEquip(item);
                  }
                  bag.addItem(item);
                  if(item.Place == 15 && bagType == 0 && item.UserID == this.Self.ID)
                  {
                     this._self.DeputyWeaponID = item.TemplateID;
                  }
                  if(PathManager.solveExternalInterfaceEnabel() && bagType == BagInfo.STOREBAG && item.StrengthenLevel >= 7)
                  {
                     ExternalInterfaceManager.sendToAgent(3,this.Self.ID,this.Self.NickName,ServerManager.Instance.zoneName,item.StrengthenLevel);
                  }
               }
               else
               {
                  bag.removeItemAt(slot);
               }
            }
         }
         finally
         {
            bag.commiteChanges();
         }
         if(sign)
         {
            dispatchEvent(new BeadEvent(BeadEvent.EQUIPBEAD,0));
         }
         BuriedManager.evnetDispatch.dispatchEvent(new BuriedEvent(BuriedEvent.UpDate_Stone_Count));
      }
      
      public function getPlaceOfEquip(item:InventoryItemInfo) : int
      {
         var placeArr:Array = null;
         if(EquipType.isWeddingRing(item))
         {
            placeArr = [16];
         }
         else
         {
            placeArr = EquipType.CategeryIdToPlace(item.CategoryID);
         }
         var arr:Array = this._self.Bag.findIsEquipedByPlace(placeArr);
         if(arr.length > 0)
         {
            return arr[0];
         }
         return -1;
      }
      
      private function showTipWithEquip(item:InventoryItemInfo) : void
      {
         var placeArr:Array = null;
         if(EquipType.isWeddingRing(item))
         {
            placeArr = [16];
         }
         else
         {
            placeArr = EquipType.CategeryIdToPlace(item.CategoryID);
         }
         var arr:Array = this._self.Bag.findIsEquipedByPlace(placeArr);
         if(arr.length > 0)
         {
            SystemOpenPromptManager.instance.showEquipTipFrame(item);
         }
      }
      
      private function __itemEquip(evt:CrazyTankSocketEvent) : void
      {
         var _itemNum:int = 0;
         var i:uint = 0;
         var beadCount:int = 0;
         var m:uint = 0;
         var count:int = 0;
         var j:int = 0;
         var k:int = 0;
         var item:InventoryItemInfo = null;
         var bead:InventoryItemInfo = null;
         var gemstoneInfo:GemstonInitInfo = null;
         var str:String = null;
         var arr:Array = null;
         var list:Vector.<GemstListInfo> = null;
         var t_i:int = 0;
         var gems1:Array = null;
         var ginfo:GemstListInfo = null;
         var tmp:MagicStoneInfo = null;
         var equip:InventoryItemInfo = null;
         var pkg:PackageIn = evt.pkg;
         pkg.deCompress();
         var _id:int = pkg.readInt();
         var zoneId:int = pkg.readInt();
         var nickName:String = pkg.readUTF();
         var info:PlayerInfo = this.findPlayer(_id,zoneId,nickName);
         info.ID = _id;
         if(info != null)
         {
            info.beginChanges();
            info.Agility = pkg.readInt();
            info.Attack = pkg.readInt();
            if(!PlayerManager.Instance.isChangeStyleTemp(_id))
            {
               info.Colors = pkg.readUTF();
               info.Skin = pkg.readUTF();
            }
            else
            {
               pkg.readUTF();
               pkg.readUTF();
               info.Colors = this.changedStyle[_id]["Colors"];
               info.Skin = this.changedStyle[_id]["Skin"];
            }
            info.Defence = pkg.readInt();
            info.GP = pkg.readInt();
            info.Grade = pkg.readInt();
            info.Luck = pkg.readInt();
            info.hp = pkg.readInt();
            if(!PlayerManager.Instance.isChangeStyleTemp(_id))
            {
               info.Hide = pkg.readInt();
            }
            else
            {
               pkg.readInt();
               info.Hide = this.changedStyle[_id]["Hide"];
            }
            info.Repute = pkg.readInt();
            if(!PlayerManager.Instance.isChangeStyleTemp(_id))
            {
               info.Sex = pkg.readBoolean();
               info.Style = pkg.readUTF();
            }
            else
            {
               pkg.readBoolean();
               pkg.readUTF();
               info.Sex = this.changedStyle[_id]["Sex"];
               info.Style = this.changedStyle[_id]["Style"];
            }
            info.Offer = pkg.readInt();
            info.NickName = nickName;
            info.typeVIP = pkg.readByte();
            info.VIPLevel = pkg.readInt();
            info.isOpenKingBless = pkg.readBoolean();
            info.WinCount = pkg.readInt();
            info.TotalCount = pkg.readInt();
            info.EscapeCount = pkg.readInt();
            info.ConsortiaID = pkg.readInt();
            info.ConsortiaName = pkg.readUTF();
            info.badgeID = pkg.readInt();
            info.RichesOffer = pkg.readInt();
            info.RichesRob = pkg.readInt();
            info.IsMarried = pkg.readBoolean();
            info.SpouseID = pkg.readInt();
            info.SpouseName = pkg.readUTF();
            info.DutyName = pkg.readUTF();
            info.Nimbus = pkg.readInt();
            info.FightPower = pkg.readInt();
            info.apprenticeshipState = pkg.readInt();
            info.masterID = pkg.readInt();
            info.setMasterOrApprentices(pkg.readUTF());
            info.graduatesCount = pkg.readInt();
            info.honourOfMaster = pkg.readUTF();
            info.AchievementPoint = pkg.readInt();
            info.honor = pkg.readUTF();
            info.LastLoginDate = pkg.readDate();
            info.spdTexpExp = pkg.readInt();
            info.attTexpExp = pkg.readInt();
            info.defTexpExp = pkg.readInt();
            info.hpTexpExp = pkg.readInt();
            info.lukTexpExp = pkg.readInt();
            info.DailyLeagueFirst = pkg.readBoolean();
            info.DailyLeagueLastScore = pkg.readInt();
            info.totemId = pkg.readInt();
            info.necklaceExp = pkg.readInt();
            info.curHorseLevel = pkg.readInt();
            if(info.curHorseLevel < 0)
            {
               info.curHorseLevel = 0;
            }
            info.commitChanges();
            _itemNum = pkg.readInt();
            info.Bag.beginChanges();
            if(!(info is SelfInfo))
            {
               info.Bag.clearnAll();
            }
            for(i = 0; i < _itemNum; i++)
            {
               item = new InventoryItemInfo();
               item.BagType = pkg.readByte();
               item.UserID = pkg.readInt();
               item.ItemID = pkg.readInt();
               item.Count = pkg.readInt();
               item.Place = pkg.readInt();
               item.TemplateID = pkg.readInt();
               item.AttackCompose = pkg.readInt();
               item.DefendCompose = pkg.readInt();
               item.AgilityCompose = pkg.readInt();
               item.LuckCompose = pkg.readInt();
               item.StrengthenLevel = pkg.readInt();
               item.IsBinds = pkg.readBoolean();
               item.IsJudge = pkg.readBoolean();
               item.BeginDate = pkg.readDateString();
               item.ValidDate = pkg.readInt();
               item.Color = pkg.readUTF();
               item.Skin = pkg.readUTF();
               item.IsUsed = pkg.readBoolean();
               ItemManager.fill(item);
               item.Hole1 = pkg.readInt();
               item.Hole2 = pkg.readInt();
               item.Hole3 = pkg.readInt();
               item.Hole4 = pkg.readInt();
               item.Hole5 = pkg.readInt();
               item.Hole6 = pkg.readInt();
               item.Pic = pkg.readUTF();
               item.RefineryLevel = pkg.readInt();
               item.DiscolorValidDate = pkg.readDateString();
               item.Hole5Level = pkg.readByte();
               item.Hole5Exp = pkg.readInt();
               item.Hole6Level = pkg.readByte();
               item.Hole6Exp = pkg.readInt();
               item.isGold = pkg.readBoolean();
               if(item.isGold)
               {
                  item.goldValidDate = pkg.readInt();
                  item.goldBeginTime = pkg.readDateString();
               }
               item.latentEnergyCurStr = pkg.readUTF();
               item.latentEnergyNewStr = pkg.readUTF();
               item.latentEnergyEndTime = pkg.readDate();
               item.MagicLevel = pkg.readInt();
               info.Bag.addItem(item);
            }
            beadCount = pkg.readInt();
            if(!(info is SelfInfo))
            {
               info.BeadBag.clearnAll();
            }
            info.BeadBag.beginChanges();
            for(m = 0; m < beadCount; m++)
            {
               bead = new InventoryItemInfo();
               bead.BagType = pkg.readByte();
               bead.UserID = pkg.readInt();
               bead.ItemID = pkg.readInt();
               bead.Count = pkg.readInt();
               bead.Place = pkg.readInt();
               bead.TemplateID = pkg.readInt();
               bead.AttackCompose = pkg.readInt();
               bead.DefendCompose = pkg.readInt();
               bead.AgilityCompose = pkg.readInt();
               bead.LuckCompose = pkg.readInt();
               bead.StrengthenLevel = pkg.readInt();
               bead.IsBinds = pkg.readBoolean();
               bead.IsJudge = pkg.readBoolean();
               bead.BeginDate = pkg.readDateString();
               bead.ValidDate = pkg.readInt();
               bead.Color = pkg.readUTF();
               bead.Skin = pkg.readUTF();
               bead.IsUsed = pkg.readBoolean();
               ItemManager.fill(bead);
               bead.Hole1 = pkg.readInt();
               bead.Hole2 = pkg.readInt();
               bead.Hole3 = pkg.readInt();
               bead.Hole4 = pkg.readInt();
               bead.Hole5 = pkg.readInt();
               bead.Hole6 = pkg.readInt();
               bead.Pic = pkg.readUTF();
               bead.RefineryLevel = pkg.readInt();
               bead.DiscolorValidDate = pkg.readDateString();
               bead.Hole5Level = pkg.readByte();
               bead.Hole5Exp = pkg.readInt();
               bead.Hole6Level = pkg.readByte();
               bead.Hole6Exp = pkg.readInt();
               bead.isGold = pkg.readBoolean();
               info.BeadBag.addItem(bead);
            }
            count = pkg.readInt();
            this.gemstoneInfoList = new Vector.<GemstonInitInfo>();
            for(j = 0; j < count; j++)
            {
               gemstoneInfo = new GemstonInitInfo();
               gemstoneInfo.figSpiritId = pkg.readInt();
               str = pkg.readUTF();
               arr = this.rezArr(str);
               list = new Vector.<GemstListInfo>();
               for(t_i = 0; t_i < 3; t_i++)
               {
                  gems1 = arr[t_i].split(",");
                  ginfo = new GemstListInfo();
                  ginfo.fightSpiritId = gemstoneInfo.figSpiritId;
                  ginfo.level = gems1[0];
                  ginfo.exp = gems1[1];
                  ginfo.place = gems1[2];
                  list.push(ginfo);
               }
               gemstoneInfo.equipPlace = pkg.readInt();
               if(Boolean(info.Bag.getItemAt(gemstoneInfo.equipPlace)))
               {
                  info.Bag.getItemAt(gemstoneInfo.equipPlace).gemstoneList = list;
               }
               gemstoneInfo.list = list;
               this.gemstoneInfoList.push(gemstoneInfo);
            }
            info.gemstoneList = this.gemstoneInfoList;
            info.evolutionGrade = pkg.readInt();
            info.evolutionExp = pkg.readInt();
            info.MagicAttack = pkg.readInt();
            info.MagicDefence = pkg.readInt();
            count = pkg.readInt();
            for(k = 0; k <= count - 1; k++)
            {
               tmp = new MagicStoneInfo();
               tmp.place = pkg.readInt();
               tmp.templateId = pkg.readInt();
               tmp.level = pkg.readInt();
               tmp.attack = pkg.readInt();
               tmp.defence = pkg.readInt();
               tmp.agility = pkg.readInt();
               tmp.luck = pkg.readInt();
               tmp.magicAttack = pkg.readInt();
               tmp.magicDefence = pkg.readInt();
               equip = info.Bag.getItemAt(tmp.place);
               if(Boolean(equip))
               {
                  equip.magicStoneAttr = tmp;
               }
            }
            info.MountsType = pkg.readInt();
            info.Bag.commiteChanges();
            info.BeadBag.commiteChanges();
            info.commitChanges();
         }
      }
      
      private function rezArr(str:String) : Array
      {
         return str.split("|");
      }
      
      private function __onsItemEquip(evt:CrazyTankSocketEvent) : void
      {
         var pkg:PackageIn = evt.pkg;
         var _id:int = pkg.readInt();
         var nickName:String = pkg.readUTF();
         var info:PlayerInfo = this.findPlayer(_id);
         if(info != null)
         {
            info.beginChanges();
            info.Agility = pkg.readInt();
            info.Attack = pkg.readInt();
            if(!PlayerManager.Instance.isChangeStyleTemp(_id))
            {
               info.Colors = pkg.readUTF();
               info.Skin = pkg.readUTF();
            }
            else
            {
               pkg.readUTF();
               pkg.readUTF();
               info.Colors = this.changedStyle[_id]["Colors"];
               info.Skin = this.changedStyle[_id]["Skin"];
            }
            info.Defence = pkg.readInt();
            info.GP = pkg.readInt();
            info.Grade = pkg.readInt();
            info.Luck = pkg.readInt();
            if(!PlayerManager.Instance.isChangeStyleTemp(_id))
            {
               info.Hide = pkg.readInt();
            }
            else
            {
               pkg.readInt();
               info.Hide = this.changedStyle[_id]["Hide"];
            }
            info.Repute = pkg.readInt();
            if(!PlayerManager.Instance.isChangeStyleTemp(_id))
            {
               info.Sex = pkg.readBoolean();
               info.Style = pkg.readUTF();
            }
            else
            {
               pkg.readBoolean();
               pkg.readUTF();
               info.Sex = this.changedStyle[_id]["Sex"];
               info.Style = this.changedStyle[_id]["Style"];
            }
            info.Offer = pkg.readInt();
            info.NickName = nickName;
            info.typeVIP = pkg.readByte();
            info.VIPLevel = pkg.readInt();
            info.WinCount = pkg.readInt();
            info.TotalCount = pkg.readInt();
            info.EscapeCount = pkg.readInt();
            info.ConsortiaID = pkg.readInt();
            info.ConsortiaName = pkg.readUTF();
            info.RichesOffer = pkg.readInt();
            info.RichesRob = pkg.readInt();
            info.IsMarried = pkg.readBoolean();
            info.SpouseID = pkg.readInt();
            info.SpouseName = pkg.readUTF();
            info.DutyName = pkg.readUTF();
            info.Nimbus = pkg.readInt();
            info.FightPower = pkg.readInt();
            info.apprenticeshipState = pkg.readInt();
            info.masterID = pkg.readInt();
            info.setMasterOrApprentices(pkg.readUTF());
            info.graduatesCount = pkg.readInt();
            info.honourOfMaster = pkg.readUTF();
            info.AchievementPoint = pkg.readInt();
            info.honor = pkg.readUTF();
            info.LastLoginDate = pkg.readDate();
            info.commitChanges();
            info.Bag.beginChanges();
            info.Bag.commiteChanges();
            info.commitChanges();
         }
         super.dispatchEvent(new CityWideEvent(CityWideEvent.ONS_PLAYERINFO,info));
      }
      
      private function __bagLockedHandler(evt:CrazyTankSocketEvent) : void
      {
         var userId:int = evt.pkg.readInt();
         var type:int = evt.pkg.readInt();
         var isSussect:Boolean = evt.pkg.readBoolean();
         var boo:Boolean = evt.pkg.readBoolean();
         var msg:String = evt.pkg.readUTF();
         var count:int = evt.pkg.readInt();
         var questionOne:String = evt.pkg.readUTF();
         var questionTwo:String = evt.pkg.readUTF();
         if(isSussect)
         {
            switch(type)
            {
               case 1:
                  this._self.bagPwdState = true;
                  this._self.bagLocked = true;
                  this._self.onReceiveTypes(BagEvent.CHANGEPSW);
                  BagLockedController.PWD = BagLockedController.TEMP_PWD;
                  MessageTipManager.getInstance().show(msg);
                  break;
               case 2:
                  this._self.bagPwdState = true;
                  this._self.bagLocked = false;
                  if(!ServerManager.AUTO_UNLOCK)
                  {
                     if(msg != "")
                     {
                        MessageTipManager.getInstance().show(msg);
                     }
                     ServerManager.AUTO_UNLOCK = false;
                  }
                  BagLockedController.PWD = BagLockedController.TEMP_PWD;
                  this._self.onReceiveTypes(BagEvent.CLEAR);
                  break;
               case 3:
                  this._self.onReceiveTypes(BagEvent.UPDATE_SUCCESS);
                  BagLockedController.PWD = BagLockedController.TEMP_PWD;
                  MessageTipManager.getInstance().show(msg);
                  break;
               case 4:
                  this._self.bagPwdState = false;
                  this._self.bagLocked = false;
                  this._self.onReceiveTypes(BagEvent.AFTERDEL);
                  MessageTipManager.getInstance().show(msg);
                  break;
               case 5:
                  this._self.bagPwdState = true;
                  this._self.bagLocked = true;
                  MessageTipManager.getInstance().show(msg);
                  break;
               case 6:
            }
         }
         else
         {
            MessageTipManager.getInstance().show(msg);
         }
      }
      
      private function __friendAdd(evt:CrazyTankSocketEvent) : void
      {
         var info:FriendListPlayer = null;
         var existInfo:PlayerInfo = null;
         var pkg:PackageIn = evt.pkg;
         var b:Boolean = pkg.readBoolean();
         if(b)
         {
            info = new FriendListPlayer();
            info.beginChanges();
            info.ID = pkg.readInt();
            info.NickName = pkg.readUTF();
            info.typeVIP = pkg.readByte();
            info.VIPLevel = pkg.readInt();
            info.Sex = pkg.readBoolean();
            existInfo = this.findPlayer(info.ID);
            if(!PlayerManager.Instance.isChangeStyleTemp(info.ID))
            {
               info.Style = pkg.readUTF();
               info.Colors = pkg.readUTF();
               info.Skin = pkg.readUTF();
            }
            else
            {
               pkg.readUTF();
               pkg.readUTF();
               pkg.readUTF();
               info.Style = existInfo.Style;
               info.Colors = existInfo.Colors;
               info.Skin = existInfo.Skin;
            }
            info.playerState = new PlayerState(pkg.readInt());
            info.Grade = pkg.readInt();
            if(!PlayerManager.Instance.isChangeStyleTemp(info.ID))
            {
               info.Hide = pkg.readInt();
            }
            else
            {
               pkg.readInt();
               info.Hide = existInfo.Hide;
            }
            info.ConsortiaName = pkg.readUTF();
            info.TotalCount = pkg.readInt();
            info.EscapeCount = pkg.readInt();
            info.WinCount = pkg.readInt();
            info.Offer = pkg.readInt();
            info.Repute = pkg.readInt();
            info.Relation = pkg.readInt();
            info.LoginName = pkg.readUTF();
            info.Nimbus = pkg.readInt();
            info.FightPower = pkg.readInt();
            info.apprenticeshipState = pkg.readInt();
            info.masterID = pkg.readInt();
            info.setMasterOrApprentices(pkg.readUTF());
            info.graduatesCount = pkg.readInt();
            info.honourOfMaster = pkg.readUTF();
            info.AchievementPoint = pkg.readInt();
            info.honor = pkg.readUTF();
            info.IsMarried = pkg.readBoolean();
            info.isOld = pkg.readBoolean();
            info.LastLoginDate = pkg.readDate();
            info.commitChanges();
            if(info.Relation != 1)
            {
               this.addFriend(info);
               if(PathInfo.isUserAddFriend)
               {
                  new AddCommunityFriend(info.LoginName,info.NickName);
               }
            }
            else
            {
               this.addBlackList(info);
            }
            dispatchEvent(new IMEvent(IMEvent.ADDNEW_FRIEND,info));
         }
         else
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.playerManager.addFriend.isRefused"));
         }
      }
      
      public function addFriend(player:PlayerInfo) : void
      {
         if(!this.blackList && !this.friendList)
         {
            return;
         }
         this.blackList.remove(player.ID);
         this.friendList.add(player.ID,player);
      }
      
      public function addBlackList(player:FriendListPlayer) : void
      {
         if(!this.blackList && !this.friendList)
         {
            return;
         }
         this.friendList.remove(player.ID);
         this.blackList.add(player.ID,player);
      }
      
      public function removeFriend(id:int) : void
      {
         if(!this.blackList && !this.friendList)
         {
            return;
         }
         this.friendList.remove(id);
         this.blackList.remove(id);
      }
      
      private function __friendRemove(evt:CrazyTankSocketEvent) : void
      {
         this.removeFriend(evt.pkg.clientId);
      }
      
      private function __playerState(evt:CrazyTankSocketEvent) : void
      {
         var clientId:int = 0;
         var state:int = 0;
         var typeVip:int = 0;
         var vipLevel:int = 0;
         var isSameCity:Boolean = false;
         var pkg:PackageIn = evt.pkg;
         if(pkg.clientId != this._self.ID)
         {
            clientId = pkg.clientId;
            state = pkg.readInt();
            typeVip = pkg.readByte();
            vipLevel = pkg.readInt();
            isSameCity = pkg.readBoolean();
            this.playerStateChange(clientId,state,typeVip,vipLevel,isSameCity);
            ConsortionModelControl.Instance.model.consortiaPlayerStateChange(clientId,state);
         }
      }
      
      private function spouseStateChange(state:int) : void
      {
         var msg:String = null;
         if(state == PlayerState.ONLINE)
         {
            msg = this.Self.Sex ? LanguageMgr.GetTranslation("ddt.manager.playerManager.wifeOnline",this.Self.SpouseName) : LanguageMgr.GetTranslation("ddt.manager.playerManager.hushandOnline",this.Self.SpouseName);
            ChatManager.Instance.sysChatYellow(msg);
         }
      }
      
      private function masterStateChange(state:int, clientId:int) : void
      {
         var msg:String = null;
         if(state == PlayerState.ONLINE && clientId != this.Self.SpouseID)
         {
            if(clientId == this.Self.masterID)
            {
               msg = LanguageMgr.GetTranslation("ddt.manager.playerManager.masterState",this.Self.getMasterOrApprentices()[clientId]);
            }
            else
            {
               if(!Boolean(this.Self.getMasterOrApprentices()[clientId]))
               {
                  return;
               }
               msg = LanguageMgr.GetTranslation("ddt.manager.playerManager.ApprenticeState",this.Self.getMasterOrApprentices()[clientId]);
            }
            ChatManager.Instance.sysChatYellow(msg);
         }
      }
      
      public function playerStateChange(id:int, state:int, typeVIP:int, viplevel:int, isSameCity:Boolean) : void
      {
         var strII:String = null;
         var beforeState:int = 0;
         var playerInfo:PlayerInfo = null;
         var info:PlayerInfo = this.friendList[id];
         if(Boolean(info))
         {
            if(info.playerState.StateID != state || info.typeVIP != typeVIP || info.isSameCity != isSameCity)
            {
               info.typeVIP = typeVIP;
               info.VIPLevel = viplevel;
               info.isSameCity = isSameCity;
               if(state == PlayerState.ONLINE)
               {
                  info.LastLoginDate = TimeManager.Instance.serverDate;
               }
               strII = "";
               beforeState = info.playerState.StateID;
               if(info.playerState.StateID != state)
               {
                  info.playerState = new PlayerState(state);
                  this.friendList.add(id,info);
                  if(beforeState == PlayerState.SHOPPING)
                  {
                     return;
                  }
                  if(id == this.Self.SpouseID)
                  {
                     this.spouseStateChange(state);
                     return;
                  }
                  if(id == this.Self.masterID || Boolean(this.Self.getMasterOrApprentices()[id]))
                  {
                     this.masterStateChange(state,id);
                     return;
                  }
                  if(state == PlayerState.ONLINE && SharedManager.Instance.showOL)
                  {
                     strII = LanguageMgr.GetTranslation("tank.view.chat.ChatInputView.friend") + "[" + info.NickName + "]" + LanguageMgr.GetTranslation("tank.manager.PlayerManger.friendOnline");
                     ChatManager.Instance.sysChatYellow(strII);
                     return;
                  }
                  return;
               }
            }
            this.friendList.add(id,info);
         }
         else if(Boolean(this.myAcademyPlayers))
         {
            playerInfo = this.myAcademyPlayers[id];
            if(Boolean(playerInfo))
            {
               if(playerInfo.playerState.StateID != state || playerInfo.IsVIP != typeVIP)
               {
                  playerInfo.typeVIP = typeVIP;
                  playerInfo.VIPLevel = viplevel;
                  playerInfo.playerState = new PlayerState(state);
                  this.myAcademyPlayers.add(id,playerInfo);
               }
            }
         }
      }
      
      private function initEvents() : void
      {
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.GRID_GOODS,this.__updateInventorySlot);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.AREA_INFO_UPDATE,this.__updateAreaInfo);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.ITEM_EQUIP,this.__itemEquip);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.ONS_EQUIP,this.__onsItemEquip);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.BAG_LOCKED,this.__bagLockedHandler);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.UPDATE_PRIVATE_INFO,this.__updatePrivateInfo);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.UPDATE_PLAYER_INFO,this.__updatePlayerInfo);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.TEMP_STYLE,this.__readTempStyle);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.DAILY_AWARD,this.__dailyAwardHandler);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.CHECK_CODE,this.__checkCodePopup);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.BUFF_OBTAIN,this.__buffObtain);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.BUFF_UPDATE,this.__buffUpdate);
         this.Self.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__selfPopChange);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.FRIEND_ADD,this.__friendAdd);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.FRIEND_REMOVE,this.__friendRemove);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.FRIEND_STATE,this.__playerState);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.VIP_IS_OPENED,this.__upVipInfo);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.USER_GET_GIFTS,this.__getGifts);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.USER_UPDATE_GIFT,this.__addGiftItem);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.USER_RELOAD_GIFT,this.__canReLoadGift);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.CARDS_DATA,this.__getCards);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.USER_ANSWER,this.__updateUerGuild);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.CHAT_FILTERING_FRIENDS_SHARE,this.__chatFilteringFriendsShare);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.SAME_CITY_FRIEND,this.__sameCity);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.ROOMLIST_PASS,this.__roomListPass);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.UPDATE_PET,this.__updatePet);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.NECKLACE_STRENGTH,this.__necklaceStrengthInfoUpadte);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.QUEST_ONEKEYFINISH,this.__updateOneKeyFinish);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.UPDATE_PLAYER_PROPERTY,this.__updatePlayerProperty);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.BEAD_HOLE_INFO,this.__onOpenHole);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.MISSION_ENERGY,this.__updateEnergyHandler);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.PEER_ID,this.__updatePeerID);
         SocketManager.Instance.addEventListener(RingStationEvent.DUNGEON_UPDATEEXP,this.__onUpdateDungeonExp);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.TOTAL_CHARGE,this.__totalCharge);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.VIP_MERRY_DISCOUNT,this.__vipMerryDiscountInfo);
      }
      
      public function discountInit() : void
      {
         this.vipPriceArr = ServerConfigManager.instance.VIPRenewalPrice;
         this.merryDiscountArr = [ServerConfigManager.instance.weddingMoney[0],ServerConfigManager.instance.weddingMoney[1],ServerConfigManager.instance.weddingMoney[2],ServerConfigManager.instance.divorcedMoney];
      }
      
      private function __vipMerryDiscountInfo(event:CrazyTankSocketEvent) : void
      {
         var beginTime:String = null;
         var endTime:String = null;
         var merryDiscountInfo:String = null;
         var vipDiscountInfo:String = null;
         var arr:Array = null;
         var i:int = 0;
         var pkg:PackageIn = event.pkg;
         var type:int = pkg.readInt();
         var bool:Boolean = pkg.readBoolean();
         if(type == 1)
         {
            this.merryDiscountArr = ["0","0","0","0"];
            if(bool)
            {
               merryDiscountInfo = pkg.readUTF();
               beginTime = pkg.readUTF();
               endTime = pkg.readUTF();
               this.merryDiscountTime = beginTime + "--" + endTime;
               this.merryDiscountArr = merryDiscountInfo.split("|");
               this.merryActivity = true;
            }
            else
            {
               this.merryDiscountArr = ServerConfigManager.instance.weddingMoney;
               this.merryDiscountArr.push(ServerConfigManager.instance.divorcedMoney);
               this.merryActivity = false;
            }
         }
         else
         {
            this.vipDiscountArr = ["0","0","0"];
            this.vipPriceArr = ["0","0","0"];
            if(bool)
            {
               vipDiscountInfo = pkg.readUTF();
               arr = vipDiscountInfo.split("|");
               for(i = 0; i < arr.length; i++)
               {
                  this.vipDiscountArr[i] = arr[i].split(",")[1];
                  this.vipPriceArr[i] = arr[i].split(",")[0];
               }
               this.checkVipDiscount();
               beginTime = pkg.readUTF();
               endTime = pkg.readUTF();
               this.vipDiscountTime = beginTime + "--" + endTime;
               this.vipActivity = true;
            }
            else
            {
               this.vipPriceArr = ServerConfigManager.instance.VIPRenewalPrice;
               this.vipActivity = false;
            }
         }
      }
      
      private function checkVipDiscount() : void
      {
         var trueDisCount:Number = NaN;
         for(var i:int = 0; i < this.vipPriceArr.length; i++)
         {
            if(Number(this.vipDiscountArr[i]) != 0)
            {
               trueDisCount = 10 * Number(this.vipPriceArr[i]) / Number(ServerConfigManager.instance.VIPRenewalPrice[i]);
               if(Math.abs(trueDisCount - Number(this.vipDiscountArr[i])) > 0.5)
               {
                  this.vipDiscountArr[i] = String(trueDisCount.toFixed(2));
               }
            }
         }
      }
      
      protected function __totalCharge(event:CrazyTankSocketEvent) : void
      {
         var pkg:PackageIn = event.pkg;
         this._self.totalCharge = pkg.readInt();
      }
      
      protected function __onUpdateDungeonExp(event:RingStationEvent) : void
      {
         var pkg:PackageIn = event.pkg;
         this._self.DungeonExpReceiveNum = pkg.readInt();
         this._self.DungeonExpTotalNum = pkg.readInt();
      }
      
      protected function __updatePeerID(event:CrazyTankSocketEvent) : void
      {
         var zoneID:int = event.pkg.readInt();
         var userID:int = event.pkg.readInt();
         var player:PlayerInfo = this.findPlayer(userID,zoneID);
         player.peerID = event.pkg.readUTF();
         FlashP2PManager.Instance.addReadStream(player.peerID,player.ID);
      }
      
      protected function __updateEnergyHandler(event:CrazyTankSocketEvent) : void
      {
         this.Self.energy = event.pkg.readInt();
         this.Self.buyEnergyCount = event.pkg.readInt();
         dispatchEvent(new Event(UPDATEENERGY));
      }
      
      protected function __necklaceStrengthInfoUpadte(event:CrazyTankSocketEvent) : void
      {
         this.Self.necklaceExp = event.pkg.readInt();
         this.Self.necklaceExpAdd = event.pkg.readInt();
      }
      
      protected function __updateAreaInfo(event:CrazyTankSocketEvent) : void
      {
         var areaInfo:AreaInfo = null;
         var len:int = event.pkg.readInt();
         for(var i:int = 0; i < len; i++)
         {
            areaInfo = new AreaInfo();
            areaInfo.areaID = event.pkg.readInt();
            areaInfo.areaName = event.pkg.readUTF();
            this._areaList.add(areaInfo.areaName,areaInfo);
         }
      }
      
      private function __loginAboutTreasure(e:CrazyTankSocketEvent) : void
      {
         PlayerManager.Instance.Self.treasure = e.pkg.readInt();
         var num:int = e.pkg.readInt();
         PlayerManager.Instance.Self.treasureAdd = num > 0 ? num : 0;
         TreasureModel.instance.isEndTreasure = e.pkg.readBoolean();
      }
      
      public function get areaList() : DictionaryData
      {
         return this._areaList;
      }
      
      public function getSelfAreaNameByAreaID() : String
      {
         var i:AreaInfo = null;
         for each(i in this._areaList)
         {
            if(i.areaID == this.Self.ZoneID)
            {
               return i.areaName;
            }
         }
         return "";
      }
      
      public function getAreaNameByAreaID(areaID:int) : String
      {
         var i:AreaInfo = null;
         for each(i in this._areaList)
         {
            if(i.areaID == areaID)
            {
               return i.areaName;
            }
         }
         return "";
      }
      
      private function __onOpenHole(pEvent:CrazyTankSocketEvent) : void
      {
         var pkg:PackageIn = pEvent.pkg as PackageIn;
         var id:int = pkg.readInt();
         BeadModel.drillInfo.clear();
         BeadModel.drillInfo.add(131,pkg.readInt());
         BeadModel.drillInfo.add(141,pkg.readInt());
         BeadModel.drillInfo.add(151,pkg.readInt());
         BeadModel.drillInfo.add(161,pkg.readInt());
         BeadModel.drillInfo.add(171,pkg.readInt());
         BeadModel.drillInfo.add(181,pkg.readInt());
         BeadModel.drillInfo.add(132,pkg.readInt());
         BeadModel.drillInfo.add(142,pkg.readInt());
         BeadModel.drillInfo.add(152,pkg.readInt());
         BeadModel.drillInfo.add(162,pkg.readInt());
         BeadModel.drillInfo.add(172,pkg.readInt());
         BeadModel.drillInfo.add(182,pkg.readInt());
         dispatchEvent(new BeadEvent(BeadEvent.OPENBEADHOLE,0));
      }
      
      protected function __updatePlayerProperty(event:CrazyTankSocketEvent) : void
      {
         var s:String = null;
         var info:PlayerInfo = null;
         var pkg:PackageIn = event.pkg;
         var arr:Array = ["Attack","Defence","Agility","Luck"];
         var dic:DictionaryData = new DictionaryData();
         var tmp:DictionaryData = null;
         var playerId:int = -1;
         playerId = pkg.readInt();
         var zoneId:int = pkg.readInt();
         for each(s in arr)
         {
            tmp = dic[s] = new DictionaryData();
            pkg.readInt();
            tmp["Texp"] = pkg.readInt();
            tmp["Card"] = pkg.readInt();
            tmp["Pet"] = pkg.readInt();
            tmp["Suit"] = pkg.readInt();
            tmp["gem"] = pkg.readInt();
            tmp["Bead"] = pkg.readInt();
            tmp["Avatar"] = pkg.readInt();
            tmp["MagicStone"] = pkg.readInt();
         }
         tmp = dic["MagicAttack"] = new DictionaryData();
         tmp["MagicStone"] = pkg.readInt();
         tmp["Horse"] = pkg.readInt();
         tmp["HorsePicCherish"] = pkg.readInt();
         tmp["Enchant"] = pkg.readInt();
         tmp["Suit"] = pkg.readInt();
         tmp = dic["MagicDefence"] = new DictionaryData();
         tmp["MagicStone"] = pkg.readInt();
         tmp["Horse"] = pkg.readInt();
         tmp["HorsePicCherish"] = pkg.readInt();
         tmp["Enchant"] = pkg.readInt();
         tmp["Suit"] = pkg.readInt();
         tmp = dic["HP"] = new DictionaryData();
         pkg.readInt();
         tmp["Texp"] = pkg.readInt();
         tmp["Pet"] = pkg.readInt();
         tmp["Bead"] = pkg.readInt();
         tmp["Suit"] = pkg.readInt();
         tmp["gem"] = pkg.readInt();
         tmp["Avatar"] = pkg.readInt();
         tmp["Horse"] = pkg.readInt();
         tmp["HorsePicCherish"] = pkg.readInt();
         tmp = dic["Damage"] = new DictionaryData();
         tmp["Suit"] = pkg.readInt();
         tmp = dic["Guard"] = new DictionaryData();
         tmp["Suit"] = pkg.readInt();
         dic["Damage"]["Bead"] = pkg.readInt();
         dic["Damage"]["Avatar"] = pkg.readInt();
         dic["Damage"]["Horse"] = pkg.readInt();
         dic["Damage"]["HorsePicCherish"] = pkg.readInt();
         dic["Armor"] = new DictionaryData();
         dic["Armor"]["Bead"] = pkg.readInt();
         dic["Armor"]["Avatar"] = pkg.readInt();
         dic["Armor"]["Horse"] = pkg.readInt();
         dic["Armor"]["HorsePicCherish"] = pkg.readInt();
         dic["Armor"]["Pet"] = pkg.readInt();
         info = this.findPlayer(playerId,zoneId);
         SyahManager.Instance.totalDamage = pkg.readInt();
         SyahManager.Instance.totalArmor = pkg.readInt();
         TotemManager.instance.updatePropertyAddtion(info.totemId,dic);
         info.propertyAddition = dic;
         dispatchEvent(new Event(UPDATE_PLAYER_PROPERTY));
         info.commitChanges();
      }
      
      public function get propertyAdditions() : DictionaryData
      {
         return this._propertyAdditions;
      }
      
      private function __roomListPass(evt:CrazyTankSocketEvent) : void
      {
         var id:int = evt.pkg.readInt();
         var passInput:PassInputFrame = ComponentFactory.Instance.creat("asset.ddtroomList.RoomList.passInputFrame");
         LayerManager.Instance.addToLayer(passInput,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
         passInput.ID = id;
      }
      
      private function __sameCity(event:CrazyTankSocketEvent) : void
      {
         var i:int = 0;
         var id:int = 0;
         for(var len:int = event.pkg.readInt(); i < len; )
         {
            id = event.pkg.readInt();
            this.findPlayer(id,this.Self.ZoneID).isSameCity = true;
            if(!this._sameCityList)
            {
               this._sameCityList = new Array();
            }
            this._sameCityList.push(id);
            i++;
         }
         this.initSameCity();
      }
      
      private function initSameCity() : void
      {
         if(!this._sameCityList)
         {
            this._sameCityList = new Array();
         }
         for(var i:int = 0; i < this._sameCityList.length; i++)
         {
            this.findPlayer(this._sameCityList[i]).isSameCity = true;
         }
         this._friendList[this._self.ZoneID].dispatchEvent(new DictionaryEvent(DictionaryEvent.UPDATE));
      }
      
      private function __chatFilteringFriendsShare(event:CrazyTankSocketEvent) : void
      {
         var info:CMFriendInfo = null;
         if(!this._cmFriendList)
         {
            return;
         }
         var pkg:PackageIn = event.pkg;
         var playerID:int = pkg.readInt();
         var notifyMsg:String = pkg.readUTF();
         var isHasInfo:Boolean = false;
         for each(info in this._cmFriendList)
         {
            if(info.UserId == playerID)
            {
               isHasInfo = true;
            }
         }
         if(isHasInfo)
         {
            ChatManager.Instance.sysChatYellow(notifyMsg);
         }
      }
      
      private function __updateUerGuild(event:CrazyTankSocketEvent) : void
      {
         var bit:int = 0;
         var b:ByteArray = new ByteArray();
         var l:int = event.pkg.readInt();
         for(var i:int = 0; i < l; i++)
         {
            bit = event.pkg.readByte();
            b.writeByte(bit);
         }
         this._self.weaklessGuildProgress = b;
      }
      
      private function __getCards(event:CrazyTankSocketEvent) : void
      {
         var place:int = 0;
         var b:Boolean = false;
         var cardInfo:CardInfo = null;
         var tempArr:Vector.<AwardsInfo> = null;
         var adinfo:AwardsInfo = null;
         this._whoGetCards = true;
         var pkg:PackageIn = event.pkg;
         var userId:int = pkg.readInt();
         var zoneId:int = pkg.readInt();
         var len:int = pkg.readInt();
         var info:PlayerInfo = this.findPlayer(userId,zoneId);
         for(var i:int = 0; i < len; i++)
         {
            place = pkg.readInt();
            b = pkg.readBoolean();
            if(b)
            {
               cardInfo = new CardInfo();
               cardInfo.CardID = pkg.readInt();
               cardInfo.CardType = pkg.readInt();
               cardInfo.UserID = pkg.readInt();
               cardInfo.Place = pkg.readInt();
               cardInfo.TemplateID = pkg.readInt();
               cardInfo.isFirstGet = pkg.readBoolean();
               cardInfo.Attack = pkg.readInt();
               cardInfo.Defence = pkg.readInt();
               cardInfo.Agility = pkg.readInt();
               cardInfo.Luck = pkg.readInt();
               cardInfo.Damage = pkg.readInt();
               cardInfo.Guard = pkg.readInt();
               if(CaddyModel.instance.type == CaddyModel.CARD_TYPE || CaddyModel.instance.type == CaddyModel.MY_CARDBOX || CaddyModel.instance.type == CaddyModel.MYSTICAL_CARDBOX)
               {
                  if(cardInfo.TemplateID != 0)
                  {
                     this._self.cardInfo = cardInfo;
                     dispatchEvent(new Event(CaddyModel.CARDS_NAME));
                  }
               }
               if(cardInfo.Place <= CardInfo.MAX_EQUIP_CARDS && cardInfo.TemplateID > 0)
               {
                  info.cardEquipDic.add(cardInfo.Place,cardInfo);
               }
               else if(cardInfo.Place <= CardInfo.MAX_EQUIP_CARDS && cardInfo.TemplateID == 0)
               {
                  info.cardEquipDic.remove(place);
               }
               else if(cardInfo.Place > CardInfo.MAX_EQUIP_CARDS && cardInfo.TemplateID == 0)
               {
                  info.cardBagDic.remove(place);
               }
               else
               {
                  info.cardBagDic.add(cardInfo.Place,cardInfo);
                  tempArr = new Vector.<AwardsInfo>();
                  adinfo = new AwardsInfo();
                  adinfo.name = cardInfo.templateInfo.Name;
                  adinfo.TemplateId = cardInfo.TemplateID;
                  adinfo.channel = cardInfo.CardType;
                  adinfo.zone = String(cardInfo.Place);
                  adinfo.zoneID = 0;
                  tempArr.push(adinfo);
                  CaddyModel.instance.addAwardsInfoByArr(tempArr);
               }
            }
            else if(place <= CardInfo.MAX_EQUIP_CARDS)
            {
               info.cardEquipDic.remove(place);
            }
            else
            {
               info.cardBagDic.remove(place);
            }
         }
      }
      
      public function get whoGetCards() : Boolean
      {
         return this._whoGetCards;
      }
      
      public function set whoGetCards(value:Boolean) : void
      {
         this._whoGetCards = value;
      }
      
      private function __sysNotice(event:CrazyTankSocketEvent) : void
      {
         var pkg:PackageIn = event.pkg;
         var sysNoticeType:int = pkg.readInt();
         var msg:String = pkg.readUTF();
         var type:int = pkg.readByte();
         var tmp0Length:int = pkg.readInt();
         var cardTempID:int = pkg.readInt();
         var cardID:int = pkg.readInt();
         var itemGuid:String = pkg.readUTF();
         var chatMsg:ChatData = new ChatData();
         chatMsg.type = 1;
         chatMsg.msg = msg;
         chatMsg.channel = sysNoticeType;
      }
      
      private function __canReLoadGift(event:CrazyTankSocketEvent) : void
      {
         var b:Boolean = event.pkg.readBoolean();
         if(b)
         {
            SocketManager.Instance.out.sendPlayerGift(this._self.ID);
         }
      }
      
      private function __addGiftItem(event:CrazyTankSocketEvent) : void
      {
         var i:int = 0;
         var pkg:PackageIn = event.pkg;
         var templateId:int = pkg.readInt();
         var amount:int = pkg.readInt();
         var len:int = int(this._self.myGiftData.length);
         if(len != 0)
         {
            for(i = 0; i < len; i++)
            {
               if(this._self.myGiftData[i].TemplateID == templateId)
               {
                  this._self.myGiftData[i].amount = amount;
                  dispatchEvent(new DictionaryEvent(DictionaryEvent.UPDATE,this._self.myGiftData[i]));
                  break;
               }
               if(i == len - 1)
               {
                  this.addItem(templateId,amount);
               }
            }
         }
         else
         {
            this.addItem(templateId,amount);
         }
         GiftController.Instance.loadRecord(GiftController.RECEIVEDPATH,this._self.ID);
      }
      
      private function addItem(templateId:int, amount:int) : void
      {
         var cellInfo:MyGiftCellInfo = new MyGiftCellInfo();
         cellInfo.TemplateID = templateId;
         cellInfo.amount = amount;
         this._self.myGiftData.push(cellInfo);
         dispatchEvent(new DictionaryEvent(DictionaryEvent.ADD,this._self.myGiftData[this._self.myGiftData.length - 1]));
      }
      
      private function __getGifts(event:CrazyTankSocketEvent) : void
      {
         var list:Vector.<MyGiftCellInfo> = null;
         var i:int = 0;
         var cellInfo:MyGiftCellInfo = null;
         var list2:Vector.<MyGiftCellInfo> = null;
         var j:int = 0;
         var cellInfo2:MyGiftCellInfo = null;
         var num:int = 0;
         var pkg:PackageIn = event.pkg;
         var id:int = pkg.readInt();
         var info:PlayerInfo = this.findPlayer(id);
         if(id == this._self.ID)
         {
            this._self.charmGP = pkg.readInt();
            num = pkg.readInt();
            list = new Vector.<MyGiftCellInfo>();
            for(i = 0; i < num; i++)
            {
               cellInfo = new MyGiftCellInfo();
               cellInfo.TemplateID = pkg.readInt();
               cellInfo.amount = pkg.readInt();
               list.push(cellInfo);
            }
            this._self.myGiftData = list;
            dispatchEvent(new Event(SELF_GIFT_INFO_CHANGE));
         }
         else
         {
            info.beginChanges();
            info.charmGP = pkg.readInt();
            num = pkg.readInt();
            list2 = new Vector.<MyGiftCellInfo>();
            for(j = 0; j < num; j++)
            {
               cellInfo2 = new MyGiftCellInfo();
               cellInfo2.TemplateID = pkg.readInt();
               cellInfo2.amount = pkg.readInt();
               list2.push(cellInfo2);
            }
            info.myGiftData = list2;
            info.commitChanges();
            dispatchEvent(new Event(GIFT_INFO_CHANGE));
         }
      }
      
      private function __upVipInfo(evt:CrazyTankSocketEvent) : void
      {
         var pkg:PackageIn = evt.pkg;
         this._self.typeVIP = pkg.readByte();
         this._self.VIPLevel = pkg.readInt();
         this._self.VIPExp = pkg.readInt();
         this._self.VIPExpireDay = pkg.readDate();
         this._self.LastDate = pkg.readDate();
         this._self.VIPNextLevelDaysNeeded = pkg.readInt();
         this._self.canTakeVipReward = pkg.readBoolean();
         dispatchEvent(new Event(VIP_STATE_CHANGE));
      }
      
      public function setupFriendList(analyzer:FriendListAnalyzer) : void
      {
         this.customList = analyzer.customList;
         this.friendList = analyzer.friendlist;
         this.blackList = analyzer.blackList;
         this.initSameCity();
      }
      
      public function setupEnergyData(analyzer:EnergyDataAnalyzer) : void
      {
         this.energyData = analyzer.data;
      }
      
      public function setupCallPropData(analyzer:CallPropDataAnalyer) : void
      {
         this.callPropData = analyzer.data;
      }
      
      public function checkHasGroupName(name:String) : Boolean
      {
         for(var i:int = 0; i < this.customList.length; i++)
         {
            if(this.customList[i].Name == name)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("IM.addFirend.repet"),0,true);
               return true;
            }
         }
         return false;
      }
      
      public function setupMyacademyPlayers(analyzer:MyAcademyPlayersAnalyze) : void
      {
         this._myAcademyPlayers = analyzer.myAcademyPlayers;
      }
      
      private function romoveAcademyPlayers() : void
      {
         var i:FriendListPlayer = null;
         for each(i in this._myAcademyPlayers)
         {
            this.friendList.remove(i.ID);
         }
      }
      
      public function setupRecentContacts(analyzer:RecentContactsAnalyze) : void
      {
         this.recentContacts = analyzer.recentContacts;
      }
      
      public function set friendList(value:DictionaryData) : void
      {
         this._friendList[this._self.ZoneID] = value;
         IMController.Instance.isLoadComplete = true;
         dispatchEvent(new Event(FRIENDLIST_COMPLETE));
      }
      
      public function get friendList() : DictionaryData
      {
         if(this._friendList[this._self.ZoneID] == null)
         {
            this._friendList[PlayerManager.Instance.Self.ZoneID] = new DictionaryData();
         }
         return this._friendList[this._self.ZoneID];
      }
      
      public function getFriendForCustom(relation:int) : DictionaryData
      {
         var info:FriendListPlayer = null;
         var temp:DictionaryData = new DictionaryData();
         if(this._friendList[this._self.ZoneID] == null)
         {
            this._friendList[PlayerManager.Instance.Self.ZoneID] = new DictionaryData();
         }
         for each(info in this._friendList[this._self.ZoneID])
         {
            if(info.Relation == relation)
            {
               temp.add(info.ID,info);
            }
         }
         return temp;
      }
      
      public function deleteCustomGroup(relation:int) : void
      {
         var info:FriendListPlayer = null;
         for each(info in this._friendList[this._self.ZoneID])
         {
            if(info.Relation == relation)
            {
               info.Relation = 0;
            }
         }
      }
      
      public function get myAcademyPlayers() : DictionaryData
      {
         return this._myAcademyPlayers;
      }
      
      public function get recentContacts() : DictionaryData
      {
         if(!this._recentContacts)
         {
            this._recentContacts = new DictionaryData();
         }
         return this._recentContacts;
      }
      
      public function set recentContacts(value:DictionaryData) : void
      {
         this._recentContacts = value;
         dispatchEvent(new Event(RECENT_CONTAST_COMPLETE));
      }
      
      public function get onlineRecentContactList() : Array
      {
         var i:FriendListPlayer = null;
         var temp:Array = [];
         for each(i in this.recentContacts)
         {
            if(i.playerState.StateID != PlayerState.OFFLINE || this.findPlayer(i.ID) && this.findPlayer(i.ID).playerState.StateID != PlayerState.OFFLINE)
            {
               temp.push(i);
            }
         }
         return temp;
      }
      
      public function get offlineRecentContactList() : Array
      {
         var i:FriendListPlayer = null;
         var temp:Array = [];
         for each(i in this.recentContacts)
         {
            if(i.playerState.StateID == PlayerState.OFFLINE)
            {
               temp.push(i);
            }
         }
         return temp;
      }
      
      public function getByNameFriend(name:String) : FriendListPlayer
      {
         var info:FriendListPlayer = null;
         for each(info in this.recentContacts)
         {
            if(info.NickName == name)
            {
               return info;
            }
         }
         return null;
      }
      
      public function deleteRecentContact(id:int) : void
      {
         this.recentContacts.remove(id);
      }
      
      public function get friendAndCustomTitle() : Array
      {
         var title:FriendListPlayer = null;
         var _titleList:Array = [];
         var len:int = int(this.customList.length);
         for(var i:int = 0; i < len - 1; i++)
         {
            title = new FriendListPlayer();
            title.type = 0;
            title.titleType = this.customList[i].ID;
            title.titleIsSelected = false;
            title.titleNumText = "[" + String(this.getOnlineFriendForCustom(this.customList[i].ID).length) + "]";
            title.titleText = this.customList[i].Name;
            _titleList.push(title);
         }
         return _titleList;
      }
      
      public function get onlineFriendList() : Array
      {
         var i:FriendListPlayer = null;
         var temp:Array = [];
         for each(i in this.friendList)
         {
            if(i.playerState.StateID != PlayerState.OFFLINE)
            {
               temp.push(i);
            }
         }
         return temp;
      }
      
      public function getOnlineFriendForCustom(relation:int) : Array
      {
         var i:FriendListPlayer = null;
         var temp:Array = [];
         for each(i in this.friendList)
         {
            if(i.playerState.StateID != PlayerState.OFFLINE && i.Relation == relation)
            {
               temp.push(i);
            }
         }
         return temp;
      }
      
      public function get offlineFriendList() : Array
      {
         var i:FriendListPlayer = null;
         var temp:Array = [];
         for each(i in this.friendList)
         {
            if(i.playerState.StateID == PlayerState.OFFLINE)
            {
               temp.push(i);
            }
         }
         return temp;
      }
      
      public function getOfflineFriendForCustom(relation:int) : Array
      {
         var i:FriendListPlayer = null;
         var temp:Array = [];
         for each(i in this.friendList)
         {
            if(i.playerState.StateID == PlayerState.OFFLINE && i.Relation == relation)
            {
               temp.push(i);
            }
         }
         return temp;
      }
      
      public function get onlineMyAcademyPlayers() : Array
      {
         var i:PlayerInfo = null;
         var temp:Array = [];
         for each(i in this._myAcademyPlayers)
         {
            if(i.playerState.StateID != PlayerState.OFFLINE)
            {
               temp.push(i as FriendListPlayer);
            }
         }
         return temp;
      }
      
      public function get offlineMyAcademyPlayers() : Array
      {
         var i:PlayerInfo = null;
         var temp:Array = [];
         for each(i in this._myAcademyPlayers)
         {
            if(i.playerState.StateID == PlayerState.OFFLINE)
            {
               temp.push(i as FriendListPlayer);
            }
         }
         return temp;
      }
      
      public function set blackList(value:DictionaryData) : void
      {
         this._blackList[this._self.ZoneID] = value;
      }
      
      public function get blackList() : DictionaryData
      {
         if(this._blackList[this._self.ZoneID] == null)
         {
            this._blackList[PlayerManager.Instance.Self.ZoneID] = new DictionaryData();
         }
         return this._blackList[this._self.ZoneID];
      }
      
      public function get CMFriendList() : DictionaryData
      {
         return this._cmFriendList;
      }
      
      public function set CMFriendList(value:DictionaryData) : void
      {
         this._cmFriendList = value;
      }
      
      public function get PlayCMFriendList() : Array
      {
         if(Boolean(this._cmFriendList))
         {
            return this._cmFriendList.filter("IsExist",true);
         }
         return [];
      }
      
      public function get UnPlayCMFriendList() : Array
      {
         if(Boolean(this._cmFriendList))
         {
            return this._cmFriendList.filter("IsExist",false);
         }
         return [];
      }
      
      private function __updatePrivateInfo(e:CrazyTankSocketEvent) : void
      {
         this._self.beginChanges();
         this._self.Money = e.pkg.readInt();
         this._self.BandMoney = e.pkg.readInt();
         e.pkg.readInt();
         this._self.Score = e.pkg.readInt();
         this._self.Gold = e.pkg.readInt();
         this._self.badLuckNumber = e.pkg.readInt();
         this._self.damageScores = e.pkg.readInt();
         if(ServerConfigManager.instance.petScoreEnable)
         {
            this._self.petScore = e.pkg.readInt();
         }
         this._self.myHonor = e.pkg.readInt();
         this._self.hardCurrency = e.pkg.readInt();
         this._self.commitChanges();
      }
      
      public function get hasTempStyle() : Boolean
      {
         return this.tempStyle.length > 0;
      }
      
      public function isChangeStyleTemp(id:int) : Boolean
      {
         return Boolean(this.changedStyle.hasOwnProperty(id)) && this.changedStyle[id] != null;
      }
      
      public function setStyleTemply(tempPlayerStyle:Object) : void
      {
         var player:PlayerInfo = this.findPlayer(tempPlayerStyle.ID);
         if(Boolean(player))
         {
            this.storeTempStyle(player);
            player.beginChanges();
            player.Sex = tempPlayerStyle.Sex;
            player.Hide = tempPlayerStyle.Hide;
            player.Style = tempPlayerStyle.Style;
            player.Colors = tempPlayerStyle.Colors;
            player.Skin = tempPlayerStyle.Skin;
            player.commitChanges();
         }
      }
      
      private function storeTempStyle(player:PlayerInfo) : void
      {
         var o:Object = new Object();
         o.Style = player.getPrivateStyle();
         o.Hide = player.Hide;
         o.Sex = player.Sex;
         o.Skin = player.Skin;
         o.Colors = player.Colors;
         o.ID = player.ID;
         this.tempStyle.push(o);
      }
      
      public function readAllTempStyleEvent() : void
      {
         var player:PlayerInfo = null;
         for(var i:int = 0; i < this.tempStyle.length; i++)
         {
            player = this.findPlayer(this.tempStyle[i].ID);
            if(Boolean(player))
            {
               player.beginChanges();
               player.Sex = this.tempStyle[i].Sex;
               player.Hide = this.tempStyle[i].Hide;
               player.Style = this.tempStyle[i].Style;
               player.Colors = this.tempStyle[i].Colors;
               player.Skin = this.tempStyle[i].Skin;
               player.commitChanges();
            }
         }
         this.tempStyle = [];
         this.changedStyle.clear();
      }
      
      private function __readTempStyle(evt:CrazyTankSocketEvent) : void
      {
         var o:Object = null;
         var pkg:PackageIn = evt.pkg;
         var len:int = pkg.readInt();
         for(var i:int = 0; i < len; i++)
         {
            o = new Object();
            o.Style = pkg.readUTF();
            o.Hide = pkg.readInt();
            o.Sex = pkg.readBoolean();
            o.Skin = pkg.readUTF();
            o.Colors = pkg.readUTF();
            o.ID = pkg.readInt();
            this.setStyleTemply(o);
            this.changedStyle.add(o.ID,o);
         }
      }
      
      private function __updatePlayerInfo(evt:CrazyTankSocketEvent) : void
      {
         var info:PlayerInfo;
         var pkg:PackageIn = null;
         var style:String = null;
         var arm:String = null;
         var offHand:String = null;
         var unknown1:int = 0;
         var unknown2:int = 0;
         var unknown3:int = 0;
         var len:int = 0;
         var n:int = 0;
         var gradeId:int = 0;
         var mapId:int = 0;
         var flag:int = 0;
         if(Boolean(RoomManager.Instance.current))
         {
            if(RoomManager.Instance.isTransnationalFight())
            {
               return;
            }
         }
         if(FightFootballTimeManager.instance.isInLoading)
         {
            return;
         }
         info = this.findPlayer(evt.pkg.clientId);
         if(Boolean(info))
         {
            info.beginChanges();
            try
            {
               pkg = evt.pkg;
               info.GP = pkg.readInt();
               info.Offer = pkg.readInt();
               info.RichesOffer = pkg.readInt();
               info.RichesRob = pkg.readInt();
               info.WinCount = pkg.readInt();
               info.TotalCount = pkg.readInt();
               info.EscapeCount = pkg.readInt();
               info.Attack = pkg.readInt();
               info.Defence = pkg.readInt();
               info.Agility = pkg.readInt();
               info.Luck = pkg.readInt();
               info.MagicAttack = pkg.readInt();
               info.MagicDefence = pkg.readInt();
               info.hp = pkg.readInt();
               if(!this.isChangeStyleTemp(info.ID))
               {
                  info.Hide = pkg.readInt();
               }
               else
               {
                  pkg.readInt();
               }
               style = pkg.readUTF();
               if(!this.isChangeStyleTemp(info.ID))
               {
                  if(Boolean(GameManager.Instance.Current) && GameManager.Instance.Current.roomType == FightFootballTimeManager.FIGHTFOOTBALLTIME_ROOM)
                  {
                     this.fightFootballStyle = style;
                  }
                  else
                  {
                     info.Style = style;
                  }
               }
               arm = style.split(",")[6].split("|")[0];
               offHand = style.split(",")[10].split("|")[0];
               if(arm == "-1" || arm == "0")
               {
                  info.WeaponID = -1;
               }
               else
               {
                  info.WeaponID = int(arm);
               }
               if(offHand == "0" || offHand == "")
               {
                  info.DeputyWeaponID = -1;
               }
               else
               {
                  info.DeputyWeaponID = int(offHand);
               }
               if(!this.isChangeStyleTemp(info.ID))
               {
                  info.Colors = pkg.readUTF();
                  info.Skin = pkg.readUTF();
               }
               else
               {
                  pkg.readUTF();
                  pkg.readUTF();
               }
               info.IsShowConsortia = pkg.readBoolean();
               info.ConsortiaID = pkg.readInt();
               info.ConsortiaName = pkg.readUTF();
               info.badgeID = pkg.readInt();
               unknown1 = pkg.readInt();
               unknown2 = pkg.readInt();
               info.Nimbus = pkg.readInt();
               info.PvePermission = pkg.readUTF();
               info.fightLibMission = pkg.readUTF();
               info.FightPower = pkg.readInt();
               if(info.isSelf)
               {
                  this._fightPower = info.FightPower;
                  if(PowerUpMovieManager.isCanPlayMovie && StateManager.currentStateType != StateType.FIGHTING)
                  {
                     if(info.FightPower < PowerUpMovieManager.powerNum)
                     {
                        if(!this._timer2.hasEventListener(TimerEvent.TIMER))
                        {
                           this._timer2.addEventListener(TimerEvent.TIMER,this.__onTimer2Handler);
                           this._timer2.start();
                        }
                     }
                     if(info.FightPower > PowerUpMovieManager.powerNum)
                     {
                        if(!this._timer1.hasEventListener(TimerEvent.TIMER))
                        {
                           this._timer1.addEventListener(TimerEvent.TIMER,this.__onTimer1Handler);
                           this._timer1.start();
                        }
                     }
                  }
               }
               info.apprenticeshipState = pkg.readInt();
               info.masterID = pkg.readInt();
               info.setMasterOrApprentices(pkg.readUTF());
               info.graduatesCount = pkg.readInt();
               info.honourOfMaster = pkg.readUTF();
               info.AchievementPoint = pkg.readInt();
               info.honor = pkg.readUTF();
               info.honorId = pkg.readInt();
               info.LastSpaDate = pkg.readDate();
               info.charmGP = pkg.readInt();
               unknown3 = pkg.readInt();
               info.shopFinallyGottenTime = pkg.readDate();
               info.UseOffer = pkg.readInt();
               info.matchInfo.dailyScore = pkg.readInt();
               info.matchInfo.dailyWinCount = pkg.readInt();
               info.matchInfo.dailyGameCount = pkg.readInt();
               info.matchInfo.weeklyScore = pkg.readInt();
               info.matchInfo.weeklyGameCount = pkg.readInt();
               info.leagueMoney = pkg.readInt();
               info.spdTexpExp = pkg.readInt();
               info.attTexpExp = pkg.readInt();
               info.defTexpExp = pkg.readInt();
               info.hpTexpExp = pkg.readInt();
               info.lukTexpExp = pkg.readInt();
               info.texpTaskCount = pkg.readInt();
               info.texpCount = pkg.readInt();
               info.texpTaskDate = pkg.readDate();
               len = pkg.readInt();
               for(n = 0; n < len; n++)
               {
                  mapId = pkg.readInt();
                  flag = pkg.readByte();
                  info.dungeonFlag[mapId] = flag;
               }
               info.PveEpicPermission = pkg.readUTF();
               gradeId = pkg.readInt();
               info.evolutionGrade = gradeId;
               info.evolutionExp = pkg.readInt();
            }
            finally
            {
               info.commitChanges();
            }
         }
      }
      
      protected function __onTimer1Handler(event:TimerEvent) : void
      {
         this._timer1.stop();
         this._timer1.removeEventListener(TimerEvent.TIMER,this.__onTimer1Handler);
         PowerUpMovieManager.addedPowerNum = this._fightPower - PowerUpMovieManager.powerNum;
         if(BagAndInfoManager.Instance.getBagAndGiftFrame() && (BagAndInfoManager.Instance.getBagAndGiftFrame().btnGroup.selectIndex == 0 || BagAndInfoManager.Instance.getBagAndGiftFrame().btnGroup.selectIndex == 6 || BagAndInfoManager.Instance.getBagAndGiftFrame().btnGroup.selectIndex == 8) || BagStore.instance.isInBagStoreFrame)
         {
            PowerUpMovieManager.powerNum = this._fightPower;
         }
         else
         {
            PowerUpMovieManager.Instance.dispatchEvent(new Event(PowerUpMovieManager.POWER_UP));
         }
      }
      
      protected function __onTimer2Handler(event:TimerEvent) : void
      {
         this._timer2.stop();
         this._timer2.removeEventListener(TimerEvent.TIMER,this.__onTimer2Handler);
         PowerUpMovieManager.powerNum = this._fightPower;
      }
      
      public function getDeputyWeaponIcon(deputyWeapon:InventoryItemInfo, type:int = 0) : DisplayObject
      {
         var cell:BagCell = null;
         if(Boolean(deputyWeapon))
         {
            cell = new BagCell(deputyWeapon.Place,deputyWeapon);
            if(type == 0)
            {
               return cell.getContent();
            }
            if(type == 1)
            {
               return cell.getSmallContent();
            }
         }
         return null;
      }
      
      public function getDeputyWeaponIconByBg(deputyWeapon:InventoryItemInfo, type:int = 0) : DisplayObject
      {
         var bgBitmap:Bitmap = null;
         var cell:BagCell = null;
         if(Boolean(deputyWeapon))
         {
            bgBitmap = ComponentFactory.Instance.creatBitmap("bagAndInfo.cell.bagCellBgAsset");
            bgBitmap.width = 44;
            bgBitmap.height = 44;
            cell = new BagCell(deputyWeapon.Place,deputyWeapon,true,bgBitmap);
            if(type == 0)
            {
               return cell.getContent();
            }
            if(type == 1)
            {
               return cell.getSmallContent();
            }
         }
         return null;
      }
      
      private function __dailyAwardHandler(evt:CrazyTankSocketEvent) : void
      {
         var bool:Boolean = evt.pkg.readBoolean();
         var getWay:int = evt.pkg.readInt();
         if(getWay == 0)
         {
            CalendarManager.getInstance().setDailyAwardState(bool);
            MainButtnController.instance.DailyAwardState = bool;
         }
         else if(getWay != 1)
         {
            if(getWay != 2)
            {
               if(getWay == 6)
               {
                  CalendarManager.getInstance().times = evt.pkg.readInt();
               }
            }
         }
      }
      
      public function get checkEnterDungeon() : Boolean
      {
         if(Instance.Self.Grade < GameManager.MinLevelDuplicate)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.manager.PlayerManager.gradeLow",GameManager.MinLevelDuplicate));
            return false;
         }
         return true;
      }
      
      public function __checkCodePopup(e:CrazyTankSocketEvent) : void
      {
         var readComplete:Function = null;
         var type:int = 0;
         var msg:String = null;
         var checkCodeData:CheckCodeData = null;
         var ba:ByteArray = null;
         var bitmapReader:BitmapReader = null;
         readComplete = function(e:Event):void
         {
            checkCodeData.pic = bitmapReader.bitmap;
            CheckCodeFrame.Instance.data = checkCodeData;
         };
         var checkCodeState:int = e.pkg.readByte();
         var backType:Boolean = e.pkg.readBoolean();
         if(checkCodeState == 1)
         {
            SoundManager.instance.play("058");
         }
         else if(checkCodeState == 2)
         {
            SoundManager.instance.play("057");
         }
         if(backType)
         {
            type = e.pkg.readByte();
            if(type == 1)
            {
               CheckCodeFrame.Instance.time = 11;
            }
            else
            {
               CheckCodeFrame.Instance.time = 20;
            }
            msg = e.pkg.readUTF();
            CheckCodeFrame.Instance.tip = msg;
            checkCodeData = new CheckCodeData();
            ba = new ByteArray();
            e.pkg.readBytes(ba,0,e.pkg.bytesAvailable);
            bitmapReader = new BitmapReader();
            bitmapReader.addEventListener(Event.COMPLETE,readComplete);
            bitmapReader.readByteArray(ba);
            CheckCodeFrame.Instance.isShowed = false;
            CheckCodeFrame.Instance.show();
            return;
         }
         CheckCodeFrame.Instance.close();
      }
      
      private function __buffObtain(evt:CrazyTankSocketEvent) : void
      {
         var type:int = 0;
         var isExist:Boolean = false;
         var beginData:Date = null;
         var validDate:int = 0;
         var value:int = 0;
         var validCount:int = 0;
         var TemplateID:int = 0;
         var buff:BuffInfo = null;
         var pkg:PackageIn = evt.pkg;
         if(pkg.clientId != this._self.ID)
         {
            return;
         }
         this._self.clearBuff();
         var lth:int = pkg.readInt();
         for(var i:int = 0; i < lth; i++)
         {
            type = pkg.readInt();
            isExist = pkg.readBoolean();
            beginData = pkg.readDate();
            validDate = pkg.readInt();
            value = pkg.readInt();
            validCount = pkg.readInt();
            TemplateID = pkg.readInt();
            buff = new BuffInfo(type,isExist,beginData,validDate,value,validCount,TemplateID);
            this._self.addBuff(buff);
         }
         evt.stopImmediatePropagation();
      }
      
      private function __buffUpdate(evt:CrazyTankSocketEvent) : void
      {
         var type:int = 0;
         var isExist:Boolean = false;
         var beginData:Date = null;
         var validDate:int = 0;
         var value:int = 0;
         var validCount:int = 0;
         var TemplateID:int = 0;
         var buff:BuffInfo = null;
         var pkg:PackageIn = evt.pkg;
         if(pkg.clientId != this._self.ID)
         {
            return;
         }
         var len:int = pkg.readInt();
         for(var i:uint = 0; i < len; i++)
         {
            type = pkg.readInt();
            isExist = pkg.readBoolean();
            beginData = pkg.readDate();
            validDate = pkg.readInt();
            value = pkg.readInt();
            validCount = pkg.readInt();
            TemplateID = pkg.readInt();
            buff = new BuffInfo(type,isExist,beginData,validDate,value,validCount,TemplateID);
            if(type == BuffInfo.Save_Life)
            {
               buff.additionCount = KingBlessManager.instance.getOneBuffData(KingBlessManager.HELP_STRAW);
            }
            if(isExist)
            {
               this._self.addBuff(buff);
            }
            else
            {
               this._self.buffInfo.remove(buff.Type);
            }
         }
         evt.stopImmediatePropagation();
      }
      
      public function findPlayerByNickName(info:PlayerInfo, nickName:String) : PlayerInfo
      {
         var playerInfo:PlayerInfo = null;
         var player:PlayerInfo = null;
         if(Boolean(nickName))
         {
            if(this._tempList[this._self.ZoneID] == null)
            {
               this._tempList[this._self.ZoneID] = new DictionaryData();
            }
            for each(playerInfo in this._friendList[this._self.ZoneID])
            {
               if(playerInfo.NickName == nickName)
               {
                  return playerInfo;
               }
            }
            if(this._tempList[this._self.ZoneID][nickName] != null)
            {
               return this._tempList[this._self.ZoneID][nickName] as PlayerInfo;
            }
            for each(player in this._tempList[this._self.ZoneID])
            {
               if(player.NickName == nickName)
               {
                  return player;
               }
            }
            info.NickName = nickName;
            this._tempList[this._self.ZoneID][nickName] = info;
            return info;
         }
         return info;
      }
      
      public function findPlayer(id:int, zoneID:int = -1, nickName:String = "") : PlayerInfo
      {
         var tempInfo:PlayerInfo = null;
         var player:PlayerInfo = null;
         var player1:PlayerInfo = null;
         if(zoneID == -1 || zoneID == this._self.ZoneID)
         {
            if(this._friendList[this._self.ZoneID] == null)
            {
               this._friendList[this._self.ZoneID] = new DictionaryData();
            }
            if(this._clubPlays[this._self.ZoneID] == null)
            {
               this._clubPlays[this._self.ZoneID] = new DictionaryData();
            }
            if(this._tempList[this._self.ZoneID] == null)
            {
               this._tempList[this._self.ZoneID] = new DictionaryData();
            }
            if(this._myAcademyPlayers == null)
            {
               this._myAcademyPlayers = new DictionaryData();
            }
            if(id == this._self.ID && (zoneID == -1 || zoneID == this._self.ZoneID))
            {
               return this._self;
            }
            if(Boolean(this._friendList[this._self.ZoneID][id]))
            {
               return this._friendList[this._self.ZoneID][id];
            }
            if(Boolean(this._clubPlays[this._self.ZoneID][id]))
            {
               return this._clubPlays[this._self.ZoneID][id];
            }
            if(Boolean(this._tempList[this._self.ZoneID][nickName]))
            {
               return this._tempList[this._self.ZoneID][nickName];
            }
            if(Boolean(this._myAcademyPlayers[id]))
            {
               return this._myAcademyPlayers[id];
            }
            if(Boolean(this._tempList[this._self.ZoneID][id]))
            {
               if(Boolean(this._tempList[this._self.ZoneID][this._tempList[this._self.ZoneID][id].NickName]))
               {
                  return this._tempList[this._self.ZoneID][this._tempList[this._self.ZoneID][id].NickName];
               }
               return this._tempList[this._self.ZoneID][id];
            }
            for each(tempInfo in this._tempList[this._self.ZoneID])
            {
               if(tempInfo.ID == id)
               {
                  this._tempList[this._self.ZoneID][id] = tempInfo;
                  return tempInfo;
               }
            }
            player = new PlayerInfo();
            player.ID = id;
            player.ZoneID = this._self.ZoneID;
            this._tempList[this._self.ZoneID][id] = player;
            return player;
         }
         if(id == this._self.ID && (zoneID == this._self.ZoneID || this._self.ZoneID == 0))
         {
            return this._self;
         }
         if(Boolean(this._friendList[zoneID]) && Boolean(this._friendList[zoneID][id]))
         {
            return this._friendList[zoneID][id];
         }
         if(Boolean(this._clubPlays[zoneID]) && Boolean(this._clubPlays[zoneID][id]))
         {
            return this._clubPlays[zoneID][id];
         }
         if(Boolean(this._tempList[zoneID]) && Boolean(this._tempList[zoneID][id]))
         {
            return this._tempList[zoneID][id];
         }
         player1 = new PlayerInfo();
         player1.ID = id;
         player1.ZoneID = zoneID;
         if(this._tempList[zoneID] == null)
         {
            this._tempList[zoneID] = new DictionaryData();
         }
         this._tempList[zoneID][id] = player1;
         return player1;
      }
      
      public function hasInMailTempList(id:int) : Boolean
      {
         if(this._mailTempList[this._self.ZoneID] == null)
         {
            this._mailTempList[this._self.ZoneID] = new DictionaryData();
         }
         if(Boolean(this._mailTempList[this._self.ZoneID][id]))
         {
            return true;
         }
         return false;
      }
      
      public function set mailTempList(value:DictionaryData) : void
      {
         if(this._mailTempList == null)
         {
            this._mailTempList = new DictionaryData();
         }
         if(this._mailTempList[this._self.ZoneID] == null)
         {
            this._mailTempList[this._self.ZoneID] = new DictionaryData();
         }
         this._mailTempList[this._self.ZoneID] = value;
      }
      
      public function hasInFriendList(id:int) : Boolean
      {
         if(this._friendList[this._self.ZoneID] == null)
         {
            this._friendList[this._self.ZoneID] = new DictionaryData();
         }
         if(Boolean(this._friendList[this._self.ZoneID][id]))
         {
            return true;
         }
         return false;
      }
      
      public function hasInClubPlays(id:int) : Boolean
      {
         if(this._clubPlays[this._self.ZoneID] == null)
         {
            this._clubPlays[this._self.ZoneID] = new DictionaryData();
         }
         if(Boolean(this._clubPlays[this._self.ZoneID][id]))
         {
            return true;
         }
         return false;
      }
      
      private function __selfPopChange(e:PlayerPropertyEvent) : void
      {
         if(Boolean(e.changedProperties["TotalCount"]))
         {
            switch(PlayerManager.Instance.Self.TotalCount)
            {
               case 1:
                  StatisticManager.Instance().startAction("gameOver1","yes");
                  break;
               case 3:
                  StatisticManager.Instance().startAction("gameOver3","yes");
                  break;
               case 5:
                  StatisticManager.Instance().startAction("gameOver5","yes");
                  break;
               case 10:
                  StatisticManager.Instance().startAction("gameOver10","yes");
            }
         }
         if(Boolean(e.changedProperties["Grade"]))
         {
            if(this.isReportGameProfile)
            {
               this.reportGameProfile();
            }
            TaskManager.instance.requestCanAcceptTask();
         }
      }
      
      private function reportGameProfile() : void
      {
      }
      
      private function __updatePet(event:CrazyTankSocketEvent) : void
      {
         var place:int = 0;
         var isUpdate:Boolean = false;
         var pid:int = 0;
         var ptid:int = 0;
         var p:PetInfo = null;
         var skillCount:int = 0;
         var k:int = 0;
         var activedSkillCount:int = 0;
         var j:int = 0;
         var isEquip:Boolean = false;
         var petEquipCount:int = 0;
         var p_i:int = 0;
         var skillid:int = 0;
         var petskill:PetSkill = null;
         var splace:int = 0;
         var sid:int = 0;
         var equipData:PetEquipData = null;
         var equInfo:InventoryItemInfo = null;
         var newInfo:InventoryItemInfo = null;
         var pkg:PackageIn = event.pkg;
         var playerid:int = pkg.readInt();
         var zoneId:int = pkg.readInt();
         var info:PlayerInfo = this.findPlayer(playerid,zoneId);
         info.ID = playerid;
         var count:int = pkg.readInt();
         for(var i:int = 0; i < count; i++)
         {
            place = pkg.readInt();
            isUpdate = pkg.readBoolean();
            if(isUpdate)
            {
               pid = pkg.readInt();
               ptid = pkg.readInt();
               p = new PetInfo();
               p.TemplateID = ptid;
               p.ID = pid;
               PetInfoManager.fillPetInfo(p);
               p.Name = pkg.readUTF();
               p.UserID = pkg.readInt();
               p.Attack = pkg.readInt();
               p.Defence = pkg.readInt();
               p.Luck = pkg.readInt();
               p.Agility = pkg.readInt();
               p.Blood = pkg.readInt();
               p.Damage = pkg.readInt();
               p.Guard = pkg.readInt();
               p.AttackGrow = pkg.readInt();
               p.DefenceGrow = pkg.readInt();
               p.LuckGrow = pkg.readInt();
               p.AgilityGrow = pkg.readInt();
               p.BloodGrow = pkg.readInt();
               p.DamageGrow = pkg.readInt();
               p.GuardGrow = pkg.readInt();
               p.Level = pkg.readInt();
               p.GP = pkg.readInt();
               p.MaxGP = pkg.readInt();
               p.Hunger = pkg.readInt();
               p.PetHappyStar = pkg.readInt();
               p.MP = pkg.readInt();
               p.clearSkills();
               p.clearEquipedSkills();
               skillCount = pkg.readInt();
               for(k = 0; k < skillCount; k++)
               {
                  skillid = pkg.readInt();
                  petskill = new PetSkill(skillid);
                  p.addSkill(petskill);
                  pkg.readInt();
               }
               activedSkillCount = pkg.readInt();
               for(j = 0; j < activedSkillCount; j++)
               {
                  splace = pkg.readInt();
                  sid = pkg.readInt();
                  p.equipdSkills.add(splace,sid);
               }
               isEquip = pkg.readBoolean();
               p.IsEquip = isEquip;
               p.Place = place;
               info.pets.add(p.Place,p);
               petEquipCount = pkg.readInt();
               for(p_i = 0; p_i < petEquipCount; p_i++)
               {
                  equipData = new PetEquipData();
                  equipData.eqType = pkg.readInt();
                  equipData.eqTemplateID = pkg.readInt();
                  equipData.startTime = pkg.readDateString();
                  equipData.ValidDate = pkg.readInt();
                  equInfo = new InventoryItemInfo();
                  equInfo.TemplateID = equipData.eqTemplateID;
                  equInfo.ValidDate = equipData.ValidDate;
                  equInfo.BeginDate = equipData.startTime;
                  equInfo.IsBinds = true;
                  equInfo.IsUsed = true;
                  equInfo.Place = equipData.eqType;
                  newInfo = ItemManager.fill(equInfo) as InventoryItemInfo;
                  p.equipList.add(newInfo.Place,newInfo);
                  if(Boolean(PetBagController.instance().view) && Boolean(PetBagController.instance().view.parent))
                  {
                     PetBagController.instance().view.addPetEquip(newInfo);
                  }
               }
               p.currentStarExp = pkg.readInt();
            }
            else
            {
               info.pets.remove(place);
            }
            info.commitChanges();
         }
      }
      
      private function __updateOneKeyFinish(event:CrazyTankSocketEvent) : void
      {
         var pkg:PackageIn = event.pkg;
         this._self.uesedFinishTime = pkg.readInt();
      }
      
      public function get isReportGameProfile() : Boolean
      {
         return this._isReportGameProfile;
      }
      
      public function set isReportGameProfile(value:Boolean) : void
      {
         this._isReportGameProfile = value;
      }
   }
}

