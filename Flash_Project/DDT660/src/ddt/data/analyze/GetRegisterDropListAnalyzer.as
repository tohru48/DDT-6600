package ddt.data.analyze
{
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.RegisterDropInfo;
   
   public class GetRegisterDropListAnalyzer extends DataAnalyzer
   {
      
      public var list:Vector.<RegisterDropInfo>;
      
      public function GetRegisterDropListAnalyzer(onCompleteCall:Function)
      {
         super(onCompleteCall);
      }
      
      override public function analyze(data:*) : void
      {
         var xmllist:XMLList = null;
         var i:int = 0;
         var info:RegisterDropInfo = null;
         var xml:XML = new XML(data);
         if(xml.@value == "true")
         {
            this.list = new Vector.<RegisterDropInfo>();
            xmllist = xml..Item;
            for(i = 0; i < xmllist.length(); i++)
            {
               info = new RegisterDropInfo();
               ObjectUtils.copyPorpertiesByXML(info,xmllist[i]);
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

