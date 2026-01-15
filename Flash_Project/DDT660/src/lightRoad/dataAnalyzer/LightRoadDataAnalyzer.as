package lightRoad.dataAnalyzer
{
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   import lightRoad.info.LightGiftInfo;
   
   public class LightRoadDataAnalyzer extends DataAnalyzer
   {
      
      public var dataList:Array;
      
      public function LightRoadDataAnalyzer(onCompleteCall:Function)
      {
         super(onCompleteCall);
      }
      
      override public function analyze(data:*) : void
      {
         var xmllist:XMLList = null;
         var i:int = 0;
         var itemInfo:LightGiftInfo = null;
         var xml:XML = new XML(data);
         this.dataList = [];
         if(xml.@value == "true")
         {
            xmllist = xml..Item;
            for(i = 0; i < xmllist.length(); i++)
            {
               itemInfo = new LightGiftInfo();
               ObjectUtils.copyPorpertiesByXML(itemInfo,xmllist[i]);
               this.dataList.push(itemInfo);
            }
            this.onAnalyzeComplete();
         }
         else
         {
            message = xml.@message;
            onAnalyzeError();
         }
      }
      
      override protected function onAnalyzeComplete() : void
      {
         super.onAnalyzeComplete();
      }
   }
}

