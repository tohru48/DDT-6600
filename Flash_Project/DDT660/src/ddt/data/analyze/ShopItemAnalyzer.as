package ddt.data.analyze
{
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.ShopItemInfo;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import road7th.data.DictionaryData;
   
   public class ShopItemAnalyzer extends DataAnalyzer
   {
      
      public var shopinfolist:DictionaryData;
      
      private var _xml:XML;
      
      private var _shoplist:XMLList;
      
      private var index:int = -1;
      
      private var _timer:Timer;
      
      public function ShopItemAnalyzer(onCompleteCall:Function)
      {
         super(onCompleteCall);
      }
      
      override public function analyze(data:*) : void
      {
         this._xml = new XML(data);
         if(this._xml.@value == "true")
         {
            this.shopinfolist = new DictionaryData();
            this._shoplist = this._xml.Store..Item;
            this.parseShop(null);
         }
         else
         {
            message = this._xml.@message;
            onAnalyzeError();
         }
      }
      
      private function parseShop(evt:Event) : void
      {
         this._timer = new Timer(30);
         this._timer.addEventListener(TimerEvent.TIMER,this.__partexceute);
         this._timer.start();
      }
      
      private function __partexceute(evt:TimerEvent) : void
      {
         var info:ShopItemInfo = null;
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
            this.shopinfolist.add(info.GoodsID,info);
         }
      }
   }
}

