package ddt.data.analyze
{
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.DailyAwardType;
   import ddt.data.DaylyGiveInfo;
   import flash.utils.Dictionary;
   
   public class DaylyGiveAnalyzer extends DataAnalyzer
   {
      
      public var list:Array;
      
      public var signAwardList:Array;
      
      public var signAwardCounts:Array;
      
      public var userAwardLog:int;
      
      public var awardLen:int;
      
      private var _xml:XML;
      
      private var _awardDic:Dictionary;
      
      public var signPetInfo:Array;
      
      public function DaylyGiveAnalyzer(onCompleteCall:Function)
      {
         super(onCompleteCall);
      }
      
      override public function analyze(data:*) : void
      {
         var xmllist:XMLList = null;
         var i:int = 0;
         var info:DaylyGiveInfo = null;
         this._xml = new XML(data);
         this.list = new Array();
         this.signAwardList = new Array();
         this.signPetInfo = new Array();
         this._awardDic = new Dictionary(true);
         this.signAwardCounts = new Array();
         if(this._xml.@value == "true")
         {
            xmllist = this._xml..Item;
            for(i = 0; i < xmllist.length(); i++)
            {
               if(xmllist[i].@GetWay == DailyAwardType.Normal)
               {
                  info = new DaylyGiveInfo();
                  ObjectUtils.copyPorpertiesByXML(info,xmllist[i]);
                  this.list.push(info);
               }
               else if(xmllist[i].@GetWay == DailyAwardType.Sign)
               {
                  info = new DaylyGiveInfo();
                  ObjectUtils.copyPorpertiesByXML(info,xmllist[i]);
                  this.signAwardList.push(info);
                  if(!this._awardDic[String(xmllist[i].@AwardDays)])
                  {
                     this._awardDic[String(xmllist[i].@AwardDays)] = true;
                     this.signAwardCounts.push(xmllist[i].@AwardDays);
                  }
               }
               else if(xmllist[i].@GetWay == 11)
               {
                  info = new DaylyGiveInfo();
                  ObjectUtils.copyPorpertiesByXML(info,xmllist[i]);
                  this.signPetInfo.push(info);
               }
            }
            onAnalyzeComplete();
         }
         else
         {
            message = this._xml.@message;
            onAnalyzeError();
            onAnalyzeComplete();
         }
      }
   }
}

