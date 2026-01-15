package ddt.data
{
   import ddt.events.PlayerPropertyEvent;
   import flash.events.EventDispatcher;
   import flash.utils.Dictionary;
   import road7th.utils.DateUtils;
   
   public class ConsortiaInfo extends EventDispatcher
   {
      
      public static const LEVEL:String = "level";
      
      public static const STORE_LEVEL:String = "storeLevel";
      
      public static const SHOP_LEVEL:String = "shopLevel";
      
      public static const BANK_LEVEL:String = "bankLevel";
      
      public static const RICHES:String = "riches";
      
      public static const DESCRIPTION:String = "description";
      
      public static const PLACARD:String = "placard";
      
      public static const CHAIRMANNAME:String = "chairmanName";
      
      public static const CONSORTIANAME:String = "consortiaName";
      
      public static const BADGE_ID:String = "badgeID";
      
      public static const BADGE_DATE:String = "badgedate";
      
      public static const COUNT:String = "count";
      
      public static const POLLOPEN:String = "pollOpen";
      
      public static const SKILL_LEVEL:String = "skillLevel";
      
      public static const IS_VOTING:String = "isVoting";
      
      public var ConsortiaID:int;
      
      private var _consortiaName:String = "";
      
      private var _badgeID:int = 0;
      
      private var _badgeBuyTime:String = DateUtils.dateFormat(new Date());
      
      private var _validDate:int;
      
      private var _IsVoting:Boolean;
      
      public var VoteRemainDay:int;
      
      public var CreatorID:int;
      
      public var CreatorName:String = "";
      
      public var ChairmanID:int;
      
      private var _chairmanName:String = "";
      
      public var MaxCount:int;
      
      public var CelebCount:int;
      
      public var BuildDate:String = "";
      
      public var IP:String;
      
      public var Port:int;
      
      private var _count:int;
      
      public var Repute:int;
      
      public var IsApply:Boolean;
      
      public var State:int;
      
      public var DeductDate:String;
      
      public var Honor:int;
      
      public var LastDayRiches:int;
      
      public var OpenApply:Boolean;
      
      public var FightPower:int;
      
      public var ChairmanTypeVIP:int;
      
      public var ChairmanVIPLevel:int;
      
      private var _PollOpen:Boolean;
      
      public var CharmGP:int;
      
      private var _Level:int;
      
      private var _storeLevel:int;
      
      private var _SmithLevel:int;
      
      private var _ShopLevel:int;
      
      private var _bufferLevel:int;
      
      private var _riches:int;
      
      private var _description:String;
      
      private var _placard:String = "";
      
      public var BadgeType:int;
      
      public var BadgeName:String;
      
      protected var _changeCount:int = 0;
      
      protected var _changedPropeties:Dictionary = new Dictionary();
      
      public function ConsortiaInfo()
      {
         super();
      }
      
      public function get ValidDate() : int
      {
         return this._validDate;
      }
      
      public function set ValidDate(value:int) : void
      {
         this._validDate = value;
      }
      
      public function get BadgeBuyTime() : String
      {
         return this._badgeBuyTime;
      }
      
      public function set BadgeBuyTime(value:String) : void
      {
         this._badgeBuyTime = value;
         this.onPropertiesChanged(BADGE_DATE);
      }
      
      public function get BadgeID() : int
      {
         return this._badgeID;
      }
      
      public function set BadgeID(value:int) : void
      {
         this._badgeID = value;
         this.onPropertiesChanged(BADGE_ID);
      }
      
      public function get ConsortiaName() : String
      {
         return this._consortiaName;
      }
      
      public function set ConsortiaName(value:String) : void
      {
         if(this._consortiaName == value)
         {
            return;
         }
         this._consortiaName = value;
         this.onPropertiesChanged(CONSORTIANAME);
      }
      
      public function get IsVoting() : Boolean
      {
         return this._IsVoting;
      }
      
      public function set IsVoting(value:Boolean) : void
      {
         this._IsVoting = value;
         this.onPropertiesChanged(IS_VOTING);
      }
      
      public function get ChairmanName() : String
      {
         return this._chairmanName;
      }
      
      public function set ChairmanName(value:String) : void
      {
         if(this._chairmanName == value)
         {
            return;
         }
         this._chairmanName = value;
         this.onPropertiesChanged(CHAIRMANNAME);
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
         this.onPropertiesChanged(COUNT);
      }
      
      public function get PollOpen() : Boolean
      {
         return this._PollOpen;
      }
      
      public function get ChairmanIsVIP() : Boolean
      {
         return this.ChairmanTypeVIP > 0;
      }
      
      public function set PollOpen(value:Boolean) : void
      {
         if(this._PollOpen == value)
         {
            return;
         }
         this._PollOpen = value;
         this.onPropertiesChanged(POLLOPEN);
      }
      
      public function get Level() : int
      {
         return this._Level;
      }
      
      public function set Level(value:int) : void
      {
         this._Level = value;
         this.onPropertiesChanged(LEVEL);
      }
      
      public function set StoreLevel($level:int) : void
      {
         this._storeLevel = $level;
         this.onPropertiesChanged(BANK_LEVEL);
      }
      
      public function get StoreLevel() : int
      {
         return this._storeLevel;
      }
      
      public function get SmithLevel() : int
      {
         return this._SmithLevel;
      }
      
      public function set SmithLevel(value:int) : void
      {
         this._SmithLevel = value;
         this.onPropertiesChanged(STORE_LEVEL);
      }
      
      public function get ShopLevel() : int
      {
         return this._ShopLevel;
      }
      
      public function set ShopLevel(value:int) : void
      {
         this._ShopLevel = value;
         this.onPropertiesChanged(SHOP_LEVEL);
      }
      
      public function get BufferLevel() : int
      {
         return this._bufferLevel;
      }
      
      public function set BufferLevel(value:int) : void
      {
         this._bufferLevel = value;
         this.onPropertiesChanged(SKILL_LEVEL);
      }
      
      public function set Riches(i:int) : void
      {
         this._riches = i;
         this.onPropertiesChanged(RICHES);
      }
      
      public function get Riches() : int
      {
         return this._riches;
      }
      
      public function get Description() : String
      {
         return this._description;
      }
      
      public function set Description(value:String) : void
      {
         if(this._description == value)
         {
            return;
         }
         this._description = value;
         this.onPropertiesChanged(DESCRIPTION);
      }
      
      public function get Placard() : String
      {
         return this._placard;
      }
      
      public function set Placard(value:String) : void
      {
         if(this._placard == value)
         {
            return;
         }
         this._placard = value;
         this.onPropertiesChanged(PLACARD);
      }
      
      public function beginChanges() : void
      {
         ++this._changeCount;
      }
      
      public function commitChanges() : void
      {
         --this._changeCount;
         if(this._changeCount <= 0)
         {
            this._changeCount = 0;
            this.updateProperties();
         }
      }
      
      protected function onPropertiesChanged(propName:String = null) : void
      {
         if(propName != null)
         {
            this._changedPropeties[propName] = true;
         }
         if(this._changeCount <= 0)
         {
            this._changeCount = 0;
            this.updateProperties();
         }
      }
      
      public function updateProperties() : void
      {
         var temp:Dictionary = this._changedPropeties;
         this._changedPropeties = new Dictionary();
         dispatchEvent(new PlayerPropertyEvent(PlayerPropertyEvent.PROPERTY_CHANGE,temp));
      }
   }
}

