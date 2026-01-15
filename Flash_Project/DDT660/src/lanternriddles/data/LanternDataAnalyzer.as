package lanternriddles.data
{
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   
   public class LanternDataAnalyzer extends DataAnalyzer
   {
      
      private var _data:Object;
      
      public function LanternDataAnalyzer(onCompleteCall:Function)
      {
         super(onCompleteCall);
      }
      
      override public function analyze(data:*) : void
      {
         var xmllist:XMLList = null;
         var i:int = 0;
         var questionData:LanternInfo = null;
         var count:int = 0;
         var xml:XML = new XML(data);
         this._data = {};
         if(xml.@value == "true")
         {
            xmllist = xml..Item;
            for(i = 0; i < xmllist.length(); i++)
            {
               questionData = new LanternInfo();
               ObjectUtils.copyPorpertiesByXML(questionData,xmllist[i]);
               count = int(xmllist[i].@QuestionID);
               if(!this._data[count])
               {
                  this._data[count] = questionData;
               }
            }
            onAnalyzeComplete();
         }
      }
      
      public function get data() : Object
      {
         return this._data;
      }
   }
}

