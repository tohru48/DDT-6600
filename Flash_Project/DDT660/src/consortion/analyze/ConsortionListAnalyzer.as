package consortion.analyze
{
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.ConsortiaInfo;
   
   public class ConsortionListAnalyzer extends DataAnalyzer
   {
      
      public var consortionList:Vector.<ConsortiaInfo>;
      
      public var consortionsTotalCount:int;
      
      public function ConsortionListAnalyzer(onCompleteCall:Function)
      {
         super(onCompleteCall);
      }
      
      override public function analyze(data:*) : void
      {
         var xmllist:XMLList = null;
         var i:int = 0;
         var info:ConsortiaInfo = null;
         this.consortionList = new Vector.<ConsortiaInfo>();
         var xmlData:XML = new XML(data);
         if(xmlData.@value == "true")
         {
            this.consortionsTotalCount = int(xmlData.@total);
            xmllist = xmlData..Item;
            for(i = 0; i < xmllist.length(); i++)
            {
               info = new ConsortiaInfo();
               info.beginChanges();
               ObjectUtils.copyPorpertiesByXML(info,xmllist[i]);
               info.commitChanges();
               this.consortionList.push(info);
            }
            onAnalyzeComplete();
         }
         else
         {
            message = xmlData.@message;
            onAnalyzeError();
            onAnalyzeComplete();
         }
      }
   }
}

