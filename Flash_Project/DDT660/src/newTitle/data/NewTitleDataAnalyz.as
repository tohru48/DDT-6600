package newTitle.data
{
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   import flash.utils.Dictionary;
   
   public class NewTitleDataAnalyz extends DataAnalyzer
   {
      
      public var _newTitleList:Dictionary;
      
      public function NewTitleDataAnalyz(onCompleteCall:Function)
      {
         super(onCompleteCall);
      }
      
      override public function analyze(data:*) : void
      {
         var xmllist:XMLList = null;
         var i:int = 0;
         var info:NewTitleModel = null;
         this._newTitleList = new Dictionary();
         var xml:XML = new XML(data);
         if(xml.@value == "true")
         {
            xmllist = xml..Item;
            for(i = 0; i < xmllist.length(); i++)
            {
               info = new NewTitleModel();
               ObjectUtils.copyPorpertiesByXML(info,xmllist[i]);
               this._newTitleList[info.id] = info;
            }
            onAnalyzeComplete();
         }
         else
         {
            message = xml.@message;
            onAnalyzeError();
            onAnalyzeError();
         }
      }
      
      public function get list() : Dictionary
      {
         return this._newTitleList;
      }
   }
}

