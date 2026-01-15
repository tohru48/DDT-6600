package ddtBuried
{
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   import ddtBuried.data.SearchGoodsData;
   
   public class SearchGoodsPayAnalyer extends DataAnalyzer
   {
      
      public var itemList:Vector.<SearchGoodsData>;
      
      public function SearchGoodsPayAnalyer(onCompleteCall:Function)
      {
         super(onCompleteCall);
      }
      
      override public function analyze(data:*) : void
      {
         var itemData:SearchGoodsData = null;
         this.itemList = new Vector.<SearchGoodsData>();
         var xml:XML = new XML(data);
         var xmllist:XMLList = xml.item;
         for(var i:int = 0; i < xmllist.length(); i++)
         {
            itemData = new SearchGoodsData();
            ObjectUtils.copyPorpertiesByXML(itemData,xmllist[i]);
            this.itemList.push(itemData);
         }
         onAnalyzeComplete();
      }
   }
}

