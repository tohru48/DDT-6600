package com.hurlant.math
{
   import com.hurlant.crypto.prng.Random;
   import com.hurlant.util.Hex;
   import com.hurlant.util.Memory;
   import flash.utils.ByteArray;
   
   use namespace bi_internal;
   
   public class BigInteger
   {
      
      public static const DB:int = 30;
      
      public static const DV:int = 1 << DB;
      
      public static const DM:int = DV - 1;
      
      public static const BI_FP:int = 52;
      
      public static const FV:Number = Math.pow(2,BI_FP);
      
      public static const F1:int = BI_FP - DB;
      
      public static const F2:int = 2 * DB - BI_FP;
      
      public static const ZERO:BigInteger = nbv(0);
      
      public static const ONE:BigInteger = nbv(1);
      
      public static const lowprimes:Array = [2,3,5,7,11,13,17,19,23,29,31,37,41,43,47,53,59,61,67,71,73,79,83,89,97,101,103,107,109,113,127,131,137,139,149,151,157,163,167,173,179,181,191,193,197,199,211,223,227,229,233,239,241,251,257,263,269,271,277,281,283,293,307,311,313,317,331,337,347,349,353,359,367,373,379,383,389,397,401,409,419,421,431,433,439,443,449,457,461,463,467,479,487,491,499,503,509];
      
      public static const lplim:int = (1 << 26) / lowprimes[lowprimes.length - 1];
      
      bi_internal var a:Array;
      
      bi_internal var s:int;
      
      public var t:int;
      
      public function BigInteger(value:* = null, radix:int = 0)
      {
         var array:ByteArray = null;
         var length:int = 0;
         super();
         bi_internal::a = new Array();
         if(value is String)
         {
            value = Hex.toArray(value);
            radix = 0;
         }
         if(value is ByteArray)
         {
            array = value as ByteArray;
            length = int(radix || array.length - array.position);
            bi_internal::fromArray(array,length);
         }
      }
      
      public static function nbv(value:int) : BigInteger
      {
         var bn:BigInteger = null;
         bn = new BigInteger();
         bn.bi_internal::fromInt(value);
         return bn;
      }
      
      public function clearBit(n:int) : BigInteger
      {
         return changeBit(n,op_andnot);
      }
      
      public function negate() : BigInteger
      {
         var r:BigInteger = null;
         r = nbi();
         ZERO.bi_internal::subTo(this,r);
         return r;
      }
      
      public function andNot(a:BigInteger) : BigInteger
      {
         var r:BigInteger = null;
         r = new BigInteger();
         bitwiseTo(a,op_andnot,r);
         return r;
      }
      
      public function modPow(e:BigInteger, m:BigInteger) : BigInteger
      {
         var i:int = 0;
         var k:int = 0;
         var r:BigInteger = null;
         var z:IReduction = null;
         var g:Array = null;
         var n:int = 0;
         var k1:int = 0;
         var km:int = 0;
         var j:int = 0;
         var w:int = 0;
         var is1:Boolean = false;
         var r2:BigInteger = null;
         var t:BigInteger = null;
         var g2:BigInteger = null;
         i = e.bitLength();
         r = nbv(1);
         if(i <= 0)
         {
            return r;
         }
         if(i < 18)
         {
            k = 1;
         }
         else if(i < 48)
         {
            k = 3;
         }
         else if(i < 144)
         {
            k = 4;
         }
         else if(i < 768)
         {
            k = 5;
         }
         else
         {
            k = 6;
         }
         if(i < 8)
         {
            z = new ClassicReduction(m);
         }
         else if(m.bi_internal::isEven())
         {
            z = new BarrettReduction(m);
         }
         else
         {
            z = new MontgomeryReduction(m);
         }
         g = [];
         n = 3;
         k1 = k - 1;
         km = (1 << k) - 1;
         g[1] = z.convert(this);
         if(k > 1)
         {
            g2 = new BigInteger();
            z.sqrTo(g[1],g2);
            while(n <= km)
            {
               g[n] = new BigInteger();
               z.mulTo(g2,g[n - 2],g[n]);
               n += 2;
            }
         }
         j = e.t - 1;
         is1 = true;
         r2 = new BigInteger();
         i = bi_internal::nbits(e.bi_internal::a[j]) - 1;
         while(j >= 0)
         {
            if(i >= k1)
            {
               w = e.bi_internal::a[j] >> i - k1 & km;
            }
            else
            {
               w = (e.bi_internal::a[j] & (1 << i + 1) - 1) << k1 - i;
               if(j > 0)
               {
                  w |= e.bi_internal::a[j - 1] >> DB + i - k1;
               }
            }
            n = k;
            while((w & 1) == 0)
            {
               w >>= 1;
               n--;
            }
            i = i - n;
            if(i < 0)
            {
               i += DB;
               j--;
            }
            if(is1)
            {
               g[w].copyTo(r);
               is1 = false;
            }
            else
            {
               while(n > 1)
               {
                  z.sqrTo(r,r2);
                  z.sqrTo(r2,r);
                  n -= 2;
               }
               if(n > 0)
               {
                  z.sqrTo(r,r2);
               }
               else
               {
                  t = r;
                  r = r2;
                  r2 = t;
               }
               z.mulTo(r2,g[w],r);
            }
            while(j >= 0 && (e.bi_internal::a[j] & 1 << i) == 0)
            {
               z.sqrTo(r,r2);
               t = r;
               r = r2;
               r2 = t;
               if(--i < 0)
               {
                  i = DB - 1;
                  j--;
               }
            }
         }
         return z.revert(r);
      }
      
      public function isProbablePrime(t:int) : Boolean
      {
         var i:int = 0;
         var x:BigInteger = null;
         var m:int = 0;
         var j:int = 0;
         x = abs();
         if(x.t == 1 && x.bi_internal::a[0] <= lowprimes[lowprimes.length - 1])
         {
            for(i = 0; i < lowprimes.length; i++)
            {
               if(x[0] == lowprimes[i])
               {
                  return true;
               }
            }
            return false;
         }
         if(x.bi_internal::isEven())
         {
            return false;
         }
         i = 1;
         while(i < lowprimes.length)
         {
            m = int(lowprimes[i]);
            j = i + 1;
            while(j < lowprimes.length && m < lplim)
            {
               m *= lowprimes[j++];
            }
            m = x.modInt(m);
            while(i < j)
            {
               if(m % lowprimes[i++] == 0)
               {
                  return false;
               }
            }
         }
         return x.millerRabin(t);
      }
      
      private function op_or(x:int, y:int) : int
      {
         return x | y;
      }
      
      public function mod(v:BigInteger) : BigInteger
      {
         var r:BigInteger = null;
         r = nbi();
         abs().bi_internal::divRemTo(v,null,r);
         if(bi_internal::s < 0 && r.compareTo(ZERO) > 0)
         {
            v.bi_internal::subTo(r,r);
         }
         return r;
      }
      
      protected function addTo(a:BigInteger, r:BigInteger) : void
      {
         var i:int = 0;
         var c:int = 0;
         var m:int = 0;
         i = 0;
         c = 0;
         m = Math.min(a.t,t);
         while(i < m)
         {
            c += this.bi_internal::a[i] + a.bi_internal::a[i];
            var _loc6_:* = i++;
            r.bi_internal::a[_loc6_] = c & DM;
            c >>= DB;
         }
         if(a.t < t)
         {
            c += a.bi_internal::s;
            while(i < t)
            {
               c += this.bi_internal::a[i];
               _loc6_ = i++;
               r.bi_internal::a[_loc6_] = c & DM;
               c >>= DB;
            }
            c += bi_internal::s;
         }
         else
         {
            c += bi_internal::s;
            while(i < a.t)
            {
               c += a.bi_internal::a[i];
               _loc6_ = i++;
               r.bi_internal::a[_loc6_] = c & DM;
               c >>= DB;
            }
            c += a.bi_internal::s;
         }
         r.bi_internal::s = c < 0 ? -1 : 0;
         if(c > 0)
         {
            _loc6_ = i++;
            r.bi_internal::a[_loc6_] = c;
         }
         else if(c < -1)
         {
            _loc6_ = i++;
            r.bi_internal::a[_loc6_] = DV + c;
         }
         r.t = i;
         r.bi_internal::clamp();
      }
      
      protected function bitwiseTo(a:BigInteger, op:Function, r:BigInteger) : void
      {
         var i:int = 0;
         var f:int = 0;
         var m:int = 0;
         m = Math.min(a.t,t);
         for(i = 0; i < m; i++)
         {
            r.bi_internal::a[i] = op(this.bi_internal::a[i],a.bi_internal::a[i]);
         }
         if(a.t < t)
         {
            f = a.bi_internal::s & DM;
            for(i = m; i < t; i++)
            {
               r.bi_internal::a[i] = op(this.bi_internal::a[i],f);
            }
            r.t = t;
         }
         else
         {
            f = bi_internal::s & DM;
            for(i = m; i < a.t; i++)
            {
               r.bi_internal::a[i] = op(f,a.bi_internal::a[i]);
            }
            r.t = a.t;
         }
         r.bi_internal::s = op(bi_internal::s,a.bi_internal::s);
         r.bi_internal::clamp();
      }
      
      protected function modInt(n:int) : int
      {
         var d:int = 0;
         var r:int = 0;
         var i:int = 0;
         if(n <= 0)
         {
            return 0;
         }
         d = DV % n;
         r = bi_internal::s < 0 ? n - 1 : 0;
         if(t > 0)
         {
            if(d == 0)
            {
               r = bi_internal::a[0] % n;
            }
            else
            {
               for(i = t - 1; i >= 0; i--)
               {
                  r = (d * r + bi_internal::a[i]) % n;
               }
            }
         }
         return r;
      }
      
      protected function chunkSize(r:Number) : int
      {
         return Math.floor(Math.LN2 * DB / Math.log(r));
      }
      
      bi_internal function dAddOffset(n:int, w:int) : void
      {
         while(t <= w)
         {
            var _loc3_:* = t++;
            bi_internal::a[_loc3_] = 0;
         }
         bi_internal::a[w] += n;
         while(bi_internal::a[w] >= DV)
         {
            bi_internal::a[w] -= DV;
            if(++w >= t)
            {
               _loc3_ = t++;
               bi_internal::a[_loc3_] = 0;
            }
            ++bi_internal::a[w];
         }
      }
      
      bi_internal function lShiftTo(n:int, r:BigInteger) : void
      {
         var bs:int = 0;
         var cbs:int = 0;
         var bm:int = 0;
         var ds:int = 0;
         var c:int = 0;
         var i:int = 0;
         bs = n % DB;
         cbs = DB - bs;
         bm = (1 << cbs) - 1;
         ds = n / DB;
         c = bi_internal::s << bs & DM;
         for(i = t - 1; i >= 0; i--)
         {
            r.bi_internal::a[i + ds + 1] = bi_internal::a[i] >> cbs | c;
            c = (bi_internal::a[i] & bm) << bs;
         }
         for(i = ds - 1; i >= 0; i--)
         {
            r.bi_internal::a[i] = 0;
         }
         r.bi_internal::a[ds] = c;
         r.t = t + ds + 1;
         r.bi_internal::s = bi_internal::s;
         r.bi_internal::clamp();
      }
      
      public function getLowestSetBit() : int
      {
         var i:int = 0;
         for(i = 0; i < t; i++)
         {
            if(bi_internal::a[i] != 0)
            {
               return i * DB + lbit(bi_internal::a[i]);
            }
         }
         if(bi_internal::s < 0)
         {
            return t * DB;
         }
         return -1;
      }
      
      public function subtract(a:BigInteger) : BigInteger
      {
         var r:BigInteger = null;
         r = new BigInteger();
         bi_internal::subTo(a,r);
         return r;
      }
      
      public function primify(bits:int, t:int) : void
      {
         if(!testBit(bits - 1))
         {
            bitwiseTo(BigInteger.ONE.shiftLeft(bits - 1),op_or,this);
         }
         if(bi_internal::isEven())
         {
            bi_internal::dAddOffset(1,0);
         }
         while(!isProbablePrime(t))
         {
            for(bi_internal::dAddOffset(2,0); bitLength() > bits; )
            {
               bi_internal::subTo(BigInteger.ONE.shiftLeft(bits - 1),this);
            }
         }
      }
      
      public function gcd(a:BigInteger) : BigInteger
      {
         var x:BigInteger = null;
         var y:BigInteger = null;
         var i:int = 0;
         var g:int = 0;
         var t:BigInteger = null;
         x = bi_internal::s < 0 ? negate() : clone();
         y = a.bi_internal::s < 0 ? a.negate() : a.clone();
         if(x.compareTo(y) < 0)
         {
            t = x;
            x = y;
            y = t;
         }
         i = x.getLowestSetBit();
         g = y.getLowestSetBit();
         if(g < 0)
         {
            return x;
         }
         if(i < g)
         {
            g = i;
         }
         if(g > 0)
         {
            x.bi_internal::rShiftTo(g,x);
            y.bi_internal::rShiftTo(g,y);
         }
         while(x.sigNum() > 0)
         {
            i = x.getLowestSetBit();
            if(i > 0)
            {
               x.bi_internal::rShiftTo(i,x);
            }
            i = y.getLowestSetBit();
            if(i > 0)
            {
               y.bi_internal::rShiftTo(i,y);
            }
            if(x.compareTo(y) >= 0)
            {
               x.bi_internal::subTo(y,x);
               x.bi_internal::rShiftTo(1,x);
            }
            else
            {
               y.bi_internal::subTo(x,y);
               y.bi_internal::rShiftTo(1,y);
            }
         }
         if(g > 0)
         {
            y.bi_internal::lShiftTo(g,y);
         }
         return y;
      }
      
      bi_internal function multiplyLowerTo(a:BigInteger, n:int, r:BigInteger) : void
      {
         var i:int = 0;
         var j:int = 0;
         i = Math.min(t + a.t,n);
         r.bi_internal::s = 0;
         r.t = i;
         while(i > 0)
         {
            var _loc6_:* = --i;
            r.bi_internal::a[_loc6_] = 0;
         }
         for(j = r.t - t; i < j; i++)
         {
            r.bi_internal::a[i + t] = bi_internal::am(0,a.bi_internal::a[i],r,i,0,t);
         }
         for(j = Math.min(a.t,n); i < j; i++)
         {
            bi_internal::am(0,a.bi_internal::a[i],r,i,0,n - i);
         }
         r.bi_internal::clamp();
      }
      
      public function modPowInt(e:int, m:BigInteger) : BigInteger
      {
         var z:IReduction = null;
         if(e < 256 || m.bi_internal::isEven())
         {
            z = new ClassicReduction(m);
         }
         else
         {
            z = new MontgomeryReduction(m);
         }
         return bi_internal::exp(e,z);
      }
      
      bi_internal function intAt(str:String, index:int) : int
      {
         return parseInt(str.charAt(index),36);
      }
      
      public function testBit(n:int) : Boolean
      {
         var j:int = 0;
         j = Math.floor(n / DB);
         if(j >= t)
         {
            return bi_internal::s != 0;
         }
         return (bi_internal::a[j] & 1 << n % DB) != 0;
      }
      
      bi_internal function exp(e:int, z:IReduction) : BigInteger
      {
         var r:BigInteger = null;
         var r2:BigInteger = null;
         var g:BigInteger = null;
         var i:int = 0;
         var t:BigInteger = null;
         if(e > 4294967295 || e < 1)
         {
            return ONE;
         }
         r = nbi();
         r2 = nbi();
         g = z.convert(this);
         i = bi_internal::nbits(e) - 1;
         g.bi_internal::copyTo(r);
         while(--i >= 0)
         {
            z.sqrTo(r,r2);
            if((e & 1 << i) > 0)
            {
               z.mulTo(r2,g,r);
            }
            else
            {
               t = r;
               r = r2;
               r2 = t;
            }
         }
         return z.revert(r);
      }
      
      public function toArray(array:ByteArray) : uint
      {
         var k:int = 0;
         var km:int = 0;
         var d:int = 0;
         var i:int = 0;
         var p:int = 0;
         var m:Boolean = false;
         var c:int = 0;
         k = 8;
         km = (1 << 8) - 1;
         d = 0;
         i = t;
         p = DB - i * DB % k;
         m = false;
         c = 0;
         if(i-- > 0)
         {
            if(p < DB && (d = bi_internal::a[i] >> p) > 0)
            {
               m = true;
               array.writeByte(d);
               c++;
            }
            while(i >= 0)
            {
               if(p < k)
               {
                  d = (bi_internal::a[i] & (1 << p) - 1) << k - p;
                  d |= bi_internal::a[--i] >> (p = p + (DB - k));
               }
               else
               {
                  d = bi_internal::a[i] >> (p = p - k) & km;
                  if(p <= 0)
                  {
                     p += DB;
                     i--;
                  }
               }
               if(d > 0)
               {
                  m = true;
               }
               if(m)
               {
                  array.writeByte(d);
                  c++;
               }
            }
         }
         return c;
      }
      
      public function dispose() : void
      {
         var r:Random = null;
         var i:uint = 0;
         r = new Random();
         for(i = 0; i < bi_internal::a.length; i++)
         {
            bi_internal::a[i] = r.nextByte();
            delete bi_internal::a[i];
         }
         bi_internal::a = null;
         t = 0;
         bi_internal::s = 0;
         Memory.gc();
      }
      
      private function lbit(x:int) : int
      {
         var r:int = 0;
         if(x == 0)
         {
            return -1;
         }
         r = 0;
         if((x & 0xFFFF) == 0)
         {
            x >>= 16;
            r += 16;
         }
         if((x & 0xFF) == 0)
         {
            x >>= 8;
            r += 8;
         }
         if((x & 0x0F) == 0)
         {
            x >>= 4;
            r += 4;
         }
         if((x & 3) == 0)
         {
            x >>= 2;
            r += 2;
         }
         if((x & 1) == 0)
         {
            r++;
         }
         return r;
      }
      
      bi_internal function divRemTo(m:BigInteger, q:BigInteger = null, r:BigInteger = null) : void
      {
         var pm:BigInteger = null;
         var pt:BigInteger = null;
         var y:BigInteger = null;
         var ts:int = 0;
         var ms:int = 0;
         var nsh:int = 0;
         var ys:int = 0;
         var y0:int = 0;
         var yt:Number = NaN;
         var d1:Number = NaN;
         var d2:Number = NaN;
         var e:Number = NaN;
         var i:int = 0;
         var j:int = 0;
         var t:BigInteger = null;
         var qd:int = 0;
         pm = m.abs();
         if(pm.t <= 0)
         {
            return;
         }
         pt = abs();
         if(pt.t < pm.t)
         {
            if(q != null)
            {
               q.bi_internal::fromInt(0);
            }
            if(r != null)
            {
               bi_internal::copyTo(r);
            }
            return;
         }
         if(r == null)
         {
            r = nbi();
         }
         y = nbi();
         ts = bi_internal::s;
         ms = m.bi_internal::s;
         nsh = DB - bi_internal::nbits(pm.bi_internal::a[pm.t - 1]);
         if(nsh > 0)
         {
            pm.bi_internal::lShiftTo(nsh,y);
            pt.bi_internal::lShiftTo(nsh,r);
         }
         else
         {
            pm.bi_internal::copyTo(y);
            pt.bi_internal::copyTo(r);
         }
         ys = y.t;
         y0 = int(y.bi_internal::a[ys - 1]);
         if(y0 == 0)
         {
            return;
         }
         yt = y0 * (1 << F1) + (ys > 1 ? y.bi_internal::a[ys - 2] >> F2 : 0);
         d1 = FV / yt;
         d2 = (1 << F1) / yt;
         e = 1 << F2;
         i = r.t;
         j = i - ys;
         t = q == null ? nbi() : q;
         y.bi_internal::dlShiftTo(j,t);
         if(r.compareTo(t) >= 0)
         {
            var _loc5_:* = r.t++;
            r.bi_internal::a[_loc5_] = 1;
            r.bi_internal::subTo(t,r);
         }
         ONE.bi_internal::dlShiftTo(ys,t);
         for(t.bi_internal::subTo(y,y); y.t < ys; )
         {
            y.(++y.t, false);
         }
         while(--j >= 0)
         {
            qd = r.bi_internal::a[--i] == y0 ? DM : int(Number(r.bi_internal::a[i]) * d1 + (Number(r.bi_internal::a[i - 1]) + e) * d2);
            if((r.bi_internal::a[i] = r.bi_internal::a[i] + y.bi_internal::am(0,qd,r,j,0,ys)) < qd)
            {
               y.bi_internal::dlShiftTo(j,t);
               r.bi_internal::subTo(t,r);
               while(r.bi_internal::a[i] < --qd)
               {
                  r.bi_internal::subTo(t,r);
               }
            }
         }
         if(q != null)
         {
            r.bi_internal::drShiftTo(ys,q);
            if(ts != ms)
            {
               ZERO.bi_internal::subTo(q,q);
            }
         }
         r.t = ys;
         r.bi_internal::clamp();
         if(nsh > 0)
         {
            r.bi_internal::rShiftTo(nsh,r);
         }
         if(ts < 0)
         {
            ZERO.bi_internal::subTo(r,r);
         }
      }
      
      public function remainder(a:BigInteger) : BigInteger
      {
         var r:BigInteger = null;
         r = new BigInteger();
         bi_internal::divRemTo(a,null,r);
         return r;
      }
      
      public function divide(a:BigInteger) : BigInteger
      {
         var r:BigInteger = null;
         r = new BigInteger();
         bi_internal::divRemTo(a,r,null);
         return r;
      }
      
      public function divideAndRemainder(a:BigInteger) : Array
      {
         var q:BigInteger = null;
         var r:BigInteger = null;
         q = new BigInteger();
         r = new BigInteger();
         bi_internal::divRemTo(a,q,r);
         return [q,r];
      }
      
      public function valueOf() : Number
      {
         var coef:Number = NaN;
         var value:Number = NaN;
         var i:uint = 0;
         coef = 1;
         value = 0;
         for(i = 0; i < t; i++)
         {
            value += bi_internal::a[i] * coef;
            coef *= DV;
         }
         return value;
      }
      
      public function shiftLeft(n:int) : BigInteger
      {
         var r:BigInteger = null;
         r = new BigInteger();
         if(n < 0)
         {
            bi_internal::rShiftTo(-n,r);
         }
         else
         {
            bi_internal::lShiftTo(n,r);
         }
         return r;
      }
      
      public function multiply(a:BigInteger) : BigInteger
      {
         var r:BigInteger = null;
         r = new BigInteger();
         bi_internal::multiplyTo(a,r);
         return r;
      }
      
      bi_internal function am(i:int, x:int, w:BigInteger, j:int, c:int, n:int) : int
      {
         var xl:int = 0;
         var xh:int = 0;
         var l:int = 0;
         var h:int = 0;
         var m:int = 0;
         xl = x & 0x7FFF;
         xh = x >> 15;
         while(--n >= 0)
         {
            l = bi_internal::a[i] & 0x7FFF;
            h = bi_internal::a[i++] >> 15;
            m = xh * l + h * xl;
            l = xl * l + ((m & 0x7FFF) << 15) + w.bi_internal::a[j] + (c & 0x3FFFFFFF);
            c = (l >>> 30) + (m >>> 15) + xh * h + (c >>> 30);
            var _loc12_:* = j++;
            w.bi_internal::a[_loc12_] = l & 0x3FFFFFFF;
         }
         return c;
      }
      
      bi_internal function drShiftTo(n:int, r:BigInteger) : void
      {
         var i:int = 0;
         for(i = n; i < t; i++)
         {
            r.bi_internal::a[i - n] = bi_internal::a[i];
         }
         r.t = Math.max(t - n,0);
         r.bi_internal::s = bi_internal::s;
      }
      
      public function add(a:BigInteger) : BigInteger
      {
         var r:BigInteger = null;
         r = new BigInteger();
         addTo(a,r);
         return r;
      }
      
      bi_internal function multiplyUpperTo(a:BigInteger, n:int, r:BigInteger) : void
      {
         var i:int = 0;
         n--;
         i = r.t = t + a.t - n;
         r.bi_internal::s = 0;
         while(--i >= 0)
         {
            r.bi_internal::a[i] = 0;
         }
         for(i = Math.max(n - t,0); i < a.t; i++)
         {
            r.bi_internal::a[t + i - n] = bi_internal::am(n - i,a.bi_internal::a[i],r,0,0,t + i - n);
         }
         r.bi_internal::clamp();
         r.bi_internal::drShiftTo(1,r);
      }
      
      protected function nbi() : *
      {
         return new BigInteger();
      }
      
      protected function millerRabin(t:int) : Boolean
      {
         var n1:BigInteger = null;
         var k:int = 0;
         var r:BigInteger = null;
         var a:BigInteger = null;
         var i:int = 0;
         var y:BigInteger = null;
         var j:int = 0;
         n1 = subtract(BigInteger.ONE);
         k = n1.getLowestSetBit();
         if(k <= 0)
         {
            return false;
         }
         r = n1.shiftRight(k);
         t = t + 1 >> 1;
         if(t > lowprimes.length)
         {
            t = int(lowprimes.length);
         }
         a = new BigInteger();
         for(i = 0; i < t; i++)
         {
            a.bi_internal::fromInt(lowprimes[i]);
            y = a.modPow(r,this);
            if(y.compareTo(BigInteger.ONE) != 0 && y.compareTo(n1) != 0)
            {
               j = 1;
               while(j++ < k && y.compareTo(n1) != 0)
               {
                  y = y.modPowInt(2,this);
                  if(y.compareTo(BigInteger.ONE) == 0)
                  {
                     return false;
                  }
               }
               if(y.compareTo(n1) != 0)
               {
                  return false;
               }
            }
         }
         return true;
      }
      
      bi_internal function dMultiply(n:int) : void
      {
         bi_internal::a[t] = bi_internal::am(0,n - 1,this,0,0,t);
         ++t;
         bi_internal::clamp();
      }
      
      private function op_andnot(x:int, y:int) : int
      {
         return x & ~y;
      }
      
      bi_internal function clamp() : void
      {
         var c:int = 0;
         c = bi_internal::s & DM;
         while(t > 0 && bi_internal::a[t - 1] == c)
         {
            --t;
         }
      }
      
      bi_internal function invDigit() : int
      {
         var x:int = 0;
         var y:int = 0;
         if(t < 1)
         {
            return 0;
         }
         x = int(bi_internal::a[0]);
         if((x & 1) == 0)
         {
            return 0;
         }
         y = x & 3;
         y = y * (2 - (x & 0x0F) * y) & 0x0F;
         y = y * (2 - (x & 0xFF) * y) & 0xFF;
         y = y * (2 - ((x & 0xFFFF) * y & 0xFFFF)) & 0xFFFF;
         y = y * (2 - x * y % DV) % DV;
         return y > 0 ? DV - y : int(-y);
      }
      
      protected function changeBit(n:int, op:Function) : BigInteger
      {
         var r:BigInteger = null;
         r = BigInteger.ONE.shiftLeft(n);
         bitwiseTo(r,op,r);
         return r;
      }
      
      public function equals(a:BigInteger) : Boolean
      {
         return compareTo(a) == 0;
      }
      
      public function compareTo(v:BigInteger) : int
      {
         var r:int = 0;
         var i:int = 0;
         r = bi_internal::s - v.bi_internal::s;
         if(r != 0)
         {
            return r;
         }
         i = t;
         r = i - v.t;
         if(r != 0)
         {
            return r;
         }
         while(--i >= 0)
         {
            r = bi_internal::a[i] - v.bi_internal::a[i];
            if(r != 0)
            {
               return r;
            }
         }
         return 0;
      }
      
      public function shiftRight(n:int) : BigInteger
      {
         var r:BigInteger = null;
         r = new BigInteger();
         if(n < 0)
         {
            bi_internal::lShiftTo(-n,r);
         }
         else
         {
            bi_internal::rShiftTo(n,r);
         }
         return r;
      }
      
      bi_internal function multiplyTo(v:BigInteger, r:BigInteger) : void
      {
         var x:BigInteger = null;
         var y:BigInteger = null;
         var i:int = 0;
         x = abs();
         y = v.abs();
         i = x.t;
         r.t = i + y.t;
         while(--i >= 0)
         {
            r.bi_internal::a[i] = 0;
         }
         for(i = 0; i < y.t; i++)
         {
            r.bi_internal::a[i + x.t] = x.bi_internal::am(0,y.bi_internal::a[i],r,i,0,x.t);
         }
         r.bi_internal::s = 0;
         r.bi_internal::clamp();
         if(bi_internal::s != v.bi_internal::s)
         {
            ZERO.bi_internal::subTo(r,r);
         }
      }
      
      public function bitCount() : int
      {
         var r:int = 0;
         var x:int = 0;
         var i:int = 0;
         r = 0;
         x = bi_internal::s & DM;
         for(i = 0; i < t; i++)
         {
            r += cbit(bi_internal::a[i] ^ x);
         }
         return r;
      }
      
      public function byteValue() : int
      {
         return t == 0 ? bi_internal::s : bi_internal::a[0] << 24 >> 24;
      }
      
      private function cbit(x:int) : int
      {
         var r:uint = 0;
         for(r = 0; x != 0; )
         {
            x &= x - 1;
            r++;
         }
         return r;
      }
      
      bi_internal function rShiftTo(n:int, r:BigInteger) : void
      {
         var ds:int = 0;
         var bs:int = 0;
         var cbs:int = 0;
         var bm:int = 0;
         var i:int = 0;
         r.bi_internal::s = bi_internal::s;
         ds = n / DB;
         if(ds >= t)
         {
            r.t = 0;
            return;
         }
         bs = n % DB;
         cbs = DB - bs;
         bm = (1 << bs) - 1;
         r.bi_internal::a[0] = bi_internal::a[ds] >> bs;
         for(i = ds + 1; i < t; i++)
         {
            r.bi_internal::a[i - ds - 1] |= (bi_internal::a[i] & bm) << cbs;
            r.bi_internal::a[i - ds] = bi_internal::a[i] >> bs;
         }
         if(bs > 0)
         {
            r.bi_internal::a[t - ds - 1] |= (bi_internal::s & bm) << cbs;
         }
         r.t = t - ds;
         r.bi_internal::clamp();
      }
      
      public function modInverse(m:BigInteger) : BigInteger
      {
         var ac:Boolean = false;
         var u:BigInteger = null;
         var v:BigInteger = null;
         var a:BigInteger = null;
         var b:BigInteger = null;
         var c:BigInteger = null;
         var d:BigInteger = null;
         ac = m.bi_internal::isEven();
         if(bi_internal::isEven() && ac || m.sigNum() == 0)
         {
            return BigInteger.ZERO;
         }
         u = m.clone();
         v = clone();
         a = nbv(1);
         b = nbv(0);
         c = nbv(0);
         d = nbv(1);
         while(u.sigNum() != 0)
         {
            while(u.bi_internal::isEven())
            {
               u.bi_internal::rShiftTo(1,u);
               if(ac)
               {
                  if(!a.bi_internal::isEven() || !b.bi_internal::isEven())
                  {
                     a.addTo(this,a);
                     b.bi_internal::subTo(m,b);
                  }
                  a.bi_internal::rShiftTo(1,a);
               }
               else if(!b.bi_internal::isEven())
               {
                  b.bi_internal::subTo(m,b);
               }
               b.bi_internal::rShiftTo(1,b);
            }
            while(v.bi_internal::isEven())
            {
               v.bi_internal::rShiftTo(1,v);
               if(ac)
               {
                  if(!c.bi_internal::isEven() || !d.bi_internal::isEven())
                  {
                     c.addTo(this,c);
                     d.bi_internal::subTo(m,d);
                  }
                  c.bi_internal::rShiftTo(1,c);
               }
               else if(!d.bi_internal::isEven())
               {
                  d.bi_internal::subTo(m,d);
               }
               d.bi_internal::rShiftTo(1,d);
            }
            if(u.compareTo(v) >= 0)
            {
               u.bi_internal::subTo(v,u);
               if(ac)
               {
                  a.bi_internal::subTo(c,a);
               }
               b.bi_internal::subTo(d,b);
            }
            else
            {
               v.bi_internal::subTo(u,v);
               if(ac)
               {
                  c.bi_internal::subTo(a,c);
               }
               d.bi_internal::subTo(b,d);
            }
         }
         if(v.compareTo(BigInteger.ONE) != 0)
         {
            return BigInteger.ZERO;
         }
         if(d.compareTo(m) >= 0)
         {
            return d.subtract(m);
         }
         if(d.sigNum() < 0)
         {
            d.addTo(m,d);
            if(d.sigNum() < 0)
            {
               return d.add(m);
            }
            return d;
         }
         return d;
      }
      
      bi_internal function fromArray(value:ByteArray, length:int) : void
      {
         var p:int = 0;
         var i:int = 0;
         var sh:int = 0;
         var k:int = 0;
         var x:int = 0;
         p = int(value.position);
         i = p + length;
         sh = 0;
         k = 8;
         t = 0;
         bi_internal::s = 0;
         while(--i >= p)
         {
            x = i < value.length ? int(value[i]) : 0;
            if(sh == 0)
            {
               var _loc8_:* = t++;
               bi_internal::a[_loc8_] = x;
            }
            else if(sh + k > DB)
            {
               bi_internal::a[t - 1] |= (x & (1 << DB - sh) - 1) << sh;
               _loc8_ = t++;
               bi_internal::a[_loc8_] = x >> DB - sh;
            }
            else
            {
               bi_internal::a[t - 1] |= x << sh;
            }
            sh += k;
            if(sh >= DB)
            {
               sh -= DB;
            }
         }
         bi_internal::clamp();
         value.position = Math.min(p + length,value.length);
      }
      
      bi_internal function copyTo(r:BigInteger) : void
      {
         var i:int = 0;
         for(i = t - 1; i >= 0; i--)
         {
            r.bi_internal::a[i] = bi_internal::a[i];
         }
         r.t = t;
         r.bi_internal::s = bi_internal::s;
      }
      
      public function intValue() : int
      {
         if(bi_internal::s < 0)
         {
            if(t == 1)
            {
               return bi_internal::a[0] - DV;
            }
            if(t == 0)
            {
               return -1;
            }
         }
         else
         {
            if(t == 1)
            {
               return bi_internal::a[0];
            }
            if(t == 0)
            {
               return 0;
            }
         }
         return (bi_internal::a[1] & (1 << 32 - DB) - 1) << DB | bi_internal::a[0];
      }
      
      public function min(a:BigInteger) : BigInteger
      {
         return compareTo(a) < 0 ? this : a;
      }
      
      public function bitLength() : int
      {
         if(t <= 0)
         {
            return 0;
         }
         return DB * (t - 1) + bi_internal::nbits(bi_internal::a[t - 1] ^ bi_internal::s & DM);
      }
      
      public function shortValue() : int
      {
         return t == 0 ? bi_internal::s : bi_internal::a[0] << 16 >> 16;
      }
      
      public function and(a:BigInteger) : BigInteger
      {
         var r:BigInteger = null;
         r = new BigInteger();
         bitwiseTo(a,op_and,r);
         return r;
      }
      
      protected function toRadix(b:uint = 10) : String
      {
         var cs:int = 0;
         var a:Number = NaN;
         var d:BigInteger = null;
         var y:BigInteger = null;
         var z:BigInteger = null;
         var r:String = null;
         if(sigNum() == 0 || b < 2 || b > 32)
         {
            return "0";
         }
         cs = chunkSize(b);
         a = Math.pow(b,cs);
         d = nbv(a);
         y = nbi();
         z = nbi();
         r = "";
         bi_internal::divRemTo(d,y,z);
         while(y.sigNum() > 0)
         {
            r = (a + z.intValue()).toString(b).substr(1) + r;
            y.bi_internal::divRemTo(d,y,z);
         }
         return z.intValue().toString(b) + r;
      }
      
      public function not() : BigInteger
      {
         var r:BigInteger = null;
         var i:int = 0;
         r = new BigInteger();
         for(i = 0; i < t; i++)
         {
            r[i] = DM & ~bi_internal::a[i];
         }
         r.t = t;
         r.bi_internal::s = ~bi_internal::s;
         return r;
      }
      
      bi_internal function subTo(v:BigInteger, r:BigInteger) : void
      {
         var i:int = 0;
         var c:int = 0;
         var m:int = 0;
         i = 0;
         c = 0;
         m = Math.min(v.t,t);
         while(i < m)
         {
            c += bi_internal::a[i] - v.bi_internal::a[i];
            var _loc6_:* = i++;
            r.bi_internal::a[_loc6_] = c & DM;
            c >>= DB;
         }
         if(v.t < t)
         {
            c -= v.bi_internal::s;
            while(i < t)
            {
               c += bi_internal::a[i];
               _loc6_ = i++;
               r.bi_internal::a[_loc6_] = c & DM;
               c >>= DB;
            }
            c += bi_internal::s;
         }
         else
         {
            c += bi_internal::s;
            while(i < v.t)
            {
               c -= v.bi_internal::a[i];
               _loc6_ = i++;
               r.bi_internal::a[_loc6_] = c & DM;
               c >>= DB;
            }
            c -= v.bi_internal::s;
         }
         r.bi_internal::s = c < 0 ? -1 : 0;
         if(c < -1)
         {
            _loc6_ = i++;
            r.bi_internal::a[_loc6_] = DV + c;
         }
         else if(c > 0)
         {
            _loc6_ = i++;
            r.bi_internal::a[_loc6_] = c;
         }
         r.t = i;
         r.bi_internal::clamp();
      }
      
      public function clone() : BigInteger
      {
         var r:BigInteger = null;
         r = new BigInteger();
         this.bi_internal::copyTo(r);
         return r;
      }
      
      public function pow(e:int) : BigInteger
      {
         return bi_internal::exp(e,new NullReduction());
      }
      
      public function flipBit(n:int) : BigInteger
      {
         return changeBit(n,op_xor);
      }
      
      public function xor(a:BigInteger) : BigInteger
      {
         var r:BigInteger = null;
         r = new BigInteger();
         bitwiseTo(a,op_xor,r);
         return r;
      }
      
      public function or(a:BigInteger) : BigInteger
      {
         var r:BigInteger = null;
         r = new BigInteger();
         bitwiseTo(a,op_or,r);
         return r;
      }
      
      public function max(a:BigInteger) : BigInteger
      {
         return compareTo(a) > 0 ? this : a;
      }
      
      bi_internal function fromInt(value:int) : void
      {
         t = 1;
         bi_internal::s = value < 0 ? -1 : 0;
         if(value > 0)
         {
            bi_internal::a[0] = value;
         }
         else if(value < -1)
         {
            bi_internal::a[0] = value + DV;
         }
         else
         {
            t = 0;
         }
      }
      
      bi_internal function isEven() : Boolean
      {
         return (t > 0 ? bi_internal::a[0] & 1 : bi_internal::s) == 0;
      }
      
      public function toString(radix:Number = 16) : String
      {
         var k:int = 0;
         var km:int = 0;
         var d:int = 0;
         var m:Boolean = false;
         var r:String = null;
         var i:int = 0;
         var p:int = 0;
         if(bi_internal::s < 0)
         {
            return "-" + negate().toString(radix);
         }
         switch(radix)
         {
            case 2:
               k = 1;
               break;
            case 4:
               k = 2;
               break;
            case 8:
               k = 3;
               break;
            case 16:
               k = 4;
               break;
            case 32:
               k = 5;
         }
         km = (1 << k) - 1;
         d = 0;
         m = false;
         r = "";
         i = t;
         p = DB - i * DB % k;
         if(i-- > 0)
         {
            if(p < DB && (d = bi_internal::a[i] >> p) > 0)
            {
               m = true;
               r = d.toString(36);
            }
            while(i >= 0)
            {
               if(p < k)
               {
                  d = (bi_internal::a[i] & (1 << p) - 1) << k - p;
                  d |= bi_internal::a[--i] >> (p = p + (DB - k));
               }
               else
               {
                  d = bi_internal::a[i] >> (p = p - k) & km;
                  if(p <= 0)
                  {
                     p += DB;
                     i--;
                  }
               }
               if(d > 0)
               {
                  m = true;
               }
               if(m)
               {
                  r += d.toString(36);
               }
            }
         }
         return m ? r : "0";
      }
      
      public function setBit(n:int) : BigInteger
      {
         return changeBit(n,op_or);
      }
      
      public function abs() : BigInteger
      {
         return bi_internal::s < 0 ? negate() : this;
      }
      
      bi_internal function nbits(x:int) : int
      {
         var r:int = 0;
         var t:int = 0;
         r = 1;
         t = x >>> 16;
         if(t != 0)
         {
            x = t;
            r += 16;
         }
         t = x >> 8;
         if(t != 0)
         {
            x = t;
            r += 8;
         }
         t = x >> 4;
         if(t != 0)
         {
            x = t;
            r += 4;
         }
         t = x >> 2;
         if(t != 0)
         {
            x = t;
            r += 2;
         }
         t = x >> 1;
         if(t != 0)
         {
            x = t;
            r += 1;
         }
         return r;
      }
      
      public function sigNum() : int
      {
         if(bi_internal::s < 0)
         {
            return -1;
         }
         if(t <= 0 || t == 1 && bi_internal::a[0] <= 0)
         {
            return 0;
         }
         return 1;
      }
      
      public function toByteArray() : ByteArray
      {
         var i:int = 0;
         var r:ByteArray = null;
         var p:int = 0;
         var d:int = 0;
         var k:int = 0;
         i = t;
         r = new ByteArray();
         r[0] = bi_internal::s;
         p = DB - i * DB % 8;
         k = 0;
         if(i-- > 0)
         {
            if(p < DB && (d = bi_internal::a[i] >> p) != (bi_internal::s & DM) >> p)
            {
               var _loc6_:* = k++;
               r[_loc6_] = d | bi_internal::s << DB - p;
            }
            while(i >= 0)
            {
               if(p < 8)
               {
                  d = (bi_internal::a[i] & (1 << p) - 1) << 8 - p;
                  d |= bi_internal::a[--i] >> (p = p + (DB - 8));
               }
               else
               {
                  d = bi_internal::a[i] >> (p = p - 8) & 0xFF;
                  if(p <= 0)
                  {
                     p += DB;
                     i--;
                  }
               }
               if((d & 0x80) != 0)
               {
                  d |= -256;
               }
               if(k == 0 && (bi_internal::s & 0x80) != (d & 0x80))
               {
                  k++;
               }
               if(k > 0 || d != bi_internal::s)
               {
                  _loc6_ = k++;
                  r[_loc6_] = d;
               }
            }
         }
         return r;
      }
      
      bi_internal function squareTo(r:BigInteger) : void
      {
         var x:BigInteger = null;
         var i:int = 0;
         var c:int = 0;
         x = abs();
         for(i = r.t = 2 * x.t; --i >= 0; )
         {
            r.bi_internal::a[i] = 0;
         }
         for(i = 0; i < x.t - 1; i++)
         {
            c = x.bi_internal::am(i,x.bi_internal::a[i],r,2 * i,0,1);
            if((r.bi_internal::a[i + x.t] = r.bi_internal::a[i + x.t] + x.bi_internal::am(i + 1,2 * x.bi_internal::a[i],r,2 * i + 1,c,x.t - i - 1)) >= DV)
            {
               r.bi_internal::a[i + x.t] -= DV;
               r.bi_internal::a[i + x.t + 1] = 1;
            }
         }
         if(r.t > 0)
         {
            r.bi_internal::a[r.t - 1] += x.bi_internal::am(i,x.bi_internal::a[i],r,2 * i,0,1);
         }
         r.bi_internal::s = 0;
         r.bi_internal::clamp();
      }
      
      private function op_and(x:int, y:int) : int
      {
         return x & y;
      }
      
      protected function fromRadix(s:String, b:int = 10) : void
      {
         var cs:int = 0;
         var d:Number = NaN;
         var mi:Boolean = false;
         var j:int = 0;
         var w:int = 0;
         var i:int = 0;
         var x:int = 0;
         bi_internal::fromInt(0);
         cs = chunkSize(b);
         d = Math.pow(b,cs);
         mi = false;
         j = 0;
         w = 0;
         for(i = 0; i < s.length; i++)
         {
            x = bi_internal::intAt(s,i);
            if(x < 0)
            {
               if(s.charAt(i) == "-" && sigNum() == 0)
               {
                  mi = true;
               }
            }
            else
            {
               w = b * w + x;
               if(++j >= cs)
               {
                  bi_internal::dMultiply(d);
                  bi_internal::dAddOffset(w,0);
                  j = 0;
                  w = 0;
               }
            }
         }
         if(j > 0)
         {
            bi_internal::dMultiply(Math.pow(b,j));
            bi_internal::dAddOffset(w,0);
         }
         if(mi)
         {
            BigInteger.ZERO.bi_internal::subTo(this,this);
         }
      }
      
      bi_internal function dlShiftTo(n:int, r:BigInteger) : void
      {
         var i:int = 0;
         for(i = t - 1; i >= 0; i--)
         {
            r.bi_internal::a[i + n] = bi_internal::a[i];
         }
         for(i = n - 1; i >= 0; i--)
         {
            r.bi_internal::a[i] = 0;
         }
         r.t = t + n;
         r.bi_internal::s = bi_internal::s;
      }
      
      private function op_xor(x:int, y:int) : int
      {
         return x ^ y;
      }
   }
}

