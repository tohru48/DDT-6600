package ddt.data.goods
{
   import flash.events.Event;
   
   public class ShopCarItemInfo extends ShopItemInfo
   {
      
      private var _currentBuyType:int = 1;
      
      private var _color:String = "";
      
      public var dressing:Boolean;
      
      public var ModelSex:Boolean;
      
      public var colorValue:String = "";
      
      public var place:int;
      
      public var skin:String = "";
      
      public function ShopCarItemInfo(goodsID:int, templateID:int, CategoryID:int = 0)
      {
         super(goodsID,templateID);
         this.currentBuyType = 1;
         if(CategoryID == 14)
         {
            this.currentBuyType = 2;
         }
         this.dressing = false;
      }
      
      public function set Property8(value:String) : void
      {
         super.TemplateInfo.Property8 = value;
         for(var i:int = 0; i < value.length - 1; i++)
         {
            this._color += "|";
         }
      }
      
      public function get Property8() : String
      {
         return super.TemplateInfo.Property8;
      }
      
      public function get CategoryID() : int
      {
         return TemplateInfo.CategoryID;
      }
      
      public function get Color() : String
      {
         return this._color;
      }
      
      public function set Color(value:String) : void
      {
         if(this._color != value)
         {
            this._color = value;
            dispatchEvent(new Event(Event.CHANGE));
         }
      }
      
      public function set currentBuyType(value:int) : void
      {
         this._currentBuyType = value;
         dispatchEvent(new Event(Event.CHANGE));
      }
      
      public function get currentBuyType() : int
      {
         return this._currentBuyType;
      }
      
      public function getCurrentPrice() : ItemPrice
      {
         return getItemPrice(this._currentBuyType);
      }
   }
}

