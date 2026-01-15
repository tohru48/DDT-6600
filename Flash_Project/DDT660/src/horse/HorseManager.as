package horse
{
   import com.pickgliss.events.ComponentEvent;
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.UIModuleLoader;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.BagInfo;
   import ddt.data.UIModuleTypes;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.TaskManager;
   import ddt.view.UIModuleSmallLoading;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import horse.data.HorsePicCherishVo;
   import horse.data.HorseSkillExpVo;
   import horse.data.HorseSkillGetVo;
   import horse.data.HorseSkillVo;
   import horse.data.HorseTemplateVo;
   import horse.dataAnalyzer.HorsePicCherishAnalyzer;
   import horse.dataAnalyzer.HorseSkillDataAnalyzer;
   import horse.dataAnalyzer.HorseSkillElementDataAnalyzer;
   import horse.dataAnalyzer.HorseSkillGetDataAnalyzer;
   import horse.dataAnalyzer.HorseTemplateDataAnalyzer;
   import horse.horsePicCherish.HorsePicCherishFrame;
   import horse.view.HorseFrame;
   import horse.view.HorseGetSkillView;
   import playerDress.data.PlayerDressEvent;
   import road7th.comm.PackageIn;
   import road7th.data.DictionaryData;
   import trainer.data.Step;
   
   public class HorseManager extends EventDispatcher
   {
      
      private static var _instance:HorseManager;
      
      public static const CHANGE_HORSE:String = "horseChangeHorse";
      
      public static const CHANGE_HORSE_BYPICCHERISH:String = "changeHorseByPicCherish";
      
      public static const UP_HORSE_STEP_1:String = "horseUpHorseStep1";
      
      public static const UP_HORSE_STEP_2:String = "horseUpHorseStep2";
      
      public static const UP_SKILL:String = "horseUpSkill";
      
      public static const TAKE_UP_DOWN_SKILL:String = "horseTakeUpDownSkill";
      
      public static const PRE_NEXT_EFFECT:String = "horsePreNextEffect";
      
      public static const REFRESH_CUR_EFFECT:String = "horseRefreshCurEffect";
      
      public static const GUIDE_6_TO_7:String = "horseGuide6To7";
      
      public var isHasLevelUp:Boolean = false;
      
      private var _curUseHorse:int = 0;
      
      private var _curLevel:int = 0;
      
      private var _curExp:int = 0;
      
      private var _curHasSkillList:Vector.<HorseSkillExpVo> = new Vector.<HorseSkillExpVo>();
      
      private var _curUseSkillList:DictionaryData = new DictionaryData();
      
      private var _horseTemplateList:Vector.<HorseTemplateVo>;
      
      private var _horseSkillGetList:DictionaryData;
      
      private var _horseSkillGetIdList:DictionaryData;
      
      private var _horseSkillGetSortArray:Array;
      
      private var _horseSkillList:DictionaryData;
      
      private var _horseSkillElementList:DictionaryData;
      
      private var _horsePicCherishList:Vector.<HorsePicCherishVo>;
      
      public var updateCherishPropertyFunc:Function;
      
      public var isSkipFromBagView:Boolean;
      
      public var skipHorsePicCherishId:int;
      
      private var _horseFrame:HorseFrame;
      
      private var _isNeedPlayGetNewSkillCartoon:Boolean;
      
      private var _isUpFloatCartoonComplete:Boolean;
      
      public function HorseManager(target:IEventDispatcher = null)
      {
         super(target);
      }
      
      public static function get instance() : HorseManager
      {
         if(_instance == null)
         {
            _instance = new HorseManager();
         }
         return _instance;
      }
      
      public function isSkillHasEquip(skillId:int) : Boolean
      {
         var tmpId:int = 0;
         for each(tmpId in this._curUseSkillList)
         {
            if(tmpId == skillId)
            {
               return true;
            }
         }
         return false;
      }
      
      public function get curUseSkillList() : DictionaryData
      {
         return this._curUseSkillList;
      }
      
      public function get takeUpSkillPlace() : int
      {
         if(!this._curUseSkillList.hasKey(1))
         {
            return 1;
         }
         if(!this._curUseSkillList.hasKey(2))
         {
            return 2;
         }
         if(!this._curUseSkillList.hasKey(3))
         {
            return 3;
         }
         return 0;
      }
      
      public function get horseSkillGetArray() : Array
      {
         return this._horseSkillGetList.list;
      }
      
      public function get curHasSkillList() : Vector.<HorseSkillExpVo>
      {
         return this._curHasSkillList;
      }
      
      public function get curExp() : int
      {
         return this._curExp;
      }
      
      public function get curLevel() : int
      {
         return this._curLevel;
      }
      
      public function get curUseHorse() : int
      {
         return this._curUseHorse;
      }
      
      public function get curHorseTemplateInfo() : HorseTemplateVo
      {
         return this._horseTemplateList[this._curLevel];
      }
      
      public function horsePicCherishDataSetup(data:HorsePicCherishAnalyzer) : void
      {
         this._horsePicCherishList = data.horsePicCherishList;
      }
      
      public function get nextHorseTemplateInfo() : HorseTemplateVo
      {
         if(this._curLevel >= 80)
         {
            return null;
         }
         return this._horseTemplateList[this._curLevel + 1];
      }
      
      public function getHorseTemplateInfoByLevel(level:int) : HorseTemplateVo
      {
         if(level < 0 || level > 80)
         {
            return null;
         }
         return this._horseTemplateList[level];
      }
      
      public function getHorseSkillGetInfoById(skillId:int) : HorseSkillGetVo
      {
         return this._horseSkillGetIdList[skillId];
      }
      
      public function getHorseSkillName(type:int, level:int) : String
      {
         var skillInfo:HorseSkillGetVo = null;
         var info:HorseSkillGetVo = null;
         for each(info in this._horseSkillGetIdList)
         {
            if(info.Type == type && info.Level == level)
            {
               skillInfo = info;
               break;
            }
         }
         return this._horseSkillList[skillInfo.SkillID].Name;
      }
      
      public function getHorseSkillInfoById(skillId:int) : HorseSkillVo
      {
         return this._horseSkillList[skillId];
      }
      
      public function getLevelBySkillId(skillId:int) : int
      {
         var tmp:HorseTemplateVo = null;
         var level:int = -1;
         for each(tmp in this._horseTemplateList)
         {
            if(tmp.SkillID == skillId)
            {
               level = tmp.Grade;
               break;
            }
         }
         return level;
      }
      
      public function horseTemplateDataSetup(data:HorseTemplateDataAnalyzer) : void
      {
         this._horseTemplateList = data.horseTemplateList;
      }
      
      public function horseSkillGetDataSetup(data:HorseSkillGetDataAnalyzer) : void
      {
         var skillId:int = 0;
         var tmpType:String = null;
         this._horseSkillGetIdList = data.horseSkillGetIdList;
         var tmpDataList:DictionaryData = data.horseSkillGetList;
         var skillIdList:Array = [];
         var tmplen:int = int(this._horseTemplateList.length);
         for(var i:int = 0; i < tmplen; i++)
         {
            if(this._horseTemplateList[i].SkillID > 0)
            {
               skillIdList.push(this._horseTemplateList[i].SkillID);
            }
         }
         var typeIdList:Array = [];
         var tmplen2:int = int(skillIdList.length);
         for(var j:int = 0; j < tmplen2; j++)
         {
            skillId = int(skillIdList[j]);
            for(tmpType in tmpDataList)
            {
               if(tmpDataList[tmpType][0].SkillID == skillId)
               {
                  typeIdList.push(tmpDataList[tmpType][0].Type);
                  break;
               }
            }
         }
         var tmplen3:int = int(typeIdList.length);
         this._horseSkillGetList = new DictionaryData();
         for(var k:int = 0; k < tmplen3; k++)
         {
            this._horseSkillGetList.add(typeIdList[k],tmpDataList[typeIdList[k]]);
         }
      }
      
      public function horseSkillDataSetup(data:HorseSkillDataAnalyzer) : void
      {
         this._horseSkillList = data.horseSkillList;
      }
      
      public function horseSkillElementDataSetup(data:HorseSkillElementDataAnalyzer) : void
      {
         this._horseSkillElementList = data.horseSkillElementList;
      }
      
      public function loadModule() : void
      {
         if(PlayerManager.Instance.Self.Grade < 28)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("horse.notOpen"));
            return;
         }
         if(!TaskManager.instance.isAchieved(TaskManager.instance.getQuestByID(568)))
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("horse.notOpen2"));
            return;
         }
         UIModuleSmallLoading.Instance.progress = 0;
         UIModuleSmallLoading.Instance.show();
         UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.loadCompleteHandler);
         UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.onUimoduleLoadProgress);
         UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.HORSE);
      }
      
      private function onUimoduleLoadProgress(event:UIModuleEvent) : void
      {
         if(event.module == UIModuleTypes.HORSE)
         {
            UIModuleSmallLoading.Instance.progress = event.loader.progress * 100;
         }
      }
      
      private function loadCompleteHandler(event:UIModuleEvent) : void
      {
         if(event.module == UIModuleTypes.HORSE)
         {
            UIModuleSmallLoading.Instance.hide();
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.loadCompleteHandler);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.onUimoduleLoadProgress);
            this.openFrame();
         }
      }
      
      private function openFrame() : void
      {
         var currentIndex:int = 0;
         var index:int = 0;
         var frame:HorsePicCherishFrame = null;
         if(!this._horseFrame)
         {
            this._horseFrame = ComponentFactory.Instance.creatComponentByStylename("HorseFrame");
            this._horseFrame.addEventListener(ComponentEvent.DISPOSE,this.frameDisposeHandler,false,0,true);
            LayerManager.Instance.addToLayer(this._horseFrame,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
            if(HorseManager.instance.isSkipFromBagView)
            {
               currentIndex = 1;
               for(index = 0; index < this._horsePicCherishList.length; index++)
               {
                  if(this._horsePicCherishList[index].ID == this.skipHorsePicCherishId)
                  {
                     if(index != 0)
                     {
                        currentIndex = int(index / 8) + 1;
                     }
                     break;
                  }
               }
               frame = ComponentFactory.Instance.creatComponentByStylename("HorsePicCherishFrame");
               frame.index = currentIndex;
               LayerManager.Instance.addToLayer(frame,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
            }
         }
         if(!PlayerManager.Instance.Self.isNewOnceFinish(Step.HORSE_GUIDE_1))
         {
            SocketManager.Instance.out.syncWeakStep(Step.HORSE_GUIDE_1);
         }
         if(!PlayerManager.Instance.Self.isNewOnceFinish(Step.HORSE_GUIDE_2))
         {
            SocketManager.Instance.out.syncWeakStep(Step.HORSE_GUIDE_2);
         }
      }
      
      private function frameDisposeHandler(event:ComponentEvent) : void
      {
         if(Boolean(this._horseFrame))
         {
            this._horseFrame.removeEventListener(ComponentEvent.DISPOSE,this.frameDisposeHandler);
         }
         this._horseFrame = null;
      }
      
      public function closeFrame() : void
      {
         if(Boolean(this._horseFrame))
         {
            this._horseFrame.removeEventListener(ComponentEvent.DISPOSE,this.frameDisposeHandler);
         }
         ObjectUtils.disposeObject(this._horseFrame);
         this._horseFrame = null;
      }
      
      public function setup() : void
      {
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.HORSE,this.pkgHandler);
      }
      
      private function pkgHandler(event:CrazyTankSocketEvent) : void
      {
         var pkg:PackageIn = event.pkg;
         var cmd:int = pkg.readByte();
         switch(cmd)
         {
            case HorsePackageType.GET_ALL_DATA:
               this.initAllData(pkg);
               break;
            case HorsePackageType.CHANGE_HORSE:
               this.changeHorse(pkg);
               break;
            case HorsePackageType.UP_HORSE:
               this.upHorse(pkg);
               break;
            case HorsePackageType.GET_SKILL:
               this.getSkillHandler(pkg);
               break;
            case HorsePackageType.UP_SKILL:
               this.upSkillHandler(pkg);
               break;
            case HorsePackageType.TAKE_UP_DOWN_SKILL:
               this.takeUpDownSkillHandler(pkg);
               break;
            case HorsePackageType.HORSE_PICCHERISH_INFO:
               this.picCherishInfo(pkg);
               break;
            case HorsePackageType.ACTIVE_HORSEPICCHERISH:
               this.activeHandler(pkg);
         }
      }
      
      private function takeUpDownSkillHandler(pkg:PackageIn) : void
      {
         var key:String = null;
         var skillId:int = pkg.readInt();
         var status:int = pkg.readInt();
         if(status > 0)
         {
            this._curUseSkillList.add(status,skillId);
         }
         else
         {
            for(key in this._curUseSkillList)
            {
               if(this._curUseSkillList[key] == skillId)
               {
                  this._curUseSkillList.remove(key);
                  break;
               }
            }
         }
         dispatchEvent(new Event(TAKE_UP_DOWN_SKILL));
      }
      
      private function upSkillHandler(pkg:PackageIn) : void
      {
         var tmp:HorseSkillExpVo = null;
         var tmp2:String = null;
         var oldSkillId:int = pkg.readInt();
         var newSkillId:int = pkg.readInt();
         var exp:int = pkg.readInt();
         for each(tmp in this._curHasSkillList)
         {
            if(tmp.skillId == oldSkillId)
            {
               tmp.skillId = newSkillId;
               tmp.exp = exp;
               break;
            }
         }
         for(tmp2 in this._curUseSkillList)
         {
            if(this._curUseSkillList[tmp2] == oldSkillId)
            {
               this._curUseSkillList.add(tmp2,newSkillId);
               break;
            }
         }
         dispatchEvent(new Event(UP_SKILL));
         dispatchEvent(new Event(TAKE_UP_DOWN_SKILL));
      }
      
      public function upFloatCartoonPlayComplete() : void
      {
         this._isUpFloatCartoonComplete = true;
         dispatchEvent(new Event(UP_HORSE_STEP_2));
         if(this._isNeedPlayGetNewSkillCartoon)
         {
            this.openGetNewSkillView();
         }
      }
      
      private function getSkillHandler(pkg:PackageIn) : void
      {
         var tmp:HorseSkillExpVo = new HorseSkillExpVo();
         tmp.skillId = pkg.readInt();
         tmp.exp = pkg.readInt();
         this._curHasSkillList.push(tmp);
         this._isNeedPlayGetNewSkillCartoon = true;
         if(this._isUpFloatCartoonComplete)
         {
            this.openGetNewSkillView();
         }
      }
      
      private function openGetNewSkillView() : void
      {
         var getSkillView:HorseGetSkillView = new HorseGetSkillView();
         getSkillView.show(this._curHasSkillList[this._curHasSkillList.length - 1].skillId);
         this._isNeedPlayGetNewSkillCartoon = false;
         this._isUpFloatCartoonComplete = false;
      }
      
      private function upHorse(pkg:PackageIn) : void
      {
         this.isHasLevelUp = pkg.readBoolean();
         this._curLevel = pkg.readInt();
         this._curExp = pkg.readInt();
         this._isUpFloatCartoonComplete = false;
         dispatchEvent(new Event(UP_HORSE_STEP_1));
      }
      
      private function changeHorse(pkg:PackageIn) : void
      {
         this._curUseHorse = pkg.readInt();
         this.updateHorse();
         if(this._curUseHorse > 100)
         {
            dispatchEvent(new Event(CHANGE_HORSE_BYPICCHERISH));
         }
         PlayerManager.Instance.Self.MountsType = this._curUseHorse;
         SocketManager.Instance.out.sendModifyNewPlayerDress();
         SocketManager.Instance.dispatchEvent(new PlayerDressEvent(PlayerDressEvent.UPDATE_PLAYERINFO));
      }
      
      private function updateHorse() : void
      {
         var key:String = null;
         for(key in PlayerManager.Instance.Self.horsePicCherishDic)
         {
            PlayerManager.Instance.Self.horsePicCherishDic[key] = int(key) == this._curUseHorse;
         }
         dispatchEvent(new Event(CHANGE_HORSE));
      }
      
      private function initAllData(pkg:PackageIn) : void
      {
         var tmp:HorseSkillExpVo = null;
         var status:int = 0;
         this._curUseHorse = pkg.readInt();
         this._curLevel = pkg.readInt();
         this._curExp = pkg.readInt();
         var count:int = pkg.readInt();
         this._curHasSkillList = new Vector.<HorseSkillExpVo>();
         this._curUseSkillList = new DictionaryData();
         for(var i:int = 0; i < count; i++)
         {
            tmp = new HorseSkillExpVo();
            tmp.skillId = pkg.readInt();
            tmp.exp = pkg.readInt();
            this._curHasSkillList.push(tmp);
            status = pkg.readInt();
            if(status > 0)
            {
               this._curUseSkillList.add(status,tmp.skillId);
            }
         }
      }
      
      public function getHorseLevelByExp(value:int) : int
      {
         var level:int = 0;
         for(var i:int = 0; i < this._horseTemplateList.length; i++)
         {
            if(this._horseTemplateList[i].Experience > value)
            {
               level = i;
               break;
            }
         }
         return level;
      }
      
      private function picCherishInfo(pkg:PackageIn) : void
      {
         var id:int = 0;
         var isUsed:Boolean = false;
         var count:int = pkg.readInt();
         for(var i:int = 0; i < count; i++)
         {
            id = pkg.readInt();
            isUsed = pkg.readInt() == 1;
            PlayerManager.Instance.Self.horsePicCherishDic[id] = isUsed;
         }
      }
      
      private function activeHandler(pkg:PackageIn) : void
      {
         var id:int = pkg.readInt();
         var isUsed:Boolean = pkg.readInt() == 1;
         PlayerManager.Instance.Self.horsePicCherishDic[id] = isUsed;
         this.updateCherishPropertyFunc();
         dispatchEvent(new Event(CHANGE_HORSE_BYPICCHERISH));
      }
      
      public function getHorsePicCherishData() : Vector.<HorsePicCherishVo>
      {
         return this._horsePicCherishList;
      }
      
      public function getHorsePicCherishState(id:int, templateId:int) : Array
      {
         var isPicCherishActive:Boolean = false;
         var isHasPicCherish:Boolean = false;
         var isPicCherishUsed:Boolean = false;
         isPicCherishActive = PlayerManager.Instance.Self.horsePicCherishDic[id] != null;
         isHasPicCherish = PlayerManager.Instance.Self.getBag(BagInfo.PROPBAG).getItemByTemplateId(templateId) != null;
         if(isPicCherishActive)
         {
            isPicCherishUsed = Boolean(PlayerManager.Instance.Self.horsePicCherishDic[id]);
         }
         return [isPicCherishActive,isHasPicCherish,isPicCherishUsed];
      }
      
      public function getHorsePicCherishAddProperty(id:int) : Array
      {
         var data:HorsePicCherishVo = null;
         for each(data in this._horsePicCherishList)
         {
            if(data.ID == id)
            {
               return [data.AddHurt,data.AddGuard,data.AddBlood,data.MagicAttack,data.MagicDefence];
            }
         }
         return [0,0,0,0,0];
      }
   }
}

