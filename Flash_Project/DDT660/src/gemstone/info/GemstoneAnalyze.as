package gemstone.info
{
   import com.pickgliss.loader.DataAnalyzer;
   
   public class GemstoneAnalyze extends DataAnalyzer
   {
      
      public var gInfoList:Vector.<GemstoneStaticInfo>;
      
      public function GemstoneAnalyze(onCompleteCall:Function)
      {
         super(onCompleteCall);
      }
      
      override public function analyze(data:*) : void
      {
         var gInfo:GemstoneStaticInfo = null;
         this.gInfoList = new Vector.<GemstoneStaticInfo>();
         var xml:XML = new XML(data);
         var len:int = int(xml.item.length());
         for(var i:int = 0; i < len; i++)
         {
            gInfo = new GemstoneStaticInfo();
            gInfo.fightSpiritIcon = xml.item.@FightSpiritID;
            gInfo.fightSpiritIcon = xml.item.@FightSpiritIcon;
            gInfo.agility = xml.item.@agility;
            gInfo.level = xml.item.@level;
            gInfo.luck = xml.item.@luck;
            gInfo.Exp = xml.item.@Exp;
            gInfo.attack = xml.item.@attack;
            gInfo.defence = xml.item.@defence;
            this.gInfoList.push(gInfo);
         }
      }
   }
}

