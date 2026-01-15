package ddt.data.analyze
{
   import com.pickgliss.loader.DataAnalyzer;
   
   public class GoodsAdditionAnalyer extends DataAnalyzer
   {
      
      private var _xml:XML;
      
      private var _additionArr:Array;
      
      public function GoodsAdditionAnalyer(onCompleteCall:Function)
      {
         super(onCompleteCall);
      }
      
      override public function analyze(data:*) : void
      {
         var i:int = 0;
         var obj:Object = null;
         this._additionArr = new Array();
         this._xml = new XML(data);
         var xmllist:XMLList = this._xml.Item;
         if(this._xml.@value == "true")
         {
            for(i = 0; i < xmllist.length(); i++)
            {
               obj = new Object();
               obj.ItemCatalog = int(xmllist[i].@ItemCatalog);
               obj.SubCatalog = int(xmllist[i].@SubCatalog);
               obj.StrengthenLevel = int(xmllist[i].@StrengthenLevel);
               obj.FailtureTimes = int(xmllist[i].@FailtureTimes);
               obj.PropertyPlus = int(xmllist[i].@PropertyPlus);
               obj.SuccessRatePlus = int(xmllist[i].@SuccessRatePlus);
               this._additionArr.push(obj);
            }
            onAnalyzeComplete();
         }
         else
         {
            message = this._xml.@message;
            onAnalyzeError();
            onAnalyzeComplete();
         }
      }
      
      public function get additionArr() : Array
      {
         return this._additionArr;
      }
   }
}

