package com.hurlant.math
{
   use namespace bi_internal;
   
   internal class MontgomeryReduction implements IReduction
   {
      
      private var um:int;
      
      private var mp:int;
      
      private var mph:int;
      
      private var mpl:int;
      
      private var mt2:int;
      
      private var m:BigInteger;
      
      public function MontgomeryReduction(m:BigInteger)
      {
         super();
         this.m = m;
         mp = m.bi_internal::invDigit();
         mpl = mp & 0x7FFF;
         mph = mp >> 15;
         um = (1 << BigInteger.DB - 15) - 1;
         mt2 = 2 * m.t;
      }
      
      public function mulTo(x:BigInteger, y:BigInteger, r:BigInteger) : void
      {
         x.bi_internal::multiplyTo(y,r);
         reduce(r);
      }
      
      public function revert(x:BigInteger) : BigInteger
      {
         var r:BigInteger = null;
         r = new BigInteger();
         x.bi_internal::copyTo(r);
         reduce(r);
         return r;
      }
      
      public function convert(x:BigInteger) : BigInteger
      {
         var r:BigInteger = null;
         r = new BigInteger();
         x.abs().bi_internal::dlShiftTo(m.t,r);
         r.bi_internal::divRemTo(m,null,r);
         if(x.bi_internal::s < 0 && r.compareTo(BigInteger.ZERO) > 0)
         {
            m.bi_internal::subTo(r,r);
         }
         return r;
      }
      
      public function reduce(x:BigInteger) : void
      {
         var i:int = 0;
         var j:int = 0;
         var u0:int = 0;
         while(x.t <= mt2)
         {
            var _loc5_:* = x.t++;
            x.bi_internal::a[_loc5_] = 0;
         }
         for(i = 0; i < m.t; i++)
         {
            j = x.bi_internal::a[i] & 0x7FFF;
            u0 = j * mpl + ((j * mph + (x.bi_internal::a[i] >> 15) * mpl & um) << 15) & BigInteger.DM;
            j = i + m.t;
            x.bi_internal::a[j] += m.bi_internal::am(0,u0,x,i,0,m.t);
            while(x.bi_internal::a[j] >= BigInteger.DV)
            {
               x.bi_internal::a[j] -= BigInteger.DV;
               ++x.bi_internal::a[++j];
            }
         }
         x.bi_internal::clamp();
         x.bi_internal::drShiftTo(m.t,x);
         if(x.compareTo(m) >= 0)
         {
            x.bi_internal::subTo(m,x);
         }
      }
      
      public function sqrTo(x:BigInteger, r:BigInteger) : void
      {
         x.bi_internal::squareTo(r);
         reduce(r);
      }
   }
}

