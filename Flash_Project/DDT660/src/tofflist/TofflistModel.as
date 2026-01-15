package tofflist
{
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.LoadResourceManager;
   import consortion.data.ConsortiaApplyInfo;
   import ddt.data.ConsortiaInfo;
   import ddt.data.player.PlayerInfo;
   import ddt.manager.PathManager;
   import ddt.manager.PlayerManager;
   import flash.events.EventDispatcher;
   import flash.net.URLVariables;
   import tofflist.analyze.RankInfoAnalyz;
   import tofflist.data.RankInfo;
   import tofflist.data.TofflistListData;
   import tofflist.view.TofflistStairMenu;
   import tofflist.view.TofflistThirdClassMenu;
   import tofflist.view.TofflistTwoGradeMenu;
   
   public class TofflistModel
   {
      
      private static var _tofflistType:int;
      
      public static var childType:int;
      
      private static var _currentPlayerInfo:PlayerInfo;
      
      public static var currentText:String;
      
      public static var currentIndex:int;
      
      private static var _mountsLevelInfo:String;
      
      private static var _currentConsortiaInfo:ConsortiaInfo;
      
      private static var _instance:TofflistModel;
      
      private static var _firstMenuType:String = TofflistStairMenu.PERSONAL;
      
      private static var _secondMenuType:String = TofflistTwoGradeMenu.BATTLE;
      
      private static var _thirdMenuType:String = TofflistThirdClassMenu.TOTAL;
      
      private static var _dispatcher:EventDispatcher = new EventDispatcher();
      
      private var _personalBattleAccumulate:TofflistListData;
      
      private var _individualGradeDay:TofflistListData;
      
      private var _individualGradeWeek:TofflistListData;
      
      private var _individualGradeAccumulate:TofflistListData;
      
      private var _individualExploitDay:TofflistListData;
      
      private var _individualExploitWeek:TofflistListData;
      
      private var _individualExploitAccumulate:TofflistListData;
      
      private var _personalAchievementPointDay:TofflistListData;
      
      private var _personalAchievementPointWeek:TofflistListData;
      
      private var _personalAchievementPoint:TofflistListData;
      
      private var _PersonalCharmvalueDay:TofflistListData;
      
      private var _PersonalCharmvalueWeek:TofflistListData;
      
      private var _PersonalCharmvalue:TofflistListData;
      
      private var _personalMatchesWeek:TofflistListData;
      
      private var _personalMountsAccumulate:TofflistListData;
      
      private var _consortiaBattleAccumulate:TofflistListData;
      
      private var _consortiaGradeAccumulate:TofflistListData;
      
      private var _consortiaAssetDay:TofflistListData;
      
      private var _consortiaAssetWeek:TofflistListData;
      
      private var _consortiaAssetAccumulate:TofflistListData;
      
      private var _consortiaExploitDay:TofflistListData;
      
      private var _consortiaExploitWeek:TofflistListData;
      
      private var _consortiaExploitAccumulate:TofflistListData;
      
      private var _ConsortiaCharmvalueDay:TofflistListData;
      
      private var _ConsortiaCharmvalueWeek:TofflistListData;
      
      private var _ConsortiaCharmvalue:TofflistListData;
      
      private var _crossServerPersonalBattleAccumulate:TofflistListData;
      
      private var _crossServerIndividualGradeDay:TofflistListData;
      
      private var _crossServerIndividualGradeWeek:TofflistListData;
      
      private var _crossServerIndividualGradeAccumulate:TofflistListData;
      
      private var _crossServerIndividualExploitDay:TofflistListData;
      
      private var _crossServerIndividualExploitWeek:TofflistListData;
      
      private var _crossServerIndividualExploitAccumulate:TofflistListData;
      
      private var _crossServerPersonalAchievementPointDay:TofflistListData;
      
      private var _crossServerPersonalAchievementPointWeek:TofflistListData;
      
      private var _crossServerPersonalAchievementPoint:TofflistListData;
      
      private var _crossServerPersonalCharmvalueDay:TofflistListData;
      
      private var _crossServerPersonalCharmvalueWeek:TofflistListData;
      
      private var _crossServerPersonalCharmvalue:TofflistListData;
      
      private var _crossServerIndividualMountsAccumulate:TofflistListData;
      
      private var _crossServerConsortiaBattleAccumulate:TofflistListData;
      
      private var _crossServerConsortiaGradeAccumulate:TofflistListData;
      
      private var _crossServerConsortiaAssetDay:TofflistListData;
      
      private var _crossServerConsortiaAssetWeek:TofflistListData;
      
      private var _crossServerConsortiaAssetAccumulate:TofflistListData;
      
      private var _crossServerConsortiaExploitDay:TofflistListData;
      
      private var _crossServerConsortiaExploitWeek:TofflistListData;
      
      private var _crossServerConsortiaExploitAccumulate:TofflistListData;
      
      private var _crossServerConsortiaCharmvalueDay:TofflistListData;
      
      private var _crossServerConsortiaCharmvalueWeek:TofflistListData;
      
      private var _crossServerConsortiaCharmvalue:TofflistListData;
      
      private var _myConsortiaAuditingApplyData:Vector.<ConsortiaApplyInfo>;
      
      public var rankInfo:RankInfo;
      
      public function TofflistModel()
      {
         super();
      }
      
      public static function addEventListener(type:String, listener:Function, useCapture:Boolean = false) : void
      {
         _dispatcher.addEventListener(type,listener,useCapture);
      }
      
      public static function removeEventListener(type:String, listener:Function, useCapture:Boolean = false) : void
      {
         _dispatcher.removeEventListener(type,listener,useCapture);
      }
      
      public static function set firstMenuType(type:String) : void
      {
         _firstMenuType = type;
         _dispatcher.dispatchEvent(new TofflistEvent(TofflistEvent.TOFFLIST_TYPE_CHANGE,type));
      }
      
      public static function get firstMenuType() : String
      {
         return _firstMenuType;
      }
      
      public static function set secondMenuType(type:String) : void
      {
         _secondMenuType = type;
         _dispatcher.dispatchEvent(new TofflistEvent(TofflistEvent.TOFFLIST_TYPE_CHANGE,type));
      }
      
      public static function get secondMenuType() : String
      {
         return _secondMenuType;
      }
      
      public static function set thirdMenuType(type:String) : void
      {
         _thirdMenuType = type;
         _dispatcher.dispatchEvent(new TofflistEvent(TofflistEvent.TOFFLIST_TYPE_CHANGE,type));
      }
      
      public static function get thirdMenuType() : String
      {
         return _thirdMenuType;
      }
      
      public static function set currentPlayerInfo(info:PlayerInfo) : void
      {
         _currentPlayerInfo = info;
         _dispatcher.dispatchEvent(new TofflistEvent(TofflistEvent.TOFFLIST_CURRENT_PLAYER,info));
      }
      
      public static function get currentPlayerInfo() : PlayerInfo
      {
         return _currentPlayerInfo;
      }
      
      public static function set currentConsortiaInfo(value:ConsortiaInfo) : void
      {
         _currentConsortiaInfo = value;
      }
      
      public static function get currentConsortiaInfo() : ConsortiaInfo
      {
         return _currentConsortiaInfo;
      }
      
      public static function get Instance() : TofflistModel
      {
         if(_instance == null)
         {
            _instance = new TofflistModel();
         }
         return _instance;
      }
      
      public static function get mountsLevelInfo() : String
      {
         return _mountsLevelInfo;
      }
      
      public static function set mountsLevelInfo(value:String) : void
      {
         _mountsLevelInfo = value;
      }
      
      public function set personalBattleAccumulate(arr:TofflistListData) : void
      {
         this._personalBattleAccumulate = arr;
         _dispatcher.dispatchEvent(new TofflistEvent(TofflistEvent.TOFFLIST_DATA_CHANGER,this.getTofflistEventParams(TofflistEvent.TOFFLIST_PERSONAL_BATTLE_ACCUMULATE,this._personalBattleAccumulate)));
      }
      
      public function get personalBattleAccumulate() : TofflistListData
      {
         return this._personalBattleAccumulate;
      }
      
      public function set individualGradeDay(arr:TofflistListData) : void
      {
         this._individualGradeDay = arr;
         _dispatcher.dispatchEvent(new TofflistEvent(TofflistEvent.TOFFLIST_DATA_CHANGER,this.getTofflistEventParams(TofflistEvent.TOFFLIST_INDIVIDUAL_GRADE_DAY,this._individualGradeDay)));
      }
      
      public function get individualGradeDay() : TofflistListData
      {
         return this._individualGradeDay;
      }
      
      public function set individualGradeWeek(arr:TofflistListData) : void
      {
         this._individualGradeWeek = arr;
         _dispatcher.dispatchEvent(new TofflistEvent(TofflistEvent.TOFFLIST_DATA_CHANGER,this.getTofflistEventParams(TofflistEvent.TOFFLIST_INDIVIDUAL_GRADE_WEEK,this._individualGradeWeek)));
      }
      
      public function get individualGradeWeek() : TofflistListData
      {
         return this._individualGradeWeek;
      }
      
      public function set individualGradeAccumulate(arr:TofflistListData) : void
      {
         this._individualGradeAccumulate = arr;
         _dispatcher.dispatchEvent(new TofflistEvent(TofflistEvent.TOFFLIST_DATA_CHANGER,this.getTofflistEventParams(TofflistEvent.TOFFLIST_INDIVIDUAL_GRADE_ACCUMULATE,this._individualGradeAccumulate)));
      }
      
      public function get individualGradeAccumulate() : TofflistListData
      {
         return this._individualGradeAccumulate;
      }
      
      public function set individualExploitDay(arr:TofflistListData) : void
      {
         this._individualExploitDay = arr;
         _dispatcher.dispatchEvent(new TofflistEvent(TofflistEvent.TOFFLIST_DATA_CHANGER,this.getTofflistEventParams(TofflistEvent.TOFFLIST_INDIVIDUAL_EXPLOIT_DAY,this._individualExploitDay)));
      }
      
      public function get individualExploitDay() : TofflistListData
      {
         return this._individualExploitDay;
      }
      
      public function set individualExploitWeek(arr:TofflistListData) : void
      {
         this._individualExploitWeek = arr;
         _dispatcher.dispatchEvent(new TofflistEvent(TofflistEvent.TOFFLIST_DATA_CHANGER,this.getTofflistEventParams(TofflistEvent.TOFFLIST_INDIVIDUAL_EXPLOIT_WEEK,this._individualExploitWeek)));
      }
      
      public function get individualExploitWeek() : TofflistListData
      {
         return this._individualExploitWeek;
      }
      
      public function set individualExploitAccumulate(arr:TofflistListData) : void
      {
         this._individualExploitAccumulate = arr;
         _dispatcher.dispatchEvent(new TofflistEvent(TofflistEvent.TOFFLIST_DATA_CHANGER,this.getTofflistEventParams(TofflistEvent.TOFFLIST_INDIVIDUAL_EXPLOIT_ACCUMULATE,this._individualExploitAccumulate)));
      }
      
      public function get individualExploitAccumulate() : TofflistListData
      {
         return this._individualExploitAccumulate;
      }
      
      public function set PersonalAchievementPointDay(value:TofflistListData) : void
      {
         this._personalAchievementPointDay = value;
         _dispatcher.dispatchEvent(new TofflistEvent(TofflistEvent.TOFFLIST_DATA_CHANGER,this.getTofflistEventParams(TofflistEvent.TOFFLIST_INDIVIDUAL_ACHIEVEMENTPOINT_DAY,this._personalAchievementPointDay)));
      }
      
      public function get PersonalAchievementPointDay() : TofflistListData
      {
         return this._personalAchievementPointDay;
      }
      
      public function set PersonalAchievementPointWeek(value:TofflistListData) : void
      {
         this._personalAchievementPointWeek = value;
         _dispatcher.dispatchEvent(new TofflistEvent(TofflistEvent.TOFFLIST_DATA_CHANGER,this.getTofflistEventParams(TofflistEvent.TOFFLIST_INDIVIDUAL_ACHIEVEMENTPOINT_WEEK,this._personalAchievementPointWeek)));
      }
      
      public function get PersonalAchievementPointWeek() : TofflistListData
      {
         return this._personalAchievementPointWeek;
      }
      
      public function set PersonalAchievementPoint(value:TofflistListData) : void
      {
         this._personalAchievementPoint = value;
         _dispatcher.dispatchEvent(new TofflistEvent(TofflistEvent.TOFFLIST_DATA_CHANGER,this.getTofflistEventParams(TofflistEvent.TOFFLIST_INDIVIDUAL_ACHIEVEMENTPOINT_ACCUMULATE,this._personalAchievementPoint)));
      }
      
      public function get PersonalAchievementPoint() : TofflistListData
      {
         return this._personalAchievementPoint;
      }
      
      public function set PersonalCharmvalueDay(value:TofflistListData) : void
      {
         this._PersonalCharmvalueDay = value;
         _dispatcher.dispatchEvent(new TofflistEvent(TofflistEvent.TOFFLIST_DATA_CHANGER,this.getTofflistEventParams(TofflistEvent.TOFFLIST_INDIVIDUAL_CHARMVALUE_DAY,this._PersonalCharmvalueDay)));
      }
      
      public function get PersonalCharmvalueDay() : TofflistListData
      {
         return this._PersonalCharmvalueDay;
      }
      
      public function set PersonalCharmvalueWeek(value:TofflistListData) : void
      {
         this._PersonalCharmvalueWeek = value;
         _dispatcher.dispatchEvent(new TofflistEvent(TofflistEvent.TOFFLIST_DATA_CHANGER,this.getTofflistEventParams(TofflistEvent.TOFFLIST_INDIVIDUAL_CHARMVALUE_WEEK,this._PersonalCharmvalueWeek)));
      }
      
      public function get PersonalCharmvalueWeek() : TofflistListData
      {
         return this._PersonalCharmvalueWeek;
      }
      
      public function set PersonalCharmvalue(value:TofflistListData) : void
      {
         this._PersonalCharmvalue = value;
         _dispatcher.dispatchEvent(new TofflistEvent(TofflistEvent.TOFFLIST_DATA_CHANGER,this.getTofflistEventParams(TofflistEvent.TOFFLIST_INDIVIDUAL_CHARMVALUE_ACCUMULATE,this._PersonalCharmvalue)));
      }
      
      public function get PersonalCharmvalue() : TofflistListData
      {
         return this._PersonalCharmvalue;
      }
      
      public function get personalMatchesWeek() : TofflistListData
      {
         return this._personalMatchesWeek;
      }
      
      public function set personalMatchesWeek(value:TofflistListData) : void
      {
         this._personalMatchesWeek = value;
         _dispatcher.dispatchEvent(new TofflistEvent(TofflistEvent.TOFFLIST_DATA_CHANGER,this.getTofflistEventParams(TofflistEvent.TOFFLIST_INDIVIDUAL_MATCHES_WEEK,this._personalMatchesWeek)));
      }
      
      public function get personalMountsAccumulate() : TofflistListData
      {
         return this._personalMountsAccumulate;
      }
      
      public function set personalMountsAccumulate(value:TofflistListData) : void
      {
         this._personalMountsAccumulate = value;
         _dispatcher.dispatchEvent(new TofflistEvent(TofflistEvent.TOFFLIST_DATA_CHANGER,this.getTofflistEventParams(TofflistEvent.TOFFLIST_INDIVIDUAL_MOUNTS_ACCUMULATE,this._personalMountsAccumulate)));
      }
      
      public function set consortiaBattleAccumulate(value:TofflistListData) : void
      {
         this._consortiaBattleAccumulate = value;
         _dispatcher.dispatchEvent(new TofflistEvent(TofflistEvent.TOFFLIST_DATA_CHANGER,this.getTofflistEventParams(TofflistEvent.TOFFLIST_CONSORTIA_BATTLE_ACCUMULATE,this._consortiaBattleAccumulate)));
      }
      
      public function get consortiaBattleAccumulate() : TofflistListData
      {
         return this._consortiaBattleAccumulate;
      }
      
      public function set consortiaGradeAccumulate(arr:TofflistListData) : void
      {
         this._consortiaGradeAccumulate = arr;
         _dispatcher.dispatchEvent(new TofflistEvent(TofflistEvent.TOFFLIST_DATA_CHANGER,this.getTofflistEventParams(TofflistEvent.TOFFLIST_CONSORTIA_GRADE_ACCUMULATE,this._consortiaGradeAccumulate)));
      }
      
      public function get consortiaGradeAccumulate() : TofflistListData
      {
         return this._consortiaGradeAccumulate;
      }
      
      public function set consortiaAssetDay(arr:TofflistListData) : void
      {
         this._consortiaAssetDay = arr;
         _dispatcher.dispatchEvent(new TofflistEvent(TofflistEvent.TOFFLIST_DATA_CHANGER,this.getTofflistEventParams(TofflistEvent.TOFFLIST_CONSORTIA_ASSET_DAY,this._consortiaAssetDay)));
      }
      
      public function get consortiaAssetDay() : TofflistListData
      {
         return this._consortiaAssetDay;
      }
      
      public function set consortiaAssetWeek($list:TofflistListData) : void
      {
         this._consortiaAssetWeek = $list;
         _dispatcher.dispatchEvent(new TofflistEvent(TofflistEvent.TOFFLIST_DATA_CHANGER,this.getTofflistEventParams(TofflistEvent.TOFFLIST_CONSORTIA_ASSET_WEEK,this._consortiaAssetWeek)));
      }
      
      public function get consortiaAssetWeek() : TofflistListData
      {
         return this._consortiaAssetWeek;
      }
      
      public function set consortiaAssetAccumulate(arr:TofflistListData) : void
      {
         this._consortiaAssetAccumulate = arr;
         _dispatcher.dispatchEvent(new TofflistEvent(TofflistEvent.TOFFLIST_DATA_CHANGER,this.getTofflistEventParams(TofflistEvent.TOFFLIST_CONSORTIA_ASSET_ACCUMULATE,this._consortiaAssetAccumulate)));
      }
      
      public function get consortiaAssetAccumulate() : TofflistListData
      {
         return this._consortiaAssetAccumulate;
      }
      
      public function set consortiaExploitDay($list:TofflistListData) : void
      {
         this._consortiaExploitDay = $list;
         _dispatcher.dispatchEvent(new TofflistEvent(TofflistEvent.TOFFLIST_DATA_CHANGER,this.getTofflistEventParams(TofflistEvent.TOFFLIST_CONSORTIA_EXPLOIT_DAY,this._consortiaExploitDay)));
      }
      
      public function get consortiaExploitDay() : TofflistListData
      {
         return this._consortiaExploitDay;
      }
      
      public function set consortiaExploitWeek($list:TofflistListData) : void
      {
         this._consortiaExploitWeek = $list;
         _dispatcher.dispatchEvent(new TofflistEvent(TofflistEvent.TOFFLIST_DATA_CHANGER,this.getTofflistEventParams(TofflistEvent.TOFFLIST_CONSORTIA_EXPLOIT_WEEK,this._consortiaExploitWeek)));
      }
      
      public function get consortiaExploitWeek() : TofflistListData
      {
         return this._consortiaExploitWeek;
      }
      
      public function set consortiaExploitAccumulate(arr:TofflistListData) : void
      {
         this._consortiaExploitAccumulate = arr;
         _dispatcher.dispatchEvent(new TofflistEvent(TofflistEvent.TOFFLIST_DATA_CHANGER,this.getTofflistEventParams(TofflistEvent.TOFFLIST_CONSORTIA_EXPLOIT_ACCUMULATE,this._consortiaExploitAccumulate)));
      }
      
      public function get consortiaExploitAccumulate() : TofflistListData
      {
         return this._consortiaExploitAccumulate;
      }
      
      public function set ConsortiaCharmvalueDay(value:TofflistListData) : void
      {
         this._ConsortiaCharmvalueDay = value;
         _dispatcher.dispatchEvent(new TofflistEvent(TofflistEvent.TOFFLIST_DATA_CHANGER,this.getTofflistEventParams(TofflistEvent.TOFFLIST_CONSORTIA_CHARMVALUE_DAY,this._ConsortiaCharmvalueDay)));
      }
      
      public function get ConsortiaCharmvalueDay() : TofflistListData
      {
         return this._ConsortiaCharmvalueDay;
      }
      
      public function set ConsortiaCharmvalueWeek(value:TofflistListData) : void
      {
         this._ConsortiaCharmvalueWeek = value;
         _dispatcher.dispatchEvent(new TofflistEvent(TofflistEvent.TOFFLIST_DATA_CHANGER,this.getTofflistEventParams(TofflistEvent.TOFFLIST_CONSORTIA_CHARMVALUE_WEEK,this._ConsortiaCharmvalueWeek)));
      }
      
      public function get ConsortiaCharmvalueWeek() : TofflistListData
      {
         return this._ConsortiaCharmvalueWeek;
      }
      
      public function set ConsortiaCharmvalue(value:TofflistListData) : void
      {
         this._ConsortiaCharmvalue = value;
         _dispatcher.dispatchEvent(new TofflistEvent(TofflistEvent.TOFFLIST_DATA_CHANGER,this.getTofflistEventParams(TofflistEvent.TOFFLIST_CONSORTIA_CHARMVALUE_ACCUMULATE,this._ConsortiaCharmvalue)));
      }
      
      public function get ConsortiaCharmvalue() : TofflistListData
      {
         return this._ConsortiaCharmvalue;
      }
      
      public function set crossServerPersonalBattleAccumulate(arr:TofflistListData) : void
      {
         this._crossServerPersonalBattleAccumulate = arr;
         _dispatcher.dispatchEvent(new TofflistEvent(TofflistEvent.CROSS_SEREVR_DATA_CHANGER,this.getTofflistEventParams(TofflistEvent.TOFFLIST_PERSONAL_BATTLE_ACCUMULATE,this._crossServerPersonalBattleAccumulate)));
      }
      
      public function get crossServerPersonalBattleAccumulate() : TofflistListData
      {
         return this._crossServerPersonalBattleAccumulate;
      }
      
      public function set crossServerIndividualGradeDay(arr:TofflistListData) : void
      {
         this._crossServerIndividualGradeDay = arr;
         _dispatcher.dispatchEvent(new TofflistEvent(TofflistEvent.CROSS_SEREVR_DATA_CHANGER,this.getTofflistEventParams(TofflistEvent.TOFFLIST_INDIVIDUAL_GRADE_DAY,this._crossServerIndividualGradeDay)));
      }
      
      public function get crossServerIndividualGradeDay() : TofflistListData
      {
         return this._crossServerIndividualGradeDay;
      }
      
      public function set crossServerIndividualGradeWeek(arr:TofflistListData) : void
      {
         this._crossServerIndividualGradeWeek = arr;
         _dispatcher.dispatchEvent(new TofflistEvent(TofflistEvent.CROSS_SEREVR_DATA_CHANGER,this.getTofflistEventParams(TofflistEvent.TOFFLIST_INDIVIDUAL_GRADE_WEEK,this._crossServerIndividualGradeWeek)));
      }
      
      public function get crossServerIndividualGradeWeek() : TofflistListData
      {
         return this._crossServerIndividualGradeWeek;
      }
      
      public function set crossServerIndividualGradeAccumulate(arr:TofflistListData) : void
      {
         this._crossServerIndividualGradeAccumulate = arr;
         _dispatcher.dispatchEvent(new TofflistEvent(TofflistEvent.CROSS_SEREVR_DATA_CHANGER,this.getTofflistEventParams(TofflistEvent.TOFFLIST_INDIVIDUAL_GRADE_ACCUMULATE,this._crossServerIndividualGradeAccumulate)));
      }
      
      public function get crossServerIndividualGradeAccumulate() : TofflistListData
      {
         return this._crossServerIndividualGradeAccumulate;
      }
      
      public function set crossServerIndividualExploitDay(arr:TofflistListData) : void
      {
         this._crossServerIndividualExploitDay = arr;
         _dispatcher.dispatchEvent(new TofflistEvent(TofflistEvent.CROSS_SEREVR_DATA_CHANGER,this.getTofflistEventParams(TofflistEvent.TOFFLIST_INDIVIDUAL_EXPLOIT_DAY,this._crossServerIndividualExploitDay)));
      }
      
      public function get crossServerIndividualExploitDay() : TofflistListData
      {
         return this._crossServerIndividualExploitDay;
      }
      
      public function set crossServerIndividualExploitWeek(arr:TofflistListData) : void
      {
         this._crossServerIndividualExploitWeek = arr;
         _dispatcher.dispatchEvent(new TofflistEvent(TofflistEvent.CROSS_SEREVR_DATA_CHANGER,this.getTofflistEventParams(TofflistEvent.TOFFLIST_INDIVIDUAL_EXPLOIT_WEEK,this._crossServerIndividualExploitWeek)));
      }
      
      public function get crossServerIndividualExploitWeek() : TofflistListData
      {
         return this._crossServerIndividualExploitWeek;
      }
      
      public function set crossServerIndividualExploitAccumulate(arr:TofflistListData) : void
      {
         this._crossServerIndividualExploitAccumulate = arr;
         _dispatcher.dispatchEvent(new TofflistEvent(TofflistEvent.CROSS_SEREVR_DATA_CHANGER,this.getTofflistEventParams(TofflistEvent.TOFFLIST_INDIVIDUAL_EXPLOIT_ACCUMULATE,this._crossServerIndividualExploitAccumulate)));
      }
      
      public function get crossServerIndividualExploitAccumulate() : TofflistListData
      {
         return this._crossServerIndividualExploitAccumulate;
      }
      
      public function set crossServerPersonalAchievementPointDay(value:TofflistListData) : void
      {
         this._crossServerPersonalAchievementPointDay = value;
         _dispatcher.dispatchEvent(new TofflistEvent(TofflistEvent.CROSS_SEREVR_DATA_CHANGER,this.getTofflistEventParams(TofflistEvent.TOFFLIST_CONSORTIA_ACHIEVEMENTPOINT_DAY,this._crossServerPersonalAchievementPointDay)));
      }
      
      public function get crossServerPersonalAchievementPointDay() : TofflistListData
      {
         return this._crossServerPersonalAchievementPointDay;
      }
      
      public function set crossServerPersonalAchievementPointWeek(value:TofflistListData) : void
      {
         this._crossServerPersonalAchievementPointWeek = value;
         _dispatcher.dispatchEvent(new TofflistEvent(TofflistEvent.CROSS_SEREVR_DATA_CHANGER,this.getTofflistEventParams(TofflistEvent.TOFFLIST_CONSORTIA_ACHIEVEMENTPOINT_WEEK,this._crossServerPersonalAchievementPointWeek)));
      }
      
      public function get crossServerPersonalAchievementPointWeek() : TofflistListData
      {
         return this._crossServerPersonalAchievementPointWeek;
      }
      
      public function set crossServerPersonalAchievementPoint(value:TofflistListData) : void
      {
         this._crossServerPersonalAchievementPoint = value;
         _dispatcher.dispatchEvent(new TofflistEvent(TofflistEvent.CROSS_SEREVR_DATA_CHANGER,this.getTofflistEventParams(TofflistEvent.TOFFLIST_CONSORTIA_ACHIEVEMENTPOINT_ACCUMULATE,this._crossServerPersonalAchievementPoint)));
      }
      
      public function get crossServerPersonalAchievementPoint() : TofflistListData
      {
         return this._crossServerPersonalAchievementPoint;
      }
      
      public function set crossServerPersonalCharmvalueDay(value:TofflistListData) : void
      {
         this._crossServerPersonalCharmvalueDay = value;
         _dispatcher.dispatchEvent(new TofflistEvent(TofflistEvent.CROSS_SEREVR_DATA_CHANGER,this.getTofflistEventParams(TofflistEvent.TOFFLIST_INDIVIDUAL_CHARMVALUE_DAY,this._crossServerPersonalCharmvalueDay)));
      }
      
      public function get crossServerPersonalCharmvalueDay() : TofflistListData
      {
         return this._crossServerPersonalCharmvalueDay;
      }
      
      public function set crossServerPersonalCharmvalueWeek(value:TofflistListData) : void
      {
         this._crossServerPersonalCharmvalueWeek = value;
         _dispatcher.dispatchEvent(new TofflistEvent(TofflistEvent.CROSS_SEREVR_DATA_CHANGER,this.getTofflistEventParams(TofflistEvent.TOFFLIST_INDIVIDUAL_CHARMVALUE_WEEK,this._crossServerPersonalCharmvalueWeek)));
      }
      
      public function get crossServerPersonalCharmvalueWeek() : TofflistListData
      {
         return this._crossServerPersonalCharmvalueWeek;
      }
      
      public function set crossServerPersonalCharmvalue(value:TofflistListData) : void
      {
         this._crossServerPersonalCharmvalue = value;
         _dispatcher.dispatchEvent(new TofflistEvent(TofflistEvent.CROSS_SEREVR_DATA_CHANGER,this.getTofflistEventParams(TofflistEvent.TOFFLIST_INDIVIDUAL_CHARMVALUE_ACCUMULATE,this._crossServerPersonalCharmvalue)));
      }
      
      public function get crossServerPersonalCharmvalue() : TofflistListData
      {
         return this._crossServerPersonalCharmvalue;
      }
      
      public function set crossServerIndividualMountsAccumulate(value:TofflistListData) : void
      {
         this._crossServerIndividualMountsAccumulate = value;
         _dispatcher.dispatchEvent(new TofflistEvent(TofflistEvent.CROSS_SEREVR_DATA_CHANGER,this.getTofflistEventParams(TofflistEvent.TOFFLIST_INDIVIDUAL_MOUNTS_ACCUMULATE,this._crossServerIndividualMountsAccumulate)));
      }
      
      public function get crossServerIndividualMountsAccumulate() : TofflistListData
      {
         return this._crossServerIndividualMountsAccumulate;
      }
      
      public function set crossServerConsortiaBattleAccumulate(value:TofflistListData) : void
      {
         this._crossServerConsortiaBattleAccumulate = value;
         _dispatcher.dispatchEvent(new TofflistEvent(TofflistEvent.CROSS_SEREVR_DATA_CHANGER,this.getTofflistEventParams(TofflistEvent.TOFFLIST_CONSORTIA_BATTLE_ACCUMULATE,this._crossServerConsortiaBattleAccumulate)));
      }
      
      public function get crossServerConsortiaBattleAccumulate() : TofflistListData
      {
         return this._crossServerConsortiaBattleAccumulate;
      }
      
      public function set crossServerConsortiaGradeAccumulate(arr:TofflistListData) : void
      {
         this._crossServerConsortiaGradeAccumulate = arr;
         _dispatcher.dispatchEvent(new TofflistEvent(TofflistEvent.CROSS_SEREVR_DATA_CHANGER,this.getTofflistEventParams(TofflistEvent.TOFFLIST_CONSORTIA_GRADE_ACCUMULATE,this._crossServerConsortiaGradeAccumulate)));
      }
      
      public function get crossServerConsortiaGradeAccumulate() : TofflistListData
      {
         return this._crossServerConsortiaGradeAccumulate;
      }
      
      public function set crossServerConsortiaAssetDay(arr:TofflistListData) : void
      {
         this._crossServerConsortiaAssetDay = arr;
         _dispatcher.dispatchEvent(new TofflistEvent(TofflistEvent.CROSS_SEREVR_DATA_CHANGER,this.getTofflistEventParams(TofflistEvent.TOFFLIST_CONSORTIA_ASSET_DAY,this._crossServerConsortiaAssetDay)));
      }
      
      public function get crossServerConsortiaAssetDay() : TofflistListData
      {
         return this._crossServerConsortiaAssetDay;
      }
      
      public function set crossServerConsortiaAssetWeek($list:TofflistListData) : void
      {
         this._crossServerConsortiaAssetWeek = $list;
         _dispatcher.dispatchEvent(new TofflistEvent(TofflistEvent.CROSS_SEREVR_DATA_CHANGER,this.getTofflistEventParams(TofflistEvent.TOFFLIST_CONSORTIA_ASSET_WEEK,this._crossServerConsortiaAssetWeek)));
      }
      
      public function get crossServerConsortiaAssetWeek() : TofflistListData
      {
         return this._crossServerConsortiaAssetWeek;
      }
      
      public function set crossServerConsortiaAssetAccumulate(arr:TofflistListData) : void
      {
         this._crossServerConsortiaAssetAccumulate = arr;
         _dispatcher.dispatchEvent(new TofflistEvent(TofflistEvent.CROSS_SEREVR_DATA_CHANGER,this.getTofflistEventParams(TofflistEvent.TOFFLIST_CONSORTIA_ASSET_ACCUMULATE,this._crossServerConsortiaAssetAccumulate)));
      }
      
      public function get crossServerConsortiaAssetAccumulate() : TofflistListData
      {
         return this._crossServerConsortiaAssetAccumulate;
      }
      
      public function set crossServerConsortiaExploitDay($list:TofflistListData) : void
      {
         this._crossServerConsortiaExploitDay = $list;
         _dispatcher.dispatchEvent(new TofflistEvent(TofflistEvent.CROSS_SEREVR_DATA_CHANGER,this.getTofflistEventParams(TofflistEvent.TOFFLIST_CONSORTIA_EXPLOIT_DAY,this._crossServerConsortiaExploitDay)));
      }
      
      public function get crossServerConsortiaExploitDay() : TofflistListData
      {
         return this._crossServerConsortiaExploitDay;
      }
      
      public function set crossServerConsortiaExploitWeek($list:TofflistListData) : void
      {
         this._crossServerConsortiaExploitWeek = $list;
         _dispatcher.dispatchEvent(new TofflistEvent(TofflistEvent.CROSS_SEREVR_DATA_CHANGER,this.getTofflistEventParams(TofflistEvent.TOFFLIST_CONSORTIA_EXPLOIT_WEEK,this._crossServerConsortiaExploitWeek)));
      }
      
      public function get crossServerConsortiaExploitWeek() : TofflistListData
      {
         return this._crossServerConsortiaExploitWeek;
      }
      
      public function set crossServerConsortiaExploitAccumulate(arr:TofflistListData) : void
      {
         this._crossServerConsortiaExploitAccumulate = arr;
         _dispatcher.dispatchEvent(new TofflistEvent(TofflistEvent.CROSS_SEREVR_DATA_CHANGER,this.getTofflistEventParams(TofflistEvent.TOFFLIST_CONSORTIA_EXPLOIT_ACCUMULATE,this._crossServerConsortiaExploitAccumulate)));
      }
      
      public function get crossServerConsortiaExploitAccumulate() : TofflistListData
      {
         return this._crossServerConsortiaExploitAccumulate;
      }
      
      public function set crossServerConsortiaCharmvalueDay(value:TofflistListData) : void
      {
         this._crossServerConsortiaCharmvalueDay = value;
         _dispatcher.dispatchEvent(new TofflistEvent(TofflistEvent.CROSS_SEREVR_DATA_CHANGER,this.getTofflistEventParams(TofflistEvent.TOFFLIST_CONSORTIA_CHARMVALUE_DAY,this._crossServerConsortiaCharmvalueDay)));
      }
      
      public function get crossServerConsortiaCharmvalueDay() : TofflistListData
      {
         return this._crossServerConsortiaCharmvalueDay;
      }
      
      public function set crossServerConsortiaCharmvalueWeek(value:TofflistListData) : void
      {
         this._crossServerConsortiaCharmvalueWeek = value;
         _dispatcher.dispatchEvent(new TofflistEvent(TofflistEvent.CROSS_SEREVR_DATA_CHANGER,this.getTofflistEventParams(TofflistEvent.TOFFLIST_CONSORTIA_CHARMVALUE_WEEK,this._crossServerConsortiaCharmvalueWeek)));
      }
      
      public function get crossServerConsortiaCharmvalueWeek() : TofflistListData
      {
         return this._crossServerConsortiaCharmvalueWeek;
      }
      
      public function set crossServerConsortiaCharmvalue(value:TofflistListData) : void
      {
         this._crossServerConsortiaCharmvalue = value;
         _dispatcher.dispatchEvent(new TofflistEvent(TofflistEvent.CROSS_SEREVR_DATA_CHANGER,this.getTofflistEventParams(TofflistEvent.TOFFLIST_CONSORTIA_CHARMVALUE_ACCUMULATE,this._crossServerConsortiaCharmvalue)));
      }
      
      public function get crossServerConsortiaCharmvalue() : TofflistListData
      {
         return this._crossServerConsortiaCharmvalue;
      }
      
      private function getTofflistEventParams(flag:String, data:TofflistListData) : Object
      {
         var obj:Object = new Object();
         obj.flag = flag;
         obj.data = data;
         return obj;
      }
      
      public function set myConsortiaAuditingApplyData(value:Vector.<ConsortiaApplyInfo>) : void
      {
         this._myConsortiaAuditingApplyData = value;
      }
      
      public function get myConsortiaAuditingApplyData() : Vector.<ConsortiaApplyInfo>
      {
         return this._myConsortiaAuditingApplyData;
      }
      
      public function loadRankInfo() : void
      {
         var args:URLVariables = new URLVariables();
         args["userID"] = PlayerManager.Instance.Self.ID;
         args["ConsortiaID"] = PlayerManager.Instance.Self.ConsortiaID;
         var loadSelfConsortiaMemberList:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("UserRankDate.ashx"),BaseLoader.REQUEST_LOADER,args);
         loadSelfConsortiaMemberList.loadErrorMessage = "";
         loadSelfConsortiaMemberList.analyzer = new RankInfoAnalyz(this._loadRankCom);
         LoadResourceManager.Instance.startLoad(loadSelfConsortiaMemberList);
      }
      
      private function _loadRankCom(analyzer:RankInfoAnalyz) : void
      {
         this.rankInfo = analyzer.info;
         _dispatcher.dispatchEvent(new TofflistEvent(TofflistEvent.RANKINFO_READY));
      }
   }
}

