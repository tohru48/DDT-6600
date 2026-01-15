package hall.hallInfo.playerInfo
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.ComponentSetting;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.controls.container.HBox;
   import com.pickgliss.ui.image.MovieImage;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.player.SelfInfo;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.events.PlayerPropertyEvent;
   import ddt.manager.LandersAwardManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.StateManager;
   import ddt.states.StateType;
   import ddt.view.common.DeedIcon;
   import ddt.view.common.KingBlessIcon;
   import ddtDeed.DeedManager;
   import email.manager.MailManager;
   import email.view.EmailEvent;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import hall.event.NewHallEvent;
   import kingBless.KingBlessManager;
   import newVersionGuide.NewVersionGuideManager;
   import oldPlayerRegress.RegressManager;
   import oldPlayerRegress.data.RegressData;
   import oldPlayerRegress.event.RegressEvent;
   import trainer.data.ArrowType;
   import trainer.data.Step;
   import trainer.view.NewHandContainer;
   import yyvip.YYVipManager;
   
   public class PlayerTool extends Sprite
   {
      
      private var _hBox:HBox;
      
      private var _kingBlessIcon:KingBlessIcon;
      
      private var _emailBtn:MovieImage;
      
      private var _celebrityBtn:SimpleBitmapButton;
      
      private var _oldPlayerBtn:SimpleBitmapButton;
      
      private var _selfInfo:SelfInfo;
      
      private var _deedIcon:DeedIcon;
      
      public function PlayerTool()
      {
         super();
         this._selfInfo = PlayerManager.Instance.Self;
         this.initView();
         this.initEvent();
         this.refreshView();
      }
      
      private function initView() : void
      {
         this._hBox = ComponentFactory.Instance.creatComponentByStylename("hall.playerInfo.toolVBox");
         addChild(this._hBox);
         this._kingBlessIcon = ComponentFactory.Instance.creatCustomObject("hall.playerInfo.KingBlessIcon",[1]);
         this._kingBlessIcon.setInfo(KingBlessManager.instance.getRemainTimeTxt().isOpen,true);
         this._hBox.addChild(this._kingBlessIcon);
         this._emailBtn = ComponentFactory.Instance.creatComponentByStylename("hall.playerInfo.mailBtn");
         this._emailBtn.tipData = LanguageMgr.GetTranslation("tank.view.common.BellowStripViewII.email");
         this._emailBtn.buttonMode = true;
         this._emailBtn.movie.gotoAndStop(1);
         this._hBox.addChild(this._emailBtn);
         this.showEmailEffect(true);
         this._celebrityBtn = ComponentFactory.Instance.creatComponentByStylename("hall.playerInfo.celebrityBtn");
         this._celebrityBtn.tipData = LanguageMgr.GetTranslation("ddt.hallStateView.celebrityText");
         this._hBox.addChild(this._celebrityBtn);
         YYVipManager.instance.createEntryBtn(this._hBox);
         LandersAwardManager.instance.createEntryBtn(this._hBox);
         this._deedIcon = ComponentFactory.Instance.creatCustomObject("hall.playerInfo.DeedIconIcon");
         this._deedIcon.setInfo(DeedManager.instance.isOpen,true);
         this._hBox.addChild(this._deedIcon);
         this._hBox.arrange();
         if(this._selfInfo.isOld)
         {
            RegressManager.instance.addEventListener(RegressEvent.REGRESS_ADD_REGRESSBTN,this.__onAddRegressBtn);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.REGRESS_RECVPACKS,this.__onRegressRecvPacks);
            SocketManager.Instance.out.sendRegressRecvPacks();
         }
      }
      
      protected function __onRegressRecvPacks(event:CrazyTankSocketEvent) : void
      {
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.REGRESS_RECVPACKS,this.__onRegressRecvPacks);
         RegressData.recvPacksInfo(event.pkg);
      }
      
      private function __onAddRegressBtn(event:RegressEvent) : void
      {
         RegressManager.instance.removeEventListener(RegressEvent.REGRESS_ADD_REGRESSBTN,this.__onAddRegressBtn);
         if(!this._selfInfo.isOld || RegressData.isOver)
         {
            this.removeOldPlayerBtn();
         }
         else
         {
            this._oldPlayerBtn = ComponentFactory.Instance.creatComponentByStylename("hall.playerInfo.oldPlayerBtn");
            this._oldPlayerBtn.tipData = LanguageMgr.GetTranslation("ddt.hallStateView.oldPlayer");
            this._hBox.addChild(this._oldPlayerBtn);
            this._hBox.arrange();
            this._oldPlayerBtn.addEventListener(MouseEvent.CLICK,this.__onOldPlayerClick);
         }
         if(this._selfInfo.isOld && !RegressData.isOver && !this._selfInfo.isSameDay && RegressData.isFirstLogin && RegressData.isAutoPop)
         {
            if(!NewVersionGuideManager.instance.isGuiding)
            {
               NewVersionGuideManager.instance.isShowOldPlayerFrame = false;
               RegressData.isAutoPop = false;
               RegressManager.instance.autoPopUp = true;
               RegressManager.instance.show();
            }
            else
            {
               NewVersionGuideManager.instance.isShowOldPlayerFrame = true;
            }
         }
      }
      
      private function initEvent() : void
      {
         this._emailBtn.addEventListener(MouseEvent.CLICK,this.__onMailClick);
         this._celebrityBtn.addEventListener(MouseEvent.CLICK,this.__onCelebrityClick);
         PlayerManager.Instance.Self.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__propertyChange);
         MailManager.Instance.Model.addEventListener(EmailEvent.INIT_EMAIL,this.__updateEmail);
         MailManager.Instance.Model.addEventListener(NewHallEvent.CANCELEMAILSHINE,this.__onSetEmailShine);
      }
      
      protected function __onSetEmailShine(event:NewHallEvent) : void
      {
         this.showEmailEffect(false);
      }
      
      protected function __updateEmail(event:Event) : void
      {
         if(Boolean(this._emailBtn))
         {
            this.showEmailEffect(true);
         }
      }
      
      private function showEmailEffect(show:Boolean) : void
      {
         if(show && MailManager.Instance.Model.hasUnReadEmail())
         {
            this._emailBtn.movie.gotoAndStop(2);
            this._emailBtn.mouseEnabled = true;
            this._emailBtn.mouseChildren = true;
         }
         else
         {
            this._emailBtn.movie.gotoAndStop(1);
         }
      }
      
      protected function __onOldPlayerClick(event:MouseEvent) : void
      {
         RegressManager.instance.show();
      }
      
      private function __propertyChange(event:PlayerPropertyEvent) : void
      {
         if(Boolean(event.changedProperties["Grade"]))
         {
            this.refreshView();
         }
      }
      
      private function refreshView() : void
      {
         var grade:int = PlayerManager.Instance.Self.Grade;
         if(grade >= 9)
         {
            this._celebrityBtn.alpha = 1;
            this._celebrityBtn.mouseEnabled = true;
            this._celebrityBtn.mouseChildren = true;
         }
         else
         {
            this._celebrityBtn.alpha = 0;
            this._celebrityBtn.mouseEnabled = false;
            this._celebrityBtn.mouseChildren = false;
         }
         if(grade == 11 && !PlayerManager.Instance.Self.isNewOnceFinish(Step.CHAT_HELPINFO))
         {
            SocketManager.Instance.out.syncWeakStep(Step.CHAT_HELPINFO);
            NewHandContainer.Instance.showArrow(ArrowType.CHAT_GUIDE,45,"hall.playerTool.chatGuidePos","asset.hall.chatHelpInfo","hall.playerTool.chatGuideInfoPos",LayerManager.Instance.getLayerByType(LayerManager.GAME_TOP_LAYER),5000,true);
         }
         if(grade == 9 && !PlayerManager.Instance.Self.isNewOnceFinish(Step.TOFFLIST_CLICK))
         {
            SocketManager.Instance.out.syncWeakStep(Step.TOFFLIST_CLICK);
            NewHandContainer.Instance.showArrow(ArrowType.TOFFLIST_GUIDE,135,"hall.playerTool.tofflistGuidePos","","",LayerManager.Instance.getLayerByType(LayerManager.GAME_TOP_LAYER),5000,true);
         }
      }
      
      protected function __onCelebrityClick(event:MouseEvent) : void
      {
         SoundManager.instance.play("047");
         StateManager.setState(StateType.TOFFLIST);
         ComponentSetting.SEND_USELOG_ID(8);
         if(PlayerManager.Instance.Self.IsWeakGuildFinish(Step.TOFF_LIST_OPEN) && !PlayerManager.Instance.Self.IsWeakGuildFinish(Step.TOFF_LIST_CLICKED))
         {
            SocketManager.Instance.out.syncWeakStep(Step.TOFF_LIST_CLICKED);
         }
      }
      
      protected function __onMailClick(event:MouseEvent) : void
      {
         SoundManager.instance.play("003");
         if(this._selfInfo.Grade >= 11)
         {
            MailManager.Instance.switchVisible();
         }
         else
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("hall.playerTool.emailLimit"));
         }
      }
      
      private function removeOldPlayerBtn() : void
      {
         if(Boolean(this._oldPlayerBtn))
         {
            this._hBox.removeChild(this._oldPlayerBtn);
            this._oldPlayerBtn.dispose();
            this._oldPlayerBtn.removeEventListener(MouseEvent.CLICK,this.__onOldPlayerClick);
            this._oldPlayerBtn = null;
         }
      }
      
      private function removeEvent() : void
      {
         this._emailBtn.removeEventListener(MouseEvent.CLICK,this.__onMailClick);
         this._celebrityBtn.removeEventListener(MouseEvent.CLICK,this.__onCelebrityClick);
         if(Boolean(this._oldPlayerBtn))
         {
            this._oldPlayerBtn.removeEventListener(MouseEvent.CLICK,this.__onOldPlayerClick);
         }
         PlayerManager.Instance.Self.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__propertyChange);
         MailManager.Instance.Model.removeEventListener(EmailEvent.INIT_EMAIL,this.__updateEmail);
         MailManager.Instance.Model.removeEventListener(NewHallEvent.CANCELEMAILSHINE,this.__onSetEmailShine);
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         if(Boolean(this._kingBlessIcon))
         {
            this._kingBlessIcon.dispose();
            this._kingBlessIcon = null;
         }
         if(Boolean(this._emailBtn))
         {
            this._emailBtn.dispose();
            this._emailBtn = null;
         }
         if(Boolean(this._celebrityBtn))
         {
            this._celebrityBtn.dispose();
            this._celebrityBtn = null;
         }
         this.removeOldPlayerBtn();
         YYVipManager.instance.disposeEntryBtn();
         LandersAwardManager.instance.disposeEntryBtn();
         if(Boolean(this._deedIcon))
         {
            ObjectUtils.disposeObject(this._deedIcon);
            this._deedIcon = null;
         }
         if(Boolean(this._hBox))
         {
            this._hBox.dispose();
            this._hBox = null;
         }
         ObjectUtils.disposeAllChildren(this);
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
   }
}

