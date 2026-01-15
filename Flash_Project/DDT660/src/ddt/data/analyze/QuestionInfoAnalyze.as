package ddt.data.analyze
{
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.QuestionInfo;
   import road7th.data.DictionaryData;
   
   public class QuestionInfoAnalyze extends DataAnalyzer
   {
      
      public var questionList:DictionaryData;
      
      public var allQuestion:Array;
      
      public function QuestionInfoAnalyze(onCompleteCall:Function)
      {
         super(onCompleteCall);
      }
      
      override public function analyze(data:*) : void
      {
         var xmllist:XMLList = null;
         var i:int = 0;
         var info:QuestionInfo = null;
         var xml:XML = new XML(data);
         this.allQuestion = [];
         this.questionList = new DictionaryData();
         if(xml.@value == "true")
         {
            xmllist = xml..Item;
            for(i = 0; i < xmllist.length(); i++)
            {
               info = new QuestionInfo();
               ObjectUtils.copyPorpertiesByXML(info,xmllist[i]);
               if(this.allQuestion[info.QuestionCatalogID] == null)
               {
                  this.allQuestion[info.QuestionCatalogID] = new DictionaryData();
               }
               this.allQuestion[info.QuestionCatalogID].add(info.QuestionID,info);
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

