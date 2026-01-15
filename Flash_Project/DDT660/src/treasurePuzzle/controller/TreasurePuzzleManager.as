package treasurePuzzle.controller
{
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.UIModuleLoader;
   import com.pickgliss.ui.ComponentFactory;
   import ddt.data.UIModuleTypes;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.SocketManager;
   import ddt.view.UIModuleSmallLoading;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import hallIcon.HallIconManager;
   import hallIcon.HallIconType;
   import road7th.comm.PackageIn;
   import treasurePuzzle.data.TreasurePuzzlePackageType;
   import treasurePuzzle.data.TreasurePuzzlePiceData;
   import treasurePuzzle.data.TreasurePuzzleRewardData;
   import treasurePuzzle.model.TreasurePuzzleModel;
   import treasurePuzzle.view.TreasurePuzzleMainView;
   
   public class TreasurePuzzleManager extends EventDispatcher
   {
      
      private static var _instance:TreasurePuzzleManager;
      
      public static var loadComplete:Boolean = false;
      
      private var _isShowIcon:Boolean;
      
      private var _treasurePuzzleView:TreasurePuzzleMainView;
      
      private var _model:TreasurePuzzleModel;
      
      public var currentPuzzle:int;
      
      public function TreasurePuzzleManager()
      {
         super();
      }
      
      public static function get Instance() : TreasurePuzzleManager
      {
         if(_instance == null)
         {
            _instance = new TreasurePuzzleManager();
         }
         return _instance;
      }
      
      public function get isShowIcon() : Boolean
      {
         return this._isShowIcon;
      }
      
      public function setup() : void
      {
         this._model = new TreasurePuzzleModel();
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.TREASUREPUZZLE_SYSTEM,this.pkgHandler);
      }
      
      private function pkgHandler(event:CrazyTankSocketEvent) : void
      {
         var pkg:PackageIn = event.pkg;
         var cmd:int = event._cmd;
         switch(cmd)
         {
            case TreasurePuzzlePackageType.TREASUREPUZZLE_OPEN_CLOSE:
               this.openOrclose(pkg);
               break;
            case TreasurePuzzlePackageType.TREASUREPUZZLE_ENTER:
               this.enterView(pkg);
               break;
            case TreasurePuzzlePackageType.TREASUREPUZZLE_SEE_REWARD:
               this.seeReward(pkg);
               break;
            case TreasurePuzzlePackageType.TREASUREPUZZLE_GET_REWARD:
               this.getReward(pkg);
               break;
            case TreasurePuzzlePackageType.TREASUREPUZZLE_FLUSH:
               this.flushData(pkg);
         }
      }
      
      private function openOrclose(pkg:PackageIn) : void
      {
         this._isShowIcon = pkg.readBoolean();
         if(this._isShowIcon)
         {
            this.addEnterIcon();
         }
         else
         {
            this.disposeEnterIcon();
         }
      }
      
      private function enterView(pkg:PackageIn) : void
      {
         var piceData:TreasurePuzzlePiceData = null;
         var modelArr:Array = new Array();
         var totol:int = pkg.readInt();
         for(var i:int = 0; i < totol; i++)
         {
            piceData = new TreasurePuzzlePiceData();
            piceData.id = pkg.readInt();
            piceData.hole1Need = pkg.readInt();
            piceData.hole1Have = pkg.readInt();
            piceData.hole2Need = pkg.readInt();
            piceData.hole2Have = pkg.readInt();
            piceData.hole3Need = pkg.readInt();
            piceData.hole3Have = pkg.readInt();
            piceData.hole4Need = pkg.readInt();
            piceData.hole4Have = pkg.readInt();
            piceData.hole5Need = pkg.readInt();
            piceData.hole5Have = pkg.readInt();
            piceData.hole6Need = pkg.readInt();
            piceData.hole6Have = pkg.readInt();
            piceData._canGetReward = pkg.readBoolean();
            modelArr.push(piceData);
         }
         this._model.dataArr = modelArr;
         if(loadComplete)
         {
            this.showTreasurePuzzleMainView();
         }
         else
         {
            UIModuleSmallLoading.Instance.progress = 0;
            UIModuleSmallLoading.Instance.show();
            UIModuleSmallLoading.Instance.addEventListener(Event.CLOSE,this.__onClose);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__progressShow);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__completeShow);
            UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.TREASURE_PUZZLE);
         }
      }
      
      private function flushData(pkg:PackageIn) : void
      {
         var piceData:TreasurePuzzlePiceData = null;
         var modelArr:Array = new Array();
         var totol:int = pkg.readInt();
         for(var i:int = 0; i < totol; i++)
         {
            piceData = new TreasurePuzzlePiceData();
            piceData.id = pkg.readInt();
            piceData.hole1Need = pkg.readInt();
            piceData.hole1Have = pkg.readInt();
            piceData.hole2Need = pkg.readInt();
            piceData.hole2Have = pkg.readInt();
            piceData.hole3Need = pkg.readInt();
            piceData.hole3Have = pkg.readInt();
            piceData.hole4Need = pkg.readInt();
            piceData.hole4Have = pkg.readInt();
            piceData.hole5Need = pkg.readInt();
            piceData.hole5Have = pkg.readInt();
            piceData.hole6Need = pkg.readInt();
            piceData.hole6Have = pkg.readInt();
            piceData._canGetReward = pkg.readBoolean();
            modelArr.push(piceData);
         }
         this._model.dataArr = modelArr;
         this._treasurePuzzleView.flushRewardBnt();
      }
      
      private function seeReward(pkg:PackageIn) : void
      {
         var id:int = 0;
         var piceData:TreasurePuzzlePiceData = null;
         var j:int = 0;
         var isShiwu:Boolean = false;
         var picData2:TreasurePuzzlePiceData = null;
         var rewardList:Array = null;
         var k:int = 0;
         var rewardData:TreasurePuzzleRewardData = null;
         var modelArr:Array = new Array();
         var totol:int = pkg.readInt();
         for(var i:int = 0; i < totol; i++)
         {
            id = pkg.readInt();
            for(j = 0; j < this._model.dataArr.length; j++)
            {
               picData2 = this._model.dataArr[j];
               if(id == picData2.id)
               {
                  piceData = this._model.dataArr[j];
               }
            }
            isShiwu = pkg.readBoolean();
            if(isShiwu)
            {
               piceData.isShiwu = true;
            }
            else
            {
               piceData.isShiwu = false;
               piceData.rewardNum = pkg.readInt();
               rewardList = new Array();
               for(k = 0; k < piceData.rewardNum; k++)
               {
                  rewardData = new TreasurePuzzleRewardData();
                  rewardData.rewardId = pkg.readInt();
                  rewardData.rewardNum = pkg.readInt();
                  rewardList.push(rewardData);
               }
               piceData.rewardList = rewardList;
            }
         }
         this._treasurePuzzleView.showHelpView();
      }
      
      private function getReward(pkg:PackageIn) : void
      {
         var isShiwu:Boolean = false;
         var success:Boolean = pkg.readBoolean();
         if(success)
         {
            isShiwu = pkg.readBoolean();
            if(isShiwu)
            {
               this._treasurePuzzleView.showShiwuInfoView();
            }
         }
      }
      
      public function addEnterIcon() : void
      {
         HallIconManager.instance.updateSwitchHandler(HallIconType.TREASUREPUZZLE,true);
      }
      
      private function disposeEnterIcon() : void
      {
         HallIconManager.instance.updateSwitchHandler(HallIconType.TREASUREPUZZLE,false);
      }
      
      public function onClickTreasurePuzzleIcon() : void
      {
         SocketManager.Instance.out.treasurePuzzle_enter();
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
         if(event.module == UIModuleTypes.TREASURE_PUZZLE)
         {
            UIModuleSmallLoading.Instance.progress = event.loader.progress * 100;
         }
      }
      
      private function __completeShow(event:UIModuleEvent) : void
      {
         if(event.module == UIModuleTypes.TREASURE_PUZZLE)
         {
            UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__onClose);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__progressShow);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__completeShow);
            UIModuleSmallLoading.Instance.hide();
            loadComplete = true;
            this.showTreasurePuzzleMainView();
         }
      }
      
      private function showTreasurePuzzleMainView() : void
      {
         this._treasurePuzzleView = ComponentFactory.Instance.creatComponentByStylename("treasurePuzzle.TreasurePuzzleFrame");
         this._treasurePuzzleView.show();
      }
      
      public function get model() : TreasurePuzzleModel
      {
         return this._model;
      }
      
      public function hide() : void
      {
         if(this._treasurePuzzleView != null)
         {
            this._treasurePuzzleView.dispose();
         }
         this._treasurePuzzleView = null;
      }
   }
}

