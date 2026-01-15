package ddt.data.analyze
{
   import com.pickgliss.loader.DataAnalyzer;
   import ddt.data.AddPublicInfo;
   
   public class AddPublicTipDataAnalyzer extends DataAnalyzer
   {
      
      public var list:Array = new Array();
      
      public function AddPublicTipDataAnalyzer(onCompleteCall:Function)
      {
         super(onCompleteCall);
      }
      
      override public function analyze(data:*) : void
      {
         var xmllist:XMLList = null;
         var len:int = 0;
         var i:int = 0;
         var info:AddPublicInfo = null;
         var xml:XML = new XML(data);
         if(xml.@value == "true")
         {
            xmllist = xml..Item;
            len = int(xmllist.length());
            for(i = 0; i < len; i++)
            {
               info = new AddPublicInfo();
               info.activityType = xmllist[i].@ActivityType;
               info.quality = xmllist[i].@Quality;
               info.templateID = xmllist[i].@TemplateID;
               info.rate = xmllist[i].@Rate;
               this.list.push(info);
            }
            onAnalyzeComplete();
         }
      }
   }
}

