package labyrinth.view
{
   import baglocked.BaglockedManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import ddtBuried.BuriedManager;
   import flash.events.MouseEvent;
   import game.TryAgain;
   import game.model.MissionAgainInfo;
   
   public class LabyrinthTryAgain extends TryAgain
   {
      
      public function LabyrinthTryAgain(info:MissionAgainInfo, isShowNum:Boolean = true)
      {
         super(info,isShowNum);
      }
      
      override protected function __tryagainClick(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         if(BuriedManager.Instance.checkMoney(false,_info.value))
         {
            return;
         }
         tryagain(false);
      }
   }
}

