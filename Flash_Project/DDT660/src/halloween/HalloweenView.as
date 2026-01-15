package halloween
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.SelectedButton;
   import com.pickgliss.ui.controls.SelectedButtonGroup;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.ServerConfigManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.TimeManager;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import store.HelpFrame;
   
   public class HalloweenView extends Frame
   {
      
      private var _bg:Bitmap;
      
      private var _rightbg:Bitmap;
      
      private var _rankTxt:FilterFrameText;
      
      private var _myCardTxt:FilterFrameText;
      
      private var _refreshTimeTxt:FilterFrameText;
      
      private var _desTxt:FilterFrameText;
      
      private var _openTimeTxt:FilterFrameText;
      
      private var _questTxt:FilterFrameText;
      
      private var clickRect:Sprite;
      
      private var _group:SelectedButtonGroup;
      
      private var _rankBtn:SelectedButton;
      
      private var _prizeBtn:SelectedButton;
      
      private var prizeView:HalloweenPrizeView;
      
      private var rankView:HalloweenRankView;
      
      private var _helpBtn:SimpleBitmapButton;
      
      private var timer:Timer = new Timer(1000);
      
      private var myTimer:int;
      
      public function HalloweenView()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         titleText = LanguageMgr.GetTranslation("ddt.halloween.view.title");
         this._bg = ComponentFactory.Instance.creat("asset.halloween.bg");
         addToContent(this._bg);
         this._rightbg = ComponentFactory.Instance.creat("asset.halloween.rightBg");
         addToContent(this._rightbg);
         this._rankTxt = ComponentFactory.Instance.creat("asset.halloween.rankTxt");
         addToContent(this._rankTxt);
         this._myCardTxt = ComponentFactory.Instance.creat("asset.halloween.myCardTxt");
         addToContent(this._myCardTxt);
         this._refreshTimeTxt = ComponentFactory.Instance.creat("asset.halloween.refreshTimeTxt");
         addToContent(this._refreshTimeTxt);
         this._desTxt = ComponentFactory.Instance.creat("asset.halloween.desTxt");
         this._desTxt.text = LanguageMgr.GetTranslation("ddt.halloween.view.des",ServerConfigManager.instance.getHalloweenMinNum);
         addToContent(this._desTxt);
         this._openTimeTxt = ComponentFactory.Instance.creat("asset.halloween.openTimeTxt");
         this._openTimeTxt.text = LanguageMgr.GetTranslation("ddt.halloween.view.time",ServerConfigManager.instance.getHalloweenBeginDate,ServerConfigManager.instance.getHalloweenEndDate);
         addToContent(this._openTimeTxt);
         this._questTxt = ComponentFactory.Instance.creat("asset.halloween.questTxt");
         addToContent(this._questTxt);
         this._questTxt.text = LanguageMgr.GetTranslation("ddt.halloween.view.questInfo");
         this._helpBtn = ComponentFactory.Instance.creatComponentByStylename("halloween.frame.helpBtn");
         this.clickRect = new Sprite();
         this.clickRect.graphics.beginFill(15728640,0);
         this.clickRect.graphics.lineStyle();
         this.clickRect.graphics.drawRect(0,0,this._questTxt.width,this._questTxt.height);
         this.clickRect.graphics.endFill();
         addChild(this.clickRect);
         this.clickRect.x = this._questTxt.x;
         this.clickRect.y = this._questTxt.y;
         this.clickRect.buttonMode = true;
         this.clickRect.addEventListener(MouseEvent.CLICK,this.clickRectHandler);
         this._group = new SelectedButtonGroup();
         this._rankBtn = ComponentFactory.Instance.creatComponentByStylename("asset.halloween.rankBtn");
         this._prizeBtn = ComponentFactory.Instance.creatComponentByStylename("asset.halloween.prizeBtn");
         this._group.addSelectItem(this._rankBtn);
         this._group.addSelectItem(this._prizeBtn);
         this.rankView = ComponentFactory.Instance.creatCustomObject("asset.halloween.rankView");
         this.prizeView = ComponentFactory.Instance.creatCustomObject("asset.halloween.prizeView");
         this._group.selectIndex = 1;
         addToContent(this.rankView);
         addToContent(this.prizeView);
         addToContent(this._rankBtn);
         addToContent(this._prizeBtn);
         addToContent(this._helpBtn);
         addToContent(this.clickRect);
         this.rankView.visible = false;
         this.prizeView.visible = true;
      }
      
      private function clickRectHandler(e:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         SocketManager.Instance.out.requestWonderfulActInit(1);
      }
      
      public function mainViewDataload() : void
      {
         this._myCardTxt.text = String(HalloweenManager.instance.mainViewData.mycard);
         this._rankTxt.text = String(HalloweenManager.instance.mainViewData.myrank);
         var date:Date = HalloweenManager.instance.mainViewData.refreshTime;
         var dat:Date = TimeManager.Instance.Now();
         if(dat.time > ServerConfigManager.instance.getHalloweenDateEnd.time)
         {
            this._refreshTimeTxt.text = "";
            return;
         }
         this.myTimer = int((date.time + 600000 - dat.time) / 1000);
         this.timer.start();
      }
      
      private function timerHandler(e:TimerEvent) : void
      {
         if(this.myTimer == 0)
         {
            this.timer.stop();
            SocketManager.Instance.out.halloweenInit();
            return;
         }
         --this.myTimer;
         var min:int = this.myTimer / 60;
         var second:String = this.myTimer % 60 >= 10 ? String(this.myTimer % 60) : "0" + String(this.myTimer % 60);
         this._refreshTimeTxt.text = LanguageMgr.GetTranslation("ddt.loader.halloween.refreshTime",min + ":" + second);
      }
      
      public function dataLoad() : void
      {
         this.rankView.setData();
      }
      
      public function show() : void
      {
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.ALPHA_BLOCKGOUND);
      }
      
      private function initEvent() : void
      {
         this._rankBtn.addEventListener(MouseEvent.CLICK,this.__rankBtnClick);
         this._prizeBtn.addEventListener(MouseEvent.CLICK,this.__prizeBtnClick);
         addEventListener(FrameEvent.RESPONSE,this.__frameEventHandler);
         this._helpBtn.addEventListener(MouseEvent.CLICK,this.helpBtnHandler);
         this.timer.addEventListener(TimerEvent.TIMER,this.timerHandler);
      }
      
      private function helpBtnHandler(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         event.stopImmediatePropagation();
         var helpBd:DisplayObject = ComponentFactory.Instance.creat("halloween.frame.HelpPrompt");
         var helpPage:HelpFrame = ComponentFactory.Instance.creat("halloween.frame.HelpFrame");
         helpPage.setView(helpBd);
         helpPage.titleText = LanguageMgr.GetTranslation("store.view.HelpButtonText");
         LayerManager.Instance.addToLayer(helpPage,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      private function __rankBtnClick(e:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this.prizeView.visible = false;
         this.rankView.visible = true;
      }
      
      private function __prizeBtnClick(e:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this.prizeView.visible = true;
         this.rankView.visible = false;
      }
      
      private function removeEvents() : void
      {
         this._rankBtn.removeEventListener(MouseEvent.CLICK,this.__rankBtnClick);
         this._prizeBtn.removeEventListener(MouseEvent.CLICK,this.__prizeBtnClick);
         removeEventListener(FrameEvent.RESPONSE,this.__frameEventHandler);
         if(Boolean(this.timer))
         {
            this.timer.removeEventListener(TimerEvent.TIMER,this.timerHandler);
         }
      }
      
      private function __frameEventHandler(event:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         switch(event.responseCode)
         {
            case FrameEvent.ESC_CLICK:
            case FrameEvent.CLOSE_CLICK:
               HalloweenManager.instance.hide();
         }
      }
      
      override public function dispose() : void
      {
         super.dispose();
         this.removeEvents();
         ObjectUtils.disposeObject(this._bg);
         this._bg = null;
         ObjectUtils.disposeObject(this._rightbg);
         this._rightbg = null;
         ObjectUtils.disposeObject(this._rankTxt);
         this._rankTxt = null;
         ObjectUtils.disposeObject(this._myCardTxt);
         this._myCardTxt = null;
         ObjectUtils.disposeObject(this._refreshTimeTxt);
         this._refreshTimeTxt = null;
         ObjectUtils.disposeObject(this._desTxt);
         this._desTxt = null;
         ObjectUtils.disposeObject(this._openTimeTxt);
         this._openTimeTxt = null;
         ObjectUtils.disposeObject(this._questTxt);
         this._questTxt = null;
         ObjectUtils.disposeObject(this.clickRect);
         this.clickRect = null;
         ObjectUtils.disposeObject(this._rankBtn);
         this._rankBtn = null;
         ObjectUtils.disposeObject(this._prizeBtn);
         this._prizeBtn = null;
         ObjectUtils.disposeObject(this.prizeView);
         this.prizeView = null;
         ObjectUtils.disposeObject(this.rankView);
         this.rankView = null;
         ObjectUtils.disposeObject(this._helpBtn);
         this._helpBtn = null;
         if(Boolean(this.timer))
         {
            this.timer.stop();
            this.timer = null;
         }
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
   }
}

