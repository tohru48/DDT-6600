package changeColor
{
   import bagAndInfo.cell.BagCell;
   import flash.events.Event;
   
   public class ChangeColorCellEvent extends Event
   {
      
      public static const CLICK:String = "changeColorCellClickEvent";
      
      public static const SETCOLOR:String = "setColor";
      
      private var _data:BagCell;
      
      public function ChangeColorCellEvent(type:String, data:BagCell, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
         this._data = data;
      }
      
      public function get data() : BagCell
      {
         return this._data;
      }
   }
}

