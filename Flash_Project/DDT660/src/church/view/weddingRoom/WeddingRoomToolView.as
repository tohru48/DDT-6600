package church.view.weddingRoom
{
   import bagAndInfo.BagAndInfoManager;
   import baglocked.BaglockedManager;
   import church.controller.ChurchRoomController;
   import church.events.WeddingRoomEvent;
   import church.model.ChurchRoomModel;
   import church.view.churchFire.ChurchFireView;
   import church.view.invite.ChurchInviteController;
   import church.view.weddingRoom.frame.WeddingRoomConfigView;
   import church.view.weddingRoom.frame.WeddingRoomContinuationView;
   import church.view.weddingRoom.frame.WeddingRoomGiftFrameForGuest;
   import church.view.weddingRoom.frame.WeddingRoomGuestListView;
   import com.greensock.TweenLite;
   import com.greensock.easing.Sine;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.LoadResourceManager;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ClassUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.ChurchRoomInfo;
   import ddt.manager.ChatManager;
   import ddt.manager.ChurchManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.PathManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.StateManager;
   import ddt.states.StateType;
   import ddt.view.chat.ChatData;
   import ddt.view.chat.ChatInputView;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.net.URLRequestMethod;
   import giftSystem.GiftController;
   
   public class WeddingRoomToolView extends Sprite implements Disposeable
   {
      
      private static const LEAST_GIFT_MONEY:int = 100;
      
      private var _controller:ChurchRoomController;
      
      private var _model:ChurchRoomModel;
      
      private var _churchRoomControler:ChurchRoomController;
      
      private var _toolBg:Bitmap;
      
      private var _toolSwitchBg:BaseButton;
      
      private var _toolSwitch:Bitmap;
      
      private var _switchEnable:Boolean = true;
      
      private var _toolBtnRoomAdmin:BaseButton;
      
      private var _toolBtnInviteGuest:BaseButton;
      
      private var _toolBtnGift:BaseButton;
      
      private var _toolBtnFire:BaseButton;
      
      private var _toolBtnFill:BaseButton;
      
      private var _toolBtnExit:BaseButton;
      
      private var _toolBtnBack:BaseButton;
      
      private var _alertExit:BaseAlerFrame;
      
      private var _alertStartWedding:BaseAlerFrame;
      
      private var _fireLoader:BaseLoader;
      
      private var _churchFireView:ChurchFireView;
      
      private var _toolAdminBg:Bitmap;
      
      private var _startWeddingTip:Bitmap;
      
      private var _startWeddingTip2:Bitmap;
      
      private var _toolBtnStartWedding:BaseButton;
      
      private var _toolBtnAdminInviteGuest:BaseButton;
      
      private var _toolBtnGuestList:BaseButton;
      
      private var _toolBtnContinuation:BaseButton;
      
      private var _toolBtnModify:BaseButton;
      
      private var _adminToolVisible:Boolean = true;
      
      private var _sendGifeToolVisible:Boolean = false;
      
      private var _weddingRoomGiftFrameViewForGuest:WeddingRoomGiftFrameForGuest;
      
      private var _weddingRoomConfigView:WeddingRoomConfigView;
      
      private var _weddingRoomContinuationView:WeddingRoomContinuationView;
      
      private var _weddingRoomGuestListView:WeddingRoomGuestListView;
      
      private var _churchInviteController:ChurchInviteController;
      
      private var _startTipTween:TweenLite;
      
      private var _switchTween:TweenLite;
      
      private var _sendGiftToolBg:Bitmap;
      
      private var _toolSendGiftBtn:BaseButton;
      
      public var _toolSendCashBtn:BaseButton;
      
      public var _toolSendCashBtnForGuest:BaseButton;
      
      private var _isplayerStartTipMovieState:int = 0;
      
      public function WeddingRoomToolView()
      {
         super();
         this.initialize();
      }
      
      public function get controller() : ChurchRoomController
      {
         return this._controller;
      }
      
      public function set controller(value:ChurchRoomController) : void
      {
         this._controller = value;
      }
      
      public function set churchRoomModel(value:ChurchRoomModel) : void
      {
         this._model = value;
      }
      
      public function set churchRoomControler(value:ChurchRoomController) : void
      {
         this._churchRoomControler = value;
      }
      
      public function set inventBtnEnabled(value:Boolean) : void
      {
         this._toolBtnInviteGuest.enable = value;
      }
      
      private function initialize() : void
      {
         this.setView();
         this.setEvent();
      }
      
      private function setView() : void
      {
         this.loadFire();
         this._toolBg = ComponentFactory.Instance.creat("asset.church.room.toolBgAsset");
         addChild(this._toolBg);
         this._toolSwitchBg = ComponentFactory.Instance.creat("church.room.toolSwitchBgAsset");
         addChild(this._toolSwitchBg);
         this._toolSwitch = ComponentFactory.Instance.creat("asset.church.room.toolSwitchAsset");
         addChild(this._toolSwitch);
         this._toolBtnGift = ComponentFactory.Instance.creat("church.room.toolBtnGiftBtnAsset");
         addChild(this._toolBtnGift);
         this._toolBtnFire = ComponentFactory.Instance.creat("church.room.toolBtnFireBtnAsset");
         addChild(this._toolBtnFire);
         this._toolBtnFill = ComponentFactory.Instance.creat("church.room.toolBtnFillBtnAsset");
         addChild(this._toolBtnFill);
         this._toolBtnExit = ComponentFactory.Instance.creat("church.room.toolBtnExitBtnAsset");
         addChild(this._toolBtnExit);
         this._toolBtnBack = ComponentFactory.Instance.creat("church.room.toolBtnBackBtnAsset");
         this._toolBtnBack.visible = false;
         addChild(this._toolBtnBack);
         if(ChurchManager.instance.isAdmin(PlayerManager.Instance.Self))
         {
            this.showAdminToolView();
         }
         else
         {
            this._toolBtnInviteGuest = ComponentFactory.Instance.creat("church.room.toolBtnInviteGuestBtnAsset");
            addChild(this._toolBtnInviteGuest);
            if(!ChurchManager.instance.isAdmin(PlayerManager.Instance.Self))
            {
               if(Boolean(this._toolBtnInviteGuest))
               {
                  this._toolBtnInviteGuest.enable = ChurchManager.instance.currentRoom.canInvite;
               }
            }
         }
         this.showGiftToolView();
         this.GiftToolVisible = this._sendGifeToolVisible;
      }
      
      private function setEvent() : void
      {
         this._toolSwitchBg.addEventListener(MouseEvent.CLICK,this.toolSwitch);
         this._toolBtnGift.addEventListener(MouseEvent.CLICK,this.onToolMenuClick);
         this._toolBtnFire.addEventListener(MouseEvent.CLICK,this.onToolMenuClick);
         this._toolBtnFill.addEventListener(MouseEvent.CLICK,this.onToolMenuClick);
         this._toolBtnExit.addEventListener(MouseEvent.CLICK,this.onToolMenuClick);
         this._toolBtnBack.addEventListener(MouseEvent.CLICK,this.onToolMenuClick);
         this._toolSendGiftBtn.addEventListener(MouseEvent.CLICK,this.onToolMenuClick);
         this._toolSendCashBtn.addEventListener(MouseEvent.CLICK,this.onToolMenuClick);
         this._toolSendCashBtnForGuest.addEventListener(MouseEvent.CLICK,this.onToolMenuClick);
         if(ChurchManager.instance.isAdmin(PlayerManager.Instance.Self))
         {
            this._toolBtnGuestList.addEventListener(MouseEvent.CLICK,this.onToolMenuClick);
            this._toolBtnContinuation.addEventListener(MouseEvent.CLICK,this.onToolMenuClick);
            this._toolBtnModify.addEventListener(MouseEvent.CLICK,this.onToolMenuClick);
            this._toolBtnRoomAdmin.addEventListener(MouseEvent.CLICK,this.onToolMenuClick);
            this._toolBtnAdminInviteGuest.addEventListener(MouseEvent.CLICK,this.onToolMenuClick);
            this._toolBtnStartWedding.addEventListener(MouseEvent.CLICK,this.onToolMenuClick);
         }
         else
         {
            this._toolBtnInviteGuest.addEventListener(MouseEvent.CLICK,this.onToolMenuClick);
         }
         ChurchManager.instance.currentRoom.addEventListener(WeddingRoomEvent.WEDDING_STATUS_CHANGE,this.__weddingStatusChange);
         ChurchManager.instance.addEventListener(WeddingRoomEvent.SCENE_CHANGE,this.__updateBtn);
         ChurchManager.instance.addEventListener(WeddingRoomEvent.SCENE_CHANGE,this.__updateBtn);
      }
      
      public function resetView() : void
      {
         if(ChurchManager.instance.currentScene)
         {
            if(ChurchManager.instance.isAdmin(PlayerManager.Instance.Self))
            {
               this._toolBtnStartWedding.enable = false;
               this._startWeddingTip.visible = false;
               this._startWeddingTip2.visible = false;
               if(Boolean(this._startWeddingTip))
               {
                  this._startWeddingTip.visible = false;
               }
               if(Boolean(this._startWeddingTip2))
               {
                  this._startWeddingTip2.visible = false;
               }
            }
            this._toolBtnBack.visible = true;
            this._toolBtnExit.visible = false;
         }
         else
         {
            if(ChurchManager.instance.isAdmin(PlayerManager.Instance.Self))
            {
               this._toolBtnStartWedding.enable = true;
               this._startWeddingTip.visible = true;
               this._startWeddingTip2.visible = true;
               if(this._adminToolVisible)
               {
                  if(Boolean(this._startWeddingTip))
                  {
                     this._startWeddingTip.visible = true;
                  }
                  if(Boolean(this._startWeddingTip2))
                  {
                     this._startWeddingTip2.visible = true;
                  }
               }
               else
               {
                  if(Boolean(this._startWeddingTip))
                  {
                     this._startWeddingTip.visible = false;
                  }
                  if(Boolean(this._startWeddingTip2))
                  {
                     this._startWeddingTip2.visible = false;
                  }
               }
            }
            this._toolBtnBack.visible = false;
            this._toolBtnExit.visible = true;
         }
      }
      
      private function __weddingStatusChange(event:WeddingRoomEvent) : void
      {
         if(ChurchManager.instance.currentScene)
         {
            return;
         }
         if(Boolean(this._startWeddingTip))
         {
            if(Boolean(this._startWeddingTip.parent))
            {
               this._startWeddingTip.parent.removeChild(this._startWeddingTip);
            }
         }
         if(Boolean(this._startWeddingTip2))
         {
            if(Boolean(this._startWeddingTip2.parent))
            {
               this._startWeddingTip2.parent.removeChild(this._startWeddingTip2);
            }
         }
         this._startTipTween = null;
         var status:String = ChurchManager.instance.currentRoom.status;
         if(!ChurchManager.instance.isAdmin(PlayerManager.Instance.Self))
         {
            if(Boolean(this._toolBtnInviteGuest))
            {
               this._toolBtnInviteGuest.enable = ChurchManager.instance.currentRoom.canInvite;
            }
         }
         if(status == ChurchRoomInfo.WEDDING_ING)
         {
            if(Boolean(this._toolBtnStartWedding))
            {
               this._toolBtnStartWedding.enable = false;
            }
            if(Boolean(this._toolBtnAdminInviteGuest))
            {
               this._toolBtnAdminInviteGuest.enable = false;
            }
            if(Boolean(this._toolBtnInviteGuest))
            {
               this._toolBtnInviteGuest.enable = false;
            }
            if(Boolean(this._toolBtnFire))
            {
               this._toolBtnFire.enable = false;
            }
            if(Boolean(this._churchFireView) && Boolean(this._churchFireView.parent))
            {
               this._churchFireView.parent.removeChild(this._churchFireView);
            }
         }
         else
         {
            if(Boolean(this._toolBtnStartWedding))
            {
               this._toolBtnStartWedding.enable = true;
            }
            if(Boolean(this._toolBtnAdminInviteGuest))
            {
               this._toolBtnAdminInviteGuest.enable = true;
            }
            if(Boolean(this._toolBtnInviteGuest))
            {
               this._toolBtnInviteGuest.enable = ChurchManager.instance.currentRoom.canInvite;
            }
            if(Boolean(this._toolBtnFire))
            {
               this._toolBtnFire.enable = true;
            }
            if(Boolean(this._toolBtnExit))
            {
               this._toolBtnExit.enable = true;
            }
            if(Boolean(this._toolBtnBack))
            {
               this._toolBtnBack.enable = true;
            }
         }
      }
      
      private function __updateBtn(evt:WeddingRoomEvent) : void
      {
         if(Boolean(this._churchInviteController))
         {
            this._churchInviteController.hide();
         }
         if(ChurchManager.instance.currentScene)
         {
            this._toolBtnBack.visible = false;
            this._toolBtnExit.visible = true;
         }
         else
         {
            this._toolBtnBack.visible = true;
            this._toolBtnExit.visible = false;
         }
      }
      
      private function showAdminToolView() : void
      {
         this._toolAdminBg = ComponentFactory.Instance.creat("asset.church.room.toolAdminBgAsset");
         addChild(this._toolAdminBg);
         this._toolBtnStartWedding = ComponentFactory.Instance.creat("church.room.toolBtnStartWeddingBtnAsset");
         addChild(this._toolBtnStartWedding);
         this._toolBtnRoomAdmin = ComponentFactory.Instance.creat("church.room.toolBtnRoomAdminBtnAsset");
         addChild(this._toolBtnRoomAdmin);
         this._toolBtnGuestList = ComponentFactory.Instance.creat("church.room.toolBtnGuestListBtnAsset");
         addChild(this._toolBtnGuestList);
         this._toolBtnContinuation = ComponentFactory.Instance.creat("church.room.toolBtnContinuationBtnAsset");
         addChild(this._toolBtnContinuation);
         this._toolBtnAdminInviteGuest = ComponentFactory.Instance.creat("church.room.toolBtnAdminInviteGuestBtnAsset");
         addChild(this._toolBtnAdminInviteGuest);
         if(!ChurchManager.instance.isAdmin(PlayerManager.Instance.Self))
         {
            if(Boolean(this._toolBtnInviteGuest))
            {
               this._toolBtnInviteGuest.enable = ChurchManager.instance.currentRoom.canInvite;
            }
         }
         this._toolBtnModify = ComponentFactory.Instance.creat("church.room.toolBtnModifyBtnAsset");
         addChild(this._toolBtnModify);
         if(PlayerManager.Instance.Self.ID != ChurchManager.instance.currentRoom.createID)
         {
            this._toolBtnModify.enable = false;
         }
         if(!this._startWeddingTip)
         {
            this._startWeddingTip = ComponentFactory.Instance.creatBitmap("asset.church.room.startWeddingTipAsset");
         }
         addChild(this._startWeddingTip);
         if(!this._startWeddingTip2)
         {
            this._startWeddingTip2 = ComponentFactory.Instance.creatBitmap("asset.church.room.startWeddingTip2Asset");
         }
         addChild(this._startWeddingTip2);
         this.playerStartTipMovie();
      }
      
      private function set adminToolVisible(value:Boolean) : void
      {
         if(Boolean(this._toolAdminBg))
         {
            this._toolAdminBg.visible = value;
         }
         if(Boolean(this._toolBtnStartWedding))
         {
            this._toolBtnStartWedding.visible = value;
         }
         if(Boolean(this._toolBtnGuestList))
         {
            this._toolBtnGuestList.visible = value;
         }
         if(Boolean(this._toolBtnContinuation))
         {
            this._toolBtnContinuation.visible = value;
         }
         if(Boolean(this._toolBtnAdminInviteGuest))
         {
            this._toolBtnAdminInviteGuest.visible = value;
         }
         if(Boolean(this._toolBtnModify))
         {
            this._toolBtnModify.visible = value;
         }
         if(Boolean(this._startWeddingTip))
         {
            this._startWeddingTip.visible = value;
         }
         if(Boolean(this._startWeddingTip2))
         {
            this._startWeddingTip2.visible = value;
         }
         if(ChurchManager.instance.currentScene == true)
         {
            if(Boolean(this._startWeddingTip))
            {
               this._startWeddingTip.visible = false;
            }
            if(Boolean(this._startWeddingTip2))
            {
               this._startWeddingTip2.visible = false;
            }
         }
      }
      
      private function showGiftToolView() : void
      {
         this._sendGiftToolBg = ComponentFactory.Instance.creat("asset.church.room.toolAdminBgAsset");
         this._sendGiftToolBg.width = 120;
         this._sendGiftToolBg.x = 60;
         addChild(this._sendGiftToolBg);
         this._toolSendGiftBtn = ComponentFactory.Instance.creat("church.room.toolBtnSendGiftAsset");
         addChild(this._toolSendGiftBtn);
         this._toolSendCashBtn = ComponentFactory.Instance.creat("asset.church.room.adminToGuest");
         this._toolSendCashBtn.enable = false;
         addChild(this._toolSendCashBtn);
         this._toolSendCashBtn.visible = false;
         this._toolSendCashBtnForGuest = ComponentFactory.Instance.creat("church.room.toolBtnSendCashAsset");
         this.addChild(this._toolSendCashBtnForGuest);
         this._toolSendCashBtnForGuest.visible = false;
      }
      
      private function set GiftToolVisible(value:Boolean) : void
      {
         if(Boolean(this._toolSendGiftBtn))
         {
            this._toolSendGiftBtn.visible = value;
         }
         if(Boolean(this._sendGiftToolBg))
         {
            this._sendGiftToolBg.visible = value;
         }
         if(!value)
         {
            this._toolSendCashBtnForGuest.visible = false;
            this._toolSendCashBtn.visible = false;
         }
         else if(this.isGuest())
         {
            this._toolSendCashBtnForGuest.visible = true;
            this._toolSendCashBtn.visible = false;
         }
         else
         {
            this._toolSendCashBtnForGuest.visible = false;
            this._toolSendCashBtn.visible = true;
         }
      }
      
      private function playerStartTipMovie() : void
      {
         if(this._isplayerStartTipMovieState == 1)
         {
            this._isplayerStartTipMovieState = 0;
            this._startTipTween = TweenLite.to(this._startWeddingTip2,0.3,{
               "y":this._startWeddingTip2.y - 10,
               "ease":Sine.easeInOut,
               "onComplete":this.playerStartTipMovie
            });
         }
         else
         {
            this._isplayerStartTipMovieState = 1;
            this._startTipTween = TweenLite.to(this._startWeddingTip2,0.3,{
               "y":this._startWeddingTip2.y + 10,
               "ease":Sine.easeInOut,
               "onComplete":this.playerStartTipMovie
            });
         }
      }
      
      private function isGuest() : Boolean
      {
         var tempArr:Array = [ChurchManager.instance.currentRoom.groomName,ChurchManager.instance.currentRoom.brideName];
         var tempIndex:int = int(tempArr.indexOf(PlayerManager.Instance.Self.NickName));
         return tempIndex >= 0 ? false : true;
      }
      
      private function onToolMenuClick(evt:MouseEvent) : void
      {
         switch(evt.currentTarget)
         {
            case this._toolBtnGift:
               SoundManager.instance.play("008");
               this.GiftToolVisible = !this._sendGifeToolVisible;
               this._sendGifeToolVisible = !this._sendGifeToolVisible;
               this._adminToolVisible = this.adminToolVisible = false;
               break;
            case this._toolBtnFire:
               if(this._toolBtnFire.enable == true)
               {
                  SoundManager.instance.play("008");
               }
               this.openFireList();
               break;
            case this._toolBtnFill:
               LeavePageManager.leaveToFillPath();
               break;
            case this._toolBtnBack:
               if(this._toolBtnBack.enable == true)
               {
                  SoundManager.instance.play("008");
               }
               this.exitRoom();
               break;
            case this._toolBtnExit:
               if(this._toolBtnExit.enable == true)
               {
                  SoundManager.instance.play("008");
               }
               if(!this._alertExit)
               {
                  this._alertExit = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("church.weddingRoom.WeddingRoomControler.leaveRoom"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,false,false,LayerManager.ALPHA_BLOCKGOUND);
                  this._alertExit.addEventListener(FrameEvent.RESPONSE,this.exitResponse);
               }
               break;
            case this._toolBtnRoomAdmin:
               SoundManager.instance.play("008");
               this._sendGifeToolVisible = this.GiftToolVisible = false;
               this.adminToolVisible = !this._adminToolVisible;
               this._adminToolVisible = !this._adminToolVisible;
               break;
            case this._toolBtnModify:
               SoundManager.instance.play("008");
               this.openRoomConfig();
               break;
            case this._toolBtnContinuation:
               if(PlayerManager.Instance.Self.bagLocked)
               {
                  BaglockedManager.Instance.show();
                  SoundManager.instance.play("008");
                  return;
               }
               SoundManager.instance.play("008");
               this.openRoomContinuation();
               break;
            case this._toolBtnGuestList:
               SoundManager.instance.play("008");
               this.openGuestList();
               break;
            case this._toolBtnInviteGuest:
            case this._toolBtnAdminInviteGuest:
               SoundManager.instance.play("008");
               this.openInviteGuest();
               break;
            case this._toolBtnStartWedding:
               SoundManager.instance.play("008");
               this.openStartWedding();
               break;
            case this._toolSendGiftBtn:
               SoundManager.instance.play("008");
               GiftController.Instance.inChurch = true;
               BagAndInfoManager.Instance.showGiftFrame();
               break;
            case this._toolSendCashBtn:
               SoundManager.instance.play("008");
               this.giftViewForGuest();
               break;
            case this._toolSendCashBtnForGuest:
               SoundManager.instance.play("008");
               this.giftView();
         }
      }
      
      public function giftViewForGuest() : void
      {
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         SocketManager.Instance.out.requestRefund();
      }
      
      public function giftView() : void
      {
         var msg:ChatData = null;
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         if(PlayerManager.Instance.Self.Money < LEAST_GIFT_MONEY)
         {
            msg = new ChatData();
            msg.channel = ChatInputView.SYS_NOTICE;
            msg.msg = LanguageMgr.GetTranslation("church.churchScene.SceneControler.startWedding.Money",LEAST_GIFT_MONEY);
            ChatManager.Instance.chat(msg);
            return;
         }
         if(Boolean(this._weddingRoomGiftFrameViewForGuest))
         {
            if(Boolean(this._weddingRoomGiftFrameViewForGuest.parent))
            {
               this._weddingRoomGiftFrameViewForGuest.parent.removeChild(this._weddingRoomGiftFrameViewForGuest);
            }
            this._weddingRoomGiftFrameViewForGuest.removeEventListener(Event.CLOSE,this.closeRoomGift);
            this._weddingRoomGiftFrameViewForGuest.dispose();
            this._weddingRoomGiftFrameViewForGuest = null;
         }
         else
         {
            this._weddingRoomGiftFrameViewForGuest = ComponentFactory.Instance.creat("church.weddingRoom.frame.WeddingRoomGiftFrameViewForGuest");
            this._weddingRoomGiftFrameViewForGuest.addEventListener(Event.CLOSE,this.closeRoomGift);
            this._weddingRoomGiftFrameViewForGuest.controller = this._controller;
            this._weddingRoomGiftFrameViewForGuest.show();
         }
      }
      
      private function exitResponse(evt:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         switch(evt.responseCode)
         {
            case FrameEvent.SUBMIT_CLICK:
            case FrameEvent.ENTER_CLICK:
               this.exitRoom();
               break;
            case FrameEvent.CANCEL_CLICK:
            case FrameEvent.CLOSE_CLICK:
            case FrameEvent.ESC_CLICK:
               if(Boolean(this._alertExit))
               {
                  if(Boolean(this._alertExit.parent))
                  {
                     this._alertExit.parent.removeChild(this._alertExit);
                  }
                  this._alertExit.dispose();
               }
               this._alertExit = null;
         }
         ObjectUtils.disposeObject(evt.target);
      }
      
      private function exitRoom() : void
      {
         if(ChurchManager.instance.currentScene && ChurchManager.instance.currentRoom.status == ChurchRoomInfo.WEDDING_NONE)
         {
            ChurchManager.instance.currentScene = false;
         }
         else
         {
            StateManager.setState(StateType.DDTCHURCH_ROOM_LIST);
         }
      }
      
      private function toolSwitch(evt:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(this._switchEnable)
         {
            this._switchTween = null;
            this._switchTween = TweenLite.to(this,0.5,{
               "x":stage.stageWidth - this.width + (this.width - 34),
               "ease":Sine.easeInOut
            });
            this._switchEnable = false;
         }
         else
         {
            this._switchTween = null;
            this._switchTween = TweenLite.to(this,0.5,{
               "x":stage.stageWidth - this.width,
               "ease":Sine.easeInOut
            });
            this._switchEnable = true;
         }
      }
      
      public function loadFire() : void
      {
         this._fireLoader = LoadResourceManager.Instance.createLoader(PathManager.solveCatharineSwf(),BaseLoader.MODULE_LOADER,null,URLRequestMethod.GET,null,false);
         LoadResourceManager.Instance.startLoad(this._fireLoader,false,false);
      }
      
	  private function get isFireLoaded() : Boolean
	  {
		  var fireClass:Class = null;
		  try
		  {
			  fireClass = ClassUtils.uiSourceDomain.getDefinition("tank.church.fireAcect.FireItemAccect02") as Class;
			  if(Boolean(fireClass))
			  {
				  return true;
			  }
			  return false;
		  }
		  catch(e:Error)
		  {
			  return false;
		  }
		  return false;
	  }
      
      private function openFireList() : void
      {
         this.closeRoomGuestList();
         this.closeInviteGuest();
         if(!this.isFireLoaded)
         {
            AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("church.churchScene.SceneUI.switchVisibleFireList"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),true,false,false,LayerManager.ALPHA_BLOCKGOUND);
            return;
         }
         if(!this._churchFireView)
         {
            this._churchFireView = ComponentFactory.Instance.creatCustomObject("church.churchFire.ChurchFireView",[this._controller,this._model]);
         }
         if(Boolean(this._churchFireView.parent))
         {
            this._churchFireView.parent.removeChild(this._churchFireView);
         }
         else
         {
            LayerManager.Instance.addToLayer(this._churchFireView,LayerManager.GAME_TOP_LAYER);
         }
      }
      
      private function openRoomConfig() : void
      {
         if(Boolean(this._weddingRoomConfigView))
         {
            if(Boolean(this._weddingRoomConfigView.parent))
            {
               this._weddingRoomConfigView.parent.removeChild(this._weddingRoomConfigView);
            }
            this._weddingRoomConfigView.removeEventListener(Event.CLOSE,this.closeRoomConfig);
            this._weddingRoomConfigView.dispose();
            this._weddingRoomConfigView = null;
         }
         else
         {
            this._weddingRoomConfigView = ComponentFactory.Instance.creat("church.weddingRoom.frame.WeddingRoomConfigView");
            this._weddingRoomConfigView.addEventListener(Event.CLOSE,this.closeRoomConfig);
            this._weddingRoomConfigView.controller = this._controller;
            this._weddingRoomConfigView.show();
         }
      }
      
      private function openRoomContinuation() : void
      {
         if(Boolean(this._weddingRoomContinuationView))
         {
            if(Boolean(this._weddingRoomContinuationView.parent))
            {
               this._weddingRoomContinuationView.parent.removeChild(this._weddingRoomContinuationView);
            }
            this._weddingRoomContinuationView.removeEventListener(Event.CLOSE,this.closeRoomContinuation);
            this._weddingRoomContinuationView.dispose();
            this._weddingRoomContinuationView = null;
         }
         else
         {
            this._weddingRoomContinuationView = ComponentFactory.Instance.creat("church.weddingRoom.frame.WeddingRoomContinuationView");
            this._weddingRoomContinuationView.addEventListener(Event.CLOSE,this.closeRoomContinuation);
            this._weddingRoomContinuationView.controller = this._controller;
            this._weddingRoomContinuationView.show();
         }
      }
      
      private function openGuestList() : void
      {
         this.closeFireList();
         this.closeInviteGuest();
         if(Boolean(this._weddingRoomGuestListView))
         {
            if(Boolean(this._weddingRoomGuestListView.parent))
            {
               this._weddingRoomGuestListView.parent.removeChild(this._weddingRoomGuestListView);
            }
            this._weddingRoomGuestListView.removeEventListener(Event.CLOSE,this.closeRoomGuestList);
            this._weddingRoomGuestListView.dispose();
            this._weddingRoomGuestListView = null;
         }
         else
         {
            this._weddingRoomGuestListView = ComponentFactory.Instance.creatCustomObject("church.weddingRoom.frame.WeddingRoomGuestListView",[this._controller,this._model]);
            this._weddingRoomGuestListView.addEventListener(Event.CLOSE,this.closeRoomGuestList);
            this._weddingRoomGuestListView.show();
         }
      }
      
      private function openInviteGuest() : void
      {
         this.closeFireList();
         this.closeRoomGuestList();
         if(this._churchInviteController == null)
         {
            this._churchInviteController = new ChurchInviteController();
         }
         if(Boolean(this._churchInviteController.getView().parent))
         {
            this._churchInviteController.getView().parent.removeChild(this._churchInviteController.getView());
         }
         else
         {
            this._churchInviteController.refleshList(0);
            this._churchInviteController.showView();
         }
      }
      
      private function openStartWedding() : void
      {
         if(this._toolBtnStartWedding.enable == true)
         {
            SoundManager.instance.play("008");
         }
         this._alertStartWedding = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tank.view.task.TaskCatalogContentView.tip"),LanguageMgr.GetTranslation("are.you.sure.to.marry"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),true,false,false,LayerManager.ALPHA_BLOCKGOUND);
         this._alertStartWedding.addEventListener(FrameEvent.RESPONSE,this.startWeddingResponse);
      }
      
      private function startWeddingResponse(evt:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         switch(evt.responseCode)
         {
            case FrameEvent.SUBMIT_CLICK:
            case FrameEvent.ENTER_CLICK:
               this._controller.startWedding();
               this.closeStartWedding();
               break;
            case FrameEvent.CANCEL_CLICK:
            case FrameEvent.CLOSE_CLICK:
            case FrameEvent.ESC_CLICK:
               this.closeStartWedding();
         }
         ObjectUtils.disposeObject(evt.target);
      }
      
      private function closeStartWedding() : void
      {
         if(Boolean(this._alertStartWedding))
         {
            if(Boolean(this._alertStartWedding.parent))
            {
               this._alertStartWedding.parent.removeChild(this._alertStartWedding);
            }
            this._alertStartWedding.dispose();
         }
         this._alertStartWedding = null;
      }
      
      private function closeFireList() : void
      {
         if(Boolean(this._churchFireView) && Boolean(this._churchFireView.parent))
         {
            this._churchFireView.parent.removeChild(this._churchFireView);
         }
      }
      
      private function closeRoomGift(evt:Event = null) : void
      {
         if(Boolean(this._weddingRoomGiftFrameViewForGuest))
         {
            this._weddingRoomGiftFrameViewForGuest.removeEventListener(Event.CLOSE,this.closeRoomGift);
            if(Boolean(this._weddingRoomGiftFrameViewForGuest.parent))
            {
               this._weddingRoomGiftFrameViewForGuest.parent.removeChild(this._weddingRoomGiftFrameViewForGuest);
            }
            this._weddingRoomGiftFrameViewForGuest.dispose();
         }
         this._weddingRoomGiftFrameViewForGuest = null;
      }
      
      private function closeRoomConfig(evt:Event = null) : void
      {
         if(Boolean(this._weddingRoomConfigView))
         {
            this._weddingRoomConfigView.removeEventListener(Event.CLOSE,this.closeRoomConfig);
            if(Boolean(this._weddingRoomConfigView.parent))
            {
               this._weddingRoomConfigView.parent.removeChild(this._weddingRoomConfigView);
            }
            this._weddingRoomConfigView.dispose();
         }
         this._weddingRoomConfigView = null;
      }
      
      private function closeRoomContinuation(evt:Event = null) : void
      {
         if(Boolean(this._weddingRoomContinuationView))
         {
            this._weddingRoomContinuationView.removeEventListener(Event.CLOSE,this.closeRoomContinuation);
            if(Boolean(this._weddingRoomContinuationView.parent))
            {
               this._weddingRoomContinuationView.parent.removeChild(this._weddingRoomContinuationView);
            }
            this._weddingRoomContinuationView.dispose();
         }
         this._weddingRoomContinuationView = null;
      }
      
      private function closeRoomGuestList(evt:Event = null) : void
      {
         if(Boolean(this._weddingRoomGuestListView))
         {
            this._weddingRoomGuestListView.removeEventListener(Event.CLOSE,this.closeRoomGuestList);
            if(Boolean(this._weddingRoomGuestListView.parent))
            {
               this._weddingRoomGuestListView.parent.removeChild(this._weddingRoomGuestListView);
            }
            this._weddingRoomGuestListView.dispose();
         }
         this._weddingRoomGuestListView = null;
      }
      
      private function closeInviteGuest(evt:Event = null) : void
      {
         if(this._churchInviteController && this._churchInviteController.getView() && Boolean(this._churchInviteController.getView().parent))
         {
            this._churchInviteController.getView().parent.removeChild(this._churchInviteController.getView());
         }
      }
      
      private function removeView() : void
      {
         if(Boolean(this._toolBg))
         {
            if(Boolean(this._toolBg.parent))
            {
               this._toolBg.parent.removeChild(this._toolBg);
            }
            this._toolBg.bitmapData.dispose();
            this._toolBg.bitmapData = null;
         }
         this._toolBg = null;
         if(Boolean(this._startWeddingTip2))
         {
            if(Boolean(this._startWeddingTip2.parent))
            {
               this._startWeddingTip2.parent.removeChild(this._startWeddingTip2);
            }
            this._startWeddingTip2.bitmapData.dispose();
            this._startWeddingTip2.bitmapData = null;
         }
         this._startWeddingTip2 = null;
         if(Boolean(this._toolSwitchBg))
         {
            if(Boolean(this._toolSwitchBg.parent))
            {
               this._toolSwitchBg.parent.removeChild(this._toolSwitchBg);
            }
            this._toolSwitchBg.dispose();
         }
         this._toolSwitchBg = null;
         if(Boolean(this._toolSwitch))
         {
            if(Boolean(this._toolSwitch.parent))
            {
               this._toolSwitch.parent.removeChild(this._toolSwitch);
            }
            this._toolSwitch.bitmapData.dispose();
            this._toolSwitch.bitmapData = null;
         }
         this._toolSwitch = null;
         if(Boolean(this._toolAdminBg))
         {
            if(Boolean(this._toolAdminBg.parent))
            {
               this._toolAdminBg.parent.removeChild(this._toolAdminBg);
            }
            this._toolAdminBg.bitmapData.dispose();
            this._toolAdminBg.bitmapData = null;
         }
         this._toolAdminBg = null;
         if(Boolean(this._startWeddingTip))
         {
            if(Boolean(this._startWeddingTip.parent))
            {
               this._startWeddingTip.parent.removeChild(this._startWeddingTip);
            }
            this._startWeddingTip.bitmapData.dispose();
            this._startWeddingTip.bitmapData = null;
         }
         this._startWeddingTip = null;
         if(Boolean(this._toolBtnRoomAdmin))
         {
            if(Boolean(this._toolBtnRoomAdmin.parent))
            {
               this._toolBtnRoomAdmin.parent.removeChild(this._toolBtnRoomAdmin);
            }
            this._toolBtnRoomAdmin.dispose();
         }
         this._toolBtnRoomAdmin = null;
         if(Boolean(this._toolBtnGift))
         {
            if(Boolean(this._toolBtnGift.parent))
            {
               this._toolBtnGift.parent.removeChild(this._toolBtnGift);
            }
            this._toolBtnGift.dispose();
         }
         this._toolBtnGift = null;
         if(Boolean(this._toolBtnFire))
         {
            if(Boolean(this._toolBtnFire.parent))
            {
               this._toolBtnFire.parent.removeChild(this._toolBtnFire);
            }
            this._toolBtnFire.dispose();
         }
         this._toolBtnFire = null;
         if(Boolean(this._toolBtnFill))
         {
            if(Boolean(this._toolBtnFill.parent))
            {
               this._toolBtnFill.parent.removeChild(this._toolBtnFill);
            }
            this._toolBtnFill.dispose();
         }
         this._toolBtnFill = null;
         if(Boolean(this._toolBtnExit))
         {
            if(Boolean(this._toolBtnExit.parent))
            {
               this._toolBtnExit.parent.removeChild(this._toolBtnExit);
            }
            this._toolBtnExit.dispose();
         }
         this._toolBtnExit = null;
         if(Boolean(this._toolBtnBack))
         {
            if(Boolean(this._toolBtnBack.parent))
            {
               this._toolBtnBack.parent.removeChild(this._toolBtnBack);
            }
            this._toolBtnBack.dispose();
         }
         this._toolBtnBack = null;
         if(Boolean(this._toolBtnStartWedding))
         {
            if(Boolean(this._toolBtnStartWedding.parent))
            {
               this._toolBtnStartWedding.parent.removeChild(this._toolBtnStartWedding);
            }
            this._toolBtnStartWedding.dispose();
         }
         this._toolBtnStartWedding = null;
         if(Boolean(this._toolBtnAdminInviteGuest))
         {
            if(Boolean(this._toolBtnAdminInviteGuest.parent))
            {
               this._toolBtnAdminInviteGuest.parent.removeChild(this._toolBtnAdminInviteGuest);
            }
            this._toolBtnAdminInviteGuest.dispose();
         }
         this._toolBtnAdminInviteGuest = null;
         if(Boolean(this._toolBtnGuestList))
         {
            if(Boolean(this._toolBtnGuestList.parent))
            {
               this._toolBtnGuestList.parent.removeChild(this._toolBtnGuestList);
            }
            this._toolBtnGuestList.dispose();
         }
         this._toolBtnGuestList = null;
         if(Boolean(this._toolBtnContinuation))
         {
            if(Boolean(this._toolBtnContinuation.parent))
            {
               this._toolBtnContinuation.parent.removeChild(this._toolBtnContinuation);
            }
            this._toolBtnContinuation.dispose();
         }
         this._toolBtnContinuation = null;
         if(Boolean(this._toolBtnModify))
         {
            if(Boolean(this._toolBtnModify.parent))
            {
               this._toolBtnModify.parent.removeChild(this._toolBtnModify);
            }
            this._toolBtnModify.dispose();
         }
         this._toolBtnModify = null;
         if(Boolean(this._alertExit))
         {
            if(Boolean(this._alertExit.parent))
            {
               this._alertExit.parent.removeChild(this._alertExit);
            }
            this._alertExit.dispose();
         }
         this._alertExit = null;
         this._fireLoader = null;
         if(Boolean(this._churchFireView))
         {
            if(Boolean(this._churchFireView.parent))
            {
               this._churchFireView.parent.removeChild(this._churchFireView);
            }
            this._churchFireView.dispose();
         }
         this._churchFireView = null;
         if(Boolean(this._weddingRoomGiftFrameViewForGuest))
         {
            if(Boolean(this._weddingRoomGiftFrameViewForGuest.parent))
            {
               this._weddingRoomGiftFrameViewForGuest.parent.removeChild(this._weddingRoomGiftFrameViewForGuest);
            }
            this._weddingRoomGiftFrameViewForGuest.dispose();
         }
         this._weddingRoomGiftFrameViewForGuest = null;
         if(Boolean(this._weddingRoomConfigView))
         {
            if(Boolean(this._weddingRoomConfigView.parent))
            {
               this._weddingRoomConfigView.parent.removeChild(this._weddingRoomConfigView);
            }
            this._weddingRoomConfigView.dispose();
         }
         this._weddingRoomConfigView = null;
         if(Boolean(this._weddingRoomContinuationView))
         {
            if(Boolean(this._weddingRoomContinuationView.parent))
            {
               this._weddingRoomContinuationView.parent.removeChild(this._weddingRoomContinuationView);
            }
            this._weddingRoomContinuationView.dispose();
         }
         this._weddingRoomContinuationView = null;
         if(Boolean(this._weddingRoomGuestListView))
         {
            if(Boolean(this._weddingRoomGuestListView.parent))
            {
               this._weddingRoomGuestListView.parent.removeChild(this._weddingRoomGuestListView);
            }
            this._weddingRoomGuestListView.dispose();
         }
         this._weddingRoomGuestListView = null;
         if(Boolean(this._toolBtnInviteGuest))
         {
            if(Boolean(this._toolBtnInviteGuest.parent))
            {
               this._toolBtnInviteGuest.parent.removeChild(this._toolBtnInviteGuest);
            }
            this._toolBtnInviteGuest.dispose();
         }
         this._toolBtnInviteGuest = null;
         if(Boolean(this._alertStartWedding))
         {
            if(Boolean(this._alertStartWedding.parent))
            {
               this._alertStartWedding.parent.removeChild(this._alertStartWedding);
            }
            this._alertStartWedding.dispose();
         }
         this._alertStartWedding = null;
         if(Boolean(this._sendGiftToolBg))
         {
            if(Boolean(this._sendGiftToolBg.parent))
            {
               this._sendGiftToolBg.parent.removeChild(this._sendGiftToolBg);
            }
            ObjectUtils.disposeObject(this._sendGiftToolBg);
         }
         this._sendGiftToolBg = null;
         if(Boolean(this._toolSendGiftBtn))
         {
            if(Boolean(this._toolSendGiftBtn.parent))
            {
               this._toolSendGiftBtn.parent.removeChild(this._toolSendGiftBtn);
            }
            ObjectUtils.disposeObject(this._toolSendGiftBtn);
         }
         this._toolSendGiftBtn = null;
         if(Boolean(this._toolSendCashBtn))
         {
            if(Boolean(this._toolSendCashBtn.parent))
            {
               this._toolSendCashBtn.parent.removeChild(this._toolSendCashBtn);
            }
            ObjectUtils.disposeObject(this._toolSendCashBtn);
         }
         this._toolSendCashBtn = null;
         if(Boolean(this._toolSendCashBtnForGuest))
         {
            if(Boolean(this._toolSendCashBtnForGuest.parent))
            {
               this._toolSendCashBtnForGuest.parent.removeChild(this._toolSendCashBtnForGuest);
            }
            ObjectUtils.disposeObject(this._toolSendCashBtnForGuest);
         }
         this._toolSendCashBtnForGuest = null;
         if(Boolean(this._churchInviteController))
         {
            this._churchInviteController.dispose();
         }
         this._churchInviteController = null;
         if(Boolean(this._switchTween))
         {
            this._switchTween.kill();
         }
         this._switchTween = null;
         if(Boolean(this._startTipTween))
         {
            this._startTipTween.kill();
         }
         this._startTipTween = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
      
      private function removeEvent() : void
      {
         ChurchManager.instance.currentRoom.removeEventListener(WeddingRoomEvent.WEDDING_STATUS_CHANGE,this.__weddingStatusChange);
         ChurchManager.instance.removeEventListener(WeddingRoomEvent.SCENE_CHANGE,this.__updateBtn);
         ChurchManager.instance.removeEventListener(WeddingRoomEvent.SCENE_CHANGE,this.__updateBtn);
         this._toolSwitchBg.removeEventListener(MouseEvent.CLICK,this.toolSwitch);
         this._toolBtnGift.removeEventListener(MouseEvent.CLICK,this.onToolMenuClick);
         this._toolBtnFire.removeEventListener(MouseEvent.CLICK,this.onToolMenuClick);
         this._toolBtnFill.removeEventListener(MouseEvent.CLICK,this.onToolMenuClick);
         this._toolBtnExit.removeEventListener(MouseEvent.CLICK,this.onToolMenuClick);
         this._toolSendGiftBtn.removeEventListener(MouseEvent.CLICK,this.onToolMenuClick);
         this._toolSendCashBtn.removeEventListener(MouseEvent.CLICK,this.onToolMenuClick);
         this._toolSendCashBtnForGuest.removeEventListener(MouseEvent.CLICK,this.onToolMenuClick);
         if(Boolean(this._toolBtnRoomAdmin))
         {
            this._toolBtnRoomAdmin.removeEventListener(MouseEvent.CLICK,this.onToolMenuClick);
         }
         if(Boolean(this._toolBtnModify))
         {
            this._toolBtnModify.removeEventListener(MouseEvent.CLICK,this.onToolMenuClick);
         }
         if(Boolean(this._toolBtnContinuation))
         {
            this._toolBtnContinuation.removeEventListener(MouseEvent.CLICK,this.onToolMenuClick);
         }
         if(Boolean(this._toolBtnGuestList))
         {
            this._toolBtnGuestList.removeEventListener(MouseEvent.CLICK,this.onToolMenuClick);
         }
         if(Boolean(this._toolBtnStartWedding))
         {
            this._toolBtnStartWedding.removeEventListener(MouseEvent.CLICK,this.onToolMenuClick);
         }
         if(Boolean(this._toolBtnAdminInviteGuest))
         {
            this._toolBtnAdminInviteGuest.removeEventListener(MouseEvent.CLICK,this.onToolMenuClick);
         }
         if(Boolean(this._weddingRoomGiftFrameViewForGuest))
         {
            this._weddingRoomGiftFrameViewForGuest.removeEventListener(Event.CLOSE,this.closeRoomGift);
         }
         if(Boolean(this._weddingRoomConfigView))
         {
            this._weddingRoomConfigView.removeEventListener(Event.CLOSE,this.closeRoomConfig);
         }
         if(Boolean(this._weddingRoomContinuationView))
         {
            this._weddingRoomContinuationView.removeEventListener(Event.CLOSE,this.closeRoomContinuation);
         }
         if(Boolean(this._weddingRoomGuestListView))
         {
            this._weddingRoomGuestListView.removeEventListener(Event.CLOSE,this.closeRoomGuestList);
         }
         if(Boolean(this._alertExit))
         {
            this._alertExit.removeEventListener(FrameEvent.RESPONSE,this.exitResponse);
         }
         if(Boolean(this._alertStartWedding))
         {
            this._alertStartWedding.removeEventListener(FrameEvent.RESPONSE,this.startWeddingResponse);
         }
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         this.removeView();
      }
   }
}

