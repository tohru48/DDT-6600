package ddt.data.analyze
{
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   import petsBag.data.PetMoePropertyInfo;
   
   public class PetMoePropertyAnalyzer extends DataAnalyzer
   {
      
      private var _list:Vector.<PetMoePropertyInfo>;
      
      public function PetMoePropertyAnalyzer(onCompleteCall:Function)
      {
         super(onCompleteCall);
      }
      
      override public function analyze(data:*) : void
      {
         var xmllist:XMLList = null;
         var i:int = 0;
         var info:PetMoePropertyInfo = null;
         this._list = new Vector.<PetMoePropertyInfo>();
         var xml:XML = new XML(data);
         if(xml.@value == "true")
         {
            xmllist = xml..Item;
            for(i = 0; i < xmllist.length(); i++)
            {
               info = new PetMoePropertyInfo();
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
      
      public function get list() : Vector.<PetMoePropertyInfo>
      {
         return this._list;
      }
   }
}

