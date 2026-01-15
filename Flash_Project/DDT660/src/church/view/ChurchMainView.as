package church.view
{
   import bagAndInfo.cell.BagCell;
   import bagAndInfo.cell.CellFactory;
   import church.controller.ChurchRoomListController;
   import church.model.ChurchRoomListModel;
   import church.view.weddingRoomList.WeddingRoomListNavView;
   import church.view.weddingRoomList.WeddingRoomListView;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.MutipleImage;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.ChatManager;
   import ddt.manager.ItemManager;
   import ddt.manager.SocketManager;
   import ddt.utils.PositionUtils;
   import ddt.view.MainToolBar;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.geom.Point;
   
   public class ChurchMainView extends Sprite implements Disposeable
   {
      
      public static const NAV_PANEL:String = "btn panel";
      
      public static const ROOM_LIST:String = "room list";
      
      private var _controller:ChurchRoomListController;
      
      private var _model:ChurchRoomListModel;
      
      private var _titleMainAsset:Bitmap;
      
      private var _picPreviewAsset:MutipleImage;
      
      private var _chatFrame:Sprite;
      
      private var _weddingRoomListView:WeddingRoomListView;
      
      private var _weddingRoomListNavView:WeddingRoomListNavView;
      
      private var _currentState:String = "btn panel";
      
      private var _cell:BagCell;
      
      private var _BG:DisplayObject;
      
      private var _bg:Bitmap;
      
      public function ChurchMainView(controller:ChurchRoomListController, model:ChurchRoomListModel)
      {
         super();
         this._controller = controller;
         this._model = model;
         this.initialize();
      }
      
      protected function initialize() : void
      {
         var pos:Point = null;
         this._weddingRoomListNavView = new WeddingRoomListNavView(this._controller,this._model);
         this._weddingRoomListView = new WeddingRoomListView(this._controller,this._model);
         this._BG = ComponentFactory.Instance.creatCustomObject("background.churchroomlist.bg");
         addChild(this._BG);
         this._titleMainAsset = ComponentFactory.Instance.creatBitmap("asset.church.main.titleMainAsset");
         addChild(this._titleMainAsset);
         this._picPreviewAsset = ComponentFactory.Instance.creatComponentByStylename("church.main.picPreviewAsset");
         addChild(this._picPreviewAsset);
         this._bg = ComponentFactory.Instance.creatBitmap("equipretrieve.trieveCell0");
         PositionUtils.setPos(this._bg,"equipretrieve.trieveCell0.pos");
         addChild(this._bg);
         this._cell = CellFactory.instance.createPersonalInfoCell(-1,ItemManager.Instance.getTemplateById(9022),true) as BagCell;
         pos = ComponentFactory.Instance.creatCustomObject("church.view.WeddingRoomListItemView.cellPos");
         this._cell.x = pos.x;
         this._cell.y = pos.y;
         this._cell.setContentSize(60,60);
         addChild(this._cell);
         this.updateViewState();
         ChatManager.Instance.state = ChatManager.CHAT_WEDDINGLIST_STATE;
         this._chatFrame = ChatManager.Instance.view;
         addChild(this._chatFrame);
         ChatManager.Instance.setFocus();
      }
      
      public function changeState(state:String) : void
      {
         if(this._currentState == state)
         {
            return;
         }
         this._currentState = state;
         this.updateViewState();
      }
      
      private function updateViewState() : void
      {
         switch(this._currentState)
         {
            case NAV_PANEL:
               addChild(this._weddingRoomListNavView);
               MainToolBar.Instance.backFunction = null;
               if(Boolean(this._weddingRoomListView.parent))
               {
                  removeChild(this._weddingRoomListView);
                  this._weddingRoomListView.updateList();
               }
               break;
            case ROOM_LIST:
               SocketManager.Instance.out.sendMarryRoomLogin();
               addChild(this._weddingRoomListView);
               this._weddingRoomListView.updateList();
               MainToolBar.Instance.backFunction = this.returnClick;
               if(Boolean(this._weddingRoomListNavView.parent))
               {
                  removeChild(this._weddingRoomListNavView);
               }
         }
      }
      
      private function returnClick() : void
      {
         this.changeState(NAV_PANEL);
      }
      
      public function show() : void
      {
         this._controller.addChild(this);
      }
      
      public function dispose() : void
      {
         this._controller = null;
         this._model = null;
         if(Boolean(this._titleMainAsset))
         {
            if(Boolean(this._titleMainAsset.bitmapData))
            {
               this._titleMainAsset.bitmapData.dispose();
            }
            this._titleMainAsset.bitmapData = null;
         }
         this._titleMainAsset = null;
         if(Boolean(this._bg))
         {
            if(Boolean(this._bg.bitmapData))
            {
               this._bg.bitmapData.dispose();
            }
            this._bg.bitmapData = null;
         }
         this._bg = null;
         this._BG = null;
         if(Boolean(this._picPreviewAsset))
         {
            ObjectUtils.disposeObject(this._picPreviewAsset);
         }
         this._picPreviewAsset = null;
         if(Boolean(this._chatFrame))
         {
            ObjectUtils.disposeObject(this._chatFrame);
         }
         this._chatFrame = null;
         if(Boolean(this._weddingRoomListView))
         {
            ObjectUtils.disposeObject(this._weddingRoomListView);
         }
         this._weddingRoomListView = null;
         if(Boolean(this._weddingRoomListNavView))
         {
            ObjectUtils.disposeObject(this._weddingRoomListNavView);
         }
         this._weddingRoomListNavView = null;
         if(Boolean(this._cell))
         {
            ObjectUtils.disposeObject(this._cell);
         }
         this._cell = null;
      }
   }
}

