package store.events
{
   import flash.events.Event;
   
   public class EmbedEvent extends Event
   {
      
      public static const EMBED:String = "embed";
      
      private var _cellID:int;
      
      public function EmbedEvent(type:String, cellID:int, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
         this._cellID = cellID;
      }
      
      public function get CellID() : int
      {
         return this._cellID;
      }
   }
}

