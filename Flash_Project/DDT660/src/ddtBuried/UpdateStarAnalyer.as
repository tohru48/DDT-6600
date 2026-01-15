package ddtBuried
{
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   import ddtBuried.data.UpdateStarData;
   
   public class UpdateStarAnalyer extends DataAnalyzer
   {
      
      public var itemList:Vector.<UpdateStarData>;
      
      public function UpdateStarAnalyer(onCompleteCall:Function)
      {
         super(onCompleteCall);
      }
      
      override public function analyze(data:*) : void
      {
         var itemData:UpdateStarData = null;
         this.itemList = new Vector.<UpdateStarData>();
         var xml:XML = new XML(data);
         var len:int = int(xml.Item.length());
         var xmllist:XMLList = xml.item;
         for(var i:int = 0; i < xmllist.length(); i++)
         {
            itemData = new UpdateStarData();
            ObjectUtils.copyPorpertiesByXML(itemData,xmllist[i]);
            this.itemList.push(itemData);
         }
         onAnalyzeComplete();
      }
   }
}

