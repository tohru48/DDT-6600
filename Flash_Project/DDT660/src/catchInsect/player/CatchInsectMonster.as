package catchInsect.player
{
   import catchInsect.CatchInsectMonsterManager;
   import catchInsect.data.InsectInfo;
   import catchInsect.event.InsectEvent;
   import com.greensock.TweenLite;
   import com.pickgliss.loader.ModuleLoader;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ClassUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.filters.GlowFilter;
   import flash.geom.Point;
   import flash.media.SoundTransform;
   import flash.utils.Timer;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   import road.game.resource.ActionMovie;
   
   public class CatchInsectMonster extends Sprite implements Disposeable
   {
      
      private static const Time:int = 5;
      
      private static const Distance:int = 300;
      
      private var _monsterInfo:InsectInfo;
      
      private var LastPos:Point;
      
      protected var _actionMovie:ActionMovie;
      
      protected var _movieTouch:Sprite;
      
      private var _timer:Timer;
      
      private var _walkTimer:Timer;
      
      private var _fightIcon:MovieClip;
      
      private var _pos:Point;
      
      private var _state:int;
      
      private var timeoutID1:uint;
      
      private var timeoutID2:uint;
      
      private var aimX:int;
      
      public function CatchInsectMonster(pInsectInfo:InsectInfo, pPos:Point)
      {
         super();
         this._pos = pPos.clone();
         this.LastPos = pPos;
         this._monsterInfo = pInsectInfo;
         this.initMovie();
         this.x = this._pos.x;
         this.y = this._pos.y;
         this.initEvent();
         this._fightIcon = ComponentFactory.Instance.creat("catchInsect.fighting");
         addChild(this._fightIcon);
         this._fightIcon.visible = false;
         this._fightIcon.gotoAndStop(1);
         this.MonsterState = this._monsterInfo.State;
      }
      
      public function set Pos(value:Point) : void
      {
         this._pos = value;
         this.LastPos = value;
      }
      
      private function TimeEx() : Number
      {
         return Time / Distance;
      }
      
      public function get MonsterState() : int
      {
         return this._state;
      }
      
      public function set MonsterState(value:int) : void
      {
         this._state = value;
         if(this._state >= InsectInfo.FIGHTING)
         {
            this.visible = true;
            this._fightIcon.visible = true;
            this._fightIcon.gotoAndPlay(1);
            this.filters = [new GlowFilter(16711680,1,8,8,2,2)];
            if(Boolean(this._walkTimer))
            {
               this._walkTimer.stop();
            }
         }
         else
         {
            this.visible = true;
            this._fightIcon.visible = false;
            this._fightIcon.gotoAndStop(1);
            this.filters = null;
            if(Boolean(this._walkTimer) && !this._walkTimer.running)
            {
               this.startTimer();
            }
         }
      }
      
      public function get monsterInfo() : InsectInfo
      {
         return this._monsterInfo;
      }
      
      private function initEvent() : void
      {
         addEventListener(MouseEvent.CLICK,this.__onMonsterClick);
         addEventListener(MouseEvent.MOUSE_OVER,this.__onMouseOverMonster);
         addEventListener(MouseEvent.MOUSE_OUT,this.__onMouseOutMonster);
         this._monsterInfo.addEventListener(InsectEvent.UPDATE_MONSTER_STATE,this.__onStateChange);
      }
      
      private function removeEvent() : void
      {
         removeEventListener(MouseEvent.CLICK,this.__onMonsterClick);
         removeEventListener(MouseEvent.MOUSE_OVER,this.__onMouseOverMonster);
         removeEventListener(MouseEvent.MOUSE_OUT,this.__onMouseOutMonster);
         this._monsterInfo.removeEventListener(InsectEvent.UPDATE_MONSTER_STATE,this.__onStateChange);
      }
      
      private function __onMouseOverMonster(e:MouseEvent) : void
      {
         if(this.MonsterState >= InsectInfo.FIGHTING)
         {
            this.filters = [new GlowFilter(16711680,1,8,8,2,2)];
         }
         else
         {
            this.filters = [new GlowFilter(16776960,1,8,8,2,2)];
         }
      }
      
      private function __onMouseOutMonster(e:MouseEvent) : void
      {
         if(this.MonsterState >= InsectInfo.FIGHTING)
         {
            this.filters = [new GlowFilter(16711680,1,8,8,2,2)];
         }
         else
         {
            this.filters = null;
         }
      }
      
      private function __onStateChange(pEvent:InsectEvent) : void
      {
         this.MonsterState = pEvent.data as int;
      }
      
      private function startTimer() : void
      {
         this.timeoutID1 = setTimeout(this._walkTimer.start,Math.abs(Math.random() * 5000));
      }
      
      private function initMovie() : void
      {
         var movieClass:Class = null;
         if(ModuleLoader.hasDefinition(this._monsterInfo.ActionMovieName))
         {
            movieClass = ModuleLoader.getDefinition(this._monsterInfo.ActionMovieName) as Class;
            if(Boolean(this._actionMovie))
            {
               this._actionMovie.dispose();
               this._actionMovie = null;
               ObjectUtils.disposeObject(this._movieTouch);
               this._movieTouch = null;
            }
            this._actionMovie = new movieClass();
            addChild(this._actionMovie);
            this._movieTouch = new Sprite();
            this._movieTouch.graphics.beginFill(0,0);
            this._movieTouch.graphics.drawRect(0,0,this._actionMovie.width,this._actionMovie.height);
            this._movieTouch.graphics.endFill();
            addChild(this._movieTouch);
            this._movieTouch.x = -(this._actionMovie.width / 2);
            this._movieTouch.y = -this._actionMovie.height;
            this._movieTouch.buttonMode = true;
            this.soundTransform = new SoundTransform(0);
            this._actionMovie.doAction("stand");
            this._actionMovie.scaleX = -1;
            this._walkTimer = new Timer(5000);
            this._walkTimer.addEventListener(TimerEvent.TIMER,this.__walkingNow);
            if(this.monsterInfo.State != InsectInfo.FIGHTING)
            {
               this.startTimer();
            }
         }
         else
         {
            this._actionMovie = ClassUtils.CreatInstance("asset.game.defaultImage") as ActionMovie;
            addChild(this._actionMovie);
            this._movieTouch = new Sprite();
            this._movieTouch.graphics.beginFill(0,0);
            this._movieTouch.graphics.drawRect(0,0,this._actionMovie.width,this._actionMovie.height);
            this._movieTouch.graphics.endFill();
            addChild(this._movieTouch);
            this._movieTouch.x = -(this._actionMovie.width / 2);
            this._movieTouch.y = -this._actionMovie.height;
            this._movieTouch.buttonMode = true;
            this._timer = new Timer(500);
            this._timer.addEventListener(TimerEvent.TIMER,this.__checkActionIsReady);
            this._timer.start();
         }
      }
      
      private function __walkingNow(pEvent:TimerEvent) : void
      {
         if(Boolean(this._actionMovie))
         {
            this.walk();
         }
      }
      
      protected function __checkActionIsReady(event:TimerEvent) : void
      {
         if(ModuleLoader.hasDefinition(this._monsterInfo.ActionMovieName))
         {
            this._timer.stop();
            this._timer.removeEventListener(TimerEvent.TIMER,this.__checkActionIsReady);
            this._timer = null;
            this.initMovie();
         }
      }
      
      private function __onMonsterClick(pEvent:MouseEvent) : void
      {
         CatchInsectMonsterManager.Instance.curMonster = this;
      }
      
      public function StartFight() : void
      {
         if(!CatchInsectMonsterManager.Instance.isFighting && this.MonsterState <= InsectInfo.LIVIN)
         {
            if(Boolean(PlayerManager.Instance.Self.Bag.getItemAt(6)))
            {
               SocketManager.Instance.out.sendFightWithInsect(this._monsterInfo.ID);
               CatchInsectMonsterManager.Instance.isFighting = true;
               CatchInsectMonsterManager.Instance.CurrentMonster = this._monsterInfo;
               CatchInsectMonsterManager.Instance.setupFightEvent();
               this.timeoutID2 = setTimeout(this.resetStartState,3000);
            }
            else
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.room.RoomIIController.weapon"));
            }
         }
      }
      
      private function resetStartState() : void
      {
         CatchInsectMonsterManager.Instance.isFighting = false;
         CatchInsectMonsterManager.Instance.CurrentMonster = null;
      }
      
      public function walk(pAimPoint:Point = null) : void
      {
         var dis:int = 0;
         this.aimX = Math.abs(Math.random()) * 300 + (this._pos.x - 150);
         if(this.aimX >= this.LastPos.x)
         {
            dis = this.aimX - this.LastPos.x;
            this._actionMovie.scaleX = -1;
            this._actionMovie.doAction("walk");
         }
         else
         {
            dis = this.LastPos.x - this.aimX;
            this._actionMovie.scaleX = 1;
            this._actionMovie.doAction("walk");
         }
         TweenLite.to(this,dis * this.TimeEx(),{
            "x":this.aimX,
            "onComplete":this.onTweenComplete
         });
      }
      
      private function onTweenComplete() : void
      {
         this._actionMovie.doAction("stand");
         this.LastPos.x = this.aimX;
      }
      
      public function dispose() : void
      {
         clearTimeout(this.timeoutID1);
         clearTimeout(this.timeoutID2);
         TweenLite.killTweensOf(this);
         if(Boolean(this._actionMovie))
         {
            this._actionMovie.dispose();
            this._actionMovie = null;
         }
         if(Boolean(this._fightIcon) && Boolean(this._fightIcon.parent))
         {
            this._fightIcon.visible = false;
            this._fightIcon.gotoAndStop(1);
            this._fightIcon.parent.removeChild(this._fightIcon);
         }
         this._fightIcon = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

