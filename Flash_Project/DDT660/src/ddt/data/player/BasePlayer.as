package ddt.data.player
{
   import com.pickgliss.manager.NoviceDataManager;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.Experience;
   import ddt.events.PlayerPropertyEvent;
   import ddt.manager.PathManager;
   import ddt.manager.ServerConfigManager;
   import flash.events.EventDispatcher;
   import flash.net.URLRequest;
   import flash.net.URLVariables;
   import flash.net.sendToURL;
   import flash.utils.Dictionary;
   
   [Event(name="gold_change",type="tank.data.player.PlayerPropertyEvent")]
   [Event(name="propertychange",type="ddt.events.PlayerPropertyEvent")]
   public class BasePlayer extends EventDispatcher
   {
      
      public static const BADGE_ID:String = "badgeid";
      
      public static const JUNIOR_VIP:int = 1;
      
      public static const SENIOR_VIP:int = 2;
      
      private var _zoneID:int;
      
      public var ID:Number;
      
      public var LoginName:String;
      
      private var _activityTanabataNum:int;
      
      protected var _nick:String;
      
      protected var _Sex:Boolean;
      
      public var WinCount:int;
      
      public var EscapeCount:int;
      
      private var _totalCount:int = 0;
      
      private var _isFirstDivorce:int;
      
      private var _repute:int;
      
      private var _grade:int;
      
      private var _IsUpGrade:Boolean;
      
      public var isUpGradeInGame:Boolean = false;
      
      private var _fightPower:int;
      
      private var _matchInfo:MatchInfo;
      
      private var _leagueFirst:Boolean;
      
      private var _lasetWeekScore:Number;
      
      public var _score:Number = 0;
      
      private var _CardSoul:int;
      
      private var _GetSoulCount:int;
      
      private var _gP:int;
      
      private var _offer:int;
      
      private var _sign:Boolean;
      
      private var _treasure:int;
      
      private var _treasureAdd:int;
      
      private var _state:PlayerState;
      
      private var _typeVIP:int = 0;
      
      public var VIPLevel:int = 1;
      
      public var VIPExp:int;
      
      public var isOpenKingBless:Boolean;
      
      private var _honor:String = "";
      
      public var honorId:int;
      
      private var _achievementPoint:int;
      
      private var _isMarried:Boolean;
      
      public var SpouseID:int;
      
      private var _spouseName:String;
      
      public var ConsortiaID:int = 0;
      
      public var ConsortiaName:String;
      
      public var DutyLevel:int;
      
      private var _dutyName:String;
      
      private var _right:int;
      
      private var _RichesRob:int;
      
      private var _RichesOffer:int;
      
      private var _UseOffer:int;
      
      private var _badgeID:int = 0;
      
      private var _apprenticeshipState:int;
      
      public var LastLoginDate:Date;
      
      private var _hpTexpExp:int = -1;
      
      private var _attTexpExp:int = -1;
      
      private var _defTexpExp:int = -1;
      
      private var _spdTexpExp:int = -1;
      
      private var _lukTexpExp:int = -1;
      
      private var _texpCount:int;
      
      private var _texpTaskCount:int;
      
      private var _texpTaskDate:Date;
      
      protected var _changeCount:int = 0;
      
      protected var _changedPropeties:Dictionary = new Dictionary();
      
      protected var _lastValue:Dictionary = new Dictionary();
      
      protected var _isOld:Boolean = false;
      
      public var Rank:int = 0;
      
      public var MountsType:int = 0;
      
      private var canRideMountsArr:Array = [1,2,3,4,5,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,120];
      
      public var PetsID:int;
      
      private var specialMountsArr:Array = [4,5,6,7,8,9,103];
      
      public function BasePlayer()
      {
         super();
      }
      
      public function set ZoneID(zoneID:int) : void
      {
         this._zoneID = zoneID;
      }
      
      public function get ZoneID() : int
      {
         return this._zoneID;
      }
      
      public function set NickName(value:String) : void
      {
         this._nick = value;
      }
      
      public function get NickName() : String
      {
         return this._nick;
      }
      
      public function get SexByInt() : int
      {
         if(this.Sex)
         {
            return 1;
         }
         return 2;
      }
      
      public function set SexByInt(value:int) : void
      {
      }
      
      public function get TotalCount() : int
      {
         return this._totalCount;
      }
      
      public function set TotalCount(value:int) : void
      {
         if(this._totalCount == value || value <= 0)
         {
            return;
         }
         if(this._totalCount == value - 1 || this._totalCount == value - 2)
         {
            this.onPropertiesChanged("TotalCount");
         }
         this._totalCount = value;
      }
      
      public function set isFirstDivorce(value:int) : void
      {
         this._isFirstDivorce = value;
      }
      
      public function get isFirstDivorce() : int
      {
         return this._isFirstDivorce;
      }
      
      public function get Repute() : int
      {
         return this._repute;
      }
      
      public function set Repute(value:int) : void
      {
         this._repute = value;
         this.onPropertiesChanged("Repute");
      }
      
      public function get Grade() : int
      {
         return this._grade;
      }
      
      public function set Grade(value:int) : void
      {
         if(this._grade == value || value <= 0)
         {
            return;
         }
         if(this._grade != 0 && this._grade < value)
         {
            this.IsUpGrade = true;
         }
         this._grade = value;
         this.onPropertiesChanged("Grade");
      }
      
      public function get IsUpGrade() : Boolean
      {
         return this._IsUpGrade;
      }
      
      public function set IsUpGrade(value:Boolean) : void
      {
         this._IsUpGrade = value;
         this.noticeGrade();
      }
      
      private function noticeGrade() : void
      {
         if(!this.IsUpGrade)
         {
            return;
         }
         var site:String = PathManager.solveGradeNotificationPath(this.Grade);
         if(site == null)
         {
            return;
         }
         var request:URLRequest = new URLRequest(site);
         var variable:URLVariables = new URLVariables();
         variable["grade"] = this.Grade;
         request.data = variable;
         sendToURL(request);
         if(this.Grade == 11)
         {
            NoviceDataManager.instance.saveNoviceData(730,PathManager.userName(),PathManager.solveRequestPath());
         }
      }
      
      public function get FightPower() : int
      {
         return this._fightPower;
      }
      
      public function get matchInfo() : MatchInfo
      {
         if(this._matchInfo == null)
         {
            this._matchInfo = new MatchInfo();
         }
         return this._matchInfo;
      }
      
      public function set matchInfo(value:MatchInfo) : void
      {
         if(this._matchInfo == value)
         {
            return;
         }
         ObjectUtils.copyProperties(this.matchInfo,value);
         this.onPropertiesChanged("matchInfo");
      }
      
      public function get DailyLeagueFirst() : Boolean
      {
         return this._leagueFirst;
      }
      
      public function set DailyLeagueFirst(value:Boolean) : void
      {
         if(this._leagueFirst == value)
         {
            return;
         }
         this._leagueFirst = value;
         this.onPropertiesChanged("DailyLeagueFirst");
      }
      
      public function get DailyLeagueLastScore() : Number
      {
         return this._lasetWeekScore;
      }
      
      public function set DailyLeagueLastScore(value:Number) : void
      {
         if(this._lasetWeekScore == value)
         {
            return;
         }
         this._lasetWeekScore = value;
         this.onPropertiesChanged("DailyLeagueLastScore");
      }
      
      public function set FightPower(value:int) : void
      {
         if(this._fightPower == value)
         {
            return;
         }
         this._fightPower = value;
         this.onPropertiesChanged("FightPower");
      }
      
      public function get Score() : Number
      {
         return this._score;
      }
      
      public function set Score(value:Number) : void
      {
         if(this._score == value)
         {
            return;
         }
         this._score = value;
         this.onPropertiesChanged("Score");
      }
      
      public function get CardSoul() : int
      {
         return this._CardSoul;
      }
      
      public function set CardSoul(value:int) : void
      {
         this._CardSoul = value;
         this.onPropertiesChanged("CardSoul");
         this.updateProperties();
      }
      
      public function get GetSoulCount() : int
      {
         return this._GetSoulCount;
      }
      
      public function set GetSoulCount(value:int) : void
      {
         this._GetSoulCount = value;
         this.onPropertiesChanged("GetSoulCount");
         this.updateProperties();
      }
      
      public function get GP() : int
      {
         return this._gP;
      }
      
      public function set GP(value:int) : void
      {
         this._gP = value;
         this.Grade = Experience.getGrade(this._gP);
         this.onPropertiesChanged("GP");
      }
      
      public function get Offer() : int
      {
         return this._offer;
      }
      
      public function set Offer(value:int) : void
      {
         if(this._offer == value)
         {
            return;
         }
         this._offer = value;
         this.onPropertiesChanged("Offer");
      }
      
      public function get Sign() : Boolean
      {
         return this._sign;
      }
      
      public function set Sign(value:Boolean) : void
      {
         if(this._sign == value)
         {
            return;
         }
         this._sign = value;
         this.onPropertiesChanged("Sign");
      }
      
      public function get treasure() : int
      {
         return this._treasure;
      }
      
      public function set treasure(value:int) : void
      {
         this._treasure = value;
      }
      
      public function get treasureAdd() : int
      {
         return this._treasureAdd;
      }
      
      public function set treasureAdd(value:int) : void
      {
         this._treasureAdd = value;
      }
      
      public function get playerState() : PlayerState
      {
         if(this._state == null)
         {
            this._state = new PlayerState(PlayerState.ONLINE);
         }
         return this._state;
      }
      
      public function set playerState(value:PlayerState) : void
      {
         if(this._state == null || this._state.StateID == PlayerState.ONLINE || this._state.StateID != value.StateID && this._state.Priority <= value.Priority)
         {
            this._state = value;
            this.onPropertiesChanged("State");
         }
      }
      
      public function get IsVIP() : Boolean
      {
         return this._typeVIP >= 1;
      }
      
      public function set IsVIP(value:Boolean) : void
      {
         this._typeVIP = int(value);
      }
      
      public function set typeVIP(value:int) : void
      {
         this._typeVIP = value;
         this.onPropertiesChanged("isVip");
      }
      
      public function get typeVIP() : int
      {
         return this._typeVIP;
      }
      
      public function get honor() : String
      {
         return this._honor;
      }
      
      public function set honor(value:String) : void
      {
         if(this._honor == value)
         {
            return;
         }
         this._honor = value;
         this.onPropertiesChanged("honor");
      }
      
      public function get AchievementPoint() : int
      {
         return this._achievementPoint;
      }
      
      public function set AchievementPoint(value:int) : void
      {
         this._achievementPoint = value;
      }
      
      public function set SpouseName(value:String) : void
      {
         if(this._spouseName == value)
         {
            return;
         }
         this._spouseName = value;
         this.onPropertiesChanged("SpouseName");
      }
      
      public function get SpouseName() : String
      {
         return this._spouseName;
      }
      
      public function set IsMarried(value:Boolean) : void
      {
         if(value && !this._isMarried)
         {
         }
         this._isMarried = value;
         this.onPropertiesChanged("IsMarried");
      }
      
      public function get IsMarried() : Boolean
      {
         return this._isMarried;
      }
      
      public function get DutyName() : String
      {
         return this._dutyName;
      }
      
      public function set DutyName(value:String) : void
      {
         if(this._dutyName == value)
         {
            return;
         }
         this._dutyName = value;
         this.onPropertiesChanged("dutyName");
      }
      
      public function get Right() : int
      {
         return this._right;
      }
      
      public function set Right(value:int) : void
      {
         if(this._right == value)
         {
            return;
         }
         this._right = value;
         this.onPropertiesChanged("Right");
      }
      
      public function get RichesRob() : int
      {
         return this._RichesRob;
      }
      
      public function set RichesRob(value:int) : void
      {
         if(this._RichesRob == value)
         {
            return;
         }
         this._RichesRob = value;
         this.onPropertiesChanged("RichesRob");
      }
      
      public function get RichesOffer() : int
      {
         return this._RichesOffer;
      }
      
      public function set RichesOffer(value:int) : void
      {
         if(this._RichesOffer == value)
         {
            return;
         }
         this._RichesOffer = value;
         this.onPropertiesChanged("RichesOffer");
      }
      
      public function get UseOffer() : int
      {
         return this._UseOffer;
      }
      
      public function set UseOffer(value:int) : void
      {
         if(this._UseOffer == value)
         {
            return;
         }
         this._UseOffer = value;
         this.onPropertiesChanged("UseOffer");
      }
      
      public function get Riches() : int
      {
         return this.RichesOffer + this.RichesRob;
      }
      
      public function set Riches(value:int) : void
      {
         this.RichesOffer = value;
      }
      
      public function get badgeID() : int
      {
         return this._badgeID;
      }
      
      public function set badgeID(value:int) : void
      {
         this._badgeID = value;
         this.onPropertiesChanged(BADGE_ID);
      }
      
      public function set apprenticeshipState(value:int) : void
      {
         this._apprenticeshipState = value;
      }
      
      public function get apprenticeshipState() : int
      {
         return this._apprenticeshipState;
      }
      
      public function get hpTexpExp() : int
      {
         return this._hpTexpExp;
      }
      
      public function set hpTexpExp(value:int) : void
      {
         if(this._hpTexpExp == value)
         {
            return;
         }
         this._lastValue["hpTexpExp"] = this._hpTexpExp;
         this._hpTexpExp = value;
         if(this._lastValue["hpTexpExp"] != -1)
         {
            this.onPropertiesChanged("hpTexpExp");
         }
      }
      
      public function get attTexpExp() : int
      {
         return this._attTexpExp;
      }
      
      public function set attTexpExp(value:int) : void
      {
         if(this._attTexpExp == value)
         {
            return;
         }
         this._lastValue["attTexpExp"] = this._attTexpExp;
         this._attTexpExp = value;
         if(this._lastValue["attTexpExp"] != -1)
         {
            this.onPropertiesChanged("attTexpExp");
         }
      }
      
      public function get defTexpExp() : int
      {
         return this._defTexpExp;
      }
      
      public function set defTexpExp(value:int) : void
      {
         if(this._defTexpExp == value)
         {
            return;
         }
         this._lastValue["defTexpExp"] = this._defTexpExp;
         this._defTexpExp = value;
         if(this._lastValue["defTexpExp"] != -1)
         {
            this.onPropertiesChanged("defTexpExp");
         }
      }
      
      public function get spdTexpExp() : int
      {
         return this._spdTexpExp;
      }
      
      public function set spdTexpExp(value:int) : void
      {
         if(this._spdTexpExp == value)
         {
            return;
         }
         this._lastValue["spdTexpExp"] = this._spdTexpExp;
         this._spdTexpExp = value;
         if(this._lastValue["spdTexpExp"] != -1)
         {
            this.onPropertiesChanged("spdTexpExp");
         }
      }
      
      public function get lukTexpExp() : int
      {
         return this._lukTexpExp;
      }
      
      public function set lukTexpExp(value:int) : void
      {
         if(this._lukTexpExp == value)
         {
            return;
         }
         this._lastValue["lukTexpExp"] = this._lukTexpExp;
         this._lukTexpExp = value;
         if(this._lastValue["lukTexpExp"] != -1)
         {
            this.onPropertiesChanged("lukTexpExp");
         }
      }
      
      public function get texpCount() : int
      {
         return this._texpCount;
      }
      
      public function set texpCount(value:int) : void
      {
         this._texpCount = value;
      }
      
      public function get texpTaskCount() : int
      {
         return this._texpTaskCount;
      }
      
      public function set texpTaskCount(value:int) : void
      {
         this._texpTaskCount = value;
      }
      
      public function get texpTaskDate() : Date
      {
         return this._texpTaskDate;
      }
      
      public function set texpTaskDate(value:Date) : void
      {
         this._texpTaskDate = value;
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
      
      public function get isOld() : Boolean
      {
         return this._isOld;
      }
      
      public function set isOld(value:Boolean) : void
      {
         this._isOld = value;
      }
      
      public function updateProperties() : void
      {
         var temp:Dictionary = this._changedPropeties;
         var last:Dictionary = this._lastValue;
         this._changedPropeties = new Dictionary();
         this._lastValue = new Dictionary();
         dispatchEvent(new PlayerPropertyEvent(PlayerPropertyEvent.PROPERTY_CHANGE,temp,last));
      }
      
      public function get activityTanabataNum() : int
      {
         return this._activityTanabataNum;
      }
      
      public function set activityTanabataNum(value:int) : void
      {
         value = ServerConfigManager.instance.activityEnterNum - value;
         this._activityTanabataNum = value < 0 ? 0 : value;
      }
      
      public function get Sex() : Boolean
      {
         return this._Sex;
      }
      
      public function set Sex(value:Boolean) : void
      {
         this._Sex = value;
      }
      
      public function get IsMounts() : Boolean
      {
         return this.MountsType > 0;
      }
      
      public function getPetsPosIndex() : int
      {
         var index:int = 0;
         if(this.PetsID >= 62001 && this.PetsID <= 62003)
         {
            index = this.MountsType <= 0 ? 0 : 2;
         }
         else if(this.PetsID >= 62004 && this.PetsID <= 62006)
         {
            index = this.MountsType <= 0 ? 1 : 3;
         }
         return index;
      }
      
      public function getIsRide() : Boolean
      {
         return this.canRideMountsArr.indexOf(this.MountsType) != -1;
      }
      
      public function getIsSpecialRide() : Boolean
      {
         return this.specialMountsArr.indexOf(this.MountsType) != -1;
      }
	  
	  private var _isAttest:Boolean = false;
	  
	  public function get isAttest() : Boolean
	  {
		  return this._isAttest;
	  }
	  
	  public function set isAttest(param1:Boolean) : void
	  {
		  this._isAttest = param1;
	  }
	  
	  public var targetId:int;
   }
}

