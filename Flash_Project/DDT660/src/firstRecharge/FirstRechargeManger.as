package firstRecharge
{
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.UIModuleLoader;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.UIModuleTypes;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.ItemManager;
   import ddt.manager.SocketManager;
   import ddt.view.UIModuleSmallLoading;
   import firstRecharge.info.RechargeData;
   import firstRecharge.view.AccumulationView;
   import firstRecharge.view.FirstTouchView;
   import flash.display.Sprite;
   import flash.events.Event;
   import road7th.comm.PackageIn;
   import wonderfulActivity.WonderfulActivityManager;
   
   public class FirstRechargeManger extends Sprite
   {
      
      private static var _instance:FirstRechargeManger;
      
      public static const REMOVEFIRSTRECHARGEICON:String = "removefirstrechargeicon";
      
      public static const ADDFIRSTRECHARGEICON:String = "addfirstrechargeicon";
      
      private var _firstTouchView:FirstTouchView;
      
      private var _accumulationView:AccumulationView;
      
      private var _isShowFirst:Boolean;
      
      private var _isOpen:Boolean;
      
      private var callback:Function;
      
      private var _isOver:Boolean;
      
      private var startTime:Date;
      
      private var endTime:Date;
      
      public var openFun:Function;
      
      public var endFun:Function;
      
      private var _goodsList:Vector.<RechargeData>;
      
      private var _goodsList_haiwai:Vector.<RechargeData>;
      
      private var _isopen:Boolean = false;
      
      public var rechargeMoneyTotal:int;
      
      public var rechargeGiftBagValue:int;
      
      public var rechargeEndTime:String;
      
      public function FirstRechargeManger()
      {
         super();
         this._goodsList = new Vector.<RechargeData>();
         this._goodsList_haiwai = new Vector.<RechargeData>();
      }
      
      public static function get Instance() : FirstRechargeManger
      {
         if(!_instance)
         {
            _instance = new FirstRechargeManger();
         }
         return _instance;
      }
      
      public function setup() : void
      {
         this.initEvent();
      }
      
      public function completeHander(analyzer:RechargeAnalyer) : void
      {
         this._goodsList = analyzer.goodsList;
         WonderfulActivityManager.Instance.updateChargeActiveTemplateXml();
      }
      
      public function get isopen() : Boolean
      {
         return this._isopen;
      }
      
      public function set ShowIcon(value:Function) : void
      {
         this.callback = value;
      }
      
      public function setGoods(data:RechargeData) : InventoryItemInfo
      {
         var info:InventoryItemInfo = new InventoryItemInfo();
         info.TemplateID = data.RewardItemID;
         info.StrengthenLevel = data.StrengthenLevel;
         info.AgilityCompose = data.AgilityCompose;
         info.AttackCompose = data.AttackCompose;
         info.LuckCompose = data.LuckCompose;
         info.DefendCompose = data.DefendCompose;
         info = ItemManager.fill(info);
         info.CanCompose = false;
         info.CanStrengthen = false;
         info.ValidDate = data.RewardItemValid;
         info.BindType = data.IsBind == true ? 0 : 1;
         info.IsBinds = data.IsBind;
         return info;
      }
      
      public function getGoodsList() : Vector.<RechargeData>
      {
         return this._goodsList;
      }
      
      public function getGoodsList_haiwai() : Vector.<RechargeData>
      {
         return this._goodsList_haiwai;
      }
      
      private function initEvent() : void
      {
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.CUMULATECHARGE_DATA,this.cumlatechargeData);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.CUMULATECHARGE_OPEN,this.cumlatechargeOpen);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.FIRSTRECHARGE_OPEN,this.__firstRechargeOpen);
      }
      
      private function __firstRechargeOpen(e:CrazyTankSocketEvent) : void
      {
         var rechargeData:RechargeData = null;
         this._goodsList_haiwai = new Vector.<RechargeData>();
         var pkg:PackageIn = e.pkg;
         var active:Boolean = pkg.readBoolean();
         if(active)
         {
            this._isopen = true;
            dispatchEvent(new Event(ADDFIRSTRECHARGEICON));
         }
         else
         {
            this._isopen = false;
            dispatchEvent(new Event(REMOVEFIRSTRECHARGEICON));
         }
         if(this.callback != null)
         {
            this.callback(this._isopen);
         }
         this.rechargeMoneyTotal = pkg.readInt();
         this.rechargeGiftBagValue = pkg.readInt();
         var _rechargeGiftBagId:int = pkg.readInt();
         this.rechargeEndTime = pkg.readUTF();
         var _rechargeGiftBagItemNum:int = pkg.readInt();
         for(var i:int = 0; i < _rechargeGiftBagItemNum; i++)
         {
            rechargeData = new RechargeData();
            rechargeData.RewardItemID = pkg.readInt();
            rechargeData.RewardItemCount = pkg.readInt();
            rechargeData.RewardItemValid = pkg.readInt();
            rechargeData.IsBind = pkg.readBoolean();
            rechargeData.StrengthenLevel = pkg.readInt();
            rechargeData.AttackCompose = pkg.readInt();
            rechargeData.DefendCompose = pkg.readInt();
            rechargeData.AgilityCompose = pkg.readInt();
            rechargeData.LuckCompose = pkg.readInt();
            this._goodsList_haiwai.push(rechargeData);
         }
         if(!this._isopen)
         {
            this.closeView();
         }
         else
         {
            dispatchEvent(new Event(ADDFIRSTRECHARGEICON));
         }
      }
      
      protected function getSpree(event:CrazyTankSocketEvent) : void
      {
      }
      
      protected function cumlatechargeOver(event:CrazyTankSocketEvent) : void
      {
         var pkg:PackageIn = event.pkg;
         this._isOver = pkg.readBoolean();
         this.endFun();
      }
      
      protected function cumlatechargeOpen(event:CrazyTankSocketEvent) : void
      {
         var pkg:PackageIn = event.pkg;
         this._isOpen = pkg.readBoolean();
         if(this.openFun != null)
         {
            this.openFun();
         }
         if(this._isOpen)
         {
            this.closeView();
         }
      }
      
      private function closeView() : void
      {
         if(Boolean(this._firstTouchView))
         {
            ObjectUtils.disposeObject(this._firstTouchView);
            this._firstTouchView = null;
         }
      }
      
      protected function cumlatechargeData(event:CrazyTankSocketEvent) : void
      {
         var obj:Object = null;
         var type:int = 0;
         var pkg:PackageIn = event.pkg;
         var count:int = pkg.readInt();
         for(var i:int = 0; i < count; i++)
         {
            obj = new Object();
            obj.userId = pkg.readInt();
            type = pkg.readInt();
            obj.chargeMoney = pkg.readInt();
         }
         if(type == 1)
         {
            this._isShowFirst = true;
         }
         else
         {
            this._isShowFirst = false;
         }
      }
      
      public function showView() : void
      {
         this._isShowFirst = true;
         if(this._isShowFirst)
         {
            if(!this._firstTouchView)
            {
               UIModuleSmallLoading.Instance.progress = 0;
               UIModuleSmallLoading.Instance.show();
               UIModuleSmallLoading.Instance.addEventListener(Event.CLOSE,this.__onSmallLoadingClose);
               UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.gemstoneCompHander);
               UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.gemstoneProgress);
               UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.FRISTRECHARGE_SYS);
            }
            else
            {
               this._firstTouchView = ComponentFactory.Instance.creatComponentByStylename("firstrecharge.firstView");
               this._firstTouchView.setGoodsList(this._goodsList_haiwai);
               LayerManager.Instance.addToLayer(this._firstTouchView,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
            }
         }
         else if(!this._accumulationView)
         {
            UIModuleSmallLoading.Instance.progress = 0;
            UIModuleSmallLoading.Instance.show();
            UIModuleSmallLoading.Instance.addEventListener(Event.CLOSE,this.__onSmallLoadingClose);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.gemstoneCompHander);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.gemstoneProgress);
            UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.FRISTRECHARGE_SYS);
         }
         else
         {
            this._accumulationView = ComponentFactory.Instance.creatComponentByStylename("firstrecharge.accumulationView");
            LayerManager.Instance.addToLayer(this._accumulationView,LayerManager.GAME_DYNAMIC_LAYER,true);
         }
      }
      
      private function gemstoneProgress(pEvent:UIModuleEvent) : void
      {
         if(pEvent.module == UIModuleTypes.FRISTRECHARGE_SYS)
         {
            UIModuleSmallLoading.Instance.progress = pEvent.loader.progress * 100;
         }
      }
      
      private function gemstoneCompHander(e:UIModuleEvent) : void
      {
         if(e.module != UIModuleTypes.FRISTRECHARGE_SYS)
         {
            return;
         }
         UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__onSmallLoadingClose);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.gemstoneCompHander);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.gemstoneProgress);
         UIModuleSmallLoading.Instance.hide();
         if(this._isShowFirst)
         {
            if(this._firstTouchView == null)
            {
               this._firstTouchView = ComponentFactory.Instance.creatComponentByStylename("firstrecharge.firstView");
               this._firstTouchView.setGoodsList(this._goodsList_haiwai);
               LayerManager.Instance.addToLayer(this._firstTouchView,LayerManager.GAME_DYNAMIC_LAYER,true);
            }
         }
         else if(this._accumulationView == null)
         {
            this._accumulationView = ComponentFactory.Instance.creatComponentByStylename("firstrecharge.accumulationView");
            LayerManager.Instance.addToLayer(this._accumulationView,LayerManager.GAME_DYNAMIC_LAYER,true);
         }
      }
      
      public function get isOpen() : Boolean
      {
         return this._isOpen;
      }
      
      public function get isOver() : Boolean
      {
         return this._isOver;
      }
      
      public function get isShowFirst() : Boolean
      {
         return this._isShowFirst;
      }
      
      private function __onSmallLoadingClose(e:Event) : void
      {
         UIModuleSmallLoading.Instance.hide();
         UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__onSmallLoadingClose);
      }
   }
}

