package ddt.data.analyze
{
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.map.MapInfo;
   
   public class MapAnalyzer extends DataAnalyzer
   {
      
      public var list:Vector.<MapInfo>;
      
      public function MapAnalyzer(onCompleteCall:Function)
      {
         super(onCompleteCall);
      }
      
      override public function analyze(data:*) : void
      {
         var xmllist:XMLList = null;
         var i:int = 0;
         var info:MapInfo = null;
         var xml:XML = new XML(data);
         this.list = new Vector.<MapInfo>();
         if(xml.@value == "true")
         {
            xmllist = xml..Item;
            for(i = 0; i < xmllist.length(); i++)
            {
               info = new MapInfo();
               ObjectUtils.copyPorpertiesByXML(info,xmllist[i]);
               if(info.Name != "")
               {
                  info.canSelect = info.ID <= 2000;
                  this.list.push(info);
               }
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

