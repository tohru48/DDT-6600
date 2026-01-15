package church.view.weddingRoomList.frame
{
   import church.controller.ChurchRoomListController;
   import church.model.ChurchRoomListModel;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.SelectedButton;
   import com.pickgliss.ui.controls.SelectedButtonGroup;
   import com.pickgliss.ui.controls.SelectedIconButton;
   import com.pickgliss.ui.controls.TextInput;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.text.TextArea;
   import com.pickgliss.ui.vo.AlertInfo;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.ChurchRoomInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.ServerConfigManager;
   import ddt.manager.SoundManager;
   import ddt.utils.FilterWordManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class WeddingRoomCreateView extends BaseAlerFrame
   {
      
      private var _controller:ChurchRoomListController;
      
      private var _model:ChurchRoomListModel;
      
      private var _bgLeftTop:ScaleBitmapImage;
      
      private var _bgLeftBottom:ScaleBitmapImage;
      
      private var _bgRight:Scale9CornerImage;
      
      private var _alertInfo:AlertInfo;
      
      private var _roomCreateRoomNameTitle:Bitmap;
      
      private var _roomCreateIntro:Bitmap;
      
      private var _roomCreateTimeTitle:Bitmap;
      
      private var _roomCreateIntroMaxChBg:Bitmap;
      
      private var _txtCreateRoomName:FilterFrameText;
      
      private var _chkCreateRoomPassword:SelectedIconButton;
      
      private var _chkCreateRoomIsGuest:SelectedIconButton;
      
      private var _txtCreateRoomPassword:TextInput;
      
      private var _roomCreateTime1SelectedBtn:SelectedButton;
      
      private var _roomCreateTime2SelectedBtn:SelectedButton;
      
      private var _roomCreateTime3SelectedBtn:SelectedButton;
      
      private var _roomCreateTime1Txt:FilterFrameText;
      
      private var _roomCreateTime2Txt:FilterFrameText;
      
      private var _roomCreateTime3Txt:FilterFrameText;
      
      private var _roomCreateMoney1Txt:FilterFrameText;
      
      private var _roomCreateMoney2Txt:FilterFrameText;
      
      private var _roomCreateMoney3Txt:FilterFrameText;
      
      private var _roomCreateTimeGroup:SelectedButtonGroup;
      
      private var _roomCreateIntroMaxChLabel:FilterFrameText;
      
      private var _txtRoomCreateIntro:TextArea;
      
      private var _flower:Bitmap;
      
      private var _bg1:ScaleBitmapImage;
      
      private var _selectedIconButtonTxt1:FilterFrameText;
      
      private var _selectedIconButtonTxt2:FilterFrameText;
      
      public function WeddingRoomCreateView()
      {
         super();
         this.initialize();
      }
      
      public function setController(controller:ChurchRoomListController, model:ChurchRoomListModel) : void
      {
         this._controller = controller;
         this._model = model;
      }
      
      protected function initialize() : void
      {
         this.setView();
         this.setEvent();
      }
      
      private function setView() : void
      {
         cancelButtonStyle = "core.simplebt";
         submitButtonStyle = "core.simplebt";
         this._alertInfo = new AlertInfo();
         this._alertInfo.title = LanguageMgr.GetTranslation("church.weddingRoom.frame.CreateRoomFrame.titleText");
         this._alertInfo.moveEnable = false;
         info = this._alertInfo;
         this.escEnable = true;
         this._flower = ComponentFactory.Instance.creatBitmap("asset.churchroomlist.flowers");
         this._flower.scaleY = 0.9;
         this._flower.scaleX = 0.9;
         PositionUtils.setPos(this._flower,"WeddingRoomCreateView.titleFlowers.pos");
         addToContent(this._flower);
         this._bgLeftTop = ComponentFactory.Instance.creatComponentByStylename("church.main.createWeddingRoomFrameLeftTopBg");
         addToContent(this._bgLeftTop);
         this._bgLeftBottom = ComponentFactory.Instance.creatComponentByStylename("church.main.createWeddingRoomFrameLeftBottomBg");
         addToContent(this._bgLeftBottom);
         this._roomCreateRoomNameTitle = ComponentFactory.Instance.creatBitmap("asset.church.roomCreateRoomNameTitleAsset");
         addToContent(this._roomCreateRoomNameTitle);
         this._roomCreateTimeTitle = ComponentFactory.Instance.creatBitmap("asset.church.roomCreateTimeTitleAsset");
         addToContent(this._roomCreateTimeTitle);
         this._txtCreateRoomName = ComponentFactory.Instance.creat("church.main.txtCreateRoomName");
         this._txtCreateRoomName.text = LanguageMgr.GetTranslation("hurch.weddingRoom.frame.CreateRoomFrame.name_txt",PlayerManager.Instance.Self.NickName,PlayerManager.Instance.Self.SpouseName);
         this._bg1 = ComponentFactory.Instance.creat("church.main.createRoomFrameBG");
         addToContent(this._bg1);
         addToContent(this._txtCreateRoomName);
         this._chkCreateRoomPassword = ComponentFactory.Instance.creat("church.main.chkCreateRoomPassword");
         addToContent(this._chkCreateRoomPassword);
         this._chkCreateRoomIsGuest = ComponentFactory.Instance.creat("church.main.chkCreateRoomIsGuest");
         addToContent(this._chkCreateRoomIsGuest);
         this._selectedIconButtonTxt1 = ComponentFactory.Instance.creat("church.main.WeddingRoomCreateView.SelectedIconButtonTxt1");
         this._selectedIconButtonTxt1.text = LanguageMgr.GetTranslation("church.main.WeddingRoomCreateView.SelectedIconButtonTxt1.text");
         this._chkCreateRoomPassword.addChild(this._selectedIconButtonTxt1);
         this._selectedIconButtonTxt2 = ComponentFactory.Instance.creat("church.main.WeddingRoomCreateView.SelectedIconButtonTxt2");
         this._selectedIconButtonTxt2.text = LanguageMgr.GetTranslation("church.main.WeddingRoomCreateView.SelectedIconButtonTxt2.text");
         this._chkCreateRoomIsGuest.addChild(this._selectedIconButtonTxt2);
         this._txtCreateRoomPassword = ComponentFactory.Instance.creat("church.main.txtCreateRoomPassword");
         this._txtCreateRoomPassword.displayAsPassword = true;
         this._txtCreateRoomPassword.enable = false;
         this._txtCreateRoomPassword.maxChars = 6;
         addToContent(this._txtCreateRoomPassword);
         this._roomCreateTime1SelectedBtn = ComponentFactory.Instance.creat("asset.church.roomCreateTimeSelectedBtn");
         addToContent(this._roomCreateTime1SelectedBtn);
         this._roomCreateTime1SelectedBtn.filters = ComponentFactory.Instance.creatFilters("lightFilter");
         this._roomCreateTime2SelectedBtn = ComponentFactory.Instance.creat("asset.church.roomCreateTimeSelectedBtn");
         addToContent(this._roomCreateTime2SelectedBtn);
         PositionUtils.setPos(this._roomCreateTime2SelectedBtn,"church.view.roomCreateTime1Btn.pos");
         this._roomCreateTime2SelectedBtn.filters = ComponentFactory.Instance.creatFilters("grayFilter");
         this._roomCreateTime3SelectedBtn = ComponentFactory.Instance.creat("asset.church.roomCreateTimeSelectedBtn");
         PositionUtils.setPos(this._roomCreateTime3SelectedBtn,"church.view.roomCreateTime2Btn.pos");
         addToContent(this._roomCreateTime3SelectedBtn);
         this._roomCreateTime1Txt = ComponentFactory.Instance.creatComponentByStylename("asset.church.roomCreateTime");
         this._roomCreateTime2Txt = ComponentFactory.Instance.creatComponentByStylename("asset.church.roomCreateTime");
         this._roomCreateTime3Txt = ComponentFactory.Instance.creatComponentByStylename("asset.church.roomCreateTime");
         addToContent(this._roomCreateTime1Txt);
         addToContent(this._roomCreateTime2Txt);
         addToContent(this._roomCreateTime3Txt);
         PositionUtils.setPos(this._roomCreateTime2Txt,"church.view.roomCreateTime1Txt.pos");
         PositionUtils.setPos(this._roomCreateTime3Txt,"church.view.roomCreateTime2Txt.pos");
         this._roomCreateTime1Txt.text = LanguageMgr.GetTranslation("church.weddingRoom.frame.roomCreateTime",2);
         this._roomCreateTime2Txt.text = LanguageMgr.GetTranslation("church.weddingRoom.frame.roomCreateTime",3);
         this._roomCreateTime3Txt.text = LanguageMgr.GetTranslation("church.weddingRoom.frame.roomCreateTime",4);
         this._roomCreateMoney1Txt = ComponentFactory.Instance.creatComponentByStylename("asset.church.roomCreateMoney");
         this._roomCreateMoney2Txt = ComponentFactory.Instance.creatComponentByStylename("asset.church.roomCreateMoney");
         this._roomCreateMoney3Txt = ComponentFactory.Instance.creatComponentByStylename("asset.church.roomCreateMoney");
         addToContent(this._roomCreateMoney1Txt);
         addToContent(this._roomCreateMoney2Txt);
         addToContent(this._roomCreateMoney3Txt);
         PositionUtils.setPos(this._roomCreateMoney2Txt,"church.view.roomCreateMoney1Txt.pos");
         PositionUtils.setPos(this._roomCreateMoney3Txt,"church.view.roomCreateMoney2Txt.pos");
         this._roomCreateMoney1Txt.text = LanguageMgr.GetTranslation("church.weddingRoom.frame.roomCreateMoney",int(PlayerManager.Instance.merryDiscountArr[0]) > 0 ? PlayerManager.Instance.merryDiscountArr[0] : ServerConfigManager.instance.weddingMoney[0]);
         this._roomCreateMoney2Txt.text = LanguageMgr.GetTranslation("church.weddingRoom.frame.roomCreateMoney",int(PlayerManager.Instance.merryDiscountArr[1]) > 0 ? PlayerManager.Instance.merryDiscountArr[1] : ServerConfigManager.instance.weddingMoney[1]);
         this._roomCreateMoney3Txt.text = LanguageMgr.GetTranslation("church.weddingRoom.frame.roomCreateMoney",int(PlayerManager.Instance.merryDiscountArr[2]) > 0 ? PlayerManager.Instance.merryDiscountArr[2] : ServerConfigManager.instance.weddingMoney[2]);
         this._roomCreateTimeGroup = new SelectedButtonGroup(false);
         this._roomCreateTimeGroup.addSelectItem(this._roomCreateTime1SelectedBtn);
         this._roomCreateTimeGroup.addSelectItem(this._roomCreateTime2SelectedBtn);
         this._roomCreateTimeGroup.addSelectItem(this._roomCreateTime3SelectedBtn);
         this._roomCreateTimeGroup.selectIndex = 0;
         this._roomCreateIntro = ComponentFactory.Instance.creatBitmap("asset.church.roomCreateIntroAsset");
         addToContent(this._roomCreateIntro);
         this._roomCreateIntroMaxChLabel = ComponentFactory.Instance.creat("asset.church.main.roomCreateIntroMaxChLabelAsset");
         addToContent(this._roomCreateIntroMaxChLabel);
         this._bgRight = ComponentFactory.Instance.creat("church.main.createRoomFrameRightBg");
         addToContent(this._bgRight);
         var groomName:String = "";
         var brideName:String = "";
         if(PlayerManager.Instance.Self.Sex)
         {
            groomName = PlayerManager.Instance.Self.NickName;
            brideName = PlayerManager.Instance.Self.SpouseName;
         }
         else
         {
            groomName = PlayerManager.Instance.Self.SpouseName;
            brideName = PlayerManager.Instance.Self.NickName;
         }
         this._txtRoomCreateIntro = ComponentFactory.Instance.creat("church.view.weddingRoomList.frame.WeddingRoomCreateViewField");
         this._txtRoomCreateIntro.text = LanguageMgr.GetTranslation("church.weddingRoom.frame.CreateRoomFrame._remark_txt",groomName,brideName);
         this._txtRoomCreateIntro.maxChars = 400;
         addToContent(this._txtRoomCreateIntro);
         var charCut:int = this._txtRoomCreateIntro.maxChars - this._txtRoomCreateIntro.text.length;
         this._roomCreateIntroMaxChLabel.text = LanguageMgr.GetTranslation("church.churchScene.frame.ModifyDiscriptionFrame.spare") + " " + String(charCut <= 0 ? 0 : charCut) + LanguageMgr.GetTranslation("church.churchScene.frame.ModifyDiscriptionFrame.word");
      }
      
      private function removeView() : void
      {
         this._alertInfo = null;
         if(Boolean(this._flower))
         {
            if(Boolean(this._flower.parent))
            {
               this._flower.parent.removeChild(this._flower);
            }
            this._flower.bitmapData.dispose();
            this._flower.bitmapData = null;
         }
         this._flower = null;
         if(Boolean(this._bgLeftTop))
         {
            ObjectUtils.disposeObject(this._bgLeftTop);
         }
         this._bgLeftTop = null;
         if(Boolean(this._bgLeftBottom))
         {
            ObjectUtils.disposeObject(this._bgLeftBottom);
         }
         this._bgLeftBottom = null;
         if(Boolean(this._roomCreateRoomNameTitle))
         {
            if(Boolean(this._roomCreateRoomNameTitle.parent))
            {
               this._roomCreateRoomNameTitle.parent.removeChild(this._roomCreateRoomNameTitle);
            }
            this._roomCreateRoomNameTitle.bitmapData.dispose();
            this._roomCreateRoomNameTitle.bitmapData = null;
         }
         this._roomCreateRoomNameTitle = null;
         if(Boolean(this._roomCreateIntro))
         {
            if(Boolean(this._roomCreateIntro.parent))
            {
               this._roomCreateIntro.parent.removeChild(this._roomCreateIntro);
            }
            this._roomCreateIntro.bitmapData.dispose();
            this._roomCreateIntro.bitmapData = null;
         }
         this._roomCreateIntro = null;
         if(Boolean(this._roomCreateTimeTitle))
         {
            if(Boolean(this._roomCreateTimeTitle.parent))
            {
               this._roomCreateTimeTitle.parent.removeChild(this._roomCreateTimeTitle);
            }
            this._roomCreateTimeTitle.bitmapData.dispose();
            this._roomCreateTimeTitle.bitmapData = null;
         }
         this._roomCreateTimeTitle = null;
         if(Boolean(this._txtCreateRoomName))
         {
            if(Boolean(this._txtCreateRoomName.parent))
            {
               this._txtCreateRoomName.parent.removeChild(this._txtCreateRoomName);
            }
            this._txtCreateRoomName.dispose();
         }
         this._txtCreateRoomName = null;
         if(Boolean(this._bg1))
         {
            ObjectUtils.disposeObject(this._bg1);
         }
         this._bg1 = null;
         if(Boolean(this._chkCreateRoomPassword))
         {
            if(Boolean(this._chkCreateRoomPassword.parent))
            {
               this._chkCreateRoomPassword.parent.removeChild(this._chkCreateRoomPassword);
            }
            this._chkCreateRoomPassword.dispose();
         }
         this._chkCreateRoomPassword = null;
         if(Boolean(this._txtCreateRoomPassword))
         {
            if(Boolean(this._txtCreateRoomPassword.parent))
            {
               this._txtCreateRoomPassword.parent.removeChild(this._txtCreateRoomPassword);
            }
            this._txtCreateRoomPassword.dispose();
         }
         this._txtCreateRoomPassword = null;
         if(Boolean(this._roomCreateTime1SelectedBtn))
         {
            if(Boolean(this._roomCreateTime1SelectedBtn.parent))
            {
               this._roomCreateTime1SelectedBtn.parent.removeChild(this._roomCreateTime1SelectedBtn);
            }
            this._roomCreateTime1SelectedBtn.dispose();
         }
         this._roomCreateTime1SelectedBtn = null;
         if(Boolean(this._roomCreateTime2SelectedBtn))
         {
            if(Boolean(this._roomCreateTime2SelectedBtn.parent))
            {
               this._roomCreateTime2SelectedBtn.parent.removeChild(this._roomCreateTime2SelectedBtn);
            }
            this._roomCreateTime2SelectedBtn.dispose();
         }
         this._roomCreateTime2SelectedBtn = null;
         if(Boolean(this._roomCreateTime3SelectedBtn))
         {
            if(Boolean(this._roomCreateTime3SelectedBtn.parent))
            {
               this._roomCreateTime3SelectedBtn.parent.removeChild(this._roomCreateTime3SelectedBtn);
            }
            this._roomCreateTime3SelectedBtn.dispose();
         }
         this._roomCreateTime3SelectedBtn = null;
         if(Boolean(this._roomCreateTime1Txt))
         {
            ObjectUtils.disposeObject(this._roomCreateTime1Txt);
         }
         this._roomCreateTime1Txt = null;
         if(Boolean(this._roomCreateTime2Txt))
         {
            ObjectUtils.disposeObject(this._roomCreateTime2Txt);
         }
         this._roomCreateTime2Txt = null;
         if(Boolean(this._roomCreateTime3Txt))
         {
            ObjectUtils.disposeObject(this._roomCreateTime3Txt);
         }
         this._roomCreateTime3Txt = null;
         if(Boolean(this._roomCreateMoney1Txt))
         {
            ObjectUtils.disposeObject(this._roomCreateMoney1Txt);
         }
         this._roomCreateMoney1Txt = null;
         if(Boolean(this._roomCreateMoney2Txt))
         {
            ObjectUtils.disposeObject(this._roomCreateMoney2Txt);
         }
         this._roomCreateMoney2Txt = null;
         if(Boolean(this._roomCreateMoney3Txt))
         {
            ObjectUtils.disposeObject(this._roomCreateMoney3Txt);
         }
         this._roomCreateMoney3Txt = null;
         if(Boolean(this._roomCreateIntroMaxChLabel))
         {
            if(Boolean(this._roomCreateIntroMaxChLabel.parent))
            {
               this._roomCreateIntroMaxChLabel.parent.removeChild(this._roomCreateIntroMaxChLabel);
            }
            this._roomCreateIntroMaxChLabel.dispose();
         }
         this._roomCreateIntroMaxChLabel = null;
         if(Boolean(this._bgRight))
         {
            if(Boolean(this._bgRight.parent))
            {
               this._bgRight.parent.removeChild(this._bgRight);
            }
            this._bgRight.dispose();
         }
         this._bgRight = null;
         this._txtRoomCreateIntro = null;
         if(Boolean(this._roomCreateTimeGroup))
         {
            this._roomCreateTimeGroup.dispose();
         }
         this._roomCreateTimeGroup = null;
         if(Boolean(this._selectedIconButtonTxt1))
         {
            if(Boolean(this._selectedIconButtonTxt1.parent))
            {
               this._selectedIconButtonTxt1.parent.removeChild(this._selectedIconButtonTxt1);
            }
            this._selectedIconButtonTxt1.dispose();
         }
         this._selectedIconButtonTxt1 = null;
         if(Boolean(this._selectedIconButtonTxt2))
         {
            if(Boolean(this._selectedIconButtonTxt2.parent))
            {
               this._selectedIconButtonTxt2.parent.removeChild(this._selectedIconButtonTxt2);
            }
            this._selectedIconButtonTxt2.dispose();
         }
         this._selectedIconButtonTxt2 = null;
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
      
      private function setEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.onFrameResponse);
         this._chkCreateRoomPassword.addEventListener(MouseEvent.CLICK,this.onRoomPasswordCheck);
         this._txtRoomCreateIntro.addEventListener(Event.CHANGE,this.onIntroChange);
         this._chkCreateRoomIsGuest.addEventListener(MouseEvent.CLICK,this.onIsGuest);
         this._roomCreateTime1SelectedBtn.addEventListener(MouseEvent.CLICK,this.onIsGuest1);
         this._roomCreateTime2SelectedBtn.addEventListener(MouseEvent.CLICK,this.onIsGuest2);
         this._roomCreateTime3SelectedBtn.addEventListener(MouseEvent.CLICK,this.onIsGuest3);
      }
      
      private function removeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.onFrameResponse);
         if(Boolean(this._chkCreateRoomPassword))
         {
            this._chkCreateRoomPassword.removeEventListener(MouseEvent.CLICK,this.onRoomPasswordCheck);
         }
         if(Boolean(this._txtRoomCreateIntro))
         {
            this._txtRoomCreateIntro.removeEventListener(Event.CHANGE,this.onIntroChange);
         }
         if(Boolean(this._chkCreateRoomIsGuest))
         {
            this._chkCreateRoomIsGuest.removeEventListener(MouseEvent.CLICK,this.onIsGuest);
         }
         if(Boolean(this._roomCreateTime1SelectedBtn))
         {
            this._roomCreateTime1SelectedBtn.removeEventListener(MouseEvent.CLICK,this.onIsGuest1);
         }
         if(Boolean(this._roomCreateTime2SelectedBtn))
         {
            this._roomCreateTime2SelectedBtn.removeEventListener(MouseEvent.CLICK,this.onIsGuest2);
         }
         if(Boolean(this._roomCreateTime3SelectedBtn))
         {
            this._roomCreateTime3SelectedBtn.removeEventListener(MouseEvent.CLICK,this.onIsGuest3);
         }
      }
      
      private function onIsGuest(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
      }
      
      private function onIsGuest1(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this._roomCreateTime1SelectedBtn.filters = ComponentFactory.Instance.creatFilters("lightFilter");
         this._roomCreateTime2SelectedBtn.filters = ComponentFactory.Instance.creatFilters("grayFilter");
         this._roomCreateTime3SelectedBtn.filters = ComponentFactory.Instance.creatFilters("grayFilter");
      }
      
      private function onIsGuest2(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this._roomCreateTime1SelectedBtn.filters = ComponentFactory.Instance.creatFilters("grayFilter");
         this._roomCreateTime2SelectedBtn.filters = ComponentFactory.Instance.creatFilters("lightFilter");
         this._roomCreateTime3SelectedBtn.filters = ComponentFactory.Instance.creatFilters("grayFilter");
      }
      
      private function onIsGuest3(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this._roomCreateTime1SelectedBtn.filters = ComponentFactory.Instance.creatFilters("grayFilter");
         this._roomCreateTime2SelectedBtn.filters = ComponentFactory.Instance.creatFilters("grayFilter");
         this._roomCreateTime3SelectedBtn.filters = ComponentFactory.Instance.creatFilters("lightFilter");
      }
      
      private function onRoomPasswordCheck(evt:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this._txtCreateRoomPassword.enable = this._chkCreateRoomPassword.selected;
         if(this._txtCreateRoomPassword.enable)
         {
            this._txtCreateRoomPassword.setFocus();
         }
         else
         {
            this._txtCreateRoomPassword.text = "";
         }
      }
      
      private function onFrameResponse(evt:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         switch(evt.responseCode)
         {
            case FrameEvent.CANCEL_CLICK:
            case FrameEvent.CLOSE_CLICK:
            case FrameEvent.ESC_CLICK:
               this.dispose();
               break;
            case FrameEvent.ENTER_CLICK:
            case FrameEvent.SUBMIT_CLICK:
               this.createRoomConfirm();
         }
      }
      
      private function createRoomConfirm() : void
      {
         var nowMoney:int = int(PlayerManager.Instance.merryDiscountArr[this._roomCreateTimeGroup.selectIndex]) > 0 ? int(PlayerManager.Instance.merryDiscountArr[this._roomCreateTimeGroup.selectIndex]) : int(ServerConfigManager.instance.weddingMoney[this._roomCreateTimeGroup.selectIndex]);
         if(PlayerManager.Instance.Self.Money < nowMoney)
         {
            LeavePageManager.showFillFrame();
            return;
         }
         if(!this.checkRoom())
         {
            return;
         }
         var room:ChurchRoomInfo = new ChurchRoomInfo();
         room.roomName = this._txtCreateRoomName.text;
         room.password = this._txtCreateRoomPassword.text;
         room.valideTimes = this._roomCreateTimeGroup.selectIndex + 2;
         room.canInvite = this._chkCreateRoomIsGuest.selected;
         room.discription = FilterWordManager.filterWrod(this._txtRoomCreateIntro.text);
         this._controller.createRoom(room);
         this.dispose();
      }
      
      private function checkRoom() : Boolean
      {
         if(FilterWordManager.IsNullorEmpty(this._txtCreateRoomName.text))
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.roomlist.RoomListIICreateRoomView.name"));
            return false;
         }
         if(FilterWordManager.isGotForbiddenWords(this._txtCreateRoomName.text,"name"))
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.roomlist.RoomListIICreateRoomView.string"));
            return false;
         }
         if(this._chkCreateRoomPassword.selected && FilterWordManager.IsNullorEmpty(this._txtCreateRoomPassword.text))
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.roomlist.RoomListIICreateRoomView.set"));
            return false;
         }
         return true;
      }
      
      private function onIntroChange(e:Event) : void
      {
         this._roomCreateIntroMaxChLabel.text = LanguageMgr.GetTranslation("church.churchScene.frame.ModifyDiscriptionFrame.spare") + String(this._txtRoomCreateIntro.maxChars - this._txtRoomCreateIntro.text.length <= 0 ? 0 : this._txtRoomCreateIntro.maxChars - this._txtRoomCreateIntro.text.length) + LanguageMgr.GetTranslation("church.churchScene.frame.ModifyDiscriptionFrame.word");
      }
      
      public function show() : void
      {
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      override public function dispose() : void
      {
         super.dispose();
         this.removeEvent();
         this.removeView();
      }
   }
}

