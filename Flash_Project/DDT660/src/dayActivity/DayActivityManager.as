package dayActivity
{
   import battleGroud.BattleGroudManager;
   import campbattle.CampBattleManager;
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.LoadResourceManager;
   import com.pickgliss.loader.UIModuleLoader;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.utils.ObjectUtils;
   import consortion.ConsortionModelControl;
   import consortionBattle.ConsortiaBattleManager;
   import dayActivity.data.ActivityData;
   import dayActivity.data.DayActiveData;
   import dayActivity.data.DayRewaidData;
   import dayActivity.items.DayActivieListItem;
   import ddt.data.UIModuleTypes;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.PathManager;
   import ddt.manager.SocketManager;
   import ddt.manager.TimeManager;
   import ddt.view.UIModuleSmallLoading;
   import ddtActivityIcon.DdtActivityIconManager;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import flash.utils.Dictionary;
   import league.manager.LeagueManager;
   import littleGame.LittleGameManager;
   import wantstrong.WantStrongManager;
   import worldboss.WorldBossManager;
   
   public class DayActivityManager extends EventDispatcher
   {
      
      private static var _instance:DayActivityManager;
      
      public static const ACTIVITY_VALUE_CHANGE:String = "daily_activity_value_change";
      
      public static const ACTIVITY_GET_STATUS_CHANGE:String = "daily_activity_get_status_change";
      
      public static const DAY_ACTIVITY:int = 0;
      
      public static const DAY_ACTIVE:int = 1;
      
      public static const DAY_ACTIVITYADV:int = 2;
      
      public var overList:Vector.<ActivityData>;
      
      public var noOverList:Vector.<ActivityData>;
      
      public var acitivityList:Vector.<ActivityData>;
      
      private var _activityFrame:ActivityFrame;
      
      public var acitivityDataList:Vector.<ActivityData>;
      
      public var acitiveDataList:Vector.<DayActiveData>;
      
      public var reweadDataList:Vector.<DayRewaidData>;
      
      public var bossDataDic:Dictionary = new Dictionary();
      
      private var findBackDic:Dictionary = new Dictionary();
      
      public var speedActArr:Array = new Array();
      
      private var _activityValue:int;
      
      public var isOverList:Array;
      
      private var rezArray:Array;
      
      public var btnArr:Array;
      
      public var sessionArr:Array;
      
      private var ANYEBOJUE:String;
      
      public var ANYEBOJUE_DAYOFWEEK:String;
      
      private var YUANGUJULONG:String;
      
      public var YUANGUJULONG_DAYOFWEEK:String;
      
      private var LIANSAI:String;
      
      private var ZHANCHANG:String;
      
      private var GONGHUIBOSS:String;
      
      private var BOGUQUNYING:String;
      
      private var ZHENYINGZHAN:String;
      
      private var ZUQIUBOSS:String;
      
      public var ZUQIUBOSS_DAYOFWEEK:String;
      
      private var GONGHUIZHAN:String;
      
      public function DayActivityManager(target:IEventDispatcher = null)
      {
         super(target);
         this.overList = new Vector.<ActivityData>();
         this.noOverList = new Vector.<ActivityData>();
         this.acitivityList = new Vector.<ActivityData>();
      }
      
      public static function get Instance() : DayActivityManager
      {
         if(_instance == null)
         {
            _instance = new DayActivityManager();
         }
         return _instance;
      }
      
      public function get activityValue() : int
      {
         return this._activityValue;
      }
      
      public function set activityValue(value:int) : void
      {
         this._activityValue = value;
         dispatchEvent(new Event(ACTIVITY_VALUE_CHANGE));
      }
      
      public function setup() : void
      {
         this.initEvent();
      }
      
      private function initEvent() : void
      {
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.USEMONEYPOINT_COMPLETE,this.addSpeedResp);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.GETACTIVEPOINT_REWARD,this.changGoodsBtn);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.EVERYDAYACTIVEPOINT_DATA,this.initActivityList);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.EVERYDAYACTIVEPOINT_CHANGE,this.initSingleActivity);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.ADD_ACTIVITY_DATA_CHANGE,this.addActivityChange);
      }
      
      private function creatActiveLoader() : void
      {
         var loader:BaseLoader = LoadResourceManager.Instance.creatAndStartLoad(PathManager.solveRequestPath("EveryDayActivePointTemplateInfoList.xml"),BaseLoader.COMPRESS_TEXT_LOADER);
         loader.analyzer = new ActivityAnalyzer(this.everyDayActive);
      }
      
      private function creatActivePointLoader() : void
      {
         var loader:BaseLoader = LoadResourceManager.Instance.creatAndStartLoad(PathManager.solveRequestPath("EveryDayActiveProgressInfoList.xml"),BaseLoader.COMPRESS_TEXT_LOADER);
         loader.analyzer = new ActivePointAnalzer(this.everyDayActivePoint);
      }
      
      private function creatRewardLoader() : void
      {
         var loader:BaseLoader = LoadResourceManager.Instance.creatAndStartLoad(PathManager.solveRequestPath("EveryDayActiveRewardTemplateInfoList.xml"),BaseLoader.COMPRESS_TEXT_LOADER);
         loader.analyzer = new ActivityRewardAnalyzer(this.activityRewardComp);
      }
      
      public function activityRewardComp(data:ActivityRewardAnalyzer) : void
      {
         this.reweadDataList = data.itemList;
      }
      
      public function everyDayActivePoint(analy:ActivePointAnalzer) : void
      {
         this.acitiveDataList = analy.itemList;
         DdtActivityIconManager.Instance.timerList = analy.itemList;
         this.setActionTime();
      }
      
      private function setActionTime() : void
      {
         var len:int = int(this.acitiveDataList.length);
         for(var i:int = 0; i < len; i++)
         {
            switch(this.acitiveDataList[i].ID)
            {
               case 1:
               case 2:
                  this.YUANGUJULONG = this.acitiveDataList[i].ActiveTime;
                  this.YUANGUJULONG_DAYOFWEEK = this.acitiveDataList[i].DayOfWeek;
                  break;
               case 4:
                  this.LIANSAI = this.acitiveDataList[i].ActiveTime;
                  break;
               case 5:
                  this.ZHANCHANG = this.acitiveDataList[i].ActiveTime;
                  break;
               case 6:
                  this.GONGHUIBOSS = this.acitiveDataList[i].ActiveTime;
                  break;
               case 10:
                  this.BOGUQUNYING = this.acitiveDataList[i].ActiveTime;
                  break;
               case 18:
                  this.ZHENYINGZHAN = this.acitiveDataList[i].ActiveTime;
                  break;
               case 19:
                  this.ZUQIUBOSS = this.acitiveDataList[i].ActiveTime;
                  this.ZUQIUBOSS_DAYOFWEEK = this.acitiveDataList[i].DayOfWeek;
                  break;
               case 20:
                  this.GONGHUIZHAN = this.acitiveDataList[i].ActiveTime;
                  break;
            }
         }
      }
      
      public function everyDayActive(analy:ActivityAnalyzer) : void
      {
         this.acitivityDataList = analy.itemList;
         this.noOverList = this.copyArr(this.acitivityDataList);
      }
      
      public function changGoodsBtn(e:CrazyTankSocketEvent) : void
      {
         var id:int = e.pkg.readInt();
         var bool:Boolean = e.pkg.readBoolean();
         if(bool)
         {
            this.btnArr[id - 1][1] = 1;
            if(Boolean(this._activityFrame))
            {
               this._activityFrame.updataBtn(id);
            }
            dispatchEvent(new Event(ACTIVITY_GET_STATUS_CHANGE));
         }
      }
      
      public function get isHasActivityAward() : Boolean
      {
         if(!this.btnArr || this.btnArr.length == 0)
         {
            return false;
         }
         if(this.activityValue >= 30 && this.btnArr[0][1] == 0)
         {
            return true;
         }
         if(this.activityValue >= 60 && this.btnArr[1][1] == 0)
         {
            return true;
         }
         if(this.activityValue >= 80 && this.btnArr[2][1] == 0)
         {
            return true;
         }
         if(this.activityValue >= 100 && this.btnArr[3][1] == 0)
         {
            return true;
         }
         return false;
      }
      
      public function addActivityChange(e:CrazyTankSocketEvent) : void
      {
         var id:int = e.pkg.readInt();
         var count:int = e.pkg.readInt();
         this.updataNum(id,count);
      }
      
      public function send(i:int, id:int) : void
      {
         SocketManager.Instance.out.addSpeed(i,id);
      }
      
      private function updataNum(id:int, count:int) : void
      {
         var arr:Array = null;
         var i:int = 0;
         if(this.sessionArr == null)
         {
            this.sessionArr = [];
         }
         var len:int = int(this.sessionArr.length);
         if(len == 0)
         {
            arr = [];
            arr[0] = id;
            arr[1] = count;
            this.sessionArr.push(arr);
         }
         else
         {
            for(i = 0; i < len; i++)
            {
               if(this.sessionArr[i][0] == id)
               {
                  this.sessionArr[i][1] = count;
                  break;
               }
               if(i >= len - 1)
               {
                  arr = [];
                  arr[0] = id;
                  arr[1] = count;
                  this.sessionArr.push(arr);
               }
            }
         }
      }
      
      public function addSpeedResp(e:CrazyTankSocketEvent) : void
      {
         var id:int = e.pkg.readInt();
         var bool:Boolean = e.pkg.readBoolean();
         this.activityValue = e.pkg.readInt();
         var actId:int = e.pkg.readInt();
         if(this.speedActArr.indexOf(actId) == -1)
         {
            this.speedActArr.push(actId);
         }
         this.addOverList(bool,id);
         if(Boolean(this._activityFrame) && Boolean(this._activityFrame.parent))
         {
            this._activityFrame.setLeftView(this.overList,this.noOverList);
            this._activityFrame.setBar(this.activityValue);
         }
      }
      
      private function addOverList(bool:Boolean, id:int, count:int = 0) : void
      {
         var len:int = int(this.acitivityDataList.length);
         for(var j:int = 0; j < len; j++)
         {
            if(this.acitivityDataList[j].ID == id)
            {
               if(bool)
               {
                  this.acitivityDataList[j].OverCount = this.acitivityDataList[j].Count;
                  this.overList.push(this.acitivityDataList[j]);
                  this.deleNoOverListItem(id);
               }
               else
               {
                  this.acitivityDataList[j].OverCount = count;
                  if(this.acitivityDataList[j].Count <= count)
                  {
                     if(!this.checkOverList(this.acitivityDataList[j].ID))
                     {
                        this.overList.push(this.acitivityDataList[j]);
                     }
                     this.deleNoOverListItem(id);
                  }
               }
               break;
            }
         }
      }
      
      private function checkOverList(id:int) : Boolean
      {
         var len:int = int(this.overList.length);
         for(var i:int = 0; i < len; i++)
         {
            if(this.overList[i].ID == id)
            {
               return true;
            }
         }
         return false;
      }
      
      public function initSingleActivity(e:CrazyTankSocketEvent) : void
      {
         var id1:int = e.pkg.readInt();
         var count1:int = e.pkg.readInt();
         if(id1 == 4 || id1 == 5 || id1 == 6 || id1 == 18 || id1 == 19)
         {
            this.bossDataDic[id1] = count1;
         }
         this.activityValue = e.pkg.readInt();
         this.addOverList(false,id1,count1);
         if(Boolean(this._activityFrame) && Boolean(this._activityFrame.parent))
         {
            this._activityFrame.setLeftView(this.overList,this.noOverList);
            this._activityFrame.setBar(this.activityValue);
         }
      }
      
      private function deleNoOverListItem(id:int) : void
      {
         var len:int = int(this.noOverList.length);
         for(var i:int = 0; i < len; i++)
         {
            if(id == this.noOverList[i].ID)
            {
               this.noOverList.splice(i,1);
               break;
            }
         }
      }
      
      public function initActivityList(e:CrazyTankSocketEvent) : void
      {
         var arr1:Array = null;
         var tmpIndex:int = 0;
         var tmpValue:int = 0;
         var tmpLen:int = 0;
         var n:int = 0;
         var arr3:Array = null;
         var conut:int = 0;
         var t_i:int = 0;
         var id:int = 0;
         var overCount:int = 0;
         var bType:int = 0;
         var arr:Array = null;
         var count1:int = e.pkg.readInt();
         if(count1 == 0)
         {
            this.overList.splice(0,this.overList.length);
            this.noOverList.splice(0,this.noOverList.length);
            this.noOverList = this.copyArr(this.acitivityDataList);
         }
         this.rezArray = [];
         for(var i:int = 0; i < count1; i++)
         {
            arr1 = new Array();
            arr1[0] = e.pkg.readInt();
            arr1[1] = e.pkg.readInt();
            if(arr1[0] == 4 || arr1[0] == 5 || arr1[0] == 6 || arr1[0] == 18 || arr1[0] == 19)
            {
               this.bossDataDic[arr1[0]] = arr1[1];
            }
            this.rezArray.push(arr1);
         }
         this.btnArr = [[1,0],[2,0],[3,0],[4,0]];
         var count2:int = e.pkg.readInt();
         for(var j:int = 0; j < count2; j++)
         {
            tmpIndex = e.pkg.readInt();
            tmpValue = e.pkg.readInt();
            tmpLen = int(this.btnArr.length);
            for(n = 0; n < tmpLen; n++)
            {
               if(this.btnArr[n][0] == tmpIndex)
               {
                  this.btnArr[n][1] = tmpValue;
                  break;
               }
            }
         }
         this.sessionArr = [];
         var count3:int = e.pkg.readInt();
         for(var k:int = 0; k < count3; k++)
         {
            arr3 = new Array();
            arr3[0] = e.pkg.readInt();
            arr3[1] = e.pkg.readInt();
            this.sessionArr.push(arr3);
         }
         this.activityValue = e.pkg.readInt();
         this.initSession();
         var len:int = int(this.rezArray.length);
         for(var t_j:int = 0; t_j < len; t_j++)
         {
            conut = int(this.noOverList.length);
            for(t_i = 0; t_i < conut; t_i++)
            {
               id = int(this.rezArray[t_j][0]);
               overCount = int(this.rezArray[t_j][1]);
               if(this.noOverList[t_i].ID == id)
               {
                  this.noOverList[t_i].OverCount = overCount;
                  if(this.noOverList[t_i].OverCount >= this.noOverList[t_i].Count)
                  {
                     this.overList.push(this.noOverList[t_i]);
                     this.deleNoOverListItem(id);
                  }
                  break;
               }
            }
         }
         var count4:int = e.pkg.readInt();
         for(var t_k:int = 0; t_k < count4; t_k++)
         {
            bType = e.pkg.readInt();
            arr = new Array();
            arr[0] = e.pkg.readBoolean();
            arr[1] = e.pkg.readBoolean();
            this.findBackDic[bType] = arr;
         }
         var wantstrongBoolStr:String = e.pkg.readUTF();
         this.speedActArr = wantstrongBoolStr.split("|");
         WantStrongManager.Instance.findBackDic = this.findBackDic;
      }
      
      private function copyArr(arr:Vector.<ActivityData>) : Vector.<ActivityData>
      {
         var data:ActivityData = null;
         var vet:Vector.<ActivityData> = new Vector.<ActivityData>();
         if(!arr)
         {
            return vet;
         }
         for(var i:int = 0; i < arr.length; i++)
         {
            arr[i].resetOverCount();
            data = arr[i];
            vet.push(data);
         }
         return vet;
      }
      
      public function initActivityFrame() : void
      {
         if(!this._activityFrame)
         {
            UIModuleSmallLoading.Instance.progress = 0;
            UIModuleSmallLoading.Instance.show();
            UIModuleSmallLoading.Instance.addEventListener(Event.CLOSE,this.onSmallLoadingClose);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.createActivityFrame);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.onUIProgress);
            UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.DAY_ACTIVITY);
         }
         else
         {
            this._activityFrame = ComponentFactory.Instance.creatComponentByStylename("dayActivity.ActivityFrame");
            LayerManager.Instance.addToLayer(this._activityFrame,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
         }
      }
      
      public function initActivityStata(_list:Vector.<DayActivieListItem>) : void
      {
         var timeBogu:Array = null;
         if(WorldBossManager.Instance.isOpen)
         {
            if(WorldBossManager.Instance.currentPVE_ID == 30002)
            {
               this.updateActivityData(this.ANYEBOJUE,_list,false);
            }
            else if(WorldBossManager.Instance.currentPVE_ID == 1243)
            {
               this.updateActivityData(this.YUANGUJULONG,_list,false);
            }
            else
            {
               this.updateActivityData(this.ZUQIUBOSS,_list,false);
            }
         }
         else if(WorldBossManager.Instance.currentPVE_ID == 30002)
         {
            this.updateActivityData(this.ANYEBOJUE,_list,true);
         }
         else if(WorldBossManager.Instance.currentPVE_ID == 1243)
         {
            this.updateActivityData(this.YUANGUJULONG,_list,true);
         }
         else
         {
            this.updateActivityData(this.ZUQIUBOSS,_list,true);
         }
         if(BattleGroudManager.Instance.isShow)
         {
            this.updateActivityData(this.ZHANCHANG,_list,false);
         }
         else
         {
            this.updateActivityData(this.ZHANCHANG,_list,true);
         }
         if(LeagueManager.instance.isOpen)
         {
            this.updateActivityData(this.LIANSAI,_list,false);
         }
         else
         {
            this.updateActivityData(this.LIANSAI,_list,true);
         }
         if(ConsortionModelControl.Instance.isBossOpen)
         {
            this.updateActivityData(this.GONGHUIBOSS,_list,false);
         }
         else
         {
            this.updateActivityData(this.GONGHUIBOSS,_list,true);
         }
         if(LittleGameManager.Instance.hasActive())
         {
            timeBogu = this.encounterTime(this.BOGUQUNYING);
            if(Number(timeBogu[0]) >= Number(timeBogu[1]) && Number(timeBogu[0]) <= Number(timeBogu[2]))
            {
               this.updateActivityData(this.BOGUQUNYING,_list,false);
            }
            else
            {
               this.updateActivityData(this.BOGUQUNYING,_list,true);
            }
         }
         else
         {
            this.updateActivityData(this.BOGUQUNYING,_list,true);
         }
         if(CampBattleManager.instance.model.isOpen)
         {
            this.updateActivityData(this.ZHENYINGZHAN,_list,false);
         }
         else
         {
            this.updateActivityData(this.ZHENYINGZHAN,_list,true);
         }
         if(ConsortiaBattleManager.instance.isOpen)
         {
            this.updateActivityData(this.GONGHUIZHAN,_list,false);
         }
         else
         {
            this.updateActivityData(this.GONGHUIZHAN,_list,true);
         }
      }
      
      private function updateActivityData(str:String, _list:Vector.<DayActivieListItem>, bool:Boolean) : void
      {
         var len:int = int(_list.length);
         for(var i:int = 0; i < len; i++)
         {
            if(str == _list[i].data.ActiveTime)
            {
               _list[i].initTxt(bool);
               return;
            }
         }
      }
      
      private function encounterTime(_timeStr:String) : Array
      {
         var temp:String = null;
         var time6Arr2:Array = null;
         var timeTemp:Number = NaN;
         var currentDate:Date = TimeManager.Instance.Now();
         var currentTimeStr:Number = currentDate.hours * 60 * 60 + currentDate.minutes * 60;
         var timeArr:Array = [];
         timeArr.push(currentTimeStr);
         var time6Arr:Array = _timeStr.split("-");
         for each(temp in time6Arr)
         {
            time6Arr2 = temp.split(":");
            timeTemp = Number(time6Arr2[0]) * 60 * 60 + Number(time6Arr2[1]) * 60;
            timeArr.push(timeTemp);
         }
         return timeArr;
      }
      
      protected function onUIProgress(event:UIModuleEvent) : void
      {
         if(event.module == UIModuleTypes.DAY_ACTIVITY)
         {
            UIModuleSmallLoading.Instance.progress = event.loader.progress * 100;
         }
      }
      
      protected function createActivityFrame(event:UIModuleEvent) : void
      {
         if(event.module != UIModuleTypes.DAY_ACTIVITY)
         {
            return;
         }
         UIModuleSmallLoading.Instance.hide();
         UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.onSmallLoadingClose);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.createActivityFrame);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.onUIProgress);
         this._activityFrame = ComponentFactory.Instance.creatComponentByStylename("dayActivity.ActivityFrame");
         LayerManager.Instance.addToLayer(this._activityFrame,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      protected function onSmallLoadingClose(event:Event) : void
      {
         UIModuleSmallLoading.Instance.hide();
         UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.onSmallLoadingClose);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.createActivityFrame);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.onUIProgress);
      }
      
      public function dispose() : void
      {
         this._activityFrame.dispose();
         ObjectUtils.disposeObject(this._activityFrame);
         this._activityFrame = null;
      }
      
      private function initSession() : void
      {
         var j:int = 0;
         for(var i:int = 0; i < this.sessionArr.length; i++)
         {
            for(j = 0; j < this.acitiveDataList.length; j++)
            {
               if(Boolean(this.sessionArr[i]))
               {
                  if(this.sessionArr[i][0] == this.acitiveDataList[j].ActivityTypeID)
                  {
                     this.acitiveDataList[j].TotalCount = this.sessionArr[i][1];
                     break;
                  }
               }
            }
         }
      }
   }
}

