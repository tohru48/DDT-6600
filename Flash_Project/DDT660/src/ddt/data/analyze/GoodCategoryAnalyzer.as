package ddt.data.analyze
{
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.CateCoryInfo;
   
   public class GoodCategoryAnalyzer extends DataAnalyzer
   {
      
      public var list:Vector.<CateCoryInfo>;
      
      private var _xml:XML;
      
      public function GoodCategoryAnalyzer(onCompleteCall:Function)
      {
         super(onCompleteCall);
      }
      
      override public function analyze(data:*) : void
      {
         var xmllist:XMLList = null;
         var i:int = 0;
         var info:CateCoryInfo = null;
         this._xml = new XML(data);
         if(this._xml.@value == "true")
         {
            this.list = new Vector.<CateCoryInfo>();
            xmllist = this._xml..Item;
            for(i = 0; i < xmllist.length(); i++)
            {
               info = new CateCoryInfo();
               ObjectUtils.copyPorpertiesByXML(info,xmllist[i]);
               this.list.push(info);
            }
            onAnalyzeComplete();
         }
         else
         {
            message = this._xml.@message;
            onAnalyzeError();
         }
      }
   }
}

