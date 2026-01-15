package ddt.data.analyze
{
   import com.pickgliss.loader.DataAnalyzer;
   
   public class MovingNotificationAnalyzer extends DataAnalyzer
   {
      
      public var list:Array = [];
      
      public function MovingNotificationAnalyzer(onCompleteCall:Function)
      {
         super(onCompleteCall);
      }
      
      override public function analyze(data:*) : void
      {
         this.list = String(data).split("\r\n");
         for(var i:int = 0; i < this.list.length; i++)
         {
            this.list[i] = this.list[i].replace("\\r","\r");
            this.list[i] = this.list[i].replace("\\n","\n");
         }
         onAnalyzeComplete();
      }
   }
}

