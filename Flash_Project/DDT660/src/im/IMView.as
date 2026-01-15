package im
{
   import bagAndInfo.BagAndGiftFrame;
   import bagAndInfo.BagAndInfoManager;
   import com.pickgliss.toplevel.StageReferance;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.ComponentSetting;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.SelectedButtonGroup;
   import com.pickgliss.ui.controls.SelectedTextButton;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.controls.container.HBox;
   import com.pickgliss.ui.controls.list.DropList;
   import com.pickgliss.ui.image.MutipleImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.text.GradientText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.player.PlayerInfo;
   import ddt.data.player.PlayerState;
   import ddt.data.player.SelfInfo;
   import ddt.events.PlayerPropertyEvent;
   import ddt.manager.AcademyFrameManager;
   import ddt.manager.AcademyManager;
   import ddt.manager.ChatManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PathManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.ServerManager;
   import ddt.manager.SharedManager;
   import ddt.manager.SoundManager;
   import ddt.manager.StateManager;
   import ddt.states.StateType;
   import ddt.view.PlayerPortraitView;
   import ddt.view.common.LevelIcon;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   import flash.net.URLVariables;
   import flash.utils.Dictionary;
   import oldplayerintegralshop.IntegralShopManager;
   import road7th.utils.StringHelper;
   import socialContact.SocialContactManager;
   import vip.VipController;
   
   public class IMView extends Frame
   {
      
      public static var IS_SHOW_SUB:Boolean;
      
      private static const ALL_STATE:Array = [new PlayerState(PlayerState.ONLINE,PlayerState.MANUAL),new PlayerState(PlayerState.AWAY,PlayerState.MANUAL),new PlayerState(PlayerState.BUSY,PlayerState.MANUAL),new PlayerState(PlayerState.NO_DISTRUB,PlayerState.MANUAL),new PlayerState(PlayerState.SHOPPING,PlayerState.MANUAL),new PlayerState(PlayerState.CLEAN_OUT,PlayerState.MANUAL)];
      
      public static const FRIEND_LIST:int = 0;
      
      public static const CMFRIEND_LIST:int = 2;
      
      public static const CONSORTIA_LIST:int = 1;
      
      public static const LIKEFRIEND_LIST:int = 3;
      
      private var _CMSelectedBtn:SelectedTextButton;
      
      private var _IMSelectedBtn:SelectedTextButton;
      
      private var _likePersonSelectedBtn:SelectedTextButton;
      
      private var _addBlackFrame:AddBlackFrame;
      
      private var _addBleak:TextButton;
      
      private var _addFriend:TextButton;
      
      private var _myAcademyBtn:TextButton;
      
      private var _inviteBtn:TextButton;
      
      private var _addFriendFrame:AddFriendFrame;
      
      private var _bg:MutipleImage;
      
      private var _consortiaListBtn:SelectedTextButton;
      
      private var _levelIcon:LevelIcon;
      
      private var _selectedButtonGroup:SelectedButtonGroup;
      
      private var _currentListType:int;
      
      private var _friendList:IMListView;
      
      private var _consortiaList:ConsortiaListView;
      
      private var _CMfriendList:CMFriendList;
      
      private var _likeFriendList:LikeFriendListView;
      
      private var _listContent:Sprite;
      
      private var _selfName:FilterFrameText;
      
      private var _vipName:GradientText;
      
      private var _playerPortrait:PlayerPortraitView;
      
      private var _imLookupView:IMLookupView;
      
      private var _stateSelectBtn:StateIconButton;
      
      private var _stateList:DropList;
      
      private var _replyInput:AutoReplyInput;
      
      private var _state:FilterFrameText;
      
      private var _hBox:HBox;
      
      private var _integralShop:SimpleBitmapButton;
      
      public function IMView()
      {
         super();
         super.init();
         this.initContent();
         this.initEvent();
      }
      
      private function initContent() : void
      {
         var pos:Point = null;
         titleText = LanguageMgr.GetTranslation("tank.game.ToolStripView.friend");
         this._bg = ComponentFactory.Instance.creatComponentByStylename("IM.BGMovieImage");
         addToContent(this._bg);
         this._selfName = ComponentFactory.Instance.creatComponentByStylename("IM.IMList.selfName");
         this._selfName.text = PlayerManager.Instance.Self.NickName;
         if(PlayerManager.Instance.Self.IsVIP)
         {
            this._vipName = VipController.instance.getVipNameTxt(138,PlayerManager.Instance.Self.typeVIP);
            this._vipName.textSize = 18;
            this._vipName.x = this._selfName.x;
            this._vipName.y = this._selfName.y;
            this._vipName.text = this._selfName.text;
            addToContent(this._vipName);
         }
         else
         {
            addToContent(this._selfName);
         }
         this._hBox = ComponentFactory.Instance.creatComponentByStylename("IM.btnHbox");
         addToContent(this._hBox);
         this._IMSelectedBtn = ComponentFactory.Instance.creatComponentByStylename("IMView.IMSelectedBtn");
         this._IMSelectedBtn.text = LanguageMgr.GetTranslation("tank.view.im.Friend");
         this._hBox.addChild(this._IMSelectedBtn);
         this._consortiaListBtn = ComponentFactory.Instance.creatComponentByStylename("IMView.consortiaListBtn");
         this._consortiaListBtn.text = LanguageMgr.GetTranslation("tank.view.im.consorita");
         this._hBox.addChild(this._consortiaListBtn);
         if(PathManager.CommnuntyMicroBlog())
         {
            this._CMSelectedBtn = ComponentFactory.Instance.creatComponentByStylename("IMView.MBSelectedBtn");
            this._CMSelectedBtn.text = LanguageMgr.GetTranslation("tank.view.im.MB");
            if(SharedManager.Instance.isCommunity && PathManager.CommunityExist())
            {
               this._hBox.addChild(this._CMSelectedBtn);
            }
         }
         else
         {
            this._CMSelectedBtn = ComponentFactory.Instance.creatComponentByStylename("IMView.CMSelectedBtn");
            this._CMSelectedBtn.text = LanguageMgr.GetTranslation("tank.view.im.CM");
            if(SharedManager.Instance.isCommunity && PathManager.CommunityExist())
            {
               this._hBox.addChild(this._CMSelectedBtn);
            }
         }
         this._selectedButtonGroup = new SelectedButtonGroup();
         this._selectedButtonGroup.addSelectItem(this._IMSelectedBtn);
         this._selectedButtonGroup.addSelectItem(this._consortiaListBtn);
         this._selectedButtonGroup.addSelectItem(this._CMSelectedBtn);
         if(PathManager.LikePersonSelected())
         {
            if(!(SharedManager.Instance.isCommunity && PathManager.CommunityExist()))
            {
               this._likePersonSelectedBtn = ComponentFactory.Instance.creatComponentByStylename("IMView.LikeSelectedBtnII");
            }
            else
            {
               this._likePersonSelectedBtn = ComponentFactory.Instance.creatComponentByStylename("IMView.LikeSelectedBtn");
            }
            this._likePersonSelectedBtn.text = LanguageMgr.GetTranslation("tank.view.im.Like");
            this._hBox.addChild(this._likePersonSelectedBtn);
            this._selectedButtonGroup.addSelectItem(this._likePersonSelectedBtn);
         }
         this._selectedButtonGroup.selectIndex = 0;
         this._hBox.arrange();
         this._addFriend = ComponentFactory.Instance.creatComponentByStylename("IM.AddFriendBtn");
         this._addFriend.text = LanguageMgr.GetTranslation("tank.view.im.addFriendBtn");
         this._addFriend.tipData = LanguageMgr.GetTranslation("tank.view.im.AddFriendFrame.add");
         addToContent(this._addFriend);
         this._addBleak = ComponentFactory.Instance.creatComponentByStylename("IM.AddBleakBtn");
         this._addBleak.text = LanguageMgr.GetTranslation("tank.view.im.addBleakBtn");
         this._addBleak.tipData = LanguageMgr.GetTranslation("tank.view.im.AddBlackListFrame.btnText");
         addToContent(this._addBleak);
         this._levelIcon = ComponentFactory.Instance.creatCustomObject("IM.imView.LevelIcon");
         this._levelIcon.setSize(LevelIcon.SIZE_BIG);
         addToContent(this._levelIcon);
         this._listContent = new Sprite();
         addToContent(this._listContent);
         this._imLookupView = new IMLookupView();
         pos = ComponentFactory.Instance.creatCustomObject("IM.IMView.IMLookupViewPos");
         this._imLookupView.x = pos.x;
         this._imLookupView.y = pos.y;
         addToContent(this._imLookupView);
         this._myAcademyBtn = ComponentFactory.Instance.creatComponentByStylename("IMView.myAcademyBtn");
         this._myAcademyBtn.text = LanguageMgr.GetTranslation("tank.view.im.addAcadeBtn");
         this._myAcademyBtn.tipData = LanguageMgr.GetTranslation("im.IMView.myAcademyBtnTips");
         addToContent(this._myAcademyBtn);
         this._stateSelectBtn = ComponentFactory.Instance.creatCustomObject("IM.stateIconButton");
         addToContent(this._stateSelectBtn);
         this._stateList = ComponentFactory.Instance.creatComponentByStylename("IMView.stateList");
         this._stateList.targetDisplay = this._stateSelectBtn;
         this._stateList.showLength = 6;
         this._state = ComponentFactory.Instance.creatComponentByStylename("IM.stateIconBtn.stateNameTxt");
         this._state.text = "[" + PlayerManager.Instance.Self.playerState.convertToString() + "]";
         addToContent(this._state);
         this._replyInput = ComponentFactory.Instance.creatCustomObject("im.autoReplyInput");
         addToContent(this._replyInput);
         var selfInfo:SelfInfo = PlayerManager.Instance.Self;
         this._levelIcon.setInfo(selfInfo.Grade,selfInfo.Repute,selfInfo.WinCount,selfInfo.TotalCount,selfInfo.FightPower,selfInfo.Offer,true,false);
         this.showFigure();
         this._currentListType = 0;
         this.setListType();
         this.__onStateChange(new PlayerPropertyEvent("*",new Dictionary()));
         this._integralShop = ComponentFactory.Instance.creatComponentByStylename("IMView.integralShopBtn");
         addToContent(this._integralShop);
      }
      
      private function initEvent() : void
      {
         this._IMSelectedBtn.addEventListener(MouseEvent.CLICK,this.__IMBtnClick);
         this._CMSelectedBtn.addEventListener(MouseEvent.CLICK,this.__CMBtnClick);
         this._consortiaListBtn.addEventListener(MouseEvent.CLICK,this.__consortiaListBtnClick);
         if(Boolean(this._likePersonSelectedBtn))
         {
            this._likePersonSelectedBtn.addEventListener(MouseEvent.CLICK,this.__likeBtnClick);
         }
         this._addFriend.addEventListener(MouseEvent.CLICK,this.__addFriendBtnClick);
         this._addBleak.addEventListener(MouseEvent.CLICK,this.__addBleakBtnClick);
         this._selectedButtonGroup.addEventListener(Event.CHANGE,this.__buttonGroupChange);
         if(Boolean(this._myAcademyBtn))
         {
            this._myAcademyBtn.addEventListener(MouseEvent.CLICK,this.__myAcademyClick);
         }
         this._stateSelectBtn.addEventListener(MouseEvent.CLICK,this.__stateSelectClick);
         StageReferance.stage.addEventListener(MouseEvent.CLICK,this.__hideStateList);
         PlayerManager.Instance.Self.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__onStateChange);
         this._integralShop.addEventListener(MouseEvent.CLICK,this.__onIntegralShop);
      }
      
      protected function __onIntegralShop(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         IntegralShopManager.instance.show();
      }
      
      private function __CMBtnClick(evt:MouseEvent) : void
      {
         IMController.Instance.createConsortiaLoader();
         IMController.Instance.addEventListener(Event.COMPLETE,this.__CMFriendLoadComplete);
         SoundManager.instance.play("008");
      }
      
      private function __CMFriendLoadComplete(event:Event) : void
      {
         IMController.Instance.removeEventListener(Event.COMPLETE,this.__CMFriendLoadComplete);
         this._currentListType = CMFRIEND_LIST;
         this.setListType();
      }
      
      private function __IMBtnClick(evt:MouseEvent) : void
      {
         this._currentListType = FRIEND_LIST;
         this.setListType();
         SoundManager.instance.play("008");
      }
      
      private function __inviteBtnClick(event:MouseEvent) : void
      {
         var req:URLRequest = null;
         var data:URLVariables = null;
         var loader:URLLoader = null;
         MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("im.IMView.inviteInfo"));
         SoundManager.instance.play("008");
         if(!StringHelper.isNullOrEmpty(PathManager.CommunityInvite()))
         {
            req = new URLRequest(PathManager.CommunityInvite());
            data = new URLVariables();
            data["fuid"] = String(PlayerManager.Instance.Self.LoginName);
            data["fnick"] = PlayerManager.Instance.Self.NickName;
            data["tuid"] = this._CMfriendList.currentCMFInfo.UserName;
            data["serverid"] = String(ServerManager.Instance.AgentID);
            data["rnd"] = Math.random();
            req.data = data;
            loader = new URLLoader(req);
            loader.load(req);
         }
      }
      
      private function __consortiaListBtnClick(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.ConsortiaID <= 0)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("im.IMView.infoText"));
            this._selectedButtonGroup.selectIndex = this._currentListType;
            return;
         }
         this._currentListType = CONSORTIA_LIST;
         this.setListType();
      }
      
      private function __likeBtnClick(e:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this._currentListType = LIKEFRIEND_LIST;
         this.setListType();
      }
      
      private function __addBleakBtnClick(evt:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(Boolean(this._addFriendFrame) && Boolean(this._addFriendFrame.parent))
         {
            this._addFriendFrame.dispose();
            this._addFriendFrame = null;
         }
         if(Boolean(this._addBlackFrame) && Boolean(this._addBlackFrame.parent))
         {
            this._addBlackFrame.dispose();
            this._addBlackFrame = null;
            return;
         }
         this._addBlackFrame = ComponentFactory.Instance.creat("AddBlackFrame");
         LayerManager.Instance.addToLayer(this._addBlackFrame,LayerManager.GAME_DYNAMIC_LAYER);
         if(StateManager.currentStateType == StateType.MAIN)
         {
            ChatManager.Instance.lock = false;
         }
         if(StateManager.currentStateType == StateType.FIGHTING)
         {
            ComponentSetting.SEND_USELOG_ID(127);
         }
      }
      
      private function __buttonGroupChange(e:Event) : void
      {
         this._hBox.arrange();
      }
      
      private function __myAcademyClick(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.Grade >= AcademyManager.TARGET_PLAYER_MIN_LEVEL)
         {
            if(PlayerManager.Instance.Self.apprenticeshipState != AcademyManager.NONE_STATE)
            {
               AcademyManager.Instance.myAcademy();
            }
            else
            {
               AcademyFrameManager.Instance.showAcademyPreviewFrame();
            }
         }
         else
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("im.IMView.academyInfo"));
         }
      }
      
      private function _socialContactBtClick(e:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         SocialContactManager.Instance.showView();
      }
      
      private function __addFriendBtnClick(evt:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(this._currentListType == FRIEND_LIST || this._currentListType == CONSORTIA_LIST || this._currentListType == LIKEFRIEND_LIST)
         {
            if(Boolean(this._addBlackFrame) && Boolean(this._addBlackFrame.parent))
            {
               this._addBlackFrame.dispose();
               this._addBlackFrame = null;
            }
            if(Boolean(this._addFriendFrame) && Boolean(this._addFriendFrame.parent))
            {
               this._addFriendFrame.dispose();
               this._addFriendFrame = null;
               return;
            }
            this._addFriendFrame = ComponentFactory.Instance.creat("AddFriendFrame");
            LayerManager.Instance.addToLayer(this._addFriendFrame,LayerManager.GAME_DYNAMIC_LAYER);
         }
         else if(this._CMfriendList && this._CMfriendList.currentCMFInfo && this._CMfriendList.currentCMFInfo.IsExist)
         {
            IMController.Instance.addFriend(this._CMfriendList.currentCMFInfo.NickName);
         }
         if(StateManager.currentStateType == StateType.MAIN)
         {
            ChatManager.Instance.lock = false;
         }
         if(StateManager.currentStateType == StateType.FIGHTING)
         {
            ComponentSetting.SEND_USELOG_ID(126);
         }
      }
      
      private function showFigure() : void
      {
         var info:PlayerInfo = PlayerManager.Instance.Self;
         this._playerPortrait = ComponentFactory.Instance.creatCustomObject("im.PlayerPortrait",["right"]);
         this._playerPortrait.info = info;
         addToContent(this._playerPortrait);
      }
      
      private function setListType() : void
      {
         if(Boolean(this._friendList) && Boolean(this._friendList.parent))
         {
            this._friendList.parent.removeChild(this._friendList);
            this._friendList.dispose();
            this._friendList = null;
         }
         if(Boolean(this._consortiaList) && Boolean(this._consortiaList.parent))
         {
            this._consortiaList.parent.removeChild(this._consortiaList);
            this._consortiaList.dispose();
            this._consortiaList = null;
         }
         if(Boolean(this._CMfriendList) && Boolean(this._CMfriendList.parent))
         {
            this._CMfriendList.parent.removeChild(this._CMfriendList);
            this._CMfriendList.dispose();
            this._CMfriendList = null;
         }
         if(Boolean(this._likeFriendList) && Boolean(this._likeFriendList.parent))
         {
            this._likeFriendList.parent.removeChild(this._likeFriendList);
            this._likeFriendList.dispose();
            this._likeFriendList = null;
         }
         var listPos:Point = ComponentFactory.Instance.creatCustomObject("IM.IMList.listPos");
         switch(this._currentListType)
         {
            case 0:
               this._friendList = new IMListView();
               this._friendList.x = 8;
               this._friendList.y = listPos.x;
               this._listContent.addChild(this._friendList);
               this._addBleak.visible = true;
               this._addFriend.visible = true;
               this._myAcademyBtn.visible = true;
               this._imLookupView.listType = FRIEND_LIST;
               break;
            case 1:
               this._consortiaList = new ConsortiaListView();
               this._consortiaList.x = 8;
               this._consortiaList.y = listPos.x;
               this._listContent.addChild(this._consortiaList);
               this._addBleak.visible = true;
               this._addFriend.visible = true;
               this._myAcademyBtn.visible = true;
               this._imLookupView.listType = FRIEND_LIST;
               break;
            case 2:
               this._CMfriendList = new CMFriendList();
               this._CMfriendList.x = 8;
               this._CMfriendList.y = listPos.y;
               if(Boolean(this._listContent))
               {
                  this._listContent.addChild(this._CMfriendList);
               }
               this._addFriend.visible = false;
               this._addBleak.visible = false;
               this._myAcademyBtn.visible = false;
               this._imLookupView.listType = CMFRIEND_LIST;
               break;
            case LIKEFRIEND_LIST:
               this._likeFriendList = new LikeFriendListView();
               this._likeFriendList.x = 8;
               this._likeFriendList.y = listPos.x;
               if(Boolean(this._listContent))
               {
                  this._listContent.addChild(this._likeFriendList);
               }
               this._addBleak.visible = true;
               this._addFriend.visible = true;
               this._myAcademyBtn.visible = true;
               this._imLookupView.listType = LIKEFRIEND_LIST;
         }
         if(AcademyManager.Instance.isFighting())
         {
            if(Boolean(this._myAcademyBtn))
            {
               this._myAcademyBtn.visible = false;
            }
         }
      }
      
      private function __giftClick(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         BagAndInfoManager.Instance.showBagAndInfo(BagAndGiftFrame.GIFTVIEW);
      }
      
      private function __onStateChange(event:PlayerPropertyEvent) : void
      {
         if(PlayerManager.Instance.Self.playerState.StateID == 1)
         {
            this._replyInput.visible = false;
         }
         else
         {
            this._replyInput.visible = true;
         }
         if(Boolean(event.changedProperties["State"]))
         {
            this._state.text = "[" + PlayerManager.Instance.Self.playerState.convertToString() + "]";
            this._stateSelectBtn.setFrame(PlayerManager.Instance.Self.playerState.StateID);
         }
      }
      
      private function __hideStateList(event:MouseEvent) : void
      {
         if(Boolean(this._stateList.parent))
         {
            this._stateList.parent.removeChild(this._stateList);
         }
      }
      
      private function __stateSelectClick(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         event.stopImmediatePropagation();
         if(this._stateList.parent == null)
         {
            addToContent(this._stateList);
         }
         this._stateList.dataList = ALL_STATE;
      }
      
      private function removeEvent() : void
      {
         this._IMSelectedBtn.removeEventListener(MouseEvent.CLICK,this.__IMBtnClick);
         this._CMSelectedBtn.removeEventListener(MouseEvent.CLICK,this.__CMBtnClick);
         this._consortiaListBtn.removeEventListener(MouseEvent.CLICK,this.__consortiaListBtnClick);
         if(Boolean(this._likePersonSelectedBtn))
         {
            this._likePersonSelectedBtn.removeEventListener(MouseEvent.CLICK,this.__likeBtnClick);
         }
         this._addFriend.removeEventListener(MouseEvent.CLICK,this.__addFriendBtnClick);
         this._addBleak.removeEventListener(MouseEvent.CLICK,this.__addBleakBtnClick);
         IMController.Instance.removeEventListener(Event.COMPLETE,this.__CMFriendLoadComplete);
         if(Boolean(this._myAcademyBtn))
         {
            this._myAcademyBtn.removeEventListener(MouseEvent.CLICK,this.__myAcademyClick);
         }
         this._stateSelectBtn.removeEventListener(MouseEvent.CLICK,this.__stateSelectClick);
         StageReferance.stage.removeEventListener(MouseEvent.CLICK,this.__hideStateList);
         PlayerManager.Instance.Self.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__onStateChange);
         this._integralShop.removeEventListener(MouseEvent.CLICK,this.__onIntegralShop);
      }
      
      override public function dispose() : void
      {
         IMController.Instance.isShow = false;
         this.removeEvent();
         if(Boolean(this._bg) && Boolean(this._bg.parent))
         {
            this._bg.parent.removeChild(this._bg);
            this._bg.dispose();
            this._bg = null;
         }
         if(Boolean(this._listContent) && Boolean(this._listContent.parent))
         {
            this._listContent.parent.removeChild(this._listContent);
            this._listContent = null;
         }
         if(Boolean(this._selfName) && Boolean(this._selfName.parent))
         {
            this._selfName.parent.removeChild(this._selfName);
            this._selfName.dispose();
            this._selfName = null;
         }
         if(Boolean(this._levelIcon) && Boolean(this._levelIcon.parent))
         {
            this._levelIcon.parent.removeChild(this._levelIcon);
            this._levelIcon.dispose();
            this._levelIcon = null;
         }
         if(Boolean(this._consortiaListBtn) && Boolean(this._consortiaListBtn.parent))
         {
            this._consortiaListBtn.parent.removeChild(this._consortiaListBtn);
            this._consortiaListBtn.dispose();
            this._consortiaListBtn = null;
         }
         if(Boolean(this._likePersonSelectedBtn))
         {
            ObjectUtils.disposeObject(this._likePersonSelectedBtn);
         }
         this._likePersonSelectedBtn = null;
         if(Boolean(this._addFriend) && Boolean(this._addFriend.parent))
         {
            this._addFriend.parent.removeChild(this._addFriend);
            this._addFriend.dispose();
            this._addFriend = null;
         }
         if(Boolean(this._addBleak) && Boolean(this._addBleak.parent))
         {
            this._addBleak.parent.removeChild(this._addBleak);
            this._addBleak.dispose();
            this._addBleak = null;
         }
         if(Boolean(this._IMSelectedBtn) && Boolean(this._IMSelectedBtn.parent))
         {
            this._IMSelectedBtn.parent.removeChild(this._IMSelectedBtn);
            this._IMSelectedBtn.dispose();
            this._IMSelectedBtn = null;
         }
         if(Boolean(this._CMSelectedBtn) && Boolean(this._CMSelectedBtn.parent))
         {
            this._CMSelectedBtn.parent.removeChild(this._CMSelectedBtn);
            this._CMSelectedBtn.dispose();
            this._CMSelectedBtn = null;
         }
         if(Boolean(this._imLookupView) && Boolean(this._imLookupView.parent))
         {
            this._imLookupView.parent.removeChild(this._imLookupView);
            this._imLookupView.dispose();
            this._imLookupView = null;
         }
         if(Boolean(this._friendList) && Boolean(this._friendList.parent))
         {
            this._friendList.parent.removeChild(this._friendList);
            this._friendList.dispose();
            this._friendList = null;
         }
         if(Boolean(this._consortiaList) && Boolean(this._consortiaList.parent))
         {
            this._consortiaList.parent.removeChild(this._consortiaList);
            this._consortiaList.dispose();
            this._consortiaList = null;
         }
         if(Boolean(this._CMfriendList) && Boolean(this._CMfriendList.parent))
         {
            this._CMfriendList.parent.removeChild(this._CMfriendList);
            this._CMfriendList.dispose();
            this._CMfriendList = null;
         }
         if(Boolean(this._addFriendFrame))
         {
            this._addFriendFrame.dispose();
            this._addFriendFrame = null;
         }
         if(Boolean(this._addBlackFrame))
         {
            this._addBlackFrame.dispose();
            this._addBlackFrame = null;
         }
         if(Boolean(this._myAcademyBtn))
         {
            this._myAcademyBtn.dispose();
            this._myAcademyBtn = null;
         }
         if(Boolean(this._stateList))
         {
            this._stateList.dispose();
            this._stateList = null;
         }
         if(Boolean(this._stateSelectBtn))
         {
            this._stateSelectBtn.dispose();
            this._stateSelectBtn = null;
         }
         if(Boolean(this._likeFriendList))
         {
            this._likeFriendList.dispose();
            this._likeFriendList = null;
         }
         if(Boolean(this._vipName))
         {
            ObjectUtils.disposeObject(this._vipName);
         }
         this._vipName = null;
         this._selectedButtonGroup.dispose();
         this._selectedButtonGroup = null;
         if(Boolean(this._integralShop))
         {
            this._integralShop.dispose();
            this._integralShop = null;
         }
         super.dispose();
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
   }
}

