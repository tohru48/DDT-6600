package lottery.data
{
   import com.pickgliss.loader.DataAnalyzer;
   import road7th.utils.StringHelper;
   
   public class LotteryResultAnalyzer extends DataAnalyzer
   {
      
      public var lotteryResultList:Vector.<LotteryCardResultVO>;
      
      public function LotteryResultAnalyzer(onCompleteCall:Function)
      {
         super(onCompleteCall);
      }
      
      override public function analyze(data:*) : void
      {
         var xmllist:XMLList = null;
         var j:int = 0;
         var resultVO:LotteryCardResultVO = null;
         var selfXmllist:XMLList = null;
         var selfChoose:Array = null;
         var i:int = 0;
         this.lotteryResultList = new Vector.<LotteryCardResultVO>();
         var xml:XML = new XML(data);
         if(xml.@value == "true")
         {
            xmllist = xml.WealthDivine;
            for(j = 0; j < xmllist.length(); j++)
            {
               resultVO = new LotteryCardResultVO();
               resultVO.resultIds = this.analyzeNumber(String(xmllist[j].@num));
               if(xml.page[j] != null)
               {
                  selfXmllist = xml.page[j].PlayerDivineNum;
                  selfChoose = new Array();
                  for(i = 0; i < selfXmllist.length(); i++)
                  {
                     selfChoose = selfChoose.concat(this.analyzeNumber(String(selfXmllist[i].@num)));
                  }
                  resultVO.selfChooseIds = selfChoose;
                  this.lotteryResultList.push(resultVO);
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
      
      private function analyzeNumber(data:String) : Array
      {
         if(StringHelper.isNullOrEmpty(data))
         {
            return [];
         }
         var arr:Array = data.split(",");
         if(arr.indexOf(0) > -1 || arr.indexOf("0") > -1)
         {
            return [];
         }
         return arr;
      }
   }
}

