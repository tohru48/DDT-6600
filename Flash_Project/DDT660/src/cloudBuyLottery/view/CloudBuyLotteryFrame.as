package cloudBuyLottery.view
{
   import bagAndInfo.cell.BagCell;
   import baglocked.BaglockedManager;
   import cloudBuyLottery.CloudBuyLotteryManager;
   import com.greensock.TweenLite;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.toplevel.StageReferance;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.core.Component;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ClassUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import store.HelpFrame;
   
   public class CloudBuyLotteryFrame extends Frame
   {
      
      public static var logFrameFlag:Boolean;
      
      public static const MOVE_SPEED:Number = 0.8;
      
      private var _bg:Bitmap;
      
      private var showTimes:MovieClip;
      
      private var timeArray:Array;
      
      private var _timer:Timer;
      
      private var _helpBtn:BaseButton;
      
      private var _jubaoBtn:BaseButton;
      
      private var _buyBtn:BaseButton;
      
      private var _finish:Bitmap;
      
      private var _expBar:ExpBar;
      
      private var _luckNumTxt:FilterFrameText;
      
      private var _chanceTxt:FilterFrameText;
      
      private var _showBuyNumTxt:FilterFrameText;
      
      private var _buyNumTxt:FilterFrameText;
      
      private var _buyGoodsMoneyTxt:FilterFrameText;
      
      private var _helpTxt:FilterFrameText;
      
      private var _tipsframe:BaseAlerFrame;
      
      private var _inputBg:Bitmap;
      
      private var _inputText:FilterFrameText;
      
      private var _moneyNumText:FilterFrameText;
      
      private var _maxBtn:SimpleBitmapButton;
      
      private var _text:FilterFrameText;
      
      private var _cell:BagCell;
      
      private var _logTxt:FilterFrameText;
      
      private var _logSprite:Sprite;
      
      private var winningLogFrame:TheWinningLog;
      
      private var _infoWidth:Number;
      
      private var _numberK:Bitmap;
      
      private var _numberKTxt:FilterFrameText;
      
      private var luckLooteryFrame:IndividualLottery;
      
      private var _buyGoodsSprite:Component;
      
      public function CloudBuyLotteryFrame()
      {
         super();
         this.initView();
         this.addEvent();
      }
      
      private function initView() : void
      {
         _titleText = LanguageMgr.GetTranslation("CloudBuyLotteryFrame.title");
         this._bg = ComponentFactory.Instance.creatBitmap("asset.cloudbuy.bg");
         this.showTimes = ClassUtils.CreatInstance("asset.cloudbuy.showTime") as MovieClip;
         PositionUtils.setPos(this.showTimes,"CloudBuyLotteryFrame.showTimesMC");
         this._helpBtn = ComponentFactory.Instance.creat("CloudBuyLotteryFrame.helpBtn");
         this._jubaoBtn = ComponentFactory.Instance.creat("CloudBuyLotteryFrame.jubaoBtn");
         this._buyBtn = ComponentFactory.Instance.creat("CloudBuyLotteryFrame.buyBtn");
         this._finish = ComponentFactory.Instance.creatBitmap("asset.cloudbuy.finish");
         this._expBar = ComponentFactory.Instance.creatComponentByStylename("CloudBuyLotteryFrame.expBar");
         this._luckNumTxt = ComponentFactory.Instance.creatComponentByStylename("CloudBuyLotteryFrame.luckNumTxt");
         this._luckNumTxt.text = CloudBuyLotteryManager.Instance.model.luckCount.toString();
         this._chanceTxt = ComponentFactory.Instance.creatComponentByStylename("CloudBuyLotteryFrame.chanceTxt");
         this._chanceTxt.text = CloudBuyLotteryManager.Instance.model.luckCount + "/" + CloudBuyLotteryManager.Instance.model.maxNum;
         this._showBuyNumTxt = ComponentFactory.Instance.creatComponentByStylename("CloudBuyLotteryFrame.showBuyNumTxt");
         this._showBuyNumTxt.text = LanguageMgr.GetTranslation("CloudBuyLotteryFrame.showBuyNum");
         this._buyNumTxt = ComponentFactory.Instance.creatComponentByStylename("CloudBuyLotteryFrame.buyNumTxt");
         this._buyNumTxt.text = CloudBuyLotteryManager.Instance.model.currentNum.toString();
         this._buyGoodsMoneyTxt = ComponentFactory.Instance.creatComponentByStylename("CloudBuyLotteryFrame.buyGoodsMoneyTxt");
         this._buyGoodsMoneyTxt.text = LanguageMgr.GetTranslation("cloudBuyLotteryFrame.buyGoodsMoneyTxt",CloudBuyLotteryManager.Instance.model.buyMoney.toString());
         this._helpTxt = ComponentFactory.Instance.creatComponentByStylename("CloudBuyLotteryFrame.helpTxt");
         this._helpTxt.text = LanguageMgr.GetTranslation("CloudBuyLotteryFrame.help");
         this._logTxt = ComponentFactory.Instance.creatComponentByStylename("CloudBuyLotteryFrame.logTxt");
         this._logTxt.text = LanguageMgr.GetTranslation("CloudBuyLotteryFrame.log");
         this._logSprite = new Sprite();
         this._logSprite.addChild(this._logTxt);
         this._logSprite.buttonMode = true;
         PositionUtils.setPos(this._logSprite,"CloudBuyLotteryFrame.logSprite");
         this._numberK = ComponentFactory.Instance.creatBitmap("asset.cloudbuy.numberK");
         this._numberKTxt = ComponentFactory.Instance.creatComponentByStylename("CloudBuyLotteryFrame.numberKTxt");
         this._numberKTxt.text = CloudBuyLotteryManager.Instance.model.remainTimes.toString();
         addToContent(this._bg);
         addToContent(this.showTimes);
         addToContent(this._helpBtn);
         addToContent(this._jubaoBtn);
         addToContent(this._buyBtn);
         addToContent(this._finish);
         addToContent(this._expBar);
         addToContent(this._luckNumTxt);
         addToContent(this._chanceTxt);
         addToContent(this._showBuyNumTxt);
         addToContent(this._buyNumTxt);
         addToContent(this._buyGoodsMoneyTxt);
         addToContent(this._helpTxt);
         addToContent(this._logSprite);
         addToContent(this._numberK);
         addToContent(this._numberKTxt);
         this.timesNum();
         this.luckGoodsCell(CloudBuyLotteryManager.Instance.model.templateId);
         this.buyGoodsCell(CloudBuyLotteryManager.Instance.model.buyGoodsIDArray);
         this._timer = new Timer(1000);
         this._timer.addEventListener(TimerEvent.TIMER,this.__updateTimes);
         this._timer.start();
      }
      
      private function addEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         this._helpBtn.addEventListener(MouseEvent.CLICK,this.__onHelpClick);
         this._buyBtn.addEventListener(MouseEvent.CLICK,this.__onBuyClick);
         this._jubaoBtn.addEventListener(MouseEvent.CLICK,this.__onJuBaoClick);
         this._logSprite.addEventListener(MouseEvent.CLICK,this.__onLogClick);
         CloudBuyLotteryManager.Instance.addEventListener(CloudBuyLotteryManager.UPDATE_INFO,this.__updateInfo);
         CloudBuyLotteryManager.Instance.addEventListener(CloudBuyLotteryManager.FRAMEUPDATE,this.__frmeUpdateInfo);
      }
      
      private function removeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         this._helpBtn.removeEventListener(MouseEvent.CLICK,this.__onHelpClick);
         this._buyBtn.removeEventListener(MouseEvent.CLICK,this.__onBuyClick);
         this._jubaoBtn.removeEventListener(MouseEvent.CLICK,this.__onJuBaoClick);
         this._logSprite.removeEventListener(MouseEvent.CLICK,this.__onLogClick);
         CloudBuyLotteryManager.Instance.removeEventListener(CloudBuyLotteryManager.UPDATE_INFO,this.__updateInfo);
         CloudBuyLotteryManager.Instance.removeEventListener(CloudBuyLotteryManager.FRAMEUPDATE,this.__frmeUpdateInfo);
      }
      
      override public function set width(w:Number) : void
      {
         super.width = w;
         this._infoWidth = w;
      }
      
      private function __updateInfo(e:Event) : void
      {
         this.timesNum();
         this.luckGoodsCell(CloudBuyLotteryManager.Instance.model.templateId);
         this.buyGoodsCell(CloudBuyLotteryManager.Instance.model.buyGoodsIDArray);
         this._buyNumTxt.text = CloudBuyLotteryManager.Instance.model.currentNum.toString();
         this._chanceTxt.text = CloudBuyLotteryManager.Instance.model.luckCount + "/" + CloudBuyLotteryManager.Instance.model.maxNum;
         this._luckNumTxt.text = CloudBuyLotteryManager.Instance.model.luckCount.toString();
         this._numberKTxt.text = CloudBuyLotteryManager.Instance.model.remainTimes.toString();
         var num:int = CloudBuyLotteryManager.Instance.model.maxNum - CloudBuyLotteryManager.Instance.model.currentNum;
         CloudBuyLotteryManager.Instance.expBar.initBar(num,CloudBuyLotteryManager.Instance.model.maxNum);
      }
      
      private function __frmeUpdateInfo(e:Event) : void
      {
         this._numberKTxt.text = CloudBuyLotteryManager.Instance.model.remainTimes.toString();
      }
      
      private function __onLogClick(evt:MouseEvent) : void
      {
         var totalWidth:int = 0;
         if(!logFrameFlag)
         {
            logFrameFlag = true;
            this.winningLogFrame = ComponentFactory.Instance.creatComponentByStylename("winningLogFrame.frame");
            this.winningLogFrame.addEventListener(FrameEvent.RESPONSE,this.__onclose);
            addChildAt(this.winningLogFrame,0);
            totalWidth = this._infoWidth + this.winningLogFrame.width;
            TweenLite.to(this,MOVE_SPEED,{"x":(StageReferance.stage.stageWidth - totalWidth) / 2});
            TweenLite.to(this.winningLogFrame,MOVE_SPEED,{"x":this._infoWidth});
         }
         else
         {
            logFrameFlag = false;
            this.hideFrame();
         }
      }
      
      public function hideFrame() : void
      {
         TweenLite.to(this,MOVE_SPEED,{"x":(StageReferance.stage.stageWidth - this._infoWidth) / 2});
         TweenLite.to(this.winningLogFrame,MOVE_SPEED,{
            "x":this.winningLogFrame.width,
            "onComplete":this.releaseRight,
            "onCompleteParams":[this.winningLogFrame]
         });
         this.winningLogFrame = null;
      }
      
      private function releaseRight(frame:Frame) : void
      {
         if(Boolean(frame))
         {
            frame.removeEventListener(FrameEvent.RESPONSE,this.__onclose);
         }
         ObjectUtils.disposeObject(frame);
      }
      
      protected function __onclose(event:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         switch(event.responseCode)
         {
            case FrameEvent.ESC_CLICK:
            case FrameEvent.CLOSE_CLICK:
            case FrameEvent.CANCEL_CLICK:
               this.hideFrame();
         }
      }
      
      private function __onBuyClick(evt:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(!CloudBuyLotteryManager.Instance.model.isGame)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("cloudBuyLottery.isGameOver"));
            return;
         }
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         if(PlayerManager.Instance.Self.Money < CloudBuyLotteryManager.Instance.model.buyMoney)
         {
            LeavePageManager.showFillFrame();
            return;
         }
         this._tipsframe = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("CloudBuyLotteryFrame.buy.tips"),"","",LanguageMgr.GetTranslation("cancel"),true,true,false,2,null,"SimpleAlert2");
         this._tipsframe.width = 360;
         this._tipsframe.height = 200;
         this._text = ComponentFactory.Instance.creatComponentByStylename("CloudBuyLotteryFrame.tipsframeText");
         this._text.text = LanguageMgr.GetTranslation("CloudBuyLotteryFrame.autoOpenCount.text");
         PositionUtils.setPos(this._text,"CloudBuyLotteryFrame.autoOpenCount.textPos");
         this._inputBg = ComponentFactory.Instance.creatBitmap("bagAndInfo.openBatchView.inputBg");
         this._inputText = ComponentFactory.Instance.creatComponentByStylename("CloudBuyLotteryFrame.inputTxt");
         this._inputText.text = "1";
         PositionUtils.setPos(this._inputBg,"CloudBuyLotteryFrame.autoOpenCount.textPos1");
         PositionUtils.setPos(this._inputText,"CloudBuyLotteryFrame.autoOpenCount.textPos2");
         this._maxBtn = ComponentFactory.Instance.creatComponentByStylename("openBatchView.maxBtn");
         PositionUtils.setPos(this._maxBtn,"CloudBuyLotteryFrame.autoOpenCount.textPos3");
         this._moneyNumText = ComponentFactory.Instance.creatComponentByStylename("CloudBuyLotteryFrame.moneyNumText");
         this._tipsframe.addToContent(this._text);
         this._tipsframe.addToContent(this._inputBg);
         this._tipsframe.addToContent(this._inputText);
         this._tipsframe.addToContent(this._maxBtn);
         this._tipsframe.addToContent(this._moneyNumText);
         this._tipsframe.addEventListener(FrameEvent.RESPONSE,this.__onResponse);
         this._maxBtn.addEventListener(MouseEvent.CLICK,this.changeMaxHandler,false,0,true);
         this._inputText.addEventListener(Event.CHANGE,this.inputTextChangeHandler,false,0,true);
         this.showMoneyNum();
      }
      
      private function changeMaxHandler(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this._inputText.text = this._buyNumTxt.text;
         this.showMoneyNum();
      }
      
      private function inputTextChangeHandler(event:Event) : void
      {
         var maxNum:int = int(this._buyNumTxt.text);
         var num:int = int(this._inputText.text);
         if(num > maxNum)
         {
            this._inputText.text = maxNum.toString();
         }
         else if(num < 1)
         {
            this._inputText.text = "1";
         }
         this.showMoneyNum();
      }
      
      private function showMoneyNum() : void
      {
         var money:int = int(this._inputText.text) * CloudBuyLotteryManager.Instance.model.buyMoney;
         this._moneyNumText.htmlText = LanguageMgr.GetTranslation("CloudBuyLotteryFrame.moneyNumText.LG",money);
      }
      
      private function __onResponse(evt:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         var currentValue:int = int(this._inputText.text);
         if(evt.responseCode == FrameEvent.ENTER_CLICK || evt.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            SocketManager.Instance.out.sendYGBuyGoods(currentValue);
         }
         if(Boolean(this._tipsframe))
         {
            this._tipsframe.removeEventListener(FrameEvent.RESPONSE,this.__onResponse);
            ObjectUtils.disposeAllChildren(this._tipsframe);
            ObjectUtils.disposeObject(this._tipsframe);
            this._tipsframe = null;
         }
      }
      
      private function __onJuBaoClick(evt:MouseEvent) : void
      {
         if(this.luckLooteryFrame != null)
         {
            ObjectUtils.disposeObject(this.luckLooteryFrame);
            this.luckLooteryFrame = null;
         }
         if(this.luckLooteryFrame == null)
         {
            this.luckLooteryFrame = ComponentFactory.Instance.creatComponentByStylename("individualLottery.frame");
            LayerManager.Instance.addToLayer(this.luckLooteryFrame,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
         }
      }
      
      private function luckGoodsCell(id:int) : void
      {
         var itemInfo:ItemTemplateInfo = ItemManager.Instance.getTemplateById(id) as ItemTemplateInfo;
         var tInfo:InventoryItemInfo = new InventoryItemInfo();
         ObjectUtils.copyProperties(tInfo,itemInfo);
         tInfo.ValidDate = CloudBuyLotteryManager.Instance.model.validDate;
         tInfo.StrengthenLevel = CloudBuyLotteryManager.Instance.model.property[0];
         tInfo.AttackCompose = CloudBuyLotteryManager.Instance.model.property[1];
         tInfo.DefendCompose = CloudBuyLotteryManager.Instance.model.property[2];
         tInfo.LuckCompose = CloudBuyLotteryManager.Instance.model.property[3];
         tInfo.AgilityCompose = CloudBuyLotteryManager.Instance.model.property[4];
         tInfo.IsBinds = true;
         if(this._cell != null)
         {
            ObjectUtils.disposeObject(this._cell);
            this._cell = null;
         }
         this._cell = new BagCell(0,tInfo);
         PositionUtils.setPos(this._cell,"CloudBuyLotteryFrame.cellPos");
         this._cell.setContentSize(78,78);
         this._cell.setCount(CloudBuyLotteryManager.Instance.model.templatedIdCount);
         this._cell.setBgVisible(false);
         addToContent(this._cell);
      }
      
      private function buyGoodsCell(id:Array) : void
      {
         var itemInfo:ItemTemplateInfo = null;
         var tInfo:InventoryItemInfo = null;
         var count:int = 0;
         var goodsName:String = "";
         for(var i:int = 0; i < id.length; i++)
         {
            itemInfo = ItemManager.Instance.getTemplateById(id[i]) as ItemTemplateInfo;
            tInfo = new InventoryItemInfo();
            ObjectUtils.copyProperties(tInfo,itemInfo);
            count = int(CloudBuyLotteryManager.Instance.model.buyGoodsCountArray[i]);
            goodsName += LanguageMgr.GetTranslation("cloudBuyLotteryFrame.buyGoodsTip",tInfo.Name,count);
         }
         this._buyGoodsSprite = ComponentFactory.Instance.creatComponentByStylename("cloudBuyLotteryFrame.tipData");
         this._buyGoodsSprite.tipData = goodsName.substring(0,goodsName.length - 1);
         this._buyGoodsSprite.buttonMode = true;
         var _goodsImg:Bitmap = ComponentFactory.Instance.creatBitmap("asset.IndividualLottery.goods");
         this._buyGoodsSprite.addChild(_goodsImg);
         addToContent(this._buyGoodsSprite);
      }
      
      private function __updateTimes(evt:TimerEvent) : void
      {
         this.timesNum();
      }
      
      private function timesNum() : void
      {
         var hoursTen:int = 0;
         var hoursBit:int = 0;
         var minutesTen:int = 0;
         var minutesBit:int = 0;
         var secondsTen:int = 0;
         var secondsBit:int = 0;
         if(CloudBuyLotteryManager.Instance.model.isGame)
         {
            this.timeArray = CloudBuyLotteryManager.Instance.refreshTimePlayTxt().split(":");
            hoursTen = CloudBuyLotteryManager.Instance.returnTen(this.timeArray[0]);
            hoursBit = CloudBuyLotteryManager.Instance.returnABit(this.timeArray[0]);
            minutesTen = CloudBuyLotteryManager.Instance.returnTen(this.timeArray[1]);
            minutesBit = CloudBuyLotteryManager.Instance.returnABit(this.timeArray[1]);
            secondsTen = CloudBuyLotteryManager.Instance.returnTen(this.timeArray[2]);
            secondsBit = CloudBuyLotteryManager.Instance.returnABit(this.timeArray[2]);
            this.showTimes.hourTen.gotoAndStop(hoursTen);
            this.showTimes.hourBit.gotoAndStop(hoursBit);
            this.showTimes.minutesTen.gotoAndStop(minutesTen);
            this.showTimes.minutesBit.gotoAndStop(minutesBit);
            this.showTimes.secondsTen.gotoAndStop(secondsTen);
            this.showTimes.secondsBit.gotoAndStop(secondsBit);
         }
         else
         {
            this._luckNumTxt.text = "0";
            this._chanceTxt.text = "0/0";
            this.showTimes.hourTen.gotoAndStop(0);
            this.showTimes.hourBit.gotoAndStop(0);
            this.showTimes.minutesTen.gotoAndStop(0);
            this.showTimes.minutesBit.gotoAndStop(0);
            this.showTimes.secondsTen.gotoAndStop(0);
            this.showTimes.secondsBit.gotoAndStop(0);
            if(this._timer != null)
            {
               this._timer.stop();
            }
         }
      }
      
      protected function __onHelpClick(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         var helpBd:DisplayObject = ComponentFactory.Instance.creat("CloudBuyLotteryFrame.HelpPrompt");
         var helpPage:HelpFrame = ComponentFactory.Instance.creat("CloudBuyLotteryFrame.HelpFrame");
         helpPage.setView(helpBd);
         helpPage.titleText = LanguageMgr.GetTranslation("store.view.HelpButtonText");
         LayerManager.Instance.addToLayer(helpPage,LayerManager.STAGE_DYANMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      private function __responseHandler(evt:FrameEvent) : void
      {
         if(evt.responseCode == FrameEvent.CLOSE_CLICK || evt.responseCode == FrameEvent.ESC_CLICK)
         {
            SoundManager.instance.play("008");
            this.dispose();
         }
      }
      
      public function get expBar() : ExpBar
      {
         return this._expBar;
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         if(Boolean(this._timer))
         {
            this._timer.stop();
            this._timer.removeEventListener(TimerEvent.TIMER,this.__updateTimes);
            this._timer = null;
         }
         ObjectUtils.disposeAllChildren(this);
         super.dispose();
         if(Boolean(this._expBar))
         {
            ObjectUtils.disposeObject(this._expBar);
         }
         this._expBar = null;
         if(Boolean(this._cell))
         {
            ObjectUtils.disposeObject(this._cell);
         }
         this._cell = null;
         if(Boolean(this.luckLooteryFrame))
         {
            ObjectUtils.disposeObject(this.luckLooteryFrame);
         }
         this.luckLooteryFrame = null;
         if(Boolean(this.winningLogFrame))
         {
            ObjectUtils.disposeObject(this.winningLogFrame);
         }
         this.winningLogFrame = null;
         this._bg = null;
         this.showTimes = null;
      }
   }
}

