package civil.view
{
   import civil.CivilController;
   import civil.CivilEvent;
   import civil.CivilModel;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.SelectedButton;
   import com.pickgliss.ui.controls.SelectedButtonGroup;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.controls.TextInput;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ClassUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import im.IMController;
   
   public class CivilRightView extends Sprite implements Disposeable
   {
      
      private var _listBg:MovieClip;
      
      private var _bg:ScaleBitmapImage;
      
      private var _goldLinBg:ScaleBitmapImage;
      
      private var _formIineBig1:ScaleBitmapImage;
      
      private var _formIineBig2:ScaleBitmapImage;
      
      private var _preBtn:SimpleBitmapButton;
      
      private var _nextBtn:SimpleBitmapButton;
      
      private var _addBigBtn:SimpleBitmapButton;
      
      private var _pagePreBg:ScaleBitmapImage;
      
      private var _nameTitle:FilterFrameText;
      
      private var _levelTitle:FilterFrameText;
      
      private var _stateTitle:FilterFrameText;
      
      private var _pageTxt:FilterFrameText;
      
      private var _pageLastBg:Scale9CornerImage;
      
      private var _searchBG:Scale9CornerImage;
      
      private var _civilGenderGroup:SelectedButtonGroup;
      
      private var _maleBtn:SelectedButton;
      
      private var _femaleBtn:SelectedButton;
      
      private var _searchBtn:TextButton;
      
      private var _registerBtn:TextButton;
      
      private var _menberList:CivilPlayerInfoList;
      
      private var _controller:CivilController;
      
      private var _currentPage:int = 1;
      
      private var _model:CivilModel;
      
      private var _searchTxt:TextInput;
      
      private var _sex:Boolean;
      
      private var _loadMember:Boolean = false;
      
      private var _seachKey:String = "";
      
      private var _isBusy:Boolean;
      
      public function CivilRightView(controller:CivilController, model:CivilModel)
      {
         this._model = model;
         this._controller = controller;
         super();
         this.init();
         this.initButton();
         this.initEvnet();
         this._menberList.MemberList(this._model.civilPlayers);
         if(PlayerManager.Instance.Self.MarryInfoID <= 0 || !PlayerManager.Instance.Self.MarryInfoID)
         {
            SocketManager.Instance.out.sendRegisterInfo(PlayerManager.Instance.Self.ID,true,LanguageMgr.GetTranslation("civil.frame.CivilRegisterFrame.text"));
         }
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         if(Boolean(this._listBg))
         {
            removeChild(this._listBg);
         }
         if(Boolean(this._formIineBig1))
         {
            this._formIineBig1.dispose();
         }
         if(Boolean(this._formIineBig2))
         {
            this._formIineBig2.dispose();
         }
         if(Boolean(this._preBtn))
         {
            this._preBtn.dispose();
            this._preBtn = null;
         }
         if(Boolean(this._pagePreBg))
         {
            this._pagePreBg.dispose();
            this._pagePreBg = null;
         }
         if(Boolean(this._pageLastBg))
         {
            this._pageLastBg.dispose();
            this._pageLastBg = null;
         }
         if(Boolean(this._nextBtn))
         {
            this._nextBtn.dispose();
            this._nextBtn = null;
         }
         if(Boolean(this._bg))
         {
            this._bg.dispose();
            this._bg = null;
         }
         if(Boolean(this._goldLinBg))
         {
            this._goldLinBg.dispose();
            this._goldLinBg = null;
         }
         if(Boolean(this._registerBtn))
         {
            this._registerBtn.dispose();
            this._registerBtn = null;
         }
         if(Boolean(this._addBigBtn))
         {
            this._addBigBtn.dispose();
            this._addBigBtn = null;
         }
         if(Boolean(this._searchBtn))
         {
            this._searchBtn.dispose();
            this._searchBtn = null;
         }
         if(Boolean(this._femaleBtn))
         {
            this._femaleBtn.dispose();
            this._femaleBtn = null;
         }
         if(Boolean(this._maleBtn))
         {
            this._maleBtn.dispose();
            this._maleBtn = null;
         }
         if(Boolean(this._civilGenderGroup))
         {
            this._civilGenderGroup.dispose();
            this._civilGenderGroup = null;
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
         if(Boolean(this._stateTitle))
         {
            ObjectUtils.disposeObject(this._stateTitle);
            this._stateTitle = null;
         }
         if(Boolean(this._searchBG))
         {
            ObjectUtils.disposeObject(this._searchBG);
            this._searchBG = null;
         }
         if(Boolean(this._searchTxt))
         {
            ObjectUtils.disposeObject(this._searchTxt);
            this._searchTxt = null;
         }
         if(Boolean(this._pageTxt))
         {
            ObjectUtils.disposeObject(this._pageTxt);
            this._pageTxt = null;
         }
         if(Boolean(this._menberList))
         {
            ObjectUtils.disposeObject(this._menberList);
            this._menberList = null;
         }
      }
      
      public function init() : void
      {
         this._bg = ComponentFactory.Instance.creatComponentByStylename("asset.ddtcivil.rightView.bg");
         addChild(this._bg);
         this._goldLinBg = ComponentFactory.Instance.creatComponentByStylename("asset.ddtcivil.goldlinebg");
         addChild(this._goldLinBg);
         this._listBg = ClassUtils.CreatInstance("asset.ddtcivil.rightListBgAsset") as MovieClip;
         PositionUtils.setPos(this._listBg,"ddtcivil.rightListBg");
         addChild(this._listBg);
         this._formIineBig1 = ComponentFactory.Instance.creatComponentByStylename("asset.ddtcivil.formIineBig1");
         addChild(this._formIineBig1);
         this._formIineBig2 = ComponentFactory.Instance.creatComponentByStylename("asset.ddtcivil.formIineBig2");
         addChild(this._formIineBig2);
         this._nameTitle = ComponentFactory.Instance.creatComponentByStylename("ddtcivil.nameTitle");
         this._nameTitle.text = LanguageMgr.GetTranslation("itemview.listname");
         addChild(this._nameTitle);
         this._levelTitle = ComponentFactory.Instance.creatComponentByStylename("ddtcivil.levelTitle");
         this._levelTitle.text = LanguageMgr.GetTranslation("itemview.listlevel");
         addChild(this._levelTitle);
         this._stateTitle = ComponentFactory.Instance.creatComponentByStylename("ddtcivil.stateTitle");
         this._stateTitle.text = LanguageMgr.GetTranslation("itemview.liststate");
         addChild(this._stateTitle);
         this._searchBG = ComponentFactory.Instance.creatComponentByStylename("ddtcivil.searchBg");
         addChild(this._searchBG);
         this._searchTxt = ComponentFactory.Instance.creat("ddtcivil.searchText");
         this._searchTxt.text = LanguageMgr.GetTranslation("academy.view.AcademyMemberListView.searchTxt");
         addChild(this._searchTxt);
         this._menberList = ComponentFactory.Instance.creatCustomObject("civil.view.CivilPlayerInfoList");
         this._menberList.model = this._model;
         addChild(this._menberList);
         this._pagePreBg = ComponentFactory.Instance.creatComponentByStylename("ddtcivil.pagePreBg");
         addChild(this._pagePreBg);
         this._pageLastBg = ComponentFactory.Instance.creatComponentByStylename("ddtcivil.pageLastBg");
         addChild(this._pageLastBg);
         this._pageTxt = ComponentFactory.Instance.creat("ddtcivil.page");
         addChild(this._pageTxt);
      }
      
      private function initButton() : void
      {
         this._civilGenderGroup = new SelectedButtonGroup();
         this._searchBtn = ComponentFactory.Instance.creatComponentByStylename("asset.ddtcivil.searchBtn");
         this._searchBtn.text = LanguageMgr.GetTranslation("civil.rightview.searchBtnTxt");
         addChild(this._searchBtn);
         this._preBtn = ComponentFactory.Instance.creatComponentByStylename("asset.ddtcivil.preBtn");
         addChild(this._preBtn);
         this._nextBtn = ComponentFactory.Instance.creatComponentByStylename("asset.ddtcivil.nextBtn");
         addChild(this._nextBtn);
         this._registerBtn = ComponentFactory.Instance.creatComponentByStylename("asset.ddtcivil.registerTxtBtn");
         this._registerBtn.text = LanguageMgr.GetTranslation("civil.rightview.registerBtnTxt");
         addChild(this._registerBtn);
         this._addBigBtn = ComponentFactory.Instance.creatComponentByStylename("asset.ddtcivil.addBigTxtBtn");
         addChild(this._addBigBtn);
         this._maleBtn = ComponentFactory.Instance.creatComponentByStylename("asset.ddtcivil.maleButton");
         this._femaleBtn = ComponentFactory.Instance.creatComponentByStylename("asset.ddtcivil.femaleButton");
         addChild(this._maleBtn);
         addChild(this._femaleBtn);
         this._civilGenderGroup.addSelectItem(this._maleBtn);
         this._civilGenderGroup.addSelectItem(this._femaleBtn);
      }
      
      private function initEvnet() : void
      {
         this._preBtn.addEventListener(MouseEvent.CLICK,this.__leafBtnClick);
         this._nextBtn.addEventListener(MouseEvent.CLICK,this.__leafBtnClick);
         this._searchBtn.addEventListener(MouseEvent.CLICK,this.__leafBtnClick);
         this._maleBtn.addEventListener(MouseEvent.CLICK,this.__sexBtnClick);
         this._femaleBtn.addEventListener(MouseEvent.CLICK,this.__sexBtnClick);
         this._registerBtn.addEventListener(MouseEvent.CLICK,this.__btnClick);
         this._addBigBtn.addEventListener(MouseEvent.CLICK,this.__addBtnClick);
         this._searchTxt.addEventListener(MouseEvent.CLICK,this.__searchTxtClick);
         this._menberList.addEventListener(CivilEvent.SELECTED_CHANGE,this.__memberSelectedChange);
         this._model.addEventListener(CivilEvent.CIVIL_PLAYERINFO_ARRAY_CHANGE,this.__updateView);
         this._model.addEventListener(CivilEvent.REGISTER_CHANGE,this.__onRegisterChange);
      }
      
      private function removeEvent() : void
      {
         this._preBtn.removeEventListener(MouseEvent.CLICK,this.__leafBtnClick);
         this._nextBtn.removeEventListener(MouseEvent.CLICK,this.__leafBtnClick);
         this._searchBtn.removeEventListener(MouseEvent.CLICK,this.__leafBtnClick);
         this._maleBtn.removeEventListener(MouseEvent.CLICK,this.__sexBtnClick);
         this._femaleBtn.removeEventListener(MouseEvent.CLICK,this.__sexBtnClick);
         this._searchTxt.removeEventListener(MouseEvent.CLICK,this.__searchTxtClick);
         this._menberList.removeEventListener(CivilEvent.SELECTED_CHANGE,this.__memberSelectedChange);
         this._registerBtn.removeEventListener(MouseEvent.CLICK,this.__btnClick);
         this._addBigBtn.removeEventListener(MouseEvent.CLICK,this.__addBtnClick);
         this._model.removeEventListener(CivilEvent.CIVIL_PLAYERINFO_ARRAY_CHANGE,this.__updateView);
         this._model.removeEventListener(CivilEvent.REGISTER_CHANGE,this.__onRegisterChange);
      }
      
      private function __onRegisterChange(evt:CivilEvent) : void
      {
      }
      
      private function __btnClick(evt:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this._controller.Register();
      }
      
      private function __addBtnClick(e:MouseEvent) : void
      {
         if(Boolean(this._controller.currentcivilInfo) && Boolean(this._controller.currentcivilInfo.info))
         {
            SoundManager.instance.play("008");
            IMController.Instance.addFriend(this._controller.currentcivilInfo.info.NickName);
         }
      }
      
      private function __sexBtnClick(evt:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this._currentPage = 1;
         if(evt.currentTarget == this._femaleBtn)
         {
            this._sex = false;
            if(this._sex == this._model.sex)
            {
               return;
            }
            this._model.sex = false;
         }
         else
         {
            this._sex = true;
            if(this._sex == this._model.sex)
            {
               return;
            }
            this._model.sex = true;
         }
         this._sex = this._model.sex;
         this._controller.loadCivilMemberList(this._currentPage,this._model.sex);
         if(this._searchTxt.text != LanguageMgr.GetTranslation("academy.view.AcademyMemberListView.searchTxt"))
         {
            this._searchTxt.text = "";
         }
         else
         {
            this._searchTxt.text = LanguageMgr.GetTranslation("academy.view.AcademyMemberListView.searchTxt");
         }
         this._seachKey = "";
      }
      
      private function __leafBtnClick(evt:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(this._loadMember)
         {
            return;
         }
         if(this._isBusy)
         {
            return;
         }
         switch(evt.currentTarget)
         {
            case this._preBtn:
               this._currentPage = --this._currentPage;
               break;
            case this._nextBtn:
               this._currentPage = ++this._currentPage;
               break;
            case this._searchBtn:
               if(this._searchTxt.text == "" || this._searchTxt.text == LanguageMgr.GetTranslation("academy.view.AcademyMemberListView.searchTxt"))
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("civil.view.CivilRightView.info"));
               }
               else
               {
                  this._seachKey = this._searchTxt.text;
                  this._currentPage = 1;
                  this._controller.loadCivilMemberList(this._currentPage,this._sex,this._seachKey);
                  this._loadMember = true;
               }
               return;
         }
         this._isBusy = true;
         this._controller.loadCivilMemberList(this._currentPage,this._sex,this._seachKey);
      }
      
      private function __searchTxtClick(evt:MouseEvent) : void
      {
         if(this._searchTxt.text == LanguageMgr.GetTranslation("academy.view.AcademyMemberListView.searchTxt"))
         {
            this._searchTxt.text = "";
         }
      }
      
      private function __memberSelectedChange(evt:CivilEvent) : void
      {
         if(Boolean(evt.data))
         {
            this._addBigBtn.enable = this._menberList.selectedItem.info.UserId == PlayerManager.Instance.Self.ID ? false : true;
         }
      }
      
      private function updateButton() : void
      {
         if(this._model.TotalPage == 1)
         {
            this.setButtonState(false,false);
         }
         else if(this._model.TotalPage == 0)
         {
            this.setButtonState(false,false);
         }
         else if(this._currentPage == 1)
         {
            this.setButtonState(false,true);
         }
         else if(this._currentPage == this._model.TotalPage && this._currentPage != 0)
         {
            this.setButtonState(true,false);
         }
         else
         {
            this.setButtonState(true,true);
         }
         if(!this._model.TotalPage)
         {
            this._pageTxt.text = String(1) + " / " + String(1);
         }
         else
         {
            this._pageTxt.text = String(this._currentPage) + " / " + String(this._model.TotalPage);
         }
         this._addBigBtn.enable = this._addBigBtn.enable && this._model.civilPlayers.length > 0 ? true : false;
         this.updateSex();
      }
      
      private function updateSex() : void
      {
         if(this._model.sex)
         {
            this._civilGenderGroup.selectIndex = 0;
         }
         else
         {
            this._civilGenderGroup.selectIndex = 1;
         }
         this._sex = this._model.sex;
      }
      
      private function __updateRegisterGlow(evt:CivilEvent) : void
      {
      }
      
      private function setButtonState($pre:Boolean, $next:Boolean) : void
      {
         this._preBtn.mouseChildren = $pre;
         this._preBtn.enable = $pre;
         this._nextBtn.mouseChildren = $next;
         this._nextBtn.enable = $next;
      }
      
      private function __updateView(evt:CivilEvent) : void
      {
         this._isBusy = false;
         this.updateButton();
         this._loadMember = false;
      }
   }
}

