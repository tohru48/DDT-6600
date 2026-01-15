package ddt.data.analyze
{
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   import pet.date.PetConfigInfo;
   
   public class PetconfigAnalyzer extends DataAnalyzer
   {
      
      public static var PetCofnig:PetConfigInfo = new PetConfigInfo();
      
      public function PetconfigAnalyzer(onCompleteCall:Function)
      {
         super(onCompleteCall);
      }
      
      override public function analyze(data:*) : void
      {
         var item:XML = null;
         var xml:XML = XML(data);
         var items:XMLList = xml..item;
         for each(item in items)
         {
            ObjectUtils.copyPorpertiesByXML(PetCofnig,item);
         }
         onAnalyzeComplete();
      }
   }
}

