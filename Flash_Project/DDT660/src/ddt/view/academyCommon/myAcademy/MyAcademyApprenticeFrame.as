package ddt.view.academyCommon.myAcademy
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.vo.AlertInfo;
   import ddt.data.player.PlayerInfo;
   import ddt.manager.AcademyManager;
   import ddt.manager.LanguageMgr;
   import ddt.utils.PositionUtils;
   import ddt.view.academyCommon.myAcademy.myAcademyItem.MyAcademyClassmateItem;
   import ddt.view.academyCommon.myAcademy.myAcademyItem.MyAcademyMasterItem;
   import flash.events.MouseEvent;
   import road7th.data.DictionaryEvent;
   
   public class MyAcademyApprenticeFrame extends MyAcademyMasterFrame implements Disposeable
   {
      
      private var _masterItem:MyAcademyMasterItem;
      
      private var _classmateItem:MyAcademyClassmateItem;
      
      private var _classmateItemII:MyAcademyClassmateItem;
      
      private var _masterInfo:PlayerInfo;
      
      private var _ApprenticeInfos:Vector.<PlayerInfo>;
      
      public function MyAcademyApprenticeFrame()
      {
         super();
      }
      
      override public function show() : void
      {
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      override protected function initContent() : void
      {
         _alertInfo = new AlertInfo();
         _alertInfo.title = LanguageMgr.GetTranslation("im.IMView.myAcademyBtnTips");
         _alertInfo.bottomGap = BOTTOM_GAP;
         _alertInfo.customPos = ComponentFactory.Instance.creatCustomObject("academyCommon.myAcademy.gotoMainlPos2");
         info = _alertInfo;
         _ItemButtomBg1 = ComponentFactory.Instance.creatComponentByStylename("asset.academyCommon.academyItemButtomBg1");
         addToContent(_ItemButtomBg1);
         _myAcademyTitle = ComponentFactory.Instance.creatBitmap("asset.academyCommon.myAcademy.myAcademyTitle");
         addToContent(_myAcademyTitle);
         _titleBtn = ComponentFactory.Instance.creatComponentByStylename("academyCommon.myAcademy.MyAcademyMasterFrame.titleBtn");
         _titleBtn.text = LanguageMgr.GetTranslation("ddt.manager.showAcademyPreviewFrame.masterFree");
         addToContent(_titleBtn);
         _myApprentice = AcademyManager.Instance.myAcademyPlayers;
         this.initItem();
      }
      
      override protected function initItem() : void
      {
         _myAcademyIcon = ComponentFactory.Instance.creatBitmap("asset.academyCommon.myAcademy.myAcademyMasterIcon");
         addToContent(_myAcademyIcon);
         _ItemButtomBg2 = ComponentFactory.Instance.creatComponentByStylename("asset.academyCommon.academyItemButtomBg2");
         addToContent(_ItemButtomBg2);
         _itemBG = ComponentFactory.Instance.creatComponentByStylename("asset.academyCommon.myAcademy.myAcademyMasterBG");
         addToContent(_itemBG);
         _nameTitle = ComponentFactory.Instance.creatComponentByStylename("academyCommon.MyAcademyMasterItem.nameTitle");
         _nameTitle.text = LanguageMgr.GetTranslation("ddt.view.academyCommon.academyIcon.MasterIcon");
         addToContent(_nameTitle);
         initItemContent();
         _nameTitleClass = ComponentFactory.Instance.creatComponentByStylename("academyCommon.MyAcademyClassmatesItem.nameTitle");
         _nameTitleClass.text = LanguageMgr.GetTranslation("ddt.view.academyCommon.academyIcon.ClassIcon");
         addToContent(_nameTitleClass);
         _levelTitleClass = ComponentFactory.Instance.creatComponentByStylename("academyCommon.MyAcademyClassmatesItem.levelTitle");
         _levelTitleClass.text = LanguageMgr.GetTranslation("itemview.listlevel");
         addToContent(_levelTitleClass);
         _offLineTitleClass = ComponentFactory.Instance.creatComponentByStylename("academyCommon.MyAcademyClassmatesItem.offLineTitle");
         _offLineTitleClass.text = LanguageMgr.GetTranslation("itemview.listOffLine");
         addToContent(_offLineTitleClass);
         _emailTitleClass = ComponentFactory.Instance.creatComponentByStylename("academyCommon.MyAcademyClassmatesItem.emailTitle");
         _emailTitleClass.text = LanguageMgr.GetTranslation("itemview.listLink");
         addToContent(_emailTitleClass);
         _disposeTitleClass = ComponentFactory.Instance.creatComponentByStylename("academyCommon.MyAcademyClassmatesItem.addFriendTitle");
         _disposeTitleClass.text = LanguageMgr.GetTranslation("civil.leftview.addName");
         addToContent(_disposeTitleClass);
         _titleline1 = ComponentFactory.Instance.creatComponentByStylename("asset.academyCommon.MyAcademyMasterItem.formIineBig1");
         addToContent(_titleline1);
         _titleline2 = ComponentFactory.Instance.creatComponentByStylename("asset.academyCommon.MyAcademyMasterItem.formIineBig2");
         addToContent(_titleline2);
         _titleline3 = ComponentFactory.Instance.creatComponentByStylename("asset.academyCommon.MyAcademyMasterItem.formIineBig3");
         addToContent(_titleline3);
         _titleline4 = ComponentFactory.Instance.creatComponentByStylename("asset.academyCommon.MyAcademyMasterItem.formIineBig4");
         addToContent(_titleline4);
         this._masterItem = new MyAcademyMasterItem();
         PositionUtils.setPos(this._masterItem,"academyCommon.myAcademy.MyAcademyApprenticeFrame.masterItem");
         addToContent(this._masterItem);
         this._classmateItem = new MyAcademyClassmateItem();
         PositionUtils.setPos(this._classmateItem,"academyCommon.myAcademy.MyAcademyApprenticeFrame.classmateItem");
         addToContent(this._classmateItem);
         this._classmateItemII = new MyAcademyClassmateItem();
         PositionUtils.setPos(this._classmateItemII,"academyCommon.myAcademy.MyAcademyApprenticeFrame.classmateItemII");
         addToContent(this._classmateItemII);
         this._ApprenticeInfos = new Vector.<PlayerInfo>();
         this.updateItem();
      }
      
      override protected function initEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,__onResponse);
         this._masterItem.addEventListener(MouseEvent.CLICK,__itemClick);
         _titleBtn.addEventListener(MouseEvent.CLICK,__titleBtnClick);
         this._classmateItem.addEventListener(MouseEvent.CLICK,__itemClick);
         this._classmateItemII.addEventListener(MouseEvent.CLICK,__itemClick);
         AcademyManager.Instance.myAcademyPlayers.addEventListener(DictionaryEvent.REMOVE,__removeItem);
         AcademyManager.Instance.myAcademyPlayers.addEventListener(DictionaryEvent.CLEAR,__clearItem);
      }
      
      override protected function updateItem() : void
      {
         this.sliceInfo();
         switch(_myApprentice.length)
         {
            case 0:
               this._masterItem.visible = false;
               this._classmateItem.visible = false;
               this._classmateItemII.visible = false;
               break;
            case 1:
               this._masterItem.info = this._masterInfo;
               this._classmateItem.visible = false;
               this._classmateItemII.visible = false;
               break;
            case 2:
               this._masterItem.info = this._masterInfo;
               this._classmateItem.info = this._ApprenticeInfos[0];
               this._classmateItemII.visible = false;
               break;
            case 3:
               this._masterItem.info = this._masterInfo;
               this._classmateItem.info = this._ApprenticeInfos[0];
               this._classmateItemII.info = this._ApprenticeInfos[1];
         }
      }
      
      private function sliceInfo() : void
      {
         var i:PlayerInfo = null;
         for each(i in _myApprentice)
         {
            if(i.apprenticeshipState == AcademyManager.APPRENTICE_STATE)
            {
               this._ApprenticeInfos.push(i);
            }
            else
            {
               this._masterInfo = i;
            }
         }
      }
      
      override protected function clearItem() : void
      {
         if(Boolean(this._masterItem))
         {
            this._masterItem.removeEventListener(MouseEvent.CLICK,__itemClick);
            this._masterItem.dispose();
            this._masterItem = null;
         }
         if(Boolean(this._classmateItem))
         {
            this._classmateItem.removeEventListener(MouseEvent.CLICK,__itemClick);
            this._classmateItem.dispose();
            this._classmateItem = null;
         }
         if(Boolean(this._classmateItemII))
         {
            this._classmateItemII.removeEventListener(MouseEvent.CLICK,__itemClick);
            this._classmateItemII.dispose();
            this._classmateItemII = null;
         }
      }
   }
}

