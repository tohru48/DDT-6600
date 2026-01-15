package cardSystem.analyze
{
   import cardSystem.data.CardPropIncreaseInfo;
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   import road7th.data.DictionaryData;
   
   public class CardPropIncreaseRuleAnalyzer extends DataAnalyzer
   {
      
      private var _levelIncre:DictionaryData;
      
      public var propIncreaseDic:DictionaryData;
      
      public function CardPropIncreaseRuleAnalyzer(onCompleteCall:Function)
      {
         super(onCompleteCall);
         this.propIncreaseDic = new DictionaryData();
      }
      
      override public function analyze(data:*) : void
      {
         var xmlList1:XMLList = null;
         var i:int = 0;
         var info:CardPropIncreaseInfo = null;
         var id:String = null;
         var xml:XML = new XML(data);
         if(xml.@value == "true")
         {
            xmlList1 = xml..Item;
            for(i = 0; i < xmlList1.length(); i++)
            {
               info = new CardPropIncreaseInfo();
               ObjectUtils.copyPorpertiesByXML(info,xmlList1[i]);
               id = xmlList1[i].@Id;
               if(this.propIncreaseDic[id] == null)
               {
                  this.propIncreaseDic[id] = new DictionaryData();
                  this.propIncreaseDic[id].add(info.Level,info);
               }
               else
               {
                  this.propIncreaseDic[id].add(info.Level,info);
               }
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

