package AvatarCollection.data
{
   import com.pickgliss.loader.DataAnalyzer;
   import road7th.data.DictionaryData;
   
   public class AvatarCollectionUnitDataAnalyzer extends DataAnalyzer
   {
      
      private var _maleUnitDic:DictionaryData;
      
      private var _femaleUnitDic:DictionaryData;
      
      public function AvatarCollectionUnitDataAnalyzer(onCompleteCall:Function)
      {
         super(onCompleteCall);
      }
      
      override public function analyze(data:*) : void
      {
         var xmllist:XMLList = null;
         var i:int = 0;
         var tmpVo:AvatarCollectionUnitVo = null;
         var xml:XML = new XML(data);
         this._maleUnitDic = new DictionaryData();
         this._femaleUnitDic = new DictionaryData();
         if(xml.@value == "true")
         {
            xmllist = xml..Item;
            for(i = 0; i < xmllist.length(); i++)
            {
               tmpVo = new AvatarCollectionUnitVo();
               tmpVo.id = xmllist[i].@ID;
               tmpVo.sex = xmllist[i].@Sex;
               tmpVo.name = xmllist[i].@Name;
               tmpVo.Attack = xmllist[i].@Attack;
               tmpVo.Defence = xmllist[i].@Defend;
               tmpVo.Agility = xmllist[i].@Agility;
               tmpVo.Luck = xmllist[i].@Luck;
               tmpVo.Damage = xmllist[i].@Damage;
               tmpVo.Guard = xmllist[i].@Guard;
               tmpVo.Blood = xmllist[i].@Blood;
               tmpVo.needHonor = xmllist[i].@Cost;
               if(tmpVo.sex == 1)
               {
                  this._maleUnitDic.add(tmpVo.id,tmpVo);
               }
               else
               {
                  this._femaleUnitDic.add(tmpVo.id,tmpVo);
               }
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
      
      public function get maleUnitDic() : DictionaryData
      {
         return this._maleUnitDic;
      }
      
      public function get femaleUnitDic() : DictionaryData
      {
         return this._femaleUnitDic;
      }
   }
}

