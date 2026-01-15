package petsBag.petsAdvanced
{
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   import petsBag.data.PetsFormData;
   
   public class PetsFormDataAnalyzer extends DataAnalyzer
   {
      
      private var _list:Vector.<PetsFormData>;
      
      public function PetsFormDataAnalyzer(onCompleteCall:Function)
      {
         super(onCompleteCall);
      }
      
      override public function analyze(data:*) : void
      {
         var xmllist:XMLList = null;
         var i:int = 0;
         var info:PetsFormData = null;
         this._list = new Vector.<PetsFormData>();
         var xml:XML = new XML(data);
         if(xml.@value == "true")
         {
            xmllist = xml..item;
            for(i = 0; i < xmllist.length(); i++)
            {
               info = new PetsFormData();
               ObjectUtils.copyPorpertiesByXML(info,xmllist[i]);
               this._list.push(info);
            }
            onAnalyzeComplete();
         }
         else
         {
            message = xml.@message;
            onAnalyzeError();
         }
      }
      
      public function get list() : Vector.<PetsFormData>
      {
         return this._list;
      }
   }
}

