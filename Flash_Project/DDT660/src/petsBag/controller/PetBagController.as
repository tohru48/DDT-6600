package petsBag.controller
{
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.UIModuleLoader;
   import ddt.data.UIModuleTypes;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.ChatManager;
   import ddt.manager.ItemManager;
   import ddt.manager.MessageTipManager;
   import ddt.manager.SocketManager;
   import ddt.manager.TaskManager;
   import flash.display.DisplayObjectContainer;
   import flash.events.EventDispatcher;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import pet.date.PetEquipData;
   import pet.date.PetInfo;
   import pet.date.PetTemplateInfo;
   import petsBag.data.PetFarmGuildeInfo;
   import petsBag.model.PetBagModel;
   import petsBag.view.PetsBagOutView;
   import road7th.comm.PackageIn;
   import road7th.data.DictionaryData;
   import trainer.data.ArrowType;
   import trainer.view.NewHandContainer;
   
   public class PetBagController extends EventDispatcher
   {
      
      private static var _instance:PetBagController;
      
      public var isOtherPetViewOpen:Boolean = false;
      
      public var petModel:PetBagModel;
      
      public var isEquip:Boolean = false;
      
      private var _view:PetsBagOutView;
      
      private var _newPetInfo:PetInfo;
      
      private var _popuMsg:Array = [];
      
      private var _timer:Timer;
      
      public function PetBagController()
      {
         super();
      }
      
      public static function instance() : PetBagController
      {
         if(!_instance)
         {
            _instance = new PetBagController();
         }
         return _instance;
      }
      
      public function set newPetInfo(value:PetInfo) : void
      {
         this._newPetInfo = value;
      }
      
      public function get newPetInfo() : PetInfo
      {
         return this._newPetInfo;
      }
      
      public function get view() : PetsBagOutView
      {
         return this._view;
      }
      
      public function set view(value:PetsBagOutView) : void
      {
         this._view = value;
      }
      
      public function setup() : void
      {
         this.petModel = new PetBagModel();
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.OPTION_CHANGE,this.__petGuildOptionChange);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.DEL_PET_EQUIP,this.delPetEquipHander);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.ADD_PET_EQUIP,this.addPetEquipHander);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.PET_EAT,this._eatPetsInfoHandler);
      }
      
      private function _eatPetsInfoHandler(e:CrazyTankSocketEvent) : void
      {
         var eatPetsInfo:DictionaryData = new DictionaryData();
         eatPetsInfo.add("weaponExp",e.pkg.readInt());
         eatPetsInfo.add("weaponLevel",e.pkg.readInt());
         eatPetsInfo.add("clothesExp",e.pkg.readInt());
         eatPetsInfo.add("clothesLevel",e.pkg.readInt());
         eatPetsInfo.add("hatExp",e.pkg.readInt());
         eatPetsInfo.add("hatLevel",e.pkg.readInt());
         if(this.petModel.eatPetsInfo.length == 0)
         {
            this.petModel.eatPetsLevelUp = false;
         }
         else if(eatPetsInfo.weaponLevel > this.petModel.eatPetsInfo.weaponLevel || eatPetsInfo.clothesLevel > this.petModel.eatPetsInfo.clothesLevel || eatPetsInfo.hatLevel > this.petModel.eatPetsInfo.hatLevel)
         {
            this.petModel.eatPetsLevelUp = true;
         }
         else
         {
            this.petModel.eatPetsLevelUp = false;
         }
         this.petModel.eatPetsInfo = eatPetsInfo;
      }
      
      protected function addPetEquipHander(event:CrazyTankSocketEvent) : void
      {
         var petPlace:int = 0;
         var type:int = 0;
         var tempID:int = 0;
         var startTime:String = null;
         var ValidDate:int = 0;
         var data:PetEquipData = null;
         var equInfo:InventoryItemInfo = null;
         var newInfo:InventoryItemInfo = null;
         var bool:Boolean = event.pkg.readBoolean();
         if(bool)
         {
            petPlace = event.pkg.readInt();
            type = event.pkg.readInt();
            tempID = event.pkg.readInt();
            startTime = event.pkg.readDateString();
            ValidDate = event.pkg.readInt();
            data = new PetEquipData();
            data.eqTemplateID = tempID;
            data.eqType = type;
            data.startTime = startTime;
            data.ValidDate = ValidDate;
            equInfo = new InventoryItemInfo();
            equInfo.TemplateID = data.eqTemplateID;
            equInfo.ValidDate = data.ValidDate;
            equInfo.BeginDate = data.startTime;
            equInfo.IsBinds = true;
            equInfo.IsUsed = true;
            equInfo.Place = data.eqType;
            newInfo = ItemManager.fill(equInfo) as InventoryItemInfo;
            if(Boolean(this.petModel.currentPetInfo.equipList[type]))
            {
               this.petModel.currentPetInfo.equipList[type] = newInfo;
            }
            else
            {
               this.petModel.currentPetInfo.equipList.add(type,newInfo);
            }
            if(this._view && this._view.parent && petPlace == this.petModel.currentPetInfo.Place)
            {
               this._view.addPetEquip(newInfo);
            }
         }
      }
      
      protected function delPetEquipHander(event:CrazyTankSocketEvent) : void
      {
         var bool:Boolean = event.pkg.readBoolean();
         var petPlace:int = event.pkg.readInt();
         var type:int = event.pkg.readInt();
         if(bool)
         {
            if(!this.petModel.currentPetInfo)
            {
               return;
            }
            if(Boolean(this.petModel.currentPetInfo.equipList[type]))
            {
               this.petModel.currentPetInfo.equipList.remove(type);
            }
            if(this._view && this._view.parent && petPlace == this.petModel.currentPetInfo.Place)
            {
               this._view.delPetEquip(petPlace,type);
            }
         }
      }
      
      public function pushMsg(str:String) : void
      {
         this._popuMsg.push(str);
         if(!this._timer)
         {
            this._timer = new Timer(2000);
            this._timer.addEventListener(TimerEvent.TIMER,this.__popu);
            this._timer.start();
         }
      }
      
      private function __popu(e:TimerEvent) : void
      {
         var msg:String = "";
         if(this._popuMsg.length > 0)
         {
            msg = this._popuMsg.shift();
            MessageTipManager.getInstance().show(msg);
            ChatManager.Instance.sysChatYellow(msg);
         }
         else
         {
            this._timer.stop();
            this._timer.removeEventListener(TimerEvent.TIMER,this.__popu);
            this._timer = null;
            this._popuMsg = [];
         }
      }
      
      public function getEquipdSkillIndex() : int
      {
         return this.view.getUnLockItemIndex();
      }
      
      public function getPetPic($info:PetTemplateInfo, $levl:int) : String
      {
         var result:String = "";
         if($levl < 30)
         {
            result = $info.Pic + "/icon1";
         }
         else if(30 <= $levl && $levl < 50)
         {
            result = $info.Pic + "/icon2";
         }
         else if(50 <= $levl)
         {
            result = $info.Pic + "/icon3";
         }
         return result;
      }
      
      public function getPicStrByLv($info:PetInfo) : String
      {
         var result:String = "";
         if($info.Level < 30)
         {
            result = $info.Pic + "/icon1";
         }
         else if(30 <= $info.Level && $info.Level < 50)
         {
            result = $info.Pic + "/icon2";
         }
         else if(50 <= $info.Level)
         {
            result = $info.Pic + "/icon3";
         }
         return result;
      }
      
      private function loadPetsGuildeUI(callBack:Function) : void
      {
         var __Finish:Function = null;
         __Finish = function(evt:UIModuleEvent):void
         {
            if(evt.module == UIModuleTypes.FARM_PET_TRAINER_UI)
            {
               UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,__Finish);
               petModel.isLoadPetTrainer = true;
               if(Boolean(petModel.CurrentPetFarmGuildeArrow))
               {
                  callBack(petModel.CurrentPetFarmGuildeArrow);
               }
            }
         };
         UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.FARM_PET_TRAINER_UI);
         UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,__Finish);
      }
      
      private function showLoadedArrow(currentPetFarmArrow:Object) : void
      {
         if(currentPetFarmArrow.id != 94 && currentPetFarmArrow.id != 119 && currentPetFarmArrow.id != 100)
         {
            NewHandContainer.Instance.showArrow(currentPetFarmArrow.id,currentPetFarmArrow.rotation,currentPetFarmArrow.arrowPos,currentPetFarmArrow.tip,currentPetFarmArrow.tipPos,currentPetFarmArrow.con,0,true);
         }
      }
      
      public function showPetFarmGuildArrow(id:int, rotation:int, arrowPos:String, tip:String = "", tipPos:String = "", con:DisplayObjectContainer = null, delay:int = 0) : void
      {
         if(this.petModel.isLoadPetTrainer)
         {
            if(this.petModel.preShowArrowID != 0)
            {
               if(id != this.petModel.nextShowArrowID)
               {
                  return;
               }
            }
            this.setAvailableArrow(id);
            if(id != 94)
            {
               NewHandContainer.Instance.showArrow(id,rotation,arrowPos,tip,tipPos,con,0,true);
            }
         }
         else
         {
            this.petModel.CurrentPetFarmGuildeArrow = new Object();
            this.petModel.CurrentPetFarmGuildeArrow.id = id;
            this.petModel.CurrentPetFarmGuildeArrow.rotation = rotation;
            this.petModel.CurrentPetFarmGuildeArrow.arrowPos = arrowPos;
            this.petModel.CurrentPetFarmGuildeArrow.tip = tip;
            this.petModel.CurrentPetFarmGuildeArrow.tipPos = tipPos;
            this.petModel.CurrentPetFarmGuildeArrow.con = con;
            this.loadPetsGuildeUI(this.showLoadedArrow);
         }
      }
      
      private function setAvailableArrow(arrowID:int) : Boolean
      {
         var items:Vector.<PetFarmGuildeInfo> = null;
         var item:PetFarmGuildeInfo = null;
         for each(items in this.petModel.petGuilde)
         {
            for each(item in items)
            {
               if(item.arrowID == arrowID)
               {
                  item.isFinish = true;
                  this.petModel.nextShowArrowID = item.NextArrowID;
                  this.petModel.preShowArrowID = item.PreArrowID;
                  return true;
               }
            }
         }
         return false;
      }
      
      public function clearCurrentPetFarmGuildeArrow(orderID:int) : void
      {
         NewHandContainer.Instance.clearArrowByID(orderID);
      }
      
      public function haveTaskOrderByID(taskID:int) : Boolean
      {
         return TaskManager.instance.isAvailable(TaskManager.instance.getQuestByID(taskID));
      }
      
      public function isPetFarmGuildeTask(taskID:int) : Boolean
      {
         return this.petModel.petGuilde[taskID];
      }
      
      public function finishTask() : void
      {
         this.petModel.preShowArrowID = 0;
         this.petModel.nextShowArrowID = 0;
      }
      
      private function __petGuildOptionChange(event:CrazyTankSocketEvent) : void
      {
         var pkg:PackageIn = null;
         var optionOnOff:int = 8;
         var isFlag:Boolean = true;
         if(Boolean(event))
         {
            pkg = event.pkg;
            isFlag = pkg.readBoolean();
            optionOnOff = pkg.readInt();
         }
         switch(optionOnOff)
         {
            case 8:
               this.petModel.petGuildeOptionOnOff.add(ArrowType.CHOOSE_PET_SKILL,optionOnOff);
               break;
            case 16:
               this.petModel.petGuildeOptionOnOff.add(ArrowType.USE_PET_SKILL,optionOnOff);
         }
      }
   }
}

