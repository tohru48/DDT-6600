package roomList.pveRoomList
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
   import flash.display.Bitmap;
   import flash.events.MouseEvent;
   import labyrinth.LabyrinthManager;
   import roomList.LookupEnumerate;
   import roomList.movingNotification.MovingNotificationManager;
   import trainer.data.ArrowType;
   import trainer.view.NewHandContainer;
   
   public class DungeonListView extends Frame implements Disposeable
   {
      
      private var _leaf:Bitmap;
      
      private var _dungeonListBGView:DungeonListBGView;
      
      private var _playerList:DungeonRoomListPlayerListView;
      
      private var _model:DungeonListModel;
      
      private var _controlle:DungeonListController;
      
      private var _chatBtn:SimpleBitmapButton;
      
      public function DungeonListView()
      {
         super();
         this.initEvent();
      }
      
      private function initEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__frameEventHandler);
      }
      
      public function initView(controller:DungeonListController, model:DungeonListModel) : void
      {
         titleText = LanguageMgr.GetTranslation("tank.hall.ChooseHallView.dungeon");
         this._controlle = controller;
         this._model = model;
         this._dungeonListBGView = new DungeonListBGView(this._controlle,this._model);
         PositionUtils.setPos(this._dungeonListBGView,"asset.ddtdungeonList.bgview.pos");
         addChild(this._dungeonListBGView);
         this._playerList = new DungeonRoomListPlayerListView(this._model.getPlayerList());
         this._playerList.type = LookupEnumerate.DUNGEON_LIST;
         PositionUtils.setPos(this._playerList,"dungeonList.playerListPos");
         addChild(this._playerList);
         this._leaf = ComponentFactory.Instance.creatBitmap("asset.ddtroomlist.pve.leaf");
         addChild(this._leaf);
         this._chatBtn = ComponentFactory.Instance.creatComponentByStylename("hall.chatButton");
         this._chatBtn.addEventListener(MouseEvent.CLICK,this.__chatClick);
         PositionUtils.setPos(this._chatBtn,"dungeonList.chatButtonPos");
         this._chatBtn.tipData = LanguageMgr.GetTranslation("tank.game.ToolStripView.chat");
         addChild(this._chatBtn);
      }
      
      private function __frameEventHandler(event:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         switch(event.responseCode)
         {
            case FrameEvent.ESC_CLICK:
            case FrameEvent.CLOSE_CLICK:
               StateManager.currentStateType = StateType.MAIN;
               DungeonListController.instance.hide();
         }
      }
      
      private function __chatClick(event:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         LabyrinthManager.Instance.chat();
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
         MovingNotificationManager.Instance.hide();
         if(Boolean(this._dungeonListBGView))
         {
            this._dungeonListBGView.dispose();
            this._dungeonListBGView = null;
         }
         if(Boolean(this._playerList) && Boolean(this._playerList.parent))
         {
            this._playerList.dispose();
            this._playerList = null;
         }
         if(Boolean(this._leaf))
         {
            this._leaf.bitmapData.dispose();
            this._leaf = null;
         }
         this._model = null;
         if(Boolean(this._controlle))
         {
            this._controlle.dispose();
            this._controlle = null;
         }
         if(Boolean(this._chatBtn))
         {
            ObjectUtils.disposeObject(this._chatBtn);
            this._chatBtn = null;
         }
         super.dispose();
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
         NewHandContainer.Instance.clearArrowByID(ArrowType.DUNGEON_GUIDE);
      }
   }
}

