package horse.dataAnalyzer
{
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   import horse.data.HorseSkillVo;
   import road7th.data.DictionaryData;
   
   public class HorseSkillDataAnalyzer extends DataAnalyzer
   {
      
      private var _horseSkillList:DictionaryData;
      
      public function HorseSkillDataAnalyzer(onCompleteCall:Function)
      {
         super(onCompleteCall);
      }
      
      override public function analyze(data:*) : void
      {
         var xmllist:XMLList = null;
         var i:int = 0;
         var tmpVo:HorseSkillVo = null;
         var xml:XML = new XML(data);
         this._horseSkillList = new DictionaryData();
         if(xml.@value == "true")
         {
            xmllist = xml..item;
            for(i = 0; i < xmllist.length(); i++)
            {
               tmpVo = new HorseSkillVo();
               ObjectUtils.copyPorpertiesByXML(tmpVo,xmllist[i]);
               this._horseSkillList.add(tmpVo.ID,tmpVo);
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
      
      public function get horseSkillList() : DictionaryData
      {
         return this._horseSkillList;
      }
   }
}

