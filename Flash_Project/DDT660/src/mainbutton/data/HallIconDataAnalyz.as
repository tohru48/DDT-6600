package mainbutton.data
{
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   import flash.utils.Dictionary;
   import mainbutton.MainButton;
   
   public class HallIconDataAnalyz extends DataAnalyzer
   {
      
      public var _HallIconList:Dictionary;
      
      public function HallIconDataAnalyz(onCompleteCall:Function)
      {
         super(onCompleteCall);
      }
      
      override public function analyze(data:*) : void
      {
         var xmllist:XMLList = null;
         var i:int = 0;
         var info:MainButton = null;
         this._HallIconList = new Dictionary();
         var xml:XML = new XML(data);
         if(xml.@value == "true")
         {
            xmllist = xml..Item;
            for(i = 0; i < xmllist.length(); i++)
            {
               info = new MainButton();
               ObjectUtils.copyPorpertiesByXML(info,xmllist[i]);
               this._HallIconList[info.ID] = info;
            }
            this.addDiceIconData();
            onAnalyzeComplete();
         }
         else
         {
            message = xml.@message;
            onAnalyzeError();
            onAnalyzeError();
         }
      }
      
      public function addDiceIconData() : void
      {
         var diceInfo:MainButton = new MainButton();
         diceInfo.ID = "8";
         diceInfo.IsShow = false;
         diceInfo.btnName = "diceBtn";
         diceInfo.btnMark = int(diceInfo.ID);
         diceInfo.btnCompleteVisable = 0;
         diceInfo.btnServerVisable = 0;
         this._HallIconList[diceInfo.ID] = diceInfo;
      }
      
      public function get list() : Dictionary
      {
         return this._HallIconList;
      }
   }
}

