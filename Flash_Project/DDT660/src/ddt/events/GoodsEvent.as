package ddt.events
{
   import flash.events.Event;
   
   public class GoodsEvent extends Event
   {
      
      public static const PROPERTY_CHANGE:String = "propertyChange";
      
      public var property:String = "";
      
      public var value:*;
      
      public function GoodsEvent(type:String, pro:String = "", va:* = null, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         this.property = pro;
         this.value = va;
         super(type,bubbles,cancelable);
      }
   }
}

