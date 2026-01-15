package ddt.data.analyze
{
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.BallInfo;
   
   public class BallInfoAnalyzer extends DataAnalyzer
   {
      
      public var list:Vector.<BallInfo>;
      
      public function BallInfoAnalyzer(onCompleteCall:Function)
      {
         super(onCompleteCall);
      }
      
      override public function analyze(data:*) : void
      {
         var xmllist:XMLList = null;
         var i:int = 0;
         var info:BallInfo = null;
         var xml:XML = new XML(data);
         this.list = new Vector.<BallInfo>();
         if(xml.@value == "true")
         {
            xmllist = xml..Item;
            for(i = 0; i < xmllist.length(); i++)
            {
               info = new BallInfo();
               ObjectUtils.copyPorpertiesByXML(info,xmllist[i]);
               info.blastOutID = xmllist[i].@BombPartical;
               info.craterID = xmllist[i].@Crater;
               info.FlyingPartical = xmllist[i].@FlyingPartical;
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

