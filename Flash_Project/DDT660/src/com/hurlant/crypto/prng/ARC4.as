package com.hurlant.crypto.prng
{
   import com.hurlant.crypto.symmetric.IStreamCipher;
   import com.hurlant.util.Memory;
   import flash.utils.ByteArray;
   
   public class ARC4 implements IPRNG, IStreamCipher
   {
      
      private var S:ByteArray;
      
      private var i:int = 0;
      
      private var j:int = 0;
      
      private const psize:uint = 256;
      
      public function ARC4(key:ByteArray = null)
      {
         super();
         S = new ByteArray();
         if(Boolean(key))
         {
            init(key);
         }
      }
      
      public function decrypt(block:ByteArray) : void
      {
         encrypt(block);
      }
      
      public function init(key:ByteArray) : void
      {
         var i:int = 0;
         var j:int = 0;
         var t:int = 0;
         for(i = 0; i < 256; i++)
         {
            S[i] = i;
         }
         j = 0;
         for(i = 0; i < 256; i++)
         {
            j = j + S[i] + key[i % key.length] & 0xFF;
            t = int(S[i]);
            S[i] = S[j];
            S[j] = t;
         }
         this.i = 0;
         this.j = 0;
      }
      
      public function dispose() : void
      {
         var i:uint = 0;
         i = 0;
         if(S != null)
         {
            for(i = 0; i < S.length; i++)
            {
               S[i] = Math.random() * 256;
            }
            S.length = 0;
            S = null;
         }
         this.i = 0;
         this.j = 0;
         Memory.gc();
      }
      
      public function encrypt(block:ByteArray) : void
      {
         var i:uint = 0;
         i = 0;
         while(i < block.length)
         {
            var _loc3_:* = i++;
            block[_loc3_] ^= next();
         }
      }
      
      public function next() : uint
      {
         var t:int = 0;
         i = i + 1 & 0xFF;
         j = j + S[i] & 0xFF;
         t = int(S[i]);
         S[i] = S[j];
         S[j] = t;
         return S[t + S[i] & 0xFF];
      }
      
      public function getBlockSize() : uint
      {
         return 1;
      }
      
      public function getPoolSize() : uint
      {
         return psize;
      }
      
      public function toString() : String
      {
         return "rc4";
      }
   }
}

