package consortion.analyze
{
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   import consortion.data.ConsortiaAssetLevelOffer;
   
   public class ConsortionBuildingUseConditionAnalyer extends DataAnalyzer
   {
      
      public var useConditionList:Vector.<ConsortiaAssetLevelOffer>;
      
      public function ConsortionBuildingUseConditionAnalyer(onCompleteCall:Function)
      {
         super(onCompleteCall);
      }
      
      override public function analyze(data:*) : void
      {
         var xmllist:XMLList = null;
         var i:int = 0;
         var offer:ConsortiaAssetLevelOffer = null;
         this.useConditionList = new Vector.<ConsortiaAssetLevelOffer>();
         var xml:XML = new XML(data);
         if(xml.@value == "true")
         {
            xmllist = XML(xml)..Item;
            for(i = 0; i < xmllist.length(); i++)
            {
               offer = new ConsortiaAssetLevelOffer();
               ObjectUtils.copyPorpertiesByXML(offer,xmllist[i]);
               this.useConditionList.push(offer);
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

