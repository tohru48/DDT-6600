package ddt.data.analyze
{
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   import flash.utils.Dictionary;
   import pet.date.PetSkillTemplateInfo;
   
   public class PetSkillAnalyzer extends DataAnalyzer
   {
      
      public var list:Dictionary = new Dictionary();
      
      public function PetSkillAnalyzer(onCompleteCall:Function)
      {
         super(onCompleteCall);
      }
      
      override public function analyze(data:*) : void
      {
         var item:XML = null;
         var skill:PetSkillTemplateInfo = null;
         var xml:XML = XML(data);
         var items:XMLList = xml..item;
         for each(item in items)
         {
            skill = new PetSkillTemplateInfo();
            ObjectUtils.copyPorpertiesByXML(skill,item);
            this.list[skill.ID] = skill;
         }
         onAnalyzeComplete();
      }
   }
}

