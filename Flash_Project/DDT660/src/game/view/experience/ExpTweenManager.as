package game.view.experience
{
   import com.greensock.TimelineMax;
   import com.greensock.core.TweenCore;
   
   public class ExpTweenManager
   {
      
      private static var _instance:ExpTweenManager;
      
      public var isPlaying:Boolean;
      
      private var _timeline:TimelineMax;
      
      private var _tweens:Vector.<TweenCore>;
      
      public function ExpTweenManager()
      {
         super();
         this.init();
      }
      
      public static function get Instance() : ExpTweenManager
      {
         if(!_instance)
         {
            _instance = new ExpTweenManager();
         }
         return _instance;
      }
      
      private function init() : void
      {
         this._timeline = new TimelineMax();
         this._timeline.autoRemoveChildren = true;
         this._timeline.stop();
         this._tweens = new Vector.<TweenCore>();
      }
      
      public function appendTween(tween:TweenCore, offset:Number = 0, obj:Object = null) : void
      {
         this._tweens.push(tween);
         this._timeline.append(tween,offset);
         if(obj != null)
         {
            if(obj.onStart != null && obj.onStartParams != null)
            {
               tween.vars.onStart = obj.onStart;
               tween.vars.onStartParams = obj.onStartParams;
            }
            else if(obj.onStart != null)
            {
               tween.vars.onStart = obj.onStart;
            }
            if(obj.onComplete != null && obj.onCompleteParams != null)
            {
               tween.vars.onComplete = obj.onComplete;
               tween.vars.onCompleteParams = obj.onCompleteParams;
            }
            else if(obj.onComplete != null)
            {
               tween.vars.onComplete = obj.onComplete;
            }
         }
      }
      
      public function startTweens() : void
      {
         this._timeline.play();
      }
      
      public function completeTweens() : void
      {
         this._timeline.timeScale = 100;
      }
      
      public function speedRecover() : void
      {
         this._timeline.timeScale = 1;
      }
      
      public function deleteTweens() : void
      {
         var core:TweenCore = null;
         this._timeline.stop();
         while(this._tweens.length > 0)
         {
            core = this._tweens.shift();
            core.kill();
            core = null;
         }
         this._tweens = new Vector.<TweenCore>();
         this._timeline.kill();
         this._timeline.clear();
         this._timeline.totalProgress = 0;
         this._timeline = new TimelineMax();
      }
   }
}

