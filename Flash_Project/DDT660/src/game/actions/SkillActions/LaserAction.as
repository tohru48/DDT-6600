package game.actions.SkillActions
{
   import ddt.command.PlayerAction;
   import ddt.manager.SkillManager;
   import ddt.view.character.GameCharacter;
   import flash.display.MovieClip;
   import flash.events.Event;
   import game.actions.BaseAction;
   import game.animations.ShockMapAnimation;
   import game.model.Living;
   import game.model.Player;
   import game.objects.GamePlayer;
   import game.view.map.MapView;
   import road7th.utils.MovieClipWrapper;
   
   public class LaserAction extends BaseAction
   {
      
      public static const radius:int = 60;
      
      private var _player:GamePlayer;
      
      private var _laserMovie:MovieClipWrapper;
      
      private var _movieComplete:Boolean = false;
      
      private var _movieStarted:Boolean = false;
      
      private var _shocked:Boolean = false;
      
      private var _showAction:PlayerAction;
      
      private var _hideAction:PlayerAction;
      
      private var _living:Living;
      
      private var _map:MapView;
      
      private var _angle:int;
      
      private var _speed:int;
      
      public function LaserAction(living:Living, map:MapView, angle:int)
      {
         super();
         this._living = living;
         this._map = map;
         this._angle = angle;
      }
      
      override public function prepare() : void
      {
         if(_isPrepare)
         {
            return;
         }
         _isPrepare = true;
         this._laserMovie = new MovieClipWrapper(SkillManager.createWeaponSkillMovieAsset(Player(this._living).currentWeapInfo.skill) as MovieClip);
         var angle:int = 0;
         if(this._living.direction == -1)
         {
            angle = 180 + this._angle;
            this._laserMovie.movie.scaleX = -1;
         }
         else
         {
            angle = this._angle;
            this._laserMovie.movie.scaleX = 1;
         }
         this._laserMovie.movie.rotation = angle;
         this._laserMovie.movie.x = this._living.pos.x;
         this._laserMovie.movie.y = this._living.pos.y;
         this._map.addChild(this._laserMovie.movie);
         this._showAction = GameCharacter.SHOT;
         this._hideAction = GameCharacter.HIDEGUN;
      }
      
      override public function execute() : void
      {
         if(!this._movieStarted)
         {
            this._laserMovie.addEventListener(Event.COMPLETE,this.__movieComplete);
            this._laserMovie.movie.addEventListener(Event.ENTER_FRAME,this.__laserFrame);
            this._laserMovie.gotoAndPlay(1);
            this._movieStarted = true;
         }
      }
      
      private function __laserFrame(event:Event) : void
      {
         if(this._laserMovie.movie.currentFrame >= this._laserMovie.movie.totalFrames - 6 && !this._shocked)
         {
            this._map.animateSet.addAnimation(new ShockMapAnimation(null));
         }
      }
      
      private function __movieComplete(event:Event) : void
      {
         this._laserMovie.removeEventListener(Event.COMPLETE,this.__movieComplete);
         this._laserMovie.movie.removeEventListener(Event.ENTER_FRAME,this.__laserFrame);
         if(Boolean(this._laserMovie.movie.parent))
         {
            this._laserMovie.movie.parent.removeChild(this._laserMovie.movie);
         }
         this._laserMovie.dispose();
         _isFinished = true;
      }
   }
}

