package room.view.states
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SoundManager;
   import ddt.manager.StateManager;
   import ddt.states.BaseStateView;
   import ddt.states.StateType;
   import ddt.view.MainToolBar;
   import room.RoomManager;
   import room.view.roomView.MissionRoomView;
   
   public class MissionRoomState extends BaseRoomState
   {
      
      public function MissionRoomState()
      {
         super();
      }
      
      override public function enter(prev:BaseStateView, data:Object = null) : void
      {
         _roomView = new MissionRoomView(RoomManager.Instance.current);
         addChild(_roomView);
         MainToolBar.Instance.backFunction = this.leaveAlert;
         super.enter(prev,data);
      }
      
      private function leaveAlert() : void
      {
         var alert:BaseAlerFrame = null;
         if(RoomManager.Instance.current.selfRoomPlayer.isViewer)
         {
            StateManager.setState(StateType.DUNGEON_LIST);
         }
         else
         {
            alert = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("tank.missionsettle.dungeon.leaveConfirm.contents"),"",LanguageMgr.GetTranslation("cancel"),true,true,false,LayerManager.BLCAK_BLOCKGOUND);
            alert.moveEnable = false;
            alert.addEventListener(FrameEvent.RESPONSE,this.__onResponse);
         }
      }
      
      private function __onResponse(evt:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         if(evt.responseCode == FrameEvent.ENTER_CLICK || evt.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            StateManager.setState(StateType.DUNGEON_LIST);
         }
      }
      
      override public function getType() : String
      {
         return StateType.MISSION_ROOM;
      }
      
      override public function leaving(next:BaseStateView) : void
      {
         MainToolBar.Instance.backFunction = null;
         super.leaving(next);
      }
      
      override public function getBackType() : String
      {
         return StateType.DUNGEON_LIST;
      }
   }
}

