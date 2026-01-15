package horse.dataAnalyzer
{
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   import horse.data.HorseSkillGetVo;
   import road7th.data.DictionaryData;
   
   public class HorseSkillGetDataAnalyzer extends DataAnalyzer
   {
      
      private var _horseSkillGetList:DictionaryData;
      
      private var _horseSkillGetIdList:DictionaryData;
      
      public function HorseSkillGetDataAnalyzer(onCompleteCall:Function)
      {
         super(onCompleteCall);
      }
      
      override public function analyze(data:*) : void
      {
         var xmllist:XMLList = null;
         var i:int = 0;
         var tmp:Vector.<HorseSkillGetVo> = null;
         var type:int = 0;
         var tmpVo:HorseSkillGetVo = null;
         var xml:XML = new XML(data);
         this._horseSkillGetList = new DictionaryData();
         this._horseSkillGetIdList = new DictionaryData();
         if(xml.@value == "true")
         {
            xmllist = xml..item;
            for(i = 0; i < xmllist.length(); i++)
            {
               type = int(xmllist[i].@Type);
               if(!this._horseSkillGetList[type])
               {
                  this._horseSkillGetList.add(type,new Vector.<HorseSkillGetVo>());
               }
               tmpVo = new HorseSkillGetVo();
               ObjectUtils.copyPorpertiesByXML(tmpVo,xmllist[i]);
               this._horseSkillGetList[type].push(tmpVo);
               this._horseSkillGetIdList.add(tmpVo.SkillID,tmpVo);
            }
            for each(tmp in this._horseSkillGetList)
            {
               tmp.sort(this.compareFunc);
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
      
      private function compareFunc(tmpA:HorseSkillGetVo, tmpB:HorseSkillGetVo) : int
      {
         if(tmpA.Level > tmpB.Level)
         {
            return 1;
         }
         if(tmpA.Level < tmpB.Level)
         {
            return -1;
         }
         return 0;
      }
      
      public function get horseSkillGetList() : DictionaryData
      {
         return this._horseSkillGetList;
      }
      
      public function get horseSkillGetIdList() : DictionaryData
      {
         return this._horseSkillGetIdList;
      }
   }
}

