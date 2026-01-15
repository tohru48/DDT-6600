package dayActivity
{
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   import dayActivity.data.DayActiveData;
   
   public class ActivePointAnalzer extends DataAnalyzer
   {
      
      public var itemList:Vector.<DayActiveData>;
      
      public function ActivePointAnalzer(onCompleteCall:Function)
      {
         super(onCompleteCall);
      }
      
      override public function analyze(data:*) : void
      {
         var itemData:DayActiveData = null;
         this.itemList = new Vector.<DayActiveData>();
         XML.ignoreWhitespace = true;
         var xml:XML = new XML(data);
         var len:int = int(xml.item.length());
         var xmllist:XMLList = xml..item;
         for(var i:int = 0; i < xmllist.length(); i++)
         {
            itemData = new DayActiveData();
            ObjectUtils.copyPorpertiesByXML(itemData,xmllist[i]);
            itemData.setLong();
            this.itemList.push(itemData);
         }
         onAnalyzeComplete();
      }
   }
}

