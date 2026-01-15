package consortion.analyze
{
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   import consortion.data.ConsortiaApplyInfo;
   
   public class ConsortionApplyListAnalyzer extends DataAnalyzer
   {
      
      public var applyList:Vector.<ConsortiaApplyInfo>;
      
      public var totalCount:int;
      
      public function ConsortionApplyListAnalyzer(onCompleteCall:Function)
      {
         super(onCompleteCall);
      }
      
      override public function analyze(data:*) : void
      {
         var xmllist:XMLList = null;
         var i:int = 0;
         var info:ConsortiaApplyInfo = null;
         this.applyList = new Vector.<ConsortiaApplyInfo>();
         var xml:XML = new XML(data);
         if(xml.@value == "true")
         {
            this.totalCount = int(xml.@total);
            xmllist = XML(xml)..Item;
            for(i = 0; i < xmllist.length(); i++)
            {
               info = new ConsortiaApplyInfo();
               ObjectUtils.copyPorpertiesByXML(info,xmllist[i]);
               info.IsOld = int(xmllist[i].@OldPlayer) == 1;
               this.applyList.push(info);
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

