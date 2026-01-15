package trainer.controller
{
   import bagAndInfo.BagAndInfoManager;
   import bagAndInfo.cell.BagCell;
   import battleGroud.BattleGroudManager;
   import calendar.CalendarManager;
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.UIModuleLoader;
   import com.pickgliss.ui.ComponentFactory;
   import consortion.ConsortionModelControl;
   import ddt.bagStore.BagStore;
   import ddt.data.BagInfo;
   import ddt.data.EquipType;
   import ddt.data.UIModuleTypes;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PathManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.StateManager;
   import ddt.states.StateType;
   import farm.FarmModelController;
   import flash.events.EventDispatcher;
   import flash.utils.Dictionary;
   import mainbutton.MainButtnController;
   import pet.sprite.PetSpriteController;
   import sevenDouble.SevenDoubleManager;
   import trainer.data.Step;
   import trainer.view.SystemOpenPromptFrame;
   import treasure.controller.TreasureManager;
   import treasure.model.TreasureModel;
   
   public class SystemOpenPromptManager extends EventDispatcher
   {
      
      private static var _instance:SystemOpenPromptManager;
      
      public static const TOTEM:int = 1;
      
      public static const GEMSTONE:int = 2;
      
      public static const GET_AWARD:int = 3;
      
      public static const SIGN:int = 4;
      
      public static const TREASURE:int = 10;
      
      public static const CONSORTIA_BOSS_OPEN:int = 5;
      
      public static const BATTLE_GROUND_OPEN:int = 6;
      
      public static const FARM_CROP_RIPE:int = 7;
      
      public static const SEVEN_DOUBLE_DUNGEON:int = 8;
      
      public static const GET_NEW_EQUIP_TIP:int = 9;
      
      public static const ENCHANT:int = 11;
      
      public var isShowNewEuipTip:Boolean;
      
      private var _item:InventoryItemInfo;
      
      private var _equipFrameDic:Dictionary;
      
      private var _isLoadComplete:Boolean = false;
      
      private var _frameList:Object;
      
      private var _isJudge:Boolean = false;
      
      public function SystemOpenPromptManager()
      {
         super(null);
      }
      
      public static function get instance() : SystemOpenPromptManager
      {
         if(_instance == null)
         {
            _instance = new SystemOpenPromptManager();
         }
         return _instance;
      }
      
      public function loadModule() : void
      {
         UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.loadCompleteHandler);
         UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.SYSTEM_OPEN_PROMPT);
      }
      
      private function loadCompleteHandler(event:UIModuleEvent) : void
      {
         if(event.module == UIModuleTypes.SYSTEM_OPEN_PROMPT)
         {
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.loadCompleteHandler);
            this._isLoadComplete = true;
            this.showFrame();
         }
      }
      
      public function showFrame(item:InventoryItemInfo = null, toPlace:int = 0) : void
      {
         var tmp:SystemOpenPromptFrame = null;
         this._frameList = {};
         if(PetSpriteController.Instance.checkFarmCropRipe() || FarmModelController.instance.isHelperOK)
         {
            if(!this._isLoadComplete)
            {
               this.loadModule();
               return;
            }
            tmp = ComponentFactory.Instance.creatCustomObject("SystemOpenPromptFrame");
            tmp.show(FARM_CROP_RIPE,this.gotoSystem);
            this._frameList[FARM_CROP_RIPE] = tmp;
         }
         if(PlayerManager.Instance.Self.Grade >= 20 && !PlayerManager.Instance.Self.isNewOnceFinish(Step.TOTEM_OPEN))
         {
            if(!this._isLoadComplete)
            {
               this.loadModule();
               return;
            }
            tmp = ComponentFactory.Instance.creatCustomObject("SystemOpenPromptFrame");
            tmp.show(TOTEM,this.gotoSystem);
            this._frameList[TOTEM] = tmp;
            SocketManager.Instance.out.syncWeakStep(Step.TOTEM_OPEN);
         }
         if(PlayerManager.Instance.Self.Grade >= 30 && !PlayerManager.Instance.Self.isNewOnceFinish(Step.GEMSTONE_OPEN) && PathManager.solveGemstoneSwitch)
         {
            if(!this._isLoadComplete)
            {
               this.loadModule();
               return;
            }
            tmp = ComponentFactory.Instance.creatCustomObject("SystemOpenPromptFrame");
            tmp.show(GEMSTONE,this.gotoSystem);
            this._frameList[GEMSTONE] = tmp;
            SocketManager.Instance.out.syncWeakStep(Step.GEMSTONE_OPEN);
         }
         if(PlayerManager.Instance.Self.Grade >= 6 && !PlayerManager.Instance.Self.isNewOnceFinish(Step.ENCHANT_OPEN))
         {
            if(!this._isLoadComplete)
            {
               this.loadModule();
               return;
            }
            tmp = ComponentFactory.Instance.creatCustomObject("SystemOpenPromptFrame");
            tmp.show(ENCHANT,this.gotoSystem);
            this._frameList[ENCHANT] = tmp;
            SocketManager.Instance.out.syncWeakStep(Step.ENCHANT_OPEN);
         }
         if(PathManager.treasureSwitch && !this._isJudge && PlayerManager.Instance.Self.Grade >= 25 && PlayerManager.Instance.Self.treasure + PlayerManager.Instance.Self.treasureAdd > 0 && !TreasureModel.instance.isEndTreasure)
         {
            if(!this._isLoadComplete)
            {
               this.loadModule();
               return;
            }
            tmp = ComponentFactory.Instance.creatCustomObject("SystemOpenPromptFrame");
            tmp.show(TREASURE,this.gotoSystem);
            this._frameList[TREASURE] = tmp;
         }
         if(!this._isJudge && PlayerManager.Instance.Self.Grade >= 5 && (PlayerManager.Instance.Self.IsVIP && PlayerManager.Instance.Self.canTakeVipReward))
         {
            if(!this._isLoadComplete)
            {
               this.loadModule();
               return;
            }
            tmp = ComponentFactory.Instance.creatCustomObject("SystemOpenPromptFrame");
            tmp.show(GET_AWARD,this.gotoSystem);
            this._frameList[GET_AWARD] = tmp;
         }
         if(!this._isJudge && PlayerManager.Instance.Self.Grade >= 5 && !PlayerManager.Instance.Self.Sign)
         {
            if(!this._isLoadComplete)
            {
               this.loadModule();
               return;
            }
            tmp = ComponentFactory.Instance.creatCustomObject("SystemOpenPromptFrame");
            tmp.show(SIGN,this.gotoSystem);
            this._frameList[SIGN] = tmp;
         }
         if(ConsortionModelControl.Instance.isShowBossOpenTip)
         {
            if(!this._isLoadComplete)
            {
               this.loadModule();
               return;
            }
            tmp = ComponentFactory.Instance.creatCustomObject("SystemOpenPromptFrame");
            tmp.show(CONSORTIA_BOSS_OPEN,this.gotoSystem);
            this._frameList[CONSORTIA_BOSS_OPEN] = tmp;
            ConsortionModelControl.Instance.isShowBossOpenTip = false;
         }
         if(SevenDoubleManager.instance.isShowDungeonTip && !PlayerManager.Instance.Self.isSameDay && SevenDoubleManager.instance.isStart)
         {
            if(!this._isLoadComplete)
            {
               this.loadModule();
               return;
            }
            tmp = ComponentFactory.Instance.creatCustomObject("SystemOpenPromptFrame");
            tmp.show(SEVEN_DOUBLE_DUNGEON,this.gotoSystem);
            this._frameList[SEVEN_DOUBLE_DUNGEON] = tmp;
            SevenDoubleManager.instance.isShowDungeonTip = false;
         }
         this._isJudge = true;
      }
      
      public function showEquipTipFrame(item:InventoryItemInfo) : void
      {
         var equipFrame:SystemOpenPromptFrame = null;
         this._equipFrameDic = new Dictionary();
         this._item = item;
         if(Boolean(this._item) && this.checkUseHealStone(item))
         {
            equipFrame = ComponentFactory.Instance.creatCustomObject("SystemOpenPromptFrame");
            equipFrame.show(GET_NEW_EQUIP_TIP,this.equipedNewEquip,this._item);
            this._equipFrameDic[item.TemplateID] = equipFrame;
         }
      }
      
      private function checkUseHealStone(info:InventoryItemInfo) : Boolean
      {
         if(info.CategoryID == EquipType.HEALSTONE)
         {
            if(PlayerManager.Instance.Self.Grade >= int(info.Property1))
            {
               return true;
            }
            return false;
         }
         return true;
      }
      
      public function equipedNewEquip(equipCell:BagCell) : void
      {
         var info:InventoryItemInfo = equipCell.info as InventoryItemInfo;
         var toPlace:int = PlayerManager.Instance.getPlaceOfEquip(info);
         if(toPlace == -1)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.systemOpenPrompt.equiped"));
         }
         else
         {
            SocketManager.Instance.out.sendMoveGoods(BagInfo.EQUIPBAG,info.Place,BagInfo.EQUIPBAG,toPlace,info.Count);
         }
         this._equipFrameDic[info.TemplateID] = null;
         delete this._equipFrameDic[info.TemplateID];
      }
      
      public function gotoSystem(type:int) : void
      {
         switch(type)
         {
            case TOTEM:
               this.showTotem();
               break;
            case GEMSTONE:
               this.showGemstone();
               break;
            case GET_AWARD:
               this.showGetAward();
               break;
            case SIGN:
               this.showSign();
               break;
            case TREASURE:
               this.showTreasure();
               break;
            case CONSORTIA_BOSS_OPEN:
               this.showConsortiaBoss();
               break;
            case BATTLE_GROUND_OPEN:
               this.showBattleGround();
               break;
            case FARM_CROP_RIPE:
               FarmModelController.instance.isHelperOK = false;
               this.showFarm();
               break;
            case SEVEN_DOUBLE_DUNGEON:
               this.goSevenDoubleDungeon();
               break;
            case ENCHANT:
               this.showEnchant();
         }
         this._frameList[type] = null;
         delete this._frameList[type];
      }
      
      private function goSevenDoubleDungeon() : void
      {
         StateManager.setState(StateType.DUNGEON_LIST);
      }
      
      private function showFarm() : void
      {
         FarmModelController.instance.goFarm(PlayerManager.Instance.Self.ID,PlayerManager.Instance.Self.NickName);
      }
      
      private function showBattleGround() : void
      {
         BattleGroudManager.Instance.initBattleView();
      }
      
      private function showConsortiaBoss() : void
      {
         StateManager.setState(StateType.CONSORTIA,ConsortionModelControl.Instance.openBossFrame);
      }
      
      private function showTreasure() : void
      {
         TreasureManager.instance.show();
      }
      
      private function showSign() : void
      {
         CalendarManager.getInstance().open(1);
      }
      
      private function showGetAward() : void
      {
         MainButtnController.instance.show(MainButtnController.DDT_AWARD);
      }
      
      private function showGemstone() : void
      {
         BagStore.instance.show(BagStore.FORGE_STORE,3);
      }
      
      private function showEnchant() : void
      {
         BagStore.instance.show(BagStore.FORGE_STORE,4);
      }
      
      private function showTotem() : void
      {
         BagAndInfoManager.Instance.showBagAndInfo(5);
      }
      
      public function dispose() : void
      {
         var tmp:SystemOpenPromptFrame = null;
         var equipTmp:SystemOpenPromptFrame = null;
         for each(tmp in this._frameList)
         {
            tmp.dispose();
         }
         this._frameList = null;
         for each(equipTmp in this._equipFrameDic)
         {
            equipTmp.dispose();
         }
         this._equipFrameDic = null;
      }
      
      public function get isLoadComplete() : Boolean
      {
         return this._isLoadComplete;
      }
   }
}

