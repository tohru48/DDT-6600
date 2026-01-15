package ddt.manager
{
   import com.pickgliss.utils.ClassUtils;
   import flash.display.MovieClip;
   import game.GameManager;
   import game.model.Living;
   import game.model.Player;
   import game.objects.MirariType;
   import game.objects.SkillType;
   import game.view.effects.BaseMirariEffectIcon;
   import game.view.effects.LimitMaxForceEffectIcon;
   import game.view.effects.MirariEffectIconManager;
   import game.view.effects.ReduceStrengthEffect;
   import road7th.comm.PackageIn;
   
   public class SkillManager
   {
      
      public function SkillManager()
      {
         super();
      }
      
      public static function solveWeaponSkillMovieName(id:int) : String
      {
         return solveSkillMovieName(id);
      }
      
      public static function solveSkillMovieName(id:int) : String
      {
         return "tank.resource.skill.weapon" + id;
      }
      
      public static function createWeaponSkillMovieAsset(id:int) : MovieClip
      {
         return createSkillMovieAsset(id);
      }
      
      public static function createSkillMovieAsset(id:int) : MovieClip
      {
         return ClassUtils.CreatInstance(solveSkillMovieName(id)) as MovieClip;
      }
      
      public static function applySkillToLiving(skill:int, livingID:int, ... arg) : void
      {
         switch(skill)
         {
            case SkillType.ForbidFly:
               applyForbidFly(livingID);
               break;
            case SkillType.ReduceDander:
               applyReduceDander(livingID,arg[0]);
               break;
            case SkillType.ChangeTurnTime:
               applyChangeTurnTime(livingID,arg[0],arg[1]);
               break;
            case SkillType.LimitMaxForce:
               applyLimitMaxForce(livingID,arg[0]);
               break;
            case SkillType.ReduceStrength:
               applyReduceStrength(livingID,arg[0]);
               break;
            case SkillType.ResolveHurt:
               applyResolveHurt(livingID,arg[0]);
               break;
            case SkillType.Revert:
               applyRevert(livingID,arg[0]);
         }
      }
      
      public static function removeSkillFromLiving(skill:int, livingID:int, ... arg) : void
      {
         switch(skill)
         {
            case SkillType.ResolveHurt:
               removeResolveHurt(livingID,arg[0]);
         }
      }
      
      private static function applyReduceStrength(livingid:int, strength:int) : void
      {
         var effect:ReduceStrengthEffect = null;
         var living:Living = GameManager.Instance.Current.findLiving(livingid);
         if(living.isPlayer() && living.isLiving)
         {
            effect = MirariEffectIconManager.getInstance().createEffectIcon(MirariType.ReduceStrength) as ReduceStrengthEffect;
            effect.strength = strength;
            if(effect != null)
            {
            }
         }
      }
      
      private static function applyLimitMaxForce(livingid:int, maxForce:int) : void
      {
         var effect:LimitMaxForceEffectIcon = null;
         var living:Living = GameManager.Instance.Current.findLiving(livingid);
         if(living.isPlayer() && living.isLiving)
         {
            effect = MirariEffectIconManager.getInstance().createEffectIcon(MirariType.LimitMaxForce) as LimitMaxForceEffectIcon;
            effect.force = maxForce;
            if(effect != null)
            {
            }
         }
      }
      
      private static function applyChangeTurnTime(livingid:int, time:int, reverse:int) : void
      {
         var player:Player = null;
         var living:Living = GameManager.Instance.Current.findLiving(livingid);
         if(living.isPlayer() && living.isLiving)
         {
            player = living as Player;
         }
      }
      
      private static function applyReduceDander(livingid:int, dander:int) : void
      {
         var player:Player = null;
         var living:Living = GameManager.Instance.Current.findLiving(livingid);
         if(living.isPlayer() && living.isLiving)
         {
            player = living as Player;
            player.dander = dander;
         }
      }
      
      private static function applyForbidFly(livingid:int) : void
      {
         var living:Living = GameManager.Instance.Current.findLiving(livingid);
         var baseEffect:BaseMirariEffectIcon = MirariEffectIconManager.getInstance().createEffectIcon(MirariType.DisenableFly);
         if(baseEffect != null && living.isLiving)
         {
         }
      }
      
      private static function applyResolveHurt(livingid:int, pkg:PackageIn) : void
      {
         var living:Living = GameManager.Instance.Current.findLiving(livingid);
         if(living.isLiving)
         {
            living.applySkill(SkillType.ResolveHurt,pkg);
         }
      }
      
      private static function removeResolveHurt(livingid:int, pkg:PackageIn) : void
      {
         var player:Player = null;
         var living:Living = GameManager.Instance.Current.findLiving(livingid);
         if(living && living.isPlayer() && living.isLiving)
         {
            player = Player(living);
            player.removeSkillMovie(2);
            player.removeMirariEffect(MirariEffectIconManager.getInstance().createEffectIcon(MirariType.ResolveHurt));
         }
         var count:int = pkg.readInt();
         for(var i:int = 0; i < count; i++)
         {
            living = GameManager.Instance.Current.findLiving(pkg.readInt());
            if(living.isPlayer() && living.isLiving)
            {
               player = Player(living);
               player.removeSkillMovie(2);
               player.removeMirariEffect(MirariEffectIconManager.getInstance().createEffectIcon(MirariType.ResolveHurt));
            }
         }
      }
      
      private static function applyRevert(livingid:int, pkg:PackageIn) : void
      {
         var living:Living = GameManager.Instance.Current.findLiving(livingid);
         if(living.isLiving)
         {
            living.applySkill(SkillType.Revert,pkg);
         }
      }
   }
}

