package GodSyah
{
   import com.pickgliss.loader.DataAnalyzer;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.manager.ItemManager;
   
   public class SyahAnalyzer extends DataAnalyzer
   {
      
      private var _details:Array;
      
      private var _modes:Vector.<SyahMode>;
      
      private var _infos:Vector.<InventoryItemInfo>;
      
      private var _nowTime:Date;
      
      private var _syahArr:Array;
      
      private var _detailsArr:Array;
      
      private var _modeArr:Array;
      
      public function SyahAnalyzer(onCompleteCall:Function)
      {
         super(onCompleteCall);
      }
      
      override public function analyze(data:*) : void
      {
         var xmllist:XMLList = null;
         var j:int = 0;
         var details:Array = null;
         var i:int = 0;
         var mode:SyahMode = null;
         var info:InventoryItemInfo = null;
         var xml:XML = new XML(data);
         this._nowTime = this._getEndTime(xml.@nowTime,xml.@nowTime);
         if(xml.@value == "true")
         {
            this._details = new Array();
            this._modes = new Vector.<SyahMode>();
            this._infos = new Vector.<InventoryItemInfo>();
            this._syahArr = new Array();
            this._detailsArr = new Array();
            this._modeArr = new Array();
            xmllist = xml..Condition;
            for(j = 0; j < xml.child("Active").length(); j++)
            {
               this._detailsArr[j] = new Vector.<InventoryItemInfo>();
               this._modeArr[j] = new Vector.<SyahMode>();
               details = new Array();
               details[0] = xml.child("Active")[j].@IsOpen;
               details[1] = this._createValid(xml.child("Active")[j].@StartDate,xml.child("Active")[j].@EndDate);
               details[2] = xml.child("Active")[j].@ActiveInfo;
               details[3] = this._getEndTime(xml.child("Active")[j].@StartDate,xml.child("Active")[j].@StartTime);
               details[4] = this._getEndTime(xml.child("Active")[j].@EndDate,xml.child("Active")[j].@EndTime);
               details[5] = xml.child("Active")[j].@SubID;
               this._syahArr[j] = details;
               for(i = 0; i < xmllist.length(); i++)
               {
                  if(xml.child("Active")[j].@SubID == xmllist[i].@SubID)
                  {
                     mode = this._createModeValue(xmllist[i].@Value);
                     mode.syahID = xmllist[i].@ConditionID;
                     mode.level = mode.isGold ? int(xmllist[i].@Type - 100) : int(xmllist[i].@Type);
                     mode.valid = this._createValid(xml.child("Active")[j].@StartDate,xml.child("Active")[j].@EndDate);
                     this._modeArr[j].push(mode);
                     info = new InventoryItemInfo();
                     info.TemplateID = mode.syahID;
                     info = ItemManager.fill(info);
                     info.StrengthenLevel = mode.level;
                     info.isGold = mode.isGold;
                     this._detailsArr[j].push(info);
                  }
               }
            }
            onAnalyzeComplete();
         }
         else
         {
            message = xml.@message;
            onAnalyzeComplete();
         }
      }
      
      private function _createModeValue(s:String) : SyahMode
      {
         var arr:Array = s.split("-");
         var mode:SyahMode = new SyahMode();
         for(var i:int = 0; i < arr.length; i += 2)
         {
            switch(arr[i])
            {
               case "1":
                  mode.attack = arr[i + 1];
                  break;
               case "2":
                  mode.defense = arr[i + 1];
                  break;
               case "3":
                  mode.agility = arr[i + 1];
                  break;
               case "4":
                  mode.lucky = arr[i + 1];
                  break;
               case "5":
                  mode.hp = arr[i + 1];
                  break;
               case "6":
                  mode.damage = arr[i + 1];
                  break;
               case "7":
                  mode.armor = arr[i + 1];
                  break;
               case "11":
                  mode.isGold = arr[i + 1] == 1 ? true : false;
                  break;
            }
         }
         return mode;
      }
      
      private function _createValid(sd:String, ed:String) : String
      {
         return sd.split(" ")[0].replace("-",".").replace("-",".") + "-" + ed.split(" ")[0].replace("-",".").replace("-",".");
      }
      
      private function _getEndTime(ed:String, et:String) : Date
      {
         var arr1:Array = ed.split(" ")[0].split("-");
         var end:String = arr1[1] + "/" + arr1[2] + "/" + arr1[0] + " " + et.split(" ")[1];
         return new Date(end);
      }
      
      public function get modes() : Array
      {
         return this._modeArr;
      }
      
      public function get details() : Array
      {
         return this._syahArr;
      }
      
      public function get infos() : Array
      {
         return this._detailsArr;
      }
      
      public function get nowTime() : Date
      {
         return this._nowTime;
      }
   }
}

