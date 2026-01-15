package ddt.data.analyze
{
   import com.pickgliss.loader.DataAnalyzer;
   
   public class PetExpericenceAnalyze extends DataAnalyzer
   {
      
      public var expericence:Array;
      
      public function PetExpericenceAnalyze(onCompleteCall:Function)
      {
         super(onCompleteCall);
      }
      
      override public function analyze(data:*) : void
      {
         var xmllist:XMLList = null;
         var i:int = 0;
         var xml:XML = new XML(data);
         this.expericence = [];
         if(xml.@value == "true")
         {
            xmllist = xml..item;
            for(i = 0; i < xmllist.length(); i++)
            {
               this.expericence.push(int(xmllist[i].@GP));
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

