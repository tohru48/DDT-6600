package store.view.strength.analyzer
{
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   import flash.utils.Dictionary;
   import store.view.strength.vo.ItemStrengthenGoodsInfo;
   
   public class ItemStrengthenGoodsInfoAnalyzer extends DataAnalyzer
   {
      
      public var list:Dictionary = new Dictionary();
      
      private var _xml:XML;
      
      public function ItemStrengthenGoodsInfoAnalyzer(onCompleteCall:Function)
      {
         super(onCompleteCall);
      }
      
      override public function analyze(data:*) : void
      {
         var i:int = 0;
         var itemInfo:ItemStrengthenGoodsInfo = null;
         this._xml = new XML(data);
         this.list = new Dictionary();
         var xmllist:XMLList = this._xml..Item;
         if(this._xml.@value == "true")
         {
            for(i = 0; i < xmllist.length(); i++)
            {
               itemInfo = new ItemStrengthenGoodsInfo();
               ObjectUtils.copyPorpertiesByXML(itemInfo,xmllist[i]);
               this.list[itemInfo.CurrentEquip + "," + itemInfo.Level] = itemInfo;
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
   }
}

