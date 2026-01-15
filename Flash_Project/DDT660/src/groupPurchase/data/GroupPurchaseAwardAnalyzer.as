package groupPurchase.data
{
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   
   public class GroupPurchaseAwardAnalyzer extends DataAnalyzer
   {
      
      private var _awardList:Object;
      
      public function GroupPurchaseAwardAnalyzer(onCompleteCall:Function)
      {
         super(onCompleteCall);
      }
      
      override public function analyze(data:*) : void
      {
         var xmllist:XMLList = null;
         var i:int = 0;
         var awardInfo:GroupPurchaseAwardInfo = null;
         var xml:XML = new XML(data);
         this._awardList = {};
         if(xml.@value == "true")
         {
            xmllist = xml..item;
            for(i = 0; i < xmllist.length(); i++)
            {
               awardInfo = new GroupPurchaseAwardInfo();
               ObjectUtils.copyPorpertiesByXML(awardInfo,xmllist[i]);
               this._awardList[awardInfo.SortID] = awardInfo;
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
      
      public function get awardList() : Object
      {
         return this._awardList;
      }
   }
}

