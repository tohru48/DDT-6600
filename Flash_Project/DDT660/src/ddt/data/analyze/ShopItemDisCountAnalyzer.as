package ddt.data.analyze
{
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.ShopItemInfo;
   import ddt.manager.ShopManager;
   import flash.events.TimerEvent;
   import flash.utils.Dictionary;
   import flash.utils.Timer;
   import road7th.data.DictionaryData;
   
   public class ShopItemDisCountAnalyzer extends DataAnalyzer
   {
      
      private var _xml:XML;
      
      private var _shoplist:XMLList;
      
      public var shopDisCountGoods:Dictionary;
      
      private var index:int = -1;
      
      private var _timer:Timer;
      
      public function ShopItemDisCountAnalyzer(onCompleteCall:Function)
      {
         super(onCompleteCall);
         this.shopDisCountGoods = new Dictionary();
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
         var info:ShopItemInfo = null;
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
            info = new ShopItemInfo(int(this._shoplist[this.index].@ID),int(this._shoplist[this.index].@TemplateID));
            ObjectUtils.copyPorpertiesByXML(info,this._shoplist[this.index]);
            info.Label = int(this._shoplist[this.index].@LableType);
            info.AUnit = int(this._shoplist[this.index].@AUnit);
            info.APrice1 = int(this._shoplist[this.index].@APrice);
            info.AValue1 = int(this._shoplist[this.index].@AValue);
            info.BUnit = int(this._shoplist[this.index].@BUnit);
            info.BPrice1 = int(this._shoplist[this.index].@BPrice);
            info.BValue1 = int(this._shoplist[this.index].@BValue);
            info.CUnit = int(this._shoplist[this.index].@CUnit);
            info.CPrice1 = int(this._shoplist[this.index].@CPrice);
            info.CValue1 = int(this._shoplist[this.index].@CValue);
            info.isDiscount = 2;
            info.APrice2 = info.APrice3 = info.APrice1;
            info.BPrice2 = info.BPrice3 = info.BPrice1;
            info.CPrice2 = info.CPrice3 = info.CPrice1;
            this.addList(Math.abs(info.APrice1),info);
         }
      }
      
      private function converMoneyType(info:ShopItemInfo) : void
      {
         switch(Math.abs(info.APrice1))
         {
            case 3:
               info.APrice1 = -1;
               break;
            case 4:
               info.APrice1 = -2;
         }
         switch(Math.abs(info.BPrice1))
         {
            case 3:
               info.BPrice1 = -1;
               break;
            case 4:
               info.BPrice1 = -2;
               break;
            default:
               info.BPrice1 = info.APrice1;
         }
         switch(Math.abs(info.CPrice1))
         {
            case 3:
               info.CPrice1 = -1;
               break;
            case 4:
               info.CPrice1 = -2;
               break;
            default:
               info.CPrice1 = info.APrice1;
         }
         info.APrice2 = info.APrice3 = info.APrice1;
         info.BPrice2 = info.BPrice3 = info.BPrice1;
         info.CPrice2 = info.CPrice3 = info.CPrice1;
      }
      
      private function addList(type:int, itemInfo:ShopItemInfo) : void
      {
         var list:DictionaryData = this.shopDisCountGoods[type];
         if(!list)
         {
            list = new DictionaryData();
            this.shopDisCountGoods[type] = list;
         }
         list.add(itemInfo.GoodsID,itemInfo);
      }
   }
}

