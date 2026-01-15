package ddt.manager
{
   import bagAndInfo.cell.BagCell;
   import com.pickgliss.action.FunctionAction;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.UIModuleLoader;
   import com.pickgliss.manager.CacheSysManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import ddt.command.QuickBuyFrame;
   import ddt.constants.CacheConsts;
   import ddt.data.EquipType;
   import ddt.data.UIModuleTypes;
   import ddt.data.box.BoxGoodsTempInfo;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.events.BagEvent;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.states.StateType;
   import ddt.view.UIModuleSmallLoading;
   import ddt.view.caddyII.CaddyAwardListFrame;
   import ddt.view.caddyII.CaddyEvent;
   import ddt.view.caddyII.CaddyFrame;
   import ddt.view.caddyII.CaddyModel;
   import ddt.view.caddyII.card.CardFrame;
   import ddt.view.caddyII.card.CardSoulBoxFrame;
   import ddt.view.caddyII.vip.VipBoxFrame;
   import ddt.view.roulette.RouletteBoxPanel;
   import ddt.view.roulette.RouletteEvent;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import road7th.comm.PackageIn;
   import surpriseRoulette.view.SurpriseRouletteView;
   
   public class RouletteManager extends EventDispatcher
   {
      
      private static var _instance:RouletteManager = null;
      
      public static const SLEEP:int = 0;
      
      public static const OPEN_ROULETTEBOX:int = 1;
      
      public static const OPEN_CADDY:int = 2;
      
      public static const NO_BOX:int = 0;
      
      public static const ROULETTEBOX:int = 1;
      
      public static const CADDY:int = 2;
      
      private var _rouletteBoxkeyCount:int = -1;
      
      private var _sRouletteKeyCount:int = 10;
      
      private var id:int;
      
      private var _caddyKeyCount:int = -1;
      
      private var _templateIDList:Array;
      
      private var _bagType:int;
      
      private var _place:int;
      
      private var _stateAfterBuyKey:int = 0;
      
      private var _boxType:int = 0;
      
      private var _numList:Array = [0,0,0,4,4,4,3,3,3,2];
      
      public var dataList:Vector.<Object>;
      
      public var goodList:Vector.<InventoryItemInfo>;
      
      private var _goodsInfo:ItemTemplateInfo;
      
      private var limdataList:Vector.<Object>;
      
      public function RouletteManager(target:IEventDispatcher = null)
      {
         super(target);
      }
      
      public static function get instance() : RouletteManager
      {
         if(_instance == null)
         {
            _instance = new RouletteManager();
         }
         return _instance;
      }
      
      public function setup() : void
      {
         this.init();
         this.initEvent();
      }
      
      private function init() : void
      {
         this._templateIDList = new Array();
      }
      
      private function initEvent() : void
      {
         PlayerManager.Instance.Self.PropBag.addEventListener(BagEvent.UPDATE,this._bagUpdate);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.CADDY_GET_BADLUCK,this.__getBadLuckHandler);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.LOTTERY_ALTERNATE_LIST,this._showBox);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.LUCKSTONE_RANK_LIMIT,this.luckStoneRankLimit);
      }
      
      protected function luckStoneRankLimit(event:CrazyTankSocketEvent) : void
      {
         var obj:Object = null;
         var events:CaddyEvent = null;
         var lastTime:String = null;
         var count1:int = 0;
         var j:int = 0;
         this.limdataList = new Vector.<Object>();
         var pkg:PackageIn = event.pkg;
         var isStart:Boolean = pkg.readBoolean();
         if(isStart)
         {
            count1 = pkg.readInt();
            for(j = 0; j < count1; j++)
            {
               obj = new Object();
               obj.TemplateID = pkg.readInt();
               obj.count = this._numList[j];
               this.limdataList.push(obj);
            }
            events = new CaddyEvent(CaddyEvent.LUCKSTONE_RANK_LIMIT);
            events.lastTime = lastTime;
            events.dataList = this.limdataList;
            dispatchEvent(events);
            return;
         }
         lastTime = pkg.readUTF();
         var isOpen:Boolean = pkg.readBoolean();
         var count:int = pkg.readInt();
         for(var i:int = 0; i < count; i++)
         {
            obj = new Object();
            obj["Rank"] = pkg.readInt();
            obj["UserID"] = pkg.readInt();
            obj["LuckStone"] = pkg.readInt();
            obj["TemplateID"] = pkg.readInt();
            obj["Nickname"] = pkg.readUTF();
            obj["count"] = this._numList[i];
            this.limdataList.push(obj);
         }
         events = new CaddyEvent(CaddyEvent.LUCKSTONE_RANK_LIMIT);
         events.lastTime = lastTime;
         events.dataList = this.limdataList;
         dispatchEvent(events);
      }
      
      private function _showBox(evt:CrazyTankSocketEvent) : void
      {
         switch(this._boxType)
         {
            case ROULETTEBOX:
               this._showRoultteView(evt);
               break;
            case CADDY:
         }
      }
      
      private function _showRoultteView(evt:CrazyTankSocketEvent) : void
      {
         var i:int;
         var info:BoxGoodsTempInfo = null;
         var pkg:PackageIn = evt.pkg;
         try
         {
            this.id = pkg.readInt();
         }
         catch(e:Error)
         {
         }
         for(i = 0; i < 18; i++)
         {
            try
            {
               info = new BoxGoodsTempInfo();
               info.TemplateId = pkg.readInt();
               info.IsBind = pkg.readBoolean();
               info.ItemCount = pkg.readByte();
               info.ItemValid = pkg.readByte();
               this._templateIDList.push(info);
            }
            catch(e:Error)
            {
            }
         }
         this._randomTemplateID();
         if(this.id == EquipType.SURPRISE_ROULETTE_BOX)
         {
            this.showSurpriseRouletteView();
         }
         else if(this.id == EquipType.ROULETTE_BOX)
         {
            this.showRouletteView();
         }
         this._boxType = NO_BOX;
      }
      
      public function showSurpriseRouletteView() : void
      {
         var view:SurpriseRouletteView = new SurpriseRouletteView(this._templateIDList);
         view.keyCount = this._sRouletteKeyCount;
         LayerManager.Instance.addToLayer(view,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      public function useRouletteBox(cell:BagCell) : void
      {
         this._rouletteBoxkeyCount = PlayerManager.Instance.Self.PropBag.getItemCountByTemplateId(EquipType.ROULETTE_KEY);
         this._bagType = cell.itemInfo.BagType;
         this._place = cell.itemInfo.Place;
         this._boxType = ROULETTEBOX;
         if(this._rouletteBoxkeyCount >= 1)
         {
            SocketManager.Instance.out.sendRouletteBox(this._bagType,this._place);
         }
         else
         {
            this._stateAfterBuyKey = OPEN_ROULETTEBOX;
            this.showBuyRouletteKey(1,EquipType.ROULETTE_KEY);
         }
      }
      
      public function useSurpriseRoulette(cell:BagCell) : void
      {
         this._sRouletteKeyCount = PlayerManager.Instance.Self.PropBag.getItemCountByTemplateId(EquipType.SURPRISE_ROULETTE_KEY);
         this._bagType = cell.itemInfo.BagType;
         this._place = cell.itemInfo.Place;
         this._boxType = ROULETTEBOX;
         if(this._sRouletteKeyCount >= 1)
         {
            SocketManager.Instance.out.sendRouletteBox(this._bagType,this._place);
         }
         else
         {
            this._stateAfterBuyKey = OPEN_ROULETTEBOX;
            this.showBuyRouletteKey(1,EquipType.SURPRISE_ROULETTE_KEY);
         }
      }
      
      private function updateState() : void
      {
         switch(this._stateAfterBuyKey)
         {
            case SLEEP:
               break;
            case OPEN_ROULETTEBOX:
               if(this._rouletteBoxkeyCount >= 1)
               {
                  SocketManager.Instance.out.sendRouletteBox(this._bagType,this._place);
               }
               this._stateAfterBuyKey = SLEEP;
               break;
            case OPEN_CADDY:
         }
      }
      
      public function showRouletteView() : void
      {
         var panel:RouletteBoxPanel = ComponentFactory.Instance.creat("roulette.RoulettePanelAsset");
         panel.templateIDList = this._templateIDList;
         panel.keyCount = this._rouletteBoxkeyCount;
         panel.show();
         LayerManager.Instance.addToLayer(panel,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      public function showBuyRouletteKey(needKeyCount:int, itemId:int) : void
      {
         var _quick:QuickBuyFrame = ComponentFactory.Instance.creatComponentByStylename("ddtcore.QuickFrame");
         _quick.setTitleText(LanguageMgr.GetTranslation("tank.view.store.matte.goldQuickBuy"));
         _quick.itemID = itemId;
         _quick.stoneNumber = needKeyCount;
         LayerManager.Instance.addToLayer(_quick,LayerManager.GAME_TOP_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
         _quick.addEventListener(FrameEvent.RESPONSE,this._response);
      }
      
      private function _response(evt:FrameEvent) : void
      {
         (evt.currentTarget as QuickBuyFrame).removeEventListener(FrameEvent.RESPONSE,this._response);
         if(evt.responseCode == FrameEvent.CLOSE_CLICK || evt.responseCode == FrameEvent.ESC_CLICK)
         {
            this._closeFun();
         }
      }
      
      private function _closeFun() : void
      {
         this._stateAfterBuyKey = SLEEP;
      }
      
      private function _randomTemplateID() : void
      {
         var ran:int = 0;
         var itemID:BoxGoodsTempInfo = null;
         for(var i:int = 0; i < this._templateIDList.length; i++)
         {
            ran = Math.floor(Math.random() * this._templateIDList.length);
            itemID = this._templateIDList[i] as BoxGoodsTempInfo;
            this._templateIDList[i] = this._templateIDList[ran];
            this._templateIDList[ran] = itemID;
         }
      }
      
      private function _bagUpdate(e:BagEvent) : void
      {
         var number:int = 0;
         var evt:RouletteEvent = null;
         number = PlayerManager.Instance.Self.PropBag.getItemCountByTemplateId(EquipType.SURPRISE_ROULETTE_KEY);
         if(this._sRouletteKeyCount != number)
         {
            evt = new RouletteEvent(RouletteEvent.ROULETTE_KEYCOUNT_UPDATE);
            evt.keyCount = this._sRouletteKeyCount = number;
            dispatchEvent(evt);
            this.updateState();
            return;
         }
         number = PlayerManager.Instance.Self.PropBag.getItemCountByTemplateId(EquipType.ROULETTE_KEY);
         if(this._rouletteBoxkeyCount != number)
         {
            evt = new RouletteEvent(RouletteEvent.ROULETTE_KEYCOUNT_UPDATE);
            evt.keyCount = this._rouletteBoxkeyCount = number;
            dispatchEvent(evt);
            this.updateState();
         }
      }
      
      private function __getBadLuckHandler(e:CrazyTankSocketEvent) : void
      {
         var obj:Object = null;
         var events:CaddyEvent = null;
         this.dataList = new Vector.<Object>();
         var pkg:PackageIn = e.pkg;
         var lastTime:String = pkg.readUTF();
         var isOpen:Boolean = pkg.readBoolean();
         var count:int = pkg.readInt();
         for(var i:int = 0; i < count; i++)
         {
            obj = new Object();
            obj["Rank"] = pkg.readInt();
            obj["UserID"] = pkg.readInt();
            obj["Count"] = pkg.readInt();
            obj["TemplateID"] = pkg.readInt();
            obj["Nickname"] = pkg.readUTF();
            this.dataList.push(obj);
         }
         if(count == 0 || this.dataList[0].TemplateID == 0)
         {
            events = new CaddyEvent(CaddyEvent.UPDATE_BADLUCK);
            events.lastTime = lastTime;
            events.dataList = this.dataList;
            dispatchEvent(events);
         }
         else if(this.getStateAble(StateManager.currentStateType) && isOpen)
         {
            this.__showBadLuckEndFrame();
         }
         else
         {
            CacheSysManager.getInstance().cacheFunction(CacheConsts.ALERT_IN_HALL,new FunctionAction(this.__showBadLuckEndFrame));
         }
      }
      
      private function __showBadLuckEndFrame() : void
      {
         var _listView:CaddyAwardListFrame = ComponentFactory.Instance.creatComponentByStylename("caddyAwardListFrame");
         LayerManager.Instance.addToLayer(_listView,LayerManager.GAME_TOP_LAYER,true,LayerManager.NONE_BLOCKGOUND);
      }
      
      private function getStateAble(type:String) : Boolean
      {
         if(type == StateType.MAIN || type == StateType.AUCTION || type == StateType.DDTCHURCH_ROOM_LIST || type == StateType.ROOM_LIST || type == StateType.CONSORTIA || type == StateType.DUNGEON_LIST || type == StateType.HOT_SPRING_ROOM_LIST || type == StateType.FIGHT_LIB || type == StateType.ACADEMY_REGISTRATION || type == StateType.CIVIL || type == StateType.TOFFLIST)
         {
            return true;
         }
         return false;
      }
      
      public function useCaddy(cell:BagCell) : void
      {
         this._goodsInfo = cell.info;
         this._loadSWF();
      }
      
      private function _creatCaddy() : void
      {
         var panel:CaddyFrame = ComponentFactory.Instance.creatCustomObject("caddyII.CaddyFrame",[CaddyModel.CADDY_TYPE,this._goodsInfo]);
         panel.show();
         this._boxType = NO_BOX;
      }
      
      public function useBless(cell:BagCell = null) : void
      {
         if(!cell)
         {
            this._goodsInfo = ItemManager.Instance.getTemplateById(112047);
         }
         else
         {
            this._goodsInfo = cell.info;
         }
         try
         {
            this._creatCaddy();
         }
         catch(event:Error)
         {
            _loadSWF();
         }
      }
      
      public function useVipBox(cell:BagCell) : void
      {
         this._goodsInfo = cell.info;
         var panel:VipBoxFrame = ComponentFactory.Instance.creatCustomObject("caddyII.VipFrame",[CaddyModel.VIP_TYPE,this._goodsInfo]);
         panel.setCardType(cell.info.TemplateID,cell.place);
         panel.show();
         this._boxType = NO_BOX;
      }
      
      private function _creatBless() : void
      {
         var panel:CaddyFrame = ComponentFactory.Instance.creatCustomObject("caddyII.CaddyFrame",[CaddyModel.BOMB_KING_BLESS,this._goodsInfo]);
         panel.show();
      }
      
      public function useCelebrationBox() : void
      {
         var panel:CaddyFrame = ComponentFactory.Instance.creatCustomObject("caddyII.CaddyFrame",[CaddyModel.CELEBRATION_BOX]);
         panel.show();
      }
      
      public function useBead(templateID:int) : void
      {
         var panel:CaddyFrame = null;
         if(templateID == EquipType.MYSTICAL_CARDBOX)
         {
            panel = ComponentFactory.Instance.creatCustomObject("caddyII.CaddyFrame",[CaddyModel.MYSTICAL_CARDBOX]);
         }
         else if(templateID == EquipType.MY_CARDBOX)
         {
            panel = ComponentFactory.Instance.creatCustomObject("caddyIII.CardBoxFrame",[CaddyModel.MY_CARDBOX]);
         }
         else
         {
            panel = ComponentFactory.Instance.creatCustomObject("caddyII.CaddyFrame",[CaddyModel.BEAD_TYPE]);
         }
         panel.setBeadType(templateID);
         panel.show();
      }
      
      public function useOfferPack(cell:BagCell) : void
      {
         CaddyModel.instance.offerType = cell.info.TemplateID;
         var panel:CaddyFrame = ComponentFactory.Instance.creatCustomObject("caddyII.CaddyFrame",[CaddyModel.OFFER_PACKET]);
         panel.setOfferType(cell.info.TemplateID);
         panel.show();
      }
      
      public function useCard(cell:BagCell) : void
      {
         var panel:CardFrame = null;
         var panel2:CardSoulBoxFrame = null;
         if(cell.info.TemplateID == EquipType.MY_CARDBOX)
         {
            panel = ComponentFactory.Instance.creatCustomObject("caddy.CardFrame",[CaddyModel.MY_CARDBOX]);
         }
         else if(cell.info.TemplateID == EquipType.MYSTICAL_CARDBOX)
         {
            panel = ComponentFactory.Instance.creatCustomObject("caddy.CardFrame",[CaddyModel.MYSTICAL_CARDBOX]);
         }
         else
         {
            if(cell.info.TemplateID == EquipType.CARDSOUL_BOX)
            {
               panel2 = ComponentFactory.Instance.creatCustomObject("caddy.CardSoulBoxFrame",[CaddyModel.CARD_TYPE]);
               panel2.setCardType(cell.info.TemplateID,cell.place);
               panel2.show();
               return;
            }
            panel = ComponentFactory.Instance.creatCustomObject("caddy.CardFrame",[CaddyModel.CARD_TYPE]);
         }
         panel.setCardType(cell.info.TemplateID,cell.place);
         panel.show();
      }
      
      private function _loadSWF() : void
      {
         UIModuleSmallLoading.Instance.progress = 0;
         UIModuleSmallLoading.Instance.show();
         UIModuleSmallLoading.Instance.addEventListener(Event.CLOSE,this.__onSmallLoadingClose);
         UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__onUIComplete);
         UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__onUIProgress);
         UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.CADDY);
      }
      
      private function _loadUI() : void
      {
         UIModuleSmallLoading.Instance.progress = 0;
         UIModuleSmallLoading.Instance.show();
         UIModuleSmallLoading.Instance.addEventListener(Event.CLOSE,this.__onSmallLoadingClose);
         UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__onUICompleteOne);
         UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__onUIProgress);
         UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.CADDY);
      }
      
      private function __onUIComplete(e:UIModuleEvent) : void
      {
         if(e.module == UIModuleTypes.CADDY)
         {
            UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__onSmallLoadingClose);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__onUIComplete);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__onUIProgress);
            UIModuleSmallLoading.Instance.hide();
            this._creatCaddy();
         }
      }
      
      private function __onUICompleteOne(e:UIModuleEvent) : void
      {
         if(e.module == UIModuleTypes.CADDY)
         {
            UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__onSmallLoadingClose);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__onUIComplete);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__onUIProgress);
            UIModuleSmallLoading.Instance.hide();
            this._creatBless();
         }
      }
      
      private function __onSmallLoadingClose(e:Event) : void
      {
         UIModuleSmallLoading.Instance.hide();
         UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__onSmallLoadingClose);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__onUIComplete);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__onUIProgress);
      }
      
      private function __onUIProgress(e:UIModuleEvent) : void
      {
         if(e.module == UIModuleTypes.CADDY)
         {
            UIModuleSmallLoading.Instance.progress = e.loader.progress * 100;
         }
      }
   }
}

