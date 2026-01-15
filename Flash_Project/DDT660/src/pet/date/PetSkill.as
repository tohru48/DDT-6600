package pet.date
{
   import ddt.manager.PetSkillManager;
   
   public class PetSkill extends PetSkillTemplateInfo
   {
      
      private var _equiped:Boolean;
      
      public function PetSkill(skillID:int)
      {
         super();
         ID = skillID;
         PetSkillManager.fillPetSkill(this);
      }
      
      public function get Equiped() : Boolean
      {
         return this._equiped;
      }
      
      public function set Equiped(value:Boolean) : void
      {
         this._equiped = value;
      }
   }
}

