package church.view.weddingRoom.frame
{
   import church.controller.ChurchRoomController;
   import church.model.ChurchRoomModel;
   import church.vo.PlayerVO;
   import com.pickgliss.events.ListItemEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.ListPanel;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import ddt.data.player.PlayerInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import road7th.data.DictionaryData;
   import road7th.data.DictionaryEvent;
   
   public class WeddingRoomGuestListView extends Sprite implements Disposeable
   {
      
      private var _bg:ScaleBitmapImage;
      
      private var _bg1:Scale9CornerImage;
      
      private var _controller:ChurchRoomController;
      
      private var _model:ChurchRoomModel;
      
      private var _btnGuestListClose:BaseButton;
      
      private var _guestListBox:Bitmap;
      
      private var _listPanel:ListPanel;
      
      private var _data:DictionaryData;
      
      private var _currentItem:WeddingRoomGuestListItemView;
      
      private var _titleTxt:FilterFrameText;
      
      private var _gradeText:FilterFrameText;
      
      private var _nameText:FilterFrameText;
      
      private var _sexText:FilterFrameText;
      
      public function WeddingRoomGuestListView(controller:ChurchRoomController, model:ChurchRoomModel)
      {
         super();
         this._controller = controller;
         this._model = model;
         this.initialize();
      }
      
      protected function initialize() : void
      {
         this._data = this._model.getPlayers();
         this.setView();
         this.setEvent();
         this.getGuestList();
      }
      
      private function setView() : void
      {
         this._bg = ComponentFactory.Instance.creatComponentByStylename("church.weddingRoom.guestFrameBg");
         addChild(this._bg);
         this._titleTxt = ComponentFactory.Instance.creat("ddtchurchroomlist.frame.WeddingRoomGuestListView.titleText");
         this._titleTxt.text = LanguageMgr.GetTranslation("tank.ddtchurchroomlist.frame.WeddingRoomGuestListView.titleText");
         addChild(this._titleTxt);
         this._bg1 = ComponentFactory.Instance.creat("church.weddingRoom.guestListBg");
         addChild(this._bg1);
         this._guestListBox = ComponentFactory.Instance.creat("asset.church.room.guestListBoxAsset");
         addChild(this._guestListBox);
         this._gradeText = ComponentFactory.Instance.creat("ddtchurchroomlist.frame.WeddingRoomGuestListView.gradeText");
         this._gradeText.text = LanguageMgr.GetTranslation("ddt.cardSystem.cardsTipPanel.level");
         addChild(this._gradeText);
         this._nameText = ComponentFactory.Instance.creat("ddtchurchroomlist.frame.WeddingRoomGuestListView.nameText");
         this._nameText.text = LanguageMgr.GetTranslation("itemview.listname");
         addChild(this._nameText);
         this._sexText = ComponentFactory.Instance.creat("ddtchurchroomlist.frame.WeddingRoomGuestListView.sexText");
         this._sexText.text = LanguageMgr.GetTranslation("ddt.roomlist.right.sex");
         addChild(this._sexText);
         this._btnGuestListClose = ComponentFactory.Instance.creat("church.room.guestListCloseAsset");
         addChild(this._btnGuestListClose);
         this._listPanel = ComponentFactory.Instance.creatComponentByStylename("church.room.listGuestListAsset");
         addChild(this._listPanel);
         this._listPanel.list.updateListView();
         this._listPanel.list.addEventListener(ListItemEvent.LIST_ITEM_CLICK,this.itemClick);
      }
      
      private function getGuestList() : void
      {
         var playerInfo:PlayerInfo = null;
         var obj:Object = null;
         this._data.list.sort(this.compareFunction);
         for(var i:int = 0; i < this._data.length; i++)
         {
            playerInfo = (this._data.list[i] as PlayerVO).playerInfo;
            obj = this.changeData(playerInfo,i + 1);
            this._listPanel.vectorListModel.insertElementAt(obj,this.getInsertIndex(playerInfo));
         }
         this.addSelfItem();
         this.upSelfItem();
      }
      
      private function compareFunction(info1:PlayerVO, info2:PlayerVO) : int
      {
         if(info1.playerInfo.Grade >= info2.playerInfo.Grade)
         {
            return -1;
         }
         return 1;
      }
      
      private function itemClick(evt:ListItemEvent) : void
      {
         if(!this._currentItem)
         {
            this._currentItem = evt.cell as WeddingRoomGuestListItemView;
            this._currentItem.setListCellStatus(this._listPanel.list,true,evt.index);
         }
         if(this._currentItem != evt.cell as WeddingRoomGuestListItemView)
         {
            this._currentItem.setListCellStatus(this._listPanel.list,false,evt.index);
            this._currentItem = evt.cell as WeddingRoomGuestListItemView;
            this._currentItem.setListCellStatus(this._listPanel.list,true,evt.index);
         }
      }
      
      private function setEvent() : void
      {
         this._btnGuestListClose.addEventListener(MouseEvent.CLICK,this.closeView);
         this._data.addEventListener(DictionaryEvent.ADD,this.addGuest);
         this._data.addEventListener(DictionaryEvent.REMOVE,this.removeGuest);
      }
      
      private function addGuest(evt:DictionaryEvent) : void
      {
         this._listPanel.vectorListModel.clear();
         this.getGuestList();
      }
      
      private function getInsertIndex(info:PlayerInfo) : int
      {
         var tempIndex:int = 0;
         var tempArray:Array = this._listPanel.vectorListModel.elements;
         if(tempArray.length == 0)
         {
            return 0;
         }
         for(var i:int = 0; i < tempArray.length; i++)
         {
            if(info.Grade > (tempArray[i].playerInfo as PlayerInfo).Grade)
            {
               return tempIndex;
            }
            if(info.Grade <= (tempArray[i].playerInfo as PlayerInfo).Grade)
            {
               tempIndex = i + 1;
            }
         }
         return tempIndex;
      }
      
      private function removeGuest(evt:DictionaryEvent) : void
      {
         this._listPanel.vectorListModel.clear();
         this.getGuestList();
      }
      
      private function addSelfItem() : void
      {
         this._listPanel.vectorListModel.insertElementAt(this.changeData(PlayerManager.Instance.Self,0),0);
      }
      
      private function upSelfItem() : void
      {
         var selfInfo:PlayerInfo = this._data[PlayerManager.Instance.Self.ID];
         var index:int = this._listPanel.vectorListModel.indexOf(this.changeData(selfInfo,0));
         if(index == -1 || index == 0)
         {
            return;
         }
         this._listPanel.vectorListModel.removeAt(index);
         this._listPanel.vectorListModel.insertElementAt(this.changeData(selfInfo,0),0);
      }
      
      private function changeData(info:PlayerInfo, index:int) : Object
      {
         var obj:Object = new Object();
         obj["playerInfo"] = info;
         obj["index"] = index;
         return obj;
      }
      
      private function closeView(evt:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this.dispose();
      }
      
      public function show() : void
      {
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_TOP_LAYER);
      }
      
      private function removeView() : void
      {
         if(Boolean(this._bg))
         {
            if(Boolean(this._bg.parent))
            {
               this._bg.parent.removeChild(this._bg);
            }
            this._bg.dispose();
         }
         this._bg = null;
         if(Boolean(this._bg1))
         {
            if(Boolean(this._bg1.parent))
            {
               this._bg1.parent.removeChild(this._bg1);
            }
            this._bg1.dispose();
         }
         this._bg1 = null;
         if(Boolean(this._titleTxt))
         {
            if(Boolean(this._titleTxt.parent))
            {
               this._titleTxt.parent.removeChild(this._titleTxt);
            }
            this._titleTxt.dispose();
         }
         this._titleTxt = null;
         if(Boolean(this._gradeText))
         {
            if(Boolean(this._gradeText.parent))
            {
               this._gradeText.parent.removeChild(this._gradeText);
            }
            this._gradeText.dispose();
         }
         this._gradeText = null;
         if(Boolean(this._nameText))
         {
            if(Boolean(this._nameText.parent))
            {
               this._nameText.parent.removeChild(this._nameText);
            }
            this._nameText.dispose();
         }
         this._nameText = null;
         if(Boolean(this._sexText))
         {
            if(Boolean(this._sexText.parent))
            {
               this._sexText.parent.removeChild(this._sexText);
            }
            this._sexText.dispose();
         }
         this._sexText = null;
         if(Boolean(this._btnGuestListClose))
         {
            if(Boolean(this._btnGuestListClose.parent))
            {
               this._btnGuestListClose.parent.removeChild(this._btnGuestListClose);
            }
            this._btnGuestListClose.dispose();
         }
         this._btnGuestListClose = null;
         if(Boolean(this._guestListBox))
         {
            if(Boolean(this._guestListBox.parent))
            {
               this._guestListBox.parent.removeChild(this._guestListBox);
            }
            this._guestListBox.bitmapData.dispose();
            this._guestListBox.bitmapData = null;
         }
         this._guestListBox = null;
         if(Boolean(this._listPanel))
         {
            if(Boolean(this._listPanel.parent))
            {
               this._listPanel.parent.removeChild(this._listPanel);
            }
            this._listPanel.dispose();
         }
         this._listPanel = null;
         if(Boolean(this._currentItem))
         {
            if(Boolean(this._currentItem.parent))
            {
               this._currentItem.parent.removeChild(this._currentItem);
            }
            this._currentItem.dispose();
         }
         this._currentItem = null;
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
         dispatchEvent(new Event(Event.CLOSE));
      }
      
      private function removeEvent() : void
      {
         if(Boolean(this._btnGuestListClose))
         {
            this._btnGuestListClose.removeEventListener(MouseEvent.CLICK,this.closeView);
         }
         this._data.removeEventListener(DictionaryEvent.ADD,this.addGuest);
         this._data.removeEventListener(DictionaryEvent.REMOVE,this.removeGuest);
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         this.removeView();
      }
   }
}

