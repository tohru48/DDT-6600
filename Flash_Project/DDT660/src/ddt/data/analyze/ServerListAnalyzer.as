package ddt.data.analyze
{
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.ServerInfo;
   
   public class ServerListAnalyzer extends DataAnalyzer
   {
      
      public var list:Vector.<ServerInfo>;
      
      public var agentId:int;
      
      public var zoneName:String;
      
      public function ServerListAnalyzer(onCompleteCall:Function)
      {
         super(onCompleteCall);
      }
      
      override public function analyze(data:*) : void
      {
         var xmllist:XMLList = null;
         var i:int = 0;
         var info:ServerInfo = null;
         var xml:XML = new XML(data);
         if(xml.@value == "true")
         {
            this.agentId = xml.@agentId;
            this.zoneName = xml.@AreaName;
            message = xml.@message;
            xmllist = xml..Item;
            this.list = new Vector.<ServerInfo>();
            if(xmllist.length() > 0)
            {
               for(i = 0; i < xmllist.length(); i++)
               {
                  info = new ServerInfo();
                  ObjectUtils.copyPorpertiesByXML(info,xmllist[i]);
                  this.list.push(info);
               }
               onAnalyzeComplete();
            }
         }
         else
         {
            message = xml.@message;
            onAnalyzeError();
         }
      }
   }
}

