package tofflist
{
   import battleGroud.CeleTotalPrestigeAnalyer;
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.loader.LoadResourceManager;
   import com.pickgliss.utils.ObjectUtils;
   import consortion.ConsortionModelControl;
   import ddt.manager.PathManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.TaskManager;
   import ddt.states.BaseStateView;
   import ddt.states.StateType;
   import ddt.utils.RequestVairableCreater;
   import flash.display.DisplayObject;
   import flash.net.URLVariables;
   import tofflist.analyze.TofflistListAnalyzer;
   import tofflist.analyze.TofflistListTwoAnalyzer;
   import tofflist.view.TofflistView;
   import trainer.data.Step;
   
   public class TofflistController extends BaseStateView
   {
      
      private var _view:TofflistView;
      
      private var _temporaryTofflistListData:String;
      
      public function TofflistController()
      {
         super();
      }
      
      private function init() : void
      {
         this._view = new TofflistView(this);
         addChild(this._view);
         this.loadFormData("personalBattleAccumulate","CelebByDayFightPowerList.xml","personal");
         this.celeTotalPrestigeData();
      }
      
      private function celeTotalPrestigeData() : void
      {
         var loader:BaseLoader = LoadResourceManager.Instance.creatAndStartLoad(PathManager.solveRequestPath("CelebByTotalPrestige.xml"),BaseLoader.COMPRESS_TEXT_LOADER);
         loader.analyzer = new CeleTotalPrestigeAnalyer(this.completeHander2);
      }
      
      public function completeHander2(analyzer:CeleTotalPrestigeAnalyer) : void
      {
      }
      
      override public function getView() : DisplayObject
      {
         return this._view;
      }
      
      override public function enter(prev:BaseStateView, data:Object = null) : void
      {
         super.enter(prev,data);
         this.init();
         this._view.addEvent();
         ConsortionModelControl.Instance.getConsortionList(ConsortionModelControl.Instance.selfConsortionComplete,1,6,PlayerManager.Instance.Self.ConsortiaName,-1,-1,-1,PlayerManager.Instance.Self.ConsortiaID);
         if(!PlayerManager.Instance.Self.IsWeakGuildFinish(Step.VISIT_TOFF_LIST) && Boolean(TaskManager.instance.getQuestDataByID(358)))
         {
            SocketManager.Instance.out.sendQuestCheck(358,1,0);
            SocketManager.Instance.out.syncWeakStep(Step.VISIT_TOFF_LIST);
         }
         if(TofflistModel.Instance.rankInfo == null)
         {
            TofflistModel.Instance.loadRankInfo();
         }
      }
      
      override public function dispose() : void
      {
         ObjectUtils.disposeObject(this._view);
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
      
      override public function leaving(next:BaseStateView) : void
      {
         this.dispose();
         super.leaving(next);
      }
      
      override public function getBackType() : String
      {
         return StateType.MAIN;
      }
      
      override public function getType() : String
      {
         return StateType.TOFFLIST;
      }
      
      public function loadFormData(_dataInfo:String, _url:String, _type:String) : void
      {
         var tofflistListTwoAnalyzer:DataAnalyzer = null;
         this._temporaryTofflistListData = _dataInfo;
         if(!TofflistModel.Instance[this._temporaryTofflistListData])
         {
            if(_type == "personal")
            {
               tofflistListTwoAnalyzer = new TofflistListTwoAnalyzer(this.__personalResult);
            }
            else if(_type == "sociaty")
            {
               tofflistListTwoAnalyzer = new TofflistListAnalyzer(this.__sociatyResult);
            }
            this._loadXml(_url,tofflistListTwoAnalyzer,BaseLoader.COMPRESS_TEXT_LOADER);
         }
         else
         {
            TofflistModel.Instance[this._temporaryTofflistListData] = TofflistModel.Instance[this._temporaryTofflistListData];
         }
      }
      
      private function __personalResult(analyzer:TofflistListTwoAnalyzer) : void
      {
         TofflistModel.Instance[this._temporaryTofflistListData] = analyzer.data;
      }
      
      private function __sociatyResult(analyzer:TofflistListAnalyzer) : void
      {
         TofflistModel.Instance[this._temporaryTofflistListData] = analyzer.data;
      }
      
      public function clearDisplayContent() : void
      {
         this._view.clearDisplayContent();
      }
      
      public function loadList(type:int) : void
      {
      }
      
      private function _loadXml($url:String, $dataAnalyzer:DataAnalyzer, $requestType:int, $loadErrorMessage:String = "") : void
      {
         this._view.rightView.gridBox.orderList.clearList();
         var args:URLVariables = RequestVairableCreater.creatWidthKey(true);
         var loadSelfConsortiaMemberList:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath($url),$requestType,args);
         loadSelfConsortiaMemberList.loadErrorMessage = $loadErrorMessage;
         loadSelfConsortiaMemberList.analyzer = $dataAnalyzer;
         LoadResourceManager.Instance.startLoad(loadSelfConsortiaMemberList);
      }
   }
}

