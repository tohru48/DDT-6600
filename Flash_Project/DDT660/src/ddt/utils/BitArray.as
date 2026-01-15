package ddt.utils
{
   import flash.utils.ByteArray;
   
   public class BitArray extends ByteArray
   {
      
      public function BitArray()
      {
         super();
      }
      
      public function setBit(position:uint, value:Boolean) : Boolean
      {
         var index:uint = uint(position >> 3);
         var offset:uint = uint(position & 7);
         var tempByte:uint = uint(this[index]);
         tempByte |= 1 << offset;
         this[index] = tempByte;
         return true;
      }
      
      public function getBit(position:uint) : Boolean
      {
         var index:int = position >> 3;
         var offset:int = position & 7;
         var tempByte:int = int(this[index]);
         var result:uint = uint(tempByte & 1 << offset);
         if(Boolean(result))
         {
            return true;
         }
         return false;
      }
      
      public function loadBinary(str:String) : void
      {
         for(var i:Number = 0; i < str.length * 32; i++)
         {
            this.setBit(i,Boolean(str) && Boolean(1 >> i));
         }
      }
      
      public function traceBinary(position:uint) : String
      {
         var index:uint = uint(position >> 3);
         var offset:int = position & 7;
         var tempByte:int = int(this[index]);
         var tempStr:String = "";
         for(var i:uint = 0; i < 8; i++)
         {
            if(i == offset)
            {
               if(Boolean(tempByte & 1 << i))
               {
                  tempStr += "[1]";
               }
               else
               {
                  tempStr += "[0]";
               }
            }
            else if(Boolean(tempByte & 1 << i))
            {
               tempStr += " 1 ";
            }
            else
            {
               tempStr += " 0 ";
            }
         }
         return tempStr;
      }
   }
}

