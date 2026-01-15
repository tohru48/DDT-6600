package ddt.manager
{
   import bagAndInfo.BagAndInfoManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.UIModuleLoader;
   import ddt.data.UIModuleTypes;
   import ddt.data.analyze.EffortItemTemplateInfoAnalyzer;
   import ddt.data.effort.EffortCompleteStateInfo;
   import ddt.data.effort.EffortInfo;
   import ddt.data.effort.EffortProgressInfo;
   import ddt.data.effort.EffortQualificationInfo;
   import ddt.data.effort.EffortRewardInfo;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.events.EffortEvent;
   import ddt.view.UIModuleSmallLoading;
   import effortView.EffortMainFrame;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import newTitle.NewTitleManager;
   import newTitle.data.NewTitleModel;
   import road7th.data.DictionaryData;
   import road7th.utils.DateUtils;
   
   public class EffortManager extends EventDispatcher
   {
      
      private static var _instance:EffortManager;
      
      private var allEfforts:DictionaryData;
      
      private var integrationEfforts:Array;
      
      private var roleEfforts:Array;
      
      private var taskEfforts:Array;
      
      private var duplicateEfforts:Array;
      
      private var combatEfforts:Array;
      
      private var currentEfforts:Array;
      
      private var newlyCompleteEffort:Array;
      
      private var preEfforts:DictionaryData;
      
      private var preTopEfforts:DictionaryData;
      
      private var nextEfforts:DictionaryData;
      
      private var completeEfforts:DictionaryData;
      
      private var completeTopEfforts:DictionaryData;
      
      private var inCompleteEfforts:DictionaryData;
      
      private var progressEfforts:DictionaryData;
      
      private var honorEfforts:Array;
      
      private var completeHonorEfforts:Array;
      
      private var inCompleteHonorEfforts:Array;
      
      private var honorArray:Array;
      
      private var tempPreEfforts:DictionaryData;
      
      private var tempCompleteEfforts:DictionaryData;
      
      private var tempInCompleteEfforts:DictionaryData;
      
      private var tempInCompleteTopEfforts:DictionaryData;
      
      private var tempIntegrationEfforts:Array;
      
      private var tempRoleEfforts:Array;
      
      private var tempTaskEfforts:Array;
      
      private var tempDuplicateEfforts:Array;
      
      private var tempCombatEfforts:Array;
      
      private var tempNewlyCompleteEffort:Array;
      
      private var tempCompleteID:Array;
      
      private var tempAchievementPoint:int;
      
      private var tempPreTopEfforts:DictionaryData;
      
      private var tempCompleteNextEfforts:DictionaryData;
      
      private var tempHonorEfforts:Array;
      
      private var tempCompleteHonorEfforts:Array;
      
      private var tempInCompleteHonorEfforts:Array;
      
      private var _isSelf:Boolean = true;
      
      private var currentType:int;
      
      private var count:int;
      
      private var _view:EffortMainFrame;
      
      public function EffortManager()
      {
         super();
      }
      
      public static function get Instance() : EffortManager
      {
         if(_instance == null)
         {
            _instance = new EffortManager();
         }
         return _instance;
      }
      
      public function setup(analyzer:EffortItemTemplateInfoAnalyzer) : void
      {
         this.allEfforts = analyzer.list;
         this.initDictionaryData();
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.ACHIEVEMENT_UPDATE,this.__updateAchievement);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.ACHIEVEMENT_FINISH,this.__AchievementFinish);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.ACHIEVEMENT_INIT,this.__initializeAchievement);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.ACHIEVEMENTDATA_INIT,this.__initializeAchievementData);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.LOOKUP_EFFORT,this.__lookUpEffort);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.USER_RANK,this.__userRank);
      }
      
      private function initDictionaryData() : void
      {
         this.preEfforts = new DictionaryData();
         this.preTopEfforts = new DictionaryData();
         this.nextEfforts = new DictionaryData();
         this.progressEfforts = new DictionaryData();
         this.completeEfforts = new DictionaryData();
         this.completeTopEfforts = new DictionaryData();
         this.inCompleteEfforts = new DictionaryData();
      }
      
      public function getProgressEfforts() : DictionaryData
      {
         return this.progressEfforts;
      }
      
      public function getEffortByID(id:int) : EffortInfo
      {
         if(!this.allEfforts)
         {
            return null;
         }
         return this.allEfforts[id];
      }
      
      public function getIntegrationEffort() : Array
      {
         return this.integrationEfforts;
      }
      
      public function getRoleEffort() : Array
      {
         return this.roleEfforts;
      }
      
      public function getTaskEffort() : Array
      {
         return this.taskEfforts;
      }
      
      public function getDuplicateEffort() : Array
      {
         return this.duplicateEfforts;
      }
      
      public function getCombatEffort() : Array
      {
         return this.combatEfforts;
      }
      
      public function getNewlyCompleteEffort() : Array
      {
         return this.newlyCompleteEffort;
      }
      
      public function getHonorArray() : Array
      {
         if(!this.honorArray)
         {
            return new Array();
         }
         return this.honorArray;
      }
      
      private function splitHonorEffort() : void
      {
         var info:EffortInfo = null;
         var i:int = 0;
         this.honorEfforts = [];
         this.completeHonorEfforts = [];
         this.inCompleteHonorEfforts = [];
         for each(info in this.allEfforts)
         {
            if(info.effortRewardArray)
            {
               for(i = 0; i < info.effortRewardArray.length; i++)
               {
                  if((info.effortRewardArray[i] as EffortRewardInfo).RewardType == 1)
                  {
                     this.honorEfforts.push(info);
                     if(Boolean(info.CompleteStateInfo))
                     {
                        this.completeHonorEfforts.push(info);
                     }
                     else
                     {
                        this.inCompleteHonorEfforts.push(info);
                     }
                  }
               }
            }
         }
      }
      
      public function getHonorEfforts() : Array
      {
         this.splitHonorEffort();
         return this.honorEfforts;
      }
      
      public function getCompleteHonorEfforts() : Array
      {
         this.splitHonorEffort();
         return this.completeHonorEfforts;
      }
      
      public function getInCompleteHonorEfforts() : Array
      {
         this.splitHonorEffort();
         return this.inCompleteHonorEfforts;
      }
      
      public function get completeList() : DictionaryData
      {
         return this.completeEfforts;
      }
      
      public function get fullList() : DictionaryData
      {
         return this.allEfforts;
      }
      
      public function get currentEffortList() : Array
      {
         return this.currentEfforts;
      }
      
      public function set currentEffortList(currentList:Array) : void
      {
         this.currentEfforts = [];
         this.currentEfforts = currentList;
         dispatchEvent(new EffortEvent(EffortEvent.LIST_CHANGED));
      }
      
      public function setEffortType(type:int) : void
      {
         this.currentType = type;
         switch(type)
         {
            case 0:
               this.splitEffort(this.preTopEfforts);
               break;
            case 1:
               this.splitEffort(this.completeTopEfforts);
               break;
            case 2:
               this.splitEffort(this.inCompleteEfforts);
         }
         dispatchEvent(new EffortEvent(EffortEvent.TYPE_CHANGED));
      }
      
      private function splitEffort(dic:DictionaryData) : void
      {
         var i:EffortInfo = null;
         if(!dic)
         {
            return;
         }
         this.integrationEfforts = [];
         this.roleEfforts = [];
         this.taskEfforts = [];
         this.duplicateEfforts = [];
         this.combatEfforts = [];
         for each(i in dic)
         {
            if(!i)
            {
               continue;
            }
            switch(i.PlaceID)
            {
               case 0:
                  this.integrationEfforts.push(i);
                  break;
               case 1:
                  this.roleEfforts.push(i);
                  break;
               case 2:
                  this.taskEfforts.push(i);
                  break;
               case 3:
                  this.duplicateEfforts.push(i);
                  break;
               case 4:
                  this.combatEfforts.push(i);
                  break;
            }
         }
      }
      
      private function __updateAchievement(evt:CrazyTankSocketEvent) : void
      {
         var info:EffortProgressInfo = null;
         var len:int = evt.pkg.readInt();
         for(var i:int = 0; i < len; i++)
         {
            info = new EffortProgressInfo();
            info.RecordID = evt.pkg.readInt();
            info.Total = evt.pkg.readInt();
            this.progressEfforts[info.RecordID] = info;
            this.updateProgress(info);
         }
      }
      
      private function __initializeAchievement(evt:CrazyTankSocketEvent) : void
      {
         var info:EffortProgressInfo = null;
         var len:int = evt.pkg.readInt();
         for(var i:int = 0; i < len; i++)
         {
            info = new EffortProgressInfo();
            info.RecordID = evt.pkg.readInt();
            info.Total = evt.pkg.readInt();
            this.progressEfforts.add(info.RecordID,info);
         }
         this.updateWholeProgress();
         this.splitHonorEffort();
      }
      
      private function __initializeAchievementData(evt:CrazyTankSocketEvent) : void
      {
         var info:EffortCompleteStateInfo = null;
         var fullYearUTC:int = 0;
         var monthUTC:int = 0;
         var dateUTC:int = 0;
         var date:Date = null;
         this.newlyCompleteEffort = [];
         var len:int = evt.pkg.readInt();
         this.count = len;
         for(var i:int = 0; i < len; i++)
         {
            info = new EffortCompleteStateInfo();
            info.ID = evt.pkg.readInt();
            fullYearUTC = evt.pkg.readInt();
            monthUTC = evt.pkg.readInt();
            dateUTC = evt.pkg.readInt();
            date = new Date(fullYearUTC,monthUTC - 1,dateUTC);
            info.CompletedDate = date;
            if(Boolean(this.allEfforts[info.ID]))
            {
               (this.allEfforts[info.ID] as EffortInfo).CompleteStateInfo = info;
               (this.allEfforts[info.ID] as EffortInfo).completedDate = info.CompletedDate;
               if(i < 4)
               {
                  this.newlyCompleteEffort.push(this.allEfforts[info.ID]);
               }
            }
         }
         this.splitPreEffort();
      }
      
      private function __userRank(event:CrazyTankSocketEvent) : void
      {
         var titleModel:NewTitleModel = null;
         var id:int = 0;
         var startDate:Date = null;
         var endDate:Date = null;
         var now:Date = null;
         var titleInfo:NewTitleModel = null;
         this.honorArray = [];
         var oldTitleArr:Array = [];
         var len:int = event.pkg.readInt();
         for(var i:int = 0; i < len; i++)
         {
            titleModel = new NewTitleModel();
            id = event.pkg.readInt();
            titleModel.id = id;
            titleModel.Name = event.pkg.readUTF();
            startDate = event.pkg.readDate();
            endDate = event.pkg.readDate();
            now = TimeManager.Instance.Now();
            titleModel.Valid = DateUtils.getHourDifference(now.time,endDate.time) / 24 + 1;
            if(id >= NewTitleManager.FIRST_TITLEID)
            {
               NewTitleManager.instance.titleInfo[id].Valid = titleModel.Valid;
               this.honorArray.push(NewTitleManager.instance.titleInfo[id]);
            }
            else
            {
               titleInfo = NewTitleManager.instance.getTitleByName(titleModel.Name);
               if(Boolean(titleInfo))
               {
                  titleModel.Desc = titleInfo.Desc;
                  oldTitleArr.push(titleModel);
               }
            }
         }
         this.honorArray.sortOn("id",Array.NUMERIC);
         for(var j:int = 0; j < oldTitleArr.length; j++)
         {
            this.honorArray.push(oldTitleArr[j]);
         }
         dispatchEvent(new EffortEvent(EffortEvent.FINISH));
      }
      
      private function splitPreEffort() : void
      {
         var info:EffortInfo = null;
         for each(info in this.allEfforts)
         {
            if(this.estimateEffortState(info))
            {
               this.preEfforts.add(info.ID,info);
            }
            if(this.estimateEffortState(info) && (this.isTopEffort(info) || !info.CompleteStateInfo))
            {
               this.preTopEfforts.add(info.ID,info);
            }
            else if(!this.estimateEffortState(info))
            {
               this.nextEfforts.add(info.ID,info);
            }
         }
         this.splitCompleteEffort();
         this.splitEffort(this.preEfforts);
      }
      
      private function inCompletedToPreTopEfforts() : void
      {
         var info:EffortInfo = null;
         var tempArray:Array = null;
         var tempInfo:EffortInfo = null;
         var i:int = 0;
         for each(info in this.completeEfforts)
         {
            tempArray = this.getFellNextEffort(info.ID);
            tempArray.sortOn("ID");
            for(i = 0; i < tempArray.length; i++)
            {
               tempInfo = tempArray[i] as EffortInfo;
               if(!tempInfo.CompleteStateInfo && !this.isTopEffort(tempInfo))
               {
                  this.preTopEfforts.add(tempInfo.ID,tempInfo);
                  return;
               }
            }
         }
      }
      
      private function estimateEffortState(info:EffortInfo) : Boolean
      {
         var strArray:Array = [];
         strArray = info.PreAchievementID.split(",");
         if(strArray.length == 2 && strArray[0] == "0")
         {
            return true;
         }
         for(var i:int = 0; i <= strArray.length; i++)
         {
            if(strArray[i] == "")
            {
               break;
            }
            if((this.allEfforts[int(strArray[i])] as EffortInfo).CompleteStateInfo == null)
            {
               return false;
            }
         }
         return true;
      }
      
      public function getTopEffort1(info:EffortInfo) : int
      {
         if(this.isTopEffort(info) || !info.CompleteStateInfo)
         {
            return info.ID;
         }
         var i:int = 1;
         while(!this.isTopEffort(this.getEffortByID(info.ID - i)))
         {
            i++;
         }
         return this.getEffortByID(info.ID - i).ID;
      }
      
      public function getTopEffort(info:EffortInfo) : int
      {
         if(this.isTopEffort(info) || !info.CompleteStateInfo)
         {
            return info.ID;
         }
         var lastID:int = this.getLastID(info);
         var info2:EffortInfo = this.getEffortByID(lastID);
         while(!this.isTopEffort(info2))
         {
            lastID = this.getLastID(info2);
            info2 = this.getEffortByID(lastID);
         }
         return lastID;
      }
      
      private function getLastID(info:EffortInfo) : int
      {
         var strArray:Array = [];
         strArray = info.PreAchievementID.split(",");
         var lastID:int = -1;
         for(var j:int = 0; j < strArray.length; j++)
         {
            if(strArray[j].toString().length > 0)
            {
               lastID = int(strArray[j]);
            }
         }
         return lastID;
      }
      
      public function getCompleteNextEffort1(id:int) : Array
      {
         var j:int = 0;
         var completeNextEffortArray:Array = [];
         var strArray:Array = [];
         if(Boolean(this.completeEfforts[id]))
         {
            completeNextEffortArray.push(this.completeEfforts[id]);
         }
         var i:int = 1;
         while(Boolean(this.completeEfforts[id + i]))
         {
            strArray = (this.completeEfforts[id + i] as EffortInfo).PreAchievementID.split(",");
            for(j = 0; j < strArray.length; j++)
            {
               if(this.isTopEffort(this.completeEfforts[id + i]))
               {
                  return completeNextEffortArray;
               }
               if(id + i - 1 == int(strArray[j]))
               {
                  completeNextEffortArray.push(this.completeEfforts[id + i]);
               }
            }
            i++;
         }
         return completeNextEffortArray;
      }
      
      public function getCompleteNextEffort(id:int) : Array
      {
         var info:EffortInfo = null;
         var j:int = 0;
         var completeNextEffortArray:Array = [];
         var strArray:Array = [];
         this.completeEfforts.list.sortOn("ID",Array.NUMERIC);
         if(Boolean(this.completeEfforts[id]))
         {
            completeNextEffortArray.push(this.completeEfforts[id]);
         }
         var lastID:int = id;
         for each(info in this.completeEfforts.list)
         {
            if(Boolean(info) && info.ID != id)
            {
               strArray = info.PreAchievementID.split(",");
               for(j = 0; j < strArray.length; j++)
               {
                  if(!this.isTopEffort(info))
                  {
                     if(lastID == int(strArray[j]))
                     {
                        completeNextEffortArray.push(info);
                        lastID = info.ID;
                     }
                  }
               }
            }
         }
         return completeNextEffortArray;
      }
      
      public function getFellNextEffort(id:int) : Array
      {
         var j:int = 0;
         var fellNextEffortArray:Array = [];
         var strArray:Array = [];
         if(Boolean(this.allEfforts[id]))
         {
            fellNextEffortArray.push(this.allEfforts[id]);
         }
         var i:int = 1;
         while(Boolean(this.allEfforts[id + i]))
         {
            strArray = (this.allEfforts[id + i] as EffortInfo).PreAchievementID.split(",");
            for(j = 0; j < strArray.length; j++)
            {
               if(this.isTopEffort(this.allEfforts[id + i]))
               {
                  return fellNextEffortArray;
               }
               if(id + i - 1 == int(strArray[j]))
               {
                  fellNextEffortArray.push(this.allEfforts[id + i]);
               }
            }
            i++;
         }
         return fellNextEffortArray;
      }
      
      private function splitCompleteEffort() : void
      {
         var info:EffortInfo = null;
         for each(info in this.preEfforts)
         {
            if(info.CompleteStateInfo != null && this.isTopEffort(info))
            {
               this.completeTopEfforts.add(info.ID,info);
            }
            if(info.CompleteStateInfo != null)
            {
               this.completeEfforts.add(info.ID,info);
            }
            else
            {
               this.inCompleteEfforts.add(info.ID,info);
            }
         }
      }
      
      private function __AchievementFinish(evt:CrazyTankSocketEvent) : void
      {
         var info:EffortCompleteStateInfo = new EffortCompleteStateInfo();
         info.ID = evt.pkg.readInt();
         var fullYearUTC:int = evt.pkg.readInt();
         var monthUTC:int = evt.pkg.readInt();
         var dateUTC:int = evt.pkg.readInt();
         var date:Date = new Date(fullYearUTC,monthUTC - 1,dateUTC);
         info.CompletedDate = date;
         EffortMovieClipManager.Instance.addQueue(this.allEfforts[info.ID] as EffortInfo);
         if(Boolean(this.inCompleteEfforts[info.ID]))
         {
            (this.inCompleteEfforts[info.ID] as EffortInfo).CompleteStateInfo = info;
            (this.inCompleteEfforts[info.ID] as EffortInfo).completedDate = info.CompletedDate;
         }
         if(Boolean(this.allEfforts[info.ID]))
         {
            (this.allEfforts[info.ID] as EffortInfo).CompleteStateInfo = info;
            (this.allEfforts[info.ID] as EffortInfo).completedDate = info.CompletedDate;
         }
         this.completeToInComplete(info.ID);
         if(Boolean(this.newlyCompleteEffort))
         {
            this.newlyCompleteEffort.unshift(this.completeEfforts[info.ID]);
         }
         dispatchEvent(new EffortEvent(EffortEvent.FINISH));
      }
      
      private function updateWholeProgress() : void
      {
         var effortInfo:EffortInfo = null;
         var tempArray:Array = null;
         var i:EffortInfo = null;
         var effortQualificationInfo:EffortQualificationInfo = null;
         var j:int = 0;
         for each(effortInfo in this.allEfforts)
         {
            for each(effortQualificationInfo in effortInfo.EffortQualificationList)
            {
               if(this.progressEfforts[effortQualificationInfo.CondictionType])
               {
               }
               effortQualificationInfo.para2_currentValue = (this.progressEfforts[effortQualificationInfo.CondictionType] as EffortProgressInfo).Total;
               effortInfo.addEffortQualification(effortQualificationInfo);
            }
            this.allEfforts[effortInfo.ID] = effortInfo;
         }
         tempArray = [];
         for each(i in this.allEfforts)
         {
            if(this.testEffortIsComplete(i))
            {
               tempArray.push(i);
            }
         }
         tempArray.sortOn("ID");
         if(this.count != tempArray.length)
         {
            for(j = 0; j < tempArray.length; j++)
            {
               SocketManager.Instance.out.sendAchievementFinish(tempArray[j].ID);
            }
         }
      }
      
      private function updateProgress(info:EffortProgressInfo) : void
      {
         var effortInfo:EffortInfo = null;
         var i:EffortInfo = null;
         var j:EffortInfo = null;
         var effortQualificationInfo:EffortQualificationInfo = null;
         var tempArray:Array = [];
         for each(effortInfo in this.allEfforts)
         {
            for each(effortQualificationInfo in effortInfo.EffortQualificationList)
            {
               if(effortQualificationInfo.CondictionType == info.RecordID)
               {
                  effortQualificationInfo.para2_currentValue = info.Total;
                  effortInfo.addEffortQualification(effortQualificationInfo);
               }
            }
         }
         for each(i in this.inCompleteEfforts)
         {
            if(this.testEffortIsComplete(i))
            {
               tempArray.push(i);
            }
         }
         for each(j in this.nextEfforts)
         {
            if(this.testEffortIsComplete(j))
            {
               tempArray.push(j);
            }
         }
         if(Boolean(tempArray) && Boolean(tempArray[0]))
         {
            tempArray.sortOn("ID");
         }
         for(var k:int = 0; k < tempArray.length; k++)
         {
            SocketManager.Instance.out.sendAchievementFinish(tempArray[k].ID);
         }
      }
      
      private function testEffortIsComplete(info:EffortInfo) : Boolean
      {
         var effortQualificationInfo:EffortQualificationInfo = null;
         for each(effortQualificationInfo in info.EffortQualificationList)
         {
            if(effortQualificationInfo.para2_currentValue < effortQualificationInfo.Condiction_Para2)
            {
               return false;
            }
         }
         return true;
      }
      
      public function splitTitle(str:String) : String
      {
         var strArray:Array = [];
         strArray = str.split("/");
         if(strArray.length > 1 && strArray[1] != "")
         {
            if(PlayerManager.Instance.Self.Sex)
            {
               return strArray[0];
            }
            return strArray[1];
         }
         return strArray[0];
      }
      
      public function testFunction(id:int) : void
      {
      }
      
      private function completeToInComplete(id:int) : void
      {
         if(Boolean(this.inCompleteEfforts[id]) && this.isTopEffort(this.inCompleteEfforts[id]))
         {
            this.completeTopEfforts.add(id,this.inCompleteEfforts[id]);
            this.preTopEfforts.add(id,this.inCompleteEfforts[id]);
         }
         if(Boolean(this.inCompleteEfforts[id]))
         {
            this.completeEfforts.add(id,this.inCompleteEfforts[id]);
         }
         var fullEffort:Array = this.getFellNextEffort(id);
         if(id == fullEffort[fullEffort.length - 1].ID && (this.allEfforts[id] as EffortInfo).IsOther)
         {
            this.preTopEfforts.remove(id);
         }
         this.inCompleteEfforts.remove(id);
         this.nextToPre();
      }
      
      private function isTopEffort(info:EffortInfo) : Boolean
      {
         return info.PreAchievementID == "0,";
      }
      
      private function nextToPre() : void
      {
         var info:EffortInfo = null;
         for each(info in this.nextEfforts)
         {
            if(this.estimateEffortState(info))
            {
               this.preEfforts.add(info.ID,info);
               this.nextEfforts.remove(info.ID);
               this.nexToPreTop(info);
               if(this.testEffortIsComplete(info) && this.isTopEffort(info))
               {
                  this.completeTopEfforts.add(info.ID,info);
               }
               if(this.testEffortIsComplete(info))
               {
                  this.completeEfforts.add(info.ID,info);
               }
               else
               {
                  this.inCompleteEfforts.add(info.ID,info);
               }
            }
         }
         this.setEffortType(this.currentType);
      }
      
      private function nexToPreTop(info:EffortInfo) : void
      {
         var strArray:Array = null;
         var i:int = 0;
         if(!info.CompleteStateInfo)
         {
            this.preTopEfforts.add(info.ID,info);
            if(info.PreAchievementID != "0,")
            {
               strArray = [];
               strArray = info.PreAchievementID.split(",");
               for(i = 0; i <= strArray.length; i++)
               {
                  if(strArray[i] == "")
                  {
                     break;
                  }
                  if(Boolean(this.preTopEfforts[int(strArray[i])]) && !this.isTopEffort(this.preTopEfforts[int(strArray[i])]))
                  {
                     this.preTopEfforts.remove(int(strArray[i]));
                  }
               }
            }
         }
      }
      
      public function lookUpEffort(id:int) : void
      {
         SocketManager.Instance.out.sendLookupEffort(id);
      }
      
      private function __lookUpEffort(evt:CrazyTankSocketEvent) : void
      {
         var info:EffortInfo = null;
         this.tempPreEfforts = new DictionaryData();
         this.tempPreTopEfforts = new DictionaryData();
         this.tempCompleteEfforts = new DictionaryData();
         this.tempInCompleteEfforts = new DictionaryData();
         this.tempCompleteNextEfforts = new DictionaryData();
         this.tempInCompleteTopEfforts = new DictionaryData();
         this.tempNewlyCompleteEffort = [];
         this.tempCompleteID = [];
         this.tempAchievementPoint = evt.pkg.readInt();
         var len:int = evt.pkg.readInt();
         for(var i:int = 0; i < len; i++)
         {
            if(len == 0)
            {
               break;
            }
            this.tempCompleteID[i] = evt.pkg.readInt();
            if(Boolean(this.allEfforts[this.tempCompleteID[i]]) && this.isTopEffort(this.allEfforts[this.tempCompleteID[i]]))
            {
               this.tempInCompleteTopEfforts.add(this.tempCompleteID[i],this.allEfforts[this.tempCompleteID[i]]);
            }
            if(Boolean(this.allEfforts[this.tempCompleteID[i]]))
            {
               this.tempCompleteEfforts.add(this.tempCompleteID[i],this.allEfforts[this.tempCompleteID[i]]);
            }
            if(i < 4)
            {
               this.tempNewlyCompleteEffort[i] = this.allEfforts[this.tempCompleteID[i]];
            }
         }
         for each(info in this.allEfforts)
         {
            if(this.estimateTempEffortState(info))
            {
               this.tempPreEfforts.add(info.ID,info);
               if(this.isTopEffort(info) || !this.tempCompleteEfforts[info.ID])
               {
                  this.tempPreTopEfforts.add(info.ID,info);
               }
               if(!this.tempCompleteEfforts[info.ID])
               {
                  this.tempInCompleteEfforts.add(info.ID,info);
               }
            }
         }
         this.setTempEffortType(0);
         this.isSelf = false;
         EffortManager.Instance.switchVisible();
      }
      
      private function estimateTempEffortState(info:EffortInfo) : Boolean
      {
         var strArray:Array = [];
         strArray = info.PreAchievementID.split(",");
         if(strArray.length == 2 && strArray[0] == "0")
         {
            return true;
         }
         for(var i:int = 0; i <= strArray.length; i++)
         {
            if(strArray[i] == "")
            {
               break;
            }
            if(this.tempCompleteEfforts[int(strArray[i])] == null)
            {
               return false;
            }
         }
         return true;
      }
      
      public function setTempEffortType(type:int) : void
      {
         switch(type)
         {
            case 0:
               this.splitTempEffort(this.tempPreTopEfforts);
               break;
            case 1:
               this.splitTempEffort(this.tempInCompleteTopEfforts);
               break;
            case 2:
               this.splitTempEffort(this.tempInCompleteEfforts);
         }
         dispatchEvent(new EffortEvent(EffortEvent.TYPE_CHANGED));
      }
      
      private function splitTempEffort(dic:DictionaryData) : void
      {
         var i:EffortInfo = null;
         if(!dic)
         {
            return;
         }
         this.tempIntegrationEfforts = [];
         this.tempRoleEfforts = [];
         this.tempTaskEfforts = [];
         this.tempDuplicateEfforts = [];
         this.tempCombatEfforts = [];
         for each(i in dic)
         {
            if(!i)
            {
               continue;
            }
            switch(i.PlaceID)
            {
               case 0:
                  this.tempIntegrationEfforts.push(i);
                  break;
               case 1:
                  this.tempRoleEfforts.push(i);
                  break;
               case 2:
                  this.tempTaskEfforts.push(i);
                  break;
               case 3:
                  this.tempDuplicateEfforts.push(i);
                  break;
               case 4:
                  this.tempCombatEfforts.push(i);
                  break;
            }
         }
      }
      
      public function getTempTopEffort(info:EffortInfo) : int
      {
         if(this.isTopEffort(info) || !this.tempEffortIsComplete(info.ID))
         {
            return info.ID;
         }
         var i:int = 1;
         while(!this.isTopEffort(this.getEffortByID(info.ID - i)))
         {
            i++;
         }
         return this.getEffortByID(info.ID - i).ID;
      }
      
      public function getTempCompleteNextEffort(id:int) : Array
      {
         var j:int = 0;
         var completeNextEffortArray:Array = [];
         var strArray:Array = [];
         if(this.tempEffortIsComplete(id))
         {
            completeNextEffortArray.push(this.tempCompleteEfforts[id]);
         }
         var i:int = 1;
         while(Boolean(this.tempCompleteEfforts[id + i]))
         {
            strArray = (this.tempCompleteEfforts[id + i] as EffortInfo).PreAchievementID.split(",");
            for(j = 0; j < strArray.length; j++)
            {
               if(this.isTopEffort(this.tempCompleteEfforts[id + i]))
               {
                  return completeNextEffortArray;
               }
               if(id + i - 1 == int(strArray[j]))
               {
                  completeNextEffortArray.push(this.tempCompleteEfforts[id + i]);
               }
            }
            i++;
         }
         return completeNextEffortArray;
      }
      
      private function splitTempHonorEffort() : void
      {
         var info:EffortInfo = null;
         var i:int = 0;
         this.tempHonorEfforts = [];
         this.tempCompleteHonorEfforts = [];
         this.tempInCompleteHonorEfforts = [];
         for each(info in this.allEfforts)
         {
            if(info.effortRewardArray)
            {
               for(i = 0; i < info.effortRewardArray.length; i++)
               {
                  if((info.effortRewardArray[i] as EffortRewardInfo).RewardType == 1)
                  {
                     this.tempHonorEfforts.push(info);
                     if(EffortManager.Instance.tempEffortIsComplete(info.ID))
                     {
                        this.tempCompleteHonorEfforts.push(info);
                     }
                     else
                     {
                        this.tempInCompleteHonorEfforts.push(info);
                     }
                  }
               }
            }
         }
      }
      
      public function getTempHonorEfforts() : Array
      {
         this.splitTempHonorEffort();
         return this.tempHonorEfforts;
      }
      
      public function getTempCompleteHonorEfforts() : Array
      {
         this.splitTempHonorEffort();
         return this.tempCompleteHonorEfforts;
      }
      
      public function getTempInCompleteHonorEfforts() : Array
      {
         this.splitTempHonorEffort();
         return this.tempInCompleteHonorEfforts;
      }
      
      public function tempEffortIsComplete(id:int) : Boolean
      {
         return this.tempCompleteEfforts[id];
      }
      
      public function getTempIntegrationEffort() : Array
      {
         return this.tempIntegrationEfforts;
      }
      
      public function getTempRoleEffort() : Array
      {
         return this.tempRoleEfforts;
      }
      
      public function getTempTaskEffort() : Array
      {
         return this.tempTaskEfforts;
      }
      
      public function getTempDuplicateEffort() : Array
      {
         return this.tempDuplicateEfforts;
      }
      
      public function getTempCombatEffort() : Array
      {
         return this.tempCombatEfforts;
      }
      
      public function getTempNewlyCompleteEffort() : Array
      {
         return this.tempNewlyCompleteEffort;
      }
      
      public function set isSelf(value:Boolean) : void
      {
         this._isSelf = value;
      }
      
      public function get isSelf() : Boolean
      {
         return this._isSelf;
      }
      
      public function getTempAchievementPoint() : int
      {
         return this.tempAchievementPoint;
      }
      
      public function getMainFrameVisible() : Boolean
      {
         if(this._view == null)
         {
            return false;
         }
         if(Boolean(this._view) && this._view.parent == null)
         {
            return false;
         }
         return true;
      }
      
      public function switchVisible() : void
      {
         UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__onUIModuleComplete);
         UIModuleSmallLoading.Instance.progress = 0;
         UIModuleSmallLoading.Instance.show();
         UIModuleSmallLoading.Instance.addEventListener(Event.CLOSE,this.__onClose);
         UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__onProgress);
         UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.DDT_EFFORT);
      }
      
      private function __onClose(event:Event) : void
      {
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__onUIModuleComplete);
         UIModuleSmallLoading.Instance.hide();
         UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__onClose);
      }
      
      private function __onProgress(event:UIModuleEvent) : void
      {
         UIModuleSmallLoading.Instance.progress = event.loader.progress * 100;
      }
      
      private function __onUIModuleComplete(event:UIModuleEvent) : void
      {
         if(event.module == UIModuleTypes.DDT_EFFORT)
         {
            UIModuleSmallLoading.Instance.hide();
            UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__onClose);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__onUIModuleComplete);
            if(this.getMainFrameVisible())
            {
               this.hide();
            }
            else
            {
               if(Boolean(this._view))
               {
                  this.hide();
               }
               this.show();
            }
         }
      }
      
      private function show() : void
      {
         BagAndInfoManager.Instance.showBagAndInfo(3);
      }
      
      private function __frameEvent(event:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         switch(event.responseCode)
         {
            case FrameEvent.ESC_CLICK:
            case FrameEvent.CLOSE_CLICK:
            case FrameEvent.CANCEL_CLICK:
               this.hide();
         }
      }
      
      private function hide() : void
      {
         this._view.removeEventListener(FrameEvent.RESPONSE,this.__frameEvent);
         this._view.dispose();
         this._view = null;
      }
   }
}

