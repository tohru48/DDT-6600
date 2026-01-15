package kingDivision.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.GameInSocketOut;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import ddt.manager.TimeManager;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import kingDivision.KingDivisionManager;
   import kingDivision.data.KingDivisionConsortionItemInfo;
   import kingDivision.data.KingDivisionPackageType;
   
   public class QualificationsFrame extends Sprite implements Disposeable
   {
      
      private var _bg:Bitmap;
      
      private var _awardsBtn:BaseButton;
      
      private var _ruleTxt:FilterFrameText;
      
      private var _list:VBox;
      
      private var _panel:ScrollPanel;
      
      private var _points:FilterFrameText;
      
      private var _titleName:Array;
      
      private var _titleNameTxt:FilterFrameText;
      
      private var index:int;
      
      private var _numberImg:Bitmap;
      
      private var _numberTxt:FilterFrameText;
      
      private var _startBtn:SimpleBitmapButton;
      
      private var _cancelBtn:SimpleBitmapButton;
      
      private var _consortionList:KingDivisionConsortionList;
      
      private var _consorPanel:ScrollPanel;
      
      private var _blind:Bitmap;
      
      private var _match:Bitmap;
      
      private var _timeTxt:FilterFrameText;
      
      private var _timer:Timer;
      
      private var _timerUpdate:Timer;
      
      private var _proBar:ProgressBarView;
      
      private var _info:Vector.<KingDivisionConsortionItemInfo>;
      
      private var isConsortiaID:Boolean;
      
      private var isTrue:Boolean;
      
      public function QualificationsFrame()
      {
         super();
         this.initView();
         this.addEvent();
      }
      
      private function initView() : void
      {
         this._bg = ComponentFactory.Instance.creatBitmap("asset.kingdivision.qualificationsframe");
         this._awardsBtn = ComponentFactory.Instance.creat("qualificationsFrame.awardsBtn");
         this._points = ComponentFactory.Instance.creatComponentByStylename("qualificationsFrame.pointsTxt");
         this._points.text = KingDivisionManager.Instance.points.toString();
         this._ruleTxt = ComponentFactory.Instance.creatComponentByStylename("qualificationsFrame.ruleTxt");
         this._ruleTxt.text = LanguageMgr.GetTranslation("ddt.qualificationsFrame.ruleTxt");
         this._list = ComponentFactory.Instance.creatComponentByStylename("assets.qualificationsFrame.ruleTxtVBox");
         this._list.addChild(this._ruleTxt);
         this._panel = ComponentFactory.Instance.creatComponentByStylename("assets.qualificationsFrame.ruleTxtScrollpanel");
         this._panel.setView(this._list);
         this._panel.invalidateViewport();
         this._titleName = LanguageMgr.GetTranslation("ddt.qualificationsFrame.titleNameTxt").split(",");
         this._numberImg = ComponentFactory.Instance.creatBitmap("asset.qualificationsframe.number");
         this._numberTxt = ComponentFactory.Instance.creatComponentByStylename("qualificationsFrame.numberTxt");
         this._numberTxt.text = KingDivisionManager.Instance.gameNum.toString();
         this._startBtn = ComponentFactory.Instance.creatComponentByStylename("qualificationsFrame.startBtn");
         this._cancelBtn = ComponentFactory.Instance.creatComponentByStylename("qualificationsFrame.cancelBtn");
         this._cancelBtn.visible = false;
         this._consortionList = ComponentFactory.Instance.creatComponentByStylename("kingDivision.consortionList");
         this._consorPanel = ComponentFactory.Instance.creatComponentByStylename("assets.qualificationsFrame.consorPanel");
         this._consorPanel.setView(this._consortionList);
         this._blind = ComponentFactory.Instance.creatBitmap("asset.qualificationsFrame.smallblind");
         this._blind.visible = false;
         this._match = ComponentFactory.Instance.creatBitmap("asset.qualificationsFrame.smallmatch");
         this._match.visible = false;
         this._timeTxt = ComponentFactory.Instance.creatComponentByStylename("asset.qualificationsFrame.timeTxt");
         addChild(this._bg);
         addChild(this._awardsBtn);
         addChild(this._panel);
         addChild(this._points);
         addChild(this._numberImg);
         addChild(this._numberTxt);
         addChild(this._startBtn);
         addChild(this._cancelBtn);
         addChild(this._consorPanel);
         addChild(this._blind);
         addChild(this._match);
         addChild(this._timeTxt);
         this.addTitleName(this._titleName,this._titleName.length);
         this._timer = new Timer(1000);
         this._timer.addEventListener(TimerEvent.TIMER,this.__timer);
         this._timerUpdate = new Timer(60000);
         this._timerUpdate.addEventListener(TimerEvent.TIMER,this.__updateConsortionMessage);
         this._timerUpdate.start();
         this.playerIsConsortion();
         this.checkGameStartTimer();
         if(KingDivisionManager.Instance.states == 2)
         {
            this.isShowStartBtn();
         }
      }
      
      private function addEvent() : void
      {
         this._startBtn.addEventListener(MouseEvent.CLICK,this.__onStartBtnClick);
         this._cancelBtn.addEventListener(MouseEvent.CLICK,this.__onCancelBtnClick);
         this._awardsBtn.addEventListener(MouseEvent.CLICK,this.__onClickAwardsBtn);
      }
      
      private function removeEvent() : void
      {
         this._startBtn.removeEventListener(MouseEvent.CLICK,this.__onStartBtnClick);
         this._cancelBtn.removeEventListener(MouseEvent.CLICK,this.__onCancelBtnClick);
         this._awardsBtn.removeEventListener(MouseEvent.CLICK,this.__onClickAwardsBtn);
         this._timer.removeEventListener(TimerEvent.TIMER,this.__timer);
         this._timerUpdate.removeEventListener(TimerEvent.TIMER,this.__updateConsortionMessage);
      }
      
      private function playerIsConsortion() : void
      {
         if(PlayerManager.Instance.Self.ConsortiaID <= 0)
         {
            this._startBtn.visible = false;
            this._cancelBtn.visible = false;
            this._blind.visible = false;
            this._match.visible = false;
            if(Boolean(this._numberImg))
            {
               ObjectUtils.disposeObject(this._numberImg);
               this._numberImg = null;
            }
            if(Boolean(this._numberTxt))
            {
               ObjectUtils.disposeObject(this._numberTxt);
               this._numberTxt = null;
            }
            return;
         }
         this._startBtn.visible = true;
      }
      
      public function updateMessage(score:int, gameNum:int) : void
      {
         this._points.text = score.toString();
         this._numberTxt.text = gameNum.toString();
      }
      
      public function updateConsortiaMessage() : void
      {
         if(Boolean(this._consortionList) && Boolean(this._consorPanel))
         {
            ObjectUtils.disposeObject(this._consortionList);
            this._consortionList = null;
            ObjectUtils.disposeObject(this._consorPanel);
            this._consorPanel = null;
         }
         this._consortionList = ComponentFactory.Instance.creatComponentByStylename("kingDivision.consortionList");
         this._consorPanel = ComponentFactory.Instance.creatComponentByStylename("assets.qualificationsFrame.consorPanel");
         this._consorPanel.setView(this._consortionList);
         addChild(this._consorPanel);
      }
      
      private function __timer(evt:TimerEvent) : void
      {
         var min:uint = this._timer.currentCount / 60;
         var sec:uint = this._timer.currentCount % 60;
         this._timeTxt.text = sec > 9 ? sec.toString() : "0" + sec;
      }
      
      public function updateButtons() : void
      {
         this._startBtn.visible = false;
         this._cancelBtn.visible = true;
         if(Boolean(this._blind))
         {
            ObjectUtils.disposeObject(this._blind);
            this._blind = null;
         }
         if(Boolean(this._match))
         {
            ObjectUtils.disposeObject(this._match);
            this._match = null;
         }
         this._blind = ComponentFactory.Instance.creatBitmap("asset.qualificationsFrame.smallblind");
         this._match = ComponentFactory.Instance.creatBitmap("asset.qualificationsFrame.smallmatch");
         addChild(this._blind);
         addChild(this._match);
         if(Boolean(this._timer) && !this._timer.running)
         {
            if(Boolean(this._timeTxt))
            {
               ObjectUtils.disposeObject(this._timeTxt);
               this._timeTxt = null;
            }
            this._timeTxt = ComponentFactory.Instance.creatComponentByStylename("asset.qualificationsFrame.timeTxt");
            addChild(this._timeTxt);
            this._timeTxt.text = "00";
            this._timer.start();
         }
      }
      
      private function isShowStartBtn() : void
      {
         var i:int = 0;
         this._info = KingDivisionManager.Instance.model.conItemInfo;
         if(this._info != null)
         {
            for(i = 0; i < this._info.length; i++)
            {
               if(PlayerManager.Instance.Self.ConsortiaID == this._info[i].consortionIDArea && PlayerManager.Instance.Self.ZoneID == this._info[i].areaID || this.isConsortiaID)
               {
                  this.isConsortiaID = true;
               }
               else
               {
                  this.isConsortiaID = false;
               }
            }
         }
         if(!this.isConsortiaID)
         {
            if(Boolean(this._numberImg))
            {
               ObjectUtils.disposeObject(this._numberImg);
               this._numberImg = null;
            }
            if(Boolean(this._numberTxt))
            {
               ObjectUtils.disposeObject(this._numberTxt);
               this._numberTxt = null;
            }
            this._startBtn.visible = false;
            this._cancelBtn.visible = false;
            this._blind.visible = false;
            this._match.visible = false;
         }
      }
      
      private function __onStartBtnClick(evt:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this._timerUpdate.stop();
         if(!KingDivisionManager.Instance.checkGameTimeIsOpen())
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.kingdivision.checkGameTimesIsOpen"));
            return;
         }
         if(KingDivisionManager.Instance.gameNum <= 0)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.kingdivision.gameNum"));
            return;
         }
         if(PlayerManager.Instance.Self.Grade < KingDivisionManager.Instance.level)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.kingdivision.gameLevel",KingDivisionManager.Instance.level));
            return;
         }
         if(KingDivisionManager.Instance.checkCanStartGame())
         {
            this.startGame();
         }
      }
      
      private function startGame() : void
      {
         var type:int = 0;
         if(KingDivisionManager.Instance.states == 1)
         {
            type = KingDivisionPackageType.CONSORTIA_MATCH_FIGHT;
         }
         else if(KingDivisionManager.Instance.states == 2)
         {
            type = KingDivisionPackageType.CONSORTIA_MATCH_FIGHT_AREA;
         }
         GameInSocketOut.sendKingDivisionGameStart(type);
      }
      
      private function __onCancelBtnClick(evt:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this.cancelMatch();
      }
      
      private function __onClickAwardsBtn(evt:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         var rewView:RewardView = ComponentFactory.Instance.creatComponentByStylename("qualificationsFrame.RewardView");
         LayerManager.Instance.addToLayer(rewView,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      private function addTitleName(arr:Array, len:int) : void
      {
         if(this.index > len - 1)
         {
            return;
         }
         this._titleNameTxt = ComponentFactory.Instance.creatComponentByStylename("qualificationsFrame.titleNameTxt" + this.index);
         this._titleNameTxt.text = arr[this.index];
         ++this.index;
         addChild(this._titleNameTxt);
         this.addTitleName(arr,len);
      }
      
      private function __updateConsortionMessage(evt:TimerEvent) : void
      {
         if(!this.isTrue)
         {
            this.checkGameStartTimer();
         }
         KingDivisionManager.Instance.updateConsotionMessage();
      }
      
      public function set progressBarView(value:ProgressBarView) : void
      {
         this._proBar = value;
      }
      
      public function setDateStages(arr:Array) : void
      {
         var date:Date = TimeManager.Instance.Now();
         for(var i:int = 0; i < arr.length; i++)
         {
            if(arr[i] == date.date)
            {
               this._proBar.proBarAllMovie.gotoAndStop(i + 1);
               break;
            }
            if(arr[i] < date.date)
            {
               this._proBar.proBarAllMovie.gotoAndStop(5);
            }
         }
      }
      
      public function cancelMatch() : void
      {
         this._timerUpdate.start();
         this._startBtn.visible = true;
         this._cancelBtn.visible = false;
         this._blind.visible = false;
         this._match.visible = false;
         this._timeTxt.text = "";
         this._timer.stop();
         this._timer.reset();
         GameInSocketOut.sendCancelWait();
      }
      
      private function checkGameStartTimer() : void
      {
         if(!KingDivisionManager.Instance.checkGameTimeIsOpen())
         {
            this._startBtn.enable = false;
            this._startBtn.mouseEnabled = false;
            this._startBtn.mouseChildren = false;
         }
         else
         {
            this._startBtn.enable = true;
            this._startBtn.mouseEnabled = true;
            this._startBtn.mouseChildren = true;
            this.isTrue = true;
         }
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         this.isTrue = false;
         ObjectUtils.disposeObject(this._awardsBtn);
         this._awardsBtn = null;
         ObjectUtils.disposeObject(this._ruleTxt);
         this._ruleTxt = null;
         ObjectUtils.disposeObject(this._points);
         this._points = null;
         ObjectUtils.disposeObject(this._titleNameTxt);
         this._titleNameTxt = null;
         ObjectUtils.disposeObject(this._numberTxt);
         this._numberTxt = null;
         ObjectUtils.disposeObject(this._list);
         this._list = null;
         ObjectUtils.disposeObject(this._panel);
         this._panel = null;
         ObjectUtils.disposeObject(this._startBtn);
         this._startBtn = null;
         ObjectUtils.disposeObject(this._cancelBtn);
         this._cancelBtn = null;
         if(Boolean(this._timer))
         {
            this._timer.stop();
            ObjectUtils.disposeObject(this._timer);
            this._timer = null;
         }
         if(Boolean(this._timerUpdate))
         {
            this._timerUpdate.stop();
            ObjectUtils.disposeObject(this._timerUpdate);
            this._timerUpdate = null;
         }
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

