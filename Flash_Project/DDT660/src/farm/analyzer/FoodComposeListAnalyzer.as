package farm.analyzer
{
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   import farm.view.compose.vo.FoodComposeListTemplateInfo;
   import flash.utils.Dictionary;
   
   public class FoodComposeListAnalyzer extends DataAnalyzer
   {
      
      public var list:Dictionary = new Dictionary();
      
      private var _listDetail:Vector.<FoodComposeListTemplateInfo>;
      
      public function FoodComposeListAnalyzer(onCompleteCall:Function)
      {
         super(onCompleteCall);
      }
      
      override public function analyze(data:*) : void
      {
         var tmpFoodID:int = 0;
         var item:XML = null;
         var foodList:FoodComposeListTemplateInfo = null;
         var xml:XML = XML(data);
         var items:XMLList = xml..Item;
         for each(item in items)
         {
            foodList = new FoodComposeListTemplateInfo();
            ObjectUtils.copyPorpertiesByXML(foodList,item);
            if(tmpFoodID != foodList.FoodID)
            {
               tmpFoodID = foodList.FoodID;
               this._listDetail = new Vector.<FoodComposeListTemplateInfo>();
               this._listDetail.push(foodList);
            }
            else if(tmpFoodID == foodList.FoodID)
            {
               this._listDetail.push(foodList);
            }
            this.list[tmpFoodID] = this._listDetail;
         }
         onAnalyzeComplete();
      }
   }
}

