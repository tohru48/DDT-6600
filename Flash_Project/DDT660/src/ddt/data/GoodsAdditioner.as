package ddt.data
{
   import ddt.data.analyze.GoodsAdditionAnalyer;
   import flash.geom.Point;
   
   public class GoodsAdditioner
   {
      
      private static var _instance:GoodsAdditioner;
      
      private var _additionArr:Array;
      
      public function GoodsAdditioner()
      {
         super();
      }
      
      public static function get Instance() : GoodsAdditioner
      {
         if(_instance == null)
         {
            _instance = new GoodsAdditioner();
         }
         return _instance;
      }
      
      public function addGoodsAddition(analyzer:GoodsAdditionAnalyer) : void
      {
         this._additionArr = analyzer.additionArr;
      }
      
      public function getpropertySuccessRate(ItemCatalog:int, SubCatalog:int, StrengthenLevel:int, FailtureTimes:int) : Point
      {
         if(ItemCatalog != 17)
         {
            SubCatalog = 0;
         }
         StrengthenLevel += 1;
         if(this._additionArr == null)
         {
            return null;
         }
         var p:Point = new Point();
         var arr0:Array = new Array();
         var arr1:Array = new Array();
         arr0 = this._additionArr;
         for(var i:int = 0; i < arr0.length; i++)
         {
            if(arr0[i].ItemCatalog == ItemCatalog)
            {
               arr1.push(arr0[i]);
            }
         }
         arr0 = arr1;
         arr1 = new Array();
         for(i = 0; i < arr0.length; i++)
         {
            if(arr0[i].SubCatalog == SubCatalog)
            {
               arr1.push(arr0[i]);
            }
         }
         arr0 = arr1;
         arr1 = new Array();
         for(i = 0; i < arr0.length; i++)
         {
            if(arr0[i].StrengthenLevel == StrengthenLevel)
            {
               arr1.push(arr0[i]);
            }
         }
         arr0 = arr1;
         arr1 = new Array();
         for(i = 0; i < arr0.length; i++)
         {
            if(arr0[i].FailtureTimes == FailtureTimes)
            {
               p.x = arr0[i].PropertyPlus;
               p.y = arr0[i].SuccessRatePlus;
            }
         }
         return p;
      }
   }
}

