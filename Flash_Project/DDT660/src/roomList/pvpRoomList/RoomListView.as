package roomList.pvpRoomList
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SoundManager;
   import ddt.manager.StateManager;
   import ddt.states.StateType;
   import ddt.utils.PositionUtils;
   import flash.events.MouseEvent;
   import labyrinth.LabyrinthManager;
   
   public class RoomListView extends Frame implements Disposeable
   {
      
      private var _roomListBg:RoomListBGView;
      
      private var _playerList:RoomListPlayerListView;
      
      private var _model:RoomListModel;
      
      private var _controller:RoomListController;
      
      private var _chatBtn:SimpleBitmapButton;
      
      public function RoomListView()
      {
         super();
         this.initEvent();
      }
      
      private function initEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__frameEventHandler);
      }
      
      public function initView(controller:RoomListController, model:RoomListModel) : void
      {
         titleText = LanguageMgr.GetTranslation("tank.hall.ChooseHallView.roomList");
         this._model = model;
         this._controller = controller;
         this._roomListBg = new RoomListBGView(this._controller,this._model);
         addToContent(this._roomListBg);
         this._playerList = new RoomListPlayerListView(this._model.getPlayerList());
         PositionUtils.setPos(this._playerList,"roomList.playerListPos");
         addToContent(this._playerList);
         this._chatBtn = ComponentFactory.Instance.creatComponentByStylename("hall.chatButton");
         this._chatBtn.addEventListener(MouseEvent.CLICK,this.__chatClick);
         PositionUtils.setPos(this._chatBtn,"roomList.chatButtonPos");
         this._chatBtn.tipData = LanguageMgr.GetTranslation("tank.game.ToolStripView.chat");
         addChild(this._chatBtn);
      }
      
      private function __chatClick(event:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         LabyrinthManager.Instance.chat();
      }
      
      private function __frameEventHandler(event:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         switch(event.responseCode)
         {
            case FrameEvent.ESC_CLICK:
            case FrameEvent.CLOSE_CLICK:
               StateManager.currentStateType = StateType.MAIN;
               RoomListController.instance.hide();
         }
      }
      
      private function removeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__frameEventHandler);
         if(Boolean(this._chatBtn))
         {
            this._chatBtn.removeEventListener(MouseEvent.CLICK,this.__chatClick);
         }
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         if(Boolean(this._controller))
         {
            this._controller.dispose();
            this._controller = null;
         }
         if(Boolean(this._roomListBg))
         {
            this._roomListBg.dispose();
            this._roomListBg = null;
         }
         if(Boolean(this._playerList))
         {
            this._playerList.dispose();
            this._playerList = null;
         }
         if(Boolean(this._chatBtn))
         {
            ObjectUtils.disposeObject(this._chatBtn);
            this._chatBtn = null;
         }
         super.dispose();
         if(Boolean(parent))
         {
            this.parent.removeChild(this);
         }
      }
   }
}

