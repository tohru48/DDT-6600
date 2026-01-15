package accumulativeLogin
{
   import accumulativeLogin.data.AccumulativeLoginRewardData;
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   import flash.utils.Dictionary;
   
   public class AccumulativeLoginAnalyer extends DataAnalyzer
   {
      
      private var _accumulativeloginDataDic:Dictionary;
      
      public function AccumulativeLoginAnalyer(onCompleteCall:Function)
      {
         super(onCompleteCall);
         this._accumulativeloginDataDic = new Dictionary();
      }
      
      override public function analyze(data:*) : void
      {
         var xmllist:XMLList = null;
         var dataArr:Array = null;
         var i:int = 0;
         var accData:AccumulativeLoginRewardData = null;
         var rewardData:AccumulativeLoginRewardData = null;
         var xml:XML = new XML(data);
         if(xml.@value == "true")
         {
            xmllist = xml..Item;
            dataArr = new Array();
            for(i = 0; i < xmllist.length(); i++)
            {
               rewardData = new AccumulativeLoginRewardData();
               ObjectUtils.copyPorpertiesByXML(rewardData,xmllist[i]);
               dataArr.push(rewardData);
            }
            for each(accData in dataArr)
            {
               if(!this._accumulativeloginDataDic[accData.Count])
               {
                  this._accumulativeloginDataDic[accData.Count] = new Array();
               }
               this._accumulativeloginDataDic[accData.Count].push(accData);
            }
            onAnalyzeComplete();
         }
         else
         {
            message = xml.@message;
            onAnalyzeError();
            onAnalyzeError();
         }
      }
      
      public function get accumulativeloginDataDic() : Dictionary
      {
         return this._accumulativeloginDataDic;
      }
   }
}

