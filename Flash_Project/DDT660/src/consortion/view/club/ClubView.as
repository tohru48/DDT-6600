package consortion.view.club
{
   import baglocked.BaglockedManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.SelectedButtonGroup;
   import com.pickgliss.ui.controls.SelectedTextButton;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.controls.TextInput;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.MovieImage;
   import com.pickgliss.ui.image.MutipleImage;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.text.TextArea;
   import com.pickgliss.utils.ObjectUtils;
   import consortion.ConsortionModelControl;
   import consortion.event.ConsortionEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.FocusEvent;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.ui.Keyboard;
   
   public class ClubView extends Sprite implements Disposeable
   {
      
      private var _consortiaClubPage:int = 1;
      
      private var _consortionList:ConsortionList;
      
      private var _recordList:ClubRecordList;
      
      private var _BG:MovieImage;
      
      private var _clubBG:MovieImage;
      
      private var _wordsImage:MutipleImage;
      
      private var _searchInput:TextInput;
      
      private var _searchBtn:TextButton;
      
      private var _declareBG:MutipleImage;
      
      private var _declaration:TextArea;
      
      private var _applyBtn:BaseButton;
      
      private var _randomSearchBtn:BaseButton;
      
      private var _recordGroup:SelectedButtonGroup;
      
      private var _applyRecordBtn:SelectedTextButton;
      
      private var _inviteRecordBtn:SelectedTextButton;
      
      private var _createConsortionBtn:BaseButton;
      
      private var _menberListVLine:MutipleImage;
      
      private var _searchText:FilterFrameText;
      
      private var _inputBG:MutipleImage;
      
      private var _consortionNameTxt:FilterFrameText;
      
      private var _chairmanNameTxt:FilterFrameText;
      
      private var _menberCountTxt:FilterFrameText;
      
      private var _gradeTxt:FilterFrameText;
      
      private var _exploitTxt:FilterFrameText;
      
      private var _littleFur1:ScaleFrameImage;
      
      private var _littleFur2:ScaleFrameImage;
      
      private var _dottedline:MutipleImage;
      
      public function ClubView()
      {
         super();
      }
      
      public function enterClub() : void
      {
         ConsortionModelControl.Instance.getConsortionList(ConsortionModelControl.Instance.clubSearchConsortions,1,6,"",Math.floor(Math.random() * 5 + 1),1);
         ConsortionModelControl.Instance.getApplyRecordList(ConsortionModelControl.Instance.applyListComplete,PlayerManager.Instance.Self.ID);
         ConsortionModelControl.Instance.getInviteRecordList(ConsortionModelControl.Instance.InventListComplete);
         this.init();
         this.initEvent();
         this.__consortionListComplete(null);
      }
      
      private function init() : void
      {
         this._BG = ComponentFactory.Instance.creatComponentByStylename("consortionClub.BG");
         this._clubBG = ComponentFactory.Instance.creatComponentByStylename("club.menberList.bg");
         this._menberListVLine = ComponentFactory.Instance.creatComponentByStylename("consortionClub.MemberListVLine");
         this._inputBG = ComponentFactory.Instance.creatComponentByStylename("consortionClubView.InputBG");
         this._searchText = ComponentFactory.Instance.creatComponentByStylename("consortionClubView.searchText");
         this._searchText.text = LanguageMgr.GetTranslation("tank.consortionClubView.searchText.text");
         this._consortionNameTxt = ComponentFactory.Instance.creatComponentByStylename("consortionClub.MemberListTitleText1");
         this._consortionNameTxt.text = LanguageMgr.GetTranslation("tank.consortionClub.MemberListTitleText1.text");
         this._chairmanNameTxt = ComponentFactory.Instance.creatComponentByStylename("consortionClub.MemberListTitleText2");
         this._chairmanNameTxt.text = LanguageMgr.GetTranslation("tank.consortionClub.MemberListTitleText2.text");
         this._menberCountTxt = ComponentFactory.Instance.creatComponentByStylename("consortionClub.MemberListTitleText3");
         this._menberCountTxt.text = LanguageMgr.GetTranslation("tank.consortionClub.MemberListTitleText3.text");
         this._gradeTxt = ComponentFactory.Instance.creatComponentByStylename("consortionClub.MemberListTitleText4");
         this._gradeTxt.text = LanguageMgr.GetTranslation("tank.consortionClub.MemberListTitleText4.text");
         this._exploitTxt = ComponentFactory.Instance.creatComponentByStylename("consortionClub.MemberListTitleText5");
         this._exploitTxt.text = LanguageMgr.GetTranslation("tank.consortionClub.MemberListTitleText5.text");
         this._wordsImage = ComponentFactory.Instance.creatComponentByStylename("club.wordImage.mutiple");
         this._consortionList = ComponentFactory.Instance.creatComponentByStylename("club.consortionList");
         this._searchInput = ComponentFactory.Instance.creatComponentByStylename("club.searchInput");
         this._searchInput.text = LanguageMgr.GetTranslation("tank.consortia.club.searchTxt");
         this._searchBtn = ComponentFactory.Instance.creatComponentByStylename("club.searchConsortionBtn");
         this._searchBtn.text = LanguageMgr.GetTranslation("tank.consortia.club.searchTxt.text");
         this._declareBG = ComponentFactory.Instance.creatComponentByStylename("club.declareBG");
         this._declaration = ComponentFactory.Instance.creatComponentByStylename("club.declaration");
         this._applyBtn = ComponentFactory.Instance.creatComponentByStylename("club.applyBtn");
         this._randomSearchBtn = ComponentFactory.Instance.creatComponentByStylename("club.randomSearchBtn");
         this._recordGroup = new SelectedButtonGroup(false);
         this._applyRecordBtn = ComponentFactory.Instance.creatComponentByStylename("club.applyRecordBtn");
         this._applyRecordBtn.text = LanguageMgr.GetTranslation("club.applyRecordBtnText");
         this._inviteRecordBtn = ComponentFactory.Instance.creatComponentByStylename("club.inviteRecordBtn");
         this._inviteRecordBtn.text = LanguageMgr.GetTranslation("club.inviteRecordBtnText");
         this._littleFur1 = ComponentFactory.Instance.creatComponentByStylename("club.Scale9CornerImage.littleFurI");
         this._littleFur1.setFrame(1);
         this._littleFur2 = ComponentFactory.Instance.creatComponentByStylename("club.Scale9CornerImage.littleFurII");
         this._littleFur2.setFrame(2);
         this._dottedline = ComponentFactory.Instance.creatComponentByStylename("club.dottedline");
         this._recordGroup.addSelectItem(this._inviteRecordBtn);
         this._recordGroup.addSelectItem(this._applyRecordBtn);
         this._recordGroup.selectIndex = 0;
         this._recordList = ComponentFactory.Instance.creatCustomObject("club.recordList");
         this._createConsortionBtn = ComponentFactory.Instance.creatComponentByStylename("club.createConsortion");
         if(PlayerManager.Instance.Self.Grade < 17)
         {
            this._createConsortionBtn.enable = false;
         }
         addChild(this._BG);
         addChild(this._clubBG);
         addChild(this._menberListVLine);
         addChild(this._inputBG);
         addChild(this._searchText);
         addChild(this._consortionNameTxt);
         addChild(this._chairmanNameTxt);
         addChild(this._menberCountTxt);
         addChild(this._gradeTxt);
         addChild(this._exploitTxt);
         addChild(this._declareBG);
         addChild(this._wordsImage);
         addChild(this._consortionList);
         addChild(this._searchInput);
         addChild(this._searchBtn);
         addChild(this._declaration);
         addChild(this._applyBtn);
         addChild(this._randomSearchBtn);
         addChild(this._littleFur1);
         addChild(this._littleFur2);
         addChild(this._applyRecordBtn);
         addChild(this._inviteRecordBtn);
         addChild(this._dottedline);
         addChild(this._recordList);
         addChild(this._createConsortionBtn);
         this.__recordListChange(null);
      }
      
      private function initEvent() : void
      {
         addEventListener(Event.ADDED_TO_STAGE,this.__addToStageHandler);
         this._searchBtn.addEventListener(MouseEvent.CLICK,this.__sarchWithInputHandler);
         this._applyBtn.addEventListener(MouseEvent.CLICK,this.__applyHandler);
         this._randomSearchBtn.addEventListener(MouseEvent.CLICK,this.__randomSearchHandler);
         this._consortionList.addEventListener(ConsortionEvent.CLUB_ITEM_SELECTED,this.__selectedOneConsortion);
         this._applyRecordBtn.addEventListener(MouseEvent.CLICK,this.__recordBtnClickHandler);
         this._inviteRecordBtn.addEventListener(MouseEvent.CLICK,this.__recordBtnClickHandler);
         this._createConsortionBtn.addEventListener(MouseEvent.CLICK,this.__createConsortionHandler);
         ConsortionModelControl.Instance.model.addEventListener(ConsortionEvent.CONSORTIONLIST_IS_CHANGE,this.__consortionListComplete);
         ConsortionModelControl.Instance.model.addEventListener(ConsortionEvent.INVENT_LIST_IS_CHANGE,this.__recordListChange);
         ConsortionModelControl.Instance.model.addEventListener(ConsortionEvent.MY_APPLY_LIST_IS_CHANGE,this.__recordListChange);
      }
      
      private function removeEvent() : void
      {
         removeEventListener(Event.ADDED_TO_STAGE,this.__addToStageHandler);
         this._searchInput.removeEventListener(MouseEvent.CLICK,this.__focusInHandler);
         this._searchInput.removeEventListener(FocusEvent.FOCUS_OUT,this.__focusOutHandler);
         this._searchInput.removeEventListener(KeyboardEvent.KEY_DOWN,this.__keyDownHandler);
         this._searchBtn.removeEventListener(MouseEvent.CLICK,this.__sarchWithInputHandler);
         this._applyBtn.removeEventListener(MouseEvent.CLICK,this.__applyHandler);
         this._randomSearchBtn.removeEventListener(MouseEvent.CLICK,this.__randomSearchHandler);
         this._consortionList.removeEventListener(ConsortionEvent.CLUB_ITEM_SELECTED,this.__selectedOneConsortion);
         this._applyRecordBtn.removeEventListener(MouseEvent.CLICK,this.__recordBtnClickHandler);
         this._inviteRecordBtn.removeEventListener(MouseEvent.CLICK,this.__recordBtnClickHandler);
         this._createConsortionBtn.removeEventListener(MouseEvent.CLICK,this.__createConsortionHandler);
         ConsortionModelControl.Instance.model.removeEventListener(ConsortionEvent.CONSORTIONLIST_IS_CHANGE,this.__consortionListComplete);
         ConsortionModelControl.Instance.model.removeEventListener(ConsortionEvent.INVENT_LIST_IS_CHANGE,this.__recordListChange);
         ConsortionModelControl.Instance.model.removeEventListener(ConsortionEvent.MY_APPLY_LIST_IS_CHANGE,this.__recordListChange);
      }
      
      private function __createConsortionHandler(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         var createConsortia:CreateConsortionFrame = ComponentFactory.Instance.creatComponentByStylename("createConsortionFrame");
         LayerManager.Instance.addToLayer(createConsortia,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      private function __addToStageHandler(event:Event) : void
      {
         this._searchInput.addEventListener(MouseEvent.CLICK,this.__focusInHandler);
         this._searchInput.addEventListener(FocusEvent.FOCUS_OUT,this.__focusOutHandler);
         this._searchInput.addEventListener(KeyboardEvent.KEY_DOWN,this.__keyDownHandler);
      }
      
      private function __keyDownHandler(event:KeyboardEvent) : void
      {
         if(event.keyCode == Keyboard.ENTER)
         {
            this.__sarchWithInputHandler(null);
         }
      }
      
      private function __recordBtnClickHandler(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this.__recordListChange(null);
      }
      
      private function __recordListChange(event:ConsortionEvent) : void
      {
         switch(this._recordGroup.selectIndex)
         {
            case 0:
               this._recordList.setData(ConsortionModelControl.Instance.model.inventList,ClubRecordList.INVITE);
               break;
            case 1:
               this._recordList.setData(ConsortionModelControl.Instance.model.myApplyList,ClubRecordList.APPLY);
         }
      }
      
      private function __applyHandler(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.Grade < 17)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.consortion.playerTip.notInvite"));
            return;
         }
         if(!this._consortionList.currentItem.info.OpenApply)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.consortia.club.ConsortiaClubView.applyJoinClickHandler"));
            return;
         }
         this._consortionList.currentItem.isApply = true;
         this._applyBtn.enable = false;
         this._recordGroup.selectIndex = 1;
         SocketManager.Instance.out.sendConsortiaTryIn(this._consortionList.currentItem.info.ConsortiaID);
      }
      
      private function __randomSearchHandler(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         ++this._consortiaClubPage;
         var totalCount:int = ConsortionModelControl.Instance.model.consortionsListTotalCount;
         if(totalCount != 0)
         {
            if(this._consortiaClubPage > totalCount)
            {
               this._consortiaClubPage = 1;
            }
         }
         else
         {
            this._consortiaClubPage = 1;
         }
         ConsortionModelControl.Instance.getConsortionList(ConsortionModelControl.Instance.clubSearchConsortions,this._consortiaClubPage,6);
      }
      
      private function __selectedOneConsortion(event:ConsortionEvent) : void
      {
         this._declaration.text = this._consortionList.currentItem.info.Description;
         if(this._declaration.text == "")
         {
            this._declaration.text = LanguageMgr.GetTranslation("tank.consortia.club.text");
         }
         this._applyBtn.enable = true;
      }
      
      private function __consortionListComplete(event:ConsortionEvent) : void
      {
         this._consortionList.setListData(ConsortionModelControl.Instance.model.consortionList);
         this._declaration.text = "";
         this._applyBtn.enable = false;
      }
      
      private function __focusInHandler(event:MouseEvent) : void
      {
         if(this._searchInput.text == LanguageMgr.GetTranslation("tank.consortia.club.searchTxt"))
         {
            this._searchInput.text = "";
         }
      }
      
      private function __focusOutHandler(event:FocusEvent) : void
      {
         if(this._searchInput.text == "")
         {
            this._searchInput.text = LanguageMgr.GetTranslation("tank.consortia.club.searchTxt");
         }
      }
      
      private function __sarchWithInputHandler(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         ++this._consortiaClubPage;
         var totalCount:int = ConsortionModelControl.Instance.model.consortionsListTotalCount;
         if(totalCount != 0)
         {
            if(this._consortiaClubPage > totalCount)
            {
               this._consortiaClubPage = 1;
            }
         }
         if(this._searchInput.text == "" || this._searchInput.text == LanguageMgr.GetTranslation("tank.consortia.club.searchTxt"))
         {
            ConsortionModelControl.Instance.getConsortionList(ConsortionModelControl.Instance.clubSearchConsortions,this._consortiaClubPage,6);
         }
         else
         {
            ConsortionModelControl.Instance.getConsortionList(ConsortionModelControl.Instance.clubSearchConsortions,this._consortiaClubPage,6,this._searchInput.text);
         }
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         ObjectUtils.disposeAllChildren(this);
         this._consortionList = null;
         this._recordList = null;
         this._BG = null;
         this._clubBG = null;
         this._menberListVLine = null;
         this._searchText = null;
         this._inputBG = null;
         this._consortionNameTxt = null;
         this._chairmanNameTxt = null;
         this._menberCountTxt = null;
         this._gradeTxt = null;
         this._exploitTxt = null;
         this._wordsImage = null;
         this._searchInput = null;
         if(Boolean(this._searchBtn))
         {
            ObjectUtils.disposeObject(this._searchBtn);
         }
         this._searchBtn = null;
         this._declareBG = null;
         this._declaration = null;
         this._applyBtn = null;
         this._randomSearchBtn = null;
         this._recordGroup = null;
         this._applyRecordBtn = null;
         this._inviteRecordBtn = null;
         this._littleFur1 = null;
         this._littleFur2 = null;
         this._dottedline = null;
         this._createConsortionBtn = null;
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
   }
}

