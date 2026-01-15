package bagAndInfo.info
{
   import bagAndInfo.BagAndGiftFrame;
   import bagAndInfo.BagAndInfoManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import ddt.data.player.PlayerInfo;
   import ddt.events.PlayerPropertyEvent;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.StateManager;
   import ddt.states.StateType;
   
   public class PlayerInfoViewControl
   {
      
      private static var _view:PlayerInfoFrame;
      
      private static var _tempInfo:PlayerInfo;
      
      public static var isOpenFromBag:Boolean;
      
      public static var isOpenFromBattle:Boolean;
      
      public static var _isBattle:Boolean;
      
      public static var currentPlayer:PlayerInfo;
      
      public function PlayerInfoViewControl()
      {
         super();
      }
      
      public static function view(info:*, achivEnable:Boolean = true, bool:Boolean = false, isBombKing:Boolean = false) : void
      {
         _isBattle = bool;
         if(info && _isBattle)
         {
            if(_view == null)
            {
               _view = ComponentFactory.Instance.creatComponentByStylename("bag.personelInfoViewFrame");
            }
            _view.info = info;
            _view.show();
            _view.setAchivEnable(achivEnable);
            _view.addEventListener(FrameEvent.RESPONSE,__responseHandler);
            return;
         }
         if(info && info is PlayerInfo)
         {
            if(info.Style != null)
            {
               if(_view == null)
               {
                  _view = ComponentFactory.Instance.creatComponentByStylename("bag.personelInfoViewFrame");
               }
               _view.info = info;
               _view.show();
               _view.setAchivEnable(achivEnable);
               _view.addEventListener(FrameEvent.RESPONSE,__responseHandler);
            }
            else
            {
               info.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,__infoChange);
            }
            if(isBombKing)
            {
               SocketManager.Instance.out.updateBKingItemEquip(info.ID,info.ZoneID,0);
               SocketManager.Instance.out.updateBKingItemEquip(info.ID,info.ZoneID,1);
               SocketManager.Instance.out.updateBKingItemEquip(info.ID,info.ZoneID,2);
            }
            else
            {
               SocketManager.Instance.out.getPlayerCardInfo(info.ID);
               SocketManager.Instance.out.sendItemEquip(info.ID);
               SocketManager.Instance.out.sendUpdatePetInfo(info.ID);
            }
         }
      }
      
      private static function __infoChange(evt:PlayerPropertyEvent) : void
      {
         if(Boolean(PlayerInfo(evt.currentTarget).Style))
         {
            PlayerInfo(evt.target).removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,__infoChange);
            if(_view == null)
            {
               _view = ComponentFactory.Instance.creatComponentByStylename("bag.personelInfoViewFrame");
            }
            _view.info = PlayerInfo(evt.target);
            _view.show();
            _view.addEventListener(FrameEvent.RESPONSE,__responseHandler);
         }
      }
      
      public static function viewByID(id:int, zoneID:int = -1, achivEnable:Boolean = true, _isbattle:Boolean = false, isBombKing:Boolean = false) : void
      {
         var info:PlayerInfo = PlayerManager.Instance.findPlayer(id,zoneID);
         if(zoneID != -1)
         {
            info.ZoneID = zoneID;
         }
         view(info,achivEnable,_isbattle,isBombKing);
      }
      
      public static function viewByNickName(nickName:String, zoneID:int = -1, achivEnable:Boolean = true) : void
      {
         _tempInfo = new PlayerInfo();
         _tempInfo = PlayerManager.Instance.findPlayerByNickName(_tempInfo,nickName);
         if(Boolean(_tempInfo.ID))
         {
            view(_tempInfo,achivEnable);
         }
         else
         {
            SocketManager.Instance.out.sendItemEquip(_tempInfo.NickName,true);
            _tempInfo.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,__IDChange);
         }
      }
      
      private static function __IDChange(evt:PlayerPropertyEvent) : void
      {
         _tempInfo.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,__IDChange);
         view(_tempInfo);
      }
      
      private static function __responseHandler(evt:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         switch(evt.responseCode)
         {
            case FrameEvent.CLOSE_CLICK:
            case FrameEvent.ESC_CLICK:
               clearView();
               if(isOpenFromBag && StateManager.currentStateType != StateType.FIGHTING)
               {
                  BagAndInfoManager.Instance.showBagAndInfo(BagAndGiftFrame.GIFTVIEW);
               }
               isOpenFromBag = false;
         }
      }
      
      public static function closeView() : void
      {
         if(Boolean(_view) && Boolean(_view.parent))
         {
            _view.removeEventListener(FrameEvent.RESPONSE,__responseHandler);
         }
         _view = null;
      }
      
      public static function clearView() : void
      {
         if(Boolean(_view))
         {
            _view.removeEventListener(FrameEvent.RESPONSE,__responseHandler);
            _view.dispose();
         }
         _view = null;
      }
   }
}

