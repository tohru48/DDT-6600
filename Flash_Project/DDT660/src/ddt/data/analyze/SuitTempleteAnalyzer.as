package ddt.data.analyze
{
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.SuitTemplateInfo;
   import flash.utils.Dictionary;
   import flash.utils.describeType;
   
   public class SuitTempleteAnalyzer extends DataAnalyzer
   {
      
      private var _list:Dictionary;
      
      public function SuitTempleteAnalyzer(onCompleteCall:Function)
      {
         super(onCompleteCall);
      }
      
      override public function analyze(data:*) : void
      {
         var xmllist:XMLList = null;
         var ecInfo:XML = null;
         var i:int = 0;
         var info:SuitTemplateInfo = null;
         this._list = new Dictionary();
         var xml:XML = new XML(data);
         if(xml.@value == "true")
         {
            xmllist = xml..item;
            ecInfo = describeType(new SuitTemplateInfo());
            for(i = 0; i < xmllist.length(); i++)
            {
               info = new SuitTemplateInfo();
               ObjectUtils.copyPorpertiesByXML(info,xmllist[i]);
               this._list[info.SuitId] = info;
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

