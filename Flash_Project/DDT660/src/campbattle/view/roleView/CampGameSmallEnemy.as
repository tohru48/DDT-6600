package campbattle.view.roleView
{
   import campbattle.CampBattleManager;
   import campbattle.event.MapEvent;
   import com.greensock.TweenMax;
   import com.pickgliss.loader.LoaderEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.SoundManager;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.filters.GlowFilter;
   import flash.ui.Mouse;
   import flash.utils.Timer;
   import game.model.GameNeedMovieInfo;
   import game.model.SmallEnemy;
   import game.objects.GameSmallEnemy;
   
   public class CampGameSmallEnemy extends GameSmallEnemy
   {
      
      public static const MOUSE_ON_GLOW_FILTER:Array = [new GlowFilter(16776960,1,8,8,2,2)];
      
      private static var WALK:String = "walk";
      
      private static var END:String = "stand";
      
      private var _gameLiving:GameNeedMovieInfo;
      
      private var _timer:Timer;
      
      private var _isChange:Boolean;
      
      private var _actContent:Sprite;
      
      private var _sword:MovieClip;
      
      private var _fighting:MovieClip;
      
      public function CampGameSmallEnemy(info:SmallEnemy)
      {
         super(info);
         this._actContent = new Sprite();
         this.initEvents();
         this.loadGameLiving(info);
         this._timer = new Timer(10000);
         this._timer.addEventListener(TimerEvent.TIMER,this.__onTimerHander);
         this._timer.start();
      }
      
      override protected function initView() : void
      {
         initMovie();
         this._fighting = ComponentFactory.Instance.creat("campbattle.fighting");
         this._fighting.x = -1;
         this._fighting.visible = false;
         if(Boolean(_info))
         {
            if(SmallEnemy(_info).stateType == 2)
            {
               this._fighting.visible = true;
            }
         }
         this._sword = ComponentFactory.Instance.creat("asset.CampBattle.overEnemySword");
         this._sword.visible = false;
      }
      
      private function loadGameLiving(info:SmallEnemy) : void
      {
         this._gameLiving = new GameNeedMovieInfo();
         this._gameLiving.type = 2;
         this._gameLiving.path = "image/game/living/" + info.actionMovieName + ".swf";
         info.actionMovieName = "game.living." + info.actionMovieName;
         this._gameLiving.classPath = info.actionMovieName;
         this._gameLiving.addEventListener(LoaderEvent.COMPLETE,this.__onLoadGameLivingComplete);
         this._gameLiving.startLoad();
      }
      
      public function get LivingID() : int
      {
         return info.LivingID;
      }
      
      public function setStateType(type:int) : void
      {
         this._fighting.visible = false;
         if(type == 2)
         {
            this._fighting.visible = true;
            this._timer.stop();
            this._timer.removeEventListener(TimerEvent.TIMER,this.__onTimerHander);
         }
         else if(type == 1)
         {
            this._timer.reset();
            this._timer.start();
            this._timer.addEventListener(TimerEvent.TIMER,this.__onTimerHander);
         }
      }
      
      private function initEvents() : void
      {
         addEventListener(MouseEvent.CLICK,this.__onMouseClick);
         this._actContent.addEventListener(MouseEvent.MOUSE_OVER,this.__onMouseOver);
         this._actContent.addEventListener(MouseEvent.MOUSE_OUT,this.__onMouseOut);
      }
      
      protected function __onMouseMove(event:MouseEvent) : void
      {
         if(this._sword.visible)
         {
            this._sword.x = mouseX;
            this._sword.y = mouseY;
         }
      }
      
      protected function __onMouseOut(event:MouseEvent) : void
      {
         if(Boolean(this._sword))
         {
            this._sword.visible = false;
         }
         this.setCharacterFilter(false);
         Mouse.show();
         this._actContent.removeEventListener(MouseEvent.MOUSE_MOVE,this.__onMouseMove);
      }
      
      protected function __onMouseOver(event:MouseEvent) : void
      {
         if(Boolean(this._sword))
         {
            this._sword.visible = true;
         }
         this.setCharacterFilter(true);
         Mouse.hide();
         this._actContent.addEventListener(MouseEvent.MOUSE_MOVE,this.__onMouseMove);
      }
      
      protected function setCharacterFilter(value:Boolean) : void
      {
         if(Boolean(_actionMovie))
         {
            _actionMovie.filters = value ? MOUSE_ON_GLOW_FILTER : null;
         }
      }
      
      private function __onMouseClick(e:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         e.stopImmediatePropagation();
         CampBattleManager.instance.dispatchEvent(new MapEvent(MapEvent.ENTER_FIGHT,[x,y,_info.LivingID]));
      }
      
      private function removeEvents() : void
      {
         removeEventListener(MouseEvent.CLICK,this.__onMouseClick);
         if(Boolean(this._timer))
         {
            this._timer.removeEventListener(TimerEvent.TIMER,this.__onTimerHander);
         }
         if(Boolean(this._gameLiving))
         {
            this._gameLiving.removeEventListener(LoaderEvent.COMPLETE,this.__onLoadGameLivingComplete);
         }
         if(Boolean(this._actContent))
         {
            this._actContent.removeEventListener(MouseEvent.MOUSE_OVER,this.__onMouseOver);
            this._actContent.removeEventListener(MouseEvent.MOUSE_OUT,this.__onMouseOut);
            this._actContent.removeEventListener(MouseEvent.MOUSE_MOVE,this.__onMouseMove);
         }
      }
      
      protected function __onTimerHander(event:TimerEvent) : void
      {
         if(!this._isChange)
         {
            this._isChange = true;
            _info.direction = 1;
            this.livingMove(x + 50);
         }
         else
         {
            this._isChange = false;
            _info.direction = -1;
            this.livingMove(x - 50);
         }
         doAction(WALK);
      }
      
      private function livingMove(dix:int) : void
      {
         TweenMax.to(this,1,{
            "x":dix,
            "onComplete":this.walkOver
         });
      }
      
      private function walkOver() : void
      {
         doAction(END);
      }
      
      protected function __onLoadGameLivingComplete(event:LoaderEvent) : void
      {
         replaceMovie();
         this._sword.y = _actionMovie.y - (_actionMovie.height / 2 - this._sword.height / 2);
         addChild(this._sword);
         this._fighting.y = _actionMovie.y - _actionMovie.height;
         addChild(this._fighting);
         this._actContent.graphics.beginFill(0,0);
         this._actContent.graphics.drawRect(0,0,_actionMovie.width,_actionMovie.height);
         this._actContent.graphics.endFill();
         this._actContent.x = -_actionMovie.width / 2;
         this._actContent.y = -_actionMovie.height;
         addChild(this._actContent);
      }
      
      override public function dispose() : void
      {
         this.removeEvents();
         if(Boolean(this._fighting))
         {
            this._fighting.stop();
            while(Boolean(this._fighting.numChildren))
            {
               ObjectUtils.disposeObject(this._fighting.getChildAt(0));
            }
         }
         ObjectUtils.disposeObject(this._fighting);
         this._fighting = null;
         if(Boolean(this._actContent))
         {
            this._actContent.graphics.clear();
         }
         this._actContent = null;
         if(Boolean(this._sword))
         {
            ObjectUtils.disposeObject(this._sword);
         }
         this._sword = null;
         if(Boolean(this._timer))
         {
            this._timer.stop();
            this._timer.removeEventListener(TimerEvent.TIMER,this.__onTimerHander);
         }
         this._timer = null;
         if(Boolean(_actionMovie))
         {
            _actionMovie.stop();
            _actionMovie.mute();
            _actionMovie.dispose();
         }
         _actionMovie = null;
         super.dispose();
      }
   }
}

