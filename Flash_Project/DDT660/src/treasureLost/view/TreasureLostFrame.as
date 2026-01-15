package treasureLost.view
{
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.GameInSocketOut;
   import ddt.manager.StateManager;
   import ddt.states.StateType;
   import flash.events.Event;
   import game.GameManager;
   import room.RoomManager;
   import room.model.RoomInfo;
   import treasureLost.controller.TreasureLostManager;
   
   public class TreasureLostFrame extends Frame
   {
      
      private var _treasureLostDiceView:TreasureLostDiceView;
      
      public function TreasureLostFrame()
      {
         super();
         this.initView();
         this.addEvent();
      }
      
      private function initView() : void
      {
         RoomManager.Instance.addEventListener(CrazyTankSocketEvent.GAME_ROOM_CREATE,this.__gameStart);
         GameManager.Instance.addEventListener(GameManager.START_LOAD,this.__onStartLoad);
      }
      
      private function addEvent() : void
      {
      }
      
      private function removeEvent() : void
      {
         RoomManager.Instance.removeEventListener(CrazyTankSocketEvent.GAME_ROOM_CREATE,this.__gameStart);
         GameManager.Instance.removeEventListener(GameManager.START_LOAD,this.__onStartLoad);
      }
      
      protected function __onStartLoad(event:Event) : void
      {
         var roomInfo:RoomInfo = RoomManager.Instance.current;
         if(GameManager.Instance.Current == null)
         {
            return;
         }
         StateManager.setState(StateType.ROOM_LOADING,GameManager.Instance.Current);
         this.dispose();
      }
      
      private function __gameStart(pEvent:CrazyTankSocketEvent) : void
      {
         RoomManager.Instance.removeEventListener(CrazyTankSocketEvent.GAME_ROOM_CREATE,this.__gameStart);
         if(TreasureLostManager.Instance.playerCurrentPath == TreasureLostManager.Instance.maxMapItemNum)
         {
            GameInSocketOut.sendGameRoomSetUp(TreasureLostManager.BIGBOSS,RoomInfo.TREASURELOST_ROOM,false,"","",3,0,0,false,TreasureLostManager.BIGBOSS);
         }
         else
         {
            GameInSocketOut.sendGameRoomSetUp(TreasureLostManager.SMALLBOSS,RoomInfo.TREASURELOST_ROOM,false,"","",3,0,0,false,TreasureLostManager.SMALLBOSS);
         }
         GameInSocketOut.sendGameStart();
      }
      
      public function addDiceView(type:int) : void
      {
         this._treasureLostDiceView = new TreasureLostDiceView();
         addToContent(this._treasureLostDiceView);
      }
      
      public function show() : void
      {
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_TOP_LAYER,true,LayerManager.ALPHA_BLOCKGOUND);
      }
      
      override public function dispose() : void
      {
         TreasureLostManager.Instance.isOpenFrame = false;
         this.removeEvent();
         super.dispose();
         if(Boolean(this._treasureLostDiceView))
         {
            ObjectUtils.disposeObject(this._treasureLostDiceView);
            this._treasureLostDiceView = null;
         }
      }
   }
}

