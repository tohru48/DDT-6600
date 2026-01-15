package sevenDayTarget.controller
{
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.loader.UIModuleLoader;
   import ddt.data.UIModuleTypes;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.socket.SevenDayTargetPackageType;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.view.UIModuleSmallLoading;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import godsRoads.manager.GodsRoadsManager;
   import road7th.comm.PackageIn;
   import sevenDayTarget.dataAnalyzer.SevenDayTargetDataAnalyzer;
   import sevenDayTarget.model.NewTargetQuestionInfo;
   import sevenDayTarget.model.SevenDayTargetModel;
   import sevenDayTarget.view.SevenDayTargetMainView;
   
   public class SevenDayTargetManager extends EventDispatcher
   {
      
      private static var _instance:SevenDayTargetManager;
      
      public static var loadComplete:Boolean = false;
      
      private var _model:SevenDayTargetModel;
      
      private var _isShowIcon:Boolean;
      
      private var _sevenDayTargetView:SevenDayTargetMainView;
      
      public var today:int = 1;
      
      public var questionTemple:Array;
      
      public var isHallAct:Boolean = false;
      
      public function SevenDayTargetManager()
      {
         super();
      }
      
      public static function get Instance() : SevenDayTargetManager
      {
         if(_instance == null)
         {
            _instance = new SevenDayTargetManager();
         }
         return _instance;
      }
      
      public function setup() : void
      {
         this._model = new SevenDayTargetModel();
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.SEVENDAYTARGET_GODSROADS,this.pkgHandler);
         GodsRoadsManager.instance.addEventListener("XMLdata_Complete",this._dataReciver);
      }
      
      private function _dataReciver(e:Event) : void
      {
         var xml:XML = GodsRoadsManager.instance.XMLData;
         var analyzer:SevenDayTargetDataAnalyzer = new SevenDayTargetDataAnalyzer(SevenDayTargetManager.Instance.templateDataSetup);
         analyzer.analyze(xml);
      }
      
      public function get isShowIcon() : Boolean
      {
         return this._isShowIcon;
      }
      
      public function hide() : void
      {
         if(this._sevenDayTargetView != null)
         {
            this._sevenDayTargetView.dispose();
         }
         this._sevenDayTargetView = null;
      }
      
      public function onClickSevenDayTargetIcon() : void
      {
         var timer:Timer = null;
         SoundManager.instance.play("008");
         if(Boolean(this.questionTemple))
         {
            SocketManager.Instance.out.sevenDayTarget_enter(this.isHallAct);
         }
         else
         {
            timer = new Timer(1000);
            timer.addEventListener(TimerEvent.TIMER,this.__delayLoading);
            timer.start();
         }
      }
      
      private function __delayLoading(e:TimerEvent) : void
      {
         var timer:Timer = e.currentTarget as Timer;
         if(Boolean(this.questionTemple))
         {
            SocketManager.Instance.out.sevenDayTarget_enter(this.isHallAct);
            timer.stop();
            timer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.__delayLoading);
            timer = null;
         }
      }
      
      protected function __onClose(event:Event) : void
      {
         UIModuleSmallLoading.Instance.hide();
         UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__onClose);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__progressShow);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__completeShow);
      }
      
      private function __progressShow(event:UIModuleEvent) : void
      {
         if(event.module == UIModuleTypes.SEVENDAYTARGET)
         {
            UIModuleSmallLoading.Instance.progress = event.loader.progress * 100;
         }
      }
      
      private function __completeShow(event:UIModuleEvent) : void
      {
         if(event.module == UIModuleTypes.SEVENDAYTARGET)
         {
            UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__onClose);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__progressShow);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__completeShow);
            UIModuleSmallLoading.Instance.hide();
            loadComplete = true;
            this.showSevenDayTargetMainView();
         }
      }
      
      public function showSevenDayTargetMainView() : void
      {
         NewSevenDayAndNewPlayerManager.Instance.sevenDayMainViewPreOk = true;
         NewSevenDayAndNewPlayerManager.Instance.dispatchEvent(new Event("openSevenDayMainView"));
      }
      
      public function templateDataSetup(analyzer:DataAnalyzer) : void
      {
         if(analyzer is SevenDayTargetDataAnalyzer)
         {
            this.questionTemple = SevenDayTargetDataAnalyzer(analyzer).dataList;
         }
      }
      
      public function getQuestionInfoFromTemple(questionInfo:NewTargetQuestionInfo) : NewTargetQuestionInfo
      {
         var templeInfo:NewTargetQuestionInfo = null;
         for(var i:int = 0; i < this.questionTemple.length; i++)
         {
            templeInfo = this.questionTemple[i];
            if(templeInfo.questId == questionInfo.questId)
            {
               questionInfo.condition1Title = templeInfo.condition1Title;
               questionInfo.condition2Title = templeInfo.condition2Title;
               questionInfo.condition3Title = templeInfo.condition3Title;
               questionInfo.linkId = templeInfo.linkId;
               questionInfo.condition1Para = templeInfo.condition1Para;
               questionInfo.condition2Para = templeInfo.condition2Para;
               questionInfo.condition3Para = templeInfo.condition3Para;
               questionInfo.Period = templeInfo.Period;
            }
         }
         return questionInfo;
      }
      
      private function openOrclose(pkg:PackageIn) : void
      {
         this._isShowIcon = pkg.readBoolean();
         NewSevenDayAndNewPlayerManager.Instance.sevenDayOpen = this._isShowIcon;
         NewSevenDayAndNewPlayerManager.Instance.dispatchEvent(new Event("openUpdate"));
      }
      
      private function enterView(pkg:PackageIn) : void
      {
         var rewardsGeted:Boolean = false;
         var targetQuestNum:int = 0;
         var j:int = 0;
         var questionInfo:NewTargetQuestionInfo = null;
         var condition1:int = 0;
         var condition2:int = 0;
         var condition3:int = 0;
         var rewardNum:int = 0;
         var rewardArr:Array = null;
         var k:int = 0;
         var itemTempId:int = 0;
         var info:InventoryItemInfo = null;
         var totolDays:int = pkg.readInt();
         this.today = pkg.readInt();
         var questioninfoArr:Array = [];
         for(var i:int = 0; i < totolDays; i++)
         {
            rewardsGeted = pkg.readBoolean();
            targetQuestNum = pkg.readInt();
            for(j = 0; j < targetQuestNum; j++)
            {
               questionInfo = new NewTargetQuestionInfo();
               questionInfo.questId = pkg.readInt();
               questionInfo = this.getQuestionInfoFromTemple(questionInfo);
               questionInfo.iscomplete = pkg.readBoolean();
               condition1 = pkg.readInt();
               if(condition1 >= questionInfo.condition1Para)
               {
                  questionInfo.condition1Complete = true;
               }
               condition2 = pkg.readInt();
               if(condition2 >= questionInfo.condition2Para)
               {
                  questionInfo.condition2Complete = true;
               }
               condition3 = pkg.readInt();
               if(condition3 >= questionInfo.condition3Para)
               {
                  questionInfo.condition3Complete = true;
               }
               questionInfo.condition4 = pkg.readInt();
               questionInfo.getedReward = pkg.readBoolean();
               rewardNum = pkg.readInt();
               rewardArr = [];
               for(k = 0; k < rewardNum; k++)
               {
                  itemTempId = pkg.readInt();
                  info = new InventoryItemInfo();
                  info.ItemID = itemTempId;
                  pkg.readInt();
                  info.Count = pkg.readInt();
                  rewardArr.push(info);
                  pkg.readInt();
                  pkg.readInt();
                  pkg.readInt();
                  pkg.readInt();
                  pkg.readInt();
                  pkg.readBoolean();
               }
               questionInfo.rewardList = rewardArr;
               questioninfoArr.push(questionInfo);
            }
            pkg.readInt();
            this._model.sevenDayQuestionInfoArr = questioninfoArr;
         }
         if(loadComplete)
         {
            this.showSevenDayTargetMainView();
         }
         else
         {
            UIModuleSmallLoading.Instance.progress = 0;
            UIModuleSmallLoading.Instance.show();
            UIModuleSmallLoading.Instance.addEventListener(Event.CLOSE,this.__onClose);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__progressShow);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__completeShow);
            UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.SEVENDAYTARGET);
         }
      }
      
      private function pkgHandler(event:CrazyTankSocketEvent) : void
      {
         var pkg:PackageIn = event.pkg;
         var cmd:int = event._cmd;
         switch(cmd)
         {
            case SevenDayTargetPackageType.SEVENDAYTARGET_OPEN_CLOSE:
               this.openOrclose(pkg);
               break;
            case SevenDayTargetPackageType.SEVENDAYTARGET_ENTER:
               this.enterView(pkg);
               break;
            case SevenDayTargetPackageType.SEVENDAYTARGET_GET_REWARD:
               this.updateView(pkg);
         }
      }
      
      private function updateView(pkg:PackageIn) : void
      {
         var questionID:int = 0;
         var day:int = 0;
         var isComplete:Boolean = false;
         var success:Boolean = pkg.readBoolean();
         if(success)
         {
            questionID = pkg.readInt();
            day = pkg.readInt();
            isComplete = pkg.readBoolean();
            this.updateQuestionInfoArr(questionID,success,isComplete);
         }
      }
      
      private function updateQuestionInfoArr(questionID:int, success:Boolean, isComplete:Boolean) : void
      {
         var questionInfo:NewTargetQuestionInfo = null;
         for(var i:int = 0; i < this._model.sevenDayQuestionInfoArr.length; i++)
         {
            questionInfo = this._model.sevenDayQuestionInfoArr[i];
            if(questionInfo.questId == questionID)
            {
               questionInfo.getedReward = success;
               questionInfo.iscomplete = isComplete;
            }
         }
      }
      
      public function get model() : SevenDayTargetModel
      {
         return this._model;
      }
   }
}

