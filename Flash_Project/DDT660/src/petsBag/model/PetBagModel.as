package petsBag.model
{
   import ddt.data.player.PlayerInfo;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import pet.date.PetInfo;
   import petsBag.data.PetFarmGuildeInfo;
   import petsBag.data.PetFarmGuildeTaskType;
   import petsBag.event.PetsAdvancedEvent;
   import road7th.data.DictionaryData;
   import trainer.data.ArrowType;
   
   public class PetBagModel extends EventDispatcher
   {
      
      private var _currentPetInfo:PetInfo;
      
      private var _currentPlayerInfo:PlayerInfo;
      
      private var _adoptPets:DictionaryData;
      
      private var _eatPetsInfo:DictionaryData;
      
      public var eatPetsLevelUp:Boolean;
      
      private var _adoptItems:DictionaryData;
      
      public var isLoadPetTrainer:Boolean;
      
      public var CurrentPetFarmGuildeArrow:Object;
      
      public var IsFinishTask5:Boolean = false;
      
      private var _petGuildeOptionOnOff:DictionaryData;
      
      private var _petGuilde:DictionaryData;
      
      public var nextShowArrowID:int = 0;
      
      public var preShowArrowID:int = 0;
      
      public function PetBagModel()
      {
         super();
      }
      
      public function get eatPetsInfo() : DictionaryData
      {
         if(this._eatPetsInfo == null)
         {
            this._eatPetsInfo = new DictionaryData();
         }
         return this._eatPetsInfo;
      }
      
      public function set eatPetsInfo(value:DictionaryData) : void
      {
         this._eatPetsInfo = value;
         dispatchEvent(new PetsAdvancedEvent(PetsAdvancedEvent.EAT_PETS_COMPLETE));
      }
      
      public function get adoptPets() : DictionaryData
      {
         if(this._adoptPets == null)
         {
            this._adoptPets = new DictionaryData();
         }
         return this._adoptPets;
      }
      
      public function get adoptItems() : DictionaryData
      {
         if(this._adoptItems == null)
         {
            this._adoptItems = new DictionaryData();
         }
         return this._adoptItems;
      }
      
      public function get currentPlayerInfo() : PlayerInfo
      {
         return this._currentPlayerInfo;
      }
      
      public function set currentPlayerInfo(value:PlayerInfo) : void
      {
         this._currentPlayerInfo = value;
      }
      
      public function get currentPetInfo() : PetInfo
      {
         return this._currentPetInfo;
      }
      
      public function set currentPetInfo(value:PetInfo) : void
      {
         if(value == this._currentPetInfo)
         {
            return;
         }
         this._currentPetInfo = value;
         dispatchEvent(new Event(Event.CHANGE));
      }
      
      public function get petGuildeOptionOnOff() : DictionaryData
      {
         if(!this._petGuildeOptionOnOff)
         {
            this._petGuildeOptionOnOff = new DictionaryData();
            this._petGuildeOptionOnOff.add(ArrowType.CHOOSE_PET_SKILL,0);
            this._petGuildeOptionOnOff.add(ArrowType.USE_PET_SKILL,0);
         }
         return this._petGuildeOptionOnOff;
      }
      
      public function get petGuilde() : DictionaryData
      {
         if(this._petGuilde == null)
         {
            this._petGuilde = new DictionaryData();
            this.initPetGuilde(this._petGuilde);
         }
         return this._petGuilde;
      }
      
      private function initPetGuilde(petTask:DictionaryData) : void
      {
         var petGuildeTaskInfo:PetFarmGuildeInfo = null;
         var petGuildeTaskList:Vector.<PetFarmGuildeInfo> = null;
         petGuildeTaskList = new Vector.<PetFarmGuildeInfo>();
         petGuildeTaskInfo = new PetFarmGuildeInfo();
         petGuildeTaskInfo.arrowID = ArrowType.IN_FARM;
         petGuildeTaskInfo.PreArrowID = 0;
         petGuildeTaskInfo.NextArrowID = ArrowType.OPEN_ADOPT_PET;
         petGuildeTaskList.push(petGuildeTaskInfo);
         petGuildeTaskInfo = new PetFarmGuildeInfo();
         petGuildeTaskInfo.arrowID = ArrowType.OPEN_ADOPT_PET;
         petGuildeTaskInfo.PreArrowID = ArrowType.IN_FARM;
         petGuildeTaskInfo.NextArrowID = ArrowType.SELECT_PET;
         petGuildeTaskList.push(petGuildeTaskInfo);
         petGuildeTaskInfo = new PetFarmGuildeInfo();
         petGuildeTaskInfo.arrowID = ArrowType.SELECT_PET;
         petGuildeTaskInfo.PreArrowID = ArrowType.OPEN_ADOPT_PET;
         petGuildeTaskInfo.NextArrowID = ArrowType.ADOPT_PET;
         petGuildeTaskList.push(petGuildeTaskInfo);
         petGuildeTaskInfo = new PetFarmGuildeInfo();
         petGuildeTaskInfo.arrowID = ArrowType.ADOPT_PET;
         petGuildeTaskInfo.PreArrowID = ArrowType.SELECT_PET;
         petGuildeTaskInfo.NextArrowID = 0;
         petGuildeTaskList.push(petGuildeTaskInfo);
         this._petGuilde.add(PetFarmGuildeTaskType.PET_TASK1,petGuildeTaskList);
         petGuildeTaskInfo = new PetFarmGuildeInfo();
         petGuildeTaskInfo.arrowID = ArrowType.OPEN_PET_BAG;
         petGuildeTaskInfo.PreArrowID = 0;
         petGuildeTaskInfo.NextArrowID = ArrowType.OPEN_PET_LABEL;
         petGuildeTaskList.push(petGuildeTaskInfo);
         petGuildeTaskInfo = new PetFarmGuildeInfo();
         petGuildeTaskInfo.arrowID = ArrowType.OPEN_PET_LABEL;
         petGuildeTaskInfo.PreArrowID = ArrowType.OPEN_PET_BAG;
         petGuildeTaskInfo.NextArrowID = ArrowType.FEED_PET;
         petGuildeTaskList.push(petGuildeTaskInfo);
         petGuildeTaskInfo = new PetFarmGuildeInfo();
         petGuildeTaskInfo.arrowID = ArrowType.FEED_PET;
         petGuildeTaskInfo.PreArrowID = ArrowType.OPEN_PET_LABEL;
         petGuildeTaskInfo.NextArrowID = 0;
         petGuildeTaskList.push(petGuildeTaskInfo);
         this._petGuilde.add(PetFarmGuildeTaskType.PET_TASK2,petGuildeTaskList);
         petGuildeTaskInfo = new PetFarmGuildeInfo();
         petGuildeTaskInfo.arrowID = ArrowType.JOIN_GAME;
         petGuildeTaskInfo.PreArrowID = 0;
         petGuildeTaskInfo.NextArrowID = 0;
         petGuildeTaskList.push(petGuildeTaskInfo);
         this._petGuilde.add(PetFarmGuildeTaskType.PET_TASK3,petGuildeTaskList);
         petGuildeTaskInfo = new PetFarmGuildeInfo();
         petGuildeTaskInfo.arrowID = ArrowType.PLANT_IN_FRAME;
         petGuildeTaskInfo.PreArrowID = 0;
         petGuildeTaskInfo.NextArrowID = ArrowType.OPEN_SEED_BAG;
         petGuildeTaskList.push(petGuildeTaskInfo);
         petGuildeTaskInfo = new PetFarmGuildeInfo();
         petGuildeTaskInfo.arrowID = ArrowType.OPEN_SEED_BAG;
         petGuildeTaskInfo.PreArrowID = ArrowType.PLANT_IN_FRAME;
         petGuildeTaskInfo.NextArrowID = ArrowType.CLICK_SEEDING_BTN;
         petGuildeTaskList.push(petGuildeTaskInfo);
         petGuildeTaskInfo = new PetFarmGuildeInfo();
         petGuildeTaskInfo.arrowID = ArrowType.CLICK_SEEDING_BTN;
         petGuildeTaskInfo.PreArrowID = ArrowType.OPEN_SEED_BAG;
         petGuildeTaskInfo.NextArrowID = ArrowType.CHOOSE_SEED;
         petGuildeTaskList.push(petGuildeTaskInfo);
         petGuildeTaskInfo = new PetFarmGuildeInfo();
         petGuildeTaskInfo.arrowID = ArrowType.CHOOSE_SEED;
         petGuildeTaskInfo.PreArrowID = ArrowType.CLICK_SEEDING_BTN;
         petGuildeTaskInfo.NextArrowID = ArrowType.SEEDING;
         petGuildeTaskList.push(petGuildeTaskInfo);
         petGuildeTaskInfo = new PetFarmGuildeInfo();
         petGuildeTaskInfo.arrowID = ArrowType.SEEDING;
         petGuildeTaskInfo.PreArrowID = ArrowType.CHOOSE_SEED;
         petGuildeTaskInfo.NextArrowID = 0;
         petGuildeTaskList.push(petGuildeTaskInfo);
         this._petGuilde.add(PetFarmGuildeTaskType.PET_TASK4,petGuildeTaskList);
         petGuildeTaskInfo = new PetFarmGuildeInfo();
         petGuildeTaskInfo.arrowID = ArrowType.GRAIN_IN_FRAME;
         petGuildeTaskInfo.PreArrowID = 0;
         petGuildeTaskInfo.NextArrowID = ArrowType.GAINS;
         petGuildeTaskList.push(petGuildeTaskInfo);
         petGuildeTaskInfo = new PetFarmGuildeInfo();
         petGuildeTaskInfo.arrowID = ArrowType.GAINS;
         petGuildeTaskInfo.PreArrowID = ArrowType.GRAIN_IN_FRAME;
         petGuildeTaskInfo.NextArrowID = 0;
         petGuildeTaskList.push(petGuildeTaskInfo);
         this._petGuilde.add(PetFarmGuildeTaskType.PET_TASK5,petGuildeTaskList);
         petGuildeTaskInfo = new PetFarmGuildeInfo();
         petGuildeTaskInfo.arrowID = ArrowType.OPEN_IM;
         petGuildeTaskInfo.PreArrowID = 0;
         petGuildeTaskInfo.NextArrowID = 0;
         petGuildeTaskList.push(petGuildeTaskInfo);
         this._petGuilde.add(PetFarmGuildeTaskType.PET_TASK6,petGuildeTaskList);
      }
   }
}

