package game.actions.SkillActions
{
   import com.pickgliss.effect.BaseEffect;
   import game.GameManager;
   import game.animations.IAnimate;
   import game.model.Living;
   import game.model.Player;
   import game.objects.MirariType;
   import game.view.effects.MirariEffectIconManager;
   import road7th.comm.PackageIn;
   
   public class ResolveHurtAction extends SkillAction
   {
      
      private var _pkg:PackageIn;
      
      private var _scr:Living;
      
      public function ResolveHurtAction(animate:IAnimate, src:Living, pkg:PackageIn)
      {
         this._pkg = pkg;
         this._scr = src;
         super(animate);
      }
      
      override protected function finish() : void
      {
         var player:Player = null;
         var living:Living = null;
         var count:int = this._pkg.readInt();
         for(var i:int = 0; i < count; i++)
         {
            living = GameManager.Instance.Current.findLiving(this._pkg.readInt());
            if(living.isPlayer() && living.isLiving)
            {
               player = Player(living);
               player.handleMirariEffect(MirariEffectIconManager.getInstance().createEffectIcon(MirariType.ResolveHurt));
            }
         }
         player = Player(this._scr);
         player.handleMirariEffect(MirariEffectIconManager.getInstance().createEffectIcon(MirariType.ResolveHurt));
         super.finish();
      }
   }
}

