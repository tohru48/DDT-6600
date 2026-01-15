package labyrinth.view
{
   import baglocked.BaglockedManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.UICreatShortcut;
   import com.pickgliss.ui.controls.ListPanel;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.text.GradientText;
   import com.pickgliss.ui.vo.AlertInfo;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.player.PlayerState;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.ServerConfigManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.text.TextFormat;
   import flash.utils.Timer;
   import kingBless.KingBlessManager;
   import labyrinth.LabyrinthManager;
   import labyrinth.data.CleanOutInfo;
   import road7th.data.DictionaryEvent;
   
   public class CleanOutFrame extends BaseAlerFrame
   {
      
      private var _bg:ScaleBitmapImage;
      
      private var _rightBG:Bitmap;
      
      private var _leftBG:Bitmap;
      
      private var _startCleanOutBtn:SimpleBitmapButton;
      
      private var _speededUpBtn:SimpleBitmapButton;
      
      private var _cancelBtn:SimpleBitmapButton;
      
      private var _rightLabel:GradientText;
      
      private var _rightLabelI:GradientText;
      
      private var _rightLabelII:GradientText;
      
      private var _rightValue:FilterFrameText;
      
      private var _rightValueI:FilterFrameText;
      
      private var _rightValueII:FilterFrameText;
      
      private var _tipContainer:Sprite;
      
      private var _tipTitle:FilterFrameText;
      
      private var _tipContent:FilterFrameText;
      
      private var _list:ListPanel;
      
      private var _textFormat:TextFormat;
      
      private var _timer:Timer;
      
      private var _remainTime:int;
      
      private var _currentRemainTime:int;
      
      private var _chatBtn:SimpleBitmapButton;
      
      private var _vipIcon:Bitmap;
      
      private var _freeAccTips:FilterFrameText;
      
      private var _currentFloor:int = 0;
      
      private var _btnState:int;
      
      public function CleanOutFrame()
      {
         super();
      }
      
      override protected function init() : void
      {
         super.init();
         var alerInfo:AlertInfo = new AlertInfo(LanguageMgr.GetTranslation("ddt.labyrinth.CleanOutFrame.title"));
         alerInfo.moveEnable = false;
         info = alerInfo;
         this._bg = ComponentFactory.Instance.creatComponentByStylename("ddt.view.CleanOutFrame.ScaleBG");
         addToContent(this._bg);
         this._rightBG = ComponentFactory.Instance.creatBitmap("ddt.labyrinth.CleanOutFrame.rightBG");
         addToContent(this._rightBG);
         this._leftBG = ComponentFactory.Instance.creatBitmap("ddt.labyrinth.CleanOutFrame.leftBG");
         addToContent(this._leftBG);
         this._startCleanOutBtn = ComponentFactory.Instance.creatComponentByStylename("ddt.view.CleanOutFrame.startCleanOutButton");
         addToContent(this._startCleanOutBtn);
         this._speededUpBtn = ComponentFactory.Instance.creatComponentByStylename("ddt.view.CleanOutFrame.speededUpButton");
         addToContent(this._speededUpBtn);
         this._cancelBtn = ComponentFactory.Instance.creatComponentByStylename("ddt.view.CleanOutFrame.cancelButton");
         addToContent(this._cancelBtn);
         this._rightLabel = ComponentFactory.Instance.creatComponentByStylename("ddt.labyrinth.CleanOutFrame.rightLabel");
         addToContent(this._rightLabel);
         this._rightLabelI = ComponentFactory.Instance.creatComponentByStylename("ddt.labyrinth.CleanOutFrame.rightLabelI");
         addToContent(this._rightLabelI);
         this._rightLabelII = ComponentFactory.Instance.creatComponentByStylename("ddt.labyrinth.CleanOutFrame.rightLabelII");
         addToContent(this._rightLabelII);
         this._rightValue = ComponentFactory.Instance.creatComponentByStylename("ddt.labyrinth.CleanOutFrame.rightValue");
         addToContent(this._rightValue);
         this._rightValueI = ComponentFactory.Instance.creatComponentByStylename("ddt.labyrinth.CleanOutFrame.rightValueI");
         addToContent(this._rightValueI);
         this._rightValueII = ComponentFactory.Instance.creatComponentByStylename("ddt.labyrinth.CleanOutFrame.rightValueII");
         addToContent(this._rightValueII);
         this._chatBtn = ComponentFactory.Instance.creatComponentByStylename("ddt.labyrinth.chatButton");
         this._chatBtn.tipData = LanguageMgr.GetTranslation("tank.game.ToolStripView.chat");
         addToContent(this._chatBtn);
         this._vipIcon = ComponentFactory.Instance.creat("asset.seniorVipIcon.small_9");
         PositionUtils.setPos(this._vipIcon,"ddt.labyrinth.vipIconPos");
         addToContent(this._vipIcon);
         this._freeAccTips = ComponentFactory.Instance.creatComponentByStylename("ddt.labyrinth.freeAccTips");
         addToContent(this._freeAccTips);
         this._freeAccTips.text = LanguageMgr.GetTranslation("ddt.labyrinth.CleanOutFrame.freeAccTips");
         this._tipContainer = ComponentFactory.Instance.creatCustomObject("labyrinth.CleanOutFrame.tipContainer");
         addToContent(this._tipContainer);
         this._tipTitle = UICreatShortcut.creatTextAndAdd("ddt.labyrinth.CleanOutFrame.tipTitleText",LanguageMgr.GetTranslation("ddt.labyrinth.CleanOutFrame.leftTitle"),this._tipContainer);
         this._tipContent = UICreatShortcut.creatTextAndAdd("ddt.labyrinth.CleanOutFrame.tipContentText",LanguageMgr.GetTranslation("ddt.labyrinth.CleanOutFrame.leftTip"),this._tipContainer);
         this._textFormat = ComponentFactory.Instance.model.getSet("ddt.labyrinth.CleanOutFrame.rightValueIITF");
         this._currentFloor = LabyrinthManager.Instance.model.currentFloor;
         this._list = ComponentFactory.Instance.creatComponentByStylename("ddt.labyrinth.CleanOutFrame.List");
         addToContent(this._list);
         this.btnState = 0;
         this.initEvent();
         PlayerManager.Instance.Self.playerState = new PlayerState(PlayerState.CLEAN_OUT,PlayerState.AUTO);
         SocketManager.Instance.out.sendFriendState(PlayerManager.Instance.Self.playerState.StateID);
      }
      
      private function initEvent() : void
      {
         this._startCleanOutBtn.addEventListener(MouseEvent.CLICK,this.__startCleanOut);
         this._speededUpBtn.addEventListener(MouseEvent.CLICK,this.__speededUp);
         this._cancelBtn.addEventListener(MouseEvent.CLICK,this.__cancel);
         this._chatBtn.addEventListener(MouseEvent.CLICK,this.__chatClick);
         LabyrinthManager.Instance.model.cleanOutInfos.addEventListener(DictionaryEvent.ADD,this.__addInfo);
         LabyrinthManager.Instance.addEventListener(LabyrinthManager.UPDATE_REMAIN_TIME,this.__updateRemainTime);
         LabyrinthManager.Instance.addEventListener(LabyrinthManager.UPDATE_INFO,this.__updateInfo);
      }
      
      protected function __chatClick(event:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         LabyrinthManager.Instance.chat();
      }
      
      protected function __updateInfo(event:Event) : void
      {
         this.updateTextVlaue();
         this.updateButton();
      }
      
      protected function __updateRemainTime(event:Event) : void
      {
         if(Boolean(this._timer))
         {
            this._timer.stop();
            this._timer.removeEventListener(TimerEvent.TIMER,this.__updateTimer);
            this._timer = null;
         }
         this._remainTime = LabyrinthManager.Instance.model.remainTime;
         this._currentRemainTime = LabyrinthManager.Instance.model.currentRemainTime;
         if(this._remainTime > 0)
         {
            this._timer = new Timer(1000,this._remainTime);
            this._timer.addEventListener(TimerEvent.TIMER,this.__updateTimer);
            this._timer.start();
         }
      }
      
      private function removeEvent() : void
      {
         this._startCleanOutBtn.removeEventListener(MouseEvent.CLICK,this.__startCleanOut);
         this._speededUpBtn.removeEventListener(MouseEvent.CLICK,this.__speededUp);
         this._cancelBtn.removeEventListener(MouseEvent.CLICK,this.__cancel);
         LabyrinthManager.Instance.model.cleanOutInfos.removeEventListener(DictionaryEvent.ADD,this.__addInfo);
         LabyrinthManager.Instance.removeEventListener(LabyrinthManager.UPDATE_REMAIN_TIME,this.__updateRemainTime);
         LabyrinthManager.Instance.removeEventListener(LabyrinthManager.UPDATE_INFO,this.__updateInfo);
      }
      
      private function updateRightValueI() : void
      {
         var remainTime:int = 0;
         if(this._btnState == 0 || this._btnState == 2)
         {
            remainTime = LabyrinthManager.Instance.model.cleanOutAllTime;
         }
         else
         {
            remainTime = this._remainTime;
         }
         var minute:String = remainTime / 60 >= 10 ? String(Math.floor(remainTime / 60)) : "0" + String(Math.floor(remainTime / 60));
         var second:String = remainTime % 60 >= 10 ? String(Math.floor(remainTime % 60)) : "0" + String(Math.floor(remainTime % 60));
         this._rightValueI.text = "00 : " + minute + " : " + second;
      }
      
      protected function __updateTimer(event:TimerEvent) : void
      {
         if(this._remainTime != 0)
         {
            --this._remainTime;
         }
         if(this._currentRemainTime != 0)
         {
            --this._currentRemainTime;
         }
         this.updateRightValueI();
         if(this._currentRemainTime == 0)
         {
            SocketManager.Instance.out.labyrinthCleanOutTimerComplete();
         }
      }
      
      protected function __addInfo(event:DictionaryEvent) : void
      {
         this._list.vectorListModel.removeAt(this._list.vectorListModel.elements.length - 1);
         this._list.vectorListModel.append(event.data as CleanOutInfo);
         ++this._currentFloor;
         if(this._currentFloor != LabyrinthManager.Instance.model.myProgress + 1)
         {
            this._list.vectorListModel.append(null);
         }
      }
      
      protected function __cancel(event:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         this.btnState = 0;
         SocketManager.Instance.out.labyrinthStopCleanOut();
         LabyrinthManager.Instance.model.cleanOutInfos.clear();
         this._list.vectorListModel.clear();
         if(Boolean(this._timer))
         {
            this._timer.stop();
            this._timer.removeEventListener(TimerEvent.TIMER,this.__updateTimer);
            this._timer = null;
         }
         onResponse(FrameEvent.CLOSE_CLICK);
      }
      
      protected function __speededUp(event:MouseEvent) : void
      {
         var msg:String = null;
         var money:int = 0;
         SoundManager.instance.playButtonSound();
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         var timeDeityCount:int = KingBlessManager.instance.getOneBuffData(KingBlessManager.TIME_DEITY);
         if(timeDeityCount > 0)
         {
            msg = LanguageMgr.GetTranslation("ddt.labyrinth.CleanOutFrame.warning2");
         }
         else
         {
            money = Math.ceil(LabyrinthManager.Instance.model.remainTime / 60) * ServerConfigManager.instance.WarriorFamRaidPricePerMin;
            if(PlayerManager.Instance.Self.IsVIP && PlayerManager.Instance.Self.VIPLevel >= 6)
            {
               money = Math.ceil(money / 2);
               msg = LanguageMgr.GetTranslation("ddt.labyrinth.CleanOutFrame.warning",money);
            }
            else
            {
               msg = LanguageMgr.GetTranslation("ddt.labyrinth.CleanOutFrame.warning",money);
            }
         }
         var confirmFrame:BaseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),msg,LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),true,true,true,LayerManager.BLCAK_BLOCKGOUND,null,"labyrinth.cleanOutConfirmView",30,true,AlertManager.SELECTBTN);
         confirmFrame.moveEnable = false;
         confirmFrame.addEventListener(FrameEvent.RESPONSE,this.__onFrameEvent);
      }
      
      protected function __onFrameEvent(event:FrameEvent) : void
      {
         var timeDeityCount:int = 0;
         SoundManager.instance.playButtonSound();
         var alert:BaseAlerFrame = BaseAlerFrame(event.currentTarget);
         alert.removeEventListener(FrameEvent.RESPONSE,this.__onFrameEvent);
         ObjectUtils.disposeObject(event.target);
         var money:int = Math.ceil(LabyrinthManager.Instance.model.remainTime / 60) * ServerConfigManager.instance.WarriorFamRaidPricePerMin;
         if(PlayerManager.Instance.Self.IsVIP && PlayerManager.Instance.Self.VIPLevel >= 6)
         {
            money = Math.ceil(money / 2);
         }
         if(event.responseCode == FrameEvent.ENTER_CLICK || event.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            timeDeityCount = KingBlessManager.instance.getOneBuffData(KingBlessManager.TIME_DEITY);
            alert.isBand = false;
            if(!(PlayerManager.Instance.Self.Money >= money || timeDeityCount > 0))
            {
               LeavePageManager.showFillFrame();
               alert = null;
               return;
            }
            SocketManager.Instance.out.labyrinthSpeededUpCleanOut(alert.isBand);
            alert = null;
            this.btnState = 2;
            this.reset();
         }
      }
      
      private function reset() : void
      {
         if(Boolean(this._timer))
         {
            this._timer.stop();
            this._timer.removeEventListener(TimerEvent.TIMER,this.__updateTimer);
            this._timer = null;
         }
         this._rightValueI.text = "00 : 00 : 00";
      }
      
      protected function __startCleanOut(event:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         if(PlayerManager.Instance.Self.BandMoney < LabyrinthManager.Instance.model.cleanOutGold)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("shop.view.giftLack"));
            return;
         }
         this.btnState = 1;
         this._list.vectorListModel.append(null);
         SocketManager.Instance.out.labyrinthCleanOut();
      }
      
      private function set btnState(value:int) : void
      {
         switch(value)
         {
            case 0:
               this._btnState = 0;
               this._startCleanOutBtn.visible = true;
               this._tipContainer.visible = true;
               this._speededUpBtn.visible = false;
               this._cancelBtn.visible = false;
               this._list.visible = false;
               break;
            case 1:
               this._btnState = 1;
               this._startCleanOutBtn.visible = false;
               this._tipContainer.visible = false;
               this._speededUpBtn.visible = true;
               this._cancelBtn.visible = true;
               this._list.visible = true;
               break;
            case 2:
               this._btnState = 2;
               this._startCleanOutBtn.visible = false;
               this._tipContainer.visible = false;
               this._speededUpBtn.visible = true;
               this._cancelBtn.visible = true;
               this._list.visible = true;
         }
         this.updateTextVlaue();
      }
      
      private function updateTextVlaue() : void
      {
         var myProgress:int = LabyrinthManager.Instance.model.myProgress;
         var currentFloor:int = LabyrinthManager.Instance.model.currentFloor - 1;
         var cleanOutGold:int = LabyrinthManager.Instance.model.cleanOutGold;
         this._remainTime = LabyrinthManager.Instance.model.remainTime;
         if(this._btnState == 0 || this._btnState == 2)
         {
            this._rightLabel.text = LanguageMgr.GetTranslation("ddt.labyrinth.CleanOutFrame.rightLabelText");
            this._rightLabelI.text = LanguageMgr.GetTranslation("ddt.labyrinth.CleanOutFrame.rightLabelTextI");
            this._rightLabelII.text = LanguageMgr.GetTranslation("ddt.labyrinth.CleanOutFrame.rightLabelTextII");
            this._rightValue.text = LanguageMgr.GetTranslation("ddt.labyrinth.CleanOutFrame.rightValueTextII",myProgress);
            this._rightValueII.text = String(cleanOutGold);
            if(this._btnState == 2)
            {
               this._rightValue.text = LanguageMgr.GetTranslation("ddt.labyrinth.CleanOutFrame.rightValueText",myProgress);
               this._rightLabelII.text = LanguageMgr.GetTranslation("ddt.labyrinth.CleanOutFrame.rightLabelTextIIII");
               this._rightValueII.text = LabyrinthManager.Instance.model.accumulateExp.toString();
            }
         }
         else
         {
            this._rightLabel.text = LanguageMgr.GetTranslation("ddt.labyrinth.CleanOutFrame.rightLabelText");
            this._rightLabelI.text = LanguageMgr.GetTranslation("ddt.labyrinth.CleanOutFrame.rightLabelTextIII");
            this._rightLabelII.text = LanguageMgr.GetTranslation("ddt.labyrinth.CleanOutFrame.rightLabelTextIIII");
            this._rightValue.text = LanguageMgr.GetTranslation("ddt.labyrinth.CleanOutFrame.rightValueText",currentFloor);
            this._rightValueII.text = LabyrinthManager.Instance.model.accumulateExp.toString();
         }
         this.updateRightValueI();
         this.updateButton();
      }
      
      private function updateButton() : void
      {
         var value:Boolean = LabyrinthManager.Instance.model.currentFloor == LabyrinthManager.Instance.model.myProgress + 1;
         if(!LabyrinthManager.Instance.model.completeChallenge || value)
         {
            this._startCleanOutBtn.enable = false;
            this._speededUpBtn.enable = false;
            this.reset();
         }
      }
      
      public function continueCleanOut() : void
      {
         this.btnState = 1;
         this._list.vectorListModel.append(null);
         SocketManager.Instance.out.labyrinthCleanOut();
      }
      
      public function show() : void
      {
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.ALPHA_BLOCKGOUND);
      }
      
      override public function dispose() : void
      {
         SocketManager.Instance.out.labyrinthStopCleanOut();
         PlayerManager.Instance.Self.playerState = new PlayerState(PlayerState.ONLINE,PlayerState.AUTO);
         SocketManager.Instance.out.sendFriendState(PlayerManager.Instance.Self.playerState.StateID);
         this.removeEvent();
         if(Boolean(this._timer))
         {
            this._timer.stop();
            this._timer.removeEventListener(TimerEvent.TIMER,this.__updateTimer);
            this._timer = null;
         }
         super.dispose();
         ObjectUtils.disposeObject(this._bg);
         this._bg = null;
         ObjectUtils.disposeObject(this._rightBG);
         this._rightBG = null;
         ObjectUtils.disposeObject(this._leftBG);
         this._leftBG = null;
         ObjectUtils.disposeObject(this._startCleanOutBtn);
         this._startCleanOutBtn = null;
         ObjectUtils.disposeObject(this._speededUpBtn);
         this._speededUpBtn = null;
         ObjectUtils.disposeObject(this._cancelBtn);
         this._cancelBtn = null;
         ObjectUtils.disposeObject(this._rightLabel);
         this._rightLabel = null;
         ObjectUtils.disposeObject(this._rightLabelI);
         this._rightLabelI = null;
         ObjectUtils.disposeObject(this._rightLabelII);
         this._rightLabelII = null;
         ObjectUtils.disposeObject(this._rightValue);
         this._rightValue = null;
         ObjectUtils.disposeObject(this._rightValueI);
         this._rightValueI = null;
         ObjectUtils.disposeObject(this._rightValueII);
         this._rightValueII = null;
         ObjectUtils.disposeObject(this._tipContainer);
         this._tipContainer = null;
         ObjectUtils.disposeObject(this._tipTitle);
         this._tipTitle = null;
         ObjectUtils.disposeObject(this._tipContent);
         this._tipContent = null;
         ObjectUtils.disposeObject(this._list);
         this._list = null;
         ObjectUtils.disposeObject(this._chatBtn);
         this._chatBtn = null;
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
   }
}

