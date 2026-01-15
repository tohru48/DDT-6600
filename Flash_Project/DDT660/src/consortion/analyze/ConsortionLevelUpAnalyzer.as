package consortion.analyze
{
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   import consortion.data.ConsortiaLevelInfo;
   
   public class ConsortionLevelUpAnalyzer extends DataAnalyzer
   {
      
      public var levelUpData:Vector.<ConsortiaLevelInfo>;
      
      public function ConsortionLevelUpAnalyzer(onCompleteCall:Function)
      {
         super(onCompleteCall);
      }
      
      override public function analyze(data:*) : void
      {
         var xmllist:XMLList = null;
         var i:int = 0;
         var info:ConsortiaLevelInfo = null;
         var xml:XML = new XML(data);
         this.levelUpData = new Vector.<ConsortiaLevelInfo>();
         if(xml.@value == "true")
         {
            xmllist = XML(xml)..Item;
            for(i = 0; i < xmllist.length(); i++)
            {
               info = new ConsortiaLevelInfo();
               ObjectUtils.copyPorpertiesByXML(info,xmllist[i]);
               this.levelUpData.push(info);
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

