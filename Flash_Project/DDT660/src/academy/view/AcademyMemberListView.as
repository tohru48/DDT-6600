package academy.view
{
   import academy.AcademyController;
   import academy.AcademyEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.controls.TextInput;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ClassUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.player.AcademyPlayerInfo;
   import ddt.manager.AcademyFrameManager;
   import ddt.manager.AcademyManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class AcademyMemberListView extends Sprite implements Disposeable
   {
      
      public static const ITEM_NUM:int = 12;
      
      private var _rightBg:Scale9CornerImage;
      
      private var _rightViewBg:MovieClip;
      
      private var _pagePreBg:ScaleBitmapImage;
      
      private var _pageLastBg:Scale9CornerImage;
      
      private var _searchBG:Scale9CornerImage;
      
      private var _masterTitle:SimpleBitmapButton;
      
      private var _apprenticeTitle:SimpleBitmapButton;
      
      private var _searchBtn:TextButton;
      
      private var _titleline1:ScaleBitmapImage;
      
      private var _titleline2:ScaleBitmapImage;
      
      private var _titleline3:ScaleBitmapImage;
      
      private var _preBtn:SimpleBitmapButton;
      
      private var _nextBtn:SimpleBitmapButton;
      
      private var _freeBtn:TextButton;
      
      private var _nameTitle:FilterFrameText;
      
      private var _levelTitle:FilterFrameText;
      
      private var _stateTitle:FilterFrameText;
      
      private var _fightpowerTitle:FilterFrameText;
      
      private var _pageTxt:FilterFrameText;
      
      private var _searchTxt:TextInput;
      
      private var _items:Vector.<AcademyMemberItem>;
      
      private var _list:VBox;
      
      private var _controller:AcademyController;
      
      private var _currentPage:int = 1;
      
      private var _selectedItem:AcademyMemberItem;
      
      private var _takeMasterBtn:BaseButton;
      
      private var _takeStudentBtn:BaseButton;
      
      private var _isShowSearchInfo:Boolean = false;
      
      private var _timer:Timer;
      
      public function AcademyMemberListView(controller:AcademyController)
      {
         super();
         this._controller = controller;
         this.init();
         this.initEvent();
      }
      
      private function init() : void
      {
         this._rightBg = ComponentFactory.Instance.creatComponentByStylename("asset.ddtAcademyPlayerPanel.rightBg");
         addChild(this._rightBg);
         this._rightViewBg = ClassUtils.CreatInstance("asset.ddtacademy.rightListBgAsset") as MovieClip;
         PositionUtils.setPos(this._rightViewBg,"AcademyMemberListView.rightListBg");
         addChild(this._rightViewBg);
         this._nameTitle = ComponentFactory.Instance.creatComponentByStylename("ddtacademy.nameTitle");
         this._nameTitle.text = LanguageMgr.GetTranslation("itemview.listname");
         addChild(this._nameTitle);
         this._levelTitle = ComponentFactory.Instance.creatComponentByStylename("ddtacademy.levelTitle");
         this._levelTitle.text = LanguageMgr.GetTranslation("itemview.listlevel");
         addChild(this._levelTitle);
         this._fightpowerTitle = ComponentFactory.Instance.creatComponentByStylename("ddtacademy.fightpowerTitle");
         this._fightpowerTitle.text = LanguageMgr.GetTranslation("itemview.listfightpower");
         addChild(this._fightpowerTitle);
         this._stateTitle = ComponentFactory.Instance.creatComponentByStylename("ddtacademy.stateTitle");
         this._stateTitle.text = LanguageMgr.GetTranslation("itemview.liststate");
         addChild(this._stateTitle);
         this._titleline1 = ComponentFactory.Instance.creatComponentByStylename("asset.ddtacademy.formIineBig1");
         addChild(this._titleline1);
         this._titleline2 = ComponentFactory.Instance.creatComponentByStylename("asset.ddtacademy.formIineBig2");
         addChild(this._titleline2);
         this._titleline3 = ComponentFactory.Instance.creatComponentByStylename("asset.ddtacademy.formIineBig3");
         addChild(this._titleline3);
         this._masterTitle = ComponentFactory.Instance.creatComponentByStylename("asset.ddtacademy.MasterTitleBg");
         addChild(this._masterTitle);
         this._apprenticeTitle = ComponentFactory.Instance.creatComponentByStylename("asset.ddtacademy.ApprenticeTitleBg");
         addChild(this._apprenticeTitle);
         this._searchBG = ComponentFactory.Instance.creatComponentByStylename("ddtacademy.searchBg");
         addChild(this._searchBG);
         this._pagePreBg = ComponentFactory.Instance.creatComponentByStylename("asset.ddtacademy.pagePreBg");
         addChild(this._pagePreBg);
         this._pageLastBg = ComponentFactory.Instance.creatComponentByStylename("ddtacademy.pageLastBg");
         addChild(this._pageLastBg);
         this._pageTxt = ComponentFactory.Instance.creat("academy.AcademyMemberListView.page");
         addChild(this._pageTxt);
         this._searchBtn = ComponentFactory.Instance.creatComponentByStylename("academy.ddtAcademyMemberListView.searchBtn");
         this._searchBtn.text = LanguageMgr.GetTranslation("civil.rightview.searchBtnTxt");
         addChild(this._searchBtn);
         this._preBtn = ComponentFactory.Instance.creatComponentByStylename("academy.ddtAcademyMemberListView.preBtn");
         addChild(this._preBtn);
         this._nextBtn = ComponentFactory.Instance.creatComponentByStylename("academy.ddtAcademyMemberListView.nextBtn");
         addChild(this._nextBtn);
         this._takeStudentBtn = ComponentFactory.Instance.creatComponentByStylename("academy.ddtAcademyMemberListView.takeStudentBtn");
         addChild(this._takeStudentBtn);
         this._takeMasterBtn = ComponentFactory.Instance.creatComponentByStylename("academy.ddtAcademyMemberListView.takeMasterBtn");
         addChild(this._takeMasterBtn);
         this._freeBtn = ComponentFactory.Instance.creatComponentByStylename("academy.AcademyMemberListView.freeBtn");
         this._freeBtn.text = LanguageMgr.GetTranslation("academy.rightview.freeBtnTxt");
         addChild(this._freeBtn);
         this._searchTxt = ComponentFactory.Instance.creat("academy.ddtAcademyMemberListView.searchText");
         this._searchTxt.text = LanguageMgr.GetTranslation("academy.view.AcademyMemberListView.searchTxt");
         addChild(this._searchTxt);
         this._list = ComponentFactory.Instance.creatComponentByStylename("academy.AcademyMemberListView.List");
         addChild(this._list);
         this.creatItems();
         this._controller.model.state = PlayerManager.Instance.Self.Grade >= AcademyManager.ACADEMY_LEVEL_MIN ? true : false;
         this._timer = new Timer(500,1);
      }
      
      private function initEvent() : void
      {
         this._takeMasterBtn.addEventListener(MouseEvent.CLICK,this.__takeMasterClick);
         this._takeStudentBtn.addEventListener(MouseEvent.CLICK,this.__takeStudentClick);
         this._searchBtn.addEventListener(MouseEvent.CLICK,this.__searchBtnClick);
         this._preBtn.addEventListener(MouseEvent.CLICK,this.__leafBtnClick);
         this._nextBtn.addEventListener(MouseEvent.CLICK,this.__leafBtnClick);
         this._freeBtn.addEventListener(MouseEvent.CLICK,this.__freeBtnClick);
         this._controller.addEventListener(AcademyEvent.ACADEMY_UPDATE_LIST,this.__updateList);
         this._searchTxt.addEventListener(MouseEvent.CLICK,this.__searchTxtClick);
         AcademyManager.Instance.addEventListener(AcademyManager.SELF_DESCRIBE,this.__selfDescribe);
         this._timer.addEventListener(TimerEvent.TIMER_COMPLETE,this.__register);
      }
      
      private function removeEvent() : void
      {
         this._takeMasterBtn.removeEventListener(MouseEvent.CLICK,this.__takeMasterClick);
         this._takeStudentBtn.removeEventListener(MouseEvent.CLICK,this.__takeStudentClick);
         this._searchBtn.removeEventListener(MouseEvent.CLICK,this.__searchBtnClick);
         this._preBtn.removeEventListener(MouseEvent.CLICK,this.__leafBtnClick);
         this._nextBtn.removeEventListener(MouseEvent.CLICK,this.__leafBtnClick);
         this._freeBtn.removeEventListener(MouseEvent.CLICK,this.__freeBtnClick);
         this._controller.removeEventListener(AcademyEvent.ACADEMY_UPDATE_LIST,this.__updateList);
         this._searchTxt.removeEventListener(MouseEvent.CLICK,this.__searchTxtClick);
         AcademyManager.Instance.removeEventListener(AcademyManager.SELF_DESCRIBE,this.__selfDescribe);
         this._timer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.__register);
      }
      
      private function __selfDescribe(event:Event) : void
      {
         if(this._takeMasterBtn.visible && !AcademyManager.Instance.selfIsRegister)
         {
            this._takeMasterBtn.visible = false;
            this._takeStudentBtn.visible = true;
         }
      }
      
      private function __searchTxtClick(event:MouseEvent) : void
      {
         if(this._searchTxt.text == LanguageMgr.GetTranslation("academy.view.AcademyMemberListView.searchTxt"))
         {
            this._searchTxt.text = "";
         }
         else
         {
            this._searchTxt.textField.setSelection(0,this._searchTxt.text.length);
         }
      }
      
      private function creatItems() : void
      {
         var item:AcademyMemberItem = null;
         this._items = new Vector.<AcademyMemberItem>();
         for(var i:int = 0; i < ITEM_NUM; i++)
         {
            item = new AcademyMemberItem(i);
            item.visible = false;
            item.addEventListener(MouseEvent.CLICK,this.__itemClick);
            this._list.addChild(item);
            this._items.push(item);
         }
      }
      
      private function cleanItem() : void
      {
         for(var i:int = 0; i < this._items.length; i++)
         {
            (this._items[i] as AcademyMemberItem).removeEventListener(MouseEvent.CLICK,this.__itemClick);
            this._items[i].dispose();
         }
         this._list.disposeAllChildren();
         this._items = null;
      }
      
      private function __updateList(event:AcademyEvent) : void
      {
         var list:Vector.<AcademyPlayerInfo> = null;
         list = this._controller.model.list;
         if(list.length == 0)
         {
            this._isShowSearchInfo = false;
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("academy.view.AcademyMemberListView.registerInfoIII"));
            return;
         }
         for(var i:int = 0; i < list.length; i++)
         {
            this._items[i].visible = true;
            this._items[i].info = list[i];
         }
         for(var j:int = int(list.length); j < ITEM_NUM; j++)
         {
            this._items[j].visible = false;
         }
         if(Boolean(this._selectedItem))
         {
            this._selectedItem.isSelect = false;
            this._selectedItem = this._items[0];
            this._selectedItem.isSelect = true;
         }
         else
         {
            this._selectedItem = this._items[0];
            this._selectedItem.isSelect = true;
         }
         this.updateLeafBtn();
         this.updateListBG();
         this.updateRegisterBtn();
      }
      
      private function __takeMasterClick(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(this._selectedItem == null)
         {
            return;
         }
         if(AcademyManager.Instance.compareState(this._selectedItem.info.info,PlayerManager.Instance.Self))
         {
            AcademyFrameManager.Instance.showAcademyRequestMasterFrame(this._selectedItem.info.info);
         }
      }
      
      private function __takeStudentClick(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(this._selectedItem == null)
         {
            return;
         }
         if(PlayerManager.Instance.Self.apprenticeshipState != AcademyManager.APPRENTICE_STATE && AcademyManager.Instance.compareState(this._selectedItem.info.info,PlayerManager.Instance.Self))
         {
            AcademyFrameManager.Instance.showAcademyRequestApprenticeFrame(this._selectedItem.info.info);
         }
      }
      
      private function __freeBtnClick(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         AcademyFrameManager.Instance.showAcademyPreviewFrame();
      }
      
      private function __leafBtnClick(event:MouseEvent) : void
      {
         this._timer.reset();
         this._timer.start();
         SoundManager.instance.play("008");
         switch(event.currentTarget)
         {
            case this._preBtn:
               --this._currentPage;
               if(this._currentPage <= 1)
               {
                  this._currentPage = 1;
               }
               break;
            case this._nextBtn:
               ++this._currentPage;
         }
         this.updateLeafBtn();
      }
      
      private function __register(event:TimerEvent) : void
      {
         if(!this._isShowSearchInfo || this._searchTxt.text == LanguageMgr.GetTranslation("academy.view.AcademyMemberListView.searchTxt"))
         {
            this._controller.loadAcademyMemberList(true,this._controller.model.state,this._currentPage);
         }
         else
         {
            this._controller.loadAcademyMemberList(true,this._controller.model.state,this._currentPage,this._searchTxt.text);
         }
      }
      
      private function updateLeafBtn() : void
      {
         if(this._controller.model.totalPage <= 0)
         {
            this._takeStudentBtn.enable = false;
            this._takeMasterBtn.enable = false;
         }
         else
         {
            this._takeStudentBtn.enable = true;
            this._takeMasterBtn.enable = true;
         }
         if(this._controller.model.totalPage <= 1)
         {
            this.setButtonState(false,false);
         }
         else if(this._currentPage == 1)
         {
            this.setButtonState(false,true);
         }
         else if(this._currentPage == this._controller.model.totalPage && this._currentPage != 0)
         {
            this.setButtonState(true,false);
         }
         else
         {
            this.setButtonState(true,true);
         }
         if(this._controller.model.totalPage == 0)
         {
            this._pageTxt.text = String(1) + " / " + String(1);
         }
         else
         {
            this._pageTxt.text = String(this._currentPage) + " / " + String(this._controller.model.totalPage);
         }
      }
      
      private function updateListBG() : void
      {
         if(this._controller.model.state)
         {
            this._masterTitle.visible = false;
            this._apprenticeTitle.visible = true;
         }
         else
         {
            this._masterTitle.visible = true;
            this._apprenticeTitle.visible = false;
         }
      }
      
      private function updateRegisterBtn() : void
      {
         if(PlayerManager.Instance.Self.Grade <= 16)
         {
            this._takeMasterBtn.visible = true;
            this._takeStudentBtn.visible = false;
         }
         else if(PlayerManager.Instance.Self.Grade >= 20)
         {
            this._takeMasterBtn.visible = false;
            this._takeStudentBtn.visible = true;
         }
      }
      
      private function setButtonState($pre:Boolean, $next:Boolean) : void
      {
         this._preBtn.mouseChildren = $pre;
         this._preBtn.enable = $pre;
         this._nextBtn.mouseChildren = $next;
         this._nextBtn.enable = $next;
      }
      
      private function __searchBtnClick(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(this._searchTxt.text == "" || this._searchTxt.text == LanguageMgr.GetTranslation("academy.view.AcademyMemberListView.searchTxt"))
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("civil.view.CivilRightView.info"));
         }
         else
         {
            this._currentPage = 1;
            this._controller.loadAcademyMemberList(true,this._controller.model.state,this._currentPage,this._searchTxt.text);
            this._isShowSearchInfo = true;
         }
      }
      
      private function __itemClick(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(!this._selectedItem)
         {
            this._selectedItem = event.currentTarget as AcademyMemberItem;
         }
         if(this._selectedItem != event.currentTarget as AcademyMemberItem)
         {
            this._selectedItem.isSelect = false;
         }
         this._selectedItem = event.currentTarget as AcademyMemberItem;
         this._selectedItem.isSelect = true;
         this._controller.currentAcademyInfo = this._selectedItem.info;
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         this.cleanItem();
         if(Boolean(this._list))
         {
            this._list.dispose();
            this._list = null;
         }
         if(Boolean(this._rightViewBg))
         {
            ObjectUtils.disposeObject(this._rightViewBg);
            this._rightViewBg = null;
         }
         if(Boolean(this._searchBG))
         {
            ObjectUtils.disposeObject(this._searchBG);
            this._searchBG = null;
         }
         if(Boolean(this._pagePreBg))
         {
            ObjectUtils.disposeObject(this._pagePreBg);
            this._pagePreBg = null;
         }
         if(Boolean(this._pageLastBg))
         {
            ObjectUtils.disposeObject(this._pageLastBg);
            this._pageLastBg = null;
         }
         if(Boolean(this._nameTitle))
         {
            ObjectUtils.disposeObject(this._nameTitle);
            this._nameTitle = null;
         }
         if(Boolean(this._levelTitle))
         {
            ObjectUtils.disposeObject(this._levelTitle);
            this._levelTitle = null;
         }
         if(Boolean(this._fightpowerTitle))
         {
            ObjectUtils.disposeObject(this._fightpowerTitle);
            this._fightpowerTitle = null;
         }
         if(Boolean(this._stateTitle))
         {
            ObjectUtils.disposeObject(this._stateTitle);
            this._stateTitle = null;
         }
         if(Boolean(this._pageTxt))
         {
            ObjectUtils.disposeObject(this._pageTxt);
            this._pageTxt = null;
         }
         if(Boolean(this._searchBtn))
         {
            this._searchBtn.dispose();
            this._searchBtn = null;
         }
         if(Boolean(this._preBtn))
         {
            this._preBtn.dispose();
            this._preBtn = null;
         }
         if(Boolean(this._nextBtn))
         {
            this._nextBtn.dispose();
            this._nextBtn = null;
         }
         if(Boolean(this._takeMasterBtn))
         {
            this._takeMasterBtn.dispose();
            this._takeMasterBtn = null;
         }
         if(Boolean(this._searchTxt))
         {
            this._searchTxt.dispose();
            this._searchTxt = null;
         }
         if(Boolean(this._freeBtn))
         {
            this._freeBtn.dispose();
            this._freeBtn = null;
         }
         if(Boolean(this._selectedItem))
         {
            this._selectedItem.dispose();
            this._selectedItem = null;
         }
         if(Boolean(this._rightBg))
         {
            this._rightBg.dispose();
         }
         if(Boolean(this._masterTitle))
         {
            ObjectUtils.disposeObject(this._masterTitle);
            this._masterTitle = null;
         }
         if(Boolean(this._apprenticeTitle))
         {
            ObjectUtils.disposeObject(this._apprenticeTitle);
            this._apprenticeTitle = null;
         }
         if(Boolean(this._takeStudentBtn))
         {
            this._takeStudentBtn.dispose();
            this._takeStudentBtn = null;
         }
         if(Boolean(this._titleline1))
         {
            this._titleline1.dispose();
            this._titleline1 = null;
         }
         if(Boolean(this._titleline2))
         {
            this._titleline2.dispose();
            this._titleline2 = null;
         }
         if(Boolean(this._titleline3))
         {
            this._titleline3.dispose();
            this._titleline3 = null;
         }
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
   }
}

