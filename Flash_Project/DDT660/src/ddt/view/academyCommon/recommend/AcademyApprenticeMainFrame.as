package ddt.view.academyCommon.recommend
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.SelectedCheckButton;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.controls.container.HBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.vo.AlertInfo;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.player.AcademyPlayerInfo;
   import ddt.manager.AcademyFrameManager;
   import ddt.manager.AcademyManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SharedManager;
   import ddt.manager.SoundManager;
   import ddt.manager.StateManager;
   import ddt.states.StateType;
   import flash.display.Bitmap;
   import flash.events.MouseEvent;
   
   public class AcademyApprenticeMainFrame extends BaseAlerFrame implements Disposeable
   {
      
      public static const MAX_ITEM:int = 3;
      
      public static const BOTTOM_GAP:int = 11;
      
      protected var _recommendTitle:Bitmap;
      
      protected var _playerContainer:HBox;
      
      protected var _titleBtn:TextButton;
      
      protected var _alertInfo:AlertInfo;
      
      protected var _items:Array;
      
      protected var _players:Vector.<AcademyPlayerInfo>;
      
      protected var _treeImage:ScaleBitmapImage;
      
      protected var _treeImage2:Scale9CornerImage;
      
      protected var _currentItem:RecommendPlayerCellView;
      
      protected var _checkBoxBtn:SelectedCheckButton;
      
      public function AcademyApprenticeMainFrame()
      {
         super();
         this.initContent();
         this.initPlayerContainer();
         this.initEvent();
      }
      
      public function show() : void
      {
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      protected function initContent() : void
      {
         this._alertInfo = new AlertInfo();
         this._alertInfo.bottomGap = BOTTOM_GAP;
         this._alertInfo.customPos = ComponentFactory.Instance.creatCustomObject("academyCommon.myAcademy.gotoMainlPos");
         info = this._alertInfo;
         info.title = LanguageMgr.GetTranslation("ddt.view.academyCommon.recommend.AcademyApprenticeMainFrame.title");
         this._treeImage = ComponentFactory.Instance.creatComponentByStylename("AcademyApprenticeMainFrame.scale9cornerImageTree");
         addToContent(this._treeImage);
         this._treeImage2 = ComponentFactory.Instance.creatComponentByStylename("AcademyApprenticeMainFrame.scale9cornerImageTree2");
         addToContent(this._treeImage2);
         this._recommendTitle = ComponentFactory.Instance.creatBitmap("asset.ddtacademy.recommendTitleAsset");
         addToContent(this._recommendTitle);
         this._titleBtn = ComponentFactory.Instance.creatComponentByStylename("academyCommon.AcademyApprenticeMainFrame.titleBtn");
         this._titleBtn.text = LanguageMgr.GetTranslation("ddt.manager.showAcademyPreviewFrame.masterFree");
         addToContent(this._titleBtn);
         this._playerContainer = ComponentFactory.Instance.creatComponentByStylename("academyCommon.AcademyApprenticeMainFrame.playerContainer");
         addToContent(this._playerContainer);
         this._checkBoxBtn = ComponentFactory.Instance.creatComponentByStylename("ddt.view.academyCommon.recommend.AcademyApprenticeMainFrame.checkBoxBtn");
         this._checkBoxBtn.text = LanguageMgr.GetTranslation("ddt.view.academyCommon.recommend.AcademyApprenticeMainFrame.checkBoxBtnInfo");
         if(!SharedManager.Instance.isRecommend)
         {
            addToContent(this._checkBoxBtn);
         }
      }
      
      protected function initPlayerContainer() : void
      {
         var item:RecommendPlayerCellView = null;
         this._items = [];
         for(var i:int = 0; i < MAX_ITEM; i++)
         {
            item = new RecommendPlayerCellView();
            item.addEventListener(MouseEvent.CLICK,this.__itemClick);
            this._playerContainer.addChild(item);
            this._items.push(item);
         }
         this._players = AcademyManager.Instance.recommendPlayers;
         this.updateItem();
      }
      
      protected function initEvent() : void
      {
         this._titleBtn.addEventListener(MouseEvent.CLICK,this.__titleBtnClick);
         addEventListener(FrameEvent.RESPONSE,this.__frameEvent);
         this._checkBoxBtn.addEventListener(MouseEvent.CLICK,this.__checkBoxBtnClick);
      }
      
      private function __checkBoxBtnClick(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         SharedManager.Instance.isRecommend = this._checkBoxBtn.selected;
         SharedManager.Instance.save();
      }
      
      protected function __itemClick(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(!this._currentItem)
         {
            this._currentItem = event.currentTarget as RecommendPlayerCellView;
         }
         if(this._currentItem != event.currentTarget as RecommendPlayerCellView)
         {
            this._currentItem.isSelect = false;
         }
         this._currentItem = event.currentTarget as RecommendPlayerCellView;
         this._currentItem.isSelect = true;
      }
      
      protected function __frameEvent(event:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         switch(event.responseCode)
         {
            case FrameEvent.SUBMIT_CLICK:
            case FrameEvent.ENTER_CLICK:
               if(StateManager.currentStateType == StateType.ACADEMY_REGISTRATION)
               {
                  this.dispose();
               }
               AcademyManager.Instance.gotoAcademyState();
               break;
            case FrameEvent.ESC_CLICK:
            case FrameEvent.CLOSE_CLICK:
            case FrameEvent.CANCEL_CLICK:
               this.dispose();
         }
      }
      
      protected function __titleBtnClick(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         AcademyFrameManager.Instance.showRecommendAcademyPreviewFrame();
      }
      
      protected function updateItem() : void
      {
         for(var i:int = 0; i < MAX_ITEM; i++)
         {
            this._items[i].info = this._players[i];
         }
      }
      
      private function cleanItem() : void
      {
         if(!this._items)
         {
            return;
         }
         for(var i:int = 0; i < this._items.length; i++)
         {
            this._items[i].removeEventListener(MouseEvent.CLICK,this.__itemClick);
            this._items[i].dispose();
            this._items[i] = null;
         }
         this._playerContainer.disposeAllChildren();
         this._items = null;
      }
      
      override public function dispose() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__frameEvent);
         this._currentItem = null;
         this.cleanItem();
         if(Boolean(this._recommendTitle))
         {
            ObjectUtils.disposeObject(this._recommendTitle);
            this._recommendTitle = null;
         }
         if(Boolean(this._playerContainer))
         {
            ObjectUtils.disposeObject(this._playerContainer);
            this._playerContainer = null;
         }
         if(Boolean(this._checkBoxBtn))
         {
            this._checkBoxBtn.removeEventListener(MouseEvent.CLICK,this.__checkBoxBtnClick);
            this._checkBoxBtn.dispose();
            this._checkBoxBtn = null;
         }
         if(Boolean(this._titleBtn))
         {
            this._titleBtn.removeEventListener(MouseEvent.CLICK,this.__titleBtnClick);
            ObjectUtils.disposeObject(this._titleBtn);
            this._titleBtn = null;
         }
         if(Boolean(this._treeImage))
         {
            ObjectUtils.disposeObject(this._treeImage);
            this._treeImage = null;
         }
         if(Boolean(this._treeImage2))
         {
            ObjectUtils.disposeObject(this._treeImage2);
            this._treeImage2 = null;
         }
         super.dispose();
      }
   }
}

