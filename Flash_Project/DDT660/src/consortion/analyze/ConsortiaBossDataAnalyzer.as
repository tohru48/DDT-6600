package consortion.analyze
{
   import com.pickgliss.loader.DataAnalyzer;
   import consortion.data.ConsortiaBossConfigVo;
   
   public class ConsortiaBossDataAnalyzer extends DataAnalyzer
   {
      
      private var _dataList:Array;
      
      public function ConsortiaBossDataAnalyzer(onCompleteCall:Function)
      {
         super(onCompleteCall);
      }
      
      override public function analyze(data:*) : void
      {
         var xmllist:XMLList = null;
         var i:int = 0;
         var info:ConsortiaBossConfigVo = null;
         var xml:XML = new XML(data);
         this._dataList = [];
         if(xml.@value == "true")
         {
            xmllist = xml..item;
            for(i = 0; i < xmllist.length(); i++)
            {
               info = new ConsortiaBossConfigVo();
               info.level = xmllist[i].@Level;
               info.callBossRich = xmllist[i].@CostRich;
               info.extendTimeRich = xmllist[i].@ProlongRich;
               this._dataList.push(info);
            }
            this._dataList.sortOn("level",Array.NUMERIC);
            onAnalyzeComplete();
         }
         else
         {
            message = xml.@message;
            onAnalyzeError();
            onAnalyzeError();
         }
      }
      
      public function get dataList() : Array
      {
         return this._dataList;
      }
   }
}

