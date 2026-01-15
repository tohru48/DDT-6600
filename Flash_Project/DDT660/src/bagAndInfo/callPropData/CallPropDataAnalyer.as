package bagAndInfo.callPropData
{
   import bagAndInfo.tips.CallPropTxtTipInfo;
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   
   public class CallPropDataAnalyer extends DataAnalyzer
   {
      
      private var _data:Object;
      
      public function CallPropDataAnalyer(onCompleteCall:Function)
      {
         super(onCompleteCall);
      }
      
      override public function analyze(data:*) : void
      {
         var xmllist:XMLList = null;
         var i:int = 0;
         var callPropData:CallPropTxtTipInfo = null;
         var callName:String = null;
         var xml:XML = new XML(data);
         this._data = {};
         if(xml.@value == "true")
         {
            xmllist = xml..Item;
            for(i = 0; i < xmllist.length(); i++)
            {
               callPropData = new CallPropTxtTipInfo();
               ObjectUtils.copyPorpertiesByXML(callPropData,xmllist[i]);
               callName = xmllist[i].@Rank;
               if(!this._data[callName])
               {
                  this._data[callName] = callPropData;
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

