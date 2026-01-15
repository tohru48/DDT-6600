package game.actions.newHand
{
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import game.GameManager;
   import game.actions.BaseAction;
   import game.model.GameInfo;
   import room.RoomManager;
   import room.model.RoomInfo;
   import trainer.controller.WeakGuildManager;
   
   internal class BaseNewHandFightHelpAction extends BaseAction
   {
      
      protected var _gameInfo:GameInfo;
      
      public function BaseNewHandFightHelpAction()
      {
         super();
         this._gameInfo = GameManager.Instance.Current;
      }
      
      protected function get isInNewHandRoom() : Boolean
      {
         var roomInfo:RoomInfo = RoomManager.Instance.current;
         if(!this._gameInfo || !roomInfo)
         {
            return false;
         }
         return WeakGuildManager.Instance.switchUserGuide && this._gameInfo.livings.length == 2 && this._gameInfo.IsOneOnOne && (roomInfo.type == RoomInfo.MATCH_ROOM || roomInfo.type == RoomInfo.CHALLENGE_ROOM);
      }
      
      protected function showFightTip(tipStyle:String, duration:Number = 1) : void
      {
         MessageTipManager.getInstance().show(LanguageMgr.GetTranslation(tipStyle),0,false,duration);
      }
   }
}

