package game.actions
{
   import game.objects.GameLiving;
   
   public class LivingTurnAction extends BaseAction
   {
      
      public static const PLUS:int = 0;
      
      public static const REDUCE:int = 1;
      
      private var _movie:GameLiving;
      
      private var _rotation:int;
      
      private var _speed:int;
      
      private var _endPlay:String;
      
      private var _dir:int;
      
      private var _turnRo:int;
      
      public function LivingTurnAction(movie:GameLiving, $rotation:int, speed:int, endPlay:String)
      {
         super();
         _isFinished = false;
         this._movie = movie;
         this._rotation = $rotation;
         this._speed = speed;
         this._endPlay = endPlay;
      }
      
      override public function connect(action:BaseAction) : Boolean
      {
         var turn:LivingTurnAction = action as LivingTurnAction;
         if(Boolean(turn))
         {
            this._rotation = turn._rotation;
            this._speed = turn._speed;
            this._endPlay = turn._endPlay;
            this._dir = this._movie.rotation > this._rotation ? REDUCE : PLUS;
            return true;
         }
         return false;
      }
      
      override public function prepare() : void
      {
         if(Boolean(this._movie))
         {
            this._dir = this._movie.rotation > this._rotation ? REDUCE : PLUS;
            this._turnRo = this._movie.rotation;
         }
         else
         {
            _isFinished = true;
         }
      }
      
      override public function execute() : void
      {
         if(this._dir == PLUS)
         {
            if(this._turnRo + this._speed >= this._rotation)
            {
               this.finish();
            }
            else
            {
               this._turnRo += this._speed;
               this._movie.rotation = this._turnRo;
            }
         }
         else if(this._turnRo - this._speed <= this._rotation)
         {
            this.finish();
         }
         else
         {
            this._turnRo -= this._speed;
            this._movie.rotation = this._turnRo;
         }
      }
      
      private function finish() : void
      {
         this._movie.rotation = this._rotation;
         this._movie.doAction(this._endPlay);
         _isFinished = true;
      }
      
      override public function executeAtOnce() : void
      {
         super.executeAtOnce();
         this._movie.rotation = this._rotation;
         this._movie.doAction(this._endPlay);
      }
   }
}

