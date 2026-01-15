package ddt.data.analyze
{
   import calendar.view.goodsExchange.GoodsExchangeInfo;
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   
   public class ActiveExchangeAnalyzer extends DataAnalyzer
   {
      
      private var _list:Array;
      
      private var _xml:XML;
      
      public function ActiveExchangeAnalyzer(onCompleteCall:Function)
      {
         super(onCompleteCall);
      }
      
      override public function analyze(data:*) : void
      {
         var i:int = 0;
         var info:GoodsExchangeInfo = null;
         this._xml = new XML(data);
         this._list = new Array();
         var xmllist:XMLList = this._xml..Item;
         if(this._xml.@value == "true")
         {
            for(i = 0; i < xmllist.length(); i++)
            {
               info = new GoodsExchangeInfo();
               ObjectUtils.copyPorpertiesByXML(info,xmllist[i]);
               this._list.push(info);
            }
            onAnalyzeComplete();
         }
         else
         {
            message = this._xml.@message;
            onAnalyzeError();
            onAnalyzeComplete();
         }
      }
      
      public function get list() : Array
      {
         return this._list.slice(0);
      }
   }
}

