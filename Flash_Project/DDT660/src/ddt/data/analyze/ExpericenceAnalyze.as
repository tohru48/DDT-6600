package ddt.data.analyze
{
   import com.pickgliss.loader.DataAnalyzer;
   
   public class ExpericenceAnalyze extends DataAnalyzer
   {
      
      public var expericence:Array;
      
      public var HP:Array;
      
      public function ExpericenceAnalyze(onCompleteCall:Function)
      {
         super(onCompleteCall);
      }
      
      override public function analyze(data:*) : void
      {
         var xmllist:XMLList = null;
         var i:int = 0;
         var xml:XML = new XML(data);
         this.expericence = [];
         this.HP = [];
         if(xml.@value == "true")
         {
            xmllist = xml..Item;
            for(i = 0; i < xmllist.length(); i++)
            {
               this.expericence.push(int(xmllist[i].@GP));
               this.HP.push(int(xmllist[i].@Blood));
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

