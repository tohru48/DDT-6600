package totem.data
{
   import com.pickgliss.loader.DataAnalyzer;
   
   public class HonorUpDataAnalyz extends DataAnalyzer
   {
      
      private var _dataList:Array;
      
      public function HonorUpDataAnalyz(onCompleteCall:Function)
      {
         super(onCompleteCall);
      }
      
      override public function analyze(data:*) : void
      {
         var xmllist:XMLList = null;
         var i:int = 0;
         var info:HonorUpDataVo = null;
         var xml:XML = new XML(data);
         this._dataList = [];
         if(xml.@value == "true")
         {
            xmllist = xml..item;
            for(i = 0; i < xmllist.length(); i++)
            {
               info = new HonorUpDataVo();
               info.index = xmllist[i].@ID;
               info.honor = xmllist[i].@AddHonor;
               info.money = xmllist[i].@NeedMoney;
               this._dataList.push(info);
            }
            this._dataList.sortOn("index",Array.NUMERIC);
            onAnalyzeComplete();
         }
         else
         {
            message = xml.@message;
            onAnalyzeError();
            onAnalyzeError();
         }
      }
      
      public function get dataList() : Array
      {
         return this._dataList;
      }
   }
}

