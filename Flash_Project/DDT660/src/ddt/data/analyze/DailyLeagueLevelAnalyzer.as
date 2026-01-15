package ddt.data.analyze
{
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.DailyLeagueLevelInfo;
   
   public class DailyLeagueLevelAnalyzer extends DataAnalyzer
   {
      
      public var list:Array;
      
      public function DailyLeagueLevelAnalyzer(onCompleteCall:Function)
      {
         super(onCompleteCall);
      }
      
      override public function analyze(data:*) : void
      {
         var xmllist:XMLList = null;
         var i:int = 0;
         var info:DailyLeagueLevelInfo = null;
         var xml:XML = new XML(data);
         this.list = new Array();
         if(xml.@value == "true")
         {
            xmllist = xml..item;
            for(i = 0; i < xmllist.length(); i++)
            {
               info = new DailyLeagueLevelInfo();
               ObjectUtils.copyPorpertiesByXML(info,xmllist[i]);
               this.list.push(info);
            }
            this.list.sortOn("Score",Array.NUMERIC);
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

