package ddt.data.analyze
{
   import chickActivation.data.ChickActivationInfo;
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   import growthPackage.data.GrowthPackageInfo;
   import guildMemberWeek.data.GuildMemberWeekItemsInfo;
   import guildMemberWeek.manager.GuildMemberWeekManager;
   import horseRace.data.HorseRaceInfo;
   import kingDivision.data.KingDivisionGoodsInfo;
   import newYearRice.data.NewYearRiceInfo;
   import pyramid.data.PyramidSystemItemsInfo;
   import witchBlessing.data.WitchBlessingPackageInfo;
   
   public class ActivitySystemItemsDataAnalyzer extends DataAnalyzer
   {
      
      public var pyramidSystemDataList:Array;
      
      public var guildMemberWeekDataList:Array;
      
      public var growthPackageDataList:Array;
      
      public var kingDivisionDataList:Array;
      
      public var chickActivationDataList:Array;
      
      public var witchBlessingDataList:Array;
      
      public var newYearRiceDataList:Array;
      
      public var horseRaceDataList:Array;
      
      public function ActivitySystemItemsDataAnalyzer(onCompleteCall:Function)
      {
         super(onCompleteCall);
      }
      
      override public function analyze(data:*) : void
      {
         var xmllist:XMLList = null;
         var i:int = 0;
         var itemInfo1:PyramidSystemItemsInfo = null;
         var arr1:Array = null;
         var itemInfo2:GuildMemberWeekItemsInfo = null;
         var arr2:Array = null;
         var itemInfo3:GrowthPackageInfo = null;
         var arr3:Vector.<GrowthPackageInfo> = null;
         var itemInfo4:KingDivisionGoodsInfo = null;
         var arr4:Array = null;
         var itemInfo5:ChickActivationInfo = null;
         var arr5:Array = null;
         var itemInfo6:WitchBlessingPackageInfo = null;
         var arr6:Array = null;
         var itemInfo7:NewYearRiceInfo = null;
         var arr7:Array = null;
         var itemInfo8:HorseRaceInfo = null;
         var arr8:Array = null;
         this.pyramidSystemDataList = [];
         this.guildMemberWeekDataList = [];
         this.growthPackageDataList = [];
         this.kingDivisionDataList = [];
         this.chickActivationDataList = [];
         this.witchBlessingDataList = [];
         this.newYearRiceDataList = [];
         this.horseRaceDataList = [];
         var xml:XML = new XML(data);
         if(xml.@value == "true")
         {
            xmllist = xml..Item;
            for(i = 0; i < xmllist.length(); i++)
            {
               if(xmllist[i].@ActivityType == "8")
               {
                  itemInfo1 = new PyramidSystemItemsInfo();
                  ObjectUtils.copyPorpertiesByXML(itemInfo1,xmllist[i]);
                  arr1 = this.pyramidSystemDataList[itemInfo1.Quality - 1];
                  if(!arr1)
                  {
                     arr1 = [];
                  }
                  arr1.push(itemInfo1);
                  this.pyramidSystemDataList[itemInfo1.Quality - 1] = arr1;
               }
               else if(xmllist[i].@ActivityType == String(GuildMemberWeekManager.instance.getGiftType))
               {
                  itemInfo2 = new GuildMemberWeekItemsInfo();
                  ObjectUtils.copyPorpertiesByXML(itemInfo2,xmllist[i]);
                  arr2 = this.guildMemberWeekDataList[itemInfo2.Quality - 1];
                  if(!arr2)
                  {
                     arr2 = [];
                  }
                  arr2.push(itemInfo2);
                  this.guildMemberWeekDataList[itemInfo2.Quality - 1] = arr2;
               }
               else if(xmllist[i].@ActivityType == "20")
               {
                  itemInfo3 = new GrowthPackageInfo();
                  ObjectUtils.copyPorpertiesByXML(itemInfo3,xmllist[i]);
                  arr3 = this.growthPackageDataList[itemInfo3.Quality];
                  if(!arr3)
                  {
                     arr3 = new Vector.<GrowthPackageInfo>();
                  }
                  arr3.push(itemInfo3);
                  this.growthPackageDataList[itemInfo3.Quality] = arr3;
               }
               else if(xmllist[i].@ActivityType == "30")
               {
                  itemInfo4 = new KingDivisionGoodsInfo();
                  ObjectUtils.copyPorpertiesByXML(itemInfo4,xmllist[i]);
                  arr4 = this.kingDivisionDataList[itemInfo4.Quality - 1];
                  if(!arr4)
                  {
                     arr4 = [];
                  }
                  arr4.push(itemInfo4);
                  this.kingDivisionDataList[itemInfo4.Quality - 1] = arr4;
               }
               else if(xmllist[i].@ActivityType == "40")
               {
                  itemInfo5 = new ChickActivationInfo();
                  ObjectUtils.copyPorpertiesByXML(itemInfo5,xmllist[i]);
                  if(itemInfo5.Quality >= 10001 && itemInfo5.Quality <= 10010)
                  {
                     arr5 = this.chickActivationDataList[12];
                     if(!arr5)
                     {
                        arr5 = new Array();
                     }
                     arr5.push(itemInfo5);
                     arr5.sortOn("Quality",Array.NUMERIC);
                     this.chickActivationDataList[12] = arr5;
                  }
                  else
                  {
                     arr5 = this.chickActivationDataList[itemInfo5.Quality];
                     if(!arr5)
                     {
                        arr5 = new Array();
                     }
                     arr5.push(itemInfo5);
                     this.chickActivationDataList[itemInfo5.Quality] = arr5;
                  }
               }
               else if(xmllist[i].@ActivityType == "49")
               {
                  itemInfo6 = new WitchBlessingPackageInfo();
                  ObjectUtils.copyPorpertiesByXML(itemInfo6,xmllist[i]);
                  if(!arr6)
                  {
                     arr6 = new Array();
                  }
                  arr6.push(itemInfo6);
                  this.witchBlessingDataList = arr6;
               }
               else if(xmllist[i].@ActivityType == "99")
               {
                  itemInfo7 = new NewYearRiceInfo();
                  ObjectUtils.copyPorpertiesByXML(itemInfo7,xmllist[i]);
                  if(!arr7)
                  {
                     arr7 = new Array();
                  }
                  arr7.push(itemInfo7);
                  this.newYearRiceDataList = arr7;
               }
               else if(xmllist[i].@ActivityType == "60")
               {
                  itemInfo8 = new HorseRaceInfo();
                  ObjectUtils.copyPorpertiesByXML(itemInfo8,xmllist[i]);
                  if(!arr8)
                  {
                     arr8 = new Array();
                  }
                  arr8.push(itemInfo8);
                  this.horseRaceDataList = arr8;
               }
            }
            onAnalyzeComplete();
         }
         else
         {
            message = xml.@message;
            onAnalyzeError();
         }
      }
   }
}

