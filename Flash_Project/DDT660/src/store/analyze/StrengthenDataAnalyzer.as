package store.analyze
{
   import com.pickgliss.loader.DataAnalyzer;
   import flash.utils.Dictionary;
   
   public class StrengthenDataAnalyzer extends DataAnalyzer
   {
      
      public var _strengthData:Vector.<Dictionary>;
      
      private var _xml:XML;
      
      public function StrengthenDataAnalyzer(onCompleteCall:Function)
      {
         super(onCompleteCall);
      }
      
      override public function analyze(data:*) : void
      {
         var i:int = 0;
         var TemplateID:int = 0;
         var StrengthenLevel:int = 0;
         var Data:int = 0;
         this._xml = new XML(data);
         this.initData();
         var xmllist:XMLList = this._xml.Item;
         if(this._xml.@value == "true")
         {
            for(i = 0; i < xmllist.length(); i++)
            {
               TemplateID = int(xmllist[i].@TemplateID);
               StrengthenLevel = int(xmllist[i].@StrengthenLevel);
               Data = int(xmllist[i].@Data);
               this._strengthData[StrengthenLevel][TemplateID] = Data;
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
      
      private function initData() : void
      {
         var d:Dictionary = null;
         this._strengthData = new Vector.<Dictionary>();
         for(var i:int = 0; i <= 12; i++)
         {
            d = new Dictionary();
            this._strengthData.push(d);
         }
      }
   }
}

