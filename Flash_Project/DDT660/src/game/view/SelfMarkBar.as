package game.view
{
   import com.greensock.TweenLite;
   import com.pickgliss.toplevel.StageReferance;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.events.LivingEvent;
   import ddt.manager.PathManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import fightFootballTime.manager.FightFootballTimeManager;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.Graphics;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.filters.BlurFilter;
   import flash.utils.Dictionary;
   import flash.utils.Timer;
   import game.GameManager;
   import game.model.LocalPlayer;
   import org.aswing.KeyStroke;
   import org.aswing.KeyboardManager;
   import room.RoomManager;
   import room.model.RoomInfo;
   import trainer.controller.NewHandGuideManager;
   
   public class SelfMarkBar extends Sprite implements Disposeable
   {
      
      private var _self:LocalPlayer;
      
      private var _timer:Timer;
      
      private var _nums:Vector.<DisplayObject> = new Vector.<DisplayObject>();
      
      private var _numContainer:Sprite;
      
      private var _alreadyTime:int;
      
      private var _animateFilter:BlurFilter = new BlurFilter();
      
      private var _scale:Number = 2;
      
      private var _skipButton:SkipButton;
      
      private var _container:DisplayObjectContainer;
      
      private var _noActionTurn:int;
      
      private var _numDic:Dictionary = new Dictionary();
      
      private var _enabled:Boolean = true;
      
      public function SelfMarkBar(self:LocalPlayer, container:DisplayObjectContainer)
      {
         super();
         this._self = self;
         this._container = container;
         this._numContainer = new Sprite();
         this._numContainer.mouseEnabled = false;
         this._numContainer.mouseChildren = false;
         addChild(this._numContainer);
         this._skipButton = ComponentFactory.Instance.creatCustomObject("SkipButton");
         this._skipButton.x = -this._skipButton.width >> 1;
         this._skipButton.y = 70;
         if(GameManager.Instance.Current.roomType != FightFootballTimeManager.FIGHTFOOTBALLTIME_ROOM)
         {
            addChild(this._skipButton);
         }
         this.creatNums();
         this.addEvent();
      }
      
      private function creatNums() : void
      {
         var bitmap:Bitmap = null;
         for(var i:int = 0; i < 10; i++)
         {
            bitmap = ComponentFactory.Instance.creatBitmap("asset.game.mark.Blue" + i);
            this._numDic["Blue" + i] = bitmap;
         }
         for(var j:int = 0; j < 5; j++)
         {
            bitmap = ComponentFactory.Instance.creatBitmap("asset.game.mark.Red" + j);
            this._numDic["Red" + j] = bitmap;
         }
      }
      
      private function addEvent() : void
      {
         this._self.addEventListener(LivingEvent.ATTACKING_CHANGED,this.__attackChanged);
         this._self.addEventListener(LivingEvent.BEGIN_SHOOT,this.__beginShoot);
         this._skipButton.addEventListener(MouseEvent.CLICK,this.__skip);
         if(!(Boolean(GameManager.Instance.Current) && GameManager.Instance.Current.roomType == FightFootballTimeManager.FIGHTFOOTBALLTIME_ROOM))
         {
            KeyboardManager.getInstance().addEventListener(KeyboardEvent.KEY_DOWN,this.__keyDown);
            StageReferance.stage.addEventListener(MouseEvent.MOUSE_MOVE,this.onMouseMove);
         }
      }
      
      protected function onMouseMove(event:MouseEvent) : void
      {
         this._noActionTurn = 0;
      }
      
      private function __skip(evt:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(this._skipButton.enabled)
         {
            this.skip();
         }
      }
      
      private function removeEvent() : void
      {
         this._self.removeEventListener(LivingEvent.ATTACKING_CHANGED,this.__attackChanged);
         this._self.removeEventListener(LivingEvent.BEGIN_SHOOT,this.__beginShoot);
         if(Boolean(this._skipButton))
         {
            this._skipButton.removeEventListener(MouseEvent.CLICK,this.__skip);
         }
         KeyboardManager.getInstance().removeEventListener(KeyboardEvent.KEY_DOWN,this.__keyDown);
         StageReferance.stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.onMouseMove);
      }
      
      private function __beginShoot(evt:LivingEvent) : void
      {
         this.pause();
         this._skipButton.enabled = false;
      }
      
      private function __attackChanged(event:LivingEvent) : void
      {
         if(this._self.isAttacking && GameManager.Instance.Current.currentLiving && GameManager.Instance.Current.currentLiving.isSelf)
         {
            this.startup(this._self.turnTime);
         }
         else
         {
            this.pause();
         }
      }
      
      public function dispose() : void
      {
         var key:String = null;
         this.removeEvent();
         this.shutdown();
         this.clear();
         if(Boolean(this._skipButton))
         {
            ObjectUtils.disposeObject(this._skipButton);
            this._skipButton = null;
         }
         for(key in this._numDic)
         {
            ObjectUtils.disposeObject(this._numDic[key]);
            delete this._numDic[key];
         }
         if(Boolean(this._numContainer))
         {
            ObjectUtils.disposeObject(this._numContainer);
            this._numContainer = null;
         }
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
      
      public function startup(time:int) : void
      {
         if(!this._enabled)
         {
            return;
         }
         this._skipButton.enabled = true;
         this._alreadyTime = time;
         this.__mark(null);
         this._timer = new Timer(1000,time);
         this._timer.addEventListener(TimerEvent.TIMER,this.__mark);
         this._timer.addEventListener(TimerEvent.TIMER_COMPLETE,this.__markComplete);
         this._timer.start();
         this._container.addChild(this);
         this._animateFilter.blurX = 40;
         filters = [this._animateFilter];
         TweenLite.to(this._animateFilter,0.3,{
            "blurX":0,
            "onUpdate":this.tweenRender,
            "onComplete":this.tweenComplete
         });
      }
      
      private function __keyDown(evt:KeyboardEvent) : void
      {
         this._noActionTurn = 0;
         if(evt.keyCode == KeyStroke.VK_P.getCode() && this._self.isAttacking && NewHandGuideManager.Instance.mapID != 111)
         {
            SoundManager.instance.play("008");
            this.skip();
         }
      }
      
      public function pause() : void
      {
         if(Boolean(this._timer))
         {
            this._timer.stop();
         }
      }
      
      public function shutdown() : void
      {
         if(Boolean(this._timer))
         {
            this._timer.removeEventListener(TimerEvent.TIMER,this.__mark);
            this._timer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.__markComplete);
         }
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
      
      private function clear() : void
      {
         var num:DisplayObject = this._nums.shift();
         while(Boolean(num))
         {
            if(Boolean(num.parent))
            {
               num.parent.removeChild(num);
            }
            num = this._nums.shift();
         }
      }
      
      private function skip() : void
      {
         this.pause();
         this._self.skip();
      }
      
      private function tweenRender() : void
      {
         filters = [this._animateFilter];
      }
      
      private function tweenComplete() : void
      {
         filters = null;
      }
      
      private function __markComplete(event:TimerEvent) : void
      {
         ++this._noActionTurn;
         this.shutdown();
         this._self.skip();
         if(this._noActionTurn >= PathManager.fight_time)
         {
            if(Boolean(GameManager.Instance.Current) && this.isShowTrusteeship())
            {
               SocketManager.Instance.out.sendGameTrusteeship(true);
            }
         }
      }
      
      private function isShowTrusteeship() : Boolean
      {
         if(RoomManager.Instance.current.type == RoomInfo.DUNGEON_ROOM || RoomManager.Instance.current.type == RoomInfo.LEAGE_ROOM || RoomManager.Instance.current.type == RoomInfo.GUILD_LEAGE_MODE || RoomManager.Instance.current.type == RoomInfo.GUILD_LEAGE_MODE || RoomManager.Instance.current.type == RoomInfo.SCORE_ROOM || RoomManager.Instance.current.type == RoomInfo.SINGLE_BATTLE || RoomManager.Instance.current.type == RoomInfo.MATCH_ROOM || RoomManager.Instance.current.type == RoomInfo.CHALLENGE_ROOM || RoomManager.Instance.current.type == RoomInfo.ACADEMY_DUNGEON_ROOM || RoomManager.Instance.current.type == RoomInfo.ENCOUNTER_ROOM)
         {
            return true;
         }
         return false;
      }
      
      public function get runnning() : Boolean
      {
         return this._timer != null && this._timer.running;
      }
      
      public function set enabled(val:Boolean) : void
      {
         if(this._enabled != val)
         {
            this._enabled = val;
            if(this._enabled && this.runnning)
            {
               this._container.addChild(this);
            }
            else
            {
               this.shutdown();
            }
         }
      }
      
      private function __mark(event:TimerEvent) : void
      {
         var numStr:String = null;
         var num:DisplayObject = null;
         var shape:Shape = null;
         var bmd:BitmapData = null;
         var pen:Graphics = null;
         var rate:Number = NaN;
         TweenLite.killTweensOf(this);
         this.clear();
         --this._alreadyTime;
         numStr = this._alreadyTime.toString();
         if(this._alreadyTime > 9)
         {
            if(this._alreadyTime % 11 == 0)
            {
               num = this._numDic["Blue" + numStr.substr(0,1)];
               num.x = 0;
               this._numContainer.addChild(num);
               this._nums.push(num);
               shape = new Shape();
               bmd = this._numDic["Blue" + numStr.substr(0,1)].bitmapData;
               pen = shape.graphics;
               pen.beginBitmapFill(bmd);
               pen.drawRect(0,0,bmd.width,bmd.height);
               pen.endFill();
               shape.x = this._nums[0].width;
               this._numContainer.addChild(shape);
               this._nums.push(shape);
               this._numContainer.x = -this._numContainer.width >> 1;
            }
            else
            {
               num = this._numDic["Blue" + numStr.substr(0,1)];
               num.x = 0;
               this._numContainer.addChild(num);
               this._nums.push(num);
               num = this._numDic["Blue" + numStr.substr(1,1)];
               num.x = this._nums[0].width;
               this._numContainer.addChild(num);
               this._nums.push(num);
               this._numContainer.x = -this._numContainer.width >> 1;
            }
            SoundManager.instance.play("014");
         }
         else
         {
            if(this._alreadyTime < 0)
            {
               return;
            }
            if(this._alreadyTime <= 4)
            {
               num = this._numDic["Red" + numStr];
               Bitmap(num).smoothing = true;
               this._numContainer.addChild(num);
               this._nums.push(num);
               SoundManager.instance.stop("067");
               SoundManager.instance.play("067");
               rate = this._scale - 1;
               this._numContainer.x = -this._numContainer.width * this._scale >> 1;
               this._numContainer.y = -this._numContainer.height * rate >> 1;
               this._numContainer.scaleX = this._numContainer.scaleY = this._scale;
               TweenLite.to(this._numContainer,0.2,{
                  "x":-num.width >> 1,
                  "y":0,
                  "scaleX":1,
                  "scaleY":1
               });
            }
            else
            {
               num = this._numDic["Blue" + numStr];
               if(Boolean(num))
               {
                  num.x = 0;
                  this._numContainer.addChild(num);
                  this._numContainer.x = -this._numContainer.width >> 1;
                  this._nums.push(num);
               }
               SoundManager.instance.play("014");
            }
         }
      }
   }
}

