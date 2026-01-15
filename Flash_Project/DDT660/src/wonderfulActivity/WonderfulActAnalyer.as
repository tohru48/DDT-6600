package wonderfulActivity
{
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   import wonderfulActivity.data.ActivityTypeData;
   
   public class WonderfulActAnalyer extends DataAnalyzer
   {
      
      public var itemList:Vector.<ActivityTypeData>;
      
      public function WonderfulActAnalyer(onCompleteCall:Function)
      {
         super(onCompleteCall);
      }
      
      override public function analyze(data:*) : void
      {
         var itemData:ActivityTypeData = null;
         this.itemList = new Vector.<ActivityTypeData>();
         var xml:XML = new XML(data);
         var len:int = int(xml.Item.length());
         var xmllist:XMLList = xml.Item;
         for(var i:int = 0; i < xmllist.length(); i++)
         {
            itemData = new ActivityTypeData();
            ObjectUtils.copyPorpertiesByXML(itemData,xmllist[i]);
            this.itemList.push(itemData);
         }
         onAnalyzeComplete();
      }
   }
}

