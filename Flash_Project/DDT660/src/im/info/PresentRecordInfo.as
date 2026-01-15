package im.info
{
   import ddt.manager.PlayerManager;
   import road7th.utils.DateUtils;
   
   public class PresentRecordInfo
   {
      
      public static const SHOW:int = 0;
      
      public static const HIDE:int = 1;
      
      public static const UNREAD:int = 2;
      
      public var id:int;
      
      public var exist:int = 2;
      
      public var messages:Vector.<String>;
      
      public var recordMessage:Vector.<Object>;
      
      public function PresentRecordInfo()
      {
         super();
         this.messages = new Vector.<String>();
         this.recordMessage = new Vector.<Object>();
      }
      
      public function addMessage(name:String, date:Date, content:String) : void
      {
         var dd:String = DateUtils.dateFormat(date);
         var str:String = "";
         if(name == PlayerManager.Instance.Self.NickName)
         {
            str += "<FONT COLOR=\'#06f710\'>" + name + "   " + dd.split(" ")[1] + "</FONT>\n";
         }
         else
         {
            str += "<FONT COLOR=\'#ffff01\'>" + name + "   " + dd.split(" ")[1] + "</FONT>\n";
         }
         str += content;
         this.messages.push(str);
         var str1:String = "";
         if(name == PlayerManager.Instance.Self.NickName)
         {
            str1 += "<FONT COLOR=\'#06f710\'>" + name + "   " + dd + "</FONT>\n";
         }
         else
         {
            str1 += "<FONT COLOR=\'#ffff01\'>" + name + "   " + dd + "</FONT>\n";
         }
         str1 += content;
         this.recordMessage.push(str1);
      }
      
      public function get lastMessage() : String
      {
         return this.messages[this.messages.length - 1];
      }
      
      public function get lastRecordMessage() : Object
      {
         return this.recordMessage[this.recordMessage.length - 1];
      }
   }
}

