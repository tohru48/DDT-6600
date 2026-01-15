package sevenDayTarget.controller
{
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.UIModuleLoader;
   import ddt.data.UIModuleTypes;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.socket.SevenDayTargetPackageType;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.SocketManager;
   import ddt.view.UIModuleSmallLoading;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import road7th.comm.PackageIn;
   import sevenDayTarget.model.NewPlayerRewardInfo;
   import sevenDayTarget.model.NewPlayerRewardModel;
   import sevenDayTarget.view.NewPlayerRewardMainView;
   
   public class NewPlayerRewardManager extends EventDispatcher
   {
      
      private static var _instance:NewPlayerRewardManager;
      
      private var _isShowIcon:Boolean;
      
      private var _model:NewPlayerRewardModel;
      
      public function NewPlayerRewardManager()
      {
         super();
      }
      
      public static function get Instance() : NewPlayerRewardManager
      {
         if(_instance == null)
         {
            _instance = new NewPlayerRewardManager();
         }
         return _instance;
      }
      
      public function get isShowIcon() : Boolean
      {
         return this._isShowIcon;
      }
      
      public function setup() : void
      {
         this._model = new NewPlayerRewardModel();
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.SEVENDAYTARGET_NEWPLAYERREWARD,this.pkgHandler);
      }
      
      public function get model() : NewPlayerRewardModel
      {
         return this._model;
      }
      
      private function pkgHandler(event:CrazyTankSocketEvent) : void
      {
         var pkg:PackageIn = event.pkg;
         var cmd:int = event._cmd;
         switch(cmd)
         {
            case SevenDayTargetPackageType.NEWPLAYERREWARD_OPEN_CLOSE:
               this.openOrclose(pkg);
               break;
            case SevenDayTargetPackageType.NEWPLAYERREWARD_ENTER:
               this.enterView(pkg);
               break;
            case SevenDayTargetPackageType.NEWPLAYERREWARD_GET_REWARD:
               this.updateView(pkg);
         }
      }
      
      private function updateView(pkg:PackageIn) : void
      {
         var questionID:int = 0;
         var isComplete:Boolean = false;
         var success:Boolean = pkg.readBoolean();
         if(success)
         {
            questionID = pkg.readInt();
            isComplete = pkg.readBoolean();
            this.updateQuestionInfoArr(questionID,success,isComplete);
         }
      }
      
      private function updateQuestionInfoArr(questionID:int, success:Boolean, isComplete:Boolean) : void
      {
         var questionInfo:NewPlayerRewardInfo = null;
         for(var i:int = 0; i < this._model.chongzhiInfoArr.length; i++)
         {
            questionInfo = this._model.chongzhiInfoArr[i];
            if(questionInfo.questId == questionID)
            {
               questionInfo.getRewarded = success;
               questionInfo.finished = isComplete;
               return;
            }
         }
         for(var j:int = 0; j < this._model.xiaofeiInfoArr.length; j++)
         {
            questionInfo = this._model.xiaofeiInfoArr[j];
            if(questionInfo.questId == questionID)
            {
               questionInfo.getRewarded = success;
               questionInfo.finished = isComplete;
               return;
            }
         }
         for(var k:int = 0; k < this._model.hunliInfoArr.length; k++)
         {
            questionInfo = this._model.hunliInfoArr[k];
            if(questionInfo.questId == questionID)
            {
               questionInfo.getRewarded = success;
               questionInfo.finished = isComplete;
               return;
            }
         }
      }
      
      private function openOrclose(pkg:PackageIn) : void
      {
         this._isShowIcon = pkg.readBoolean();
         NewSevenDayAndNewPlayerManager.Instance.newPlayerOpen = this._isShowIcon;
         NewSevenDayAndNewPlayerManager.Instance.dispatchEvent(new Event("openUpdate"));
      }
      
      public function enterView(pkg:PackageIn) : void
      {
         var newArr:Array = null;
         var count:int = 0;
         var j:int = 0;
         var info:NewPlayerRewardInfo = null;
         var rewardNum:int = 0;
         var arr:Array = null;
         var k:int = 0;
         var itemInfo:InventoryItemInfo = null;
         for(var i:int = 0; i < 3; i++)
         {
            newArr = new Array();
            count = pkg.readInt();
            for(j = 0; j < count; j++)
            {
               info = new NewPlayerRewardInfo();
               info.questId = pkg.readInt();
               info.num = pkg.readInt();
               if(i == 0)
               {
                  info.bgType = NewPlayerRewardMainView.CHONGZHI;
               }
               else if(i == 1)
               {
                  info.bgType = NewPlayerRewardMainView.XIAOFEI;
               }
               else if(i == 2)
               {
                  info.bgType = NewPlayerRewardMainView.HUNLI;
               }
               info.finished = pkg.readBoolean();
               info.getRewarded = pkg.readBoolean();
               rewardNum = pkg.readInt();
               arr = new Array();
               for(k = 0; k < rewardNum; k++)
               {
                  itemInfo = new InventoryItemInfo();
                  itemInfo.ItemID = pkg.readInt();
                  itemInfo.Count = pkg.readInt();
                  arr.push(itemInfo);
               }
               info.rewardArr = arr;
               newArr.push(info);
            }
            if(i == 0)
            {
               this._model.chongzhiInfoArr = newArr;
            }
            else if(i == 1)
            {
               this._model.xiaofeiInfoArr = newArr;
            }
            else if(i == 2)
            {
               this._model.hunliInfoArr = newArr;
            }
         }
         if(SevenDayTargetManager.loadComplete)
         {
            this.showNewPlayerRewardMainView();
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
            SevenDayTargetManager.loadComplete = true;
            this.showNewPlayerRewardMainView();
         }
      }
      
      private function showNewPlayerRewardMainView() : void
      {
         NewSevenDayAndNewPlayerManager.Instance.newPlayerMainViewPreOk = true;
         NewSevenDayAndNewPlayerManager.Instance.dispatchEvent(new Event("openSevenDayMainView"));
      }
   }
}

