package ddt.manager
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import ddt.data.EquipType;
   import ddt.data.analyze.BoxTempInfoAnalyzer;
   import ddt.data.analyze.UserBoxInfoAnalyzer;
   import ddt.data.box.BoxGoodsTempInfo;
   import ddt.data.box.GradeBoxInfo;
   import ddt.data.box.TimeBoxInfo;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.events.PlayerPropertyEvent;
   import ddt.states.StateType;
   import ddt.view.bossbox.AwardsView;
   import ddt.view.bossbox.BossBoxView;
   import ddt.view.bossbox.SmallBoxButton;
   import ddt.view.bossbox.TimeBoxEvent;
   import ddt.view.bossbox.TimeCountDown;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.utils.Dictionary;
   import road7th.comm.PackageIn;
   import road7th.data.DictionaryData;
   
   public class BossBoxManager extends EventDispatcher
   {
      
      private static var _instance:BossBoxManager;
      
      public static const GradeBox:int = 1;
      
      public static const FightLibAwardBox:int = 3;
      
      public static const SignAward:int = 4;
      
      public static const LOADUSERBOXINFO_COMPLETE:String = "loadUserBoxInfo_complete";
      
      public static var DataLoaded:Boolean = false;
      
      private var _time:TimeCountDown;
      
      private var _delayBox:int = 1;
      
      private var _startDelayTime:Boolean = true;
      
      private var _isShowGradeBox:Boolean;
      
      private var _isBoxShowedNow:Boolean = false;
      
      private var _boxShowArray:Array;
      
      private var _delaySumTime:int = 0;
      
      private var _isTimeBoxOver:Boolean = false;
      
      private var _boxButtonShowType:int = 1;
      
      private var _currentGrade:int;
      
      private var _selectedBoxID:String = null;
      
      public var timeBoxList:DictionaryData;
      
      public var gradeBoxList:DictionaryData;
      
      public var caddyBoxGoodsInfo:Vector.<BoxGoodsTempInfo>;
      
      public var boxTemplateID:Dictionary;
      
      public var inventoryItemList:DictionaryData;
      
      public var boxTempIDList:DictionaryData;
      
      public var beadTempInfoList:DictionaryData;
      
      public var exploitTemplateIDs:Dictionary;
      
      private var _delayBoxHigh:int;
      
      public var timeBoxListHigh:DictionaryData;
      
      public var _receieGrade:int;
      
      public var _needGetBoxTime:int;
      
      public function BossBoxManager()
      {
         super();
         this.setup();
      }
      
      public static function get instance() : BossBoxManager
      {
         if(_instance == null)
         {
            _instance = new BossBoxManager();
         }
         return _instance;
      }
      
      private function init() : void
      {
         this._time = new TimeCountDown(1000);
         this._boxShowArray = new Array();
         this.initExploitTemplateIDs();
      }
      
      private function initExploitTemplateIDs() : void
      {
         this.exploitTemplateIDs = new Dictionary();
         this.exploitTemplateIDs[EquipType.OFFER_PACK_I] = new Vector.<BoxGoodsTempInfo>();
         this.exploitTemplateIDs[EquipType.OFFER_PACK_II] = new Vector.<BoxGoodsTempInfo>();
         this.exploitTemplateIDs[EquipType.OFFER_PACK_III] = new Vector.<BoxGoodsTempInfo>();
         this.exploitTemplateIDs[EquipType.OFFER_PACK_IV] = new Vector.<BoxGoodsTempInfo>();
         this.exploitTemplateIDs[EquipType.OFFER_PACK_V] = new Vector.<BoxGoodsTempInfo>();
      }
      
      private function initEvent() : void
      {
         this._time.addEventListener(TimeCountDown.COUNTDOWN_COMPLETE,this._timeOver);
         this._time.addEventListener(TimeCountDown.COUNTDOWN_ONE,this._timeOne);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.GET_TIME_BOX,this._getTimeBox);
      }
      
      public function setup() : void
      {
         this.init();
         this.initEvent();
      }
      
      public function setupBoxInfo(analyzer:UserBoxInfoAnalyzer) : void
      {
         this.timeBoxList = analyzer.timeBoxList;
         this.timeBoxListHigh = analyzer.timeBoxListHigh;
         this.gradeBoxList = analyzer.gradeBoxList;
         this.boxTemplateID = analyzer.boxTemplateID;
         DataLoaded = true;
         dispatchEvent(new Event(BossBoxManager.LOADUSERBOXINFO_COMPLETE));
      }
      
      public function setupBoxTempInfo(analyzer:BoxTempInfoAnalyzer) : void
      {
         this.inventoryItemList = analyzer.inventoryItemList;
         this.boxTempIDList = analyzer.caddyTempIDList;
         this.beadTempInfoList = analyzer.beadTempInfoList;
         this.caddyBoxGoodsInfo = analyzer.caddyBoxGoodsInfo;
      }
      
      public function startDelayTime() : void
      {
         this.resetTime();
      }
      
      private function resetTime() : void
      {
         if(this.timeBoxList == null)
         {
            return;
         }
         if(this.timeBoxListHigh == null)
         {
            return;
         }
         if(this.timeBoxList[this._delayBox] && this.startDelayTimeB && this.timeBoxList[this._delayBox].Level >= this.currentGrade)
         {
            this._time.setTimeOnMinute(this.timeBoxList[this._delayBox].Condition);
            this.delaySumTime = this.timeBoxList[this._delayBox].Condition * 60;
            this.boxButtonShowType = SmallBoxButton.showTypeCountDown;
            return;
         }
         if(this.timeBoxListHigh[this._delayBox] && this.startDelayTimeB && this.timeBoxListHigh[this._delayBox].Level >= this.currentGrade)
         {
            this._time.setTimeOnMinute(this.timeBoxListHigh[this._delayBox].Condition);
            this.delaySumTime = this.timeBoxListHigh[this._delayBox].Condition * 60;
            this.boxButtonShowType = SmallBoxButton.showTypeCountDown;
            return;
         }
      }
      
      public function startGradeChangeEvent() : void
      {
      }
      
      private function _updateGradeII(e:PlayerPropertyEvent) : void
      {
      }
      
      private function _checkeGradeForBox(prevGrade:int, NowGrade:int) : Boolean
      {
         this.currentGrade = PlayerManager.Instance.Self.Grade;
         return this._findGetedBoxGrade(prevGrade,NowGrade);
      }
      
      public function showSignAward(signCount:int, awardids:Array) : void
      {
         this._showBox(SignAward,signCount,awardids);
      }
      
      public function showFightLibAwardBox(type:int, level:int, awardids:Array) : void
      {
         if(StateManager.currentStateType != StateType.FIGHTING)
         {
            this.isShowGradeBox = false;
            this._showBox(FightLibAwardBox,1,awardids,type,level);
         }
         else
         {
            this.isShowGradeBox = true;
         }
      }
      
      public function showBoxOfGrade() : void
      {
         if(StateManager.currentStateType != StateType.FIGHTING)
         {
            this.isShowGradeBox = false;
            this.showGradeBox();
         }
         else
         {
            this.isShowGradeBox = true;
         }
      }
      
      private function removeEvent() : void
      {
         this._time.removeEventListener(TimeCountDown.COUNTDOWN_COMPLETE,this._timeOver);
         this._time.removeEventListener(TimeCountDown.COUNTDOWN_ONE,this._timeOne);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.GET_TIME_BOX,this._getTimeBox);
      }
      
      private function _getTimeBox(evt:CrazyTankSocketEvent) : void
      {
         var pkg:PackageIn = evt.pkg;
         var isGet:Boolean = pkg.readBoolean();
         var nextBoxTime:int = pkg.readInt();
         if(isGet)
         {
            this._isBoxShowedNow = false;
            this._selectedBoxID = null;
            if(PlayerManager.Instance.Self.Grade > this.timeBoxList[1].Level)
            {
               this._findBoxIdByTime_III(nextBoxTime);
            }
            else
            {
               this._findBoxIdByTime_II(nextBoxTime);
            }
            this.resetTime();
            this._showOtherBox();
         }
      }
      
      private function _findBoxIdByTime_III(time:int) : void
      {
         var minLevelInfo:TimeBoxInfo = null;
         var info1:TimeBoxInfo = null;
         var currentGrade:int = PlayerManager.Instance.Self.Grade;
         for each(info1 in this.timeBoxListHigh)
         {
            if(info1.Condition > time && info1.Level >= currentGrade)
            {
               if(minLevelInfo == null)
               {
                  minLevelInfo = info1;
               }
               else if(minLevelInfo.Condition + minLevelInfo.Level > info1.Condition + info1.Level)
               {
                  minLevelInfo = info1;
               }
            }
         }
         if(Boolean(minLevelInfo))
         {
            this._delayBox = minLevelInfo.ID;
            this._delayBoxHigh = minLevelInfo.ID;
            this.startDelayTimeB = true;
         }
         else
         {
            this.startDelayTimeB = false;
            this._isTimeBoxOver = true;
            this.boxButtonShowType = SmallBoxButton.showTypeHide;
         }
      }
      
      private function _findBoxIdByTime_II(time:int) : void
      {
         var minBoxInfo:TimeBoxInfo = null;
         var info:TimeBoxInfo = null;
         for each(info in this.timeBoxList)
         {
            if(info.Condition > time)
            {
               if(minBoxInfo == null)
               {
                  minBoxInfo = info;
               }
               if(info.Condition < minBoxInfo.Condition)
               {
                  minBoxInfo = info;
               }
            }
         }
         if(Boolean(minBoxInfo))
         {
            this._delayBox = minBoxInfo.ID;
            this._delayBoxHigh = this._findByTime(minBoxInfo.Condition);
            this.startDelayTimeB = true;
         }
         else
         {
            this.startDelayTimeB = false;
            this._isTimeBoxOver = true;
            this.boxButtonShowType = SmallBoxButton.showTypeHide;
         }
      }
      
      private function _findByTime(time:int) : int
      {
         var info:TimeBoxInfo = null;
         for each(info in this.timeBoxListHigh)
         {
            if(time == info.Condition && info.Level > PlayerManager.Instance.Self.Grade)
            {
               return info.ID;
            }
         }
         return 0;
      }
      
      private function _findGetedBoxByTime(time:int) : void
      {
         var info:TimeBoxInfo = null;
         for each(info in this.timeBoxList)
         {
            if(time == info.Condition)
            {
               this._delayBox = info.ID;
               if(Boolean(this.timeBoxList[this._delayBox]))
               {
                  this.startDelayTimeB = true;
               }
               else
               {
                  this.startDelayTimeB = false;
               }
               return;
            }
         }
      }
      
      private function _findGetedBoxGrade(prevGrade:int, NowGrade:int) : Boolean
      {
         var info:GradeBoxInfo = null;
         var bool:Boolean = false;
         for each(info in this.gradeBoxList)
         {
            if(PlayerManager.Instance.Self.Sex)
            {
               if(info.Level > prevGrade && info.Level <= NowGrade && Boolean(info.Condition))
               {
                  if(this._boxShowArray.indexOf(info.ID + ",grade") == -1)
                  {
                     this._boxShowArray.push(info.ID + ",grade");
                  }
                  bool = true;
               }
            }
            else if(info.Level > prevGrade && info.Level <= NowGrade && !info.Condition)
            {
               if(this._boxShowArray.indexOf(info.ID + ",grade") == -1)
               {
                  this._boxShowArray.push(info.ID + ",grade");
               }
               bool = true;
            }
         }
         return bool;
      }
      
      private function _findGetedBoxByTimeI(time:int) : void
      {
         var info:TimeBoxInfo = null;
         for each(info in this.timeBoxListHigh)
         {
            if(time == info.Condition)
            {
               if(Boolean(this.timeBoxListHigh[this._delayBox]))
               {
                  this.startDelayTimeB = true;
               }
               else
               {
                  this.startDelayTimeB = false;
               }
               return;
            }
         }
         if(Boolean(this.timeBoxListHigh[this._delayBox]))
         {
            this.startDelayTimeB = true;
         }
         else
         {
            this.startDelayTimeB = false;
         }
      }
      
      private function _showOtherBox() : void
      {
         for(var i:int = 0; i < this._boxShowArray.length; i++)
         {
            if(String(this._boxShowArray[i]).indexOf("grade") > 0)
            {
               this.showGradeBox();
               return;
            }
         }
      }
      
      private function _timeOver(e:Event) : void
      {
         if(PlayerManager.Instance.Self.Grade > this.timeBoxList[1].Level)
         {
            if(Boolean(this.timeBoxListHigh[this._delayBox]))
            {
               this._boxShowArray.push(this._delayBox + ",time," + this._delayBoxHigh);
               this.boxButtonShowType = SmallBoxButton.showTypeOpenbox;
               SocketManager.Instance.out.sendGetTimeBox(0,this.timeBoxListHigh[this._delayBox].Condition);
            }
         }
         else if(Boolean(this.timeBoxList[this._delayBox]))
         {
            this._boxShowArray.push(this._delayBox + ",time");
            this.boxButtonShowType = SmallBoxButton.showTypeOpenbox;
            SocketManager.Instance.out.sendGetTimeBox(0,this.timeBoxList[this._delayBox].Condition);
         }
      }
      
      private function _timeOne(e:Event) : void
      {
         --this.delaySumTime;
      }
      
      private function _getShowBoxID(boxType:String) : Array
      {
         var id:int = 0;
         var id2:int = 0;
         for(var i:int = 0; i < this._boxShowArray.length; i++)
         {
            if(String(this._boxShowArray[i]).indexOf(boxType) > 0)
            {
               id = int(String(this._boxShowArray[i]).split(",")[0]);
               id2 = int(String(this._boxShowArray[i]).split(",")[2]);
               this._selectedBoxID = this._boxShowArray.splice(i,1);
               return [id,id2];
            }
         }
         return [0,0];
      }
      
      private function _getShowBoxIDI(boxType:String) : int
      {
         var id:int = 0;
         for(var i:int = 0; i < this._boxShowArray.length; i++)
         {
            if(String(this._boxShowArray[i]).indexOf(boxType) > 0)
            {
               return int(String(this._boxShowArray[i]).split(",")[2]);
            }
         }
         return 0;
      }
      
      public function showTimeBox() : void
      {
         var idArr:Array = null;
         var awards:AwardsView = null;
         if(!this._isBoxShowedNow)
         {
            idArr = this._getShowBoxID("time");
            if(idArr[0] != 0)
            {
               if(PlayerManager.Instance.Self.Grade > this.timeBoxList[1].Level)
               {
                  if(PlayerManager.Instance.Self.Grade > this.timeBoxListHigh[idArr[1]].Level)
                  {
                     this._delayBoxHigh = this._findByTime(this.timeBoxListHigh[idArr[1]].Condition);
                  }
                  this._showBox(0,this._delayBoxHigh,this.inventoryItemList[this.timeBoxListHigh[this._delayBoxHigh].TemplateID]);
               }
               else
               {
                  this._showBox(0,idArr[0],this.inventoryItemList[this.timeBoxList[idArr[0]].TemplateID]);
               }
            }
            else
            {
               awards = ComponentFactory.Instance.creat("bossbox.AwardsViewAsset");
               awards.boxType = 0;
               if(PlayerManager.Instance.Self.Grade > this.timeBoxList[1].Level)
               {
                  if(PlayerManager.Instance.Self.Grade > this.timeBoxListHigh[this._delayBoxHigh].Level)
                  {
                     this._delayBoxHigh = this._findByTime(this.timeBoxListHigh[this._delayBoxHigh].Condition);
                  }
                  awards.goodsList = this.inventoryItemList[this.timeBoxListHigh[this._delayBoxHigh].TemplateID];
               }
               else
               {
                  awards.goodsList = this.inventoryItemList[this.timeBoxList[this._delayBox].TemplateID];
               }
               awards.setCheck();
               LayerManager.Instance.addToLayer(awards,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
            }
         }
      }
      
      public function showGradeBox() : void
      {
      }
      
      public function _showBox(boxType:int, _id:int, goodsIDs:Array, fightLibType:int = -1, fightLibLevel:int = -1) : void
      {
         this._isBoxShowedNow = true;
         LayerManager.Instance.addToLayer(new BossBoxView(boxType,_id,goodsIDs,fightLibType,fightLibLevel),LayerManager.GAME_DYNAMIC_LAYER);
      }
      
      public function showOtherGradeBox() : void
      {
         this._isBoxShowedNow = false;
         this._showOtherBox();
      }
      
      public function isShowBoxButton() : Boolean
      {
         if(this.timeBoxList == null || PlayerManager.Instance.Self.Grade < 8)
         {
            return false;
         }
         if(this._isTimeBoxOver)
         {
            return false;
         }
         return true;
      }
      
      public function deleteBoxButton() : void
      {
         this.stopShowTimeBox(this._delayBox);
      }
      
      public function stopShowTimeBox(ID:int) : void
      {
         if(this._isBoxShowedNow && this._selectedBoxID != null)
         {
            this._boxShowArray.push(this._selectedBoxID);
         }
         this._isBoxShowedNow = false;
      }
      
      public function set receieGrade(value:int) : void
      {
         this._receieGrade = value;
         if(this._findGetedBoxGrade(this._receieGrade,PlayerManager.Instance.Self.Grade))
         {
            this.isShowGradeBox = true;
         }
      }
      
      public function set needGetBoxTime(value:int) : void
      {
         this._needGetBoxTime = value;
         if(this._needGetBoxTime > 0)
         {
            if(PlayerManager.Instance.Self.Grade > this.timeBoxList[1].Level)
            {
               this._findGetedBoxByTimeI(this._needGetBoxTime);
            }
            else
            {
               this._findGetedBoxByTime(this._needGetBoxTime);
            }
            if(this.startDelayTimeB)
            {
               this.startDelayTimeB = false;
               if(this._boxShowArray.indexOf(this._delayBox + ",time," + this._delayBoxHigh) == -1)
               {
                  this._boxShowArray.push(this._delayBox + ",time," + this._delayBoxHigh);
               }
               this.boxButtonShowType = SmallBoxButton.showTypeOpenbox;
            }
         }
      }
      
      public function set receiebox(value:int) : void
      {
         if(this.timeBoxList != null && PlayerManager.Instance.Self.Grade > 20)
         {
            this._findBoxIdByTime_III(value);
         }
         else
         {
            this._findBoxIdByTime_II(value);
         }
      }
      
      public function set isShowGradeBox(value:Boolean) : void
      {
         this._isShowGradeBox = value;
      }
      
      public function get isShowGradeBox() : Boolean
      {
         return this._isShowGradeBox;
      }
      
      public function set currentGrade(value:int) : void
      {
         var info:TimeBoxInfo = null;
         var info1:TimeBoxInfo = null;
         this._currentGrade = value;
         if(this.timeBoxList != null && this._currentGrade > this.timeBoxList[1].Level)
         {
            for each(info in this.timeBoxListHigh)
            {
               if(this._currentGrade > 100)
               {
                  this.startDelayTimeB = false;
                  this._isTimeBoxOver = true;
                  this.boxButtonShowType = SmallBoxButton.showTypeHide;
                  break;
               }
            }
         }
         else
         {
            for each(info1 in this.timeBoxList)
            {
               if(this._currentGrade > info1.Level)
               {
                  this.startDelayTimeB = false;
                  this._isTimeBoxOver = true;
                  this.boxButtonShowType = SmallBoxButton.showTypeHide;
                  break;
               }
            }
         }
      }
      
      public function get currentGrade() : int
      {
         return this._currentGrade;
      }
      
      public function set boxButtonShowType(value:int) : void
      {
         this._boxButtonShowType = value;
         var evt:TimeBoxEvent = new TimeBoxEvent(TimeBoxEvent.UPDATESMALLBOXBUTTONSTATE);
         evt.boxButtonShowType = this._boxButtonShowType;
         dispatchEvent(evt);
      }
      
      public function get boxButtonShowType() : int
      {
         return this._boxButtonShowType;
      }
      
      public function set delaySumTime(value:int) : void
      {
         this._delaySumTime = value;
         var evt:TimeBoxEvent = new TimeBoxEvent(TimeBoxEvent.UPDATETIMECOUNT);
         evt.delaySumTime = this._delaySumTime;
         dispatchEvent(evt);
      }
      
      public function get delaySumTime() : int
      {
         return this._delaySumTime;
      }
      
      public function set startDelayTimeB(value:Boolean) : void
      {
         this._startDelayTime = value;
      }
      
      public function get startDelayTimeB() : Boolean
      {
         return this._startDelayTime;
      }
   }
}

