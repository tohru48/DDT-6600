package groupPurchase
{
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.LoadResourceManager;
   import com.pickgliss.loader.LoaderEvent;
   import com.pickgliss.loader.UIModuleLoader;
   import ddt.data.UIModuleTypes;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.loader.LoaderCreate;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.view.UIModuleSmallLoading;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import groupPurchase.data.GroupPurchaseAwardAnalyzer;
   import groupPurchase.view.GroupPurchaseMainView;
   import hallIcon.HallIconManager;
   import hallIcon.HallIconType;
   import road7th.comm.PackageIn;
   
   public class GroupPurchaseManager extends EventDispatcher
   {
      
      private static var _instance:GroupPurchaseManager;
      
      public static const REFRESH_DATA:String = "GROUP_PURCHASE_REFRESH_DATA";
      
      public static const REFRESH_RANK_DATA:String = "GROUP_PURCHASE_REFRESH_RANK_DATA";
      
      private var _func:Function;
      
      private var _funcParams:Array;
      
      private var _awardInfoList:Object;
      
      private var _isOpen:Boolean = false;
      
      private var _curTotalNum:int;
      
      private var _curMyNum:int;
      
      private var _itemId:int;
      
      private var _price:int;
      
      private var _isUseMoney:Boolean;
      
      private var _isUseBandMoney:Boolean;
      
      private var _endTime:Date;
      
      private var _discountList:Array;
      
      private var _miniNeedNum:int;
      
      private var _rankList:Array;
      
      public function GroupPurchaseManager(target:IEventDispatcher = null)
      {
         super(target);
      }
      
      public static function get instance() : GroupPurchaseManager
      {
         if(_instance == null)
         {
            _instance = new GroupPurchaseManager();
         }
         return _instance;
      }
      
      public function get awardInfoList() : Object
      {
         return this._awardInfoList;
      }
      
      public function get itemId() : int
      {
         return this._itemId;
      }
      
      public function get price() : int
      {
         return this._price;
      }
      
      public function get isUseMoney() : Boolean
      {
         return this._isUseMoney;
      }
      
      public function get isUseBandMoney() : Boolean
      {
         return this._isUseBandMoney;
      }
      
      public function get endTime() : Date
      {
         return this._endTime;
      }
      
      public function get miniNeedNum() : int
      {
         return this._miniNeedNum;
      }
      
      public function get rankList() : Array
      {
         return this._rankList;
      }
      
      public function get viewData() : Array
      {
         var curIndex:int = 0;
         var nextDiscount:int = 0;
         var nextNeedCount:int = 0;
         var nextReMoney:int = 0;
         var dataArray:Array = [];
         var len:int = int(this._discountList.length);
         for(var i:int = len - 1; i >= 0; i--)
         {
            if(this._curTotalNum >= this._discountList[i][0])
            {
               curIndex = i;
               break;
            }
         }
         var curDiscount:int = int(this._discountList[curIndex][1]);
         if(curIndex == this._discountList.length - 1)
         {
            nextDiscount = -1;
            nextNeedCount = -1;
         }
         else
         {
            nextDiscount = int(this._discountList[curIndex + 1][1]);
            nextNeedCount = int(this._discountList[curIndex + 1][0]);
         }
         var curReMoney:int = this._curMyNum * this._price * curDiscount / 100;
         if(nextDiscount == -1)
         {
            nextReMoney = this._curMyNum * this._price * curDiscount / 100;
         }
         else
         {
            nextReMoney = this._curMyNum * this._price * nextDiscount / 100;
         }
         dataArray.push(curDiscount);
         dataArray.push(nextDiscount);
         dataArray.push(nextNeedCount);
         dataArray.push(this._curTotalNum);
         dataArray.push(this._curMyNum);
         dataArray.push(curReMoney);
         dataArray.push(nextReMoney);
         return dataArray;
      }
      
      public function awardAnalyComplete(analyzer:GroupPurchaseAwardAnalyzer) : void
      {
         this._awardInfoList = analyzer.awardList;
      }
      
      public function setup() : void
      {
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.GROUP_PURCHASE,this.pkgHandler);
      }
      
      private function pkgHandler(event:CrazyTankSocketEvent) : void
      {
         var pkg:PackageIn = event.pkg;
         var cmd:int = pkg.readByte();
         switch(cmd)
         {
            case GroupPurchasePackageType.START_OR_END:
               this.openOrClose(pkg);
               break;
            case GroupPurchasePackageType.REFRESH_DATA:
               this.refreshPurchaseData(pkg);
               break;
            case GroupPurchasePackageType.REFRESH_RANK_DATA:
               this.refreshRankData(pkg);
         }
      }
      
      private function refreshRankData(pkg:PackageIn) : void
      {
         var tmpObj:Object = null;
         this._rankList = [];
         var count:int = pkg.readInt();
         for(var i:int = 0; i < count; i++)
         {
            tmpObj = {};
            tmpObj["rank"] = i + 1;
            tmpObj["name"] = pkg.readUTF();
            tmpObj["num"] = pkg.readInt();
            this._rankList.push(tmpObj);
         }
         dispatchEvent(new Event(REFRESH_RANK_DATA));
      }
      
      private function refreshPurchaseData(pkg:PackageIn) : void
      {
         this._curMyNum = pkg.readInt();
         this._curTotalNum = pkg.readInt();
         dispatchEvent(new Event(REFRESH_DATA));
      }
      
      private function openOrClose(pkg:PackageIn) : void
      {
         var loader:BaseLoader = null;
         this._isOpen = pkg.readBoolean();
         if(this._isOpen)
         {
            this._itemId = pkg.readInt();
            this._price = pkg.readInt();
            this._isUseMoney = pkg.readBoolean();
            this._isUseBandMoney = pkg.readBoolean();
            this._endTime = pkg.readDate();
            this.analyDiscountInfo(pkg.readUTF());
            this._miniNeedNum = pkg.readInt();
            loader = LoaderCreate.Instance.createGroupPurchaseAwardInfoLoader();
            loader.addEventListener(LoaderEvent.COMPLETE,this.loadAwardInfoComplete);
            LoadResourceManager.Instance.startLoad(loader);
         }
         else
         {
            HallIconManager.instance.updateSwitchHandler(HallIconType.GROUPPURCHASE,false);
         }
      }
      
      private function analyDiscountInfo(discountStr:String) : void
      {
         var tmp:Array = discountStr.split("|");
         this._discountList = [];
         this._discountList.push([0,0]);
         var len:int = int(tmp.length);
         for(var i:int = 0; i < len; i++)
         {
            this._discountList.push(tmp[i].split(","));
         }
      }
      
      private function loadAwardInfoComplete(event:LoaderEvent) : void
      {
         var loader:BaseLoader = event.loader as BaseLoader;
         loader.removeEventListener(LoaderEvent.COMPLETE,this.loadAwardInfoComplete);
         if(this._isOpen)
         {
            this.showIcon();
         }
      }
      
      public function get isOpen() : Boolean
      {
         return this._isOpen;
      }
      
      public function showIcon() : void
      {
         HallIconManager.instance.updateSwitchHandler(HallIconType.GROUPPURCHASE,true);
      }
      
      public function showFrame() : void
      {
         SoundManager.instance.play("008");
         var _view:GroupPurchaseMainView = new GroupPurchaseMainView();
         _view.init();
         HallIconManager.instance.showCommonFrame(_view,"wonderfulActivityManager.btnTxt9");
         _view.x = 18;
         _view.y = 106;
      }
      
      public function loadResModule(complete:Function = null, completeParams:Array = null) : void
      {
         this._func = complete;
         this._funcParams = completeParams;
         UIModuleSmallLoading.Instance.progress = 0;
         UIModuleSmallLoading.Instance.show();
         UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.loadCompleteHandler);
         UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.onUimoduleLoadProgress);
         UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.GROUP_PURCHASE);
      }
      
      private function onUimoduleLoadProgress(event:UIModuleEvent) : void
      {
         if(event.module == UIModuleTypes.GROUP_PURCHASE)
         {
            UIModuleSmallLoading.Instance.progress = event.loader.progress * 100;
         }
      }
      
      private function loadCompleteHandler(event:UIModuleEvent) : void
      {
         if(event.module == UIModuleTypes.GROUP_PURCHASE)
         {
            UIModuleSmallLoading.Instance.hide();
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.loadCompleteHandler);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.onUimoduleLoadProgress);
            if(null != this._func)
            {
               this._func.apply(null,this._funcParams);
            }
            this._func = null;
            this._funcParams = null;
         }
      }
   }
}

