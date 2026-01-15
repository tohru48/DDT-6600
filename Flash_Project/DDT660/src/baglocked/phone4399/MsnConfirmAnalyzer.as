package baglocked.phone4399
{
   import com.pickgliss.loader.DataAnalyzer;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   
   public class MsnConfirmAnalyzer extends DataAnalyzer
   {
      
      private var _type:int;
      
      private var _value:Boolean;
      
      private var _alertMessage:String;
      
      private var _count:int;
      
      public function MsnConfirmAnalyzer(onCompleteCall:Function)
      {
         super(onCompleteCall);
      }
      
      override public function analyze(data:*) : void
      {
         var xml:XML = new XML(data);
         if(xml.@type != undefined)
         {
            this._type = xml.@type;
            this._value = xml.@value != "false";
            this._alertMessage = xml.@message;
            this._count = xml.@count;
            onAnalyzeComplete();
         }
         else
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.loader.MsnConfirm4399"));
         }
      }
      
      public function get type() : int
      {
         return this._type;
      }
      
      public function get value() : Boolean
      {
         return this._value;
      }
      
      public function get alertMessage() : String
      {
         return this._alertMessage;
      }
      
      public function get count() : int
      {
         return this._count;
      }
   }
}

