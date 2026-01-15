package lottery.data
{
   import com.pickgliss.loader.DataAnalyzer;
   
   public class LotteryWorldWagerAnalyzer extends DataAnalyzer
   {
      
      public var worldWager:Number;
      
      public function LotteryWorldWagerAnalyzer(onCompleteCall:Function)
      {
         super(onCompleteCall);
      }
      
      override public function analyze(data:*) : void
      {
         var xml:XML = new XML(data);
         if(xml.@value == "true")
         {
            this.worldWager = Number(xml.Bonus.@sum);
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

