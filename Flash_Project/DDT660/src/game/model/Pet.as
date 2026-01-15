package game.model
{
   import ddt.events.LivingEvent;
   import flash.events.EventDispatcher;
   import flash.utils.Dictionary;
   import pet.date.PetInfo;
   
   public class Pet extends EventDispatcher
   {
      
      private var _MP:int;
      
      private var _maxMP:int = 100;
      
      private var _petInfo:PetInfo;
      
      private var _petBeatInfo:Dictionary = new Dictionary();
      
      public function Pet(petInfo:PetInfo)
      {
         super();
         this._petInfo = petInfo;
      }
      
      public function get petInfo() : PetInfo
      {
         return this._petInfo;
      }
      
      public function get MP() : int
      {
         return this._MP;
      }
      
      public function set MP(value:int) : void
      {
         if(value == this._MP)
         {
            return;
         }
         this._MP = value;
         dispatchEvent(new LivingEvent(LivingEvent.PET_MP_CHANGE));
      }
      
      public function get MaxMP() : int
      {
         return this._maxMP;
      }
      
      public function set MaxMP(value:int) : void
      {
         this._maxMP = value;
      }
      
      public function get equipedSkillIDs() : Array
      {
         return this._petInfo.equipdSkills.list;
      }
      
      public function useSkill(skillID:int, isUsed:Boolean) : void
      {
         dispatchEvent(new LivingEvent(LivingEvent.USE_PET_SKILL,skillID));
      }
      
      public function get petBeatInfo() : Dictionary
      {
         return this._petBeatInfo;
      }
   }
}

