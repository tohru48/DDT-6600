package game.actions
{
   import ddt.manager.GameInSocketOut;
   import game.model.LocalPlayer;
   
   public class SelfSkipAction extends BaseAction
   {
      
      private var _info:LocalPlayer;
      
      public function SelfSkipAction(info:LocalPlayer)
      {
         super();
         this._info = info;
      }
      
      override public function prepare() : void
      {
         if(_isPrepare)
         {
            return;
         }
         GameInSocketOut.sendGameSkipNext(this._info.shootTime);
         _isPrepare = true;
      }
   }
}

