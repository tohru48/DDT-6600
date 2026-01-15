package dayActivity
{
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   import dayActivity.data.DayRewaidData;
   
   public class ActivityRewardAnalyzer extends DataAnalyzer
   {
      
      public var itemList:Vector.<DayRewaidData>;
      
      public function ActivityRewardAnalyzer(onCompleteCall:Function)
      {
         super(onCompleteCall);
      }
      
      override public function analyze(data:*) : void
      {
         var itemData:DayRewaidData = null;
         XML.ignoreWhitespace = true;
         this.itemList = new Vector.<DayRewaidData>();
         var xml:XML = new XML(data);
         var len:int = int(xml.item.length());
         var xmllist:XMLList = xml..item;
         for(var i:int = 0; i < xmllist.length(); i++)
         {
            itemData = new DayRewaidData();
            ObjectUtils.copyPorpertiesByXML(itemData,xmllist[i]);
            this.itemList.push(itemData);
         }
         onAnalyzeComplete();
      }
   }
}

