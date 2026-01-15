package game.actions.SkillActions
{
   import game.actions.BaseAction;
   import game.animations.IAnimate;
   
   public class SkillAction extends BaseAction
   {
      
      private var _animate:IAnimate;
      
      private var _onComplete:Function;
      
      private var _onCompleteParams:Array;
      
      public function SkillAction(animate:IAnimate, onComplete:Function = null, onCompleteParams:Array = null)
      {
         super();
         this._animate = animate;
         this._onComplete = onComplete;
         this._onCompleteParams = onCompleteParams;
      }
      
      override public function execute() : void
      {
         if(this._animate != null)
         {
            if(this._animate.finish)
            {
               if(this._onComplete != null)
               {
                  this._onComplete.apply(null,this._onCompleteParams);
               }
               this.finish();
            }
         }
         else
         {
            this.finish();
         }
      }
      
      protected function finish() : void
      {
         _isFinished = true;
      }
   }
}

