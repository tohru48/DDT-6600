package consortion.view.selfConsortia.consortiaTask
{
   import baglocked.BaglockedManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import consortion.ConsortionModelControl;
   import ddt.manager.ChatManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.TimeManager;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class ConsortiaTaskView extends Sprite implements Disposeable
   {
      
      public static var RESET_MONEY:int = 500;
      
      public static var SUBMIT_RICHES:int = 5000;
      
      private var _myView:ConsortiaMyTaskView;
      
      private var _timeBG:Bitmap;
      
      private var _panel:ScrollPanel;
      
      private var _lastTimeTxt:FilterFrameText;
      
      private var _noTask:FilterFrameText;
      
      private var _timer:Timer;
      
      private var diff:Number;
      
      public function ConsortiaTaskView()
      {
         super();
         this.initView();
         this.initEvents();
      }
      
      private function initView() : void
      {
         this._timeBG = ComponentFactory.Instance.creatBitmap("asset.conortionTask.timeBG");
         this._myView = ComponentFactory.Instance.creatCustomObject("ConsortiaMyTaskView");
         this._panel = ComponentFactory.Instance.creatComponentByStylename("consortion.task.scrollpanel");
         this._lastTimeTxt = ComponentFactory.Instance.creatComponentByStylename("consortion.task.lastTimeTxt");
         this._noTask = ComponentFactory.Instance.creatComponentByStylename("conortionTask.notaskTxt");
         this._noTask.text = LanguageMgr.GetTranslation("conortionTask.notaskText");
         addChild(this._timeBG);
         addChild(this._panel);
         addChild(this._lastTimeTxt);
         addChild(this._noTask);
         this._panel.setView(this._myView);
         this._panel.invalidateViewport();
         this._noTask.visible = false;
         this._timeBG.visible = false;
         this._panel.visible = false;
         this._lastTimeTxt.visible = false;
         SocketManager.Instance.out.sendReleaseConsortiaTask(ConsortiaTaskModel.GET_TASKINFO);
      }
      
      private function initEvents() : void
      {
         ConsortionModelControl.Instance.TaskModel.addEventListener(ConsortiaTaskEvent.GETCONSORTIATASKINFO,this.__getTaskInfo);
         ConsortionModelControl.Instance.TaskModel.addEventListener(ConsortiaTaskEvent.DELAY_TASK_TIME,this.__updateEndTimeInfo);
      }
      
      private function __resetClick(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         if(ConsortionModelControl.Instance.TaskModel.taskInfo == null)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("consortia.task.stopTable"));
         }
         var alert:BaseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("consortia.task.resetTable"),LanguageMgr.GetTranslation("consortia.task.resetContent"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,true,true,LayerManager.ALPHA_BLOCKGOUND);
         alert.moveEnable = false;
         alert.addEventListener(FrameEvent.RESPONSE,this._responseI);
      }
      
      private function _responseI(event:FrameEvent) : void
      {
         var alert:BaseAlerFrame = null;
         (event.currentTarget as BaseAlerFrame).removeEventListener(FrameEvent.RESPONSE,this._responseI);
         if(event.responseCode == FrameEvent.ENTER_CLICK || event.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            if(ConsortionModelControl.Instance.TaskModel.taskInfo == null)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("consortia.task.stopTable"));
               ChatManager.Instance.sysChatYellow(LanguageMgr.GetTranslation("consortia.task.stopTable"));
            }
            else if(PlayerManager.Instance.Self.Money < RESET_MONEY)
            {
               alert = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("tank.consortia.consortiashop.ConsortiaShopItem.Money"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"));
               alert.addEventListener(FrameEvent.RESPONSE,this.__onNoMoneyResponse);
            }
            else
            {
               SocketManager.Instance.out.sendReleaseConsortiaTask(ConsortiaTaskModel.RESET_TASK);
               SocketManager.Instance.out.sendReleaseConsortiaTask(ConsortiaTaskModel.SUMBIT_TASK);
            }
         }
         ObjectUtils.disposeObject(event.currentTarget as BaseAlerFrame);
      }
      
      private function __onNoMoneyResponse(event:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         var alert:BaseAlerFrame = event.currentTarget as BaseAlerFrame;
         alert.removeEventListener(FrameEvent.RESPONSE,this.__onNoMoneyResponse);
         alert.disposeChildren = true;
         alert.dispose();
         alert = null;
         if(event.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            LeavePageManager.leaveToFillPath();
         }
      }
      
      private function removeEvents() : void
      {
         if(Boolean(this._timer))
         {
            this._timer.stop();
            this._timer.removeEventListener(TimerEvent.TIMER,this.__timerOne);
         }
         ConsortionModelControl.Instance.TaskModel.removeEventListener(ConsortiaTaskEvent.GETCONSORTIATASKINFO,this.__getTaskInfo);
         ConsortionModelControl.Instance.TaskModel.removeEventListener(ConsortiaTaskEvent.DELAY_TASK_TIME,this.__updateEndTimeInfo);
      }
      
      private function __updateEndTimeInfo(e:ConsortiaTaskEvent) : void
      {
         this.diff += e.value * 60;
      }
      
      private function __getTaskInfo(e:ConsortiaTaskEvent) : void
      {
         if(e.value == ConsortiaTaskModel.GET_TASKINFO || e.value == ConsortiaTaskModel.SUMBIT_TASK || e.value == ConsortiaTaskModel.UPDATE_TASKINFO || e.value == ConsortiaTaskModel.SUCCESS_FAIL)
         {
            if(ConsortionModelControl.Instance.TaskModel.taskInfo == null)
            {
               this.__noTask();
            }
            else
            {
               this.__showTask();
            }
         }
      }
      
      private function __showTask() : void
      {
         var right:int = PlayerManager.Instance.Self.Right;
         this._noTask.visible = false;
         this._timeBG.visible = true;
         this._panel.visible = true;
         this._lastTimeTxt.visible = true;
         this._myView.taskInfo = ConsortionModelControl.Instance.TaskModel.taskInfo;
         this.__startTimer();
      }
      
      private function __noTask() : void
      {
         this._noTask.visible = true;
         this._timeBG.visible = false;
         this._panel.visible = false;
         this._lastTimeTxt.visible = false;
         if(Boolean(this._timer))
         {
            this._timer.stop();
            this._timer.removeEventListener(TimerEvent.TIMER,this.__timerOne);
            this._timer = null;
         }
      }
      
      private function __startTimer() : void
      {
         var bg:Date = ConsortionModelControl.Instance.TaskModel.taskInfo.beginTime;
         if(!bg)
         {
            return;
         }
         this.diff = ConsortionModelControl.Instance.TaskModel.taskInfo.time * 60 - int(TimeManager.Instance.TotalSecondToNow(bg)) + 60;
         if(Boolean(this._timer))
         {
            return;
         }
         this._timer = new Timer(1000);
         this._timer.addEventListener(TimerEvent.TIMER,this.__timerOne);
         this._timer.start();
      }
      
      private function __timerOne(e:TimerEvent) : void
      {
         --this.diff;
         if(this.diff <= 0)
         {
            this._timer.stop();
            this._timer.removeEventListener(TimerEvent.TIMER,this.__timerOne);
            this._lastTimeTxt.text = "";
            return;
         }
         this._lastTimeTxt.text = LanguageMgr.GetTranslation("consortia.task.lasttime",int(this.diff / 60),int(this.diff % 60));
      }
      
      public function dispose() : void
      {
         this.removeEvents();
         if(Boolean(this._myView))
         {
            ObjectUtils.disposeObject(this._myView);
         }
         this._myView = null;
         if(Boolean(this._timeBG))
         {
            ObjectUtils.disposeObject(this._timeBG);
         }
         this._timeBG = null;
         if(Boolean(this._panel))
         {
            ObjectUtils.disposeObject(this._panel);
         }
         this._panel = null;
         if(Boolean(this._lastTimeTxt))
         {
            ObjectUtils.disposeObject(this._lastTimeTxt);
         }
         this._lastTimeTxt = null;
         if(Boolean(this._noTask))
         {
            ObjectUtils.disposeObject(this._noTask);
         }
         this._noTask = null;
         if(Boolean(this._timer))
         {
            this._timer.stop();
            this._timer = null;
         }
         ObjectUtils.disposeAllChildren(this);
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

