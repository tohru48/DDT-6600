package consortion.analyze
{
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   import consortion.data.ConsortionSkillInfo;
   
   public class ConsortionSkillInfoAnalyzer extends DataAnalyzer
   {
      
      public var skillInfoList:Vector.<ConsortionSkillInfo>;
      
      public function ConsortionSkillInfoAnalyzer(onCompleteCall:Function)
      {
         super(onCompleteCall);
      }
      
      override public function analyze(data:*) : void
      {
         var xmllist:XMLList = null;
         var i:int = 0;
         var info:ConsortionSkillInfo = null;
         this.skillInfoList = new Vector.<ConsortionSkillInfo>();
         var xml:XML = new XML(data);
         if(xml.@value == "true")
         {
            xmllist = XML(xml)..Item;
            for(i = 0; i < xmllist.length(); i++)
            {
               info = new ConsortionSkillInfo();
               ObjectUtils.copyPorpertiesByXML(info,xmllist[i]);
               this.skillInfoList.push(info);
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

