package battleGroud
{
   import battleGroud.data.BatlleData;
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   
   public class BattleGroundAnalyer extends DataAnalyzer
   {
      
      public var battleDataList:Array;
      
      public function BattleGroundAnalyer(onCompleteCall:Function)
      {
         super(onCompleteCall);
      }
      
      override public function analyze(data:*) : void
      {
         var xmllist:XMLList = null;
         var i:int = 0;
         var rechargeData:BatlleData = null;
         this.battleDataList = [];
         var xml:XML = new XML(data);
         if(xml.@value == "true")
         {
            xmllist = xml..item;
            for(i = 0; i < xmllist.length(); i++)
            {
               rechargeData = new BatlleData();
               ObjectUtils.copyPorpertiesByXML(rechargeData,xmllist[i]);
               this.battleDataList.push(rechargeData);
            }
            this.battleDataList.sortOn("Level",Array.NUMERIC);
            onAnalyzeComplete();
         }
         else
         {
            message = xml.@message;
            onAnalyzeError();
            onAnalyzeError();
         }
      }
   }
}

