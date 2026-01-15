package ddt.data.analyze
{
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   import flash.utils.Dictionary;
   import pet.date.PetAllSkillTemplateInfo;
   
   public class PetAllSkillAnalyzer extends DataAnalyzer
   {
      
      public var list:Dictionary = new Dictionary();
      
      public function PetAllSkillAnalyzer(onCompleteCall:Function)
      {
         super(onCompleteCall);
      }
      
      override public function analyze(data:*) : void
      {
         var item:XML = null;
         var skill:PetAllSkillTemplateInfo = null;
         var xml:XML = XML(data);
         var items:XMLList = xml..item;
         for each(item in items)
         {
            skill = new PetAllSkillTemplateInfo();
            ObjectUtils.copyPorpertiesByXML(skill,item);
            this.list[skill.PetTemplateID] = skill;
         }
         onAnalyzeComplete();
      }
   }
}

