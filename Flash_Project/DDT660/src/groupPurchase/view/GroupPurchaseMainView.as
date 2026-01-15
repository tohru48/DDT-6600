package groupPurchase.view
{
   import com.pickgliss.events.ComponentEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.TimeManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.geom.Point;
   import flash.utils.Timer;
   import groupPurchase.GroupPurchaseManager;
   import store.HelpFrame;
   import wonderfulActivity.WonderfulActivityManager;
   import wonderfulActivity.views.IRightView;
   
   public class GroupPurchaseMainView extends Sprite implements Disposeable, IRightView
   {
      
      private var _bg:Bitmap;
      
      private var _topBg:Bitmap;
      
      private var _rankBtn:SimpleBitmapButton;
      
      private var _countDownTxt:FilterFrameText;
      
      private var _curDiscountTxt:FilterFrameText;
      
      private var _nextDiscountTxt:FilterFrameText;
      
      private var _nextNeedNumTxt:FilterFrameText;
      
      private var _totalNumTxt:FilterFrameText;
      
      private var _myNumTxt:FilterFrameText;
      
      private var _curRebateTxt:FilterFrameText;
      
      private var _nextRebateTxt:FilterFrameText;
      
      private var _miniNeedNum:FilterFrameText;
      
      private var _shopItemCell:GroupPurchaseShopCell;
      
      private var _rankFrame:GroupPurchaseRankFrame;
      
      private var _recordWonderfulFramePos:Point = new Point();
      
      private var _helpBtn:BaseButton;
      
      private var _endTime:Date;
      
      private var _timer:Timer;
      
      private var _timer2:Timer;
      
      private var _awardView:GroupPurchaseAwardView;
      
      public function GroupPurchaseMainView()
      {
         super();
         GroupPurchaseManager.instance.loadResModule(this.initThis);
      }
      
      private function initThis() : void
      {
         PositionUtils.setPos(this,"groupPurchase.mainViewPos");
         this.initView();
         this.initEvent();
         this.initCountDown();
         this.initRefreshData();
      }
      
      private function initView() : void
      {
         this._bg = ComponentFactory.Instance.creatBitmap("asset.groupPurchase.bg");
         this._topBg = ComponentFactory.Instance.creatBitmap("asset.groupPurchase.topBg");
         this._countDownTxt = ComponentFactory.Instance.creatComponentByStylename("groupPurchase.countDownTxt");
         this._curDiscountTxt = ComponentFactory.Instance.creatComponentByStylename("groupPurchase.countDownTxt");
         PositionUtils.setPos(this._curDiscountTxt,"groupPurchase.curDiscountTxtPos");
         this._nextDiscountTxt = ComponentFactory.Instance.creatComponentByStylename("groupPurchase.countDownTxt");
         PositionUtils.setPos(this._nextDiscountTxt,"groupPurchase.nextDiscountTxtPos");
         this._nextNeedNumTxt = ComponentFactory.Instance.creatComponentByStylename("groupPurchase.nextNeedNumTxt");
         this._totalNumTxt = ComponentFactory.Instance.creatComponentByStylename("groupPurchase.totalNumTxt");
         this._myNumTxt = ComponentFactory.Instance.creatComponentByStylename("groupPurchase.totalNumTxt");
         PositionUtils.setPos(this._myNumTxt,"groupPurchase.myNumTxtPos");
         this._curRebateTxt = ComponentFactory.Instance.creatComponentByStylename("groupPurchase.totalNumTxt");
         PositionUtils.setPos(this._curRebateTxt,"groupPurchase.curRebatePos");
         this._nextRebateTxt = ComponentFactory.Instance.creatComponentByStylename("groupPurchase.totalNumTxt");
         PositionUtils.setPos(this._nextRebateTxt,"groupPurchase.nextRebatePos");
         this._miniNeedNum = ComponentFactory.Instance.creatComponentByStylename("groupPurchase.miniNeedNumTxt");
         this._miniNeedNum.text = LanguageMgr.GetTranslation("ddt.groupPurchase.miniNeedNumTxt",GroupPurchaseManager.instance.miniNeedNum);
         this._shopItemCell = new GroupPurchaseShopCell();
         PositionUtils.setPos(this._shopItemCell,"groupPurchase.shopItemCellPos");
         this._helpBtn = ComponentFactory.Instance.creatComponentByStylename("groupPurchase.HelpButton");
         this._rankBtn = ComponentFactory.Instance.creatComponentByStylename("groupPurchase.rankBtn");
         this._awardView = new GroupPurchaseAwardView();
         addChild(this._bg);
         addChild(this._topBg);
         addChild(this._countDownTxt);
         addChild(this._curDiscountTxt);
         addChild(this._nextDiscountTxt);
         addChild(this._nextNeedNumTxt);
         addChild(this._totalNumTxt);
         addChild(this._myNumTxt);
         addChild(this._curRebateTxt);
         addChild(this._nextRebateTxt);
         addChild(this._miniNeedNum);
         addChild(this._shopItemCell);
         addChild(this._awardView);
         addChild(this._helpBtn);
         addChild(this._rankBtn);
      }
      
      private function initEvent() : void
      {
         this._helpBtn.addEventListener(MouseEvent.CLICK,this.helpBtnClickHandler,false,0,true);
         this._rankBtn.addEventListener(MouseEvent.CLICK,this.rankBtnClickHandler,false,0,true);
         GroupPurchaseManager.instance.addEventListener(GroupPurchaseManager.REFRESH_DATA,this.refreshView);
      }
      
      private function initCountDown() : void
      {
         this._endTime = GroupPurchaseManager.instance.endTime;
         this._timer = new Timer(1000);
         this._timer.addEventListener(TimerEvent.TIMER,this.refreshCountDownTime,false,0,true);
         this._timer.start();
         this.refreshCountDownTime(null);
      }
      
      private function initRefreshData() : void
      {
         this._timer2 = new Timer(this.getRefreshDelay());
         this._timer2.addEventListener(TimerEvent.TIMER,this.requestRefreshData,false,0,true);
         this._timer2.start();
         SocketManager.Instance.out.sendGroupPurchaseRefreshData();
      }
      
      private function requestRefreshData(event:TimerEvent) : void
      {
         SocketManager.Instance.out.sendGroupPurchaseRefreshData();
         this._timer2.delay = this.getRefreshDelay();
      }
      
      private function getRefreshDelay() : int
      {
         var differ:Number = (this._endTime.getTime() - TimeManager.Instance.Now().getTime()) / 1000;
         if(differ > 3600)
         {
            return 180000;
         }
         return 15000;
      }
      
      private function helpBtnClickHandler(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         event.stopImmediatePropagation();
         var helpBd:DisplayObject = ComponentFactory.Instance.creat("groupPurchase.HelpPrompt");
         var helpPage:HelpFrame = ComponentFactory.Instance.creat("groupPurchase.HelpFrame");
         helpPage.setView(helpBd);
         helpPage.titleText = LanguageMgr.GetTranslation("store.view.HelpButtonText");
         LayerManager.Instance.addToLayer(helpPage,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      private function rankBtnClickHandler(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         var tmpFrame:Frame = WonderfulActivityManager.Instance.frame;
         if(!tmpFrame)
         {
            tmpFrame = ComponentFactory.Instance.creatComponentByStylename("com.wonderfulActivity.LimitActivityFrame");
         }
         if(!this._rankFrame)
         {
            this._rankFrame = ComponentFactory.Instance.creatComponentByStylename("GroupPurchaseRankFrame");
            this._rankFrame.addEventListener(ComponentEvent.DISPOSE,this.rankFrameDisposeHandler,false,0,true);
            LayerManager.Instance.addToLayer(this._rankFrame,LayerManager.GAME_TOP_LAYER,false);
            this._recordWonderfulFramePos.x = tmpFrame.x;
            this._recordWonderfulFramePos.y = tmpFrame.y;
            PositionUtils.setPos(this._rankFrame,"groupPurchase.rankFramePos");
            PositionUtils.setPos(tmpFrame,"groupPurchase.wonderfulFramePos");
         }
         else
         {
            ObjectUtils.disposeObject(this._rankFrame);
         }
      }
      
      private function rankFrameDisposeHandler(event:ComponentEvent) : void
      {
         this._rankFrame.removeEventListener(ComponentEvent.DISPOSE,this.rankFrameDisposeHandler);
         this._rankFrame = null;
      }
      
      private function refreshView(event:Event) : void
      {
         var viewData:Array = GroupPurchaseManager.instance.viewData;
         this._curDiscountTxt.text = viewData[0] + "%";
         if(viewData[1] == -1)
         {
            this._nextDiscountTxt.text = LanguageMgr.GetTranslation("ddt.groupPurchase.discountHighestTxt");
         }
         else
         {
            this._nextDiscountTxt.text = viewData[1] + "%";
         }
         if(viewData[2] == -1)
         {
            this._nextNeedNumTxt.text = "";
         }
         else
         {
            this._nextNeedNumTxt.text = LanguageMgr.GetTranslation("ddt.groupPurchase.nextNeedNumTxt",viewData[2]);
         }
         this._totalNumTxt.text = viewData[3];
         this._myNumTxt.text = viewData[4];
         this._curRebateTxt.text = viewData[5];
         this._nextRebateTxt.text = viewData[6];
      }
      
      private function refreshCountDownTime(event:TimerEvent) : void
      {
         this._countDownTxt.text = TimeManager.Instance.getMaxRemainDateStr(this._endTime);
      }
      
      public function init() : void
      {
      }
      
      public function content() : Sprite
      {
         return this;
      }
      
      public function setState(type:int, id:int) : void
      {
      }
      
      private function removeEvent() : void
      {
         if(Boolean(this._helpBtn))
         {
            this._helpBtn.removeEventListener(MouseEvent.CLICK,this.helpBtnClickHandler);
         }
         if(Boolean(this._rankBtn))
         {
            this._rankBtn.removeEventListener(MouseEvent.CLICK,this.rankBtnClickHandler);
         }
         GroupPurchaseManager.instance.removeEventListener(GroupPurchaseManager.REFRESH_DATA,this.refreshView);
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         if(Boolean(this._timer))
         {
            this._timer.removeEventListener(TimerEvent.TIMER,this.refreshCountDownTime);
            this._timer.stop();
         }
         this._timer = null;
         if(Boolean(this._timer2))
         {
            this._timer2.removeEventListener(TimerEvent.TIMER,this.requestRefreshData);
            this._timer2.stop();
         }
         this._timer2 = null;
         this._recordWonderfulFramePos = null;
         ObjectUtils.disposeAllChildren(this);
         this._bg = null;
         this._topBg = null;
         this._countDownTxt = null;
         this._curDiscountTxt = null;
         this._nextDiscountTxt = null;
         this._nextNeedNumTxt = null;
         this._totalNumTxt = null;
         this._myNumTxt = null;
         this._curRebateTxt = null;
         this._nextRebateTxt = null;
         this._miniNeedNum = null;
         this._shopItemCell = null;
         this._helpBtn = null;
         this._rankBtn = null;
         this._awardView = null;
         if(Boolean(this._rankFrame))
         {
            this._rankFrame.removeEventListener(ComponentEvent.DISPOSE,this.rankFrameDisposeHandler);
            ObjectUtils.disposeObject(this._rankFrame);
         }
         this._rankFrame = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

