package game.view
{
   import bagAndInfo.cell.BaseCell;
   import com.greensock.TimelineLite;
   import com.greensock.TweenLite;
   import com.greensock.TweenMax;
   import com.greensock.easing.Bounce;
   import com.greensock.easing.Quint;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ClassUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.SoundManager;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.geom.Point;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   import road7th.utils.MovieClipWrapper;
   
   public class DropGoods implements Disposeable
   {
      
      public static var count:int;
      
      public static var isOver:Boolean = true;
      
      private var goodBox:MovieClip;
      
      private var bagMc:MovieClipWrapper;
      
      private var goldNumText:FilterFrameText;
      
      private var goods:DisplayObject;
      
      private var container:DisplayObjectContainer;
      
      private var goldNum:int;
      
      private var beginPoint:Point;
      
      private var midPoint:Point;
      
      private var endPoint:Point;
      
      private var headGlow:MovieClip;
      
      private var _type:int;
      
      private var timeId:uint;
      
      private var timeOutId:uint;
      
      public const MONSTER_DROP:int = 1;
      
      public const CHESTS_DROP:int = 2;
      
      private var _goodsId:int;
      
      private var currentCount:int;
      
      private var tweenUp:TweenMax;
      
      private var tweenDown:TweenMax;
      
      private var timeline:TimelineLite;
      
      public function DropGoods(_container:DisplayObjectContainer, _goods:DisplayObject, _beginPoint:Point, _endPoint:Point, _goldNum:int)
      {
         super();
         this.container = _container;
         this.goods = _goods;
         this.beginPoint = _beginPoint;
         this.endPoint = _endPoint;
         this.goldNum = _goldNum;
      }
      
      public function start(type:int = 1) : void
      {
         if(this.goods == null || this.beginPoint == null)
         {
            return;
         }
         this._type = type;
         this.goods.x = this.beginPoint.x;
         this.goods.y = this.beginPoint.y;
         this.container.addChild(this.goods);
         this.midPoint = this.getLinePoint(this.beginPoint);
         var p:Point = new Point(this.beginPoint.x - (this.beginPoint.x - this.midPoint.x) / 2,this.beginPoint.y - 200);
         this.goDown(this.midPoint,p);
         isOver = false;
      }
      
      private function getLinePoint(pot:Point) : Point
      {
         var k:int = 0;
         var point:Point = new Point();
         this._goodsId = count;
         if(this._type == this.MONSTER_DROP)
         {
            k = 3;
            point.y = pot.y - 30;
         }
         else if(this._type == this.CHESTS_DROP)
         {
            k = 2;
            point.y = pot.y + Math.random() * 90 + 10;
         }
         if(count % 2 == 0 && pot.x - 45 * count / k > pot.x - 350)
         {
            point.x = pot.x - 45 * count / k;
         }
         else if(count % 2 == 1 && pot.x + 45 * count / k < pot.x + 300)
         {
            point.x = pot.x + 45 * count / k;
         }
         else
         {
            point.x = Boolean(count % 2) ? pot.x + 45 * Math.random() * (count / k) : pot.x - 45 * Math.random() * (count / k);
         }
         if(this.container.localToGlobal(point).x < 100)
         {
            point.x = pot.x + 45 * count / k;
         }
         if(this.container.localToGlobal(point).x > 900)
         {
            point.x = pot.x - 45 * count / k;
         }
         ++count;
         return point;
      }
      
      private function goDown(p1:Point, p2:Point) : void
      {
         SoundManager.instance.play("170");
         if(this._type == this.MONSTER_DROP)
         {
            this.tweenDown = TweenMax.to(this.goods,1.2 + this._goodsId / 10,{
               "bezier":[{
                  "x":p2.x,
                  "y":p2.y
               },{
                  "x":p1.x,
                  "y":p1.y
               },{
                  "x":p1.x,
                  "y":p1.y
               }],
               "scaleX":1,
               "scaleY":1,
               "ease":Bounce.easeOut,
               "onComplete":this.__onCompleteGodown
            });
         }
         else if(this._type == this.CHESTS_DROP)
         {
            this.tweenDown = TweenMax.to(this.goods,1.2 + this._goodsId / 10,{
               "bezier":[{
                  "x":p2.x,
                  "y":p2.y
               },{
                  "x":p1.x,
                  "y":this.beginPoint.y - 10
               },{
                  "x":p1.x,
                  "y":p1.y
               }],
               "scaleX":1,
               "scaleY":1,
               "ease":Bounce.easeOut,
               "onComplete":this.__onCompleteGodown
            });
         }
      }
      
      private function __onCompleteGodown() : void
      {
         var p:Point = null;
         this.tweenDown.kill();
         this.tweenDown = null;
         if(this.goods == null)
         {
            return;
         }
         if(this._type == this.MONSTER_DROP)
         {
            p = new Point(this.midPoint.x - (this.midPoint.x - this.endPoint.x) / 2,this.midPoint.y - 100);
            this.goodBox = ClassUtils.CreatInstance("asset.game.GoodFlashBox") as MovieClip;
            this.timeOutId = setTimeout(this.goPackUp,500 + this._goodsId * 50,this.endPoint,p);
         }
         else if(this._type == this.CHESTS_DROP)
         {
            p = new Point(this.midPoint.x - (this.midPoint.x - this.endPoint.x) / 2,this.midPoint.y - 100);
            this.goodBox = ClassUtils.CreatInstance("asset.game.FlashLight") as MovieClip;
            this.timeOutId = setTimeout(this.goPackUp,600 + this._goodsId * 100,this.endPoint,p);
         }
         this.goodBox.x = this.goods.x;
         this.goodBox.y = this.goods.y;
         this.goods.x = 0;
         this.goods.y = 0;
         this.goodBox.gotoAndPlay(int(Math.random() * this.goodBox.totalFrames));
         this.goodBox.box.addChild(this.goods);
         this.container.addChild(this.goodBox);
         SoundManager.instance.play("172");
      }
      
      private function goPackUp(p1:Point, p2:Point) : void
      {
         var p:Point = null;
         var tl:TweenLite = null;
         clearTimeout(this.timeOutId);
         if(this.goods == null)
         {
            return;
         }
         if(this.container.contains(this.goodBox))
         {
            this.container.removeChild(this.goodBox);
         }
         this.goods.x = this.goodBox.x;
         this.goods.y = this.goodBox.y;
         if(this._type == this.MONSTER_DROP)
         {
            this.container.addChild(this.goods);
            this.tweenUp = TweenMax.to(this.goods,0.8,{
               "alpha":0,
               "scaleX":0.5,
               "scaleY":0.5,
               "bezierThrough":[{
                  "x":p2.x,
                  "y":p2.y
               },{
                  "x":p1.x,
                  "y":p1.y
               }],
               "ease":Quint.easeInOut,
               "orientToBezier":true,
               "onComplete":this.onCompletePackUp
            });
         }
         else if(this._type == this.CHESTS_DROP)
         {
            p = this.container.localToGlobal(new Point(this.goods.x,this.goods.y));
            this.goods.x = p.x;
            this.goods.y = p.y;
            this.container.stage.addChild(this.goods);
            p2 = this.container.localToGlobal(p2);
            p1 = new Point(650,550);
            this.tweenUp = TweenMax.to(this.goods,0.8,{
               "alpha":0.5,
               "scaleX":0.5,
               "scaleY":0.5,
               "bezierThrough":[{
                  "x":p2.x,
                  "y":p2.y
               },{
                  "x":p1.x,
                  "y":p1.y
               }],
               "ease":Quint.easeInOut,
               "orientToBezier":true,
               "onComplete":this.onCompletePackUp
            });
         }
         this.goldNumText = ComponentFactory.Instance.creatComponentByStylename("dropGoods.goldNumText");
         if(Boolean(this.goldNumText))
         {
            this.goldNumText.x = this.midPoint.x;
            this.goldNumText.y = this.midPoint.y;
            this.goldNumText.text = this.goldNum.toString();
            this.container.addChild(this.goldNumText);
            tl = TweenLite.to(this.goldNumText,1,{
               "y":this.midPoint.y - 200,
               "alpha":0,
               "onComplete":function():void
               {
                  tl.kill();
               }
            });
         }
      }
      
      private function onCompletePackUp() : void
      {
         var sp:Sprite = null;
         this.tweenUp.kill();
         this.tweenUp = null;
         if(this.goods == null)
         {
            return;
         }
         if(Boolean(this.goldNumText) && this.container.contains(this.goldNumText))
         {
            this.container.removeChild(this.goldNumText);
         }
         if(this._type == this.MONSTER_DROP)
         {
            this.timeline = new TimelineLite();
            if(this.goods is BaseCell)
            {
               sp = (this.goods as BaseCell).getContent();
               if(Boolean(sp))
               {
                  sp.x -= sp.width / 2;
                  sp.y -= sp.height / 2;
               }
            }
            this.headGlow = ClassUtils.CreatInstance("asset.game.HeadGlow") as MovieClip;
            this.headGlow.x = this.endPoint.x;
            this.headGlow.y = this.endPoint.y;
            this.container.addChild(this.headGlow);
            this.goods.rotationX = this.goods.rotationY = this.goods.rotationZ = 0;
            this.timeline.append(TweenLite.to(this.goods,0.2,{
               "alpha":1,
               "scaleX":0.8,
               "scaleY":0.8,
               "x":this.goods.x + 5,
               "y":this.goods.y - 50
            }));
            this.timeline.append(TweenLite.to(this.goods,0.4,{
               "y":this.goods.y - 150,
               "alpha":0.2,
               "rotationY":360 * 5,
               "onComplete":this.completeHead
            }));
         }
         else if(this._type == this.CHESTS_DROP)
         {
            if(Boolean(this.goods) && this.container.stage.contains(this.goods))
            {
               this.container.stage.removeChild(this.goods);
            }
            this.bagMc = this.getBagAniam();
            if(Boolean(this.bagMc.movie))
            {
               this.container.stage.addChild(this.bagMc.movie);
            }
            this.timeId = setTimeout(this.dispose,500);
            this.currentCount = count;
         }
         SoundManager.instance.play("171");
      }
      
      private function completeHead() : void
      {
         this.timeline.kill();
         this.timeline = null;
         if(Boolean(this.goods) && this.container.contains(this.goods))
         {
            this.container.removeChild(this.goods);
         }
         this.timeId = setTimeout(this.dispose,500);
         this.currentCount = count;
      }
      
      private function getBagAniam() : MovieClipWrapper
      {
         var mc:MovieClip = null;
         mc = ClassUtils.CreatInstance("asset.game.bagAniam") as MovieClip;
         var pt:Point = ComponentFactory.Instance.creatCustomObject("dropGoods.bagPoint");
         mc.x = pt.x;
         mc.y = pt.y;
         return new MovieClipWrapper(mc,true,true);
      }
      
      public function dispose() : void
      {
         clearTimeout(this.timeId);
         clearTimeout(this.timeOutId);
         ObjectUtils.disposeObject(this.goods);
         this.goods = null;
         if(Boolean(this.goldNumText))
         {
            TweenLite.killTweensOf(this.goldNumText);
            ObjectUtils.disposeObject(this.goldNumText);
            this.goldNumText = null;
         }
         ObjectUtils.disposeObject(this.headGlow);
         this.headGlow = null;
         ObjectUtils.disposeObject(this.goodBox);
         this.goodBox = null;
         if(Boolean(this.bagMc))
         {
            this.bagMc.dispose();
            this.bagMc = null;
         }
         this.goods = null;
         if(this.currentCount == count)
         {
            isOver = true;
         }
         count = 0;
      }
   }
}

