package cardSystem.analyze
{
   import cardSystem.data.SetsInfo;
   import com.pickgliss.loader.DataAnalyzer;
   
   public class SetsSortRuleAnalyzer extends DataAnalyzer
   {
      
      public var setsVector:Vector.<SetsInfo>;
      
      public function SetsSortRuleAnalyzer(onCompleteCall:Function)
      {
         super(onCompleteCall);
      }
      
      override public function analyze(data:*) : void
      {
         var xmllist1:XMLList = null;
         var i:int = 0;
         var info:SetsInfo = null;
         var suitID:int = 0;
         var xmlList2:XMLList = null;
         var j:int = 0;
         this.setsVector = new Vector.<SetsInfo>();
         var xml:XML = new XML(data);
         if(xml.@value == "true")
         {
            xmllist1 = xml..Item;
            for(i = 0; i < xmllist1.length(); i++)
            {
               info = new SetsInfo();
               info.ID = xmllist1[i].@ID;
               info.name = xmllist1[i].@Name;
               info.storyDescript = xmllist1[i].@Description;
               suitID = parseInt(xmllist1[i].@SuitID) - 1;
               xmlList2 = xmllist1[i]..Card;
               for(j = 0; j < xmlList2.length(); j++)
               {
                  if(xmlList2[j].@ID != "0")
                  {
                     info.cardIdVec.push(parseInt(xmlList2[j].@ID));
                  }
               }
               this.setsVector.push(info);
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

