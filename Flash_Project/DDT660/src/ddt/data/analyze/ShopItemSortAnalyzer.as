package ddt.data.analyze
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import ddt.data.goods.ShopItemInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.ShopManager;
   import flash.events.TimerEvent;
   import flash.utils.Dictionary;
   import flash.utils.Timer;
   
   public class ShopItemSortAnalyzer extends DataAnalyzer
   {
      
      private var _xml:XML;
      
      private var _shoplist:XMLList;
      
      public var shopSortedGoods:Dictionary;
      
      private var index:int = -1;
      
      private var _timer:Timer;
      
      public function ShopItemSortAnalyzer(onCompleteCall:Function)
      {
         super(onCompleteCall);
         this.shopSortedGoods = new Dictionary();
      }
      
      override public function analyze(data:*) : void
      {
         this._xml = new XML(data);
         if(this._xml.@value == "true")
         {
            this._shoplist = this._xml..Item;
            this.parseShop();
         }
         else
         {
            message = this._xml.@message;
            onAnalyzeError();
         }
      }
      
      private function parseShop() : void
      {
         this._timer = new Timer(30);
         this._timer.addEventListener(TimerEvent.TIMER,this.__partexceute);
         this._timer.start();
      }
      
      private function __partexceute(evt:TimerEvent) : void
      {
         var type:int = 0;
         var goodsID:int = 0;
         var info:ShopItemInfo = null;
         var alert:BaseAlerFrame = null;
         if(!ShopManager.Instance.initialized)
         {
            return;
         }
         for(var i:int = 0; i < 40; i++)
         {
            ++this.index;
            if(this.index >= this._shoplist.length())
            {
               this._timer.removeEventListener(TimerEvent.TIMER,this.__partexceute);
               this._timer.stop();
               this._timer = null;
               onAnalyzeComplete();
               return;
            }
            type = int(this._shoplist[this.index].@Type);
            goodsID = int(this._shoplist[this.index].@ShopId);
            info = ShopManager.Instance.getShopItemByGoodsID(goodsID);
            if(info != null)
            {
               this.addToList(type,info);
            }
            else
            {
               alert = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("shop.DataError.NoGood") + goodsID);
               alert.addEventListener(FrameEvent.RESPONSE,this.__onResponse);
            }
         }
      }
      
      private function __onResponse(event:FrameEvent) : void
      {
         var alert:BaseAlerFrame = BaseAlerFrame(event.target);
         alert.removeEventListener(FrameEvent.RESPONSE,this.__onResponse);
         alert.dispose();
      }
      
      private function addToList(type:int, shopItem:ShopItemInfo) : void
      {
         var list:Vector.<ShopItemInfo> = this.shopSortedGoods[type];
         if(list == null)
         {
            list = new Vector.<ShopItemInfo>();
            this.shopSortedGoods[type] = list;
         }
         list.push(shopItem);
      }
   }
}

