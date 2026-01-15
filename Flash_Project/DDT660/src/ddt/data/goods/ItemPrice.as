package ddt.data.goods
{
   import ddt.manager.ItemManager;
   import flash.utils.Dictionary;
   
   public class ItemPrice
   {
      
      private var _prices:Dictionary;
      
      private var _pricesArr:Array;
      
      public function ItemPrice(price1:Price, price2:Price, price3:Price)
      {
         super();
         this._pricesArr = [];
         this._prices = new Dictionary();
         this.addPrice(price1);
         this.addPrice(price2);
         this.addPrice(price3);
      }
      
      public function addPrice(price:Price, bool:Boolean = false, type:int = 0) : void
      {
         if(price == null)
         {
            return;
         }
         this._pricesArr.push(price);
         if(bool)
         {
            price.Unit = -11;
         }
         if(type == 1)
         {
            price.Unit = -1;
         }
         else if(type == 2)
         {
            price.Unit = -11;
         }
         else if(type == 3)
         {
            price.Unit = -2;
         }
         if(this._prices[price.UnitToString] == null)
         {
            this._prices[price.UnitToString] = price.Value;
         }
         else
         {
            this._prices[price.UnitToString] += price.Value;
         }
      }
      
      public function addItemPrice(itemPrice:ItemPrice, bool:Boolean = false, type:int = 0) : void
      {
         var price:Price = null;
         for each(price in itemPrice.pricesArr)
         {
            this.addPrice(price,bool,type);
         }
      }
      
      public function multiply(value:int) : ItemPrice
      {
         if(value <= 0)
         {
            throw new Error("Multiply Invalide value!");
         }
         var result:ItemPrice = this.clone();
         for(var i:int = 0; i < value - 1; i++)
         {
            result.addItemPrice(result.clone());
         }
         return result;
      }
      
      public function clone() : ItemPrice
      {
         return new ItemPrice(this._pricesArr[0],this._pricesArr[1],this._pricesArr[2]);
      }
      
      public function get pricesArr() : Array
      {
         return this._pricesArr;
      }
      
      public function get lightStoneValue() : int
      {
         if(this._prices[Price.LIGHT_STONE_STRING] == null)
         {
            return 0;
         }
         return this._prices[Price.LIGHT_STONE_STRING];
      }
      
      public function get hardCurrencyValue() : int
      {
         if(this._prices[Price.HARD_CURRENCY_TO_STRING] == null)
         {
            return 0;
         }
         return this._prices[Price.HARD_CURRENCY_TO_STRING];
      }
      
      public function get moneyValue() : int
      {
         if(this._prices[Price.MONEYTOSTRING] == null)
         {
            return 0;
         }
         return this._prices[Price.MONEYTOSTRING];
      }
      
      public function get bandDdtMoneyValue() : int
      {
         if(this._prices[Price.NEWDDTMONEYTOSTRING] == null)
         {
            return 0;
         }
         return this._prices[Price.NEWDDTMONEYTOSTRING];
      }
      
      public function get goldValue() : int
      {
         if(this._prices[Price.GOLDTOSTRING] == null)
         {
            return 0;
         }
         return this._prices[Price.GOLDTOSTRING];
      }
      
      public function get gesteValue() : int
      {
         if(this._prices[Price.GESTETOSTRING] == null)
         {
            return 0;
         }
         return this._prices[Price.GESTETOSTRING];
      }
      
      public function get scoreValue() : int
      {
         if(this._prices[Price.SCORETOSTRING] == null)
         {
            return 0;
         }
         return this._prices[Price.SCORETOSTRING];
      }
      
      public function get leagueValue() : int
      {
         if(this._prices[Price.LEAGUESTRING] == null)
         {
            return 0;
         }
         return this._prices[Price.LEAGUESTRING];
      }
      
      public function getOtherValue(unit:int) : int
      {
         var name:String = ItemManager.Instance.getTemplateById(unit).Name;
         if(this._prices[name] == null)
         {
            return 0;
         }
         return this._prices[name];
      }
      
      public function get IsValid() : Boolean
      {
         return this._pricesArr.length > 0;
      }
      
      public function get IsMixed() : Boolean
      {
         var i:String = null;
         var result:int = 0;
         for(i in this._prices)
         {
            if(this._prices[i] > 0)
            {
               result++;
            }
         }
         return result > 1;
      }
      
      public function get PriceType() : int
      {
         if(!this.IsMixed)
         {
            if(this.moneyValue > 0)
            {
               return Price.MONEY;
            }
            if(this.goldValue > 0)
            {
               return Price.GOLD;
            }
            if(this.gesteValue > 0)
            {
               return Price.GESTE;
            }
            if(this.scoreValue > 0)
            {
               return Price.SCORE;
            }
            if(this.bandDdtMoneyValue > 0)
            {
               return Price.DDT_MONEY;
            }
            if(this.hardCurrencyValue > 0)
            {
               return Price.HARD_CURRENCY;
            }
            return -5;
         }
         return 0;
      }
      
      public function get IsMoneyType() : Boolean
      {
         return !this.IsMixed && this.moneyValue > 0;
      }
      
      public function get IsBandDDTMoneyType() : Boolean
      {
         return !this.IsMixed && this.bandDdtMoneyValue > 0;
      }
      
      public function get IsGoldType() : Boolean
      {
         return !this.IsMixed && this.goldValue > 0;
      }
      
      public function get IsGesteType() : Boolean
      {
         return !this.IsMixed && this.gesteValue > 0;
      }
      
      public function toString(bool:Boolean = false) : String
      {
         var i:String = null;
         var result:String = "";
         if(this.moneyValue > 0)
         {
            if(bool)
            {
               result += this.moneyValue.toString() + Price.BANDMONEYTOSTRING;
            }
            else
            {
               result += this.moneyValue.toString() + Price.MONEYTOSTRING;
            }
         }
         if(this.goldValue > 0)
         {
            result += this.goldValue.toString() + Price.GOLDTOSTRING;
         }
         if(this.gesteValue > 0)
         {
            result += this.gesteValue.toString() + Price.GESTETOSTRING;
         }
         if(this.bandDdtMoneyValue > 0)
         {
            result += this.bandDdtMoneyValue.toString() + Price.NEWDDTMONEYTOSTRING;
         }
         if(this.ddtPetScoreValue > 0)
         {
            result += this.ddtPetScoreValue.toString() + Price.PETSCORETOSTRING;
         }
         for(i in this._prices)
         {
            if(i != Price.MONEYTOSTRING && i != Price.GOLDTOSTRING && i != Price.GESTETOSTRING && i != Price.DDTMONEYTOSTRING && i != Price.PETSCORETOSTRING)
            {
               result += this._prices[i].toString() + i;
            }
         }
         return result;
      }
      
      public function toStringI() : String
      {
         var i:String = null;
         var result:String = "";
         if(this.moneyValue > 0)
         {
            result += this.moneyValue.toString() + " " + Price.MONEYTOSTRING;
         }
         if(this.goldValue > 0)
         {
            result += this.goldValue.toString() + " " + Price.GOLDTOSTRING;
         }
         if(this.gesteValue > 0)
         {
            result += this.gesteValue.toString() + " " + Price.GESTETOSTRING;
         }
         if(this.bandDdtMoneyValue > 0)
         {
            result += this.bandDdtMoneyValue.toString() + " " + Price.BANDMONEYTOSTRING;
         }
         for(i in this._prices)
         {
            if(i != Price.MONEYTOSTRING && i != Price.GOLDTOSTRING && i != Price.GESTETOSTRING && i != Price.BANDMONEYTOSTRING)
            {
               result += i;
            }
         }
         return result;
      }
      
      public function get ddtPetScoreValue() : int
      {
         if(this._prices[Price.PETSCORETOSTRING] == null)
         {
            return 0;
         }
         return this._prices[Price.PETSCORETOSTRING];
      }
   }
}

