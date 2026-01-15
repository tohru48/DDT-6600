package ddt.data.analyze
{
   import beadSystem.model.BeadInfo;
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import road7th.data.DictionaryData;
   
   public class BeadAnalyzer extends DataAnalyzer
   {
      
      public var list:DictionaryData = new DictionaryData();
      
      private var _xml:XML;
      
      private var _timer:Timer;
      
      private var _xmllist:XMLList;
      
      private var _index:int;
      
      public function BeadAnalyzer(onCompleteCall:Function)
      {
         super(onCompleteCall);
      }
      
      override public function analyze(data:*) : void
      {
         this._xml = new XML(data);
         this.list = new DictionaryData();
         this.parseTemplate();
      }
      
      protected function parseTemplate() : void
      {
         if(this._xml.@value == "true")
         {
            this._xmllist = this._xml..Rune;
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
         var info:BeadInfo = null;
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
            info = new BeadInfo();
            ObjectUtils.copyPorpertiesByXML(info,this._xmllist[this._index]);
            this.list.add(info.TemplateID,info);
         }
      }
   }
}

