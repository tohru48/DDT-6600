package horse.dataAnalyzer
{
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   import horse.data.HorseSkillElementVo;
   import road7th.data.DictionaryData;
   
   public class HorseSkillElementDataAnalyzer extends DataAnalyzer
   {
      
      private var _horseSkillElementList:DictionaryData;
      
      public function HorseSkillElementDataAnalyzer(onCompleteCall:Function)
      {
         super(onCompleteCall);
      }
      
      override public function analyze(data:*) : void
      {
         var xmllist:XMLList = null;
         var i:int = 0;
         var tmpVo:HorseSkillElementVo = null;
         var xml:XML = new XML(data);
         this._horseSkillElementList = new DictionaryData();
         if(xml.@value == "true")
         {
            xmllist = xml..item;
            for(i = 0; i < xmllist.length(); i++)
            {
               tmpVo = new HorseSkillElementVo();
               ObjectUtils.copyPorpertiesByXML(tmpVo,xmllist[i]);
               this._horseSkillElementList.add(tmpVo.ID,tmpVo);
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
      
      public function get horseSkillElementList() : DictionaryData
      {
         return this._horseSkillElementList;
      }
   }
}

