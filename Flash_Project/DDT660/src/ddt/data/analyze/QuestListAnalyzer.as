package ddt.data.analyze
{
   import com.pickgliss.loader.DataAnalyzer;
   import ddt.data.quest.QuestInfo;
   import flash.utils.Dictionary;
   
   public class QuestListAnalyzer extends DataAnalyzer
   {
      
      private var _xml:XML;
      
      private var _list:Dictionary;
      
      public function QuestListAnalyzer(onCompleteCall:Function)
      {
         super(onCompleteCall);
      }
      
      public function get list() : Dictionary
      {
         return this._list;
      }
      
      public function get improveXml() : XML
      {
         var xmllist:XMLList = this._xml..Rate;
         return xmllist[0];
      }
      
      override public function analyze(data:*) : void
      {
         var x:XML = null;
         var info:QuestInfo = null;
         this._xml = new XML(data);
         var xmllist:XMLList = this._xml..Item;
         this._list = new Dictionary();
         for(var i:int = 0; i < xmllist.length(); i++)
         {
            x = xmllist[i];
            info = QuestInfo.createFromXML(x);
            this._list[info.Id] = info;
         }
         onAnalyzeComplete();
      }
   }
}

