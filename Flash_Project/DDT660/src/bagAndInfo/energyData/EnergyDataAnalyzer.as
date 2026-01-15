package bagAndInfo.energyData
{
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   
   public class EnergyDataAnalyzer extends DataAnalyzer
   {
      
      private var _data:Object;
      
      public function EnergyDataAnalyzer(onCompleteCall:Function)
      {
         super(onCompleteCall);
      }
      
      override public function analyze(data:*) : void
      {
         var xmllist:XMLList = null;
         var i:int = 0;
         var energyData:EnergyData = null;
         var count:int = 0;
         var xml:XML = new XML(data);
         this._data = {};
         if(xml.@value == "true")
         {
            xmllist = xml..Item;
            for(i = 0; i < xmllist.length(); i++)
            {
               energyData = new EnergyData();
               ObjectUtils.copyPorpertiesByXML(energyData,xmllist[i]);
               count = int(xmllist[i].@Count);
               if(!this._data[count])
               {
                  this._data[count] = energyData;
               }
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
      
      public function get data() : Object
      {
         return this._data;
      }
   }
}

