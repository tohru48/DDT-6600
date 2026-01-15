package consortion.analyze
{
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   import consortion.data.ConsortionPollInfo;
   
   public class ConsortionPollListAnalyzer extends DataAnalyzer
   {
      
      public var pollList:Vector.<ConsortionPollInfo>;
      
      public function ConsortionPollListAnalyzer(onCompleteCall:Function)
      {
         super(onCompleteCall);
      }
      
      override public function analyze(data:*) : void
      {
         var xmllist:XMLList = null;
         var i:int = 0;
         var info:ConsortionPollInfo = null;
         this.pollList = new Vector.<ConsortionPollInfo>();
         var xml:XML = new XML(data);
         if(xml.@value == "true")
         {
            xmllist = XML(xml)..Item;
            for(i = 0; i < xmllist.length(); i++)
            {
               info = new ConsortionPollInfo();
               ObjectUtils.copyPorpertiesByXML(info,xmllist[i]);
               this.pollList.push(info);
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

