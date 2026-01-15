package game.animations
{
   import com.greensock.TimelineMax;
   import com.greensock.TweenMax;
   import com.greensock.TweenProxy;
   import com.pickgliss.ui.core.Disposeable;
   import ddt.utils.BitmapUtils;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.filters.GlowFilter;
   
   public class ScaleEffect extends Sprite implements Disposeable
   {
      
      private var src1:Bitmap;
      
      private var src2:Bitmap;
      
      private var mainTimeLine:TimelineMax;
      
      private var tp1:TweenProxy;
      
      private var tp2:TweenProxy;
      
      public function ScaleEffect(type:int, srcBmd:BitmapData, dir:int = 1)
      {
         var bmd:BitmapData = null;
         super();
         bmd = srcBmd.clone();
         BitmapUtils.reverseBtimapData(bmd);
         scaleX = dir;
         graphics.beginFill(0,0);
         graphics.drawRect(0,0,1000,600);
         graphics.endFill();
         mouseChildren = false;
         mouseEnabled = false;
         this.mainTimeLine = new TimelineMax({"useFrames":true});
         if(type == 1)
         {
            this.runScale(bmd);
         }
         else if(type == 2)
         {
            this.runDownToUp(bmd);
         }
         else if(type == 3)
         {
            this.runRightToLeft(bmd);
         }
         else if(type == 4)
         {
            this.centerToScale(bmd);
         }
      }
      
      private function runScale(srcBmd:BitmapData) : void
      {
         this.src1 = new Bitmap(srcBmd,"auto",true);
         this.src2 = new Bitmap(srcBmd,"auto",true);
         addChild(this.src1);
         addChild(this.src2);
         this.src1.filters = this.src2.filters = [new GlowFilter(16763904,1,38,38,0.3)];
         this.tp1 = new TweenProxy(this.src1);
         this.tp1.registrationX = this.src1.width / 2;
         this.tp1.registrationY = this.src1.height / 2;
         this.tp2 = new TweenProxy(this.src2);
         this.tp2.registrationX = this.src2.width / 2;
         this.tp2.registrationY = this.src2.height / 2;
         this.tp1.x = this.tp2.x = -50;
         this.tp1.y = this.tp2.y = 750;
         this.tp1.alpha = this.tp2.alpha = 0;
         this.tp1.scaleX = this.tp1.scaleY = this.tp2.scaleX = this.tp2.scaleY = 1;
         var tw1:Array = TweenMax.allTo([this.tp1,this.tp2],4,{
            "x":170,
            "y":320,
            "alpha":0.7,
            "scaleX":1.6,
            "scaleY":1.6
         });
         var arr:Array = TweenMax.allTo([this.tp1,this.tp2],30,{
            "scaleX":1.7,
            "scaleY":1.7,
            "x":170,
            "y":290
         });
         var arr1:Array = TweenMax.allTo([this.tp1,this.tp2],4,{
            "scaleX":3,
            "scaleY":3,
            "alpha":0
         },1);
         this.mainTimeLine.appendMultiple(tw1);
         this.mainTimeLine.appendMultiple(arr);
         this.mainTimeLine.appendMultiple(arr1);
      }
      
      private function runUpToDown(srcBmd:BitmapData) : void
      {
         var sp:Shape = new Shape();
         sp.graphics.beginFill(0,1);
         sp.graphics.drawRect(0,0,1000,100);
         sp.graphics.drawRect(0,500,1000,100);
         sp.graphics.endFill();
         this.src1 = new Bitmap(srcBmd,"auto",true);
         addChild(this.src1);
         this.tp1 = new TweenProxy(this.src1);
         this.tp1.registrationX = this.src1.width / 2;
         this.tp1.registrationY = this.src1.height / 2;
         this.tp1.x = 250;
         this.tp1.y = 0;
         this.tp1.scale = 2;
         var tw1:Array = TweenMax.allTo([this.tp1],4,{
            "alpha":1,
            "y":250
         });
         var tw2:Array = TweenMax.allTo([this.tp1],40,{"y":290});
         var tw3:Array = TweenMax.allTo([this.tp1],4,{
            "alpha":0,
            "y":700
         });
         this.mainTimeLine.appendMultiple(tw1);
         this.mainTimeLine.appendMultiple(tw2);
         this.mainTimeLine.appendMultiple(tw3);
      }
      
      private function runRightToLeft(srcBmd:BitmapData) : void
      {
         this.src1 = new Bitmap(srcBmd,"auto",true);
         addChild(this.src1);
         this.tp1 = new TweenProxy(this.src1);
         this.tp1.registrationX = this.src1.width / 2;
         this.tp1.registrationY = this.src1.height / 2;
         this.tp1.x = 1200;
         this.tp1.y = 270;
         this.tp1.alpha = 1;
         var tw1:TweenMax = TweenMax.to(this.tp1,8,{
            "x":170,
            "alpha":1,
            "scaleX":1.8,
            "scaleY":1.8
         });
         var tw2:TweenMax = TweenMax.to(this.tp1,26,{"x":150});
         var tw3:TweenMax = TweenMax.to(this.tp1,4,{
            "x":0,
            "alpha":0
         });
         this.mainTimeLine.append(tw1);
         this.mainTimeLine.append(tw2);
         this.mainTimeLine.append(tw3);
      }
      
      private function changeRegist() : void
      {
         this.tp1.registrationX = this.src1.width;
         this.tp1.registrationY = this.src1.height;
      }
      
      private function runDownToUp(srcBmd:BitmapData) : void
      {
         this.src1 = new Bitmap(srcBmd,"auto",true);
         addChild(this.src1);
         this.tp1 = new TweenProxy(this.src1);
         this.tp1.registrationX = this.src1.width / 2;
         this.tp1.registrationY = this.src1.height / 2;
         this.tp1.x = 170;
         this.tp1.y = 1000;
         this.tp1.scale = 2;
         var tw1:Array = TweenMax.allTo([this.tp1],4,{
            "alpha":1,
            "y":290
         });
         var tw2:Array = TweenMax.allTo([this.tp1],22,{"y":250});
         var tw3:Array = TweenMax.allTo([this.tp1],4,{
            "alpha":0,
            "y":-100
         });
         this.mainTimeLine.appendMultiple(tw1,8);
         this.mainTimeLine.appendMultiple(tw2);
         this.mainTimeLine.appendMultiple(tw3);
      }
      
      private function runLeftToRight(srcBmd:BitmapData) : void
      {
         this.src1 = new Bitmap(srcBmd,"auto",true);
         addChild(this.src1);
         this.tp1 = new TweenProxy(this.src1);
         this.tp1.registrationX = this.src1.width / 2;
         this.tp1.registrationY = this.src1.height / 2;
         this.tp1.x = 0;
         this.tp1.y = 270;
         this.tp1.scaleY = 1.8;
         this.tp1.scaleX = 1.8;
         this.tp1.alpha = 0.5;
         var tw1:TweenMax = TweenMax.to(this.tp1,3,{
            "x":220,
            "alpha":0.8
         });
         var tw2:TweenMax = TweenMax.to(this.tp1,24,{
            "scaleX":2.1,
            "scaleY":2.1,
            "x":240
         });
         var tw3:TweenMax = TweenMax.to(this.tp1,5,{
            "scaleX":4,
            "scaleY":4,
            "alpha":0
         });
         this.mainTimeLine.append(tw1);
         this.mainTimeLine.append(tw2);
         this.mainTimeLine.append(tw3);
      }
      
      private function centerToScale(srcBmd:BitmapData) : void
      {
         this.src1 = new Bitmap(srcBmd,"auto",true);
         this.src2 = new Bitmap(srcBmd,"auto",true);
         addChild(this.src1);
         addChild(this.src2);
         this.src1.filters = this.src2.filters = [new GlowFilter(16763904,1,40,40,0.3)];
         this.tp1 = new TweenProxy(this.src1);
         this.tp1.registrationX = this.src1.width / 2;
         this.tp1.registrationY = this.src1.height / 2;
         this.tp2 = new TweenProxy(this.src2);
         this.tp2.registrationX = this.src2.width / 2;
         this.tp2.registrationY = this.src2.height / 2;
         this.tp1.x = this.tp2.x = 170;
         this.tp1.y = this.tp2.y = 270;
         this.tp1.scaleX = this.tp1.scaleY = this.tp2.scaleX = this.tp2.scaleY = 0;
         this.tp1.alpha = this.tp2.alpha = 0.2;
         var tw1:Array = TweenMax.allTo([this.tp1,this.tp2],6,{
            "scaleX":2,
            "scaleY":2,
            "alpha":0.8
         });
         var tw5:Array = TweenMax.allTo([this.tp1,this.tp2],28,{
            "scaleX":2.2,
            "scaleY":2.2
         });
         var tw6:Array = TweenMax.allTo([this.tp1,this.tp2],4,{
            "scaleX":3,
            "scaleY":3,
            "alpha":0
         },2);
         this.mainTimeLine.appendMultiple(tw1);
         this.mainTimeLine.appendMultiple(tw5);
         this.mainTimeLine.appendMultiple(tw6);
      }
      
      public function dispose() : void
      {
         this.mainTimeLine.complete(true);
         this.mainTimeLine = null;
         this.tp1 = null;
         this.tp2 = null;
         if(Boolean(this.src1))
         {
            if(Boolean(this.src1.parent))
            {
               this.src1.parent.removeChild(this.src1);
            }
            try
            {
               this.src1.bitmapData.dispose();
            }
            catch(e:Error)
            {
            }
            this.src1 = null;
         }
         if(Boolean(this.src2))
         {
            if(Boolean(this.src2.parent))
            {
               this.src2.parent.removeChild(this.src2);
            }
            try
            {
               this.src2.bitmapData.dispose();
            }
            catch(e:Error)
            {
            }
            this.src2 = null;
         }
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

