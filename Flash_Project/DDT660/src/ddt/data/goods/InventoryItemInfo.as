package ddt.data.goods
{
   import ddt.data.EquipType;
   import ddt.events.GoodsEvent;
   import ddt.manager.ChatManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.StateManager;
   import ddt.manager.TimeManager;
   import ddt.states.StateType;
   import flash.events.TimerEvent;
   import flash.utils.ByteArray;
   import flash.utils.Timer;
   import gemstone.info.GemstListInfo;
   import magicStone.data.MagicStoneInfo;
   import road7th.utils.DateUtils;
   import store.forge.wishBead.WishBeadManager;
   import store.forge.wishBead.WishChangeInfo;
   
   public class InventoryItemInfo extends ItemTemplateInfo
   {
      
      private static var _isTimerStarted:Boolean = false;
      
      private static var _temp_Instances:Array = new Array();
      
      private var _checkTimeOutTimer:Timer;
      
      private var _checkColorValidTimer:Timer;
      
      private var _checkTimePackTimer:Timer;
      
      public var ItemID:Number;
      
      public var UserID:Number;
      
      public var IsBinds:Boolean;
      
      public var isDeleted:Boolean;
      
      public var BagType:int;
      
      public var type:int;
      
      public var isInvalid:Boolean;
      
      public var lock:Boolean = false;
      
      public var goodsLock:Boolean = false;
      
      public var Color:String;
      
      public var Skin:String;
      
      public var isMoveSpace:Boolean = true;
      
      private var _isUsed:Boolean;
      
      public var BeginDate:String;
      
      protected var _ValidDate:Number;
      
      public var isConversion:Boolean = false;
      
      private var _DiscolorValidDate:String;
      
      private var atLeastOnHour:Boolean;
      
      private var _count:int = 1;
      
      private var _exaltLevel:int;
      
      public var _StrengthenLevel:int;
      
      public var _StrengthenExp:int;
      
      private var _isGold:Boolean;
      
      public var Damage:int;
      
      public var Guard:int;
      
      public var Boold:int;
      
      public var Bless:int;
      
      private var _goldValidDate:int;
      
      private var _goldBeginTime:String;
      
      public var IsJudge:Boolean;
      
      public var Place:int;
      
      public var AttackCompose:int;
      
      public var DefendCompose:int;
      
      public var LuckCompose:int;
      
      public var AgilityCompose:int;
      
      public var lockType:int;
      
      public var Hole1:int = -1;
      
      public var Hole2:int = -1;
      
      public var Hole3:int = -1;
      
      public var Hole4:int = -1;
      
      public var Hole5:int = -1;
      
      public var Hole6:int = -1;
      
      public var Hole5Level:int;
      
      public var Hole5Exp:int = 0;
      
      public var Hole6Level:int;
      
      public var Hole6Exp:int = 0;
      
      public var beadExp:int;
      
      public var beadLevel:int = 1;
      
      public var beadIsLock:int;
      
      public var isShowBind:Boolean = true;
      
      public var gemstoneList:Vector.<GemstListInfo>;
      
      public var latentEnergyCurStr:String = "0,0,0,0";
      
      public var latentEnergyNewStr:String = "0,0,0,0";
      
      public var latentEnergyEndTime:Date;
      
      public var MagicExp:int;
      
      public var MagicLevel:int;
      
      public var magicStoneAttr:MagicStoneInfo;
      
      public function InventoryItemInfo()
      {
         super();
         if(!_isTimerStarted)
         {
            _temp_Instances.push(this);
         }
      }
      
      public static function startTimer() : void
      {
         var i:InventoryItemInfo = null;
         if(!_isTimerStarted)
         {
            _isTimerStarted = true;
            for each(i in _temp_Instances)
            {
               i.updateRemainDate();
            }
            _temp_Instances = null;
         }
      }
      
      public function get IsUsed() : Boolean
      {
         return this._isUsed;
      }
      
      public function setIsUsed(value:Boolean) : void
      {
         this._isUsed = value;
      }
      
      public function set IsUsed(value:Boolean) : void
      {
         isBeadLocked = value;
         if(this._isUsed == value)
         {
            return;
         }
         this._isUsed = value;
         if(this._isUsed && _isTimerStarted)
         {
            this.updateRemainDate();
         }
      }
      
      override public function set Property5(value:String) : void
      {
         _property5 = value;
         this.transformValidDate();
      }
      
      public function set ValidDate(value:Number) : void
      {
         this.isConversion = false;
         this._ValidDate = value;
         this.transformValidDate();
      }
      
      private function transformValidDate() : void
      {
         if(!EquipType.isPropertyWater(this))
         {
            return;
         }
         if(!this.isConversion)
         {
            switch(int(Property5))
            {
               case 1:
                  break;
               case 2:
                  this._ValidDate /= 24;
                  this.isConversion = true;
                  break;
               case 3:
                  this._ValidDate /= 24 * 60;
                  this.isConversion = true;
            }
         }
      }
      
      public function get ValidDate() : Number
      {
         return this._ValidDate;
      }
      
      public function getRemainDate() : Number
      {
         var bg:Date = null;
         var diff:Number = NaN;
         if(this.ValidDate == 0)
         {
            return int.MAX_VALUE;
         }
         if(!this._isUsed)
         {
            return this.ValidDate;
         }
         bg = DateUtils.getDateByStr(this.BeginDate);
         diff = TimeManager.Instance.TotalDaysToNow(bg);
         diff = diff < 0 ? 0 : diff;
         return this.ValidDate - diff;
      }
      
      public function getColorValidDate() : Number
      {
         var endDate:Date = null;
         var diff:Number = NaN;
         if(!this._isUsed)
         {
            return int.MAX_VALUE;
         }
         endDate = DateUtils.getDateByStr(this.DiscolorValidDate);
         return TimeManager.Instance.TotalDaysToNow(endDate) * -1;
      }
      
      public function set DiscolorValidDate(value:String) : void
      {
         var endDate:Date = null;
         var diff:Number = NaN;
         this._DiscolorValidDate = value;
         if(RefineryLevel >= 3 && this._isUsed)
         {
            endDate = DateUtils.getDateByStr(this.DiscolorValidDate);
            diff = endDate.time - TimeManager.Instance.Now().time;
            if(diff <= 0)
            {
               SocketManager.Instance.out.sendChangeColorShellTimeOver(this.BagType,this.Place);
            }
            else
            {
               this.updateDiscolorValidDate();
            }
         }
      }
      
      public function get DiscolorValidDate() : String
      {
         return this._DiscolorValidDate;
      }
      
      private function updateDiscolorValidDate() : void
      {
         var endDate:Date = DateUtils.getDateByStr(this.DiscolorValidDate);
         var diff:Number = endDate.time - TimeManager.Instance.Now().time;
         if(this._checkColorValidTimer != null)
         {
            this._checkColorValidTimer.stop();
            this._checkColorValidTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,this._timerColorComplete);
            this._checkColorValidTimer = null;
         }
         this._checkColorValidTimer = new Timer(diff,1);
         this._checkColorValidTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this._timerColorComplete);
         this._checkColorValidTimer.start();
      }
      
      private function updateRemainDate() : void
      {
         var bg:Date = null;
         var diff:Number = NaN;
         var remainDate:Number = NaN;
         var tempDelay:uint = 0;
         var p:* = undefined;
         if(this.ValidDate != 0 && this._isUsed)
         {
            bg = DateUtils.getDateByStr(this.BeginDate);
            diff = TimeManager.Instance.TotalDaysToNow(bg);
            remainDate = this.ValidDate - diff;
            if(remainDate > 0)
            {
               if(this._checkTimeOutTimer != null)
               {
                  this._checkTimeOutTimer.stop();
                  this._checkTimeOutTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.__timerComplete);
                  this._checkTimeOutTimer = null;
               }
               this.checkTimePcak(remainDate);
               this.atLeastOnHour = remainDate * 24 > 1;
               tempDelay = this.atLeastOnHour ? uint(remainDate * TimeManager.DAY_TICKS - 1 * 60 * 60 * 1000) : uint(remainDate * TimeManager.DAY_TICKS);
               this._checkTimeOutTimer = new Timer(tempDelay,1);
               this._checkTimeOutTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.__timerComplete);
               this._checkTimeOutTimer.start();
            }
            else
            {
               if(CategoryID == 50 || CategoryID == 51 || CategoryID == 52)
               {
                  if(PlayerManager.Instance.Self.pets.length > 0)
                  {
                     for(p in PlayerManager.Instance.Self.pets)
                     {
                        SocketManager.Instance.out.delPetEquip(PlayerManager.Instance.Self.pets[p].Place,this.Place);
                     }
                  }
                  return;
               }
               SocketManager.Instance.out.sendItemOverDue(this.BagType,this.Place);
            }
         }
      }
      
      private function checkTimePcak(remainDate:Number) : void
      {
         var delay:uint = 0;
         if(this._checkTimePackTimer != null)
         {
            this._checkTimePackTimer.stop();
            this._checkTimePackTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.__timerComplete);
            this._checkTimePackTimer = null;
         }
         if(TemplateID >= 1120098 && TemplateID <= 1120101)
         {
            if(remainDate * TimeManager.DAY_TICKS <= 30 * 60 * 1000)
            {
               ChatManager.Instance.addTimePackTip(Name);
               return;
            }
            delay = remainDate * TimeManager.DAY_TICKS - 30 * 60 * 1000;
            this._checkTimePackTimer = new Timer(delay,1);
            this._checkTimePackTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.__timerPackComplete);
            this._checkTimePackTimer.start();
         }
      }
      
      protected function __timerPackComplete(event:TimerEvent) : void
      {
         this._checkTimePackTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.__timerPackComplete);
         this._checkTimePackTimer.stop();
         ChatManager.Instance.addTimePackTip(Name);
      }
      
      private function __timerComplete(evt:TimerEvent) : void
      {
         this._checkTimeOutTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.__timerComplete);
         this._checkTimeOutTimer.stop();
         if(!this.IsBinds)
         {
            return;
         }
         if(TemplateID >= 1120098 && TemplateID <= 1120101)
         {
            ChatManager.Instance.addTimePackTip(Name);
         }
         if(this.atLeastOnHour)
         {
            this._checkTimeOutTimer.delay = 10000 + 1 * 60 * 60 * 1000;
         }
         else
         {
            this._checkTimeOutTimer.delay = 10000;
         }
         this._checkTimeOutTimer.reset();
         this._checkTimeOutTimer.addEventListener(TimerEvent.TIMER,this.__sendGoodsTimeOut);
         this._checkTimeOutTimer.start();
      }
      
      private function _timerColorComplete(evt:TimerEvent) : void
      {
         this._checkColorValidTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,this._timerColorComplete);
         this._checkColorValidTimer.stop();
         SocketManager.Instance.out.sendChangeColorShellTimeOver(this.BagType,this.Place);
      }
      
      private function __sendGoodsTimeOut(evt:TimerEvent) : void
      {
         var p:* = undefined;
         if(StateManager.currentStateType != StateType.FIGHTING && StateManager.currentStateType != StateType.FIGHT_LIB_GAMEVIEW)
         {
            if(CategoryID == 50 || CategoryID == 51 || CategoryID == 52)
            {
               if(PlayerManager.Instance.Self.pets.length > 0)
               {
                  for(p in PlayerManager.Instance.Self.pets)
                  {
                     SocketManager.Instance.out.delPetEquip(PlayerManager.Instance.Self.pets[p].Place,this.Place);
                  }
               }
               return;
            }
            SocketManager.Instance.out.sendItemOverDue(this.BagType,this.Place);
            this._checkTimeOutTimer.removeEventListener(TimerEvent.TIMER,this.__sendGoodsTimeOut);
            this._checkTimeOutTimer.stop();
         }
      }
      
      public function get Count() : int
      {
         return this._count;
      }
      
      public function set Count(value:int) : void
      {
         if(this._count == value)
         {
            return;
         }
         this._count = value;
         dispatchEvent(new GoodsEvent(GoodsEvent.PROPERTY_CHANGE,"Count",this._count));
      }
      
      public function clone() : InventoryItemInfo
      {
         var bytes:ByteArray = new ByteArray();
         bytes.writeObject(this);
         return bytes.readObject();
      }
      
      public function set exaltLevel(value:int) : void
      {
         this._exaltLevel = value;
      }
      
      public function get exaltLevel() : int
      {
         return this._exaltLevel;
      }
      
      public function set StrengthenLevel(value:int) : void
      {
         this._StrengthenLevel = value;
      }
      
      public function get StrengthenLevel() : int
      {
         return this._StrengthenLevel;
      }
      
      public function set StrengthenExp(value:int) : void
      {
         this._StrengthenExp = value;
      }
      
      public function get StrengthenExp() : int
      {
         return this._StrengthenExp;
      }
      
      public function get isGold() : Boolean
      {
         return this._isGold;
      }
      
      public function set isGold(value:Boolean) : void
      {
         var wishInfo:WishChangeInfo = null;
         this._isGold = value;
         if(this._isGold)
         {
            wishInfo = WishBeadManager.instance.getWishInfoByTemplateID(TemplateID,CategoryID);
            if(!wishInfo)
            {
               return;
            }
            Attack = wishInfo.Attack > 0 ? wishInfo.Attack : Attack;
            Defence = wishInfo.Defence > 0 ? wishInfo.Defence : Defence;
            Agility = wishInfo.Agility > 0 ? wishInfo.Agility : Agility;
            Luck = wishInfo.Luck > 0 ? wishInfo.Luck : Luck;
            this.Damage = wishInfo.Damage >= 0 ? wishInfo.Damage : this.Damage;
            this.Guard = wishInfo.Guard >= 0 ? wishInfo.Guard : this.Guard;
            this.Boold = wishInfo.Boold >= 0 ? wishInfo.Boold : this.Boold;
            this.Bless = wishInfo.BlessID;
            Pic = wishInfo.Pic != "" ? wishInfo.Pic : Pic;
         }
      }
      
      public function get goldValidDate() : int
      {
         return this._goldValidDate;
      }
      
      public function set goldValidDate(value:int) : void
      {
         this._goldValidDate = value;
      }
      
      public function get goldBeginTime() : String
      {
         return this._goldBeginTime;
      }
      
      public function set goldBeginTime(value:String) : void
      {
         this._goldBeginTime = value;
      }
      
      public function getGoldRemainDate() : Number
      {
         var bg:Date = DateUtils.getDateByStr(this._goldBeginTime);
         var diff:Number = TimeManager.Instance.TotalDaysToNow(bg);
         diff = diff < 0 ? 0 : diff;
         return this.goldValidDate - diff;
      }
      
      public function get isHasLatentEnergy() : Boolean
      {
         if(!this.latentEnergyEndTime || this.latentEnergyEndTime.getTime() <= TimeManager.Instance.Now().getTime())
         {
            return false;
         }
         var tmpArray:Array = this.latentEnergyCurList;
         if(tmpArray[0] == "0" || tmpArray[1] == "0" || tmpArray[2] == "0" || tmpArray[3] == "0")
         {
            return false;
         }
         return true;
      }
      
      public function get latentEnergyCurList() : Array
      {
         if(!this.isCanLatentEnergy)
         {
            this.latentEnergyCurStr = "0,0,0,0";
         }
         if(this.latentEnergyCurStr == "")
         {
            this.latentEnergyCurStr = "0,0,0,0";
         }
         return this.latentEnergyCurStr.split(",");
      }
      
      public function get latentEnergyNewList() : Array
      {
         if(this.latentEnergyNewStr == "")
         {
            this.latentEnergyNewStr = "0,0,0,0";
         }
         if(!this.isHasLatentEnergy)
         {
            this.latentEnergyNewStr = "0,0,0,0";
         }
         return this.latentEnergyNewStr.split(",");
      }
      
      public function get isHasLatenetEnergyNew() : Boolean
      {
         var tmpArray:Array = this.latentEnergyNewList;
         if(tmpArray[0] == "0" || tmpArray[1] == "0" || tmpArray[2] == "0" || tmpArray[3] == "0")
         {
            return false;
         }
         return true;
      }
      
      public function get isCanLatentEnergy() : Boolean
      {
         if(CategoryID == EquipType.HAIR || CategoryID == EquipType.SUITS || CategoryID == EquipType.GLASS || CategoryID == EquipType.EFF || CategoryID == EquipType.FACE || CategoryID == EquipType.WING)
         {
            return true;
         }
         return false;
      }
      
      public function isCanEnchant() : Boolean
      {
         if(CategoryID == EquipType.ARMLET || CategoryID == EquipType.RING || EquipType.isWeddingRing(this))
         {
            return true;
         }
         return false;
      }
      
      public function get hasComposeAttribte() : Boolean
      {
         return this.AttackCompose > 0 || this.DefendCompose > 0 || this.LuckCompose > 0 || this.AgilityCompose > 0;
      }
   }
}

