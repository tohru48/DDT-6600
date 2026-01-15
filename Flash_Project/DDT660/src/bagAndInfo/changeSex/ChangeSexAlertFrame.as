package bagAndInfo.changeSex
{
   import com.pickgliss.ui.controls.alert.SimpleAlert;
   
   public class ChangeSexAlertFrame extends SimpleAlert
   {
      
      private var _bagType:int;
      
      private var _place:int;
      
      public function ChangeSexAlertFrame()
      {
         super();
      }
      
      public function get bagType() : int
      {
         return this._bagType;
      }
      
      public function set bagType(value:int) : void
      {
         this._bagType = value;
      }
      
      public function get place() : int
      {
         return this._place;
      }
      
      public function set place(value:int) : void
      {
         this._place = value;
      }
   }
}

