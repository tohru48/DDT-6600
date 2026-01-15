package game.actions
{
   import game.objects.GameLiving;
   import road.game.resource.ActionMovie;
   
   public class ChangeDirectionAction extends BaseAction
   {
      
      private var _living:GameLiving;
      
      private var _dir:int;
      
      private var _direction:String;
      
      public function ChangeDirectionAction(living:GameLiving, $dir:int)
      {
         super();
         this._living = living;
         this._dir = $dir;
         if(this._dir > 0)
         {
            this._direction = ActionMovie.RIGHT;
         }
         else
         {
            this._direction = ActionMovie.LEFT;
         }
      }
      
      override public function canReplace(action:BaseAction) : Boolean
      {
         var act:ChangeDirectionAction = action as ChangeDirectionAction;
         if(Boolean(act) && this._dir == act.dir)
         {
            return true;
         }
         return false;
      }
      
      override public function connect(action:BaseAction) : Boolean
      {
         var act:ChangeDirectionAction = action as ChangeDirectionAction;
         if(Boolean(act) && this._dir == act.dir)
         {
            return true;
         }
         return false;
      }
      
      public function get dir() : int
      {
         return this._dir;
      }
      
      override public function prepare() : void
      {
         if(_isPrepare)
         {
            return;
         }
         _isPrepare = true;
         if(!this._living.isLiving)
         {
            _isFinished = true;
         }
      }
      
      override public function execute() : void
      {
         if(!this._living.actionMovie.shouldReplace)
         {
            this._living.actionMovie.direction = this._direction;
         }
         _isFinished = true;
      }
      
      override public function executeAtOnce() : void
      {
         super.executeAtOnce();
         this._living.actionMovie.direction = this._direction;
      }
   }
}

