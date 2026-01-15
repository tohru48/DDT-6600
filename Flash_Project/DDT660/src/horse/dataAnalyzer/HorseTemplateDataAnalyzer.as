package horse.dataAnalyzer
{
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   import horse.data.HorseTemplateVo;
   
   public class HorseTemplateDataAnalyzer extends DataAnalyzer
   {
      
      private var _horseTemplateList:Vector.<HorseTemplateVo>;
      
      public function HorseTemplateDataAnalyzer(onCompleteCall:Function)
      {
         super(onCompleteCall);
      }
      
      override public function analyze(data:*) : void
      {
         var xmllist:XMLList = null;
         var i:int = 0;
         var tmpVo:HorseTemplateVo = null;
         var xml:XML = new XML(data);
         this._horseTemplateList = new Vector.<HorseTemplateVo>();
         if(xml.@value == "true")
         {
            xmllist = xml..item;
            for(i = 0; i < xmllist.length(); i++)
            {
               tmpVo = new HorseTemplateVo();
               ObjectUtils.copyPorpertiesByXML(tmpVo,xmllist[i]);
               this._horseTemplateList.push(tmpVo);
            }
            this._horseTemplateList.sort(this.compareFunc);
            onAnalyzeComplete();
         }
         else
         {
            message = xml.@message;
            onAnalyzeError();
            onAnalyzeError();
         }
      }
      
      private function compareFunc(tmpA:HorseTemplateVo, tmpB:HorseTemplateVo) : int
      {
         if(tmpA.Grade > tmpB.Grade)
         {
            return 1;
         }
         if(tmpA.Grade < tmpB.Grade)
         {
            return -1;
         }
         return 0;
      }
      
      public function get horseTemplateList() : Vector.<HorseTemplateVo>
      {
         return this._horseTemplateList;
      }
   }
}

