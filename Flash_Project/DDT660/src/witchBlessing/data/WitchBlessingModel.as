package witchBlessing.data
{
   import com.pickgliss.ui.core.Disposeable;
   import ddt.manager.ServerConfigManager;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   
   public class WitchBlessingModel extends EventDispatcher implements Disposeable
   {
      
      public var isOpen:Boolean = true;
      
      public var totalExp:int = 0;
      
      public var startDate:Date;
      
      public var endDate:Date;
      
      public var lv1GetAwardsTimes:int = 0;
      
      public var lv2GetAwardsTimes:int = 0;
      
      public var lv3GetAwardsTimes:int = 0;
      
      public var lv1CD:int = 0;
      
      public var lv2CD:int = 0;
      
      public var lv3CD:int = 0;
      
      public var isDouble:Boolean = false;
      
      private var _itemInfoList:Array = [];
      
      public var awardslist1:Array = [];
      
      public var awardslist2:Array = [];
      
      public var awardslist3:Array = [];
      
      public var ExpArr:Array = [0];
      
      public var AwardsNums:Array = [];
      
      public var DoubleMoney:Array = [];
      
      public function WitchBlessingModel(target:IEventDispatcher = null)
      {
         super(target);
      }
      
      public function set itemInfoList(arr:Array) : void
      {
         var info:WitchBlessingPackageInfo = null;
         var str:String = null;
         var info1:WitchBlessingInfo = null;
         var strArr:Array = null;
         for(var i:int = 0; i < arr.length; i++)
         {
            info = arr[i];
            if(info.Quality == 1)
            {
               this.awardslist1.push(info);
            }
            else if(info.Quality == 2)
            {
               this.awardslist2.push(info);
            }
            else if(info.Quality == 3)
            {
               this.awardslist3.push(info);
            }
         }
         this._itemInfoList = [this.awardslist1,this.awardslist2,this.awardslist3];
         var obj:Object = ServerConfigManager.instance.serverConfigInfo["WitchBlessConfig"];
         if(Boolean(obj))
         {
            str = obj.Value;
            if(Boolean(str) && str != "")
            {
               info1 = new WitchBlessingInfo();
               strArr = str.split("|");
               info1.ExpArr = (strArr[0] as String).split(",");
               info1.AwardsNums = (strArr[1] as String).split(",");
               info1.DoubleMoney = (strArr[2] as String).split(",");
            }
            this.infoDate = info1;
         }
      }
      
      public function set infoDate(info:WitchBlessingInfo) : void
      {
         var exp:Array = info.ExpArr;
         var tempExp:int = 0;
         for(var i:int = 0; i < exp.length; i++)
         {
            tempExp += int(exp[i]);
            this.ExpArr.push(tempExp);
         }
         this.AwardsNums = info.AwardsNums;
         this.DoubleMoney = info.DoubleMoney;
      }
      
      public function get itemInfoList() : Array
      {
         return this._itemInfoList;
      }
      
      public function get activityTime() : String
      {
         var minutes1:String = null;
         var minutes2:String = null;
         var dateString:String = "";
         if(Boolean(this.startDate) && Boolean(this.endDate))
         {
            minutes1 = this.startDate.minutes > 9 ? this.startDate.minutes + "" : "0" + this.startDate.minutes;
            minutes2 = this.endDate.minutes > 9 ? this.endDate.minutes + "" : "0" + this.endDate.minutes;
            dateString = this.startDate.fullYear + "." + (this.startDate.month + 1) + "." + this.startDate.date + " - " + this.endDate.fullYear + "." + (this.endDate.month + 1) + "." + this.endDate.date;
         }
         return dateString;
      }
      
      public function dispose() : void
      {
      }
   }
}

