package rescue.data
{
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   
   public class RescueRewardAnalyzer extends DataAnalyzer
   {
      
      public var list:Array = [];
      
      public function RescueRewardAnalyzer(onCompleteCall:Function)
      {
         super(onCompleteCall);
      }
      
      override public function analyze(data:*) : void
      {
         var item:XML = null;
         var rewardInfo:RescueRewardInfo = null;
         var xml:XML = XML(data);
         var items:XMLList = xml.Item;
         for each(item in items)
         {
            rewardInfo = new RescueRewardInfo();
            ObjectUtils.copyPorpertiesByXML(rewardInfo,item);
            this.list.push(rewardInfo);
         }
         onAnalyzeComplete();
      }
   }
}

