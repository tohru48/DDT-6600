package store.newFusion.data
{
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   
   public class FusionNewDataAnalyzer extends DataAnalyzer
   {
      
      private var _data:Object;
      
      public function FusionNewDataAnalyzer(onCompleteCall:Function)
      {
         super(onCompleteCall);
      }
      
      override public function analyze(data:*) : void
      {
         var xmllist:XMLList = null;
         var i:int = 0;
         var tmpVo:FusionNewVo = null;
         var tmpType:int = 0;
         var tmpArray:Array = null;
         var xml:XML = new XML(data);
         this._data = {};
         if(xml.@value == "true")
         {
            xmllist = xml..Item;
            for(i = 0; i < xmllist.length(); i++)
            {
               tmpVo = new FusionNewVo();
               ObjectUtils.copyPorpertiesByXML(tmpVo,xmllist[i]);
               tmpType = int(xmllist[i].@FusionType);
               if(!this._data[tmpType])
               {
                  this._data[tmpType] = [];
               }
               tmpArray = this._data[tmpType];
               tmpArray.push(tmpVo);
            }
            onAnalyzeComplete();
         }
         else
         {
            message = xml.@message;
            onAnalyzeError();
         }
      }
      
      public function get data() : Object
      {
         return this._data;
      }
   }
}

