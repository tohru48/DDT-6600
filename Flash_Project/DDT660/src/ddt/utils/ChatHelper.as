package ddt.utils
{
   import ddt.view.chat.chat_system;
   import flash.utils.ByteArray;
   
   use namespace chat_system;
   
   public class ChatHelper
   {
      
      public function ChatHelper()
      {
         super();
      }
      
      chat_system static function readGoodsLinks(byte:ByteArray, isReadKey:Boolean = false) : Array
      {
         var obj:Object = null;
         var re_arr:Array = [];
         var count:uint = byte.readUnsignedByte();
         for(var i:int = 0; i < count; i++)
         {
            obj = new Object();
            obj.index = byte.readInt();
            obj.TemplateID = byte.readInt();
            obj.ItemID = byte.readInt();
            if(isReadKey)
            {
               obj.key = byte.readUTF();
            }
            re_arr.push(obj);
         }
         return re_arr;
      }
   }
}

