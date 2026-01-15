package ddt.manager
{
   import ddt.data.analyze.PetAllSkillAnalyzer;
   import flash.utils.Dictionary;
   import pet.date.PetAllSkillTemplateInfo;
   import pet.date.PetTemplateInfo;
   
   public class PetAllSkillManager
   {
      
      private static var _skills:Dictionary;
      
      public function PetAllSkillManager()
      {
         super();
      }
      
      public static function setup(analyzer:PetAllSkillAnalyzer) : void
      {
         _skills = analyzer.list;
      }
      
      public static function getAllSkillByPetTemplateID(petInfo:PetTemplateInfo) : Array
      {
         var petItem:PetAllSkillTemplateInfo = null;
         var resultAllSkills:Array = [];
         for each(petItem in _skills)
         {
            if(petItem.PetTemplateID == petInfo.TemplateID)
            {
               resultAllSkills.push(PetSkillManager.getSkillByID(petItem.SkillID));
            }
            else if(petItem.PetTemplateID == -1 && petItem.KindID == petInfo.KindID)
            {
               resultAllSkills.push(PetSkillManager.getSkillByID(petItem.SkillID));
            }
         }
         return resultAllSkills;
      }
   }
}

