package mysteriousRoullete
{
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.UIModuleLoader;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.UIModuleTypes;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.view.TransactionsFrame;
   import ddt.view.UIModuleSmallLoading;
   import flash.display.Sprite;
   import flash.events.EventDispatcher;
   import flash.events.MouseEvent;
   import hallIcon.HallIconManager;
   import hallIcon.HallIconType;
   import mysteriousRoullete.view.MysteriousActivityView;
   import mysteriousRoullete.view.MysteriousShopView;
   import road7th.comm.PackageIn;
   import wonderfulActivity.WonderfulActivityManager;
   
   public class MysteriousManager extends EventDispatcher
   {
      
      private static var _instance:MysteriousManager;
      
      private var _transactionsFrame:TransactionsFrame;
      
      public var lotteryTimes:int;
      
      public var freeGetTimes:int;
      
      public var discountBuyTimes:int;
      
      public var startTime:Date;
      
      public var endTime:Date;
      
      public var mysteriousView:MysteriousActivityView;
      
      private var _func:Function;
      
      private var _funcParams:Array;
      
      public var viewType:int;
      
      public var selectIndex:int = -1;
      
      public var isMysteriousClose:Boolean = true;
      
      private var _mask:Sprite;
      
      public function MysteriousManager()
      {
         super();
      }
      
      public static function get instance() : MysteriousManager
      {
         if(!_instance)
         {
            _instance = new MysteriousManager();
         }
         return _instance;
      }
      
      public function setup() : void
      {
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.GET_MYSTERIOUS_DATA,this.__getMysteriousData);
      }
      
      private function __getMysteriousData(event:CrazyTankSocketEvent) : void
      {
         var pkg:PackageIn = event.pkg;
         this.lotteryTimes = pkg.readInt();
         this.freeGetTimes = pkg.readInt();
         this.discountBuyTimes = pkg.readInt();
         this.startTime = pkg.readDate();
         this.endTime = pkg.readDate();
         if(this.lotteryTimes <= 0)
         {
            if(this.mysteriousView && this.mysteriousView.view && this.mysteriousView.type == MysteriousActivityView.TYPE_SHOP)
            {
               (this.mysteriousView.view as MysteriousShopView).setTimes();
               if(this.freeGetTimes == 0 && this.discountBuyTimes == 0)
               {
                  this.isMysteriousClose = true;
               }
               return;
            }
            if(this.freeGetTimes == 0 && this.discountBuyTimes == 0)
            {
               if(Boolean(WonderfulActivityManager.Instance.frame))
               {
                  this.isMysteriousClose = true;
               }
               else
               {
                  HallIconManager.instance.updateSwitchHandler(HallIconType.MYSTERIOUROULETTE,false);
               }
               return;
            }
            this.viewType = MysteriousActivityView.TYPE_SHOP;
         }
         else
         {
            this.viewType = MysteriousActivityView.TYPE_ROULETTE;
         }
         this.showIcon();
      }
      
      public function showIcon() : void
      {
         this.isMysteriousClose = false;
         HallIconManager.instance.updateSwitchHandler(HallIconType.MYSTERIOUROULETTE,true);
      }
      
      public function showFrame() : void
      {
         var _view:MysteriousActivityView = null;
         SoundManager.instance.play("008");
         _view = new MysteriousActivityView();
         _view.init();
         _view.x = -227;
         HallIconManager.instance.showCommonFrame(_view,"wonderfulActivityManager.btnTxt14");
      }
      
      public function loadMysteriousRouletteModule(complete:Function = null, completeParams:Array = null) : void
      {
         this._func = complete;
         this._funcParams = completeParams;
         UIModuleSmallLoading.Instance.progress = 0;
         UIModuleSmallLoading.Instance.show();
         UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.loadCompleteHandler);
         UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.onUimoduleLoadProgress);
         UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.MYSTERIOUS_ROULETTE);
      }
      
      private function loadCompleteHandler(event:UIModuleEvent) : void
      {
         if(event.module == UIModuleTypes.MYSTERIOUS_ROULETTE)
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
      
      private function onUimoduleLoadProgress(event:UIModuleEvent) : void
      {
         if(event.module == UIModuleTypes.MYSTERIOUS_ROULETTE)
         {
            UIModuleSmallLoading.Instance.progress = event.loader.progress * 100;
         }
      }
      
      public function setView(view:MysteriousActivityView) : void
      {
         this.mysteriousView = view;
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
         LayerManager.Instance.addToLayer(this._mask,LayerManager.GAME_TOP_LAYER,false,LayerManager.ALPHA_BLOCKGOUND);
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
         MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("mysteriousRoulette.running"));
      }
      
      public function dispose() : void
      {
         this.mysteriousView = null;
         this.removeMask();
         if(Boolean(this._transactionsFrame))
         {
            ObjectUtils.disposeObject(this._transactionsFrame);
         }
         this._transactionsFrame = null;
      }
   }
}

