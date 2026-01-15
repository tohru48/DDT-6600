package consortion.view.boss
{
   import baglocked.BaglockedManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.text.FilterFrameText;
   import consortion.ConsortionModelControl;
   import consortion.data.ConsortiaBossDataVo;
   import consortion.data.ConsortiaBossModel;
   import ddt.data.ConsortiaDutyType;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.ChatManager;
   import ddt.manager.ConsortiaDutyManager;
   import ddt.manager.GameInSocketOut;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.StateManager;
   import ddt.manager.TimeManager;
   import ddt.states.StateType;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import game.GameManager;
   import road7th.comm.PackageIn;
   import store.HelpFrame;
   
   public class ConsortiaBossFrame extends Frame
   {
      
      private var _bg:Bitmap;
      
      private var _cellList:Vector.<BossMemberItem>;
      
      private var _endTimeTxt:FilterFrameText;
      
      private var _extendBtn:SimpleBitmapButton;
      
      private var _bossStateBtn:SimpleBitmapButton;
      
      private var _helpBtn:SimpleBitmapButton;
      
      private var _timer:Timer;
      
      private var _timerChairman:Timer;
      
      private var _bossState:int = -1;
      
      private var _callBossLevel:int = 0;
      
      private var _isClickEnter:Boolean = false;
      
      private var _levelView:ConsortiaBossLevelView;
      
      public function ConsortiaBossFrame()
      {
         super();
         this.initView();
         this.initEvent();
         this.initData();
      }
      
      private function initView() : void
      {
         var i:int = 0;
         var cell:BossMemberItem = null;
         titleText = LanguageMgr.GetTranslation("ddt.consortia.bossFrame.titleTxt");
         this._bg = ComponentFactory.Instance.creatBitmap("asset.consortionBossFrame.bg");
         addToContent(this._bg);
         this._cellList = new Vector.<BossMemberItem>(11);
         for(i = 0; i < 11; i++)
         {
            cell = new BossMemberItem();
            cell.x = 26;
            cell.y = 88 + i * 35;
            cell.visible = false;
            addToContent(cell);
            this._cellList[i] = cell;
         }
         this._endTimeTxt = ComponentFactory.Instance.creatComponentByStylename("consortion.bossFrame.endTimeTxt");
         this._endTimeTxt.visible = false;
         addToContent(this._endTimeTxt);
         this._extendBtn = ComponentFactory.Instance.creatComponentByStylename("consortion.bossFrame.extendBtn");
         addToContent(this._extendBtn);
         this._extendBtn.enable = false;
         (this._extendBtn.backgound["mc"] as MovieClip).gotoAndStop(4);
         this._bossStateBtn = ComponentFactory.Instance.creatComponentByStylename("consortion.bossFrame.bossStateBtn");
         addToContent(this._bossStateBtn);
         this._bossStateBtn.enable = false;
         (this._bossStateBtn.backgound["mc"] as MovieClip).gotoAndStop(1);
         this._helpBtn = ComponentFactory.Instance.creatComponentByStylename("consortion.bossFrame.helpBtn");
         addToContent(this._helpBtn);
         this._levelView = new ConsortiaBossLevelView();
         PositionUtils.setPos(this._levelView,"consortiaBoss.levelViewPos");
         addToContent(this._levelView);
      }
      
      private function initEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         this._extendBtn.addEventListener(MouseEvent.CLICK,this.extendBossTime,false,0,true);
         this._bossStateBtn.addEventListener(MouseEvent.CLICK,this.callOrEnterBoss,false,0,true);
         this._helpBtn.addEventListener(MouseEvent.CLICK,this.showHelpFrame,false,0,true);
         GameManager.Instance.addEventListener(GameManager.START_LOAD,this.__startLoading);
         StateManager.getInGame_Step_1 = true;
      }
      
      private function extendBossTime(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         var costRich:int = ConsortionModelControl.Instance.getCallExtendBossCostRich(2,this._callBossLevel);
         var confirmFrame:BaseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("ddt.consortia.bossFrame.extendConfirmTxt",costRich),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),true,true,true,LayerManager.BLCAK_BLOCKGOUND);
         confirmFrame.moveEnable = false;
         confirmFrame.addEventListener(FrameEvent.RESPONSE,this.__confirmExtendBossTime,false,0,true);
      }
      
      private function __confirmExtendBossTime(evt:FrameEvent) : void
      {
         var costRich:int = 0;
         SoundManager.instance.play("008");
         var confirmFrame:BaseAlerFrame = evt.currentTarget as BaseAlerFrame;
         confirmFrame.removeEventListener(FrameEvent.RESPONSE,this.__confirmExtendBossTime);
         if(evt.responseCode == FrameEvent.SUBMIT_CLICK || evt.responseCode == FrameEvent.ENTER_CLICK)
         {
            costRich = ConsortionModelControl.Instance.getCallExtendBossCostRich(2,this._callBossLevel);
            if(PlayerManager.Instance.Self.consortiaInfo.Riches < costRich)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.consortia.bossFrame.unenoughRiches"));
               return;
            }
            SocketManager.Instance.out.sendConsortiaBossInfo(2);
            this._timerChairman.reset();
            this._timerChairman.start();
            this._timer.reset();
            this._timer.start();
            this._extendBtn.enable = false;
         }
      }
      
      private function callOrEnterBoss(event:MouseEvent) : void
      {
         var costRich:int = 0;
         var confirmFrame:BaseAlerFrame = null;
         SoundManager.instance.play("008");
         if(this._bossState == 0)
         {
            if(PlayerManager.Instance.Self.bagLocked)
            {
               BaglockedManager.Instance.show();
               return;
            }
            costRich = ConsortionModelControl.Instance.getCallBossCostRich(this._levelView.selectedLevel);
            confirmFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("ddt.consortia.bossFrame.callConfirmTxt",costRich),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),true,true,true,LayerManager.BLCAK_BLOCKGOUND);
            confirmFrame.moveEnable = false;
            confirmFrame.addEventListener(FrameEvent.RESPONSE,this.__confirmCallBoss,false,0,true);
         }
         else if(this._bossState == 1)
         {
            if(!this._isClickEnter)
            {
               this._isClickEnter = true;
               GameInSocketOut.sendSingleRoomBegin(2);
            }
         }
      }
      
      private function __confirmCallBoss(evt:FrameEvent) : void
      {
         var costRich:int = 0;
         SoundManager.instance.play("008");
         var confirmFrame:BaseAlerFrame = evt.currentTarget as BaseAlerFrame;
         confirmFrame.removeEventListener(FrameEvent.RESPONSE,this.__confirmCallBoss);
         if(evt.responseCode == FrameEvent.SUBMIT_CLICK || evt.responseCode == FrameEvent.ENTER_CLICK)
         {
            costRich = ConsortionModelControl.Instance.getCallBossCostRich(this._levelView.selectedLevel);
            if(PlayerManager.Instance.Self.consortiaInfo.Riches < costRich)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.consortia.bossFrame.unenoughRiches"));
               return;
            }
            SocketManager.Instance.out.sendConsortiaBossInfo(0,ConsortionModelControl.Instance.getRequestCallBossLevel(this._levelView.selectedLevel));
            this._timerChairman.reset();
            this._timerChairman.start();
            this._timer.reset();
            this._timer.start();
            this._bossStateBtn.enable = false;
         }
      }
      
      private function initData() : void
      {
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.CONSORTIA_BOSS_INFO,this.refreshData);
         this._timerChairman = new Timer(1000);
         this._timerChairman.addEventListener(TimerEvent.TIMER,this.timerHandler,false,0,true);
         this._timer = new Timer(10000);
         this._timer.addEventListener(TimerEvent.TIMER,this.timerHandler,false,0,true);
         this._timer.start();
         this.timerHandler(null);
      }
      
      private function timerHandler(event:TimerEvent) : void
      {
         SocketManager.Instance.out.sendConsortiaBossInfo(1);
      }
      
      private function refreshData(event:CrazyTankSocketEvent) : void
      {
         var isHasSelf:Boolean = false;
         var tmpCount:int = 0;
         var i:int = 0;
         var tmpVo:ConsortiaBossDataVo = null;
         var tmpVo2:ConsortiaBossDataVo = null;
         var model:ConsortiaBossModel = new ConsortiaBossModel();
         model.endTime = TimeManager.Instance.Now();
         model.extendAvailableNum = 3;
         model.playerList = new Vector.<ConsortiaBossDataVo>(11);
         this._callBossLevel = 0;
         var pkg:PackageIn = event.pkg;
         model.bossState = pkg.readByte();
         if(model.bossState == 1 || model.bossState == 2)
         {
            isHasSelf = pkg.readBoolean();
            if(isHasSelf)
            {
               tmpVo = new ConsortiaBossDataVo();
               tmpVo.name = PlayerManager.Instance.Self.NickName;
               tmpVo.rank = pkg.readInt();
               tmpVo.damage = pkg.readInt();
               tmpVo.honor = pkg.readInt();
               tmpVo.contribution = pkg.readInt();
               model.playerList[0] = tmpVo;
            }
            tmpCount = pkg.readByte();
            for(i = 1; i <= tmpCount; i++)
            {
               tmpVo2 = new ConsortiaBossDataVo();
               tmpVo2.name = pkg.readUTF();
               tmpVo2.rank = pkg.readInt();
               tmpVo2.damage = pkg.readInt();
               tmpVo2.honor = pkg.readInt();
               tmpVo2.contribution = pkg.readInt();
               model.playerList[i] = tmpVo2;
            }
            model.extendAvailableNum = pkg.readByte();
            model.endTime = pkg.readDate();
            model.callBossLevel = pkg.readInt();
            this._callBossLevel = model.callBossLevel;
         }
         this._bossState = model.bossState;
         this.refreshView(model);
      }
      
      private function refreshView(model:ConsortiaBossModel) : void
      {
         var tmpVo:ConsortiaBossDataVo = null;
         var list:Vector.<ConsortiaBossDataVo> = model.playerList;
         for(var i:int = 0; i < 11; i++)
         {
            tmpVo = list[i];
            if(Boolean(tmpVo))
            {
               this._cellList[i].info = tmpVo;
               this._cellList[i].visible = true;
            }
            else
            {
               this._cellList[i].visible = false;
            }
         }
         this.refreshEndTimeTxt(model);
         (this._extendBtn.backgound["mc"] as MovieClip).gotoAndStop(model.extendAvailableNum + 1);
         var isChairman:Boolean = ConsortiaDutyManager.GetRight(PlayerManager.Instance.Self.Right,ConsortiaDutyType._10_ChangeMan);
         if(model.bossState == 1)
         {
            (this._bossStateBtn.backgound["mc"] as MovieClip).gotoAndStop(2);
            if(model.extendAvailableNum <= 0)
            {
               this._extendBtn.enable = false;
            }
            else
            {
               this._extendBtn.enable = isChairman;
            }
            this._bossStateBtn.enable = true;
            this._endTimeTxt.visible = true;
            this._timerChairman.stop();
         }
         else
         {
            this._endTimeTxt.visible = false;
            this._extendBtn.enable = false;
            if(model.bossState == 0)
            {
               if(isChairman)
               {
                  (this._bossStateBtn.backgound["mc"] as MovieClip).gotoAndStop(4);
               }
               else
               {
                  (this._bossStateBtn.backgound["mc"] as MovieClip).gotoAndStop(1);
               }
               this._bossStateBtn.enable = isChairman;
            }
            else if(model.bossState == 2)
            {
               (this._bossStateBtn.backgound["mc"] as MovieClip).gotoAndStop(3);
               this._bossStateBtn.enable = false;
            }
         }
         if(Boolean(this._levelView))
         {
            if(model.bossState == 0)
            {
               this._levelView.mouseChildren = true;
               this._levelView.mouseEnabled = true;
            }
            else
            {
               this._levelView.mouseChildren = false;
               this._levelView.mouseEnabled = false;
               if(model.bossState == 1)
               {
                  this._levelView.selectedLevel = ConsortionModelControl.Instance.getCanCallBossMaxLevel(this._callBossLevel);
               }
            }
         }
      }
      
      private function refreshEndTimeTxt(model:ConsortiaBossModel) : void
      {
         var timeTxtStr:String = null;
         var endTimestamp:Number = model.endTime.getTime();
         var nowTimestamp:Number = TimeManager.Instance.Now().getTime();
         var differ:int = endTimestamp - nowTimestamp;
         differ = differ < 0 ? 0 : differ;
         var count:int = 0;
         if(differ / TimeManager.HOUR_TICKS > 1)
         {
            count = differ / TimeManager.HOUR_TICKS;
            timeTxtStr = count + LanguageMgr.GetTranslation("hour");
         }
         else if(differ / TimeManager.Minute_TICKS > 1)
         {
            count = differ / TimeManager.Minute_TICKS;
            timeTxtStr = count + LanguageMgr.GetTranslation("minute");
         }
         else
         {
            count = differ / TimeManager.Second_TICKS;
            timeTxtStr = count + LanguageMgr.GetTranslation("second");
         }
         this._endTimeTxt.text = timeTxtStr;
      }
      
      private function __startLoading(e:Event) : void
      {
         StateManager.getInGame_Step_6 = true;
         ChatManager.Instance.input.faceEnabled = false;
         LayerManager.Instance.clearnGameDynamic();
         StateManager.setState(StateType.ROOM_LOADING,GameManager.Instance.Current);
         StateManager.getInGame_Step_7 = true;
      }
      
      private function showHelpFrame(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         var helpBd:DisplayObject = ComponentFactory.Instance.creat("consortiaBoss.HelpPrompt");
         var helpPage:HelpFrame = ComponentFactory.Instance.creat("consortiaBoss.HelpFrame");
         helpPage.setView(helpBd);
         helpPage.titleText = LanguageMgr.GetTranslation("ddt.consortia.bossFrame.helpTitle");
         LayerManager.Instance.addToLayer(helpPage,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      private function __responseHandler(evt:FrameEvent) : void
      {
         if(evt.responseCode == FrameEvent.CLOSE_CLICK || evt.responseCode == FrameEvent.ESC_CLICK)
         {
            SoundManager.instance.play("008");
            this.dispose();
         }
      }
      
      private function removeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         if(Boolean(this._extendBtn))
         {
            this._extendBtn.removeEventListener(MouseEvent.CLICK,this.extendBossTime);
         }
         if(Boolean(this._bossStateBtn))
         {
            this._bossStateBtn.removeEventListener(MouseEvent.CLICK,this.callOrEnterBoss);
         }
         if(Boolean(this._helpBtn))
         {
            this._helpBtn.removeEventListener(MouseEvent.CLICK,this.showHelpFrame);
         }
         GameManager.Instance.removeEventListener(GameManager.START_LOAD,this.__startLoading);
         StateManager.getInGame_Step_8 = true;
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.CONSORTIA_BOSS_INFO,this.refreshData);
         if(Boolean(this._timerChairman))
         {
            this._timerChairman.stop();
            this._timerChairman.removeEventListener(TimerEvent.TIMER,this.timerHandler);
         }
         this._timerChairman = null;
         if(Boolean(this._timer))
         {
            this._timer.stop();
            this._timer.removeEventListener(TimerEvent.TIMER,this.timerHandler);
         }
         this._timer = null;
         if(Boolean(this._extendBtn))
         {
            (this._extendBtn.backgound as MovieClip).gotoAndStop(5);
         }
         if(Boolean(this._bossStateBtn))
         {
            (this._bossStateBtn.backgound as MovieClip).gotoAndStop(5);
         }
         super.dispose();
         this._bg = null;
         this._cellList = null;
         this._endTimeTxt = null;
         this._extendBtn = null;
         this._bossStateBtn = null;
         this._helpBtn = null;
         this._levelView = null;
      }
   }
}

