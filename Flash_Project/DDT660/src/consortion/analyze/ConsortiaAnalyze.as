package consortion.analyze
{
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   import consortion.rank.RankData;
   
   public class ConsortiaAnalyze extends DataAnalyzer
   {
      
      private var _dataList:Array;
      
      public function ConsortiaAnalyze(onCompleteCall:Function)
      {
         super(onCompleteCall);
      }
      
      public function get dataList() : Array
      {
         return this._dataList;
      }
      
      override public function analyze(data:*) : void
      {
         var obj:* = undefined;
         var itemData:RankData = null;
         this._dataList = [];
         var xml:XML = new XML(data);
         var xmllist:XMLList = xml.Item;
         for(var i:int = 0; i < xmllist.length(); i++)
         {
            itemData = new RankData();
            ObjectUtils.copyPorpertiesByXML(itemData,xmllist[i]);
            this._dataList.push(itemData);
         }
         this._dataList.sortOn("Rank",Array.NUMERIC);
         for each(obj in this._dataList)
         {
         }
         onAnalyzeComplete();
      }
   }
}

