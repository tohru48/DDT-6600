package cardSystem.analyze
{
   import cardSystem.data.SetsUpgradeRuleInfo;
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   
   public class UpgradeRuleAnalyzer extends DataAnalyzer
   {
      
      public var upgradeRuleVec:Vector.<SetsUpgradeRuleInfo>;
      
      public function UpgradeRuleAnalyzer(onCompleteCall:Function)
      {
         super(onCompleteCall);
         this.upgradeRuleVec = new Vector.<SetsUpgradeRuleInfo>();
      }
      
      override public function analyze(data:*) : void
      {
         var xmllist1:XMLList = null;
         var len1:int = 0;
         var i:int = 0;
         var info:SetsUpgradeRuleInfo = null;
         var xml:XML = new XML(data);
         if(xml.@value == "true")
         {
            xmllist1 = xml..Item;
            len1 = int(xmllist1.length());
            for(i = 0; i < len1; i++)
            {
               info = new SetsUpgradeRuleInfo();
               ObjectUtils.copyPorpertiesByXML(info,xmllist1[i]);
               this.upgradeRuleVec.push(info);
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

