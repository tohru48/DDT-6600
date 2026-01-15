package treasure.controller
{
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.UIModuleLoader;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.UIModuleTypes;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.ItemManager;
   import ddt.manager.PathManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.StateManager;
   import ddt.states.StateType;
   import ddt.view.UIModuleSmallLoading;
   import farm.FarmModelController;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import treasure.data.TreasureTempInfo;
   import treasure.events.TreasureEvents;
   import treasure.model.TreasureModel;
   
   public class TreasureManager extends EventDispatcher
   {
      
      private static var _instance:TreasureManager = null;
      
      private var _UILoadComplete:Boolean = false;
      
      public function TreasureManager()
      {
         super();
         this.initEvent();
      }
      
      public static function get instance() : TreasureManager
      {
         if(_instance == null)
         {
            _instance = new TreasureManager();
         }
         return _instance;
      }
      
      private function initEvent() : void
      {
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.ENTER_TREASURE,this.__onEnterTreasure);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.BEREPAIR_FRIEND_FARM_SEND,this.__farmBeRepairHandler);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.START_GAME_TREASURE,this.__stratGameHandler);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.END_TREASURE,this.__endGameHandler);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.DIG,this.__digHandler);
      }
      
      private function __digHandler(e:CrazyTankSocketEvent) : void
      {
         var id:int = e.pkg.readInt();
         var pos:int = e.pkg.readInt();
         var count:int = e.pkg.readInt();
         PlayerManager.Instance.Self.treasure = e.pkg.readInt();
         var num:int = e.pkg.readInt();
         PlayerManager.Instance.Self.treasureAdd = num > 0 ? num : 0;
         for(var i:int = 0; i < TreasureModel.instance.itemList.length; i++)
         {
            if(TreasureModel.instance.itemList[i].TemplateID == id && TreasureModel.instance.itemList[i].Count == count)
            {
               TreasureModel.instance.itemList[i].pos = pos;
               this.sortList();
               dispatchEvent(new TreasureEvents(TreasureEvents.DIG,{"pos":pos}));
               return;
            }
         }
      }
      
      private function __endGameHandler(e:CrazyTankSocketEvent) : void
      {
         TreasureModel.instance.isEndTreasure = e.pkg.readBoolean();
         dispatchEvent(new TreasureEvents(TreasureEvents.END_GAME));
      }
      
      private function __stratGameHandler(e:CrazyTankSocketEvent) : void
      {
         TreasureModel.instance.isBeginTreasure = e.pkg.readBoolean();
         dispatchEvent(new TreasureEvents(TreasureEvents.BEGIN_GAME));
      }
      
      private function __farmBeRepairHandler(e:CrazyTankSocketEvent) : void
      {
         TreasureModel.instance.friendHelpTimes = e.pkg.readInt();
         if(TreasureModel.instance.friendHelpTimes == PathManager.treasureHelpTimes)
         {
            PlayerManager.Instance.Self.treasureAdd = 1;
         }
         dispatchEvent(new TreasureEvents(TreasureEvents.BEREPAIR_FRIEND_FARM_SEND));
      }
      
      private function __onEnterTreasure(e:CrazyTankSocketEvent) : void
      {
         var num:int = 0;
         var i:int = 0;
         var ran:int = 0;
         var _info:ItemTemplateInfo = null;
         var __info:TreasureTempInfo = null;
         var _info1:ItemTemplateInfo = null;
         var __info1:TreasureTempInfo = null;
         TreasureModel.instance.logoinDays = e.pkg.readInt();
         PlayerManager.Instance.Self.treasure = e.pkg.readInt();
         var num1:int = e.pkg.readInt();
         PlayerManager.Instance.Self.treasureAdd = num1 > 0 ? num1 : 0;
         TreasureModel.instance.friendHelpTimes = e.pkg.readInt();
         TreasureModel.instance.isEndTreasure = e.pkg.readBoolean();
         TreasureModel.instance.isBeginTreasure = e.pkg.readBoolean();
         TreasureModel.instance.itemList = new Vector.<TreasureTempInfo>();
         num = e.pkg.readInt();
         for(i = 0; i < num; i++)
         {
            _info = new ItemTemplateInfo();
            _info.TemplateID = e.pkg.readInt();
            _info = ItemManager.Instance.getTemplateById(_info.TemplateID);
            __info = new TreasureTempInfo();
            ObjectUtils.copyProperties(__info,_info);
            __info.ValidDate = e.pkg.readInt();
            __info.Count = e.pkg.readInt();
            __info.pos = 0;
            __info.IsBinds = true;
            __info.BindType = 1;
            if(TreasureModel.instance.itemList.length == 0)
            {
               ran = 0;
            }
            else
            {
               ran = Math.floor((TreasureModel.instance.itemList.length + 1) * Math.random());
            }
            TreasureModel.instance.itemList.splice(ran,0,__info);
         }
         num = e.pkg.readInt();
         for(i = 0; i < num; i++)
         {
            _info1 = new ItemTemplateInfo();
            _info1.TemplateID = e.pkg.readInt();
            _info1 = ItemManager.Instance.getTemplateById(_info1.TemplateID);
            __info1 = new TreasureTempInfo();
            ObjectUtils.copyProperties(__info1,_info1);
            __info1.pos = e.pkg.readInt();
            __info1.ValidDate = e.pkg.readInt();
            __info1.Count = e.pkg.readInt();
            __info1.IsBinds = true;
            __info1.BindType = 1;
            TreasureModel.instance.itemList.push(__info1);
         }
         this.sortList();
         if(this._UILoadComplete)
         {
            this.creatView();
         }
         else
         {
            this.loadUIModule();
         }
      }
      
      private function sortList() : void
      {
         var m:int = 0;
         var temporary:TreasureTempInfo = null;
         var arr:Array = [];
         for(var i:int = 0; i < TreasureModel.instance.itemList.length; i++)
         {
            if(TreasureModel.instance.itemList[i].pos != 0)
            {
               arr.push({"pos":TreasureModel.instance.itemList[i].pos});
            }
         }
         for(var n:int = 0; n < TreasureModel.instance.itemList.length - 1; n++)
         {
            for(m = n + 1; m < TreasureModel.instance.itemList.length; m++)
            {
               if(TreasureModel.instance.itemList[n].pos > TreasureModel.instance.itemList[m].pos)
               {
                  temporary = TreasureModel.instance.itemList[n];
                  TreasureModel.instance.itemList[n] = TreasureModel.instance.itemList[m];
                  TreasureModel.instance.itemList[m] = temporary;
               }
            }
         }
         var item:Vector.<TreasureTempInfo> = TreasureModel.instance.itemList.splice(TreasureModel.instance.itemList.length - arr.length,arr.length);
         for(var j:int = 0; j < item.length; j++)
         {
            TreasureModel.instance.itemList.splice(item[j].pos - 1,0,item[j]);
         }
      }
      
      private function creatView() : void
      {
         if(StateManager.currentStateType != StateType.TREASURE)
         {
            StateManager.setState(StateType.TREASURE);
         }
         else
         {
            FarmModelController.instance.goFarm(PlayerManager.Instance.Self.ID,PlayerManager.Instance.Self.NickName);
         }
      }
      
      private function loadUIModule() : void
      {
         if(!this._UILoadComplete)
         {
            UIModuleSmallLoading.Instance.progress = 0;
            UIModuleSmallLoading.Instance.show();
            UIModuleSmallLoading.Instance.addEventListener(Event.CLOSE,this.__onClose);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__onUIModuleComplete);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__onProgress);
            UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.TREASURE);
         }
      }
      
      protected function __onClose(event:Event) : void
      {
         UIModuleSmallLoading.Instance.hide();
         UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__onClose);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__onUIModuleComplete);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__onProgress);
      }
      
      protected function __onUIModuleComplete(event:UIModuleEvent) : void
      {
         this._UILoadComplete = true;
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__onUIModuleComplete);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__onProgress);
         UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__onClose);
         UIModuleSmallLoading.Instance.hide();
         this.creatView();
      }
      
      protected function __onProgress(event:UIModuleEvent) : void
      {
         UIModuleSmallLoading.Instance.progress = event.loader.progress * 100;
      }
      
      public function show() : void
      {
         SocketManager.Instance.out.enterTreasure();
      }
   }
}

