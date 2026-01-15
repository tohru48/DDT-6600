package ddt.data.goods
{
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.TimeManager;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import road7th.utils.DateUtils;
   
   public class ShopItemInfo extends EventDispatcher
   {
      
      public static const DAY:String = LanguageMgr.GetTranslation("shop.ShopIIShoppingCarItem.day");
      
      public static const AMOUNT:String = LanguageMgr.GetTranslation("ge");
      
      public static const FOREVER:String = LanguageMgr.GetTranslation("shop.ShopIIShoppingCarItem.forever");
      
      public var ShopID:int;
      
      public var GoodsID:int;
      
      public var TemplateID:int;
      
      public var BuyType:int;
      
      public var Sort:int;
      
      public var IsBind:int;
      
      public var Label:int;
      
      public var IsCheap:Boolean;
      
      public var Beat:Number = 1;
      
      public var AUnit:int;
      
      public var APrice1:int;
      
      public var AValue1:int;
      
      public var APrice2:int;
      
      public var AValue2:int;
      
      public var APrice3:int;
      
      public var AValue3:int;
      
      public var BUnit:int;
      
      public var BPrice1:int;
      
      public var BValue1:int;
      
      public var BPrice2:int;
      
      public var BValue2:int;
      
      public var BPrice3:int;
      
      public var BValue3:int;
      
      public var IsContinue:Boolean;
      
      public var CUnit:int;
      
      public var CPrice1:int;
      
      public var CValue1:int;
      
      public var CPrice2:int;
      
      public var CValue2:int;
      
      public var CPrice3:int;
      
      public var CValue3:int;
      
      private var startDate:String;
      
      private var endDate:String;
      
      private var startData_D:Date;
      
      private var endDate_D:Date;
      
      private var _templateInfo:ItemTemplateInfo;
      
      private var _itemPrice:ItemPrice;
      
      private var _count:int = -1;
      
      private var _limitPersonalCount:int = -1;
      
      private var _limitAreaCount:int = -1;
      
      private var _limitGrade:int;
      
      public var isDiscount:int = 1;
      
      public function ShopItemInfo($GoodsID:int, $TemplateID:int)
      {
         super();
         this.GoodsID = $GoodsID;
         this.TemplateID = $TemplateID;
      }
      
      public function get LimitGrade() : int
      {
         return this._limitGrade;
      }
      
      public function set LimitGrade(value:int) : void
      {
         this._limitGrade = value;
      }
      
      public function get isValid() : Boolean
      {
         if(TimeManager.Instance.Now().time < this.endDate_D.time && TimeManager.Instance.Now().time >= this.startData_D.time)
         {
            return true;
         }
         return false;
      }
      
      public function set TemplateInfo(value:ItemTemplateInfo) : void
      {
         this._templateInfo = value;
      }
      
      public function get TemplateInfo() : ItemTemplateInfo
      {
         if(this._templateInfo == null)
         {
            return ItemManager.Instance.getTemplateById(this.TemplateID);
         }
         return this._templateInfo;
      }
      
      public function getItemPrice(index:int) : ItemPrice
      {
         switch(index)
         {
            case 1:
               return new ItemPrice(this.AUnit == -1 ? null : new Price(this.AValue1 * this.Beat,this.APrice1),this.AUnit == -1 ? null : new Price(this.AValue2 * this.Beat,this.APrice2),this.AUnit == -1 ? null : new Price(this.AValue3 * this.Beat,this.APrice3));
            case 2:
               return new ItemPrice(this.BUnit == -1 ? null : new Price(this.BValue1 * this.Beat,this.BPrice1),this.BUnit == -1 ? null : new Price(this.BValue2 * this.Beat,this.BPrice2),this.BUnit == -1 ? null : new Price(this.BValue3 * this.Beat,this.BPrice3));
            case 3:
               return new ItemPrice(this.CUnit == -1 ? null : new Price(this.CValue1 * this.Beat,this.CPrice1),this.CUnit == -1 ? null : new Price(this.CValue2 * this.Beat,this.CPrice2),this.CUnit == -1 ? null : new Price(this.CValue3 * this.Beat,this.CPrice3));
            default:
               return new ItemPrice(new Price(this.AValue1,this.APrice1),new Price(this.AValue2,this.APrice2),new Price(this.AValue3,this.APrice3));
         }
      }
      
      public function getTimeToString(type:int) : String
      {
         switch(type)
         {
            case 1:
               return this.AUnit == 0 ? FOREVER : this.AUnit.toString() + this.buyTypeToString;
            case 2:
               return this.BUnit == 0 ? FOREVER : this.BUnit.toString() + this.buyTypeToString;
            case 3:
               return this.CUnit == 0 ? FOREVER : this.CUnit.toString() + this.buyTypeToString;
            default:
               return "";
         }
      }
      
      public function get buyTypeToString() : String
      {
         if(this.BuyType == 0)
         {
            return DAY;
         }
         return AMOUNT;
      }
      
      public function get LimitCount() : int
      {
         return this._count;
      }
      
      public function set LimitCount(value:int) : void
      {
         if(this._count == value)
         {
            return;
         }
         this._count = value;
         dispatchEvent(new Event(Event.CHANGE));
      }
      
      public function get LimitPersonalCount() : int
      {
         return this._limitPersonalCount;
      }
      
      public function set LimitPersonalCount(value:int) : void
      {
         if(this._limitPersonalCount == value)
         {
            return;
         }
         this._limitPersonalCount = value;
      }
      
      public function set LimitAreaCount(value:int) : void
      {
         if(this._limitAreaCount == value)
         {
            return;
         }
         this._limitAreaCount = value;
      }
      
      public function get LimitAreaCount() : int
      {
         return this._limitAreaCount;
      }
      
      public function get StartDate() : String
      {
         return this.startDate;
      }
      
      public function set StartDate(value:String) : void
      {
         this.startDate = value;
         this.startData_D = DateUtils.decodeDated(this.startDate);
      }
      
      public function get EndDate() : String
      {
         return this.endDate;
      }
      
      public function set EndDate(value:String) : void
      {
         this.endDate = value;
         this.endDate_D = DateUtils.decodeDated(this.endDate);
      }
   }
}

