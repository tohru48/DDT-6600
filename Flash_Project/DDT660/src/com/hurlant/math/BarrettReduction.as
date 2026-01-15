package com.hurlant.math
{
   use namespace bi_internal;
   
   internal class BarrettReduction implements IReduction
   {
      
      private var r2:BigInteger;
      
      private var q3:BigInteger;
      
      private var mu:BigInteger;
      
      private var m:BigInteger;
      
      public function BarrettReduction(m:BigInteger)
      {
         super();
         r2 = new BigInteger();
         q3 = new BigInteger();
         BigInteger.ONE.bi_internal::dlShiftTo(2 * m.t,r2);
         mu = r2.divide(m);
         this.m = m;
      }
      
      public function reduce(lx:BigInteger) : void
      {
         var x:BigInteger = null;
         x = lx as BigInteger;
         x.bi_internal::drShiftTo(m.t - 1,r2);
         if(x.t > m.t + 1)
         {
            x.t = m.t + 1;
            x.bi_internal::clamp();
         }
         mu.bi_internal::multiplyUpperTo(r2,m.t + 1,q3);
         m.bi_internal::multiplyLowerTo(q3,m.t + 1,r2);
         while(x.compareTo(r2) < 0)
         {
            x.bi_internal::dAddOffset(1,m.t + 1);
         }
         x.bi_internal::subTo(r2,x);
         while(x.compareTo(m) >= 0)
         {
            x.bi_internal::subTo(m,x);
         }
      }
      
      public function revert(x:BigInteger) : BigInteger
      {
         return x;
      }
      
      public function convert(x:BigInteger) : BigInteger
      {
         var r:BigInteger = null;
         if(x.bi_internal::s < 0 || x.t > 2 * m.t)
         {
            return x.mod(m);
         }
         if(x.compareTo(m) < 0)
         {
            return x;
         }
         r = new BigInteger();
         x.bi_internal::copyTo(r);
         reduce(r);
         return r;
      }
      
      public function sqrTo(x:BigInteger, r:BigInteger) : void
      {
         x.bi_internal::squareTo(r);
         reduce(r);
      }
      
      public function mulTo(x:BigInteger, y:BigInteger, r:BigInteger) : void
      {
         x.bi_internal::multiplyTo(y,r);
         reduce(r);
      }
   }
}

