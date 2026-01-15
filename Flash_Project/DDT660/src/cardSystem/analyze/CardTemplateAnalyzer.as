package cardSystem.analyze
{
   import cardSystem.data.CardTemplateInfo;
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   import flash.utils.Dictionary;
   import flash.utils.describeType;
   
   public class CardTemplateAnalyzer extends DataAnalyzer
   {
      
      private var _list:Dictionary;
      
      public function CardTemplateAnalyzer(onCompleteCall:Function)
      {
         super(onCompleteCall);
      }
      
      override public function analyze(data:*) : void
      {
         var xmllist:XMLList = null;
         var ecInfo:XML = null;
         var i:int = 0;
         var info:CardTemplateInfo = null;
         this._list = new Dictionary();
         var xml:XML = new XML(data);
         if(xml.@value == "true")
         {
            xmllist = xml..Item;
            ecInfo = describeType(new CardTemplateInfo());
            for(i = 0; i < xmllist.length(); i++)
            {
               info = new CardTemplateInfo();
               ObjectUtils.copyPorpertiesByXML(info,xmllist[i]);
               this._list[info.CardID + "," + info.CardType] = info;
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
      
      public function get list() : Dictionary
      {
         return this._list;
      }
   }
}

