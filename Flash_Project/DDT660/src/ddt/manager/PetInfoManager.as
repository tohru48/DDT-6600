package ddt.manager
{
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.analyze.PetInfoAnalyzer;
   import flash.utils.Dictionary;
   import pet.date.PetInfo;
   import pet.date.PetTemplateInfo;
   
   public class PetInfoManager
   {
      
      private static var _list:Dictionary;
      
      public function PetInfoManager()
      {
         super();
      }
      
      public static function setup(analyzer:PetInfoAnalyzer) : void
      {
         _list = analyzer.list;
      }
      
      public static function getPetByTemplateID(id:int) : PetTemplateInfo
      {
         if(_list == null)
         {
            return null;
         }
         return _list[id];
      }
      
      public static function fillPetInfo(p:PetInfo) : void
      {
         var petTemp:PetTemplateInfo = _list[p.TemplateID];
         ObjectUtils.copyProperties(p,petTemp);
      }
   }
}

