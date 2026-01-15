package ddt.manager
{
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.analyze.PetSkillAnalyzer;
   import flash.utils.Dictionary;
   import pet.date.PetSkill;
   import pet.date.PetSkillTemplateInfo;
   
   public class PetSkillManager
   {
      
      private static var _skills:Dictionary;
      
      public function PetSkillManager()
      {
         super();
      }
      
      public static function setup(analyzer:PetSkillAnalyzer) : void
      {
         _skills = analyzer.list;
      }
      
      public static function getSkillByID(skillID:int) : PetSkillTemplateInfo
      {
         return _skills[skillID];
      }
      
      public static function fillPetSkill(skill:PetSkill) : void
      {
         var s:PetSkillTemplateInfo = getSkillByID(skill.ID);
         if(Boolean(s))
         {
            ObjectUtils.copyProperties(skill,s);
         }
      }
   }
}

