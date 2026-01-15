package labyrinth.data
{
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   
   public class RankingAnalyzer extends DataAnalyzer
   {
      
      public var list:Array;
      
      public function RankingAnalyzer(onCompleteCall:Function)
      {
         super(onCompleteCall);
      }
      
      override public function analyze(data:*) : void
      {
         var info:RankingInfo = null;
         var i:int = 0;
         this.list = [];
         var xml:XML = new XML(data);
         var items:XMLList = xml..Item;
         if(xml.@value == "true")
         {
            for(i = 0; i < items.length(); i++)
            {
               info = new RankingInfo();
               ObjectUtils.copyPorpertiesByXML(info,items[i]);
               this.list.push(info);
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

