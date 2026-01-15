package treasureHunting
{
   import com.pickgliss.events.ComponentEvent;
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.UIModuleLoader;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.EquipType;
   import ddt.data.UIModuleTypes;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.events.BagEvent;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.ChatManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.view.TransactionsFrame;
   import ddt.view.UIModuleSmallLoading;
   import ddt.view.caddyII.CaddyAwardInfo;
   import ddt.view.caddyII.CaddyAwardListFrame;
   import ddt.view.caddyII.CaddyModel;
   import ddt.view.caddyII.LookTrophy;
   import flash.display.Sprite;
   import flash.events.EventDispatcher;
   import flash.events.MouseEvent;
   import flash.utils.Dictionary;
   import hallIcon.HallIconManager;
   import hallIcon.HallIconType;
   import road7th.comm.PackageIn;
   import treasureHunting.views.TreasureEnterView;
   import treasureHunting.views.TreasureHuntingFrame;
   import wonderfulActivity.WonderfulActivityManager;
   
   public class TreasureManager extends EventDispatcher
   {
      
      private static var _instance:TreasureManager;
      
      private var treasureFrame:TreasureHuntingFrame;
      
      private var showPrize:LookTrophy;
      
      private var _transactionsFrame:TransactionsFrame;
      
      private var _listView:CaddyAwardListFrame;
      
      public var needMoney:int = 0;
      
      private var _dataXml:XML;
      
      private var _awards:Vector.<CaddyAwardInfo>;
      
      private var _func:Function;
      
      private var _funcParams:Array;
      
      public var hasItemsInbag:Boolean = false;
      
      public var isMovieComplete:Boolean = true;
      
      public var isActivityOpen:Boolean = false;
      
      public var startDate:Date;
      
      public var endDate:Date;
      
      private var _mask:Sprite;
      
      private var bagData:Dictionary;
      
      public var isAlert:Boolean = false;
      
      public var lightIndexArr:Array;
      
      public var msgStr:String;
      
      public var countMsg:String;
      
      public function TreasureManager()
      {
         super();
         this.bagData = new Dictionary();
         this.initEvent();
      }
      
      public static function get instance() : TreasureManager
      {
         if(!_instance)
         {
            _instance = new TreasureManager();
         }
         return _instance;
      }
      
      private function initEvent() : void
      {
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.PAY_FOR_HUNTING,this.onPayForHunting);
         PlayerManager.Instance.Self.CaddyBag.addEventListener(BagEvent.UPDATE,this._update);
      }
      
      public function setup() : void
      {
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.INIT_TREASURE,this.__onInitTreasure);
      }
      
      private function __onInitTreasure(event:CrazyTankSocketEvent) : void
      {
         var pkg:PackageIn = event.pkg;
         var isShowTip:Boolean = pkg.readBoolean();
         this.isActivityOpen = pkg.readBoolean();
         if(this.isActivityOpen)
         {
            this.startDate = pkg.readDate();
            this.endDate = pkg.readDate();
            TreasureManager.instance.needMoney = pkg.readInt();
            this.showIcon();
            if(isShowTip)
            {
               ChatManager.Instance.sysChatAmaranth(LanguageMgr.GetTranslation("treasureHunting.start"));
            }
         }
         else
         {
            if(!WonderfulActivityManager.Instance.frame)
            {
               HallIconManager.instance.updateSwitchHandler(HallIconType.TREASUREHUNTING,false);
            }
            if(isShowTip)
            {
               ChatManager.Instance.sysChatAmaranth(LanguageMgr.GetTranslation("treasureHunting.end"));
            }
            this.removeMask();
         }
      }
      
      public function showIcon() : void
      {
         HallIconManager.instance.updateSwitchHandler(HallIconType.TREASUREHUNTING,true);
      }
      
      public function showFrame() : void
      {
         var _view:TreasureEnterView = null;
         SoundManager.instance.play("008");
         _view = new TreasureEnterView();
         _view.init();
         _view.x = -227;
         HallIconManager.instance.showCommonFrame(_view,"wonderfulActivityManager.btnTxt12");
      }
      
      public function loadTreasureHuntingModule(complete:Function = null, completeParams:Array = null) : void
      {
         this._func = complete;
         this._funcParams = completeParams;
         UIModuleSmallLoading.Instance.progress = 0;
         UIModuleSmallLoading.Instance.show();
         UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.loadCompleteHandler);
         UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.onUimoduleLoadProgress);
         UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.TREASURE_HUNTING);
      }
      
      private function onUimoduleLoadProgress(event:UIModuleEvent) : void
      {
         if(event.module == UIModuleTypes.TREASURE_HUNTING)
         {
            UIModuleSmallLoading.Instance.progress = event.loader.progress * 100;
         }
      }
      
      private function loadCompleteHandler(event:UIModuleEvent) : void
      {
         if(event.module == UIModuleTypes.TREASURE_HUNTING)
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
      
      private function _update(event:BagEvent) : void
      {
         var key:String = null;
         var tmpData:Dictionary = event.changedSlots;
         if(Boolean(this.treasureFrame) && Boolean(this.treasureFrame.bagView))
         {
            this.treasureFrame.bagView.updateData(tmpData);
         }
         for(key in tmpData)
         {
            this.bagData[key] = tmpData[key];
         }
      }
      
      private function onPayForHunting(event:CrazyTankSocketEvent) : void
      {
         var templeteId:int = 0;
         var categoryIndex:int = 0;
         var str:String = null;
         var count:int = 0;
         this.lightIndexArr = [];
         this.msgStr = LanguageMgr.GetTranslation("treasureHunting.msg");
         var pkg:PackageIn = event.pkg;
         this.isActivityOpen = pkg.readBoolean();
         var len:int = pkg.readInt();
         if(this.isActivityOpen == false || len <= 0)
         {
            this.treasureFrame.huntingBtn.enable = true;
            TreasureManager.instance.isMovieComplete = true;
            this.removeMask();
            return;
         }
         this.countMsg = LanguageMgr.GetTranslation("treasureHunting.count",len);
         for(var i:int = 0; i <= len - 1; i++)
         {
            templeteId = pkg.readInt();
            categoryIndex = pkg.readInt();
            str = pkg.readUTF();
            count = pkg.readInt();
            this.msgStr += str + "x" + count + "  ";
            this.lightIndexArr.push(categoryIndex - 1);
         }
         this.treasureFrame.creatMoveCell(templeteId);
         var lukStoneCount:int = pkg.readInt();
         if(lukStoneCount > 0)
         {
            this.msgStr += "幸运彩石x" + lukStoneCount;
            this.treasureFrame.creatMoveCell(11550);
            SocketManager.Instance.out.sendQequestBadLuck();
         }
         if(len == 1)
         {
            this.treasureFrame.startTimer();
         }
         else
         {
            this.treasureFrame.lightUpItemArr();
         }
      }
      
      public function openShowPrize() : void
      {
         this.showPrize = ComponentFactory.Instance.creatCustomObject("treasureHunting.LookTrophy");
         this.showPrize.show(CaddyModel.instance.getCaddyTrophy(EquipType.TREASURE_CADDY));
         this.showPrize.addEventListener(ComponentEvent.DISPOSE,this.onShowPrizeDispose);
      }
      
      public function openRankPrize() : void
      {
         this._listView = ComponentFactory.Instance.creatComponentByStylename("caddyAwardListFrame");
         LayerManager.Instance.addToLayer(this._listView,LayerManager.GAME_TOP_LAYER,true,LayerManager.NONE_BLOCKGOUND);
      }
      
      private function onShowPrizeDispose(event:ComponentEvent) : void
      {
         this.showPrize.removeEventListener(ComponentEvent.DISPOSE,this.onShowPrizeDispose);
         ObjectUtils.disposeObject(this.showPrize);
         this.showPrize = null;
      }
      
      public function showTransactionFrame(str:String, payFun:Function = null, clickFun:Function = null, target:Sprite = null, autoClose:Boolean = true) : void
      {
         this._transactionsFrame = ComponentFactory.Instance.creatComponentByStylename("treasureHunting.TransactionsFrame");
         this._transactionsFrame.setTxt(str);
         this._transactionsFrame.buyFunction = payFun;
         this._transactionsFrame.clickFunction = clickFun;
         this._transactionsFrame.target = target;
         this._transactionsFrame.autoClose = autoClose;
         LayerManager.Instance.addToLayer(this._transactionsFrame,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.ALPHA_BLOCKGOUND);
      }
      
      public function closeTransactionFrame() : void
      {
         if(Boolean(this._transactionsFrame))
         {
            this._transactionsFrame.dispose();
         }
      }
      
      public function addMask() : void
      {
         if(this._mask == null)
         {
            this._mask = new Sprite();
            this._mask.graphics.beginFill(0,0);
            this._mask.graphics.drawRect(0,0,2000,1200);
            this._mask.graphics.endFill();
            this._mask.addEventListener(MouseEvent.CLICK,this.onMaskClick);
         }
         LayerManager.Instance.addToLayer(this._mask,LayerManager.GAME_DYNAMIC_LAYER,false,LayerManager.ALPHA_BLOCKGOUND);
      }
      
      public function removeMask() : void
      {
         if(this._mask != null)
         {
            this._mask.parent.removeChild(this._mask);
            this._mask.removeEventListener(MouseEvent.CLICK,this.onMaskClick);
            this._mask = null;
         }
      }
      
      private function onMaskClick(event:MouseEvent) : void
      {
         MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("treasureHunting.huntingNow"));
      }
      
      public function checkBag() : Boolean
      {
         var i:String = null;
         var cellInfo:InventoryItemInfo = null;
         for(i in this.bagData)
         {
            cellInfo = PlayerManager.Instance.Self.CaddyBag.getItemAt(int(i));
            if(cellInfo != null)
            {
               return true;
            }
         }
         return false;
      }
      
      public function get awards() : Vector.<CaddyAwardInfo>
      {
         return this._awards;
      }
      
      private function removeEvent() : void
      {
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.PAY_FOR_HUNTING,this.onPayForHunting);
         PlayerManager.Instance.Self.CaddyBag.removeEventListener(BagEvent.UPDATE,this._update);
      }
      
      public function dispose() : void
      {
         this.removeMask();
         if(this.showPrize != null)
         {
            ObjectUtils.disposeObject(this.showPrize);
         }
         this.showPrize = null;
         if(this._listView != null)
         {
            ObjectUtils.disposeObject(this._listView);
         }
         this._listView = null;
         if(this._transactionsFrame != null)
         {
            ObjectUtils.disposeObject(this._transactionsFrame);
         }
         this._transactionsFrame = null;
         if(this._mask != null)
         {
            ObjectUtils.disposeObject(this._mask);
         }
         this._mask = null;
      }
      
      public function setFrame(frame:TreasureHuntingFrame) : void
      {
         this.treasureFrame = frame;
      }
   }
}

