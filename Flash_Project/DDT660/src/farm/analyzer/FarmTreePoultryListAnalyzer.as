package farm.analyzer
{
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   import farm.modelx.FarmPoultryInfo;
   import flash.utils.Dictionary;
   
   public class FarmTreePoultryListAnalyzer extends DataAnalyzer
   {
      
      public var list:Dictionary = new Dictionary();
      
      public function FarmTreePoultryListAnalyzer(onCompleteCall:Function)
      {
         super(onCompleteCall);
      }
      
      override public function analyze(data:*) : void
      {
         var tmpFoodID:int = 0;
         var item:XML = null;
         var foodList:FarmPoultryInfo = null;
         var xml:XML = XML(data);
         var items:XMLList = xml..item;
         for each(item in items)
         {
            foodList = new FarmPoultryInfo();
            ObjectUtils.copyPorpertiesByXML(foodList,item);
            tmpFoodID = int(item.@Level);
            this.list[tmpFoodID] = foodList;
         }
         onAnalyzeComplete();
      }
   }
}

