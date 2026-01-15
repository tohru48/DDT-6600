package oldplayergetticket
{
   import flash.events.Event;
   
   public class GetTicketEvent extends Event
   {
      
      public static const GETTICKET_DATA:String = "getTicket_data";
      
      public var money:int;
      
      public var level:int;
      
      public var levelMoney:int;
      
      public function GetTicketEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
      }
   }
}

