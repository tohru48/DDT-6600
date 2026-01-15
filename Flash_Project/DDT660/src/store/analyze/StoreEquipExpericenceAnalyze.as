package store.analyze
{
   import com.pickgliss.loader.DataAnalyzer;
   import road7th.data.DictionaryData;
   
   public class StoreEquipExpericenceAnalyze extends DataAnalyzer
   {
      
      public var expericence:Array;
      
      public var necklaceStrengthExpList:DictionaryData;
      
      public var necklaceStrengthPlusList:DictionaryData;
      
      public function StoreEquipExpericenceAnalyze(onCompleteCall:Function)
      {
         super(onCompleteCall);
      }
      
      override public function analyze(data:*) : void
      {
         var xmllist:XMLList = null;
         var i:int = 0;
         var NecklaceStrengthExp:int = 0;
         var necklaceStrengthPlus:int = 0;
         var xml:XML = new XML(data);
         this.expericence = [];
         this.necklaceStrengthExpList = new DictionaryData();
         this.necklaceStrengthPlusList = new DictionaryData();
         if(xml.@value == "true")
         {
            xmllist = xml..item;
            for(i = 0; i < xmllist.length(); i++)
            {
               this.expericence[i] = int(xmllist[i].@Exp);
               NecklaceStrengthExp = int(xmllist[i].@NecklaceStrengthExp);
               necklaceStrengthPlus = int(xmllist[i].@NecklaceStrengthPlus);
               this.necklaceStrengthExpList.add(i,NecklaceStrengthExp);
               this.necklaceStrengthPlusList.add(i,necklaceStrengthPlus);
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

