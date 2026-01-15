package store.view.fusion
{
   import ddt.data.goods.InventoryItemInfo;
   import flash.events.Event;
   
   public class FusionSelectEvent extends Event
   {
      
      public static const SELL:String = "sell";
      
      public static const NOTSELL:String = "notsell";
      
      private var _sellCount:int;
      
      private var _info:InventoryItemInfo;
      
      public var index:int;
      
      public function FusionSelectEvent(type:String, sellCount:int = 0, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         this._sellCount = sellCount;
         super(type,bubbles,cancelable);
      }
      
      public function get sellCount() : int
      {
         return this._sellCount;
      }
      
      public function get info() : InventoryItemInfo
      {
         return this._info;
      }
      
      public function set info(value:InventoryItemInfo) : void
      {
         this._info = value;
      }
   }
}

