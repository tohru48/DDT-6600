package petsBag.petsAdvanced
{
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   import petsBag.data.PetStarExpData;
   
   public class PetsRisingStarDataAnalyzer extends DataAnalyzer
   {
      
      private var _list:Vector.<PetStarExpData>;
      
      public function PetsRisingStarDataAnalyzer(onCompleteCall:Function)
      {
         super(onCompleteCall);
      }
      
      override public function analyze(data:*) : void
      {
         var xmllist:XMLList = null;
         var i:int = 0;
         var info:PetStarExpData = null;
         this._list = new Vector.<PetStarExpData>();
         var xml:XML = new XML(data);
         if(xml.@value == "true")
         {
            xmllist = xml..Item;
            for(i = 0; i < xmllist.length(); i++)
            {
               info = new PetStarExpData();
               ObjectUtils.copyPorpertiesByXML(info,xmllist[i]);
               this._list.push(info);
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
      
      public function get list() : Vector.<PetStarExpData>
      {
         return this._list;
      }
   }
}

