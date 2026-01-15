package luckStar.view
{
   import com.greensock.TweenMax;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import luckStar.manager.LuckStarManager;
   
   public class LuckStarAwardAction extends Sprite implements Disposeable
   {
      
      private var _action:MovieClip;
      
      private var _list:Vector.<Bitmap>;
      
      private var _cell:Function;
      
      private var _num:Vector.<ScaleFrameImage>;
      
      private var _count:int = 0;
      
      private var len:int;
      
      private var arr:Array = [9,99,999,9999,99999,999999,9999999];
      
      private var _isMaxAward:Boolean;
      
      private var _mc:MovieClip;
      
      private var _image:Bitmap;
      
      private var _content:Sprite;
      
      private var _move:Point;
      
      private var _tweenMax:TweenMax;
      
      public function LuckStarAwardAction()
      {
         super();
      }
      
      public function playAction(cell:Function, btm:DisplayObject, move:Point, isMaxAward:Boolean = false) : void
      {
         var rect:Rectangle = null;
         this._cell = cell;
         this._isMaxAward = isMaxAward;
         if(this._isMaxAward)
         {
            this.playMaxAwardAction();
            return;
         }
         this._content = new Sprite();
         addChild(this._content);
         this._image = btm as Bitmap;
         this._move = move;
         rect = ComponentFactory.Instance.creatCustomObject("luckyStar.view.AwardLightRec");
         this._mc = ComponentFactory.Instance.creat("luckyStar.view.TurnMC");
         this._mc.stop();
         this._mc.width = this._mc.height = rect.width;
         this._mc.x = rect.x;
         this._mc.y = rect.y;
         this._mc.gotoAndPlay(1);
         this._mc.addEventListener(Event.ENTER_FRAME,this.__onEnter);
         this._content.addChild(this._mc);
      }
      
      private function playNextAction() : void
      {
         if(Boolean(this._image))
         {
            this._image.x = this._image.y = -2;
            this._image.scaleX = this._image.scaleY = 0.8;
            this._content.addChild(this._image);
         }
      }
      
      private function __onEnter(e:Event) : void
      {
         if(this._mc.currentFrame == 40)
         {
            SoundManager.instance.play("125");
            this.playNextAction();
         }
         if(this._mc.currentFrame == 65)
         {
            this._tweenMax = TweenMax.to(this._content,0.7,{
               "x":this._move.x,
               "y":this._move.y,
               "width":60,
               "height":60
            });
         }
         if(this._mc.currentFrame == this._mc.totalFrames - 1)
         {
            this.disposeAction();
         }
      }
      
      public function get actionDisplay() : Sprite
      {
         return this._content;
      }
      
      private function disposeAction() : void
      {
         if(Boolean(this._mc))
         {
            this._mc.stop();
            this._mc.removeEventListener(Event.ENTER_FRAME,this.__onEnter);
            ObjectUtils.disposeObject(this._mc);
            this._mc = null;
         }
         if(Boolean(this._image))
         {
            ObjectUtils.disposeObject(this._image);
            this._image = null;
         }
         if(Boolean(this._tweenMax))
         {
            TweenMax.killChildTweensOf(this._content);
         }
         this._tweenMax = null;
         ObjectUtils.disposeObject(this._content);
         this._content = null;
         if(this._cell != null)
         {
            this._cell.apply();
         }
         this._cell = null;
      }
      
      public function playMaxAwardAction() : void
      {
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_DYNAMIC_LAYER,false,LayerManager.BLCAK_BLOCKGOUND);
         this._list = new Vector.<Bitmap>();
         this._num = new Vector.<ScaleFrameImage>();
         this._count = LuckStarManager.Instance.model.coins;
         this._action = ComponentFactory.Instance.creat("luckyStar.view.maxAwardAction");
         PositionUtils.setPos(this._action,"luckyStar.view.maxAwardActionPos");
         addChild(this._action);
         this._action.addEventListener(Event.ENTER_FRAME,this.__onAction);
         this._action.gotoAndPlay(1);
         SoundManager.instance.play("210");
      }
      
      private function setupCount() : void
      {
         var numX:int = 0;
         var i:int = 0;
         while(this.len > this._num.length)
         {
            this._num.unshift(this.createCoinsNum(0));
         }
         while(this.len < this._num.length)
         {
            ObjectUtils.disposeObject(this._num.shift());
         }
         var cha:int = 8 - this.len;
         numX = cha / 2 * 25;
         for(i = 0; i < this.len; i++)
         {
            this._num[i].x = numX + 280;
            this._num[i].y = 200;
            numX += 25;
         }
      }
      
      private function playCount() : void
      {
         this.setupCount();
         if(this.len == 0 || this.len > this.arr.length)
         {
            return;
         }
         var random:int = Math.random() * int(this.arr[this.len - 1]);
         this.updateCoinsView(random.toString().split(""));
      }
      
      private function updateCoinsView(arr:Array) : void
      {
         for(var i:int = 0; i < this.len; i++)
         {
            if(arr[i] == 0)
            {
               arr[i] = 10;
            }
            this._num[i].setFrame(arr[i]);
         }
      }
      
      private function __onAction(e:Event) : void
      {
         this.updateCoinsView(this._count.toString().split(""));
         if(this._action.currentFrame < 165)
         {
            if(this._action.currentFrame % 20 == 0)
            {
               ++this.len;
               if(this.len > this._count.toString().length)
               {
                  this.len = this._count.toString().length;
               }
               SoundManager.instance.play("210");
            }
            this.playCount();
            this.coinsDrop();
         }
         this.checkDrop();
         if(this._action.currentFrame == this._action.totalFrames - 1)
         {
            this.len = 0;
            this._action.stop();
            this._action.removeEventListener(Event.ENTER_FRAME,this.__onAction);
            this._action = null;
            if(this._cell != null)
            {
               this._cell.apply();
            }
            this._cell = null;
         }
      }
      
      private function coinsDrop() : void
      {
         var index:int = Math.random() * 3;
         var btm:Bitmap = ComponentFactory.Instance.creatBitmap("luckyStar.view.CoinsRain" + index);
         btm.x = Math.random() * 700 + 100;
         this._list.push(btm);
         addChildAt(btm,0);
      }
      
      private function checkDrop() : void
      {
         var i:int = 0;
         for(i = 0; i < this._list.length; i++)
         {
            this._list[i].y += 30;
            if(this._list[i].y > 500)
            {
               ObjectUtils.disposeObject(this._list[i]);
               this._list.splice(this._list.indexOf(this._list[i]),this._list.indexOf(this._list[i]));
            }
         }
      }
      
      private function createCoinsNum(frame:int = 0) : ScaleFrameImage
      {
         var num:ScaleFrameImage = ComponentFactory.Instance.creatComponentByStylename("luckyStar.view.CoinsNum");
         num.setFrame(frame);
         if(Boolean(this._action))
         {
            this._action.addChild(num);
         }
         return num;
      }
      
      public function dispose() : void
      {
         while(Boolean(this._list) && Boolean(this._list.length))
         {
            ObjectUtils.disposeObject(this._list.pop());
         }
         this._list = null;
         while(Boolean(this._num) && Boolean(this._num.length))
         {
            ObjectUtils.disposeObject(this._num.pop());
         }
         this._num = null;
         this._cell = null;
         if(Boolean(this._action))
         {
            this._action.stop();
            this._action.removeEventListener(Event.ENTER_FRAME,this.__onAction);
         }
         this._action = null;
      }
   }
}

