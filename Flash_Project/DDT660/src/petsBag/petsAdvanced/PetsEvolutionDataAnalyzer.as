package petsBag.petsAdvanced
{
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   import petsBag.data.PetFightPropertyData;
   
   public class PetsEvolutionDataAnalyzer extends DataAnalyzer
   {
      
      private var _list:Vector.<PetFightPropertyData>;
      
      public function PetsEvolutionDataAnalyzer(onCompleteCall:Function)
      {
         super(onCompleteCall);
      }
      
      override public function analyze(data:*) : void
      {
         var xmllist:XMLList = null;
         var i:int = 0;
         var info:PetFightPropertyData = null;
         this._list = new Vector.<PetFightPropertyData>();
         var xml:XML = new XML(data);
         if(xml.@value == "true")
         {
            xmllist = xml..Item;
            for(i = 0; i < xmllist.length(); i++)
            {
               info = new PetFightPropertyData();
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
      
      public function get list() : Vector.<PetFightPropertyData>
      {
         return this._list;
      }
   }
}

