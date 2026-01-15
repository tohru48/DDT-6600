package room.view.states
{
   import com.pickgliss.ui.LayerManager;
   import ddt.manager.GameInSocketOut;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.states.BaseStateView;
   import ddt.states.StateType;
   import ddt.utils.PositionUtils;
   import ddt.view.MainToolBar;
   import room.RoomManager;
   import room.model.RoomInfo;
   import room.view.roomView.DungeonRoomView;
   import trainer.data.ArrowType;
   import trainer.data.Step;
   import trainer.view.NewHandContainer;
   
   public class DungeonRoomState extends BaseRoomState
   {
      
      public function DungeonRoomState()
      {
         super();
      }
      
      override public function enter(prev:BaseStateView, data:Object = null) : void
      {
         _roomView = new DungeonRoomView(RoomManager.Instance.current);
         PositionUtils.setPos(_roomView,"asset.ddtroom.matchroomstate.pos");
         addChild(_roomView);
         super.enter(prev,data);
         if(!PlayerManager.Instance.Self.isDungeonGuideFinish(Step.DUNGEON_GUIDE_1))
         {
            SocketManager.Instance.out.syncWeakStep(Step.DUNGEON_GUIDE_1);
         }
         if(!PlayerManager.Instance.Self.isDungeonGuideFinish(Step.DUNGEON_GUIDE_2))
         {
            NewHandContainer.Instance.showArrow(ArrowType.DUNGEON_GUIDE,0,"guide.dungeon.step2ArrowPos","asset.trainer.dungeonGuide2Txt","guide.dungeon.step2TipPos",LayerManager.Instance.getLayerByType(LayerManager.GAME_TOP_LAYER));
         }
      }
      
      override public function leaving(next:BaseStateView) : void
      {
         NewHandContainer.Instance.clearArrowByID(ArrowType.DUNGEON_GUIDE);
         MainToolBar.Instance.hide();
         if(Boolean(_info) && _info.selfRoomPlayer.isHost)
         {
            if(RoomManager.Instance.current.isOpenBoss)
            {
               GameInSocketOut.sendGameRoomSetUp(10000,RoomInfo.DUNGEON_ROOM,true,_info.roomPass,_info.roomName,1,_info.hardLevel,0,false,_info.mapId);
            }
            else
            {
               GameInSocketOut.sendGameRoomSetUp(10000,RoomInfo.DUNGEON_ROOM,false,_info.roomPass,_info.roomName,1,0,0,false,0);
            }
         }
         super.leaving(next);
      }
      
      override public function getType() : String
      {
         return StateType.DUNGEON_ROOM;
      }
      
      override public function getBackType() : String
      {
         return StateType.DUNGEON_LIST;
      }
   }
}

