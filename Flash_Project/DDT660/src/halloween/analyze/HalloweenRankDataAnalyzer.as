package halloween.analyze
{
   import com.pickgliss.loader.DataAnalyzer;
   import halloween.info.HalloweenRankInfo;
   
   public class HalloweenRankDataAnalyzer extends DataAnalyzer
   {
      
      public var dataList:Vector.<HalloweenRankInfo> = new Vector.<HalloweenRankInfo>();
      
      public function HalloweenRankDataAnalyzer(onCompleteCall:Function)
      {
         super(onCompleteCall);
      }
      
      override public function analyze(data:*) : void
      {
         var xmllist:XMLList = null;
         var i:int = 0;
         var questinfo:HalloweenRankInfo = null;
         var xml:XML = new XML(data);
         if(xml.@value == "true")
         {
            xmllist = xml.halloweenInfo;
            for(i = 0; i < xmllist.length(); i++)
            {
               questinfo = new HalloweenRankInfo();
               questinfo.name = xmllist[i].@nickName;
               questinfo.rank = xmllist[i].@rank;
               questinfo.num = xmllist[i].@useNum;
               questinfo.isvip = xmllist[i].@isVIP != "0" ? true : false;
               this.dataList.push(questinfo);
            }
            onAnalyzeComplete();
         }
      }
   }
}

