package game.actions
{
   import game.animations.AnimationLevel;
   import game.objects.GameLiving;
   import game.objects.GameSmallEnemy;
   
   public class LivingMoveAction extends BaseAction
   {
      
      private var _living:GameLiving;
      
      private var _path:Array;
      
      private var _currentPathIndex:int = 0;
      
      private var _dir:int;
      
      private var _endAction:String;
      
      public function LivingMoveAction(living:GameLiving, path:Array, dir:int, endAction:String = "")
      {
         super();
         _isFinished = false;
         this._living = living;
         this._path = path;
         this._dir = dir;
         this._currentPathIndex = 0;
         this._endAction = endAction;
      }
      
      override public function prepare() : void
      {
         if(this._living.isLiving)
         {
            this._living.startMoving();
            if(!(this._living is GameSmallEnemy) || this._living == this._living.map.currentFocusedLiving)
            {
               this._living.needFocus(0,0,{
                  "strategy":"directly",
                  "priority":AnimationLevel.LOW
               });
            }
            if(this._path[0].x < this._path[this._path.length - 1].x)
            {
               if(Boolean(this._living.actionMovie) && !this._living.actionMovie.shouldReplace)
               {
                  this._living.actionMovie.scaleX = -1;
               }
            }
            else if(this._path[0].x > this._path[this._path.length - 1].x)
            {
               if(Boolean(this._living.actionMovie) && !this._living.actionMovie.shouldReplace)
               {
                  this._living.actionMovie.scaleX = 1;
               }
            }
         }
         else
         {
            this.finish();
         }
      }
      
      override public function execute() : void
      {
         if(this._living is GameSmallEnemy)
         {
            this._living.map.requestForFocus(this._living,AnimationLevel.LOW);
         }
         else
         {
            this._living.needFocus(0,0,{
               "strategy":"directly",
               "priority":AnimationLevel.LOW
            });
         }
         if(Boolean(this._path[this._currentPathIndex]))
         {
            this._living.info.pos = this._path[this._currentPathIndex];
         }
         ++this._currentPathIndex;
         if(this._currentPathIndex >= this._path.length)
         {
            this.finish();
            if(this._endAction != "")
            {
               this._living.doAction(this._endAction);
            }
            else
            {
               this._living.info.doDefaultAction();
            }
         }
      }
      
      private function finish() : void
      {
         this._living.stopMoving();
         _isFinished = true;
      }
      
      override public function cancel() : void
      {
         _isFinished = true;
      }
   }
}

