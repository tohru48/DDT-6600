package ddt.utils
{
   import flash.display.BitmapData;
   import flash.display.BlendMode;
   import flash.display.DisplayObject;
   import flash.display.Shape;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.geom.ColorTransform;
   import flash.geom.Rectangle;
   import flash.utils.Timer;
   
   public class BitmapUtils
   {
      
      private static var _maskShape:Shape;
      
      private static var _curX:Number;
      
      private static var _curY:Number;
      
      private static var _rowNumber:Number;
      
      private static var _rowWitdh:Number;
      
      private static var _rowHeight:Number;
      
      private static var _frameStep:Number;
      
      private static var _callBack:Function;
      
      private static var _timer:Timer;
      
      private static var _isMask:String;
      
      private static var _curRow:Number = 0;
      
      private static var _sleepSecond:int = 0;
      
      public function BitmapUtils()
      {
         super();
      }
      
      public static function updateColor(source:BitmapData, color:Number) : BitmapData
      {
         if(!source || isNaN(color))
         {
            return source;
         }
         var _bitmapData:BitmapData = new BitmapData(source.width,source.height,true,0);
         var t:BitmapData = source.clone();
         var ct1:ColorTransform = getHightlightColorTransfrom(color);
         if(Boolean(ct1))
         {
            t.draw(source,null,ct1,null,null,true);
         }
         _bitmapData.draw(source,null,getColorTransfromByColor(color));
         _bitmapData.draw(t,null,null,BlendMode.HARDLIGHT);
         t.dispose();
         t = null;
         return _bitmapData;
      }
      
      public static function getHightlightColorTransfrom(color:uint) : ColorTransform
      {
         var r:uint = uint(color >> 16 & 0xFF);
         var g:uint = uint(color >> 8 & 0xFF);
         var b:uint = uint(color & 0xFF);
         var a:uint = uint(color >> 24 & 0xFF);
         var r1:int = int(r);
         var g1:int = int(g);
         var b1:int = int(b);
         var d:Boolean = false;
         if(!(r1 == g1 || r1 == b1 || g1 == b1))
         {
            if(r1 > g1)
            {
               if(r1 > b1)
               {
                  r1 = 50;
                  g1 = 0;
                  b1 = 0;
                  d = true;
               }
               else
               {
                  r1 = 0;
                  g1 = 0;
                  b1 = 50;
                  d = true;
               }
            }
            else if(g1 > b1)
            {
               r1 = 10;
               g1 = 30;
               b1 = 30;
               d = true;
            }
            else
            {
               r1 = 0;
               g1 = 0;
               b1 = 50;
               d = true;
            }
         }
         if(d)
         {
            return new ColorTransform(1,1,1,1,r1,g1,b1,0);
         }
         return null;
      }
      
      public static function setBitmapDataGray(src:BitmapData) : void
      {
         var color:uint = 0;
         var p:Vector.<uint> = src.getVector(src.rect);
         var l:uint = p.length;
         for(var i:uint = 0; i < l; i++)
         {
            color = uint(p[i] << 16 >>> 24);
            p[i] = color << 16 | color << 8 | color;
         }
         src.setVector(src.rect,p);
      }
      
      public static function getColorTransfromByColor(color:uint) : ColorTransform
      {
         var r:uint = uint(color >> 16 & 0xFF);
         var g:uint = uint(color >> 8 & 0xFF);
         var b:uint = uint(color & 0xFF);
         var a:uint = uint(color >> 24 & 0xFF);
         if(!(r == g || r == b || g == b))
         {
            if(r < g && r < b)
            {
               if(g < b)
               {
                  g += 40;
                  b += 10;
               }
               else
               {
                  g += 40;
                  b += 10;
               }
            }
            else if(g < r && g < b)
            {
               if(r < b)
               {
                  r += 40;
                  b += 10;
               }
               else
               {
                  r += 40;
                  b += 10;
               }
            }
            else if(b < g && b < r)
            {
               if(g < r)
               {
                  g += 40;
                  r += 10;
               }
               else
               {
                  g += 40;
                  r += 10;
               }
            }
         }
         return new ColorTransform(0,0,0,1,r,g,b,0);
      }
      
      public static function maskMovie(source:DisplayObject, maskShape:Shape, isMask:String, rowNumber:Number, rowWitdh:Number, rowHeight:Number, frameStep:Number, sleepSecond:int, callBack:Function) : void
      {
         if(!source && !source.parent)
         {
            return;
         }
         _callBack = callBack;
         _maskShape = maskShape;
         _isMask = isMask;
         _curX = 0;
         _curY = 0;
         _rowNumber = rowNumber;
         _rowWitdh = rowWitdh;
         _rowHeight = rowHeight;
         _sleepSecond = sleepSecond;
         _frameStep = frameStep;
         _curRow = 0;
         if(_isMask == "true")
         {
            source.parent.addChild(_maskShape);
            source.mask = _maskShape;
            _maskShape.addEventListener(Event.ENTER_FRAME,onMaskMovieEnerFrame);
         }
         else
         {
            source.mask = null;
            _timer = new Timer(_sleepSecond * 1000);
            _timer.addEventListener(TimerEvent.TIMER,onMaskMovieTimer);
            _timer.start();
         }
      }
      
      private static function onMaskMovieEnerFrame(evt:Event) : void
      {
         _maskShape.graphics.beginFill(0);
         _maskShape.graphics.drawRect(_curX,_curY,_frameStep,_rowHeight);
         _maskShape.graphics.endFill();
         _curX += _frameStep;
         if(_curX >= _rowWitdh)
         {
            ++_curRow;
            _curX = 0;
            _curY = _curRow * _rowHeight;
         }
         if(_curRow >= _rowNumber)
         {
            _maskShape.removeEventListener(Event.ENTER_FRAME,onMaskMovieEnerFrame);
            if(_callBack == null)
            {
               return;
            }
            if(_sleepSecond > 0)
            {
               _timer = new Timer(_sleepSecond * 1000);
               _timer.addEventListener(TimerEvent.TIMER,onMaskMovieTimer);
               _timer.start();
            }
            else
            {
               if(Boolean(_maskShape.parent))
               {
                  _maskShape.parent.removeChild(_maskShape);
               }
               _maskShape = null;
               _callBack();
            }
         }
      }
      
      private static function onMaskMovieTimer(evt:TimerEvent) : void
      {
         _timer.stop();
         _timer.removeEventListener(TimerEvent.TIMER_COMPLETE,onMaskMovieTimer);
         _timer = null;
         if(Boolean(_maskShape) && Boolean(_maskShape.parent))
         {
            _maskShape.parent.removeChild(_maskShape);
         }
         _maskShape = null;
         if(_callBack != null)
         {
            _callBack();
         }
      }
      
      public static function reverseBtimapData(src:BitmapData) : void
      {
         var w:int = src.width;
         var h:int = src.height;
         var pixels:Vector.<uint> = src.getVector(new Rectangle(0,0,w,h));
         for(var i:int = 0; i < h; i++)
         {
            src.setVector(new Rectangle(0,i,w,1),pixels.splice(0,w).reverse());
         }
      }
   }
}

