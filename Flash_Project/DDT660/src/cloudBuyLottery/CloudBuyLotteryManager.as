package cloudBuyLottery
{
   import cloudBuyLottery.data.CloudBuyAnalyzer;
   import cloudBuyLottery.loader.LoaderUIModule;
   import cloudBuyLottery.model.CloudBuyLotteryModel;
   import cloudBuyLottery.model.CloudBuyLotteryPackageType;
   import cloudBuyLottery.view.CloudBuyLotteryFrame;
   import cloudBuyLottery.view.ExpBar;
   import cloudBuyLottery.view.WinningLogItemInfo;
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.loader.LoadResourceManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.UIModuleTypes;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.PathManager;
   import ddt.manager.SocketManager;
   import ddt.manager.TimeManager;
   import flash.display.Sprite;
   import flash.events.Event;
   import hallIcon.HallIconManager;
   import hallIcon.HallIconType;
   import road7th.comm.PackageIn;
   
   public class CloudBuyLotteryManager extends Sprite
   {
      
      private static var _instance:CloudBuyLotteryManager;
      
      public static const UPDATE_INFO:String = "updateInfo";
      
      public static const INDIVIDUAL:String = "Individual";
      
      public static const FRAMEUPDATE:String = "frmeupdate";
      
      private var _model:CloudBuyLotteryModel;
      
      private var cloudBuyFrame:CloudBuyLotteryFrame;
      
      public var logArr:Array;
      
      public function CloudBuyLotteryManager(pct:PrivateClass)
      {
         super();
      }
      
      public static function get Instance() : CloudBuyLotteryManager
      {
         if(CloudBuyLotteryManager._instance == null)
         {
            CloudBuyLotteryManager._instance = new CloudBuyLotteryManager(new PrivateClass());
         }
         return CloudBuyLotteryManager._instance;
      }
      
      public function setup() : void
      {
         this._model = new CloudBuyLotteryModel();
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.CLOUDBUY,this.__cloudBuyLotteryHandle);
      }
      
      private function __cloudBuyLotteryHandle(e:CrazyTankSocketEvent) : void
      {
         var pkg:PackageIn = e.pkg;
         var cmd:int = e._cmd;
         switch(cmd)
         {
            case CloudBuyLotteryPackageType.OPEN_GAME:
               this.activityOpen(pkg);
               break;
            case CloudBuyLotteryPackageType.Enter_GAME:
               this.enterGame(pkg);
               break;
            case CloudBuyLotteryPackageType.BUY_GOODS:
               this.buyGoods(pkg);
               break;
            case CloudBuyLotteryPackageType.UPDATE_INFO:
               this.updateInfo(pkg);
               break;
            case CloudBuyLotteryPackageType.GET_REWARD:
               this.getReward(pkg);
         }
      }
      
      private function activityOpen(pkg:PackageIn) : void
      {
         this._model.isOpen = pkg.readBoolean();
         this.initIcon(this._model.isOpen);
         if(!this._model.isOpen)
         {
            return;
         }
         this._loadXml("BuyItemRewardLogList.ashx?ran=" + Math.random(),BaseLoader.REQUEST_LOADER);
      }
      
      private function enterGame(pkg:PackageIn) : void
      {
         this._model.templateId = pkg.readInt();
         this._model.templatedIdCount = pkg.readInt();
         this._model.validDate = pkg.readInt();
         this._model.property = pkg.readUTF().split(",");
         this._model.count = pkg.readInt();
         if(this._model.count <= 0)
         {
            return;
         }
         this._model.buyGoodsIDArray = new Array();
         this._model.buyGoodsCountArray = new Array();
         for(var i:int = 0; i < this._model.count; i++)
         {
            this._model.buyGoodsIDArray[i] = pkg.readInt();
            this._model.buyGoodsCountArray[i] = pkg.readInt();
         }
         this._model.buyMoney = pkg.readInt();
         this._model.maxNum = pkg.readInt();
         this._model.currentNum = pkg.readInt();
         this._model.luckTime = pkg.readDate();
         this._model.luckCount = pkg.readInt();
         this._model.remainTimes = pkg.readInt();
         this._model.isGame = pkg.readBoolean();
         LoaderUIModule.Instance.loadUIModule(this.initOpenFrame,null,UIModuleTypes.CLOUDBUY);
      }
      
      private function buyGoods(pkg:PackageIn) : void
      {
      }
      
      private function updateInfo(pkg:PackageIn) : void
      {
         var templateId:int = pkg.readInt();
         this._model.templatedIdCount = pkg.readInt();
         this._model.validDate = pkg.readInt();
         this._model.property = pkg.readUTF().split(",");
         this._model.maxNum = pkg.readInt();
         this._model.currentNum = pkg.readInt();
         this._model.luckTime = pkg.readDate();
         this._model.luckCount = pkg.readInt();
         this._model.remainTimes = pkg.readInt();
         this._model.isGame = pkg.readBoolean();
         if(this._model.templateId != templateId || this._model.isGame == false)
         {
            this._loadXml("BuyItemRewardLogList.ashx?ran=" + Math.random(),BaseLoader.REQUEST_LOADER);
         }
         this._model.templateId = templateId;
         dispatchEvent(new Event(UPDATE_INFO));
      }
      
      private function getReward(pkg:PackageIn) : void
      {
         this._model.isGetReward = pkg.readBoolean();
         if(this._model.isGetReward)
         {
            this._model.remainTimes = pkg.readInt();
            this._model.luckDrawId = pkg.readInt();
         }
         dispatchEvent(new Event(INDIVIDUAL));
         dispatchEvent(new Event(FRAMEUPDATE));
      }
      
      public function loaderCloudBuyFrame() : void
      {
         if(this._model.isOpen)
         {
            SocketManager.Instance.out.sendEnterGame();
         }
      }
      
      private function initOpenFrame() : void
      {
         this.cloudBuyFrame = ComponentFactory.Instance.creatComponentByStylename("cloudBuyFrame");
         LayerManager.Instance.addToLayer(this.cloudBuyFrame,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.ALPHA_BLOCKGOUND);
      }
      
      public function initIcon(flag:Boolean) : void
      {
         HallIconManager.instance.updateSwitchHandler(HallIconType.CLOUDBUYLOTTERY,flag);
         if(this.cloudBuyFrame != null && flag == false)
         {
            if(Boolean(this.cloudBuyFrame))
            {
               ObjectUtils.disposeObject(this.cloudBuyFrame);
            }
            this.cloudBuyFrame = null;
         }
      }
      
      public function returnTen(str:String) : int
      {
         if(str.length > 1)
         {
            return int(str.charAt(0)) + 1;
         }
         return 1;
      }
      
      public function returnABit(str:String) : int
      {
         if(str.length <= 1)
         {
            return int(str.charAt(0)) + 1;
         }
         return int(str.charAt(1)) + 1;
      }
      
      public function refreshTimePlayTxt() : String
      {
         var endTimestamp:Number = Number(this._model.luckTime.getTime());
         var nowTimestamp:Number = Number(TimeManager.Instance.Now().getTime());
         var differ:Number = endTimestamp - nowTimestamp;
         differ = differ < 0 ? 0 : differ;
         var timeTxtStr:String = "";
         var hours:int = differ / (1000 * 60 * 60);
         var minitues:int = (differ - hours * 1000 * 60 * 60) / (1000 * 60);
         var seconds:int = (differ - hours * 1000 * 60 * 60 - minitues * 1000 * 60) / 1000;
         return hours + ":" + minitues + ":" + seconds;
      }
      
      private function _loadXml($url:String, $requestType:int, $loadErrorMessage:String = "") : void
      {
         var loadSelfConsortiaMemberList:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath($url),$requestType);
         loadSelfConsortiaMemberList.loadErrorMessage = $loadErrorMessage;
         loadSelfConsortiaMemberList.analyzer = new CloudBuyAnalyzer(this.logComplete);
         LoadResourceManager.Instance.startLoad(loadSelfConsortiaMemberList);
      }
      
      private function logComplete(analyzer:DataAnalyzer) : void
      {
         var cellInfo:WinningLogItemInfo = null;
         if(analyzer is CloudBuyAnalyzer)
         {
            this.logArr = CloudBuyAnalyzer(analyzer).dataArr;
         }
         if(this.logArr == null || this.logArr.length <= 0)
         {
            return;
         }
         var list:Vector.<WinningLogItemInfo> = new Vector.<WinningLogItemInfo>();
         for(var i:int = 0; i < this.logArr.length; i++)
         {
            cellInfo = new WinningLogItemInfo();
            cellInfo.TemplateID = int(this.logArr[i].templateId);
            cellInfo.validate = int(this.logArr[i].validate);
            cellInfo.count = int(this.logArr[i].count);
            cellInfo.property = this.logArr[i].property.split(",");
            cellInfo.nickName = this.logArr[i].nickName;
            list.push(cellInfo);
         }
         this._model.myGiftData = list;
      }
      
      public function get model() : CloudBuyLotteryModel
      {
         return this._model;
      }
      
      public function get expBar() : ExpBar
      {
         return this.cloudBuyFrame.expBar;
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
