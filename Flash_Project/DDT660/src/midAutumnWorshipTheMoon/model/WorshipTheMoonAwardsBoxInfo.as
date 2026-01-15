package midAutumnWorshipTheMoon.model
{
   public class WorshipTheMoonAwardsBoxInfo
   {
      
      public var id:int;
      
      public var moonType:int;
      
      public function WorshipTheMoonAwardsBoxInfo($moonType:int, $id:int)
      {
         super();
         this.moonType = $moonType;
         this.id = $id;
      }
      
      public static function getMoonName(id:int) : String
      {
         switch(id)
         {
            case 1:
               return "Hilal hediye";
            case 2:
               return "Kızıl ay hediye";
            case 3:
               return "Çeyrek ay hediye";
            case 4:
               return "Son çeyrek ay hediye";
            case 5:
               return "Kambur ay hediye";
            case 6:
               return "Dolunay hediye";
            default:
               return "";
         }
      }
      
      public static function getCakeName(id:int) : String
      {
         switch(id)
         {
            case 1:
               return "Hilal hediye paketi";
            case 2:
               return "Kızıl ay hediye paketi";
            case 3:
               return "Çeyrek ay hediye paketi";
            case 4:
               return "Son çeyrek ay hediye paketi";
            case 5:
               return "Kambur ay hediye paketi";
            case 6:
               return "Dolunay hediye paketi";
            default:
               return "";
         }
      }
   }
}

