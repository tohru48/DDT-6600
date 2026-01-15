package ddt.data.analyze
{
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.manager.ItemManager;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class InventoryItemAnalyzer extends DataAnalyzer
   {
      
      public var list:Vector.<InventoryItemInfo> = new Vector.<InventoryItemInfo>();
      
      private var _xml:XML;
      
      private var _timer:Timer;
      
      private var _xmllist:XMLList;
      
      private var _index:int;
      
      public function InventoryItemAnalyzer(onCompleteCall:Function)
      {
         super(onCompleteCall);
      }
      
      override public function analyze(data:*) : void
      {
         this._xml = new XML(data);
         this.list = new Vector.<InventoryItemInfo>();
         this.parseTemplate();
      }
      
      protected function parseTemplate() : void
      {
         if(this._xml.@value == "true")
         {
            this._xmllist = this._xml..Item;
            this._index = -1;
            this._timer = new Timer(30);
            this._timer.addEventListener(TimerEvent.TIMER,this.__partexceute);
            this._timer.start();
         }
         else
         {
            message = this._xml.@message;
            onAnalyzeError();
         }
      }
      
      private function __partexceute(event:TimerEvent) : void
      {
         var info:InventoryItemInfo = null;
         for(var i:int = 0; i < 40; i++)
         {
            ++this._index;
            if(this._index >= this._xmllist.length())
            {
               this._timer.removeEventListener(TimerEvent.TIMER,this.__partexceute);
               this._timer.stop();
               this._timer = null;
               onAnalyzeComplete();
               return;
            }
            info = new InventoryItemInfo();
            ObjectUtils.copyPorpertiesByXML(info,this._xmllist[this._index]);
            ItemManager.fill(info);
            this.list.push(info);
         }
      }
   }
}

