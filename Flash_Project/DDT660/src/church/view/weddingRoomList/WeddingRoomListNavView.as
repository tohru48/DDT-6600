package church.view.weddingRoomList
{
   import baglocked.BaglockedManager;
   import church.controller.ChurchRoomListController;
   import church.model.ChurchRoomListModel;
   import church.view.ChurchMainView;
   import church.view.weddingRoomList.frame.WeddingRoomCreateView;
   import church.view.weddingRoomList.frame.WeddingUnmarryView;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.MutipleImage;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.ChurchManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class WeddingRoomListNavView extends Sprite implements Disposeable
   {
      
      private var _controller:ChurchRoomListController;
      
      private var _model:ChurchRoomListModel;
      
      private var _bgNavAsset:MutipleImage;
      
      private var _btnCreateAsset:BaseButton;
      
      private var _btnJoinAsset:BaseButton;
      
      private var _btnDivorceAsset:BaseButton;
      
      private var _createRoomFrame:WeddingRoomCreateView;
      
      private var _weddingUnmarryView:WeddingUnmarryView;
      
      public function WeddingRoomListNavView(controller:ChurchRoomListController, model:ChurchRoomListModel)
      {
         super();
         this._controller = controller;
         this._model = model;
         this.initialize();
      }
      
      protected function initialize() : void
      {
         this.setView();
         this.addEvent();
      }
      
      private function setView() : void
      {
         this._bgNavAsset = ComponentFactory.Instance.creatComponentByStylename("churchroomlist.WeddingRoomListNavViewBG");
         addChild(this._bgNavAsset);
         this._btnCreateAsset = ComponentFactory.Instance.creat("church.main.btnCreateAsset");
         addChild(this._btnCreateAsset);
         this._btnJoinAsset = ComponentFactory.Instance.creat("church.main.btnJoinAsset");
         addChild(this._btnJoinAsset);
         this._btnDivorceAsset = ComponentFactory.Instance.creat("church.main.btnDivorceAsset");
         addChild(this._btnDivorceAsset);
         if(DivorcePromptFrame.Instance.isOpenDivorce == true)
         {
            this._openDivorce();
            DivorcePromptFrame.Instance.isOpenDivorce = false;
         }
      }
      
      private function removeView() : void
      {
         if(Boolean(this._bgNavAsset))
         {
            if(Boolean(this._bgNavAsset.parent))
            {
               this._bgNavAsset.parent.removeChild(this._bgNavAsset);
            }
         }
         this._bgNavAsset = null;
         if(Boolean(this._btnCreateAsset))
         {
            if(Boolean(this._btnCreateAsset.parent))
            {
               this._btnCreateAsset.parent.removeChild(this._btnCreateAsset);
            }
            this._btnCreateAsset.dispose();
         }
         this._btnCreateAsset = null;
         if(Boolean(this._btnJoinAsset))
         {
            if(Boolean(this._btnJoinAsset.parent))
            {
               this._btnJoinAsset.parent.removeChild(this._btnJoinAsset);
            }
            this._btnJoinAsset.dispose();
         }
         this._btnJoinAsset = null;
         if(Boolean(this._btnDivorceAsset))
         {
            if(Boolean(this._btnDivorceAsset.parent))
            {
               this._btnDivorceAsset.parent.removeChild(this._btnDivorceAsset);
            }
            this._btnDivorceAsset.dispose();
         }
         this._btnDivorceAsset = null;
         if(Boolean(this._createRoomFrame))
         {
            if(Boolean(this._createRoomFrame.parent))
            {
               this._createRoomFrame.parent.removeChild(this._createRoomFrame);
            }
            this._createRoomFrame.dispose();
         }
         this._createRoomFrame = null;
      }
      
      private function addEvent() : void
      {
         this._btnCreateAsset.addEventListener(MouseEvent.CLICK,this.onClickListener);
         this._btnJoinAsset.addEventListener(MouseEvent.CLICK,this.onClickListener);
         this._btnDivorceAsset.addEventListener(MouseEvent.CLICK,this.onClickListener);
      }
      
      private function removeEvent() : void
      {
         this._btnCreateAsset.removeEventListener(MouseEvent.CLICK,this.onClickListener);
         this._btnJoinAsset.removeEventListener(MouseEvent.CLICK,this.onClickListener);
         this._btnDivorceAsset.removeEventListener(MouseEvent.CLICK,this.onClickListener);
      }
      
      private function onClickListener(evt:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         switch(evt.currentTarget)
         {
            case this._btnCreateAsset:
               this.showWeddingRoomCreateView();
               break;
            case this._btnJoinAsset:
               this._controller.changeViewState(ChurchMainView.ROOM_LIST);
               break;
            case this._btnDivorceAsset:
               if(!PlayerManager.Instance.Self.IsMarried)
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("church.weddingRoom.RoomListBtnPanel.clickListener"));
                  return;
               }
               this._openDivorce();
               break;
         }
      }
      
      private function _openDivorce() : void
      {
         SocketManager.Instance.out.sendMateTime(PlayerManager.Instance.Self.SpouseID);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.MATE_ONLINE_TIME,this.__mateTime);
      }
      
      private function __mateTime(e:CrazyTankSocketEvent) : void
      {
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.MATE_ONLINE_TIME,this.__mateTime);
         var _date:Date = e.pkg.readDate();
         var needMoney:int = CalculateDate.needMoney(_date);
         this.showUnmarryFrame(_date,needMoney);
      }
      
      public function showWeddingRoomCreateView() : void
      {
         if(!PlayerManager.Instance.Self.IsMarried)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("church.weddingRoom.WeddingRoomControler.showCreateFrame"));
            return;
         }
         if(Boolean(ChurchManager.instance.selfRoom))
         {
            SocketManager.Instance.out.sendEnterRoom(0,"");
            return;
         }
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         this._createRoomFrame = ComponentFactory.Instance.creat("church.main.weddingRoomList.weddingRoomCreateView");
         this._createRoomFrame.setController(this._controller,this._model);
         this._createRoomFrame.show();
      }
      
      public function showUnmarryFrame(spouseLastDate:Date, needMoney:int) : void
      {
         var arr:Array = CalculateDate.start(spouseLastDate);
         this._weddingUnmarryView = ComponentFactory.Instance.creat("church.weddingRoomList.frame.WeddingUnmarryView");
         this._weddingUnmarryView.controller = this._controller;
         this._weddingUnmarryView.setText(arr[0],arr[1]);
         this._weddingUnmarryView.show(needMoney);
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         this.removeView();
      }
   }
}

