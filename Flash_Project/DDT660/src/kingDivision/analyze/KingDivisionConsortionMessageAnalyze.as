package kingDivision.analyze
{
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   import kingDivision.data.KingDivisionConsortionMessageInfo;
   
   public class KingDivisionConsortionMessageAnalyze extends DataAnalyzer
   {
      
      public var _list:Array;
      
      public function KingDivisionConsortionMessageAnalyze(onCompleteCall:Function)
      {
         super(onCompleteCall);
      }
      
      override public function analyze(data:*) : void
      {
         var xmllist:XMLList = null;
         var i:int = 0;
         var itemInfo:KingDivisionConsortionMessageInfo = null;
         var xml:XML = new XML(data);
         if(xml.@value == "true")
         {
            xmllist = xml..Info;
            this._list = new Array();
            for(i = 0; i < xmllist.length(); i++)
            {
               itemInfo = new KingDivisionConsortionMessageInfo();
               ObjectUtils.copyPorpertiesByXML(itemInfo,xmllist[i]);
               this._list.push(itemInfo);
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

