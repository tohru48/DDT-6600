package kingDivision
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.LoadResourceManager;
   import com.pickgliss.loader.LoaderEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.core.Component;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.GameInSocketOut;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PathManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.ServerConfigManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.StateManager;
   import ddt.manager.TimeManager;
   import ddt.states.StateType;
   import flash.display.Bitmap;
   import flash.events.EventDispatcher;
   import flash.utils.Dictionary;
   import hallIcon.HallIconManager;
   import hallIcon.HallIconType;
   import kingDivision.analyze.AreaNameMessageAnalyze;
   import kingDivision.analyze.KingDivisionConsortionMessageAnalyze;
   import kingDivision.data.KingDivisionConsortionItemInfo;
   import kingDivision.event.KingDivisionEvent;
   import kingDivision.loader.LoaderKingDivisionUIModule;
   import kingDivision.model.KingDivisionModel;
   import kingDivision.view.KingDivisionFrame;
   import road7th.comm.PackageIn;
   
   public class KingDivisionManager extends EventDispatcher
   {
      
      private static var _instance:KingDivisionManager;
      
      private var _model:KingDivisionModel;
      
      public var _kingDivFrame:KingDivisionFrame;
      
      public var openFrame:Boolean;
      
      private var analyzerArr:Array;
      
      public var isThisZoneWin:Boolean;
      
      public var dataDic:Dictionary;
      
      public function KingDivisionManager(pct:PrivateClass)
      {
         super();
         this.addEvent();
      }
      
      public static function get Instance() : KingDivisionManager
      {
         if(KingDivisionManager._instance == null)
         {
            KingDivisionManager._instance = new KingDivisionManager(new PrivateClass());
         }
         return KingDivisionManager._instance;
      }
      
      public function setup() : void
      {
         this._model = new KingDivisionModel();
         SocketManager.Instance.addEventListener(KingDivisionEvent.ACTIVITY_OPEN,this.__activityOpen);
      }
      
      private function addEvent() : void
      {
         SocketManager.Instance.addEventListener(KingDivisionEvent.CONSORTIA_MATCH_INFO,this.__consortiaMatchInfo);
         SocketManager.Instance.addEventListener(KingDivisionEvent.CONSORTIA_MATCH_SCORE,this.__consortiaMatchScore);
         SocketManager.Instance.addEventListener(KingDivisionEvent.CONSORTIA_MATCH_RANK,this.__consortiaMatchRank);
         SocketManager.Instance.addEventListener(KingDivisionEvent.CONSORTIA_MATCH_AREA_RANK,this.__consortiaMatchAreaRank);
         SocketManager.Instance.addEventListener(KingDivisionEvent.CONSORTIA_MATCH_AREA_RANK_INFO,this.__consortiaMatchAreaRankInfo);
      }
      
      private function __activityOpen(evt:KingDivisionEvent) : void
      {
         var pkg:PackageIn = evt.pkg;
         this._model.isOpen = pkg.readBoolean();
         this._model.states = pkg.readByte();
         this._model.level = pkg.readInt();
         this._model.dateArr = ServerConfigManager.instance.localConsortiaMatchDays;
         this._model.allDateArr = ServerConfigManager.instance.areaConsortiaMatchDays;
         this._model.consortiaMatchStartTime = ServerConfigManager.instance.consortiaMatchStartTime;
         this._model.consortiaMatchEndTime = ServerConfigManager.instance.consortiaMatchEndTime;
         this.updateConsotionMessage();
         this.kingDivisionIcon(this._model.isOpen);
      }
      
      public function updateConsotionMessage() : void
      {
         var dates:Date = null;
         var datesArea:Date = null;
         if(this._model.states == 1)
         {
            dates = TimeManager.Instance.Now();
            if(this._model.dateArr[0] == dates.date)
            {
               GameInSocketOut.sendGetConsortionMessageThisZone();
            }
            else
            {
               GameInSocketOut.sendGetEliminateConsortionMessageThisZone();
            }
         }
         if(this._model.states == 2)
         {
            this.loaderConsortionMessage();
            this.loaderAreaNameMessage();
            datesArea = TimeManager.Instance.Now();
            if(this._model.allDateArr[0] == datesArea.date)
            {
               GameInSocketOut.sendGetConsortionMessageAllZone();
            }
            else
            {
               GameInSocketOut.sendGetEliminateConsortionMessageAllZone();
            }
         }
      }
      
      public function loaderConsortionMessage() : void
      {
         var loader:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("ConsortiaMatchHistory.ashx"),BaseLoader.REQUEST_LOADER);
         loader.analyzer = new KingDivisionConsortionMessageAnalyze(this.__searchResult);
         LoadResourceManager.Instance.startLoad(loader);
      }
      
      public function loaderAreaNameMessage() : void
      {
         var loader:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.getAreaNameInfoPath(),BaseLoader.TEXT_LOADER);
         loader.loadErrorMessage = LanguageMgr.GetTranslation("tank.auctionHouse.controller.KingDivisionAreaNameError");
         loader.analyzer = new AreaNameMessageAnalyze(this.loadAreaNameDataComplete);
         LoadResourceManager.Instance.startLoad(loader);
      }
      
      private function loadAreaNameDataComplete(analyzer:AreaNameMessageAnalyze) : void
      {
         this.dataDic = analyzer.kingDivisionAreaNameDataDic;
      }
      
      private function __onLoadError(event:LoaderEvent) : void
      {
         var msg:String = event.loader.loadErrorMessage;
         if(Boolean(event.loader.analyzer))
         {
            msg = event.loader.loadErrorMessage + "\n" + event.loader.analyzer.message;
         }
         var alert:BaseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("alert"),event.loader.loadErrorMessage,LanguageMgr.GetTranslation("tank.view.bagII.baglocked.sure"));
         alert.addEventListener(FrameEvent.RESPONSE,this.__onAlertResponse);
      }
      
      private function __onAlertResponse(event:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         event.currentTarget.removeEventListener(FrameEvent.RESPONSE,this.__onAlertResponse);
         ObjectUtils.disposeObject(event.currentTarget);
      }
      
      private function __searchResult(analyzer:KingDivisionConsortionMessageAnalyze) : void
      {
         var conItem:KingDivisionConsortionItemInfo = null;
         this.isThisZoneWin = true;
         this.analyzerArr = analyzer._list;
         if(this._model.eliminateInfo != null)
         {
            ObjectUtils.disposeObject(this._model.eliminateInfo);
            this._model.eliminateInfo = null;
         }
         this._model.eliminateInfo = new Vector.<KingDivisionConsortionItemInfo>();
         if(this.analyzerArr == null || this.analyzerArr.length < 1)
         {
            return;
         }
         for(var i:int = 0; i < this.analyzerArr.length; i++)
         {
            conItem = new KingDivisionConsortionItemInfo();
            conItem.conID = this.analyzerArr[i].ConsortiaID;
            conItem.conName = this.analyzerArr[i].ConsortiaName;
            conItem.score = this.analyzerArr[i].Score;
            conItem.conState = this.analyzerArr[i].State;
            conItem.conStyle = this.analyzerArr[i].Style;
            conItem.conSex = this.analyzerArr[i].Sex;
            this._model.eliminateInfo.push(conItem);
         }
      }
      
      private function __consortiaMatchInfo(evt:KingDivisionEvent) : void
      {
         var pkg:PackageIn = evt.pkg;
         this._model.gameNum = pkg.readInt();
         this._model.points = pkg.readInt();
         if(this._kingDivFrame != null)
         {
            if(this._kingDivFrame.qualificationsFrame != null)
            {
               this._kingDivFrame.qualificationsFrame.cancelMatch();
               this._kingDivFrame.qualificationsFrame.updateMessage(this._model.points,this._model.gameNum);
            }
            else if(this._kingDivFrame.rankingRoundView != null)
            {
               this._kingDivFrame.rankingRoundView.cancelMatch();
               this._kingDivFrame.rankingRoundView.updateMessage(this._model.points,this._model.gameNum);
            }
         }
      }
      
      private function __consortiaMatchScore(evt:KingDivisionEvent) : void
      {
         var conItem:KingDivisionConsortionItemInfo = null;
         var pkg:PackageIn = evt.pkg;
         var __stage:int = pkg.readByte();
         var rankStage:int = pkg.readByte();
         this._model.conLen = pkg.readInt();
         if(this._model.conItemInfo != null)
         {
            ObjectUtils.disposeObject(this._model.conItemInfo);
            this._model.eliminateInfo = null;
         }
         this._model.conItemInfo = new Vector.<KingDivisionConsortionItemInfo>();
         if(this._model.conLen < 1)
         {
            return;
         }
         for(var i:int = 0; i < this._model.conLen; i++)
         {
            conItem = new KingDivisionConsortionItemInfo();
            conItem.rang = pkg.readInt();
            conItem.consortionName = pkg.readUTF();
            conItem.consortionLevel = pkg.readInt();
            conItem.num = pkg.readInt();
            conItem.points = pkg.readInt();
            this._model.conItemInfo.push(conItem);
         }
         if(this._kingDivFrame != null && this._kingDivFrame.qualificationsFrame != null)
         {
            this._kingDivFrame.qualificationsFrame.updateConsortiaMessage();
         }
      }
      
      private function __consortiaMatchRank(evt:KingDivisionEvent) : void
      {
         var conItem:KingDivisionConsortionItemInfo = null;
         var pkg:PackageIn = evt.pkg;
         var __stage:int = pkg.readByte();
         var rankStage:int = pkg.readByte();
         if(this._model.eliminateInfo != null)
         {
            ObjectUtils.disposeObject(this._model.eliminateInfo);
            this._model.eliminateInfo = null;
         }
         this._model.eliminateInfo = new Vector.<KingDivisionConsortionItemInfo>();
         var length:int = pkg.readInt();
         if(length < 1)
         {
            return;
         }
         for(var i:int = 0; i < length; i++)
         {
            conItem = new KingDivisionConsortionItemInfo();
            conItem.conID = pkg.readInt();
            conItem.conName = pkg.readUTF();
            conItem.name = pkg.readUTF();
            conItem.score = pkg.readInt();
            conItem.conState = pkg.readByte();
            conItem.isGame = pkg.readBoolean();
            this._model.eliminateInfo.push(conItem);
         }
         if(this._kingDivFrame != null && this._kingDivFrame.rankingRoundView != null)
         {
            this._kingDivFrame.rankingRoundView.zone = 0;
         }
      }
      
      private function __consortiaMatchAreaRank(evt:KingDivisionEvent) : void
      {
         var conItem:KingDivisionConsortionItemInfo = null;
         var pkg:PackageIn = evt.pkg;
         var __stage:int = pkg.readByte();
         var rankStage:int = pkg.readByte();
         this._model.conLen = pkg.readInt();
         if(this._model.conItemInfo != null)
         {
            ObjectUtils.disposeObject(this._model.conItemInfo);
            this._model.conItemInfo = null;
         }
         this._model.conItemInfo = new Vector.<KingDivisionConsortionItemInfo>();
         if(this._model.conLen < 1)
         {
            return;
         }
         for(var i:int = 0; i < this._model.conLen; i++)
         {
            conItem = new KingDivisionConsortionItemInfo();
            conItem.consortionIDArea = pkg.readInt();
            conItem.areaID = pkg.readInt();
            conItem.consortionLevel = pkg.readInt();
            conItem.num = pkg.readInt();
            conItem.consortionName = pkg.readUTF();
            conItem.points = pkg.readInt();
            this._model.conItemInfo.push(conItem);
         }
         if(this._kingDivFrame != null && this._kingDivFrame.qualificationsFrame != null)
         {
            this._kingDivFrame.qualificationsFrame.updateConsortiaMessage();
         }
      }
      
      private function __consortiaMatchAreaRankInfo(evt:KingDivisionEvent) : void
      {
         var conItem:KingDivisionConsortionItemInfo = null;
         var pkg:PackageIn = evt.pkg;
         var __stage:int = pkg.readByte();
         var rankStage:int = pkg.readByte();
         if(this._model.eliminateAllZoneInfo != null)
         {
            ObjectUtils.disposeObject(this._model.eliminateAllZoneInfo);
            this._model.eliminateAllZoneInfo = null;
         }
         this._model.eliminateAllZoneInfo = new Vector.<KingDivisionConsortionItemInfo>();
         var length:int = pkg.readInt();
         if(length < 1)
         {
            return;
         }
         for(var i:int = 0; i < length; i++)
         {
            conItem = new KingDivisionConsortionItemInfo();
            conItem.consortionIDArea = pkg.readInt();
            conItem.areaID = pkg.readInt();
            conItem.consortionStyle = pkg.readUTF();
            conItem.consortionSex = pkg.readBoolean();
            conItem.consortionNameArea = pkg.readUTF();
            conItem.consortionState = pkg.readByte();
            conItem.consortionScoreArea = pkg.readInt();
            conItem.consortionIsGame = pkg.readBoolean();
            this._model.eliminateAllZoneInfo.push(conItem);
         }
         if(this._kingDivFrame != null && this._kingDivFrame.rankingRoundView != null)
         {
            this._kingDivFrame.rankingRoundView.zone = 1;
         }
      }
      
      public function templateDataSetup(dataList:Array) : void
      {
         this._model.goods = dataList;
      }
      
      public function get model() : KingDivisionModel
      {
         return this._model;
      }
      
      public function kingDivisionIcon(flag:Boolean) : void
      {
         if(PathManager.kingFightEnable)
         {
            HallIconManager.instance.updateSwitchHandler(HallIconType.KINGDIVISION,flag);
         }
         else
         {
            HallIconManager.instance.updateSwitchHandler(HallIconType.KINGDIVISION,false);
         }
      }
      
      public function onClickIcon() : void
      {
         if(StateManager.currentStateType == StateType.MAIN && this._model.isOpen)
         {
            LoaderKingDivisionUIModule.Instance.loadUIModule(this.doOpenKingDivisionFrame);
         }
      }
      
      private function doOpenKingDivisionFrame() : void
      {
         this._kingDivFrame = ComponentFactory.Instance.creatComponentByStylename("kingdivision.frame");
         LayerManager.Instance.addToLayer(this._kingDivFrame,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      public function returnComponent(cell:Bitmap, tipName:String) : Component
      {
         var compoent:Component = new Component();
         compoent.tipData = tipName;
         compoent.tipDirctions = "0,1,2";
         compoent.tipStyle = "ddt.view.tips.OneLineTip";
         compoent.tipGapH = 20;
         compoent.width = cell.width;
         compoent.x = cell.x;
         compoent.y = cell.y;
         cell.x = 0;
         cell.y = 0;
         compoent.addChild(cell);
         return compoent;
      }
      
      public function checkCanStartGame() : Boolean
      {
         var result:Boolean = true;
         if(PlayerManager.Instance.Self.Bag.getItemAt(6) == null)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.room.RoomIIController.weapon"));
            result = false;
         }
         return result;
      }
      
      public function checkGameTimeIsOpen() : Boolean
      {
         var date:Date = TimeManager.Instance.Now();
         var hour:int = date.hours;
         var minutes:int = date.minutes;
         if(hour > int(this._model.consortiaMatchEndTime[0]) || hour < int(this._model.consortiaMatchStartTime[0]))
         {
            return false;
         }
         if(hour <= int(this._model.consortiaMatchEndTime[0]) && hour >= int(this._model.consortiaMatchStartTime[0]))
         {
            if(hour == int(this._model.consortiaMatchEndTime[0]))
            {
               if(minutes >= int(this._model.consortiaMatchEndTime[1]))
               {
                  return false;
               }
               return true;
            }
            if(hour == int(this._model.consortiaMatchStartTime[0]))
            {
               if(minutes <= int(this._model.consortiaMatchStartTime[1]))
               {
                  return false;
               }
               return true;
            }
            if(hour < int(this._model.consortiaMatchEndTime[0]) && hour > int(this._model.consortiaMatchStartTime[0]))
            {
               return true;
            }
         }
         return false;
      }
      
      public function get isOpen() : Boolean
      {
         return this._model == null ? false : this._model.isOpen;
      }
      
      public function set zoneIndex(value:int) : void
      {
         this._model.zoneIndex = value;
      }
      
      public function get zoneIndex() : int
      {
         return this._model.zoneIndex;
      }
      
      public function get dateArr() : Array
      {
         return this._model.dateArr;
      }
      
      public function set dateArr(value:Array) : void
      {
         this._model.dateArr = value;
      }
      
      public function get allDateArr() : Array
      {
         return this._model.allDateArr;
      }
      
      public function set allDateArr(value:Array) : void
      {
         this._model.allDateArr = value;
      }
      
      public function get thisZoneNickName() : String
      {
         return this._model.thisZoneNickName;
      }
      
      public function set thisZoneNickName(value:String) : void
      {
         this._model.thisZoneNickName = value;
      }
      
      public function get allZoneNickName() : String
      {
         return this._model.allZoneNickName;
      }
      
      public function set allZoneNickName(value:String) : void
      {
         this._model.allZoneNickName = value;
      }
      
      public function get points() : int
      {
         return this._model.points;
      }
      
      public function set points(value:int) : void
      {
         this._model.points = value;
      }
      
      public function get gameNum() : int
      {
         return this._model.gameNum;
      }
      
      public function set gameNum(value:int) : void
      {
         this._model.gameNum = value;
      }
      
      public function get states() : int
      {
         return this._model.states;
      }
      
      public function set states(value:int) : void
      {
         this._model.states = value;
      }
      
      public function get level() : int
      {
         return this._model.level;
      }
      
      public function set level(value:int) : void
      {
         this._model.level = value;
      }
   }
}

class PrivateClass
{
   
   public function PrivateClass()
   {
      super();
   }
}
