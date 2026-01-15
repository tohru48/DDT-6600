package cardSystem.analyze
{
   import cardSystem.data.SetsPropertyInfo;
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   import road7th.data.DictionaryData;
   
   public class SetsPropertiesAnalyzer extends DataAnalyzer
   {
      
      public var setsList:DictionaryData;
      
      public function SetsPropertiesAnalyzer(onCompleteCall:Function)
      {
         super(onCompleteCall);
      }
      
      override public function analyze(data:*) : void
      {
         var xmlList1:XMLList = null;
         var i:int = 0;
         var setsId:String = null;
         var setsPropVec:Vector.<SetsPropertyInfo> = null;
         var xmlList2:XMLList = null;
         var j:int = 0;
         var info:SetsPropertyInfo = null;
         this.setsList = new DictionaryData();
         var xml:XML = new XML(data);
         if(xml.@value == "true")
         {
            xmlList1 = xml..Card;
            for(i = 0; i < xmlList1.length(); i++)
            {
               setsId = xmlList1[i].@CardID;
               setsPropVec = new Vector.<SetsPropertyInfo>();
               xmlList2 = xmlList1[i]..Item;
               for(j = 0; j < xmlList2.length(); j++)
               {
                  if(xmlList2[j].@condition != "0")
                  {
                     info = new SetsPropertyInfo();
                     ObjectUtils.copyPorpertiesByXML(info,xmlList2[j]);
                     setsPropVec.push(info);
                  }
               }
               this.setsList.add(setsId,setsPropVec);
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

