package game.view.effects
{
   import game.model.Living;
   import game.objects.MirariType;
   
   public class DisenableFlyEffectIcon extends BaseMirariEffectIcon
   {
      
      public function DisenableFlyEffectIcon()
      {
         _iconClass = "asset.game.forbidFlyAsset";
         super();
      }
      
      override public function get mirariType() : int
      {
         return MirariType.DisenableFly;
      }
      
      override protected function excuteEffectImp(live:Living) : void
      {
         live.isLockFly = true;
         super.excuteEffectImp(live);
      }
      
      override public function unExcuteEffect(live:Living) : void
      {
         live.isLockFly = false;
      }
   }
}

