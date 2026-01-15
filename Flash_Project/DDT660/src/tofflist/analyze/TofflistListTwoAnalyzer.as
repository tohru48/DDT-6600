package tofflist.analyze
{
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   import flash.utils.describeType;
   import tofflist.data.TofflistListData;
   import tofflist.data.TofflistPlayerInfo;
   
   public class TofflistListTwoAnalyzer extends DataAnalyzer
   {
      
      private var _xml:XML;
      
      public var data:TofflistListData;
      
      public function TofflistListTwoAnalyzer(onCompleteCall:Function)
      {
         super(onCompleteCall);
      }
      
      override public function analyze(data:*) : void
      {
         var xmllist:XMLList = null;
         var _tempInfo:TofflistPlayerInfo = null;
         var _xmlInfo:XML = null;
         var i:int = 0;
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
               p = new TofflistPlayerInfo();
               p.beginChanges();
               ObjectUtils.copyPorpertiesByXML(p,xmllist[i]);
               p.commitChanges();
               list.push(p);
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

