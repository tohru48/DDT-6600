package room.view.states
{
   import ddt.manager.SocketManager;
   import ddt.states.BaseStateView;
   import ddt.states.StateType;
   import ddt.utils.PositionUtils;
   import ddt.view.MainToolBar;
   import flash.events.Event;
   import room.RoomManager;
   import room.model.RoomInfo;
   import room.view.roomView.MatchRoomView;
   import trainer.data.Step;
   
   public class MatchRoomState extends BaseRoomState
   {
      
      public function MatchRoomState()
      {
         super();
      }
      
      override public function enter(prev:BaseStateView, data:Object = null) : void
      {
         _roomView = new MatchRoomView(RoomManager.Instance.current);
         PositionUtils.setPos(_roomView,"asset.ddtroom.matchroomstate.pos");
         addChild(_roomView);
         super.enter(prev,data);
      }
      
      override protected function __startLoading(e:Event) : void
      {
         super.__startLoading(e);
         SocketManager.Instance.out.syncWeakStep(Step.CREATE_ROOM_TIP);
         SocketManager.Instance.out.syncWeakStep(Step.START_GAME_TIP);
      }
      
      override public function getType() : String
      {
         return StateType.MATCH_ROOM;
      }
      
      override public function getBackType() : String
      {
         if(RoomManager.Instance.current.type == RoomInfo.ENTERTAINMENT_ROOM || RoomManager.Instance.current.type == RoomInfo.ENTERTAINMENT_ROOM_PK)
         {
            return StateType.MAIN;
         }
         return StateType.ROOM_LIST;
      }
      
      override public function leaving(next:BaseStateView) : void
      {
         MainToolBar.Instance.hide();
         super.leaving(next);
      }
   }
}

