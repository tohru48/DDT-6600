package baglocked
{
   import flash.events.Event;
   
   public class SetPassEvent extends Event
   {
      
      public static const CANCELBTN:String = "cancelBtn";
      
      public static const OKBTN:String = "okBtn";
      
      public var data:Object;
      
      public function SetPassEvent(type:String, $data:Object = null, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
         this.data = $data;
      }
   }
}

