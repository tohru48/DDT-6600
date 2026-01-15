package gypsyShop.model
{
   public class GypsyItemData
   {
      
      public var id:int;
      
      public var infoID:int;
      
      public var num:int = 0;
      
      public var unit:int = 0;
      
      public var canBuy:int = 0;
      
      public var price:int = 1;
      
      public function GypsyItemData($id:int, $unit:int, $price:int, $infoID:int, $num:int, $canBuy:int)
      {
         super();
         this.id = $id;
         this.unit = $unit;
         this.infoID = $infoID;
         this.num = $num;
         this.price = $price;
         this.canBuy = $canBuy;
      }
   }
}

