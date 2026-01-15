package kingDivision.analyze
{
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   import flash.utils.Dictionary;
   import kingDivision.data.KingDivisionAreaNameMessageInfo;
   
   public class AreaNameMessageAnalyze extends DataAnalyzer
   {
      
      public var _listDic:Dictionary;
      
      public function AreaNameMessageAnalyze(onCompleteCall:Function)
      {
         super(onCompleteCall);
      }
      
      override public function analyze(data:*) : void
      {
         var xmllist:XMLList = null;
         var dataArr:Array = null;
         var i:int = 0;
         var dataInfo:KingDivisionAreaNameMessageInfo = null;
         var itemInfo:KingDivisionAreaNameMessageInfo = null;
         var xml:XML = new XML(data);
         if(xml.@value == "true")
         {
            xmllist = xml..Info;
            this._listDic = new Dictionary();
            dataArr = new Array();
            for(i = 0; i < xmllist.length(); i++)
            {
               itemInfo = new KingDivisionAreaNameMessageInfo();
               ObjectUtils.copyPorpertiesByXML(itemInfo,xmllist[i]);
               dataArr.push(itemInfo);
            }
            for each(dataInfo in dataArr)
            {
               if(!this._listDic[dataInfo.AreaID])
               {
                  this._listDic[dataInfo.AreaID] = new Array();
               }
               this._listDic[dataInfo.AreaID].push(dataInfo.AreaName);
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
      
      public function get kingDivisionAreaNameDataDic() : Dictionary
      {
         return this._listDic;
      }
   }
}

