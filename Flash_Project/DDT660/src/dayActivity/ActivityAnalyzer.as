package dayActivity
{
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   import dayActivity.data.ActivityData;
   
   public class ActivityAnalyzer extends DataAnalyzer
   {
      
      public var itemList:Vector.<ActivityData>;
      
      public function ActivityAnalyzer(onCompleteCall:Function)
      {
         super(onCompleteCall);
      }
      
      override public function analyze(data:*) : void
      {
         var itemData:ActivityData = null;
         this.itemList = new Vector.<ActivityData>();
         XML.ignoreWhitespace = true;
         var xml:XML = new XML(data);
         var len:int = int(xml.item.length());
         var xmllist:XMLList = xml..item;
         for(var i:int = 0; i < xmllist.length(); i++)
         {
            itemData = new ActivityData();
            ObjectUtils.copyPorpertiesByXML(itemData,xmllist[i]);
            this.itemList.push(itemData);
         }
         onAnalyzeComplete();
      }
   }
}

