package ddt.data.analyze
{
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   import flash.utils.Dictionary;
   import texpSystem.data.TexpExp;
   
   public class TexpExpAnalyze extends DataAnalyzer
   {
      
      public var list:Dictionary;
      
      public function TexpExpAnalyze(onCompleteCall:Function)
      {
         super(onCompleteCall);
      }
      
      override public function analyze(data:*) : void
      {
         var xmlList:XMLList = null;
         var i:int = 0;
         var texpExp:TexpExp = null;
         var lv:int = 0;
         this.list = new Dictionary();
         var xml:XML = new XML(data);
         message = xml.@message;
         if(xml.@value == "true")
         {
            xmlList = xml..Item;
            for(i = 0; i < xmlList.length(); i++)
            {
               texpExp = new TexpExp();
               ObjectUtils.copyPorpertiesByXML(texpExp,xmlList[i]);
               lv = int(xmlList[i].@Grage);
               this.list[lv] = texpExp;
            }
            onAnalyzeComplete();
         }
         else
         {
            onAnalyzeError();
         }
      }
   }
}

