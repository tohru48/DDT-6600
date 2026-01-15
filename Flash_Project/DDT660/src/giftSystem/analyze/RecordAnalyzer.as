package giftSystem.analyze
{
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   import giftSystem.data.RecordInfo;
   import giftSystem.data.RecordItemInfo;
   
   public class RecordAnalyzer extends DataAnalyzer
   {
      
      private var _info:RecordInfo;
      
      public function RecordAnalyzer(onCompleteCall:Function)
      {
         super(onCompleteCall);
      }
      
      override public function analyze(data:*) : void
      {
         var xmllist:XMLList = null;
         var i:int = 0;
         var itemInfo:RecordItemInfo = null;
         var xml:XML = new XML(data);
         if(xml.@value == "true")
         {
            this._info = new RecordInfo();
            xmllist = xml..Item;
            for(i = 0; i < xmllist.length(); i++)
            {
               itemInfo = new RecordItemInfo();
               ObjectUtils.copyPorpertiesByXML(itemInfo,xmllist[i]);
               this._info.recordList.push(itemInfo);
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
      
      public function get info() : RecordInfo
      {
         return this._info;
      }
   }
}

