package halloween.analyze
{
   import com.pickgliss.loader.DataAnalyzer;
   import halloween.info.HalloweenPrizeInfo;
   
   public class HalloweenDataAnalyzer extends DataAnalyzer
   {
      
      public var dataList:Array = new Array();
      
      public function HalloweenDataAnalyzer(onCompleteCall:Function)
      {
         super(onCompleteCall);
      }
      
      override public function analyze(data:*) : void
      {
         var xmllist:XMLList = null;
         var i:int = 0;
         var dataListArr:Array = null;
         var j:int = 0;
         var questinfo:HalloweenPrizeInfo = null;
         var xml:XML = new XML(data);
         if(xml.@value == "true")
         {
            xmllist = xml..items;
            for(i = 0; i < xmllist.length(); i++)
            {
               dataListArr = new Array();
               for(j = 0; j < xmllist[i].item.length(); j++)
               {
                  questinfo = new HalloweenPrizeInfo();
                  questinfo.templateId = xmllist[i].item[j].@templateId;
                  questinfo.count = xmllist[i].item[j].@count;
                  questinfo.validate = xmllist[i].item[j].@validate;
                  questinfo.strenthLevel = xmllist[i].item[j].@strenthLevel;
                  questinfo.attack = xmllist[i].item[j].@attack;
                  questinfo.defend = xmllist[i].item[j].@defend;
                  questinfo.luck = xmllist[i].item[j].@luck;
                  questinfo.agility = xmllist[i].item[j].@agility;
                  questinfo.isBind = xmllist[i].item[j].@isBind;
                  dataListArr.push(questinfo);
               }
               this.dataList.push(dataListArr);
            }
            onAnalyzeComplete();
         }
      }
   }
}

