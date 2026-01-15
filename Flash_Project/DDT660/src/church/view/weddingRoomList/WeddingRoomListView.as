package church.view.weddingRoomList
{
   import church.controller.ChurchRoomListController;
   import church.model.ChurchRoomListModel;
   import church.view.weddingRoomList.frame.WeddingRoomEnterConfirmView;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.MovieImage;
   import com.pickgliss.ui.image.MutipleImage;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.ChurchRoomInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import road7th.data.DictionaryEvent;
   
   public class WeddingRoomListView extends Sprite implements Disposeable
   {
      
      private var _controller:ChurchRoomListController;
      
      private var _model:ChurchRoomListModel;
      
      private var _bgJoinListAsset:MutipleImage;
      
      private var _btnPageFirstAsset:BaseButton;
      
      private var _btnPageBackAsset:BaseButton;
      
      private var _btnPageNextAsset:BaseButton;
      
      private var _btnPageLastAsset:BaseButton;
      
      private var _pageInfoText:FilterFrameText;
      
      private var _pageCount:int;
      
      private var _pageIndex:int = 1;
      
      private var _pageSize:int = 7;
      
      private var _weddingRoomListBox:VBox;
      
      private var _enterConfirmView:WeddingRoomEnterConfirmView;
      
      private var _titleBG:Bitmap;
      
      private var _titleTxt:FilterFrameText;
      
      private var _listBG:MovieImage;
      
      private var _titleLine:MovieImage;
      
      private var _roomListBG:ScaleBitmapImage;
      
      private var _menberListVLine:MutipleImage;
      
      private var _itemBG:MutipleImage;
      
      private var _pagePreBG:ScaleBitmapImage;
      
      private var _idTxt:FilterFrameText;
      
      private var _roomNameTxt:FilterFrameText;
      
      private var _numberTxt:FilterFrameText;
      
      private var _lblPageInfoBG:Scale9CornerImage;
      
      public function WeddingRoomListView(controller:ChurchRoomListController, model:ChurchRoomListModel)
      {
         super();
         this._controller = controller;
         this._model = model;
         this.initialize();
      }
      
      protected function initialize() : void
      {
         this.setView();
         this.setEvent();
         this.updateList();
      }
      
      private function setView() : void
      {
         this._bgJoinListAsset = ComponentFactory.Instance.creatComponentByStylename("churchroomlist.WeddingRoomListNavViewBG");
         addChild(this._bgJoinListAsset);
         this._titleBG = ComponentFactory.Instance.creatBitmap("asset.church.main.bgJoinListAsset");
         addChild(this._titleBG);
         this._titleTxt = ComponentFactory.Instance.creat("church.main.WeddingRoomListView.titleTxt");
         this._titleTxt.text = LanguageMgr.GetTranslation("church.weddingRoom.frame.AddWeddingRoomFrame.titleText");
         addChild(this._titleTxt);
         this._roomListBG = ComponentFactory.Instance.creatComponentByStylename("churchroomlist.WeddingRoomListBG");
         addChild(this._roomListBG);
         this._listBG = ComponentFactory.Instance.creatComponentByStylename("churchroomlist.WeddingRoomListBG.titleBG");
         addChild(this._listBG);
         this._titleLine = ComponentFactory.Instance.creatComponentByStylename("churchroomlist.WeddingRoomLine");
         addChild(this._titleLine);
         this._menberListVLine = ComponentFactory.Instance.creatComponentByStylename("church.main.WeddingRoomListTitle.Vline");
         addChild(this._menberListVLine);
         this._idTxt = ComponentFactory.Instance.creat("church.main.WeddingRoomList.idTxt");
         this._idTxt.text = LanguageMgr.GetTranslation("tank.ddthotSpringList.ID");
         addChild(this._idTxt);
         this._roomNameTxt = ComponentFactory.Instance.creat("church.main.WeddingRoomList.roomNameTxt");
         this._roomNameTxt.text = LanguageMgr.GetTranslation("ddt.matchRoom.setView.roomname");
         addChild(this._roomNameTxt);
         this._numberTxt = ComponentFactory.Instance.creat("church.main.WeddingRoomList.numberTxt");
         this._numberTxt.text = LanguageMgr.GetTranslation("tank.ddthotSpringList.peopleNum");
         addChild(this._numberTxt);
         this._itemBG = ComponentFactory.Instance.creatComponentByStylename("church.main.WeddingRoomListItem.BG");
         addChild(this._itemBG);
         this._weddingRoomListBox = ComponentFactory.Instance.creat("asset.church.main.WeddingRoomListBoxAsset");
         addChild(this._weddingRoomListBox);
         this._pagePreBG = ComponentFactory.Instance.creatComponentByStylename("churchroomlist.WeddingRoomList.pagePreBg");
         addChild(this._pagePreBG);
         this._lblPageInfoBG = ComponentFactory.Instance.creatComponentByStylename("church.main.lblPageInfo.wordBG");
         addChild(this._lblPageInfoBG);
         this._btnPageFirstAsset = ComponentFactory.Instance.creat("church.main.btnPageFirstAsset");
         addChild(this._btnPageFirstAsset);
         this._btnPageBackAsset = ComponentFactory.Instance.creat("church.main.btnPageBackAsset");
         addChild(this._btnPageBackAsset);
         this._btnPageNextAsset = ComponentFactory.Instance.creat("church.main.btnPageNextAsset");
         addChild(this._btnPageNextAsset);
         this._btnPageLastAsset = ComponentFactory.Instance.creat("church.main.btnPageLastAsset");
         addChild(this._btnPageLastAsset);
         this._pageInfoText = ComponentFactory.Instance.creat("church.main.lblPageInfo");
         addChild(this._pageInfoText);
      }
      
      private function removeView() : void
      {
         if(Boolean(this._bgJoinListAsset))
         {
            if(Boolean(this._bgJoinListAsset.parent))
            {
               this._bgJoinListAsset.parent.removeChild(this._bgJoinListAsset);
            }
         }
         this._bgJoinListAsset = null;
         if(Boolean(this._titleBG))
         {
            if(Boolean(this._titleBG.parent))
            {
               this._titleBG.parent.removeChild(this._titleBG);
            }
            this._titleBG.bitmapData.dispose();
            this._titleBG.bitmapData = null;
         }
         this._titleBG = null;
         if(Boolean(this._titleTxt))
         {
            if(Boolean(this._titleTxt.parent))
            {
               this._titleTxt.parent.removeChild(this._titleTxt);
            }
            this._titleTxt.dispose();
         }
         this._titleTxt = null;
         if(Boolean(this._roomListBG))
         {
            ObjectUtils.disposeObject(this._roomListBG);
         }
         this._roomListBG = null;
         if(Boolean(this._listBG))
         {
            if(Boolean(this._listBG.parent))
            {
               this._listBG.parent.removeChild(this._listBG);
            }
         }
         this._listBG = null;
         if(Boolean(this._titleLine))
         {
            if(Boolean(this._titleLine.parent))
            {
               this._titleLine.parent.removeChild(this._titleLine);
            }
         }
         this._titleLine = null;
         this._menberListVLine = null;
         this._itemBG = null;
         this._pagePreBG = null;
         this._lblPageInfoBG.dispose();
         this._lblPageInfoBG = null;
         this._idTxt = null;
         this._roomNameTxt = null;
         this._numberTxt = null;
         if(Boolean(this._btnPageFirstAsset))
         {
            if(Boolean(this._btnPageFirstAsset.parent))
            {
               this._btnPageFirstAsset.parent.removeChild(this._btnPageFirstAsset);
            }
            this._btnPageFirstAsset.dispose();
         }
         this._btnPageFirstAsset = null;
         if(Boolean(this._btnPageBackAsset))
         {
            if(Boolean(this._btnPageBackAsset.parent))
            {
               this._btnPageBackAsset.parent.removeChild(this._btnPageBackAsset);
            }
            this._btnPageBackAsset.dispose();
         }
         this._btnPageBackAsset = null;
         if(Boolean(this._btnPageNextAsset))
         {
            if(Boolean(this._btnPageNextAsset.parent))
            {
               this._btnPageNextAsset.parent.removeChild(this._btnPageNextAsset);
            }
            this._btnPageNextAsset.dispose();
         }
         this._btnPageNextAsset = null;
         if(Boolean(this._btnPageLastAsset))
         {
            if(Boolean(this._btnPageLastAsset.parent))
            {
               this._btnPageLastAsset.parent.removeChild(this._btnPageLastAsset);
            }
            this._btnPageLastAsset.dispose();
         }
         this._btnPageLastAsset = null;
         if(Boolean(this._enterConfirmView))
         {
            if(Boolean(this._enterConfirmView.parent))
            {
               this._enterConfirmView.parent.removeChild(this._enterConfirmView);
            }
            this._enterConfirmView.dispose();
         }
         this._enterConfirmView = null;
         if(Boolean(this._pageInfoText))
         {
            ObjectUtils.disposeObject(this._pageInfoText);
         }
         this._pageInfoText = null;
         if(Boolean(this._weddingRoomListBox))
         {
            ObjectUtils.disposeObject(this._weddingRoomListBox);
         }
         this._weddingRoomListBox = null;
      }
      
      private function setEvent() : void
      {
         this._model.roomList.addEventListener(DictionaryEvent.ADD,this.updateList);
         this._model.roomList.addEventListener(DictionaryEvent.REMOVE,this.updateList);
         this._model.roomList.addEventListener(DictionaryEvent.UPDATE,this.updateList);
         this._btnPageFirstAsset.addEventListener(MouseEvent.CLICK,this.getPageList);
         this._btnPageBackAsset.addEventListener(MouseEvent.CLICK,this.getPageList);
         this._btnPageNextAsset.addEventListener(MouseEvent.CLICK,this.getPageList);
         this._btnPageLastAsset.addEventListener(MouseEvent.CLICK,this.getPageList);
      }
      
      private function removeEvent() : void
      {
         this._btnPageFirstAsset.removeEventListener(MouseEvent.CLICK,this.getPageList);
         this._btnPageBackAsset.removeEventListener(MouseEvent.CLICK,this.getPageList);
         this._btnPageNextAsset.removeEventListener(MouseEvent.CLICK,this.getPageList);
         this._btnPageLastAsset.removeEventListener(MouseEvent.CLICK,this.getPageList);
      }
      
      private function getPageList(evt:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         switch(evt.target)
         {
            case this._btnPageFirstAsset:
               this.pageIndex = 1;
               break;
            case this._btnPageBackAsset:
               this.pageIndex = this.pageIndex - 1 > 0 ? this.pageIndex - 1 : 1;
               break;
            case this._btnPageNextAsset:
               this.pageIndex = this.pageIndex + 1 <= this.pageCount ? this.pageIndex + 1 : this.pageCount;
               break;
            case this._btnPageLastAsset:
               this.pageIndex = this.pageCount;
         }
      }
      
      public function updateList(event:DictionaryEvent = null) : void
      {
         var churchRoomInfo:ChurchRoomInfo = null;
         var item:WeddingRoomListItemView = null;
         this._weddingRoomListBox.disposeAllChildren();
         this._btnPageFirstAsset.enable = this._btnPageBackAsset.enable = this.pageCount > 0 && this.pageIndex > 1;
         this._btnPageNextAsset.enable = this._btnPageLastAsset.enable = this.pageCount > 0 && this.pageIndex < this.pageCount;
         this.updatePageText();
         if(!this.currentDataList || this.currentDataList.length <= 0)
         {
            return;
         }
         var pageList:Array = this.currentDataList.slice(this._pageIndex * this._pageSize - this._pageSize,this._pageIndex * this._pageSize <= this.currentDataList.length ? this._pageIndex * this._pageSize : this.currentDataList.length);
         for each(churchRoomInfo in pageList)
         {
            item = ComponentFactory.Instance.creatCustomObject("church.view.WeddingRoomListItemView");
            item.churchRoomInfo = churchRoomInfo;
            this._weddingRoomListBox.addChild(item);
            item.addEventListener(MouseEvent.CLICK,this.__itemClick);
         }
      }
      
      private function updatePageText() : void
      {
         this._pageInfoText.text = this._pageIndex + "/" + this._pageCount;
      }
      
      private function __itemClick(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         event.stopImmediatePropagation();
         var item:WeddingRoomListItemView = event.currentTarget as WeddingRoomListItemView;
         this._enterConfirmView = ComponentFactory.Instance.creat("church.main.weddingRoomList.WeddingRoomEnterConfirmView");
         this._enterConfirmView.controller = this._controller;
         this._enterConfirmView.churchRoomInfo = item.churchRoomInfo;
         this._enterConfirmView.show();
      }
      
      public function get currentDataList() : Array
      {
         var arr:Array = null;
         if(Boolean(this._model) && Boolean(this._model.roomList))
         {
            arr = this._model.roomList.list;
            arr.sortOn("id",Array.NUMERIC);
            return arr;
         }
         return null;
      }
      
      public function get pageIndex() : int
      {
         return this._pageIndex;
      }
      
      public function set pageIndex(value:int) : void
      {
         this._pageIndex = value;
         this.updateList();
      }
      
      public function get pageCount() : int
      {
         this._pageCount = this.currentDataList.length / this._pageSize;
         if(this.currentDataList.length % this._pageSize > 0)
         {
            this._pageCount += 1;
         }
         this._pageCount = this._pageCount == 0 ? 1 : this._pageCount;
         return this._pageCount;
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         this.removeView();
      }
   }
}

