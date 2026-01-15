package totem
{
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.UIModuleLoader;
   import ddt.data.Experience;
   import ddt.data.UIModuleTypes;
   import ddt.manager.PlayerManager;
   import ddt.view.UIModuleSmallLoading;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import road7th.data.DictionaryData;
   import totem.data.TotemAddInfo;
   import totem.data.TotemDataAnalyz;
   import totem.data.TotemDataVo;
   
   public class TotemManager extends EventDispatcher
   {
      
      private static var _instance:TotemManager;
      
      public var isBindInNoPrompt:Boolean;
      
      public var isDonotPromptActPro:Boolean;
      
      public var isSelectedActPro:Boolean;
      
      private var _dataList:Object;
      
      private var _dataList2:Object;
      
      private var _func:Function;
      
      private var _funcParams:Array;
      
      public function TotemManager(target:IEventDispatcher = null)
      {
         super(target);
      }
      
      public static function get instance() : TotemManager
      {
         if(_instance == null)
         {
            _instance = new TotemManager();
         }
         return _instance;
      }
      
      public function loadTotemModule(complete:Function = null, completeParams:Array = null) : void
      {
         this._func = complete;
         this._funcParams = completeParams;
         UIModuleSmallLoading.Instance.progress = 0;
         UIModuleSmallLoading.Instance.show();
         UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.loadCompleteHandler);
         UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.onUimoduleLoadProgress);
         UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.TOTEM);
      }
      
      private function onUimoduleLoadProgress(event:UIModuleEvent) : void
      {
         if(event.module == UIModuleTypes.TOTEM)
         {
            UIModuleSmallLoading.Instance.progress = event.loader.progress * 100;
         }
      }
      
      private function loadCompleteHandler(event:UIModuleEvent) : void
      {
         if(event.module == UIModuleTypes.TOTEM)
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
      
      public function setup(analyzer:TotemDataAnalyz) : void
      {
         this._dataList = analyzer.dataList;
         this._dataList2 = analyzer.dataList2;
      }
      
      public function getCurInfoByLevel(totemLevel:int) : TotemDataVo
      {
         return this._dataList2[totemLevel];
      }
      
      public function getCurInfoById(id:int) : TotemDataVo
      {
         if(id == 0)
         {
            return new TotemDataVo();
         }
         return this._dataList[id];
      }
      
      public function getNextInfoByLevel(totemLevel:int) : TotemDataVo
      {
         return this._dataList2[totemLevel + 1];
      }
      
      public function getNextInfoById(id:int) : TotemDataVo
      {
         var level:int = 0;
         if(id == 0)
         {
            level = 0;
         }
         else
         {
            level = int(this._dataList[id].Point);
         }
         return this._dataList2[level + 1];
      }
      
      public function getAddInfo(totemLevel:int, startTotemLevel:int = 1) : TotemAddInfo
      {
         var tmpVo:TotemDataVo = null;
         var totemAddInfo:TotemAddInfo = new TotemAddInfo();
         for each(tmpVo in this._dataList)
         {
            if(tmpVo.Point <= totemLevel && tmpVo.Point >= startTotemLevel)
            {
               totemAddInfo.Agility += tmpVo.AddAgility;
               totemAddInfo.Attack += tmpVo.AddAttack;
               totemAddInfo.Blood += tmpVo.AddBlood;
               totemAddInfo.Damage += tmpVo.AddDamage;
               totemAddInfo.Defence += tmpVo.AddDefence;
               totemAddInfo.Guard += tmpVo.AddGuard;
               totemAddInfo.Luck += tmpVo.AddLuck;
            }
         }
         return totemAddInfo;
      }
      
      public function getTotemPointLevel(id:int) : int
      {
         if(id == 0)
         {
            return 0;
         }
         return this._dataList[id].Point;
      }
      
      public function get usableGP() : int
      {
         return PlayerManager.Instance.Self.GP - Experience.expericence[PlayerManager.Instance.Self.Grade - 1];
      }
      
      public function getCurrentLv(totemLevel:int) : int
      {
         return int(totemLevel / 7);
      }
      
      public function updatePropertyAddtion(totemId:int, dic:DictionaryData) : void
      {
         if(!dic["Attack"])
         {
            return;
         }
         var totemAddInfo:TotemAddInfo = this.getAddInfo(this.getCurInfoById(totemId).Point);
         dic["Attack"]["Totem"] = totemAddInfo.Attack;
         dic["Defence"]["Totem"] = totemAddInfo.Defence;
         dic["Agility"]["Totem"] = totemAddInfo.Agility;
         dic["Luck"]["Totem"] = totemAddInfo.Luck;
         dic["HP"]["Totem"] = totemAddInfo.Blood;
         dic["Damage"]["Totem"] = totemAddInfo.Damage;
         dic["Armor"]["Totem"] = totemAddInfo.Guard;
      }
      
      public function getSamePageLocationList(page:int, location:int) : Array
      {
         var tmp:TotemDataVo = null;
         var dataArray:Array = [];
         for each(tmp in this._dataList)
         {
            if(tmp.Page == page && tmp.Location == location)
            {
               dataArray.push(tmp);
            }
         }
         dataArray.sortOn("Layers",Array.NUMERIC);
         return dataArray;
      }
   }
}

