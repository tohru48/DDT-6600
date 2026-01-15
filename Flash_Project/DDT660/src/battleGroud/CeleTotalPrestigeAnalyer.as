package battleGroud
{
   import battleGroud.data.BattlPrestigeData;
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   
   public class CeleTotalPrestigeAnalyer extends DataAnalyzer
   {
      
      public var battleDataList:Vector.<BattlPrestigeData>;
      
      public function CeleTotalPrestigeAnalyer(onCompleteCall:Function)
      {
         super(onCompleteCall);
      }
      
      override public function analyze(data:*) : void
      {
         var battleData:BattlPrestigeData = null;
         this.battleDataList = new Vector.<BattlPrestigeData>();
         var xml:XML = new XML(data);
         var len:int = int(xml.item.length());
         var xmllist:XMLList = xml..Item;
         for(var i:int = 0; i < xmllist.length(); i++)
         {
            battleData = new BattlPrestigeData();
            battleData.Numbers = i + 1;
            ObjectUtils.copyPorpertiesByXML(battleData,xmllist[i]);
            this.battleDataList.push(battleData);
         }
         onAnalyzeComplete();
      }
   }
}

