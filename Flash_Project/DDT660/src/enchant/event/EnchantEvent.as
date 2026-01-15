package enchant.event
{
   import ddt.data.goods.InventoryItemInfo;
   import flash.events.Event;
   
   public class EnchantEvent extends Event
   {
      
      public static const UPDATE_PROGRESS:String = "update_progress";
      
      public var info:InventoryItemInfo;
      
      public var isUpGrade:Boolean;
      
      public function EnchantEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
      }
   }
}

