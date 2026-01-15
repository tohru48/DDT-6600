package farm.analyzer
{
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   import farm.modelx.SuperPetFoodPriceInfo;
   
   public class SuperPetFoodPriceAnalyzer extends DataAnalyzer
   {
      
      public static const Path:String = "PetExpItemPrice.xml";
      
      public var list:Vector.<SuperPetFoodPriceInfo>;
      
      public function SuperPetFoodPriceAnalyzer(onCompleteCall:Function)
      {
         super(onCompleteCall);
      }
      
      override public function analyze(data:*) : void
      {
         var item:XML = null;
         var info:SuperPetFoodPriceInfo = null;
         var xml:XML = XML(data);
         var items:XMLList = xml..Item;
         this.list = new Vector.<SuperPetFoodPriceInfo>();
         for each(item in items)
         {
            info = new SuperPetFoodPriceInfo();
            ObjectUtils.copyPorpertiesByXML(info,item);
            this.list.push(info);
         }
         onAnalyzeComplete();
      }
   }
}

