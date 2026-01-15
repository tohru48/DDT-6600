package game.actions.SkillActions
{
   import game.GameManager;
   import game.animations.IAnimate;
   import game.model.Living;
   import road7th.comm.PackageIn;
   
   public class RevertAction extends SkillAction
   {
      
      private var _pkg:PackageIn;
      
      private var _src:Living;
      
      public function RevertAction(animate:IAnimate, src:Living, pkg:PackageIn)
      {
         this._pkg = pkg;
         this._src = src;
         super(animate);
      }
      
      override protected function finish() : void
      {
         var living:Living = null;
         var count:int = this._pkg.readInt();
         var livings:Vector.<Living> = new Vector.<Living>();
         for(var i:int = 0; i < count; i++)
         {
            livings.push(GameManager.Instance.Current.findLiving(this._pkg.readInt()));
         }
         var addValue:int = this._pkg.readInt();
         for each(living in livings)
         {
            living.updateBlood(living.blood + addValue,0,addValue);
         }
         super.finish();
      }
   }
}

