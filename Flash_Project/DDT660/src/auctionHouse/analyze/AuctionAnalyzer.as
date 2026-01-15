package auctionHouse.analyze
{
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.auctionHouse.AuctionGoodsInfo;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.manager.ItemManager;
   
   public class AuctionAnalyzer extends DataAnalyzer
   {
      
      public var list:Vector.<AuctionGoodsInfo>;
      
      public var total:int;
      
      public function AuctionAnalyzer(onCompleteCall:Function)
      {
         super(onCompleteCall);
      }
      
      override public function analyze(data:*) : void
      {
         var i:int = 0;
         var info:AuctionGoodsInfo = null;
         var xmllistII:XMLList = null;
         var bagInfo:InventoryItemInfo = null;
         this.list = new Vector.<AuctionGoodsInfo>();
         var xml:XML = new XML(data);
         var xmllist:XMLList = xml.Item;
         this.total = xml.@total;
         if(xml.@value == "true")
         {
            for(i = 0; i < xmllist.length(); i++)
            {
               info = new AuctionGoodsInfo();
               ObjectUtils.copyPorpertiesByXML(info,xmllist[i]);
               xmllistII = xmllist[i].Item;
               if(xmllistII.length() > 0)
               {
                  bagInfo = new InventoryItemInfo();
                  ObjectUtils.copyPorpertiesByXML(bagInfo,xmllistII[0]);
                  ItemManager.fill(bagInfo);
                  info.BagItemInfo = bagInfo;
                  this.list.push(info);
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

