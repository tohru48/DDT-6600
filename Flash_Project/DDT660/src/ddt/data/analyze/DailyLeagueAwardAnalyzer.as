package ddt.data.analyze
{
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.DailyLeagueAwardInfo;
   
   public class DailyLeagueAwardAnalyzer extends DataAnalyzer
   {
      
      public var list:Array;
      
      public function DailyLeagueAwardAnalyzer(onCompleteCall:Function)
      {
         super(onCompleteCall);
      }
      
      override public function analyze(data:*) : void
      {
         var xmllist:XMLList = null;
         var i:int = 0;
         var info:DailyLeagueAwardInfo = null;
         var xml:XML = new XML(data);
         this.list = new Array();
         if(xml.@value == "true")
         {
            xmllist = xml..item;
            for(i = 0; i < xmllist.length(); i++)
            {
               info = new DailyLeagueAwardInfo();
               ObjectUtils.copyPorpertiesByXML(info,xmllist[i]);
               this.list.push(info);
            }
            onAnalyzeComplete();
         }
         else
         {
            message = xml.@message;
            onAnalyzeError();
            onAnalyzeComplete();
         }
      }
   }
}

