package dragonBoat.dataAnalyzer
{
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   import dragonBoat.data.DragonBoatActiveInfo;
   import dragonBoat.data.DragonBoatAwardInfo;
   
   public class DragonBoatActiveDataAnalyzer extends DataAnalyzer
   {
      
      private var _data:DragonBoatActiveInfo;
      
      private var _dataList:Array;
      
      private var _dataListSelf:Array;
      
      private var _dataListOther:Array;
      
      public function DragonBoatActiveDataAnalyzer(onCompleteCall:Function)
      {
         super(onCompleteCall);
      }
      
      override public function analyze(data:*) : void
      {
         var xmllist:XMLList = null;
         var i:int = 0;
         var awardInfo:DragonBoatAwardInfo = null;
         var xml:XML = new XML(data);
         this._data = new DragonBoatActiveInfo();
         this._dataList = [];
         this._dataListSelf = [];
         this._dataListOther = [];
         if(xml.@value == "true")
         {
            xmllist = xml..Active;
            i = 0;
            if(i < xmllist.length())
            {
               ObjectUtils.copyPorpertiesByXML(this._data,xmllist[i]);
            }
            xmllist = xml..ActiveExp;
            for(i = 0; i < xmllist.length(); i++)
            {
               if(xmllist[i].@ActiveID == this._data.ActiveID.toString())
               {
                  this._dataList.push(int(xmllist[i].@Exp));
               }
            }
            this._dataList.sort(Array.NUMERIC);
            xmllist = xml..ActiveAward;
            for(i = 0; i < xmllist.length(); i++)
            {
               if(xmllist[i].@ActiveID == this._data.ActiveID.toString())
               {
                  awardInfo = new DragonBoatAwardInfo();
                  ObjectUtils.copyPorpertiesByXML(awardInfo,xmllist[i]);
                  if(xmllist[i].@IsArea == "1")
                  {
                     this._dataListSelf.push(awardInfo);
                  }
                  else
                  {
                     this._dataListOther.push(awardInfo);
                  }
               }
            }
            this._dataListSelf.sortOn("RandID",Array.NUMERIC);
            this._dataListOther.sortOn("RandID",Array.NUMERIC);
            onAnalyzeComplete();
         }
         else
         {
            message = xml.@message;
            onAnalyzeError();
         }
      }
      
      public function get data() : DragonBoatActiveInfo
      {
         return this._data;
      }
      
      public function get dataList() : Array
      {
         return this._dataList;
      }
      
      public function get dataListSelf() : Array
      {
         return this._dataListSelf;
      }
      
      public function get dataListOther() : Array
      {
         return this._dataListOther;
      }
   }
}

