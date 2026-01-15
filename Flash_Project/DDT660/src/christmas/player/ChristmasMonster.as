package christmas.player
{
   import christmas.event.ChristmasMonsterEvent;
   import christmas.info.MonsterInfo;
   import christmas.manager.ChristmasMonsterManager;
   import com.greensock.TweenLite;
   import com.pickgliss.loader.ModuleLoader;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ClassUtils;
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
   
   public class ChristmasMonster extends Sprite implements Disposeable
   {
      
      private static const Time:int = 5;
      
      private static const Distance:int = 300;
      
      private var _monsterInfo:MonsterInfo;
      
      private var LastPos:Point;
      
      protected var _actionMovie:ActionMovie;
      
      private var _timer:Timer;
      
      private var _walkTimer:Timer;
      
      private var _monsterNameTxt:FilterFrameText;
      
      private var _fightIcon:MovieClip;
      
      private var _pos:Point;
      
      private var _state:int;
      
      private var timeoutID1:uint;
      
      private var timeoutID2:uint;
      
      private var aimX:int;
      
      public function ChristmasMonster(pMonsterInfo:MonsterInfo, pPos:Point)
      {
         super();
         this._pos = pPos.clone();
         this.LastPos = pPos;
         this._monsterInfo = pMonsterInfo;
         this.initMovie();
         this._monsterNameTxt = ComponentFactory.Instance.creatComponentByStylename("christmas.monster.name");
         this._monsterNameTxt.text = this._monsterInfo.MonsterName;
         this._monsterNameTxt.x = -31;
         this._monsterNameTxt.y = 13;
         addChild(this._monsterNameTxt);
         this.x = this._pos.x;
         this.y = this._pos.y;
         this.initEvent();
         this._fightIcon = ComponentFactory.Instance.creat("asset.christmasMonster.fighting");
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
         if(this._state >= MonsterInfo.FIGHTING)
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
      
      public function get monsterInfo() : MonsterInfo
      {
         return this._monsterInfo;
      }
      
      private function initEvent() : void
      {
         this.addEventListener(MouseEvent.CLICK,this.__onMonsterClick);
         this.addEventListener(MouseEvent.MOUSE_OVER,this.__onMouseOverMonster);
         this.addEventListener(MouseEvent.MOUSE_OUT,this.__onMouseOutMonster);
         this._monsterInfo.addEventListener(ChristmasMonsterEvent.UPDATE_MONSTER_STATE,this.__onStateChange);
      }
      
      private function removeEvent() : void
      {
         this.removeEventListener(MouseEvent.CLICK,this.__onMonsterClick);
         this._monsterInfo.removeEventListener(ChristmasMonsterEvent.UPDATE_MONSTER_STATE,this.__onStateChange);
      }
      
      private function __onMouseOverMonster(e:MouseEvent) : void
      {
         if(this.MonsterState >= MonsterInfo.FIGHTING)
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
         if(this.MonsterState >= MonsterInfo.FIGHTING)
         {
            this.filters = [new GlowFilter(16711680,1,8,8,2,2)];
         }
         else
         {
            this.filters = null;
         }
      }
      
      private function __onStateChange(pEvent:ChristmasMonsterEvent) : void
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
            }
            this._actionMovie = new movieClass();
            this._actionMovie.mouseEnabled = true;
            this._actionMovie.mouseChildren = true;
            this._actionMovie.buttonMode = true;
            this._actionMovie.scrollRect = null;
            addChild(this._actionMovie);
            this.soundTransform = new SoundTransform(0);
            this._actionMovie.doAction("stand");
            this._actionMovie.scaleX = -1;
            this._walkTimer = new Timer(5000);
            this._walkTimer.addEventListener(TimerEvent.TIMER,this.__walkingNow);
            if(this.monsterInfo.State != MonsterInfo.FIGHTING)
            {
               this.startTimer();
            }
            else if(this.monsterInfo.State == MonsterInfo.FIGHTING)
            {
               this._walkTimer.stop();
            }
         }
         else
         {
            this._actionMovie = ClassUtils.CreatInstance("asset.game.defaultImage") as ActionMovie;
            this._actionMovie.mouseEnabled = false;
            this._actionMovie.mouseChildren = false;
            this._actionMovie.scrollRect = null;
            addChild(this._actionMovie);
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
         ChristmasMonsterManager.Instance.curMonster = this;
      }
      
      public function StartFight() : void
      {
         if(!ChristmasMonsterManager.Instance.isFighting && this.MonsterState <= MonsterInfo.LIVIN)
         {
            if(Boolean(PlayerManager.Instance.Self.Bag.getItemAt(6)))
            {
               SocketManager.Instance.out.sendStartFightWithMonster(this._monsterInfo.ID);
               ChristmasMonsterManager.Instance.isFighting = true;
               ChristmasMonsterManager.Instance.CurrentMonster = this._monsterInfo;
               ChristmasMonsterManager.Instance.setupFightEvent();
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
         ChristmasMonsterManager.Instance.isFighting = false;
         ChristmasMonsterManager.Instance.CurrentMonster = null;
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

