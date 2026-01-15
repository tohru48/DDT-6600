package pyramid.model
{
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.manager.ItemManager;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import flash.utils.Dictionary;
   import pyramid.data.PyramidSystemItemsInfo;
   import pyramid.event.PyramidEvent;
   
   public class PyramidModel extends EventDispatcher
   {
      
      public var isOpen:Boolean;
      
      public var isScoreExchange:Boolean;
      
      public var turnCardPrice:int;
      
      public var revivePrice:Array;
      
      public var freeCount:int;
      
      public var beginTime:Date;
      
      public var endTime:Date;
      
      public var currentLayer:int;
      
      public var position:int;
      
      public var maxLayer:int;
      
      private var _totalPoint:int;
      
      public var turnPoint:int;
      
      public var pointRatio:int;
      
      public var currentFreeCount:int;
      
      public var currentReviveCount:int;
      
      public var isPyramidStart:Boolean;
      
      public var selectLayerItems:Dictionary;
      
      public var templateID:int;
      
      public var isPyramidDie:Boolean;
      
      public var isUp:Boolean;
      
      public var items:Array;
      
      public function PyramidModel(target:IEventDispatcher = null)
      {
         super(target);
      }
      
      public function getLevelCardItems(level:int) : Array
      {
         return this.items[level - 1];
      }
      
      public function getLevelCardItem(level:int, templateID:int) : PyramidSystemItemsInfo
      {
         var item:PyramidSystemItemsInfo = null;
         var arr:Array = null;
         var temp:PyramidSystemItemsInfo = null;
         if(this.isUp)
         {
            arr = this.items[level - 2];
         }
         else
         {
            arr = this.items[level - 1];
         }
         for(var i:int = 0; i < arr.length; i++)
         {
            temp = arr[i];
            if(temp.TemplateID == templateID)
            {
               item = temp;
               break;
            }
         }
         return item;
      }
      
      public function getInventoryItemInfo(info:PyramidSystemItemsInfo) : InventoryItemInfo
      {
         var tempInfo:ItemTemplateInfo = ItemManager.Instance.getTemplateById(info.TemplateID);
         var tInfo:InventoryItemInfo = new InventoryItemInfo();
         ObjectUtils.copyProperties(tInfo,tempInfo);
         tInfo.LuckCompose = info.TemplateID;
         tInfo.ValidDate = info.ValidDate;
         tInfo.Count = info.Count;
         tInfo.IsBinds = info.IsBind;
         tInfo.StrengthenLevel = info.StrengthLevel;
         tInfo.AttackCompose = info.AttackCompose;
         tInfo.DefendCompose = info.DefendCompose;
         tInfo.AgilityCompose = info.AgilityCompose;
         tInfo.LuckCompose = info.LuckCompose;
         tInfo.isShowBind = false;
         return tInfo;
      }
      
      public function get activityTime() : String
      {
         var minutes1:String = null;
         var minutes2:String = null;
         var dateString:String = "";
         if(Boolean(this.beginTime) && Boolean(this.endTime))
         {
            minutes1 = this.beginTime.minutes > 9 ? this.beginTime.minutes + "" : "0" + this.beginTime.minutes;
            minutes2 = this.endTime.minutes > 9 ? this.endTime.minutes + "" : "0" + this.endTime.minutes;
            dateString = this.beginTime.fullYear + "." + (this.beginTime.month + 1) + "." + this.beginTime.date + " " + this.beginTime.hours + ":" + minutes1 + " - " + this.endTime.fullYear + "." + (this.endTime.month + 1) + "." + this.endTime.date + " " + this.endTime.hours + ":" + minutes2;
         }
         return dateString;
      }
      
      public function get isShuffleMovie() : Boolean
      {
         var obj:Object = null;
         if(this.currentLayer >= 8)
         {
            return false;
         }
         if(!this.isPyramidStart)
         {
            return false;
         }
         if(this.isUp)
         {
            return true;
         }
         var length:int = 0;
         var dic:Dictionary = this.selectLayerItems[this.currentLayer];
         for each(obj in dic)
         {
            length++;
         }
         if(length > 0)
         {
            return false;
         }
         return true;
      }
      
      public function dataChange(_eventType:String, _resultData:Object = null) : void
      {
         dispatchEvent(new PyramidEvent(_eventType,_resultData));
      }
      
      public function set totalPoint(value:int) : void
      {
         this._totalPoint = value;
         dispatchEvent(new PyramidEvent(PyramidEvent.DATA_CHANGE));
      }
      
      public function get totalPoint() : int
      {
         return this._totalPoint;
      }
   }
}

