package ddt.data.player
{
   import com.hurlant.util.Base64;
   import com.pickgliss.utils.ObjectUtils;
   
   import flash.events.TimerEvent;
   import flash.utils.ByteArray;
   import flash.utils.Dictionary;
   import flash.utils.Timer;
   
   import cardSystem.data.CardInfo;
   
   import ddt.data.BagInfo;
   import ddt.data.BuffInfo;
   import ddt.data.ConsortiaInfo;
   import ddt.data.EquipType;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.events.BagEvent;
   import ddt.manager.ChatManager;
   import ddt.manager.ExternalInterfaceManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PVEMapPermissionManager;
   import ddt.manager.PathManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.ServerManager;
   import ddt.manager.SharedManager;
   import ddt.manager.SocketManager;
   import ddt.manager.TimeManager;
   import ddt.utils.GoodUtils;
   import ddt.view.buff.BuffControl;
   import ddt.view.chat.ChatData;
   import ddt.view.chat.ChatInputView;
   import ddt.view.goods.AddPricePanel;
   
   import road7th.data.DictionaryData;
   import road7th.data.DictionaryEvent;
   
   import trainer.controller.WeakGuildManager;
   import trainer.data.Step;
   
   public class SelfInfo extends PlayerInfo
   {
      
      public static const PET:String = "Pets";
      
      private static const buffScanTime:int = 60;
      
      public var CivilPlayerList:Array = new Array();
      
      private var _timer:Timer;
      
      private var _questionOne:String;
      
      private var _questionTwo:String;
      
      private var _leftTimes:int = 5;
      
      public var IsNovice:Boolean;
      
      public var rid:String;
      
      public var _hasPopupLeagueNotice:Boolean;
      
      public var scoreArr:Array = [];
      
      public var isViewOther:Boolean = false;
      
      public var baiduEnterCode:String;
      
      public var IsGotRing:Boolean;
      
      private var _marryInfoID:int;
      
      private var _civilIntroduction:String;
      
      private var _isPublishEquit:Boolean;
      
      private var _bagPwdState:Boolean;
      
      private var _bagLocked:Boolean;
      
      private var _shouldPassword:Boolean;
      
      public var IsBanChat:Boolean;
      
      public var _props:DictionaryData;
      
      private var _isFirst:int;
      
      private var FirstLoaded:Boolean = false;
      
      private var _questList:Array;
      
      public var PropBag:BagInfo;
      
      public var FightBag:BagInfo;
      
      public var TempBag:BagInfo;
      
      public var ConsortiaBag:BagInfo;
      
      public var CaddyBag:BagInfo;
      
      public var farmBag:BagInfo;
      
      public var vegetableBag:BagInfo;
      
      public var magicStoneBag:BagInfo;
      
      public var MagicHouseBag:BagInfo;
      
      private var _overtimeList:Array;
      
      private var sendedGrade:Array = [];
      
      public var StoreBag:BagInfo;
      
      private var _weaklessGuildProgress:ByteArray;
      
      public var _canTakeVipReward:Boolean;
      
      private var _VIPExpireDay:Object;
      
      public var LastDate:Object;
      
      public var isOldPlayerHasValidEquitAtLogin:Boolean;
      
      private var _vipNextLevelDaysNeeded:int;
      
      public var systemDate:Object;
      
      private var _consortiaInfo:ConsortiaInfo;
      
      private var _energy:int;
      
      private var _buyEnergyCount:int;
      
      private var _gold:Number;
      
      private var _money:Number;
      
      private var _bandMoney:Number = 0;
      
      private var _uesedFinishTime:int;
      
      private var _cardInfo:CardInfo;
      
      private var _isFarmHelper:Boolean;
      
      private var _petScore:Number = 0;
      
      private var _coin:int;
      
      private var _LastServerId:int = -1;
      
      private var _myHonor:int;
      
      private var _totalCharge:int;
      
      public function SelfInfo()
      {
         super();
         this.PropBag = new BagInfo(BagInfo.PROPBAG,48);
         this.FightBag = new BagInfo(BagInfo.FIGHTBAG,48);
         this.TempBag = new BagInfo(BagInfo.TEMPBAG,48);
         this.ConsortiaBag = new BagInfo(BagInfo.CONSORTIA,100);
         this.StoreBag = new BagInfo(BagInfo.STOREBAG,11);
         this.CaddyBag = new BagInfo(BagInfo.CADDYBAG,99);
         this.farmBag = new BagInfo(BagInfo.FARM,100);
         this.vegetableBag = new BagInfo(BagInfo.VEGETABLE,100);
         this.magicStoneBag = new BagInfo(BagInfo.MAGICSTONE,142);
         this.MagicHouseBag = new BagInfo(BagInfo.MAGICHOUSE,100);
         _isSelf = true;
      }
      
      override public function set NickName(value:String) : void
      {
         super.NickName = value;
      }
      
      public function set MarryInfoID(value:int) : void
      {
         this._marryInfoID = value;
         onPropertiesChanged("MarryInfoID");
      }
      
      public function get MarryInfoID() : int
      {
         return this._marryInfoID;
      }
      
      public function set Introduction(value:String) : void
      {
         this._civilIntroduction = value;
         onPropertiesChanged("Introduction");
      }
      
      public function get Introduction() : String
      {
         if(this._civilIntroduction == null)
         {
            this._civilIntroduction = "";
         }
         return this._civilIntroduction;
      }
      
      public function set IsPublishEquit(value:Boolean) : void
      {
         this._isPublishEquit = value;
         onPropertiesChanged("IsPublishEquit");
      }
      
      public function get IsPublishEquit() : Boolean
      {
         return this._isPublishEquit;
      }
      
      public function set bagPwdState($bagpwdstate:Boolean) : void
      {
         this._bagPwdState = $bagpwdstate;
      }
      
      public function get bagPwdState() : Boolean
      {
         return this._bagPwdState;
      }
      
      public function set bagLocked(b:Boolean) : void
      {
         this._bagLocked = b;
         onPropertiesChanged("bagLocked");
      }
      
      public function get bagLocked() : Boolean
      {
         if(!this._bagPwdState)
         {
            return false;
         }
         return this._bagLocked;
      }
      
      public function get shouldPassword() : Boolean
      {
         return this._shouldPassword;
      }
      
      public function set shouldPassword(value:Boolean) : void
      {
         this._shouldPassword = value;
      }
      
      public function onReceiveTypes(value:String) : void
      {
         dispatchEvent(new BagEvent(value,new Dictionary()));
      }
      
      public function resetProps() : void
      {
         this._props = new DictionaryData();
      }
      
      public function findOvertimeItems(lefttime:Number = 0) : Array
      {
         return this.getOverdueItems();
      }
      
      public function getOverdueItems() : Array
      {
         var betoArr:Array = [];
         var hasArr:Array = [];
         var bagA:Array = GoodUtils.getOverdueItemsFrom(this.PropBag.items);
         var bagB:Array = GoodUtils.getOverdueItemsFrom(this.FightBag.items);
         var bagC:Array = GoodUtils.getOverdueItemsFrom(Bag.items);
         var body:Array = GoodUtils.getOverdueItemsFrom(this.ConsortiaBag.items);
         betoArr = betoArr.concat(bagA[0],bagB[0],[],bagC[0]);
         hasArr = hasArr.concat(bagA[1],bagB[1],[],bagC[1]);
         return [betoArr,hasArr];
      }
      
      public function set IsFirst(b:int) : void
      {
         this._isFirst = b;
         if(this._isFirst == 1)
         {
            this.initIsFirst();
         }
      }
      
      public function get IsFirst() : int
      {
         return this._isFirst;
      }
      
      private function initIsFirst() : void
      {
         SharedManager.Instance.isWorldBossBuyBuff = false;
         SharedManager.Instance.isWorldBossBindBuyBuff = false;
         SharedManager.Instance.isWorldBossBuyBuffFull = false;
         SharedManager.Instance.isWorldBossBindBuyBuffFull = false;
         SharedManager.Instance.isRefreshPet = false;
         SharedManager.Instance.isResurrect = false;
         SharedManager.Instance.isReFight = false;
         SharedManager.Instance.save();
      }
      
      public function findItemCount(tempId:int, LimitValue:int = -1) : int
      {
         return Bag.getLimitSLItemCountByTemplateId(tempId,LimitValue);
      }
      
      public function loadPlayerItem() : void
      {
      }
      
      public function loadRelatedPlayersInfo() : void
      {
         if(this.FirstLoaded)
         {
            return;
         }
         this.FirstLoaded = true;
      }
      
      private function loadBodyThingComplete(itemData:DictionaryData, buffData:DictionaryData) : void
      {
         var i:InventoryItemInfo = null;
         var j:BuffInfo = null;
         for each(i in itemData)
         {
            Bag.addItem(i);
         }
         for each(j in buffData)
         {
            super.addBuff(j);
         }
      }
      
      public function getPveMapPermission(mapid:int, level:int) : Boolean
      {
         return PVEMapPermissionManager.Instance.getPermission(mapid,level,PvePermission);
      }
      
      public function canEquip(info:InventoryItemInfo) : Boolean
      {
         if(!EquipType.canEquip(info))
         {
            if(!isNaN(info.CategoryID))
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.data.player.SelfInfo.this"));
            }
         }
         else if(info.getRemainDate() <= 0)
         {
            AddPricePanel.Instance.setInfo(info,true);
            AddPricePanel.Instance.show();
         }
         else if(info.NeedSex != 0 && info.NeedSex != (Sex ? 1 : 2))
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.data.player.SelfInfo.object"));
         }
         else
         {
            if(info.CategoryID == EquipType.HEALSTONE)
            {
               if(Grade >= int(info.Property1))
               {
                  return true;
               }
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.HealStone.ErrorGrade",info.Property1));
               return false;
            }
            if(info.NeedLevel <= Grade)
            {
               return true;
            }
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.data.player.SelfInfo.need"));
         }
         return false;
      }
      
      override public function addBuff(buff:BuffInfo) : void
      {
         super.addBuff(buff);
         if(!this._timer)
         {
            this._timer = new Timer(1000 * 60);
            this._timer.addEventListener(TimerEvent.TIMER,this.__refreshSelfInfo);
            this._timer.start();
         }
      }
      
      private function __refreshSelfInfo(evt:TimerEvent) : void
      {
         this.refreshBuff();
      }
      
      private function refreshBuff() : void
      {
         var buff:BuffInfo = null;
         var msg:ChatData = null;
         for each(buff in _buffInfo)
         {
            if(!BuffControl.isPayBuff(buff))
            {
               if(buff.ValidDate - Math.floor((TimeManager.Instance.Now().time - buff.BeginData.time) / (1000 * 60)) - 1 == buffScanTime)
               {
                  msg = new ChatData();
                  msg.channel = ChatInputView.SYS_TIP;
                  msg.msg = LanguageMgr.GetTranslation("tank.view.buffInfo.outDate",buff.buffName,buffScanTime);
                  ChatManager.Instance.chat(msg);
               }
            }
         }
      }
      
      public function achievedQuest(id:int) : Boolean
      {
         if(Boolean(this._questList) && Boolean(this._questList[id]))
         {
            return true;
         }
         return false;
      }
      
      public function unlockAllBag() : void
      {
         Bag.unLockAll();
         this.PropBag.unLockAll();
      }
      
      public function getBag(bagType:int) : BagInfo
      {
         switch(bagType)
         {
            case BagInfo.EQUIPBAG:
               return Bag;
            case BagInfo.PROPBAG:
               return this.PropBag;
            case BagInfo.FIGHTBAG:
               return this.FightBag;
            case BagInfo.TEMPBAG:
               return this.TempBag;
            case BagInfo.CONSORTIA:
               return this.ConsortiaBag;
            case BagInfo.STOREBAG:
               return this.StoreBag;
            case BagInfo.CADDYBAG:
               return this.CaddyBag;
            case BagInfo.FARM:
               return this.farmBag;
            case BagInfo.VEGETABLE:
               return this.vegetableBag;
            case BagInfo.BEADBAG:
               return BeadBag;
            case BagInfo.MAGICSTONE:
               return this.magicStoneBag;
            case BagInfo.MAGICHOUSE:
               return this.MagicHouseBag;
            default:
               return null;
         }
      }
      
      public function get questionOne() : String
      {
         return this._questionOne;
      }
      
      public function set questionOne(value:String) : void
      {
         this._questionOne = value;
      }
      
      public function get questionTwo() : String
      {
         return this._questionTwo;
      }
      
      public function set questionTwo(value:String) : void
      {
         this._questionTwo = value;
      }
      
      public function get leftTimes() : int
      {
         return this._leftTimes;
      }
      
      public function set leftTimes(value:int) : void
      {
         this._leftTimes = value;
      }
      
      public function getMedalNum() : int
      {
         var value1:int = this.PropBag.getItemCountByTemplateId(EquipType.MEDAL);
         var value2:int = this.ConsortiaBag.getItemCountByTemplateId(EquipType.MEDAL);
         return value1 + value2;
      }
      
      public function get OvertimeListByBody() : Array
      {
         return PlayerManager.Instance.Self.Bag.findOvertimeItemsByBody();
      }
      
      public function sendOverTimeListByBody() : void
      {
         var info:InventoryItemInfo = null;
         var p:* = undefined;
         var temp:Array = PlayerManager.Instance.Self.Bag.findOvertimeItemsByBodyII();
         for each(info in temp)
         {
            if(info.CategoryID == 50 || info.CategoryID == 51 || info.CategoryID == 52)
            {
               if(PlayerManager.Instance.Self.pets.length > 0)
               {
                  for(p in PlayerManager.Instance.Self.pets)
                  {
                     SocketManager.Instance.out.delPetEquip(PlayerManager.Instance.Self.pets[p].Place,info.Place);
                  }
               }
               return;
            }
            SocketManager.Instance.out.sendItemOverDue(info.BagType,info.Place);
         }
      }
      
      override public function set Grade(value:int) : void
      {
         super.Grade = value;
         if(IsUpGrade && PathManager.solveExternalInterfaceEnabel() && this.sendedGrade.indexOf(value) == -1)
         {
            ExternalInterfaceManager.sendToAgent(2,ID,NickName,ServerManager.Instance.zoneName,Grade);
            this.sendedGrade.push(Grade);
         }
      }
      
      public function get weaklessGuildProgress() : ByteArray
      {
         return this._weaklessGuildProgress;
      }
      
	  public function set weaklessGuildProgress(value:ByteArray) : void
	  {
		  this._weaklessGuildProgress = new ByteArray();
		  this._weaklessGuildProgress.writeBytes(Base64.decodeToByteArray(
			  "//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////8="
		  ));
	  }
      
      public function set weaklessGuildProgressStr(value:String) : void
      {
		  var finish:String = "//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////8=";
		  
		 this.weaklessGuildProgress = Base64.decodeToByteArray(finish);
      }
      
      public function IsWeakGuildFinish(step:int) : Boolean
      {
		  return true;
         /*
		  if(!WeakGuildManager.Instance.switchUserGuide && step != Step.GHOST_FIRST && step != Step.GHOSTPROP_FIRST && step != Step.DRESS_OPEN && step != Step.VISIT_AUCTION && step != Step.VISIT_TOFF_LIST && step != Step.CONSORTIA_CHAT)
         {
            return true;
         }
         if(!this._weaklessGuildProgress || step > this._weaklessGuildProgress.length * 8 || step < 1)
         {
            return false;
         }
         if(this.bit(Step.OLD_PLAYER) && step != Step.GHOST_FIRST && step != Step.GHOSTPROP_FIRST)
         {
            return true;
         }
         return this.bit(step);
		 */
      }
      
      public function isToffListGuideFinish(step:int) : Boolean
      {
         if(Grade > 12)
         {
            return true;
         }
         return this.bit(step);
      }
      
      public function isDungeonGuideFinish(step:int) : Boolean
      {
         if(PlayerManager.Instance.Self.Grade > 12)
         {
            return true;
         }
         return this.bit(step);
      }
      
      public function isMagicStoneGuideFinish(step:int) : Boolean
      {
         if(PlayerManager.Instance.Self.Grade > 40)
         {
            return true;
         }
         return this.bit(step);
      }
      
      public function isNewOnceFinish(step:int) : Boolean
      {
         return this.bit(step);
      }
      
      private function bit(step:int) : Boolean
      {
         step--;
         var index:int = step / 8;
         var offset:int = step % 8;
         if(!this._weaklessGuildProgress)
         {
            return false;
         }
         var result:int = this._weaklessGuildProgress[index] & 1 << offset;
         return result != 0;
      }
      
      public function get canTakeVipReward() : Boolean
      {
         return this._canTakeVipReward;
      }
      
      public function set canTakeVipReward(value:Boolean) : void
      {
         this._canTakeVipReward = value;
         onPropertiesChanged("canTakeVipReward");
      }
      
      public function get VIPExpireDay() : Object
      {
         return this._VIPExpireDay;
      }
      
      public function set VIPExpireDay(value:Object) : void
      {
         this._VIPExpireDay = value;
         onPropertiesChanged("VipExpireDay");
      }
      
      public function set VIPNextLevelDaysNeeded(value:int) : void
      {
         this._vipNextLevelDaysNeeded = value;
         onPropertiesChanged("VIPNextLevelDaysNeeded");
      }
      
      public function get VIPNextLevelDaysNeeded() : int
      {
         return this._vipNextLevelDaysNeeded;
      }
      
      public function get VIPLeftDays() : int
      {
         return int(this.VipLeftHours / 24);
      }
      
      public function get VipLeftHours() : int
      {
         return int((this.VIPExpireDay.valueOf() - this.systemDate.valueOf()) / 3600000);
      }
      
      public function get isSameDay() : Boolean
      {
         if(this.LastDate.fullYear == this.systemDate.fullYear && this.LastDate.month == this.systemDate.month && this.LastDate.date == this.systemDate.date)
         {
            return true;
         }
         return false;
      }
      
      public function set consortiaInfo(info:ConsortiaInfo) : void
      {
         if(this._consortiaInfo == info)
         {
            return;
         }
         this.consortiaInfo.beginChanges();
         ObjectUtils.copyProperties(this.consortiaInfo,info);
         this.consortiaInfo.commitChanges();
         onPropertiesChanged("consortiaInfo");
      }
      
      public function get consortiaInfo() : ConsortiaInfo
      {
         if(this._consortiaInfo == null)
         {
            this._consortiaInfo = new ConsortiaInfo();
         }
         return this._consortiaInfo;
      }
      
      public function get energy() : int
      {
         return this._energy;
      }
      
      public function set energy(value:int) : void
      {
         if(this._energy == value)
         {
            return;
         }
         this._energy = value;
         onPropertiesChanged(PlayerInfo.Energy);
      }
      
      public function get buyEnergyCount() : int
      {
         return this._buyEnergyCount;
      }
      
      public function set buyEnergyCount(value:int) : void
      {
         if(this._buyEnergyCount == value)
         {
            return;
         }
         this._buyEnergyCount = value;
         onPropertiesChanged(PlayerInfo.BuyEnergyCount);
      }
      
      public function get Gold() : Number
      {
         return this._gold;
      }
      
      public function set Gold(value:Number) : void
      {
         if(this._gold == value)
         {
            return;
         }
         this._gold = value;
         onPropertiesChanged(PlayerInfo.GOLD);
      }
      
      public function get Money() : Number
      {
         return this._money;
      }
      
      public function set Money(value:Number) : void
      {
         if(this._money == value)
         {
            return;
         }
         this._money = value;
         onPropertiesChanged(PlayerInfo.MONEY);
      }
      
      public function get BandMoney() : int
      {
         return this._bandMoney;
      }
      
      public function set BandMoney(num:int) : void
      {
         this._bandMoney = num;
         onPropertiesChanged("BandMoney");
      }
      
      public function set uesedFinishTime(value:int) : void
      {
         this._uesedFinishTime = value;
      }
      
      public function get uesedFinishTime() : int
      {
         return this._uesedFinishTime;
      }
      
      public function get cardInfo() : CardInfo
      {
         return this._cardInfo;
      }
      
      public function set cardInfo(value:CardInfo) : void
      {
         this._cardInfo = value;
      }
      
      public function get isFarmHelper() : Boolean
      {
         return this._isFarmHelper;
      }
      
      public function set isFarmHelper(value:Boolean) : void
      {
         this._isFarmHelper = value;
      }
      
      override public function get pets() : DictionaryData
      {
         if(_pets == null)
         {
            _pets = new DictionaryData();
            _pets.addEventListener("add",this.__petsDataChanged);
            _pets.addEventListener("remove",this.__petsDataChanged);
         }
         return _pets;
      }
      
      protected function __petsDataChanged(event:DictionaryEvent) : void
      {
         onPropertiesChanged(PET);
      }
      
      public function get petScore() : Number
      {
         return this._petScore;
      }
      
      public function set petScore(value:Number) : void
      {
         if(this._petScore == value)
         {
            return;
         }
         this._petScore = value;
         onPropertiesChanged(PlayerInfo.PETSCORE);
      }
      
      public function set coin(value:int) : void
      {
         this._coin = value;
         onPropertiesChanged("coin");
      }
      
      public function get coin() : int
      {
         return this._coin;
      }
      
      public function get LastServerId() : int
      {
         return this._LastServerId;
      }
      
      public function set myHonor(value:int) : void
      {
         this._myHonor = value;
         onPropertiesChanged("myHonor");
      }
      
      public function get myHonor() : int
      {
         return this._myHonor;
      }
      
      public function set LastServerId(value:int) : void
      {
         this._LastServerId = value;
      }
      
      public function get totalCharge() : int
      {
         return this._totalCharge;
      }
      
      public function set totalCharge(value:int) : void
      {
         this._totalCharge = value;
      }
      
      public function isCatchInsectGuideFinish(step:int) : Boolean
      {
         return this.bit(step);
      }
   }
}

class DateGeter
{
   
   public static var date:Date;
   
   public function DateGeter()
   {
      super();
   }
}
