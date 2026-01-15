package worldBossHelper.view
{
   import baglocked.BaglockedManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.ServerConfigInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.ServerConfigManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.TimeManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import worldBossHelper.WorldBossHelperManager;
   import worldBossHelper.event.WorldBossHelperEvent;
   import worldboss.WorldBossManager;
   
   public class WorldBossHelperLeftView extends Sprite implements Disposeable
   {
      
      private var _infoBg:Bitmap;
      
      private var _scrollPanel:ScrollPanel;
      
      private var _vBox:VBox;
      
      private var _state:Boolean;
      
      private var _openStateTxt:FilterFrameText;
      
      private var _closeStateTxt:FilterFrameText;
      
      private var _openBtn:SimpleBitmapButton;
      
      private var _closeBtn:SimpleBitmapButton;
      
      private var _date1:Date;
      
      private var _date2:Date;
      
      private var _timer:Timer;
      
      private var _remainTime:int;
      
      private var _count:int;
      
      private var _countArr:Array;
      
      private var _titleTxtArr:Array;
      
      private var _allHonorTxt:FilterFrameText;
      
      private var _allMoneyTxt:FilterFrameText;
      
      private var _startTimer:Timer;
      
      private var _buyAddMoneyFun:Function;
      
      public function WorldBossHelperLeftView()
      {
         super();
         this._countArr = ["一","二","三"];
         this._titleTxtArr = new Array();
         this.initView();
         this.initEvent();
      }
      
      private function initEvent() : void
      {
         this._openBtn.addEventListener(MouseEvent.CLICK,this.__btnHandler);
         this._closeBtn.addEventListener(MouseEvent.CLICK,this.__btnHandler);
      }
      
      protected function __btnHandler(event:MouseEvent) : void
      {
         var alertAsk:BaseAlerFrame = null;
         SoundManager.instance.play("008");
         if(event.target == this._openBtn)
         {
            if(PlayerManager.Instance.Self.bagLocked)
            {
               BaglockedManager.Instance.show();
               return;
            }
         }
         if(!this._date1)
         {
            this._date1 = TimeManager.Instance.Now();
         }
         else
         {
            this._date2 = TimeManager.Instance.Now();
            if(this._date2.time - this._date1.time < 10 * 1000)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("worldboss.helper.click"));
               return;
            }
            this._date1 = this._date2;
         }
         if(event.target == this._openBtn)
         {
            alertAsk = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tips"),LanguageMgr.GetTranslation("worldboss.helper.isOpen"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,true,false,LayerManager.ALPHA_BLOCKGOUND);
            alertAsk.addEventListener(FrameEvent.RESPONSE,this.__alertOpenHelper);
         }
         else
         {
            if(!this._openBtn.visible)
            {
               this.fightFailDescription();
            }
            this.dispatchHelperEvent();
         }
      }
      
      public function dispatchHelperEvent() : void
      {
         var newEvent:WorldBossHelperEvent = new WorldBossHelperEvent(WorldBossHelperEvent.CHANGE_HELPER_STATE);
         newEvent.state = this._openBtn.visible;
         dispatchEvent(newEvent);
      }
      
      protected function __alertOpenHelper(event:FrameEvent) : void
      {
         var buffNum:int = 0;
         var money:int = 0;
         var moneyNumInfo:ServerConfigInfo = null;
         var alertFrame:BaseAlerFrame = null;
         var moneyAdd:int = 0;
         switch(event.responseCode)
         {
            case FrameEvent.SUBMIT_CLICK:
            case FrameEvent.ENTER_CLICK:
               if(Boolean(WorldBossManager.Instance.bossInfo))
               {
                  buffNum = WorldBossHelperManager.Instance.data.buffNum - WorldBossManager.Instance.bossInfo.myPlayerVO.buffLevel;
                  if(buffNum <= 0)
                  {
                     buffNum = 0;
                  }
               }
               else
               {
                  buffNum = WorldBossHelperManager.Instance.data.buffNum;
               }
               moneyNumInfo = ServerConfigManager.instance.findInfoByName("WorldBossAssistantFightMoney");
               if(Boolean(moneyNumInfo) && Boolean(moneyNumInfo.Value))
               {
                  money = int(moneyNumInfo.Value);
               }
               else
               {
                  money = 10;
               }
               if(PlayerManager.Instance.Self.Money < money)
               {
                  alertFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tank.room.RoomIIView2.notenoughmoney.title"),LanguageMgr.GetTranslation("tank.hotSpring.continuComfirm"),LanguageMgr.GetTranslation("ok"),"",false,true,true,LayerManager.ALPHA_BLOCKGOUND);
                  alertFrame.addEventListener(FrameEvent.RESPONSE,this._response2);
                  event.currentTarget.removeEventListener(FrameEvent.RESPONSE,this.__alertOpenHelper);
                  ObjectUtils.disposeObject(event.currentTarget);
                  return;
               }
               moneyAdd = this._buyAddMoneyFun != null ? this._buyAddMoneyFun() : 0;
               if(moneyAdd > 0 && PlayerManager.Instance.Self.Money < moneyAdd + buffNum * 30)
               {
                  alertFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tank.room.RoomIIView2.notenoughmoney.title"),LanguageMgr.GetTranslation("tank.room.RoomIIView2.notenoughmoney.content"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,true,true,LayerManager.ALPHA_BLOCKGOUND);
                  alertFrame.addEventListener(FrameEvent.RESPONSE,this._response);
                  event.currentTarget.removeEventListener(FrameEvent.RESPONSE,this.__alertOpenHelper);
                  ObjectUtils.disposeObject(event.currentTarget);
                  return;
               }
               this.dispatchHelperEvent();
               break;
         }
         event.currentTarget.removeEventListener(FrameEvent.RESPONSE,this.__alertOpenHelper);
         ObjectUtils.disposeObject(event.currentTarget);
      }
      
      public function set buyAddMoney(fun:Function) : void
      {
         this._buyAddMoneyFun = fun;
      }
      
      private function _response(evt:FrameEvent) : void
      {
         (evt.currentTarget as BaseAlerFrame).removeEventListener(FrameEvent.RESPONSE,this._response);
         if(evt.responseCode == FrameEvent.SUBMIT_CLICK || evt.responseCode == FrameEvent.ENTER_CLICK)
         {
            LeavePageManager.leaveToFillPath();
         }
         evt.currentTarget.removeEventListener(FrameEvent.RESPONSE,this._response);
         ObjectUtils.disposeObject(evt.currentTarget);
      }
      
      private function _response2(evt:FrameEvent) : void
      {
         evt.currentTarget.removeEventListener(FrameEvent.RESPONSE,this._response2);
         ObjectUtils.disposeObject(evt.currentTarget);
      }
      
      private function fightFailDescription() : void
      {
         var child:FilterFrameText = null;
         this.stopAndDisposeTimer();
         if(this._vBox.numChildren > 0)
         {
            child = this._vBox.getChildAt(this._vBox.numChildren - 1) as FilterFrameText;
            child.text = LanguageMgr.GetTranslation("worldboss.helper.fightFail",WorldBossHelperManager.Instance.num);
         }
      }
      
      private function stopAndDisposeTimer() : void
      {
         if(Boolean(this._timer))
         {
            this._timer.stop();
            this._timer.removeEventListener(TimerEvent.TIMER,this.__timerHandler);
            this._timer = null;
         }
      }
      
      public function get state() : Boolean
      {
         return this._state;
      }
      
      public function set state(value:Boolean) : void
      {
         this._state = value;
      }
      
      private function initView() : void
      {
         this._infoBg = ComponentFactory.Instance.creat("worldBossHelper.info");
         addChild(this._infoBg);
         this._allHonorTxt = ComponentFactory.Instance.creatComponentByStylename("worldBossHelper.view.allHonorAndMoneyText");
         addChild(this._allHonorTxt);
         this._allHonorTxt.text = "0";
         PositionUtils.setPos(this._allHonorTxt,"worldBossHelper.view.allHonorPos");
         this._allMoneyTxt = ComponentFactory.Instance.creatComponentByStylename("worldBossHelper.view.allHonorAndMoneyText");
         addChild(this._allMoneyTxt);
         this._allMoneyTxt.text = "0";
         PositionUtils.setPos(this._allMoneyTxt,"worldBossHelper.view.allMoneyPos");
         this._vBox = ComponentFactory.Instance.creatComponentByStylename("worldBossHelper.Vbox");
         this._scrollPanel = ComponentFactory.Instance.creatComponentByStylename("worldBossHelper.scrollPanel");
         this._scrollPanel.setView(this._vBox);
         addChild(this._scrollPanel);
         this._openStateTxt = ComponentFactory.Instance.creatComponentByStylename("worldBossHelper.view.helperStateText");
         this._openStateTxt.text = LanguageMgr.GetTranslation("worldbosshelper.open");
         addChild(this._openStateTxt);
         this._closeStateTxt = ComponentFactory.Instance.creatComponentByStylename("worldBossHelper.view.helperStateText");
         this._closeStateTxt.text = LanguageMgr.GetTranslation("worldbosshelper.close");
         addChild(this._closeStateTxt);
         this._openBtn = ComponentFactory.Instance.creatComponentByStylename("worldBossHelper.view.openBtn");
         this._openBtn.tipData = LanguageMgr.GetTranslation("worldboss.helper.openTip");
         addChild(this._openBtn);
         this._closeBtn = ComponentFactory.Instance.creatComponentByStylename("worldBossHelper.view.closeBtn");
         addChild(this._closeBtn);
      }
      
      public function changeState() : void
      {
         this._state = WorldBossHelperManager.Instance.data.isOpen;
         if(this._state)
         {
            this._closeStateTxt.visible = this._openBtn.visible = false;
            this._openStateTxt.visible = this._closeBtn.visible = true;
            if(Boolean(WorldBossManager.Instance.bossInfo) && !WorldBossManager.Instance.bossInfo.fightOver)
            {
               this.startFight();
            }
         }
         else
         {
            WorldBossHelperManager.Instance.isFighting = false;
            this._closeStateTxt.visible = this._openBtn.visible = true;
            this._openStateTxt.visible = this._closeBtn.visible = false;
         }
      }
      
      private function checkTrueStart() : Boolean
      {
         if(!WorldBossHelperManager.Instance.data.isOpen)
         {
            return false;
         }
         if(WorldBossManager.Instance.bossInfo && !WorldBossManager.Instance.bossInfo.fightOver && WorldBossManager.Instance.beforeStartTime <= 0)
         {
            return true;
         }
         if(!this._startTimer)
         {
            this._startTimer = new Timer(1000);
            this._startTimer.addEventListener(TimerEvent.TIMER,this.startTimerHandler,false,0,true);
         }
         this._startTimer.start();
         return false;
      }
      
      private function startTimerHandler(event:TimerEvent) : void
      {
         if(WorldBossManager.Instance.bossInfo && !WorldBossManager.Instance.bossInfo.fightOver && WorldBossManager.Instance.beforeStartTime <= 0)
         {
            this.startFight();
            this.disposeStartTimer();
         }
      }
      
      private function disposeStartTimer() : void
      {
         if(Boolean(this._startTimer))
         {
            this._startTimer.removeEventListener(TimerEvent.TIMER,this.startTimerHandler);
            this._startTimer.stop();
            this._startTimer = null;
         }
      }
      
      public function startFight() : void
      {
         if(!this.checkTrueStart())
         {
            return;
         }
         WorldBossHelperManager.Instance.isFighting = true;
         this.addDescription(false,WorldBossHelperManager.Instance.num,null,0);
         if(WorldBossHelperManager.Instance.data.type == 0)
         {
            if(Boolean(WorldBossHelperManager.Instance.WorldBossAssistantTimeInfo1))
            {
               this._remainTime = int(WorldBossHelperManager.Instance.WorldBossAssistantTimeInfo1.Value);
            }
            else
            {
               this._remainTime = 90;
            }
         }
         else if(WorldBossHelperManager.Instance.data.type == 1)
         {
            if(Boolean(WorldBossHelperManager.Instance.WorldBossAssistantTimeInfo2))
            {
               this._remainTime = int(WorldBossHelperManager.Instance.WorldBossAssistantTimeInfo2.Value);
            }
            else
            {
               this._remainTime = 70;
            }
         }
         else if(WorldBossHelperManager.Instance.data.type == 2)
         {
            if(Boolean(WorldBossHelperManager.Instance.WorldBossAssistantTimeInfo3))
            {
               this._remainTime = int(WorldBossHelperManager.Instance.WorldBossAssistantTimeInfo3.Value);
            }
            else
            {
               this._remainTime = 65;
            }
         }
         this._timer = new Timer(1000);
         this._timer.addEventListener(TimerEvent.TIMER,this.__timerHandler);
         this._timer.start();
      }
      
      protected function __timerHandler(event:TimerEvent) : void
      {
         if(this._count != this._remainTime)
         {
            ++this._count;
         }
         if(this._count == this._remainTime)
         {
            if(!WorldBossHelperManager.Instance.receieveData)
            {
               WorldBossHelperManager.Instance.data.requestType = 3;
               SocketManager.Instance.out.openOrCloseWorldBossHelper(WorldBossHelperManager.Instance.data);
            }
            else
            {
               WorldBossHelperManager.Instance.receieveData = false;
               this._count = 0;
               this.addDescription(false,WorldBossHelperManager.Instance.num,null,0);
            }
         }
      }
      
      public function addDescription(isFightOver:Boolean, num:int, hurtArr:Array, honor:int) : void
      {
         var honorTxt:FilterFrameText = null;
         var i:int = 0;
         var fightTitleTxt:FilterFrameText = null;
         var descriptionTxt:FilterFrameText = null;
         var fightTitleDescriptionTxt:FilterFrameText = null;
         if(WorldBossHelperManager.Instance.isFighting)
         {
            if(isFightOver)
            {
               this._allHonorTxt.text = "" + WorldBossHelperManager.Instance.allHonor;
               this._allMoneyTxt.text = "" + WorldBossHelperManager.Instance.allMoney;
               honorTxt = ComponentFactory.Instance.creatComponentByStylename("worldBossHelper.view.infoText");
               if(hurtArr.length > 0)
               {
                  fightTitleTxt = this._titleTxtArr[num - 1];
                  fightTitleTxt.text = LanguageMgr.GetTranslation("worldboss.helper.fightTitleTxt",num);
               }
               for(i = 0; i < hurtArr.length; i++)
               {
                  descriptionTxt = ComponentFactory.Instance.creatComponentByStylename("worldBossHelper.view.infoText");
                  descriptionTxt.text = LanguageMgr.GetTranslation("worldboss.helper.fightHurt",this._countArr[i],hurtArr[i]);
                  descriptionTxt.x = fightTitleTxt.x + 40;
                  this._vBox.addChild(descriptionTxt);
               }
               honorTxt.text = LanguageMgr.GetTranslation("worldboss.helper.fightHonor",honor);
               honorTxt.x = fightTitleTxt.x + 40;
               this._vBox.addChild(honorTxt);
               WorldBossHelperManager.Instance.receieveData = true;
            }
            else
            {
               fightTitleDescriptionTxt = ComponentFactory.Instance.creatComponentByStylename("worldBossHelper.view.titleInfoText");
               fightTitleDescriptionTxt.text = LanguageMgr.GetTranslation("worldboss.helper.fighting",num);
               this._vBox.addChild(fightTitleDescriptionTxt);
               this._titleTxtArr.push(fightTitleDescriptionTxt);
            }
         }
         else
         {
            this.fightFailDescription();
         }
         this._scrollPanel.invalidateViewport(true);
      }
      
      private function removeEvent() : void
      {
         this._openBtn.removeEventListener(MouseEvent.CLICK,this.__btnHandler);
         this._closeBtn.removeEventListener(MouseEvent.CLICK,this.__btnHandler);
      }
      
      public function dispose() : void
      {
         this.disposeStartTimer();
         this.stopAndDisposeTimer();
         this.removeEvent();
         this._infoBg.bitmapData.dispose();
         this._infoBg = null;
         ObjectUtils.disposeObject(this._scrollPanel);
         this._scrollPanel = null;
         ObjectUtils.disposeObject(this._allHonorTxt);
         this._allHonorTxt = null;
         ObjectUtils.disposeObject(this._allMoneyTxt);
         this._allMoneyTxt = null;
         ObjectUtils.disposeObject(this._vBox);
         this._vBox = null;
         ObjectUtils.disposeObject(this._openStateTxt);
         this._openStateTxt = null;
         ObjectUtils.disposeObject(this._closeStateTxt);
         this._closeStateTxt = null;
         ObjectUtils.disposeObject(this._openBtn);
         this._openBtn = null;
         ObjectUtils.disposeObject(this._closeBtn);
         this._closeBtn = null;
         for(var i:int = 0; i < this._titleTxtArr.length; i++)
         {
            if(Boolean(this._titleTxtArr[i]))
            {
               ObjectUtils.disposeObject(this._titleTxtArr[i]);
               this._titleTxtArr[i] = null;
            }
         }
         this._titleTxtArr = null;
         this._date1 = null;
         this._date2 = null;
         this._countArr = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

