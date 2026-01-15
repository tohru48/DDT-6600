package eliteGame.analyze
{
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.manager.ItemManager;
   
   public class EliteGameAwardAnalyer extends DataAnalyzer
   {
      
      public var award30_39:Object;
      
      public var award40_60:Object;
      
      public function EliteGameAwardAnalyer(onCompleteCall:Function)
      {
         super(onCompleteCall);
      }
      
      override public function analyze(data:*) : void
      {
         var grade:XMLList = null;
         var i:int = 0;
         var type:XMLList = null;
         var j:int = 0;
         var vec:Vector.<InventoryItemInfo> = null;
         var items:XMLList = null;
         var value:String = null;
         var n:int = 0;
         var itemId:int = 0;
         var inv:InventoryItemInfo = null;
         var tempInfo:ItemTemplateInfo = null;
         this.award30_39 = new Object();
         this.award40_60 = new Object();
         var xml:XML = new XML(data);
         if(xml.@value == "true")
         {
            grade = xml.PlayerGrade;
            for(i = 0; i < grade.length(); i++)
            {
               type = grade[i].prizeType;
               for(j = 0; j < type.length(); j++)
               {
                  vec = new Vector.<InventoryItemInfo>();
                  items = type[j].Item;
                  value = type[j].@value;
                  for(n = 0; n < items.length(); n++)
                  {
                     itemId = parseInt(items[n].@ItemTemplateID);
                     inv = new InventoryItemInfo();
                     tempInfo = ItemManager.Instance.getTemplateById(itemId);
                     ObjectUtils.copyProperties(inv,tempInfo);
                     ObjectUtils.copyPorpertiesByXML(inv,items[n]);
                     inv.BindType = 4;
                     vec.push(inv);
                  }
                  if(grade[i].@value == "1")
                  {
                     this.award30_39[value] = vec;
                  }
                  else
                  {
                     this.award40_60[value] = vec;
                  }
               }
            }
            onAnalyzeComplete();
         }
         else
         {
            message = xml.@message;
            onAnalyzeError();
            onAnalyzeComplete();
         }
      }
   }
}

