package gotopage.view
{
   import bagAndInfo.BagAndInfoManager;
   import battleGroud.BattleGroudManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.ComponentSetting;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.controls.container.SimpleTileList;
   import com.pickgliss.ui.image.MutipleImage;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.vo.AlertInfo;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.dailyRecord.DailyRecordControl;
   import ddt.manager.AcademyManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.StateManager;
   import ddt.states.StateType;
   import flash.events.MouseEvent;
   import kingBless.KingBlessManager;
   import league.manager.LeagueManager;
   import room.RoomManager;
   import setting.controll.SettingController;
   import trainer.controller.WeakGuildManager;
   import trainer.data.Step;
   import vip.VipController;
   
   public class GotoPageView extends BaseAlerFrame
   {
      
      private var _btnList:Vector.<SimpleBitmapButton>;
      
      private var _btnListContainer:SimpleTileList;
      
      private var _bg:Scale9CornerImage;
      
      private var _VIPBtn:SimpleBitmapButton;
      
      private var _kingBlessBtn:SimpleBitmapButton;
      
      private var _eliteBtn:SimpleBitmapButton;
      
      private var _battleShopBtn:SimpleBitmapButton;
      
      private var _giftBoxBtn:SimpleBitmapButton;
      
      private var _boguShopBtn:SimpleBitmapButton;
      
      private var _templeBtn:SimpleBitmapButton;
      
      private var _friendBtn:SimpleBitmapButton;
      
      private var _dailyBtn:SimpleBitmapButton;
      
      private var _setBtn:SimpleBitmapButton;
      
      private var _vline:MutipleImage;
      
      private var _hline:MutipleImage;
      
      private var _event:MouseEvent;
      
      public function GotoPageView()
      {
         super();
         this.initView();
      }
      
      private function initView() : void
      {
         info = new AlertInfo(LanguageMgr.GetTranslation("tank.view.ChannelList.FastMenu.titleText"));
         _info.showSubmit = false;
         _info.showCancel = false;
         _info.moveEnable = false;
         this._bg = ComponentFactory.Instance.creatComponentByStylename("gotopage.GotoPageView.bg");
         addToContent(this._bg);
         this._VIPBtn = ComponentFactory.Instance.creatComponentByStylename("gotopage.VIPBtn");
         addToContent(this._VIPBtn);
         this._kingBlessBtn = ComponentFactory.Instance.creatComponentByStylename("gotopage.kingBlessBtn");
         addToContent(this._kingBlessBtn);
         this._eliteBtn = ComponentFactory.Instance.creatComponentByStylename("gotopage.eliteBtn");
         addToContent(this._eliteBtn);
         this._battleShopBtn = ComponentFactory.Instance.creatComponentByStylename("gotopage.battleShopBtn");
         addToContent(this._battleShopBtn);
         this._giftBoxBtn = ComponentFactory.Instance.creatComponentByStylename("gotopage.giftBoxBtn");
         addToContent(this._giftBoxBtn);
         this._boguShopBtn = ComponentFactory.Instance.creatComponentByStylename("gotopage.boguShopBtn");
         addToContent(this._boguShopBtn);
         this._boguShopBtn.visible = false;
         this._templeBtn = ComponentFactory.Instance.creatComponentByStylename("gotopage.templeBtn");
         addToContent(this._templeBtn);
         this._friendBtn = ComponentFactory.Instance.creatComponentByStylename("gotopage.friendBtn");
         addToContent(this._friendBtn);
         this._dailyBtn = ComponentFactory.Instance.creatComponentByStylename("gotopage.dailyBtn");
         addToContent(this._dailyBtn);
         this._setBtn = ComponentFactory.Instance.creatComponentByStylename("gotopage.setBtn");
         addToContent(this._setBtn);
         this._vline = ComponentFactory.Instance.creatComponentByStylename("gotopage.vline");
         addToContent(this._vline);
         this._hline = ComponentFactory.Instance.creatComponentByStylename("gotopage.hline");
         addToContent(this._hline);
         this._btnList = new Vector.<SimpleBitmapButton>();
         this._btnList.push(this._VIPBtn);
         this._btnList.push(this._kingBlessBtn);
         this._btnList.push(this._eliteBtn);
         this._btnList.push(this._battleShopBtn);
         this._btnList.push(this._giftBoxBtn);
         this._btnList.push(this._boguShopBtn);
         this._btnList.push(this._templeBtn);
         this._btnList.push(this._friendBtn);
         this._btnList.push(this._dailyBtn);
         this._btnList.push(this._setBtn);
         this.creatBtn();
      }
      
      private function creatBtn() : void
      {
         for(var i:int = 0; i < this._btnList.length; i++)
         {
            this._btnList[i].addEventListener(MouseEvent.CLICK,this.__clickHandle);
         }
      }
      
      private function clearBtn() : void
      {
         for(var i:int = 0; i < this._btnList.length; i++)
         {
            if(Boolean(this._btnList[i]))
            {
               this._btnList[i].removeEventListener(MouseEvent.CLICK,this.__clickHandle);
               ObjectUtils.disposeObject(this._btnList[i]);
            }
            this._btnList[i] = null;
         }
      }
      
      private function __clickHandle(evt:MouseEvent) : void
      {
         evt.stopImmediatePropagation();
         this._event = evt;
         SoundManager.instance.play("047");
         if(evt.currentTarget != this._dailyBtn && evt.currentTarget != this._setBtn && evt.currentTarget != this._eliteBtn && evt.currentTarget != this._VIPBtn && RoomManager.Instance.current != null && RoomManager.Instance.current.selfRoomPlayer != null)
         {
            if((StateManager.currentStateType == StateType.MISSION_ROOM || RoomManager.Instance.current.isOpenBoss) && !RoomManager.Instance.current.selfRoomPlayer.isViewer)
            {
               this.showAlert();
               return;
            }
         }
         this.skipView(evt);
      }
      
      private function showAlert() : void
      {
         var alert:BaseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("tank.missionsettle.dungeon.leaveConfirm.contents"),"",LanguageMgr.GetTranslation("cancel"),true,true,false,LayerManager.BLCAK_BLOCKGOUND);
         alert.moveEnable = false;
         alert.addEventListener(FrameEvent.RESPONSE,this.__onResponse);
      }
      
      private function __onResponse(evt:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         var alert:BaseAlerFrame = evt.target as BaseAlerFrame;
         alert.removeEventListener(FrameEvent.RESPONSE,this.__onResponse);
         alert.dispose();
         alert = null;
         if(evt.responseCode == FrameEvent.ENTER_CLICK || evt.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            this.skipView(this._event);
         }
         else
         {
            this.dispose();
            dispatchEvent(new FrameEvent(FrameEvent.CLOSE_CLICK));
         }
      }
      
      private function skipView(evt:MouseEvent) : void
      {
         var isFirst:Boolean = false;
         var currentClick:int = int(this._btnList.indexOf(evt.currentTarget as SimpleBitmapButton));
         switch(currentClick)
         {
            case 0:
               VipController.instance.show();
               break;
            case 1:
               KingBlessManager.instance.loadKingBlessModule(KingBlessManager.instance.doOpenKingBlessFrame);
               break;
            case 2:
               if(!WeakGuildManager.Instance.checkOpen(Step.TOFF_LIST_OPEN,21))
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.functionLimitTip",21));
                  return;
               }
               BattleGroudManager.Instance.initBattleView();
               break;
            case 3:
               if(!WeakGuildManager.Instance.checkOpen(Step.TOFF_LIST_OPEN,22))
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.functionLimitTip",22));
                  return;
               }
               LeagueManager.instance.showLeagueShopFrame();
               break;
            case 4:
               if(PlayerManager.Instance.Self.Grade < 24)
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.functionLimitTip",24));
                  return;
               }
               BagAndInfoManager.Instance.showGiftFrame();
               break;
            case 5:
               StateManager.setState(StateType.LITTLEHALL);
               break;
            case 6:
               if(PlayerManager.Instance.Self.Grade < AcademyManager.TARGET_PLAYER_MIN_LEVEL)
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.functionLimitTip",12));
                  return;
               }
               if(PlayerManager.Instance.Self.apprenticeshipState == AcademyManager.NONE_STATE)
               {
                  StateManager.setState(StateType.ACADEMY_REGISTRATION);
               }
               else
               {
                  StateManager.setState(StateType.ACADEMY_REGISTRATION);
               }
               ComponentSetting.SEND_USELOG_ID(119);
               break;
            case 7:
               if(!WeakGuildManager.Instance.checkOpen(Step.CIVIL_OPEN,11))
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.functionLimitTip",11));
                  return;
               }
               isFirst = false;
               if(PlayerManager.Instance.Self.IsWeakGuildFinish(Step.CIVIL_OPEN) && !PlayerManager.Instance.Self.IsWeakGuildFinish(Step.CIVIL_CLICKED))
               {
                  SocketManager.Instance.out.syncWeakStep(Step.CIVIL_CLICKED);
                  isFirst = true;
               }
               StateManager.setState(StateType.CIVIL,isFirst);
               ComponentSetting.SEND_USELOG_ID(10);
               break;
            case 8:
               DailyRecordControl.Instance.alertDailyFrame();
               break;
            case 9:
               SettingController.Instance.switchVisible();
         }
         dispatchEvent(new FrameEvent(FrameEvent.CLOSE_CLICK));
      }
      
      override public function dispose() : void
      {
         GotoPageController.Instance.isShow = false;
         if(Boolean(this._bg))
         {
            ObjectUtils.disposeObject(this._bg);
         }
         this._bg = null;
         if(Boolean(this._VIPBtn))
         {
            ObjectUtils.disposeObject(this._VIPBtn);
         }
         this._VIPBtn = null;
         if(Boolean(this._kingBlessBtn))
         {
            ObjectUtils.disposeObject(this._kingBlessBtn);
         }
         this._kingBlessBtn = null;
         if(Boolean(this._eliteBtn))
         {
            ObjectUtils.disposeObject(this._eliteBtn);
         }
         this._eliteBtn = null;
         if(Boolean(this._battleShopBtn))
         {
            ObjectUtils.disposeObject(this._battleShopBtn);
         }
         this._battleShopBtn = null;
         if(Boolean(this._templeBtn))
         {
            ObjectUtils.disposeObject(this._templeBtn);
         }
         this._templeBtn = null;
         if(Boolean(this._boguShopBtn))
         {
            ObjectUtils.disposeObject(this._boguShopBtn);
         }
         this._boguShopBtn = null;
         if(Boolean(this._giftBoxBtn))
         {
            ObjectUtils.disposeObject(this._giftBoxBtn);
         }
         this._giftBoxBtn = null;
         if(Boolean(this._friendBtn))
         {
            ObjectUtils.disposeObject(this._friendBtn);
         }
         this._friendBtn = null;
         if(Boolean(this._dailyBtn))
         {
            ObjectUtils.disposeObject(this._dailyBtn);
         }
         this._dailyBtn = null;
         if(Boolean(this._setBtn))
         {
            ObjectUtils.disposeObject(this._setBtn);
         }
         this._setBtn = null;
         if(Boolean(this._vline))
         {
            ObjectUtils.disposeObject(this._vline);
         }
         this._vline = null;
         if(Boolean(this._hline))
         {
            ObjectUtils.disposeObject(this._hline);
         }
         this._hline = null;
         if(Boolean(this._btnList))
         {
            this.clearBtn();
         }
         ObjectUtils.disposeObject(this._btnListContainer);
         this._btnList = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
         super.dispose();
      }
   }
}

