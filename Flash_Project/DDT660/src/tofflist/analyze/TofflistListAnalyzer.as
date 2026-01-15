package tofflist.analyze
{
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   import flash.utils.describeType;
   import tofflist.data.TofflistConsortiaData;
   import tofflist.data.TofflistConsortiaInfo;
   import tofflist.data.TofflistListData;
   import tofflist.data.TofflistPlayerInfo;
   
   public class TofflistListAnalyzer extends DataAnalyzer
   {
      
      public var data:TofflistListData;
      
      private var _xml:XML;
      
      public function TofflistListAnalyzer(onCompleteCall:Function)
      {
         super(onCompleteCall);
      }
      
      override public function analyze(data:*) : void
      {
         var xmllist:XMLList = null;
         var _tempInfo:TofflistPlayerInfo = null;
         var _xmlInfo:XML = null;
         var i:int = 0;
         var info:TofflistConsortiaData = null;
         var tcInfo:TofflistConsortiaInfo = null;
         var p:TofflistPlayerInfo = null;
         this._xml = new XML(data);
         var list:Array = new Array();
         this.data = new TofflistListData();
         this.data.lastUpdateTime = this._xml.@date;
         if(this._xml.@value == "true")
         {
            xmllist = XML(this._xml)..Item;
            _tempInfo = new TofflistPlayerInfo();
            _xmlInfo = describeType(_tempInfo);
            for(i = 0; i < xmllist.length(); i++)
            {
               info = new TofflistConsortiaData();
               tcInfo = new TofflistConsortiaInfo();
               ObjectUtils.copyPorpertiesByXML(tcInfo,xmllist[i]);
               info.consortiaInfo = tcInfo;
               if(xmllist[i].children().length() > 0)
               {
                  p = new TofflistPlayerInfo();
                  p.beginChanges();
                  ObjectUtils.copyPorpertiesByXML(p,xmllist[i].Item[0]);
                  p.commitChanges();
                  info.playerInfo = p;
                  list.push(info);
               }
            }
            this.data.list = list;
            onAnalyzeComplete();
         }
         else
         {
            message = this._xml.@message;
            onAnalyzeError();
            onAnalyzeComplete();
         }
      }
   }
}

