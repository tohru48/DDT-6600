package ddt.data.analyze
{
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   import flash.utils.Dictionary;
   import pet.date.PetTemplateInfo;
   
   public class PetInfoAnalyzer extends DataAnalyzer
   {
      
      public var list:Dictionary = new Dictionary();
      
      public function PetInfoAnalyzer(onCompleteCall:Function)
      {
         super(onCompleteCall);
      }
      
      override public function analyze(data:*) : void
      {
         var item:XML = null;
         var pInfo:PetTemplateInfo = null;
         var xml:XML = XML(data);
         var items:XMLList = xml..item;
         for each(item in items)
         {
            pInfo = new PetTemplateInfo();
            ObjectUtils.copyPorpertiesByXML(pInfo,item);
            this.list[pInfo.TemplateID] = pInfo;
         }
         onAnalyzeComplete();
      }
   }
}

