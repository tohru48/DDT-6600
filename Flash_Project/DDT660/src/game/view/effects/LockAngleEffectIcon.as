package game.view.effects
{
   import game.model.Living;
   import game.objects.MirariType;
   
   public class LockAngleEffectIcon extends BaseMirariEffectIcon
   {
      
      public function LockAngleEffectIcon()
      {
         _iconClass = "asset.game.lockAngelAsset";
         super();
      }
      
      override public function get mirariType() : int
      {
         return MirariType.LockAngl;
      }
      
      override protected function excuteEffectImp(live:Living) : void
      {
         live.isLockAngle = true;
         super.excuteEffectImp(live);
      }
      
      override public function unExcuteEffect(live:Living) : void
      {
         live.isLockAngle = false;
      }
   }
}

