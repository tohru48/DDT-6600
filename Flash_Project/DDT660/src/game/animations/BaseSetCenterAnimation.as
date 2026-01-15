package game.animations
{
   import flash.geom.Point;
   import flash.utils.getDefinitionByName;
   import game.view.map.MapView;
   
   public class BaseSetCenterAnimation extends BaseAnimate
   {
      
      protected var _target:Point;
      
      protected var _life:int;
      
      protected var _directed:Boolean;
      
      protected var _speed:int;
      
      protected var _moveSpeed:int = 4;
      
      protected var _tween:BaseStageTween;
      
      public function BaseSetCenterAnimation(cx:Number, cy:Number, life:int = 0, directed:Boolean = false, level:int = 0, speed:int = 4, data:Object = null)
      {
         var tweenObject:TweenObject = null;
         super();
         tweenObject = new TweenObject(data);
         this._target = new Point(cx,cy);
         tweenObject.target = this._target;
         var tweenType:String = StageTweenStrategys.getTweenClassNameByShortName(tweenObject.strategy);
         _finished = false;
         this._life = life;
         _level = level;
         if(Boolean(data) && data.priority != null)
         {
            _level = data.priority;
         }
         if(Boolean(data) && data.duration != null)
         {
            this._life = data.duration;
         }
         this._directed = directed;
         this._speed = speed;
         var tweenClass:Class = getDefinitionByName(tweenType) as Class;
         this._tween = new tweenClass(tweenObject);
      }
      
      override public function canAct() : Boolean
      {
         if(_finished)
         {
            return false;
         }
         if(this._life <= 0)
         {
            return false;
         }
         return true;
      }
      
      override public function prepare(aniset:AnimationSet) : void
      {
         this._target.x = aniset.stageWidth / 2 - this._target.x;
         this._target.y = aniset.stageHeight / 2 - this._target.y;
         this._target.x = this._target.x < aniset.minX ? aniset.minX : (this._target.x > 0 ? 0 : this._target.x);
         this._target.y = this._target.y < aniset.minY ? aniset.minY : (this._target.y > 0 ? 0 : this._target.y);
      }
      
      override public function update(movie:MapView) : Boolean
      {
         var result:Point = null;
         --this._life;
         if(this._life <= 0)
         {
            this.finished();
         }
         if(!_finished && this._life > 0)
         {
            if(!this._directed)
            {
               this._tween.target = this._target;
               result = this._tween.update(movie);
               movie.x = result.x;
               movie.y = result.y;
               if(this._tween.isFinished)
               {
                  this.finished();
               }
            }
            else
            {
               movie.x = this._target.x;
               movie.y = this._target.y;
               this.finished();
            }
            movie.setExpressionLoction();
            return true;
         }
         return false;
      }
      
      protected function finished() : void
      {
         _finished = true;
      }
   }
}

