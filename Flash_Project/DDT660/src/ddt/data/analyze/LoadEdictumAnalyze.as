package ddt.data.analyze
{
   import com.pickgliss.loader.DataAnalyzer;
   
   public class LoadEdictumAnalyze extends DataAnalyzer
   {
      
      public var edictumDataList:Array;
      
      public function LoadEdictumAnalyze(onCompleteCall:Function)
      {
         super(onCompleteCall);
      }
      
      override public function analyze(data:*) : void
      {
         var xmllist:XMLList = null;
         var len:int = 0;
         var i:int = 0;
         var item:Object = null;
         this.edictumDataList = [];
         var xml:XML = new XML(data);
         if(xml.@value == "true")
         {
            xmllist = xml..Item;
            len = int(xmllist.length());
            for(i = 0; i < len; i++)
            {
               item = new Object();
               item["id"] = xmllist[i].@ID.toString();
               item["Title"] = xmllist[i].@Title.toString();
               item["Text"] = xmllist[i].@Text.toString();
               item["IsExist"] = xmllist[i].@IsExist.toString();
               item["BeginTime"] = xmllist[i].@BeginTime.toString();
               this.edictumDataList.push(item);
            }
            this.edictumDataList.sortOn("id",Array.NUMERIC);
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

