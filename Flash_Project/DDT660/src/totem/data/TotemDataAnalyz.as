package totem.data
{
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   
   public class TotemDataAnalyz extends DataAnalyzer
   {
      
      private var _dataList:Object;
      
      private var _dataList2:Object;
      
      public function TotemDataAnalyz(onCompleteCall:Function)
      {
         super(onCompleteCall);
      }
      
      override public function analyze(data:*) : void
      {
         var xmllist:XMLList = null;
         var i:int = 0;
         var info:TotemDataVo = null;
         this._dataList = {};
         this._dataList2 = {};
         var xml:XML = new XML(data);
         if(xml.@value == "true")
         {
            xmllist = xml..item;
            for(i = 0; i < xmllist.length(); i++)
            {
               info = new TotemDataVo();
               ObjectUtils.copyPorpertiesByXML(info,xmllist[i]);
               this._dataList[info.ID] = info;
               this._dataList2[info.Point] = info;
            }
            onAnalyzeComplete();
         }
         else
         {
            message = xml.@message;
            onAnalyzeError();
            onAnalyzeError();
         }
      }
      
      public function get dataList() : Object
      {
         return this._dataList;
      }
      
      public function get dataList2() : Object
      {
         return this._dataList2;
      }
   }
}

