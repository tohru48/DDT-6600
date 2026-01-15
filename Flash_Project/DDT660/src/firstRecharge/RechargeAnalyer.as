package firstRecharge
{
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   import firstRecharge.info.RechargeData;
   
   public class RechargeAnalyer extends DataAnalyzer
   {
      
      public var goodsList:Vector.<RechargeData>;
      
      public function RechargeAnalyer(onCompleteCall:Function)
      {
         super(onCompleteCall);
      }
      
      override public function analyze(data:*) : void
      {
         var rechargeData:RechargeData = null;
         this.goodsList = new Vector.<RechargeData>();
         var xml:XML = new XML(data);
         var len:int = int(xml.item.length());
         var xmllist:XMLList = xml..item;
         for(var i:int = 0; i < xmllist.length(); i++)
         {
            rechargeData = new RechargeData();
            ObjectUtils.copyPorpertiesByXML(rechargeData,xmllist[i]);
            this.goodsList.push(rechargeData);
         }
         onAnalyzeComplete();
      }
   }
}

