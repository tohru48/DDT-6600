package tofflist.analyze
{
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   import tofflist.data.RankInfo;
   
   public class RankInfoAnalyz extends DataAnalyzer
   {
      
      private var _xml:XML;
      
      public var info:RankInfo;
      
      public function RankInfoAnalyz(onCompleteCall:Function)
      {
         super(onCompleteCall);
      }
      
      override public function analyze(data:*) : void
      {
         var xmllist:XMLList = null;
         this._xml = new XML(data);
         if(this._xml.@value == "true")
         {
            xmllist = XML(this._xml)..Item;
            this.info = new RankInfo();
            ObjectUtils.copyPorpertiesByXML(this.info,xmllist[0]);
            onAnalyzeComplete();
         }
         else
         {
            message = this._xml.@message;
            onAnalyzeError();
            onAnalyzeComplete();
         }
      }
   }
}

