package ddt.manager
{
   import beadSystem.controls.BeadLeadManager;
   import collectionTask.event.CollectionTaskEvent;
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.LoadResourceManager;
   import com.pickgliss.loader.TextLoader;
   import com.pickgliss.loader.UIModuleLoader;
   import com.pickgliss.manager.NoviceDataManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.BagInfo;
   import ddt.data.UIModuleTypes;
   import ddt.data.analyze.QuestListAnalyzer;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.player.SelfInfo;
   import ddt.data.quest.*;
   import ddt.events.BagEvent;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.events.PlayerPropertyEvent;
   import ddt.events.TaskEvent;
   import ddt.states.StateType;
   import ddt.utils.BitArray;
   import ddt.utils.RequestVairableCreater;
   import ddt.view.MainToolBar;
   import ddt.view.UIModuleSmallLoading;
   import ddt.view.chat.ChatEvent;
   import exitPrompt.ExitPromptManager;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.MouseEvent;
   import flash.net.URLVariables;
   import flash.utils.ByteArray;
   import flash.utils.Dictionary;
   import hall.tasktrack.HallTaskTrackManager;
   import hallIcon.HallIconManager;
   import oldPlayerRegress.event.RegressEvent;
   import petsBag.controller.PetBagController;
   import petsBag.event.UpdatePetFarmGuildeEvent;
   import quest.TaskMainFrame;
   import road7th.comm.PackageIn;
   import road7th.data.DictionaryData;
   import road7th.data.DictionaryEvent;
   import road7th.utils.MovieClipWrapper;
   import trainer.TrainStep;
   import tryonSystem.TryonSystemController;
   
   [Event(name="remove",type="tank.events.TaskEvent")]
   [Event(name="add",type="tank.events.TaskEvent")]
   [Event(name="changed",type="tank.events.TaskEvent")]
   public class TaskManager extends EventDispatcher
   {
      
      public static var itemAwardSelected:int;
      
      private static var _selectedQuest:QuestInfo;
      
      private static var _questListLoader:TextLoader;
      
      private static var _mainFrame:TaskMainFrame;
      
      private static var _questDataInited:Boolean;
      
      private static var _instance:TaskManager;
      
      private static var _allQuests:Dictionary;
      
      private static var _questLog:BitArray;
      
      public static var currentQuest:QuestInfo;
      
      private static var _currentNewQuest:QuestInfo;
      
      private static var _isShowing:Boolean;
      
      private static var mc:MovieClipWrapper;
      
      private static var _itemListenerArr:Array;
      
      private static var _consortChatConditions:Array;
      
      public static const REFRESH_TASK_TRACK_VIEW:String = "taskRefreshHallTaskTrackView";
      
      public static const GUIDE_QUEST_ID:int = 339;
      
      public static const COLLECT_INFO_EMAIL:int = 544;
      
      public static const COLLECT_INFO_CELLPHONE:int = 545;
      
      public static const COLLECT_INFO_CELLPHONEII:int = 550;
      
      public static const achievementQuestNo:int = 1000;
      
      public static const BEADLEAD_TASKTYPE1:int = 1578;
      
      public static const BEADLEAD_TASKTYPE2:int = 1579;
      
      public static const HALLICON_TASKTYPE:int = 2042;
      
      public static const SHOW_TASK_HIGHTLIGHT:String = "showTaskHightLight";
      
      public static const HIDE_TASK_HIGHTLIGHT:String = "hideTaskHightLight";
      
      private static var firstshowTask:Boolean = true;
      
      private static const _questListPath:String = "QuestList.xml";
      
      public static var _newQuests:Array = new Array();
      
      public static var _currentCategory:int = 0;
      
      public var isTaskHightLight:Boolean = false;
      
      public var guideId:int;
      
      private var _improve:QuestImproveInfo;
      
      private var _returnFun:Function;
      
      private var _isShown:Boolean = false;
      
      private var _annexListenerArr:Array;
      
      private var _desktopCond:QuestCondition;
      
      private var _friendListenerArr:Array;
      
      private var tmpQuestId:int;
      
      private var _manuGetList:DictionaryData = new DictionaryData();
      
      public function TaskManager()
      {
         super();
      }
      
      public static function get instance() : TaskManager
      {
         if(_instance == null)
         {
            _instance = new TaskManager();
         }
         return _instance;
      }
      
      public function get improve() : QuestImproveInfo
      {
         return this._improve;
      }
      
      public function set selectedQuest(value:QuestInfo) : void
      {
         _selectedQuest = value;
      }
      
      public function get selectedQuest() : QuestInfo
      {
         return _selectedQuest;
      }
      
      public function get MainFrame() : TaskMainFrame
      {
         if(!_mainFrame)
         {
            _mainFrame = ComponentFactory.Instance.creat("QuestFrame");
         }
         return _mainFrame;
      }
      
      public function switchVisible() : void
      {
         if(firstshowTask)
         {
            this._returnFun = this.switchVisible;
            this.moduleLoad();
            return;
         }
         if(!this._isShown)
         {
            this.MainFrame.open();
            this._isShown = true;
         }
         else
         {
            if(TryonSystemController.Instance.view != null)
            {
               return;
            }
            _mainFrame.dispose();
            _mainFrame = null;
            this._isShown = false;
            dispatchEvent(new Event(TaskMainFrame.TASK_FRAME_HIDE));
         }
      }
      
      private function moduleLoad() : void
      {
         UIModuleSmallLoading.Instance.progress = 0;
         UIModuleSmallLoading.Instance.show();
         UIModuleSmallLoading.Instance.addEventListener(Event.CLOSE,this.__onClose);
         UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__onTaskLoadProgress);
         UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__onTaskLoadComplete);
         UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.QUEST);
      }
      
      private function __onTaskLoadComplete(event:UIModuleEvent) : void
      {
         if(event.module == UIModuleTypes.QUEST)
         {
            firstshowTask = false;
            this._returnFun();
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__onTaskLoadComplete);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__onTaskLoadProgress);
            UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__onClose);
            UIModuleSmallLoading.Instance.hide();
         }
      }
      
      private function __onTaskLoadProgress(event:UIModuleEvent) : void
      {
         if(event.module == UIModuleTypes.QUEST)
         {
            UIModuleSmallLoading.Instance.progress = event.loader.progress * 100;
         }
      }
      
      private function __onClose(event:Event) : void
      {
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__onTaskLoadComplete);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__onTaskLoadProgress);
         UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__onClose);
      }
      
      public function get isShow() : Boolean
      {
         return this._isShown;
      }
      
      public function set isShow(value:Boolean) : void
      {
         this._isShown = value;
         if(!this._isShown)
         {
            _mainFrame = null;
         }
      }
      
      public function setup(analyzer:QuestListAnalyzer) : void
      {
         this.allQuests = analyzer.list;
         _questDataInited = false;
         this._improve = this.getImproveArray(analyzer.improveXml);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.QUEST_UPDATE,this.__updateAcceptedTask);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.QUEST_FINISH,this.__questFinish);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.QUEST_MANU_GET,this.questManuGetHandler);
      }
      
      public function reloadNewQuest(analyzer:QuestListAnalyzer) : void
      {
         var info:QuestInfo = null;
         var tempQuests:Dictionary = analyzer.list;
         for each(info in tempQuests)
         {
            if(this.getQuestByID(info.id) == null)
            {
               this.addQuest(info);
            }
         }
      }
      
      private function getImproveArray(xml:XML) : QuestImproveInfo
      {
         var questImprove:QuestImproveInfo = new QuestImproveInfo();
         questImprove.bindMoneyRate = String(xml.@BindMoneyRate).split("|");
         questImprove.expRate = String(xml.@ExpRate).split("|");
         questImprove.goldRate = String(xml.@GoldRate).split("|");
         questImprove.exploitRate = String(xml.@ExploitRate).split("|");
         questImprove.canOneKeyFinishTime = Number(xml.@CanOneKeyFinishTime);
         return questImprove;
      }
      
      public function addQuest(info:QuestInfo) : void
      {
         TaskManager.instance.allQuests[info.Id] = info;
      }
      
      public function loadQuestLog(value:ByteArray) : void
      {
         value.position = 0;
         _questLog = new BitArray();
         for(var i:int = 0; i < value.length; i++)
         {
            _questLog.writeByte(value.readByte());
         }
      }
      
      private function IsQuestFinish(questId:int) : Boolean
      {
         if(!_questLog)
         {
            return false;
         }
         if(questId > _questLog.length * 8 || questId < 1)
         {
            return false;
         }
         questId--;
         var index:int = questId / 8;
         var offset:int = questId % 8;
         var result:int = _questLog[index] & 1 << offset;
         return result != 0;
      }
      
      public function get allQuests() : Dictionary
      {
         if(!_allQuests)
         {
            _allQuests = new Dictionary();
         }
         return _allQuests;
      }
      
      public function set allQuests(dict:Dictionary) : void
      {
         _allQuests = dict;
      }
      
      public function getQuestByID(id:int) : QuestInfo
      {
         if(!this.allQuests)
         {
            return null;
         }
         return this.allQuests[id];
      }
      
      public function getQuestDataByID(id:int) : QuestDataInfo
      {
         if(!this.getQuestByID(id))
         {
            return null;
         }
         return this.getQuestByID(id).data;
      }
      
      public function getAvailableQuests(type:int = -1, onlyExist:Boolean = true) : QuestCategory
      {
         var info:QuestInfo = null;
         var cate:QuestCategory = new QuestCategory();
         for each(info in this.allQuests)
         {
            if(info.QuestID == 3000)
            {
            }
            if(info.QuestID == 3)
            {
            }
            if(info.QuestID == 545 || info.QuestID == 550)
            {
               if(!PathManager.phoneBandEnable())
               {
                  continue;
               }
            }
            if(!(info.id >= 4001 && info.id <= 4024))
            {
               if(type > -1)
               {
                  if(type == 0)
                  {
                     if(info.Type != 0)
                     {
                        continue;
                     }
                  }
                  else if(type == 1)
                  {
                     if(info.Type != 4 && info.Type != 1 && info.Type != 6)
                     {
                        continue;
                     }
                  }
                  else if(type == 2)
                  {
                     if(info.Type != 2 && info.Type < 100)
                     {
                        continue;
                     }
                  }
                  else if(type == 3)
                  {
                     if(info.Type != 3)
                     {
                        continue;
                     }
                  }
                  else if(type == 4)
                  {
                     if(info.Type != 7)
                     {
                        continue;
                     }
                  }
                  else if(type == 5)
                  {
                     if(info.Type != 10)
                     {
                        continue;
                     }
                  }
                  else if(type == 6)
                  {
                     if(info.Type != 66)
                     {
                        continue;
                     }
                  }
               }
               if(onlyExist && info.data && !info.data.isExist)
               {
                  this.requestQuest(info);
               }
               else if(this.isAvailableQuest(info,true))
               {
                  if(info.Id != achievementQuestNo)
                  {
                     if(info.isCompleted)
                     {
                        cate.addCompleted(info);
                     }
                     else if(Boolean(info.data) && info.data.isNew)
                     {
                        cate.addNew(info);
                     }
                     else
                     {
                        cate.addQuest(info);
                     }
                  }
               }
            }
         }
         return cate;
      }
      
      public function getQuestCategory() : void
      {
      }
      
      public function get allHotQuests() : Array
      {
         return this.getAvailableQuests(6,false).list;
      }
      
      public function get allAvailableQuests() : Array
      {
         return this.getAvailableQuests(-1,false).list;
      }
      
      public function get allCurrentQuest() : Array
      {
         return this.getAvailableQuests(-1,true).list;
      }
      
      public function get mainQuests() : Array
      {
         return this.getAvailableQuests(0,true).list;
      }
      
      public function get sideQuests() : Array
      {
         return this.getAvailableQuests(1,true).list;
      }
      
      public function get dailyQuests() : Array
      {
         return this.getAvailableQuests(2,true).list;
      }
      
      public function get texpQuests() : Array
      {
         var info:QuestInfo = null;
         var cate:QuestCategory = new QuestCategory();
         for each(info in this.allQuests)
         {
            if(info.Type >= 100)
            {
               if(Boolean(info.data) && !info.data.isExist)
               {
                  this.requestQuest(info);
               }
               else if(this.isAvailableQuest(info,true))
               {
                  if(info.Id != achievementQuestNo)
                  {
                     if(info.isCompleted)
                     {
                        cate.addCompleted(info);
                     }
                     else if(Boolean(info.data) && info.data.isNew)
                     {
                        cate.addNew(info);
                     }
                     else
                     {
                        cate.addQuest(info);
                     }
                  }
               }
            }
         }
         return cate.list;
      }
      
      public function get newQuests() : Array
      {
         var info:QuestInfo = null;
         var tempArr:Array = new Array();
         for each(info in this.allAvailableQuests)
         {
            if(info.data && info.data.needInformed && info.Type != 2)
            {
               tempArr.push(info);
            }
         }
         _newQuests = tempArr;
         return tempArr;
      }
      
      public function set currentCategory(value:int) : void
      {
         _currentCategory = value;
      }
      
      public function get currentCategory() : int
      {
         if(Boolean(this.selectedQuest))
         {
            return this.selectedQuest.Type;
         }
         return _currentCategory;
      }
      
      public function get welcomeQuests() : Array
      {
         var info:QuestInfo = null;
         var tempArr:Array = new Array();
         for each(info in this.dailyQuests)
         {
            if(info.otherCondition != 1)
            {
               tempArr.push(info);
            }
         }
         return tempArr.reverse();
      }
      
      public function get welcomeGuildQuests() : Array
      {
         var info:QuestInfo = null;
         var tempArr:Array = new Array();
         for each(info in this.dailyQuests)
         {
            if(info.otherCondition == 1)
            {
               tempArr.push(info);
            }
         }
         return tempArr.reverse();
      }
      
      public function getTaskData(id:int) : QuestDataInfo
      {
         if(Boolean(this.getQuestByID(id)))
         {
            return this.getQuestByID(id).data;
         }
         return null;
      }
      
      public function isAvailableQuest(info:QuestInfo, checkExist:Boolean = false) : Boolean
      {
         var grade:int = 0;
         var preArr:Array = null;
         var preId:int = 0;
         var preQuest:QuestInfo = null;
         var dis:Array = PathManager.DISABLE_TASK_ID;
         for(var i:int = 0; i < dis.length; i++)
         {
            if(info.id == parseInt(dis[i]))
            {
               return false;
            }
         }
         if(info.disabled)
         {
            return false;
         }
         if(info.texpTaskIsTimeOut())
         {
            return false;
         }
         if(info.Type <= 100)
         {
            grade = PlayerManager.Instance.Self.Grade;
            if(info.NeedMinLevel > grade || info.NeedMaxLevel < grade)
            {
               return false;
            }
         }
         if(info.PreQuestID != "0,")
         {
            preArr = [];
            preArr = info.PreQuestID.split(",");
            for each(preId in preArr)
            {
               if(preId != 0)
               {
                  if(Boolean(this.getQuestByID(preId)))
                  {
                     preQuest = this.getQuestByID(preId);
                     if(!preQuest)
                     {
                        return false;
                     }
                     if(!this.isAchieved(preQuest))
                     {
                        return false;
                     }
                  }
               }
            }
         }
         if(!(this.isValidateByDate(info) && this.isAvailableByGuild(info) && this.isAvailableByMarry(info)))
         {
            return false;
         }
         if(info.Type <= 100 && this.haveLog(info))
         {
            return false;
         }
         if(!info.isAvailable)
         {
            return false;
         }
         if(info.data == null || !info.data.isExist && info.CanRepeat)
         {
            this.requestQuest(info);
            if(checkExist && info.Type != 4)
            {
               return false;
            }
         }
         if(info.isManuGet && (!info.data || !info.data.isGet))
         {
            if(!this._manuGetList.hasKey(info.id))
            {
               this._manuGetList.add(info.id,info);
            }
            return false;
         }
         return true;
      }
      
      public function isAchieved(info:QuestInfo) : Boolean
      {
         if(info.isAchieved)
         {
            return true;
         }
         if(!info.CanRepeat)
         {
            if(this.IsQuestFinish(info.Id))
            {
               return true;
            }
         }
         return false;
      }
      
      public function isCompleted(info:QuestInfo) : Boolean
      {
         if(info.isCompleted)
         {
            return true;
         }
         return false;
      }
      
      public function isAvailable(info:QuestInfo) : Boolean
      {
         if(!info)
         {
            return false;
         }
         return this.isAvailableQuest(info) && !info.isCompleted;
      }
      
      private function haveLog(info:QuestInfo) : Boolean
      {
         if(info.CanRepeat)
         {
            if(Boolean(info.data) && info.data.repeatLeft == 0)
            {
               return true;
            }
            return false;
         }
         if(this.IsQuestFinish(info.Id))
         {
            return true;
         }
         return false;
      }
      
      public function isValidateByDate(info:QuestInfo) : Boolean
      {
         if(!info)
         {
            return false;
         }
         return !info.isTimeOut();
      }
      
      public function isAvailableByGuild(info:QuestInfo) : Boolean
      {
         if(!info)
         {
            return false;
         }
         return info.otherCondition != 1 || PlayerManager.Instance.Self.ConsortiaID != 0;
      }
      
      public function isAvailableByMarry(info:QuestInfo) : Boolean
      {
         if(!info)
         {
            return false;
         }
         return info.otherCondition != 2 || PlayerManager.Instance.Self.IsMarried;
      }
      
      private function questManuGetHandler(event:CrazyTankSocketEvent) : void
      {
         var pkg:PackageIn = event.pkg;
         var isSuccess:Boolean = pkg.readBoolean();
         var questId:int = pkg.readInt();
         this._manuGetList.remove(questId);
         if(questId == 559 || questId == 561 || questId == 563 || questId == 565 || questId == 567 || questId == 569)
         {
            TaskManager.instance.jumpToQuestByID(questId);
         }
         if(questId == 559)
         {
            NoviceDataManager.instance.saveNoviceData(340,PathManager.userName(),PathManager.solveRequestPath());
         }
         if(questId == 564)
         {
            NoviceDataManager.instance.saveNoviceData(590,PathManager.userName(),PathManager.solveRequestPath());
         }
      }
      
      public function __updateAcceptedTask(event:CrazyTankSocketEvent) : void
      {
         var id:int = 0;
         var info:QuestInfo = null;
         var data:QuestDataInfo = null;
         var con0:int = 0;
         var con1:int = 0;
         var con2:int = 0;
         var con3:int = 0;
         var tmpConArr:Array = null;
         var tmpConLen:int = 0;
         var k:int = 0;
         var tmpIndex:int = 0;
         var pkg:PackageIn = event.pkg;
         var length:int = pkg.readInt();
         for(var i:int = 0; i < length; i++)
         {
            id = pkg.readInt();
            info = new QuestInfo();
            if(Boolean(this.getQuestByID(id)))
            {
               info = this.getQuestByID(id);
               if(Boolean(info.data))
               {
                  data = info.data;
               }
               else
               {
                  data = new QuestDataInfo(id);
                  if(info.required)
                  {
                     data.isNew = true;
                  }
               }
               data.isAchieved = pkg.readBoolean();
               con0 = pkg.readInt();
               con1 = pkg.readInt();
               con2 = pkg.readInt();
               con3 = pkg.readInt();
               data.setProgress(con0,con1,con2,con3);
               data.CompleteDate = pkg.readDate();
               data.repeatLeft = pkg.readInt();
               data.quality = pkg.readInt();
               data.isExist = pkg.readBoolean();
               info.QuestLevel = pkg.readInt();
               tmpConArr = [0,0,0,0];
               tmpConLen = pkg.readInt();
               for(k = 0; k < tmpConLen; k++)
               {
                  tmpIndex = pkg.readInt() - 4;
                  tmpConArr[tmpIndex] = pkg.readInt();
               }
               data.setProgressConcoat(tmpConArr);
               data.isGet = pkg.readBoolean();
               info.data = data;
               if(data.isNew)
               {
                  this.addNewQuest(info);
               }
               if(PetBagController.instance().isPetFarmGuildeTask(info.QuestID))
               {
                  PetBagController.instance().dispatchEvent(new UpdatePetFarmGuildeEvent(UpdatePetFarmGuildeEvent.FINISH,info));
               }
               if(id == TaskManager.BEADLEAD_TASKTYPE1)
               {
                  BeadLeadManager.Instance.perTaskComplete = info.data.isCompleted;
               }
               else if(id == TaskManager.BEADLEAD_TASKTYPE2)
               {
                  BeadLeadManager.Instance.taskComplete = info.data.isCompleted;
               }
               else if(id == TaskManager.HALLICON_TASKTYPE)
               {
                  HallIconManager.instance.checkHallIconExperienceTask(info.data.isCompleted);
               }
               dispatchEvent(new TaskEvent(TaskEvent.CHANGED,info,data));
            }
         }
         this.loadQuestLog(pkg.readByteArray());
         _questDataInited = true;
         this.checkHighLight();
         if(this.hasEventListener(RegressEvent.REGRESS_UPDATE_TASKMENUITEM))
         {
            dispatchEvent(new RegressEvent(RegressEvent.REGRESS_UPDATE_TASKMENUITEM));
         }
         if(this.hasEventListener(CollectionTaskEvent.REFRESH_COMPLETE))
         {
            dispatchEvent(new CollectionTaskEvent(CollectionTaskEvent.REFRESH_COMPLETE));
         }
      }
      
      private function addNewQuest(info:QuestInfo) : void
      {
         if(!_newQuests)
         {
            _newQuests = new Array();
         }
         if(_newQuests.indexOf(info) == -1 && !_isShowing)
         {
            this.showGetNewQuest();
         }
         _newQuests.push(info);
      }
      
      private function availableForMainToolBar() : Boolean
      {
         if(StateManager.currentStateType == null)
         {
            return false;
         }
         return true;
      }
      
      public function clearNewQuest() : void
      {
         var info:QuestInfo = null;
         for each(info in this.allAvailableQuests)
         {
         }
      }
      
      public function showGetNewQuest() : void
      {
      }
      
      private function __onComplete(event:Event) : void
      {
         mc.movie.removeEventListener(MouseEvent.CLICK,this.__onclicked);
         mc.removeEventListener(Event.COMPLETE,this.__onComplete);
         ObjectUtils.disposeObject(mc);
         mc = null;
         _isShowing = false;
      }
      
      private function __onclicked(event:MouseEvent) : void
      {
         mc.movie.removeEventListener(MouseEvent.CLICK,this.__onclicked);
         if(StateManager.currentStateType == StateType.FIGHT_LIB_GAMEVIEW || StateManager.currentStateType == StateType.FIGHTING || StateManager.currentStateType == StateType.TRAINER1 || StateManager.currentStateType == StateType.TRAINER2 || StateManager.currentStateType == StateType.GAME_LOADING)
         {
            return;
         }
         mc.movie.visible = false;
         false;
         if(!this._isShown)
         {
            this.switchVisible();
         }
      }
      
      public function get currentNewQuest() : QuestInfo
      {
         return _currentNewQuest;
      }
      
      private function __questFinish(evt:CrazyTankSocketEvent) : void
      {
         var pkg:PackageIn = evt.pkg;
         var id:int = pkg.readInt();
         if(id == TaskManager.achievementQuestNo)
         {
            return;
         }
         this.onFinishQuest(id);
         if(id == 558)
         {
            NoviceDataManager.instance.saveNoviceData(330,PathManager.userName(),PathManager.solveRequestPath());
         }
         else if(id == 560)
         {
            NoviceDataManager.instance.saveNoviceData(450,PathManager.userName(),PathManager.solveRequestPath());
         }
         else if(id == 562)
         {
            NoviceDataManager.instance.saveNoviceData(500,PathManager.userName(),PathManager.solveRequestPath());
         }
         else if(id == 564)
         {
            NoviceDataManager.instance.saveNoviceData(600,PathManager.userName(),PathManager.solveRequestPath());
         }
         else if(id == 565)
         {
            NoviceDataManager.instance.saveNoviceData(620,PathManager.userName(),PathManager.solveRequestPath());
         }
         else if(id == 566)
         {
            NoviceDataManager.instance.saveNoviceData(640,PathManager.userName(),PathManager.solveRequestPath());
         }
         if(id == 560)
         {
            TrainStep.send(TrainStep.Step.FIGHT_FIRST);
         }
         if(id == 562)
         {
            TrainStep.send(TrainStep.Step.TASK_FIRSTSTRENGTH);
         }
         if(id == 564)
         {
            TrainStep.send(TrainStep.Step.FIGHT_TWO);
         }
         else if(id == 565)
         {
            TrainStep.send(TrainStep.Step.TASK_COLLECTFLOWER);
         }
         else if(id == 566)
         {
            TrainStep.send(TrainStep.Step.TASK_COMPOSE);
         }
         else if(id == 327)
         {
            TrainStep.send(TrainStep.Step.TASK_FIGHTTWOCOMPLETE);
         }
         else if(id == 346)
         {
            TrainStep.send(TrainStep.Step.TASK_DUNGEONFIRST);
         }
         else if(id == 570)
         {
            TrainStep.send(TrainStep.Step.TASK_COLLECTFLOWERYELLOW);
         }
         else if(id == 350)
         {
            TrainStep.send(TrainStep.Step.TASK_DUNGEONTHREE);
         }
         else if(id == 8)
         {
            TrainStep.send(TrainStep.Step.TASK_TXEPFIRST);
         }
      }
      
      private function onFinishQuest(id:int) : void
      {
         var info:QuestInfo = this.getQuestByID(id);
         if(info.isAvailable || Boolean(info.NextQuestID))
         {
            this.requestCanAcceptTask();
         }
         dispatchEvent(new TaskEvent(TaskEvent.FINISH,info,info.data));
      }
      
      public function jumpToQuest(info:QuestInfo) : void
      {
         this.selectedQuest = info;
         this.MainFrame.jumpToQuest(info);
      }
      
      public function onBagChanged() : void
      {
         this.checkHighLight();
      }
      
      public function onGuildUpdate() : void
      {
         this.checkHighLight();
      }
      
      public function onPlayerLevelUp() : void
      {
         this.checkHighLight();
      }
      
      public function finshMarriage() : void
      {
         var info:QuestInfo = null;
         var data:QuestDataInfo = null;
         for each(var _loc5_ in this.allQuests)
         {
            info = _loc5_;
            _loc5_;
            data = info.data;
            if(data)
            {
               if(!data.isAchieved)
               {
                  if(info.Condition == 21)
                  {
                     this.showTaskHightLight();
                  }
               }
            }
         }
         this.requestCanAcceptTask();
      }
      
      public function get achievementQuest() : QuestInfo
      {
         return TaskManager.instance.getQuestByID(achievementQuestNo);
      }
      
      public function requestAchievementReward() : void
      {
         SocketManager.Instance.out.sendQuestFinish(achievementQuestNo,0);
      }
      
      public function requestCanAcceptTask() : void
      {
         var arr:Array = null;
         var info:QuestInfo = null;
         var temp:Array = this.allAvailableQuests;
         if(temp.length != 0)
         {
            arr = new Array();
            for each(var _loc6_ in temp)
            {
               info = _loc6_;
               _loc6_;
               if(info.Type <= 100)
               {
                  if(!(Boolean(info.data) && info.data.isExist))
                  {
                     arr.push(info.QuestID);
                     if(_questDataInited)
                     {
                        info.required = true;
                     }
                  }
               }
            }
            this.socketSendQuestAdd(arr);
         }
      }
      
      public function requestQuest(info:QuestInfo) : void
      {
         if(StateManager.currentStateType == StateType.LOGIN)
         {
            return;
         }
         if(info.Type > 100)
         {
            return;
         }
         var arr:Array = new Array();
         arr.push(info.QuestID);
         if(_questDataInited)
         {
            info.required = true;
            true;
         }
         this.socketSendQuestAdd(arr);
      }
      
      public function requestClubTask() : void
      {
         var info:QuestInfo = null;
         var temp:Array = new Array();
         for each(var _loc5_ in this.allAvailableQuests)
         {
            info = _loc5_;
            _loc5_;
            if(info.otherCondition == 1)
            {
               if(this.isAvailableQuest(info))
               {
                  temp.push(info.QuestID);
               }
            }
         }
         if(temp.length > 0)
         {
            this.socketSendQuestAdd(temp);
         }
      }
      
      public function isHaveBuriedQuest() : Boolean
      {
         var data:QuestCategory = this.getAvailableQuests(5);
         if(!data || data.list.length == 0)
         {
            return false;
         }
         return true;
      }
      
      public function addEquipUpdateListener() : void
      {
         PlayerManager.Instance.Self.Bag.addEventListener(BagEvent.UPDATE,this.__onEquipUpdate);
      }
      
      private function __onEquipUpdate(evt:BagEvent) : void
      {
         PlayerManager.Instance.Self.Bag.removeEventListener(BagEvent.UPDATE,this.__onEquipUpdate);
         this.checkHighLight();
      }
      
      public function addItemListener(itemId:int) : void
      {
         if(!_itemListenerArr)
         {
            _itemListenerArr = new Array();
         }
         _itemListenerArr.push(itemId);
         var self:SelfInfo = PlayerManager.Instance.Self;
         self.getBag(BagInfo.EQUIPBAG).addEventListener(BagEvent.UPDATE,this.__onBagUpdate);
         self.getBag(BagInfo.PROPBAG).addEventListener(BagEvent.UPDATE,this.__onBagUpdate);
      }
      
      private function __onBagUpdate(evt:BagEvent) : void
      {
         var item:InventoryItemInfo = null;
         var id:int = 0;
         for each(var _loc6_ in evt.changedSlots)
         {
            item = _loc6_;
            _loc6_;
            for each(var _loc8_ in _itemListenerArr)
            {
               id = _loc8_;
               _loc8_;
               if(id == item.TemplateID)
               {
                  this.checkHighLight();
               }
            }
         }
      }
      
      public function addGradeListener() : void
      {
         PlayerManager.Instance.Self.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__onPlayerPropertyChange);
      }
      
      private function __onPlayerPropertyChange(e:PlayerPropertyEvent) : void
      {
         if(Boolean(e.changedProperties["Grade"]))
         {
            this.checkHighLight();
         }
      }
      
      public function onMarriaged() : void
      {
         this.checkHighLight();
      }
      
      public function addGuildMemberListener() : void
      {
      }
      
      public function addAnnexListener(cond:QuestCondition) : void
      {
         if(!this._annexListenerArr)
         {
            this._annexListenerArr = new Array();
         }
         this._annexListenerArr.push(cond);
      }
      
      public function addDesktopListener(cond:QuestCondition) : void
      {
         this._desktopCond = cond;
         if(DesktopManager.Instance.isDesktop)
         {
            this.checkQuest(this._desktopCond.questID,this._desktopCond.ConID,0);
         }
      }
      
      public function onDesktopApp() : void
      {
         if(Boolean(this._desktopCond))
         {
            this.checkQuest(this._desktopCond.questID,this._desktopCond.ConID,0);
         }
      }
      
      public function onSendAnnex(itemArr:Array) : void
      {
         var item:InventoryItemInfo = null;
         var cond:QuestCondition = null;
         for each(var _loc6_ in itemArr)
         {
            item = _loc6_;
            _loc6_;
            for each(var _loc8_ in this._annexListenerArr)
            {
               cond = _loc8_;
               _loc8_;
               if(cond.param2 == item.TemplateID)
               {
                  if(this.isAvailableQuest(this.getQuestByID(cond.questID),true))
                  {
                     this.checkQuest(cond.questID,cond.ConID,0);
                  }
               }
            }
         }
      }
      
      public function addFriendListener(cond:QuestCondition) : void
      {
         if(!this._friendListenerArr)
         {
            this._friendListenerArr = new Array();
         }
         this._friendListenerArr.push(cond);
         PlayerManager.Instance.addEventListener(PlayerManager.FRIENDLIST_COMPLETE,this.__onFriendListComplete);
         addEventListener(TaskEvent.CHANGED,this.__onQuestChange);
      }
      
      private function __onQuestChange(evtObj:TaskEvent) : void
      {
         var cond:QuestCondition = null;
         for each(var _loc5_ in this._friendListenerArr)
         {
            cond = _loc5_;
            _loc5_;
            if(evtObj.info.Id == cond.questID)
            {
               this.checkQuest(cond.questID,cond.ConID,cond.param2 - PlayerManager.Instance.friendList.length);
            }
         }
      }
      
      private function __onFriendListComplete(e:Event) : void
      {
         var cond:QuestCondition = null;
         PlayerManager.Instance.friendList.addEventListener(DictionaryEvent.ADD,this.__onFriendListUpdated);
         PlayerManager.Instance.friendList.addEventListener(DictionaryEvent.REMOVE,this.__onFriendListUpdated);
         for each(var _loc5_ in this._friendListenerArr)
         {
            cond = _loc5_;
            _loc5_;
            this.checkQuest(cond.questID,cond.ConID,cond.param2 - PlayerManager.Instance.friendList.length);
         }
      }
      
      private function __onFriendListUpdated(e:DictionaryEvent) : void
      {
         var cond:QuestCondition = null;
         for each(var _loc5_ in this._friendListenerArr)
         {
            cond = _loc5_;
            _loc5_;
            this.checkQuest(cond.questID,cond.ConID,cond.param2 - PlayerManager.Instance.friendList.length);
         }
      }
      
      public function hasConsortiaSayTask() : Boolean
      {
         var task:QuestInfo = null;
         var con:QuestCondition = null;
         var l:Array = this.getAvailableQuests(-1,true).list;
         for each(var _loc6_ in l)
         {
            task = _loc6_;
            _loc6_;
            if(!task.isAchieved)
            {
               for each(var _loc8_ in task._conditions)
               {
                  con = _loc8_;
                  _loc8_;
                  if(con.type == 20 && con.param == 4)
                  {
                     return true;
                  }
               }
            }
         }
         return false;
      }
      
      public function addConsortaChatCondition(con:QuestCondition) : void
      {
         if(_consortChatConditions == null)
         {
            _consortChatConditions = [];
         }
         _consortChatConditions.push(con);
         ChatManager.Instance.addEventListener(ChatEvent.SEND_CONSORTIA,this.__onConsortiaChat);
      }
      
      private function __onConsortiaChat(event:ChatEvent) : void
      {
         var cond:QuestCondition = null;
         if(!this.hasConsortiaSayTask())
         {
            return;
         }
         for each(var _loc5_ in _consortChatConditions)
         {
            cond = _loc5_;
            _loc5_;
            this.checkQuest(cond.questID,cond.ConID,0);
         }
      }
      
      public function sendQuestFinish(questID:uint) : void
      {
         SocketManager.Instance.out.sendQuestFinish(questID,itemAwardSelected);
         this.questFinishHook(questID);
      }
      
      private function questFinishHook(questID:uint) : void
      {
         var selfid:Number = NaN;
         var args:URLVariables = null;
         var request:BaseLoader = null;
         switch(questID)
         {
            case COLLECT_INFO_EMAIL:
               selfid = PlayerManager.Instance.Self.ID;
               args = RequestVairableCreater.creatWidthKey(true);
               args["selfid"] = selfid;
               args["url"] = PathManager.solveLogin();
               args["nickname"] = PlayerManager.Instance.Self.NickName;
               args["rnd"] = Math.random();
               request = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("SendMailGameUrl.ashx"),BaseLoader.REQUEST_LOADER,args);
               LoadResourceManager.Instance.startLoad(request);
         }
      }
      
      public function sendQuestData(questID:int, conID:int) : void
      {
         if(!this.getQuestByID(questID).data)
         {
            return;
         }
         var value:int = int(this.getQuestByID(questID).data.progress[conID]);
         value--;
         this.checkQuest(questID,conID,value);
      }
      
      public function HighLightChecked(info:QuestInfo) : void
      {
         if(info.isCompleted)
         {
            info.hadChecked = true;
            true;
         }
      }
      
      public function checkQuest(id:int, conID:int, value:int) : void
      {
         SocketManager.Instance.out.sendQuestCheck(id,conID,value);
      }
      
      private function socketSendQuestAdd(arr:Array) : void
      {
         SocketManager.Instance.out.sendQuestAdd(arr);
      }
      
      public function checkHighLight() : void
      {
         var info:QuestInfo = null;
         ExitPromptManager.Instance.changeJSQuestVar();
         var count:int = 0;
         var regressTask:QuestCategory = this.getAvailableQuests(4);
         for each(var _loc6_ in this.allCurrentQuest)
         {
            info = _loc6_;
            _loc6_;
            if(regressTask.list.indexOf(info) == -1)
            {
               if(!info.isAchieved || info.CanRepeat)
               {
                  if(info.isCompleted)
                  {
                     if(!info.hadChecked)
                     {
                        count++;
                        HallTaskTrackManager.instance.addCompleteTask(info.QuestID);
                     }
                  }
               }
            }
         }
         if(count > 0)
         {
            this.showTaskHightLight();
         }
         else
         {
            MainToolBar.Instance.hideTaskHightLight();
            this.isTaskHightLight = false;
            dispatchEvent(new Event(HIDE_TASK_HIGHTLIGHT));
         }
         dispatchEvent(new Event(REFRESH_TASK_TRACK_VIEW));
      }
      
      private function showTaskHightLight() : void
      {
         if(this.availableForMainToolBar())
         {
            if(!this._isShown)
            {
               MainToolBar.Instance.showTaskHightLight();
               this.isTaskHightLight = true;
               true;
               dispatchEvent(new Event(SHOW_TASK_HIGHTLIGHT));
            }
         }
      }
      
      public function jumpToQuestByID(id:int = -1) : void
      {
         if(id == -1)
         {
            id = this.tmpQuestId;
         }
         if(firstshowTask)
         {
            this.tmpQuestId = id;
            this._returnFun = this.jumpToQuestByID;
            this.moduleLoad();
            return;
         }
         var info:QuestInfo = this.getQuestByID(id);
         this._isShown = true;
         this.MainFrame.open();
         this.MainFrame.gotoQuest(info);
      }
      
      public function get manuGetList() : DictionaryData
      {
         return this._manuGetList;
      }
   }
}

