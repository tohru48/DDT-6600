package newChickenBox.view
{
   import baglocked.BaglockedManager;
   import com.greensock.TweenLite;
   import com.greensock.easing.Sine;
   import com.gskinner.geom.ColorMatrix;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.toplevel.StageReferance;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.SelectedCheckButton;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.Image;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ClassUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.AddPublicTipManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.TimeManager;
   import ddt.utils.PositionUtils;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.filters.ColorMatrixFilter;
   import flash.filters.GlowFilter;
   import flash.text.TextField;
   import flash.ui.Mouse;
   import flash.utils.Timer;
   import newChickenBox.controller.NewChickenBoxManager;
   import newChickenBox.events.NewChickenBoxEvents;
   import newChickenBox.model.NewChickenBoxModel;
   
   public class NewChickenBoxFrame extends Frame implements Disposeable
   {
      
      private var _model:NewChickenBoxModel;
      
      private var tipSprite:Sprite;
      
      private var _newBoxBG:Image;
      
      public var countNum:ScaleFrameImage;
      
      private var openCardTimes:Image;
      
      public var eyeBtn:BaseButton;
      
      private var _eyeBtnSprite:Sprite;
      
      public var openCardBtn:BaseButton;
      
      private var _openCardBtnSprite:Sprite;
      
      public var startBnt:BaseButton;
      
      public var flushBnt:TextButton;
      
      public var msgText:FilterFrameText;
      
      public var newBoxView:NewChickenBoxView;
      
      private var _timer:Timer;
      
      private var _help_btn:BaseButton;
      
      private var egg:MovieClip;
      
      private var _helpPage:Frame;
      
      private var _helpPageCloseBtn:TextButton;
      
      private var _helpPageBg:Scale9CornerImage;
      
      private var _helpWord:MovieClip;
      
      private var eyepic:MovieClip;
      
      private var _refreshTimerTxt:FilterFrameText;
      
      private var _panel:ScrollPanel;
      
      public var frame:BaseAlerFrame;
      
      private var _freeOpenCountTxt:FilterFrameText;
      
      private var _freeEyeCountTxt:FilterFrameText;
      
      private var _freeRefreshCountTxt:FilterFrameText;
      
      private var _openCardBtnColorMatrixFilter:ColorMatrixFilter;
      
      private var _openCardBtnGlowFilter:GlowFilter;
      
      private var _eyeBtnColorMatrixFilter:ColorMatrixFilter;
      
      private var _eyeBtnGlowFilter:GlowFilter;
      
      private var _timePlayTxt:FilterFrameText;
      
      private var _timePlayTimer:Timer;
      
      private var _isEnd:Boolean;
      
      public function NewChickenBoxFrame()
      {
         super();
         this._model = NewChickenBoxModel.instance;
         this._openCardBtnColorMatrixFilter = new ColorMatrixFilter();
         var ld_Matrix:ColorMatrix = new ColorMatrix();
         ld_Matrix.adjustBrightness(25);
         ld_Matrix.adjustContrast(8);
         ld_Matrix.adjustSaturation(13);
         ld_Matrix.adjustHue(14);
         this._openCardBtnColorMatrixFilter.matrix = ld_Matrix;
         this._openCardBtnGlowFilter = new GlowFilter(16724787,1,10,10);
         this._eyeBtnColorMatrixFilter = new ColorMatrixFilter();
         var ld_Matrix2:ColorMatrix = new ColorMatrix();
         ld_Matrix2.adjustBrightness(38);
         ld_Matrix2.adjustContrast(11);
         ld_Matrix2.adjustSaturation(13);
         ld_Matrix2.adjustHue(14);
         this._eyeBtnColorMatrixFilter.matrix = ld_Matrix2;
         this._eyeBtnGlowFilter = new GlowFilter(16724787,1,10,10);
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         escEnable = true;
         titleText = LanguageMgr.GetTranslation("newChickenBox.newChickenTitle");
         this._newBoxBG = ComponentFactory.Instance.creatComponentByStylename("newChickenBox.newChickenBoxFrame.BG");
         addToContent(this._newBoxBG);
         this.countNum = ComponentFactory.Instance.creatComponentByStylename("newChickenBox.countNum");
         var times:int = this._model.canOpenCounts + 1 - this._model.countTime;
         this.countNum.setFrame(times);
         addToContent(this.countNum);
         this.openCardTimes = ComponentFactory.Instance.creatComponentByStylename("newChickenBox.openCardTimes");
         addToContent(this.openCardTimes);
         this.openCardBtn = ComponentFactory.Instance.creatComponentByStylename("newChickenBox.openCardBtn");
         this._openCardBtnSprite = new Sprite();
         this._openCardBtnSprite.mouseEnabled = false;
         this._openCardBtnSprite.x = this.openCardBtn.x;
         this._openCardBtnSprite.y = this.openCardBtn.y;
         this.openCardBtn.x = 0;
         this.openCardBtn.y = 0;
         this._openCardBtnSprite.addChild(this.openCardBtn);
         addToContent(this._openCardBtnSprite);
         this._freeOpenCountTxt = ComponentFactory.Instance.creatComponentByStylename("newChickenBox.openCardFreeTxt");
         addToContent(this._freeOpenCountTxt);
         this.refreshOpenCardBtnTxt();
         this.setOpenCardLight(true);
         this.eyeBtn = ComponentFactory.Instance.creatComponentByStylename("newChickenBox.eyeBtn");
         this._eyeBtnSprite = new Sprite();
         this._eyeBtnSprite.mouseEnabled = false;
         this._eyeBtnSprite.x = this.eyeBtn.x;
         this._eyeBtnSprite.y = this.eyeBtn.y;
         this.eyeBtn.x = 0;
         this.eyeBtn.y = 0;
         this._eyeBtnSprite.addChild(this.eyeBtn);
         addToContent(this._eyeBtnSprite);
         this._freeEyeCountTxt = ComponentFactory.Instance.creatComponentByStylename("newChickenBox.eyeFreeTxt");
         addToContent(this._freeEyeCountTxt);
         this.refreshEagleEyeBtnTxt();
         this._help_btn = ComponentFactory.Instance.creat("newChickenBox.helpPageBtn");
         addToContent(this._help_btn);
         this.firstEnterHelp();
         this.startBnt = ComponentFactory.Instance.creatComponentByStylename("newChickenBox.startBtn");
         if(this._model.isShowAll)
         {
            this.startBnt.enable = true;
         }
         else
         {
            this.startBnt.enable = false;
         }
         addToContent(this.startBnt);
         this.flushBnt = ComponentFactory.Instance.creatComponentByStylename("newChickenBox.freeFluashBnt");
         this.flushBnt.text = LanguageMgr.GetTranslation("newChickenBox.freeFlush");
         this.flushBnt.tipData = LanguageMgr.GetTranslation("newChickenBox.flushTipData");
         addToContent(this.flushBnt);
         this._freeRefreshCountTxt = ComponentFactory.Instance.creatComponentByStylename("newChickenBox.refreshCardFreeTxt");
         addToContent(this._freeRefreshCountTxt);
         this._refreshTimerTxt = ComponentFactory.Instance.creatComponentByStylename("newChickenBox.text.adoptRefreshTimer");
         this.firestGetTime();
         addToContent(this._refreshTimerTxt);
         this.msgText = ComponentFactory.Instance.creatComponentByStylename("newChickenBox.TextStyle_1");
         addToContent(this.msgText);
         this.msgText.text = LanguageMgr.GetTranslation("newChickenBox.useMoneyMsg",this._model.openCardPrice[this._model.countTime]);
         this.msgText.visible = false;
         this.newBoxView = new NewChickenBoxView();
         addToContent(this.newBoxView);
         this.eyepic = ClassUtils.CreatInstance("asset.newChickenBox.eyePic") as MovieClip;
         this.eyepic.visible = false;
         this.eyepic.mouseChildren = false;
         this.eyepic.mouseEnabled = false;
         addEventListener(Event.ENTER_FRAME,this.useEyePic);
         LayerManager.Instance.addToLayer(this.eyepic,LayerManager.STAGE_TOP_LAYER);
         this._isEnd = false;
         this._timePlayTxt = ComponentFactory.Instance.creatComponentByStylename("newChickenBox.timePlayTxt");
         addToContent(this._timePlayTxt);
         this.startTimePlayTimer();
         this.refreshTimePlayTxt();
         AddPublicTipManager.Instance.type = AddPublicTipManager.CHICKEN;
      }
      
      private function startTimePlayTimer() : void
      {
         this._timePlayTimer = new Timer(1000,0);
         this._timePlayTimer.addEventListener(TimerEvent.TIMER,this.countChangeHandler,false,0,true);
         this._timePlayTimer.start();
      }
      
      private function refreshTimePlayTxt() : void
      {
         var timeTxtStr:String = null;
         var endTimestamp:Number = Number(this._model.endTime.getTime());
         var nowTimestamp:Number = Number(TimeManager.Instance.Now().getTime());
         var differ:Number = endTimestamp - nowTimestamp;
         differ = differ < 0 ? 0 : differ;
         var count:int = 0;
         if(differ / TimeManager.DAY_TICKS > 1)
         {
            count = differ / TimeManager.DAY_TICKS;
            timeTxtStr = count + LanguageMgr.GetTranslation("day");
         }
         else if(differ / TimeManager.HOUR_TICKS > 1)
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
         this._timePlayTxt.text = LanguageMgr.GetTranslation("newChickenBox.timePlayTxt") + timeTxtStr;
         if(count <= 0)
         {
            this._isEnd = true;
         }
      }
      
      private function countChangeHandler(event:TimerEvent) : void
      {
         if(!this._isEnd)
         {
            this.refreshTimePlayTxt();
         }
         this.firestGetTime();
      }
      
      private function disposeTimePlayTimer() : void
      {
         if(Boolean(this._timePlayTimer))
         {
            this._timePlayTimer.stop();
            this._timePlayTimer.removeEventListener(TimerEvent.TIMER,this.countChangeHandler);
            this._timePlayTimer = null;
         }
      }
      
      public function setEyeLight(isLigth:Boolean) : void
      {
         if(isLigth)
         {
            this._eyeBtnSprite.filters = [this._eyeBtnColorMatrixFilter,this._eyeBtnGlowFilter];
         }
         else
         {
            this._eyeBtnSprite.filters = null;
         }
      }
      
      public function setOpenCardLight(isLigth:Boolean) : void
      {
         if(isLigth)
         {
            this._openCardBtnSprite.filters = [this._openCardBtnColorMatrixFilter,this._openCardBtnGlowFilter];
         }
         else
         {
            this._openCardBtnSprite.filters = null;
         }
      }
      
      public function refreshEagleEyeBtnTxt() : void
      {
         if(this._model.freeEyeCount <= 0)
         {
            this.eyeBtn.backStyle = "asset.newChickenBox.eagleEyeBtn";
            this.eyeBtn.tipStyle = "ddt.view.tips.OneLineTip";
            this.eyeBtn.tipData = LanguageMgr.GetTranslation("newChickenBox.useEyeCost",this._model.eagleEyePrice[this._model.countEye]);
            this._freeEyeCountTxt.visible = false;
         }
         else
         {
            this.eyeBtn.backStyle = "asset.newChickenBox.eagleEyeBtnFree";
            this.eyeBtn.tipStyle = null;
            this.eyeBtn.tipData = null;
            this._freeEyeCountTxt.text = "（" + this._model.freeEyeCount + "）";
            this._freeEyeCountTxt.visible = true;
         }
      }
      
      public function refreshOpenCardBtnTxt() : void
      {
         if(this._model.freeOpenCardCount <= 0)
         {
            this.openCardBtn.backStyle = "asset.newChickenBox.openCardBtn";
            this.openCardBtn.tipStyle = "ddt.view.tips.OneLineTip";
            this.openCardBtn.tipData = LanguageMgr.GetTranslation("newChickenBox.useOpenCardCost",this._model.openCardPrice[this._model.countTime]);
            this._freeOpenCountTxt.visible = false;
         }
         else
         {
            this.openCardBtn.backStyle = "asset.newChickenBox.openCardBtnFree";
            this.openCardBtn.tipStyle = null;
            this.openCardBtn.tipData = null;
            this._freeOpenCountTxt.text = "（" + this._model.freeOpenCardCount + "）";
            this._freeOpenCountTxt.visible = true;
         }
      }
      
      private function useEyePic(e:Event) : void
      {
         if(this._model.clickEagleEye)
         {
            this.eyepic.visible = true;
            Mouse.hide();
         }
         else
         {
            this.eyepic.visible = false;
            Mouse.show();
         }
         this.eyepic.x = mouseX;
         this.eyepic.y = mouseY;
      }
      
      public function firestGetTime() : Boolean
      {
         var flag:Boolean = false;
         var timeCut:Number = NaN;
         var hours:int = 0;
         var minitues:int = 0;
         var now:Date = TimeManager.Instance.Now();
         var nowNum:Number = Number(now.getTime());
         var lastNum:Number = Number(this._model.lastFlushTime.getTime());
         var bettwen:Number = this._model.freeFlushTime * 60 * 1000;
         if(this._model.freeRefreshBoxCount > 0 || nowNum - lastNum > bettwen)
         {
            this._refreshTimerTxt.visible = false;
            this._refreshTimerTxt.text = LanguageMgr.GetTranslation("newChickenBox.flushTimecut",0);
            if(Boolean(this.flushBnt))
            {
               this.flushBnt.text = LanguageMgr.GetTranslation("newChickenBox.freeFlush");
            }
            if(Boolean(this._freeRefreshCountTxt))
            {
               this._freeRefreshCountTxt.text = "(" + (this._model.freeRefreshBoxCount + (nowNum - lastNum > bettwen ? 1 : 0)) + ")";
               this._freeRefreshCountTxt.visible = true;
            }
            flag = true;
         }
         else
         {
            timeCut = bettwen - (nowNum - lastNum);
            hours = timeCut / (1000 * 60 * 60);
            minitues = (timeCut - hours * 1000 * 60 * 60) / (1000 * 60) + 1;
            minitues = minitues > this._model.freeFlushTime ? this._model.freeFlushTime : minitues;
            this._refreshTimerTxt.text = LanguageMgr.GetTranslation("newChickenBox.flushTimecut",minitues);
            this._refreshTimerTxt.visible = true;
            if(Boolean(this.flushBnt))
            {
               this.flushBnt.text = LanguageMgr.GetTranslation("newChickenBox.flushText");
            }
            if(Boolean(this._freeRefreshCountTxt))
            {
               this._freeRefreshCountTxt.visible = false;
            }
            flag = false;
         }
         return flag;
      }
      
      private function removeEvent() : void
      {
         removeEventListener(Event.ENTER_FRAME,this.useEyePic);
         removeEventListener(FrameEvent.RESPONSE,this.__confirmResponse);
         if(Boolean(this.startBnt))
         {
            this.startBnt.removeEventListener(MouseEvent.CLICK,this.clickStart);
         }
         if(Boolean(this.eyeBtn))
         {
            this.eyeBtn.removeEventListener(MouseEvent.CLICK,this.clickEye);
         }
         if(Boolean(this.openCardBtn))
         {
            this.openCardBtn.removeEventListener(MouseEvent.CLICK,this.clickOpenCard);
         }
         if(Boolean(this.flushBnt))
         {
            this.flushBnt.removeEventListener(MouseEvent.CLICK,this.flushItem);
         }
         this._model.removeEventListener(NewChickenBoxEvents.CANCLICKENABLE,this.playMovie);
         this._model.removeEventListener("mouseShapoff",this.mouseoff);
         if(Boolean(this._help_btn))
         {
            this._help_btn.removeEventListener(MouseEvent.CLICK,this.__help);
         }
         if(Boolean(this._helpPageCloseBtn))
         {
            this._helpPageCloseBtn.removeEventListener(MouseEvent.CLICK,this.__helpPageClose);
            this._helpPage.removeEventListener(FrameEvent.RESPONSE,this.__helpResponseHandler);
         }
      }
      
      private function mouseoff(e:Event) : void
      {
         this.eyepic.visible = false;
         Mouse.show();
      }
      
      private function initEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__confirmResponse);
         this.startBnt.addEventListener(MouseEvent.CLICK,this.clickStart);
         this.eyeBtn.addEventListener(MouseEvent.CLICK,this.clickEye);
         this.openCardBtn.addEventListener(MouseEvent.CLICK,this.clickOpenCard);
         this.flushBnt.addEventListener(MouseEvent.CLICK,this.flushItem);
         this._model.addEventListener(NewChickenBoxEvents.CANCLICKENABLE,this.playMovie);
         this._model.addEventListener("mouseShapoff",this.mouseoff);
         this._help_btn.addEventListener(MouseEvent.CLICK,this.__help);
      }
      
      private function clickOpenCard(e:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this.setOpenCardLight(true);
         this.setEyeLight(false);
         if(this._model.clickEagleEye)
         {
            this.eyepic.visible = false;
            Mouse.show();
            this._model.clickEagleEye = false;
         }
      }
      
      private function firstEnterHelp() : void
      {
         if(this._model.firstEnterHelp)
         {
            this._model.firstEnterHelp = false;
            if(!this._helpPage)
            {
               this.createHelpPage();
            }
            StageReferance.stage.focus = this._helpPage;
            this._helpPage.visible = this._helpPage.visible ? false : true;
         }
      }
      
      private function __help(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         event.stopImmediatePropagation();
         if(!this._helpPage)
         {
            this.createHelpPage();
         }
         StageReferance.stage.focus = this._helpPage;
         this._helpPage.visible = this._helpPage.visible ? false : true;
      }
      
      private function createHelpPage() : void
      {
         this._helpPage = ComponentFactory.Instance.creat("newChickenBox.helpPageFrame");
         this._helpPage.escEnable = true;
         this._helpPage.titleText = LanguageMgr.GetTranslation("tank.view.emailII.ReadingView.useHelp");
         LayerManager.Instance.addToLayer(this._helpPage,LayerManager.GAME_TOP_LAYER,true);
         this._helpPageBg = ComponentFactory.Instance.creatComponentByStylename("newChickenBox.helpPageFrameBG");
         this._helpPage.addToContent(this._helpPageBg);
         this._helpPageCloseBtn = ComponentFactory.Instance.creat("newChickenBox.helpPageCloseBtn");
         this._helpPageCloseBtn.text = LanguageMgr.GetTranslation("close");
         this._helpPage.addToContent(this._helpPageCloseBtn);
         this._helpPageCloseBtn.addEventListener(MouseEvent.CLICK,this.__helpPageClose);
         this._helpWord = ComponentFactory.Instance.creat("asset.newChickenBox.helpPageWord");
         this._panel = ComponentFactory.Instance.creatComponentByStylename("newChickenBox.ReaderScrollpanel");
         this._panel.setView(this._helpWord);
         this._panel.invalidateViewport(false);
         this._helpPage.addToContent(this._panel);
         this._helpPage.visible = false;
         this._helpPage.addEventListener(FrameEvent.RESPONSE,this.__helpResponseHandler);
         this._helpPage.graphics.beginFill(16777215,0);
         this._helpPage.graphics.drawRect(-this._helpPage.x,-this._helpPage.y,1000,600);
         this._helpPage.graphics.endFill();
      }
      
      private function __helpPageClose(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this._helpPage.visible = false;
      }
      
      private function __helpResponseHandler(evt:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         if(evt.responseCode == FrameEvent.CLOSE_CLICK || evt.responseCode == FrameEvent.ESC_CLICK)
         {
            this._helpPage.visible = false;
         }
         StageReferance.stage.focus = this;
      }
      
      private function playMovie(e:NewChickenBoxEvents) : void
      {
         this.eyeBtn.enable = true;
         this.openCardBtn.enable = true;
         this.__start();
      }
      
      private function clickStart(e:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this.startBnt.enable = false;
         SocketManager.Instance.out.sendClickStartBntNewChickenBox();
      }
      
      private function flushItem(e:MouseEvent) : void
      {
         var times1:int = 0;
         var times:int = 0;
         SoundManager.instance.play("008");
         this._model.clickEagleEye = false;
         this.setOpenCardLight(true);
         this.setEyeLight(false);
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         Mouse.show();
         var moneyValue:int = this._model.flushPrice;
         var isFree:Boolean = this.firestGetTime();
         if(!isFree && PlayerManager.Instance.Self.Money < moneyValue)
         {
            LeavePageManager.showFillFrame();
            return;
         }
         if(this._model.AlertFlush && !isFree)
         {
            this.openAlertFrame();
         }
         else if(isFree)
         {
            this.startBnt.enable = true;
            this.eyeBtn.enable = false;
            this.openCardBtn.enable = false;
            times1 = this._model.canOpenCounts + 1;
            this.countNum.setFrame(times1);
            this._model.countTime = 0;
            this._model.countEye = 0;
            this._model.canclickEnable = false;
            SocketManager.Instance.out.sendFlushNewChickenBox();
         }
         else
         {
            this.startBnt.enable = true;
            times = this._model.canOpenCounts + 1;
            this.countNum.setFrame(times);
            this._model.countTime = 0;
            this._model.countEye = 0;
            this.eyeBtn.enable = false;
            this.openCardBtn.enable = false;
            this._model.canclickEnable = false;
            SocketManager.Instance.out.sendFlushNewChickenBox();
         }
      }
      
      private function openAlertFrame() : BaseAlerFrame
      {
         var msg:String = LanguageMgr.GetTranslation("newChickenBox.useMoneyAlert",this._model.flushPrice);
         var textField:TextField = new TextField();
         var select:SelectedCheckButton = ComponentFactory.Instance.creatComponentByStylename("newChickenBox.selectBnt");
         select.text = LanguageMgr.GetTranslation("newChickenBox.noAlert");
         select.addEventListener(MouseEvent.CLICK,this.noAlertEable);
         if(Boolean(this.frame))
         {
            ObjectUtils.disposeObject(this.frame);
         }
         this.frame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("newChickenBox.newChickenTitle"),msg,LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),true,true,false,2);
         this.frame.addChild(select);
         this.frame.addEventListener(FrameEvent.RESPONSE,this.__onResponse);
         return this.frame;
      }
      
      private function noAlertEable(e:MouseEvent) : void
      {
         var select:SelectedCheckButton = e.currentTarget as SelectedCheckButton;
         if(select.selected)
         {
            this._model.AlertFlush = false;
         }
         else
         {
            this._model.AlertFlush = true;
         }
      }
      
      private function __onResponse(evt:FrameEvent) : void
      {
         var times:int = 0;
         SoundManager.instance.play("008");
         var alert:BaseAlerFrame = evt.target as BaseAlerFrame;
         alert.removeEventListener(FrameEvent.RESPONSE,this.__onResponse);
         alert.dispose();
         if(evt.responseCode == FrameEvent.ENTER_CLICK || evt.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            this.startBnt.enable = true;
            this.eyeBtn.enable = false;
            times = this._model.canOpenCounts + 1;
            this.countNum.setFrame(times);
            this._model.countTime = 0;
            this._model.countEye = 0;
            this._model.canclickEnable = false;
            SocketManager.Instance.out.sendFlushNewChickenBox();
         }
      }
      
      private function clickEye(e:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this.setEyeLight(true);
         this.setOpenCardLight(false);
         if(this._model.countEye >= this._model.canEagleEyeCounts)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("newChickenBox.eyeNotUseEnable"));
            return;
         }
         if(this._model.canclickEnable)
         {
            this.eyepic.visible = true;
            Mouse.hide();
            this._model.clickEagleEye = true;
            e.stopImmediatePropagation();
         }
      }
      
      private function __start() : void
      {
         TweenLite.to(this.newBoxView,0.5,{
            "alpha":0,
            "scaleX":0,
            "scaleY":0,
            "x":470,
            "y":300,
            "ease":Sine.easeInOut
         });
         this._timer = new Timer(500,1);
         this._timer.start();
         this._timer.addEventListener(TimerEvent.TIMER_COMPLETE,this._timerComplete);
      }
      
      private function showOutItem(e:Event) : void
      {
         if(Boolean(this.newBoxView))
         {
            TweenLite.to(this.newBoxView,0.5,{
               "alpha":1,
               "scaleX":1,
               "scaleY":1,
               "x":0,
               "y":0,
               "ease":Sine.easeInOut
            });
         }
         var eggs:MovieClip = e.currentTarget as MovieClip;
         if(Boolean(eggs))
         {
            eggs.removeEventListener("showItems",this.showOutItem);
            eggs.gotoAndStop(eggs.totalFrames);
            removeChild(eggs);
            eggs = null;
         }
      }
      
      private function _timerComplete(e:TimerEvent) : void
      {
         this.egg = ClassUtils.CreatInstance("asset.newChickenBox.dan") as MovieClip;
         this.egg.addEventListener("showItems",this.showOutItem);
         PositionUtils.setPos(this.egg,"newChickenBox.eggPos");
         addChild(this.egg);
         this.egg.mouseEnabled = false;
         this.egg.mouseChildren = false;
         for(var i:int = 0; i < this._model.itemList.length; i++)
         {
            this._model.itemList[i].setBg(3);
         }
         this._timer.removeEventListener(TimerEvent.TIMER_COMPLETE,this._timerComplete);
         this._timer = null;
         this.msgText.text = LanguageMgr.GetTranslation("newChickenBox.useMoneyMsg",this._model.openCardPrice[this._model.countTime]);
      }
      
      private function __confirmResponse(evt:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         removeEventListener(FrameEvent.RESPONSE,this.__confirmResponse);
         switch(evt.responseCode)
         {
            case FrameEvent.CLOSE_CLICK:
               this.dispose();
               break;
            case FrameEvent.ESC_CLICK:
               this.dispose();
         }
      }
      
      private function helpPageDispose() : void
      {
         if(Boolean(this._helpPage))
         {
            if(Boolean(this._helpPageCloseBtn))
            {
               ObjectUtils.disposeObject(this._helpPageCloseBtn);
            }
            this._helpPageCloseBtn = null;
            if(Boolean(this._helpPageBg))
            {
               ObjectUtils.disposeObject(this._helpPageBg);
            }
            this._helpPageBg = null;
            if(Boolean(this._helpWord))
            {
               ObjectUtils.disposeObject(this._helpWord);
            }
            this._helpWord = null;
            this._helpPage.dispose();
            if(Boolean(this._helpPage) && Boolean(this._helpPage.parent))
            {
               this._helpPage.parent.removeChild(this._helpPage);
            }
            this._helpPage = null;
         }
      }
      
      override public function dispose() : void
      {
         AddPublicTipManager.Instance.type = 0;
         this.removeEvent();
         TweenLite.killTweensOf(this.newBoxView);
         if(Boolean(this._timer))
         {
            this._timer.stop();
            this._timer.removeEventListener(TimerEvent.TIMER_COMPLETE,this._timerComplete);
            this._timer = null;
         }
         this.disposeTimePlayTimer();
         this._openCardBtnColorMatrixFilter = null;
         this._openCardBtnGlowFilter = null;
         this._eyeBtnColorMatrixFilter = null;
         this._eyeBtnGlowFilter = null;
         ObjectUtils.disposeObject(this._freeOpenCountTxt);
         this._freeOpenCountTxt = null;
         ObjectUtils.disposeObject(this._freeEyeCountTxt);
         this._freeEyeCountTxt = null;
         ObjectUtils.disposeObject(this._freeRefreshCountTxt);
         this._freeRefreshCountTxt = null;
         ObjectUtils.disposeObject(this._timePlayTxt);
         this._timePlayTxt = null;
         ObjectUtils.disposeObject(this._eyeBtnSprite);
         this._eyeBtnSprite = null;
         ObjectUtils.disposeObject(this._openCardBtnSprite);
         this._openCardBtnSprite = null;
         ObjectUtils.disposeObject(this.openCardBtn);
         this.openCardBtn = null;
         if(Boolean(this.egg))
         {
            this.egg.removeEventListener("showItems",this.showOutItem);
            this.egg.gotoAndStop(this.egg.totalFrames);
            if(Boolean(this.egg.parent))
            {
               removeChild(this.egg);
            }
            this.egg = null;
         }
         if(Boolean(this._newBoxBG))
         {
            ObjectUtils.disposeObject(this._newBoxBG);
         }
         this._newBoxBG = null;
         if(Boolean(this.countNum))
         {
            ObjectUtils.disposeObject(this.countNum);
         }
         this.countNum = null;
         if(Boolean(this.flushBnt))
         {
            ObjectUtils.disposeObject(this.flushBnt);
         }
         this.flushBnt = null;
         if(Boolean(this._help_btn))
         {
            ObjectUtils.disposeObject(this._help_btn);
         }
         this._help_btn = null;
         if(Boolean(this.openCardTimes))
         {
            ObjectUtils.disposeObject(this.openCardTimes);
         }
         this.openCardTimes = null;
         if(Boolean(this._newBoxBG))
         {
            ObjectUtils.disposeObject(this._newBoxBG);
         }
         this._newBoxBG = null;
         if(Boolean(this.startBnt))
         {
            ObjectUtils.disposeObject(this.startBnt);
         }
         this.startBnt = null;
         if(Boolean(this.msgText))
         {
            ObjectUtils.disposeObject(this.msgText);
         }
         this.msgText = null;
         if(Boolean(this.newBoxView))
         {
            this.newBoxView.dispose();
         }
         this.newBoxView = null;
         if(Boolean(this.frame))
         {
            this.frame.removeEventListener(FrameEvent.RESPONSE,this.__onResponse);
            this.frame.dispose();
         }
         this.helpPageDispose();
         if(Boolean(this.eyepic))
         {
            ObjectUtils.disposeObject(this.eyepic);
            this.eyepic = null;
         }
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
         super.dispose();
         NewChickenBoxManager.instance.firstEnter = true;
         this._model.canclickEnable = false;
         this._model.countTime = 0;
         this._model.countTime = 0;
         if(Boolean(this.eyepic))
         {
            this.eyepic.visible = false;
         }
         Mouse.show();
         this._model.clickEagleEye = false;
      }
   }
}

