package dragonBoat.view
{
   import baglocked.BaglockedManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.ListPanel;
   import com.pickgliss.ui.controls.SelectedButton;
   import com.pickgliss.ui.controls.SelectedButtonGroup;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.ServerConfigInfo;
   import ddt.data.player.PlayerInfo;
   import ddt.events.BagEvent;
   import ddt.events.PlayerPropertyEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.ServerConfigManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import dragonBoat.DragonBoatEvent;
   import dragonBoat.DragonBoatManager;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.text.TextFormat;
   import flash.utils.Timer;
   import store.HelpFrame;
   
   public class DragonBoatFrame extends Frame
   {
      
      private var _bg:Bitmap;
      
      private var _leftDragonBoatSprite:Sprite;
      
      private var _leftPlayerSprite:Sprite;
      
      private var _dragonboatBg:Bitmap;
      
      private var _selfRankBg:Bitmap;
      
      private var _otherRankBg:Bitmap;
      
      private var _smallBorder:Bitmap;
      
      private var _progressBg:Bitmap;
      
      private var _progress:Bitmap;
      
      private var _progressMask:Bitmap;
      
      private var _selfRankSelectedBtn:SelectedButton;
      
      private var _otherRankSelectedBtn:SelectedButton;
      
      private var _btnGroup:SelectedButtonGroup;
      
      private var _selfRankSprite:Sprite;
      
      private var _otherRankSprite:Sprite;
      
      private var _normalDecorateBtn:SimpleBitmapButton;
      
      private var _highDecorateBtn:SimpleBitmapButton;
      
      private var _normalBuildBtn:SimpleBitmapButton;
      
      private var _highBuildBtn:SimpleBitmapButton;
      
      private var _scoreExchangeBtn:SimpleBitmapButton;
      
      private var _helpBtn:SimpleBitmapButton;
      
      private var _progressTxt:FilterFrameText;
      
      private var _timeTxt:FilterFrameText;
      
      private var _itemCountTxt:FilterFrameText;
      
      private var _scoreTxt:FilterFrameText;
      
      private var _scoreTxt2:FilterFrameText;
      
      private var _rankTxt:FilterFrameText;
      
      private var _needTxt:FilterFrameText;
      
      private var _leftBottomTxt:FilterFrameText;
      
      private var _rightBottomTxt:FilterFrameText;
      
      private var _selfRankList:ListPanel;
      
      private var _otherRankList:ListPanel;
      
      private var _selfDataList:Array = [];
      
      private var _selfRank:String = "";
      
      private var _selfLessScore:String = "";
      
      private var _otherDataList:Array = [];
      
      private var _otherRank:String = "";
      
      private var _otherLessScore:String = "";
      
      private var _timer:Timer;
      
      private var _displayMc:MovieClip;
      
      private var _dragonBoatLeftCurrentCharcter:DragonBoatLeftCurrentCharcter;
      
      private var type:int;
      
      private var _playerInfo:PlayerInfo;
      
      public function DragonBoatFrame()
      {
         super();
      }
      
      public function init2(activeID:int) : void
      {
         this.type = activeID;
         this.initView();
         this.initEvent();
         this.refreshView();
         this.refreshItemCount();
         this._btnGroup.selectIndex = 0;
         var tmpStartTime:Date = DragonBoatManager.instance.activeInfo.beginTimeDate;
         var tmpEndTime:Date = DragonBoatManager.instance.activeInfo.endTimeDate;
         this._timeTxt.text = LanguageMgr.GetTranslation("ddt.dragonBoat.timeTxt",tmpStartTime.fullYear,tmpStartTime.month + 1,tmpStartTime.date,tmpEndTime.fullYear,tmpEndTime.month + 1,tmpEndTime.date);
         this.initTimer();
         SocketManager.Instance.out.sendDragonBoatRefreshBoatStatus();
         SocketManager.Instance.out.sendDragonBoatRefreshRank();
         DragonBoatManager.instance.setOpenFrameParam();
      }
      
      private function initView() : void
      {
         if(DragonBoatManager.instance.isBuildEnd)
         {
            titleText = LanguageMgr.GetTranslation("ddt.hall.dragonboatentrybtnTitle");
         }
         else
         {
            titleText = LanguageMgr.GetTranslation("ddt.dragonBoat.frameTitle");
         }
         if(this.type == 1)
         {
            this._bg = ComponentFactory.Instance.creatBitmap("asset.dragonBoat.mainFrame.bg");
         }
         else if(this.type == 4)
         {
            this._bg = ComponentFactory.Instance.creatBitmap("asset.kingStatue.mainFrame.bg");
         }
         this._leftDragonBoatSprite = new Sprite();
         this._leftPlayerSprite = new Sprite();
         this._selfRankBg = ComponentFactory.Instance.creatBitmap("asset.dragonBoat.mainFrame.selfRank.bg");
         this._otherRankBg = ComponentFactory.Instance.creatBitmap("asset.dragonBoat.mainFrame.otherRank.bg");
         this._smallBorder = ComponentFactory.Instance.creatBitmap("asset.dragonBoat.mainFrame.smallBorder");
         this._selfRankSprite = new Sprite();
         PositionUtils.setPos(this._selfRankSprite,"dragonBoat.mainFrame.selfRankPos");
         this._selfRankSprite.addChild(this._selfRankBg);
         this._otherRankSprite = new Sprite();
         PositionUtils.setPos(this._otherRankSprite,"dragonBoat.mainFrame.otherRankPos");
         this._otherRankSprite.addChild(this._otherRankBg);
         this._progressBg = ComponentFactory.Instance.creatBitmap("asset.dragonBoat.mainFrame.progressBg");
         this._progress = ComponentFactory.Instance.creatBitmap("asset.dragonBoat.mainFrame.progress");
         this._progressMask = ComponentFactory.Instance.creatBitmap("asset.dragonBoat.mainFrame.progressBg");
         this._progress.mask = this._progressMask;
         this._selfRankSelectedBtn = ComponentFactory.Instance.creatComponentByStylename("dragonBoat.mainFrame.selfRank.btn");
         this._otherRankSelectedBtn = ComponentFactory.Instance.creatComponentByStylename("dragonBoat.mainFrame.otherRank.btn");
         this._btnGroup = new SelectedButtonGroup();
         this._btnGroup.addSelectItem(this._selfRankSelectedBtn);
         this._btnGroup.addSelectItem(this._otherRankSelectedBtn);
         this._normalDecorateBtn = ComponentFactory.Instance.creatComponentByStylename("dragonBoat.mainFrame.normalDecorateBtn");
         this._highDecorateBtn = ComponentFactory.Instance.creatComponentByStylename("dragonBoat.mainFrame.highDecorateBtn");
         this._normalBuildBtn = ComponentFactory.Instance.creatComponentByStylename("dragonBoat.mainFrame.normalBuildBtn");
         this._highBuildBtn = ComponentFactory.Instance.creatComponentByStylename("dragonBoat.mainFrame.highBuildBtn");
         this._scoreExchangeBtn = ComponentFactory.Instance.creatComponentByStylename("dragonBoat.mainFrame.scoreBtn");
         this._helpBtn = ComponentFactory.Instance.creatComponentByStylename("dragonBoat.mainFrame.helpBtn");
         this._progressTxt = ComponentFactory.Instance.creatComponentByStylename("dragonBoat.mainFrame.progressTxt");
         this._timeTxt = ComponentFactory.Instance.creatComponentByStylename("dragonBoat.mainFrame.timeTxt");
         this._itemCountTxt = ComponentFactory.Instance.creatComponentByStylename("dragonBoat.mainFrame.scoreTxt");
         PositionUtils.setPos(this._itemCountTxt,"dragonBoat.mainFrame.itemCountTxtPos");
         this._scoreTxt = ComponentFactory.Instance.creatComponentByStylename("dragonBoat.mainFrame.scoreTxt");
         PositionUtils.setPos(this._scoreTxt,"dragonBoat.mainFrame.scoreTxt1Pos");
         this._scoreTxt2 = ComponentFactory.Instance.creatComponentByStylename("dragonBoat.mainFrame.scoreTxt");
         PositionUtils.setPos(this._scoreTxt2,"dragonBoat.mainFrame.scoreTxt2Pos");
         this._rankTxt = ComponentFactory.Instance.creatComponentByStylename("dragonBoat.mainFrame.rankTxt");
         this._needTxt = ComponentFactory.Instance.creatComponentByStylename("dragonBoat.mainFrame.needTxt");
         this._leftBottomTxt = ComponentFactory.Instance.creatComponentByStylename("dragonBoat.mainFrame.bottomTxt");
         this._leftBottomTxt.text = LanguageMgr.GetTranslation("ddt.dragonBoat.leftBottomTxt");
         this._rightBottomTxt = ComponentFactory.Instance.creatComponentByStylename("dragonBoat.mainFrame.bottomTxt2");
         var dragonBoatAreaMinScore:String = "";
         var sConfigInfo:ServerConfigInfo = ServerConfigManager.instance.findInfoByName("DragonBoatAreaMinScore");
         if(Boolean(sConfigInfo))
         {
            dragonBoatAreaMinScore = sConfigInfo.Value;
         }
         this._rightBottomTxt.text = LanguageMgr.GetTranslation("ddt.dragonBoat.rightBottomTxt",DragonBoatManager.instance.activeInfo.MinScore,dragonBoatAreaMinScore);
         this._selfRankList = ComponentFactory.Instance.creatComponentByStylename("dragonBoat.mainFrame.selfRankList");
         this._selfRankSprite.addChild(this._selfRankList);
         this._otherRankList = ComponentFactory.Instance.creatComponentByStylename("dragonBoat.mainFrame.otherRankList");
         this._otherRankSprite.addChild(this._otherRankList);
         switch(this.type)
         {
            case 1:
               titleText = LanguageMgr.GetTranslation("ddt.dragonBoat.frameTitle");
               this._bg = ComponentFactory.Instance.creatBitmap("asset.dragonBoat.mainFrame.bg");
               PositionUtils.setPos(this._itemCountTxt,"dragonBoat.mainFrame.itemCountTxtPos");
               this._leftBottomTxt.text = LanguageMgr.GetTranslation("ddt.dragonBoat.leftBottomTxt");
               this._rightBottomTxt.text = LanguageMgr.GetTranslation("ddt.dragonBoat.rightBottomTxt",DragonBoatManager.instance.activeInfo.MinScore,dragonBoatAreaMinScore);
               this._displayMc = ComponentFactory.Instance.creat("asset.dragonBoat.boatMc");
               this._displayMc.scaleX = 1.2;
               this._displayMc.scaleY = 1.2;
               PositionUtils.setPos(this._displayMc,"dragonBoat.shopFrame.boatMcPos");
               this._dragonboatBg = ComponentFactory.Instance.creatBitmap("asset.dragonBoat.mainFrame.dragonboatBg");
               break;
            case 4:
               titleText = LanguageMgr.GetTranslation("kingStatue.title");
               this._bg = ComponentFactory.Instance.creatBitmap("asset.kingStatue.mainFrame.bg");
               PositionUtils.setPos(this._itemCountTxt,"dragonBoat.mainFrame.itemCountTxtPos");
               this._leftBottomTxt.text = LanguageMgr.GetTranslation("kingStatue.leftBottomTxt");
               this._rightBottomTxt.text = LanguageMgr.GetTranslation("ddt.dragonBoat.rightBottomTxt2",DragonBoatManager.instance.activeInfo.MinScore,dragonBoatAreaMinScore);
               this._displayMc = ComponentFactory.Instance.creat("asset.kingStatue.statueFrameMc");
               PositionUtils.setPos(this._displayMc,"kingStatue.mainFrame.statuePos");
               this._dragonboatBg = ComponentFactory.Instance.creatBitmap("asset.kingStatue.mainFrame.kingStatueBg");
         }
         addToContent(this._bg);
         addToContent(this._leftDragonBoatSprite);
         addToContent(this._leftPlayerSprite);
         this._leftDragonBoatSprite.addChild(this._dragonboatBg);
         addToContent(this._selfRankSprite);
         addToContent(this._otherRankSprite);
         addToContent(this._smallBorder);
         this._leftDragonBoatSprite.addChild(this._displayMc);
         this._leftDragonBoatSprite.addChild(this._progress);
         this._leftDragonBoatSprite.addChild(this._progressBg);
         this._leftDragonBoatSprite.addChild(this._progressMask);
         addToContent(this._selfRankSelectedBtn);
         addToContent(this._otherRankSelectedBtn);
         this._leftDragonBoatSprite.addChild(this._normalDecorateBtn);
         this._leftDragonBoatSprite.addChild(this._highDecorateBtn);
         this._leftDragonBoatSprite.addChild(this._normalBuildBtn);
         this._leftDragonBoatSprite.addChild(this._highBuildBtn);
         addToContent(this._scoreExchangeBtn);
         addToContent(this._helpBtn);
         this._leftDragonBoatSprite.addChild(this._progressTxt);
         addToContent(this._timeTxt);
         addToContent(this._itemCountTxt);
         addToContent(this._scoreTxt);
         addToContent(this._scoreTxt2);
         addToContent(this._rankTxt);
         addToContent(this._needTxt);
         addToContent(this._leftBottomTxt);
         addToContent(this._rightBottomTxt);
         if(DragonBoatManager.instance.isBuildEnd)
         {
            this._leftDragonBoatSprite.visible = false;
         }
         else
         {
            this.isShowDragonboat(true);
         }
      }
      
      private function initTimer() : void
      {
         if(DragonBoatManager.instance.isCanBuildOrDecorate)
         {
            this._timer = new Timer(300000);
            this._timer.addEventListener(TimerEvent.TIMER,this.timerHander,false,0,true);
            this._timer.start();
         }
      }
      
      private function timerHander(event:TimerEvent) : void
      {
         SocketManager.Instance.out.sendDragonBoatRefreshBoatStatus();
         SocketManager.Instance.out.sendDragonBoatRefreshRank();
      }
      
      private function refreshView() : void
      {
         var isShowBuild:Boolean = false;
         var isEnable:Boolean = false;
         this._displayMc.gotoAndStop(DragonBoatManager.instance.boatInWhatStatus);
         var completeStatus:int = DragonBoatManager.instance.boatCompleteStatus;
         this._progressMask.scaleX = completeStatus / 100;
         this._progressTxt.text = LanguageMgr.GetTranslation("ddt.dragonBoat.progressTxt",completeStatus);
         this._scoreTxt.text = DragonBoatManager.instance.useableScore + "";
         this._scoreTxt2.text = DragonBoatManager.instance.totalScore + "";
         this._leftDragonBoatSprite.addChild(this._normalDecorateBtn);
         this._leftDragonBoatSprite.addChild(this._highDecorateBtn);
         this._leftDragonBoatSprite.addChild(this._normalBuildBtn);
         this._leftDragonBoatSprite.addChild(this._highBuildBtn);
         if(completeStatus >= 100)
         {
            isShowBuild = false;
         }
         else
         {
            isShowBuild = true;
         }
         if(DragonBoatManager.instance.isCanBuildOrDecorate)
         {
            isEnable = true;
         }
         else
         {
            isEnable = false;
         }
         this.refreshBtnStatus(isShowBuild,isEnable);
      }
      
      private function refreshBtnStatus(isShowBuild:Boolean, isEnable:Boolean) : void
      {
         this._normalDecorateBtn.visible = !isShowBuild;
         this._highDecorateBtn.visible = !isShowBuild;
         this._normalBuildBtn.visible = isShowBuild;
         this._highBuildBtn.visible = isShowBuild;
         this._normalDecorateBtn.enable = isEnable;
         this._highDecorateBtn.enable = isEnable;
         this._normalBuildBtn.enable = isEnable;
         this._highBuildBtn.enable = isEnable;
      }
      
      private function refreshItemCount() : void
      {
         var useChipId:int = 0;
         var num:int = 0;
         if(this.type == 1)
         {
            useChipId = DragonBoatManager.DRAGONBOAT_CHIP;
         }
         else
         {
            useChipId = DragonBoatManager.KINGSTATUE_CHIP;
         }
         this._itemCountTxt.text = PlayerManager.Instance.Self.PropBag.getItemCountByTemplateId(useChipId,false).toString();
         var _item2:int = PlayerManager.Instance.Self.PropBag.getItemCountByTemplateId(DragonBoatManager.LINSHI_CHIP,false);
         if(_item2 > 0)
         {
            num = PlayerManager.Instance.Self.PropBag.getItemCountByTemplateId(useChipId,true) + _item2;
            this._itemCountTxt.text = num.toString();
         }
      }
      
      private function initEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         this._btnGroup.addEventListener(Event.CHANGE,this.__changeHandler,false,0,true);
         this._selfRankSelectedBtn.addEventListener(MouseEvent.CLICK,this.__soundPlay,false,0,true);
         this._otherRankSelectedBtn.addEventListener(MouseEvent.CLICK,this.__soundPlay,false,0,true);
         this._normalBuildBtn.addEventListener(MouseEvent.CLICK,this.consumeHandler,false,0,true);
         this._highBuildBtn.addEventListener(MouseEvent.CLICK,this.consumeHandler,false,0,true);
         this._normalDecorateBtn.addEventListener(MouseEvent.CLICK,this.consumeHandler,false,0,true);
         this._highDecorateBtn.addEventListener(MouseEvent.CLICK,this.consumeHandler,false,0,true);
         this._helpBtn.addEventListener(MouseEvent.CLICK,this.openHelpFrame,false,0,true);
         this._scoreExchangeBtn.addEventListener(MouseEvent.CLICK,this.openShopFrame,false,0,true);
         DragonBoatManager.instance.addEventListener(DragonBoatManager.BUILD_OR_DECORATE_UPDATE,this.buildOrDecorateHandler);
         DragonBoatManager.instance.addEventListener(DragonBoatManager.REFRESH_BOAT_STATUS,this.refreshBoatStatusHandler);
         PlayerManager.Instance.Self.PropBag.addEventListener(BagEvent.UPDATE,this.itemUpdateHandler);
         DragonBoatManager.instance.addEventListener(DragonBoatManager.UPDATE_RANK_INFO,this.updateRankInfo);
      }
      
      private function updateRankInfo(event:DragonBoatEvent) : void
      {
         var rank:int = 0;
         var rank2:int = 0;
         var tag:int = event.tag;
         if(tag == 1)
         {
            this._selfDataList = event.data.dataList;
            rank = int(event.data.myRank);
            if(rank < 0)
            {
               this._selfRank = LanguageMgr.GetTranslation("ddt.dragonBoat.rankNoPlace");
            }
            else
            {
               this._selfRank = rank.toString();
            }
            this._selfLessScore = event.data.lessScore.toString();
            if(this._btnGroup.selectIndex == 0)
            {
               this.refreshRankView(1);
            }
            if(DragonBoatManager.instance.isBuildEnd)
            {
               this.isShowDragonboat(false);
            }
            else
            {
               this.isShowDragonboat(true);
            }
         }
         else
         {
            this._otherDataList = event.data.dataList;
            rank2 = int(event.data.myRank);
            if(rank2 < 0)
            {
               this._otherRank = LanguageMgr.GetTranslation("ddt.dragonBoat.rankNoPlace");
            }
            else
            {
               this._otherRank = rank2.toString();
            }
            this._otherLessScore = event.data.lessScore.toString();
            if(this._btnGroup.selectIndex == 1)
            {
               this.refreshRankView(2);
            }
         }
      }
      
      private function refreshRankView(tag:int) : void
      {
         if(tag == 1)
         {
            this._selfRankList.vectorListModel.clear();
            this._selfRankList.vectorListModel.appendAll(this._selfDataList);
            this._selfRankList.list.updateListView();
            this._rankTxt.text = this._selfRank;
            this._needTxt.text = this._selfLessScore;
         }
         else
         {
            this._otherRankList.vectorListModel.clear();
            this._otherRankList.vectorListModel.appendAll(this._otherDataList);
            this._otherRankList.list.updateListView();
            this._rankTxt.text = this._otherRank;
            this._needTxt.text = this._otherLessScore;
         }
         var _rankTextFormatSize:int = 30;
         if(this._rankTxt.textWidth > this._rankTxt.width)
         {
            _rankTextFormatSize = 14;
            this._rankTxt.y = 420;
         }
         else
         {
            this._rankTxt.y = 413;
         }
         var _txtFormat:TextFormat = this._rankTxt.getTextFormat();
         _txtFormat.size = _rankTextFormatSize;
         this._rankTxt.setTextFormat(_txtFormat);
         this._rankTxt.defaultTextFormat = _txtFormat;
      }
      
      private function openShopFrame(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         var shopFrame:DragonBoatShopFrame = ComponentFactory.Instance.creatComponentByStylename("DragonBoatShopFrame");
         LayerManager.Instance.addToLayer(shopFrame,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      private function openHelpFrame(event:MouseEvent) : void
      {
         var helpBd:DisplayObject = null;
         SoundManager.instance.play("008");
         switch(this.type)
         {
            case 1:
               helpBd = ComponentFactory.Instance.creat("dragonBoat.HelpPrompt");
               break;
            case 4:
               helpBd = ComponentFactory.Instance.creat("dragonBoat.statueHelpPrompt");
         }
         var helpPage:HelpFrame = ComponentFactory.Instance.creat("dragonBoat.HelpFrame");
         helpPage.setView(helpBd);
         helpPage.titleText = LanguageMgr.GetTranslation("store.view.HelpButtonText");
         LayerManager.Instance.addToLayer(helpPage,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      private function refreshBoatStatusHandler(event:Event) : void
      {
         this.refreshView();
      }
      
      private function itemUpdateHandler(event:BagEvent) : void
      {
         this.refreshItemCount();
      }
      
      private function buildOrDecorateHandler(event:Event) : void
      {
         SocketManager.Instance.out.sendDragonBoatRefreshRank();
         this.refreshView();
      }
      
      private function consumeHandler(event:Event) : void
      {
         var normalView:DragonBoatConsumeView = null;
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         var tmp:int = 1;
         switch(event.currentTarget)
         {
            case this._normalBuildBtn:
               tmp = 1;
               break;
            case this._normalDecorateBtn:
               tmp = 2;
               break;
            case this._highBuildBtn:
               tmp = 3;
               break;
            case this._highDecorateBtn:
               tmp = 4;
         }
         switch(tmp)
         {
            case 1:
            case 2:
            case 3:
            case 4:
               if((tmp == 1 || tmp == 2) && int(this._itemCountTxt.text) <= 0)
               {
                  if(this.type == 1)
                  {
                     MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.dragonBoat.noEnoughPiece"),0,true);
                  }
                  else if(this.type == 4)
                  {
                     MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.dragonBoat.statueNoEnoughPiece"),0,true);
                  }
                  return;
               }
               if((tmp == 3 || tmp == 4) && PlayerManager.Instance.Self.Money < 100)
               {
                  LeavePageManager.showFillFrame();
                  return;
               }
               normalView = ComponentFactory.Instance.creatComponentByStylename("DragonBoatNormalView");
               normalView.setView(tmp);
               LayerManager.Instance.addToLayer(normalView,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
               break;
         }
      }
      
      private function __changeHandler(event:Event) : void
      {
         switch(this._btnGroup.selectIndex)
         {
            case 0:
               this._selfRankSelectedBtn.x = 390;
               this._selfRankSelectedBtn.y = 4;
               this._otherRankSelectedBtn.x = 563;
               this._otherRankSelectedBtn.y = 7;
               this._selfRankSprite.visible = true;
               this._otherRankSprite.visible = false;
               this.refreshRankView(1);
               break;
            case 1:
               this._selfRankSelectedBtn.x = 396;
               this._selfRankSelectedBtn.y = 6;
               this._otherRankSelectedBtn.x = 550;
               this._otherRankSelectedBtn.y = 4;
               this._selfRankSprite.visible = false;
               this._otherRankSprite.visible = true;
               this.refreshRankView(2);
         }
      }
      
      private function __soundPlay(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
      }
      
      private function __responseHandler(evt:FrameEvent) : void
      {
         if(evt.responseCode == FrameEvent.CLOSE_CLICK || evt.responseCode == FrameEvent.ESC_CLICK)
         {
            SoundManager.instance.play("008");
            this.dispose();
         }
      }
      
      private function isShowDragonboat(bool:Boolean) : void
      {
         this._leftDragonBoatSprite.visible = bool;
         if(Boolean(this._dragonBoatLeftCurrentCharcter))
         {
            this._dragonBoatLeftCurrentCharcter.visible = !bool;
         }
         if(!bool)
         {
            this.showPlayerNo1();
         }
      }
      
      private function showPlayerNo1() : void
      {
         var tempPlayerObj:Object = null;
         var obj:Object = null;
         if(this._selfDataList.length <= 0)
         {
            return;
         }
         for each(obj in this._selfDataList)
         {
            if(obj.rank == 1)
            {
               tempPlayerObj = obj;
               break;
            }
         }
         this._playerInfo = new PlayerInfo();
         if(tempPlayerObj.name == PlayerManager.Instance.Self.NickName)
         {
            this._playerInfo = PlayerManager.Instance.Self;
         }
         else
         {
            this._playerInfo = PlayerManager.Instance.findPlayerByNickName(this._playerInfo,tempPlayerObj.name);
         }
         if(Boolean(this._playerInfo.ID) && Boolean(this._playerInfo.Style))
         {
            this.initPlayerNo1();
         }
         else
         {
            SocketManager.Instance.out.sendItemEquip(tempPlayerObj.name,true);
            this._playerInfo.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__playerInfoChange);
         }
      }
      
      private function __playerInfoChange(event:PlayerPropertyEvent) : void
      {
         this._playerInfo.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__playerInfoChange);
         this.initPlayerNo1();
      }
      
      private function initPlayerNo1() : void
      {
         if(!this._dragonBoatLeftCurrentCharcter)
         {
            this._dragonBoatLeftCurrentCharcter = new DragonBoatLeftCurrentCharcter();
            this._leftPlayerSprite.addChild(this._dragonBoatLeftCurrentCharcter);
         }
         this._dragonBoatLeftCurrentCharcter.updateInfo(this._playerInfo);
      }
      
      private function removeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         this._btnGroup.removeEventListener(Event.CHANGE,this.__changeHandler);
         this._selfRankSelectedBtn.removeEventListener(MouseEvent.CLICK,this.__soundPlay);
         this._otherRankSelectedBtn.removeEventListener(MouseEvent.CLICK,this.__soundPlay);
         this._normalBuildBtn.removeEventListener(MouseEvent.CLICK,this.consumeHandler);
         this._highBuildBtn.removeEventListener(MouseEvent.CLICK,this.consumeHandler);
         this._normalDecorateBtn.removeEventListener(MouseEvent.CLICK,this.consumeHandler);
         this._highDecorateBtn.removeEventListener(MouseEvent.CLICK,this.consumeHandler);
         this._helpBtn.removeEventListener(MouseEvent.CLICK,this.openHelpFrame);
         this._scoreExchangeBtn.removeEventListener(MouseEvent.CLICK,this.openShopFrame);
         DragonBoatManager.instance.removeEventListener(DragonBoatManager.BUILD_OR_DECORATE_UPDATE,this.buildOrDecorateHandler);
         DragonBoatManager.instance.removeEventListener(DragonBoatManager.REFRESH_BOAT_STATUS,this.refreshBoatStatusHandler);
         PlayerManager.Instance.Self.PropBag.removeEventListener(BagEvent.UPDATE,this.itemUpdateHandler);
         DragonBoatManager.instance.removeEventListener(DragonBoatManager.UPDATE_RANK_INFO,this.updateRankInfo);
         if(Boolean(this._playerInfo))
         {
            this._playerInfo.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__playerInfoChange);
         }
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         if(Boolean(this._dragonBoatLeftCurrentCharcter))
         {
            this._dragonBoatLeftCurrentCharcter.dispose();
         }
         this._dragonBoatLeftCurrentCharcter = null;
         if(Boolean(this._timer))
         {
            this._timer.removeEventListener(TimerEvent.TIMER,this.timerHander);
            this._timer.stop();
            this._timer = null;
         }
         if(Boolean(this._displayMc))
         {
            this._displayMc.gotoAndStop(this._displayMc.totalFrames);
            this._displayMc = null;
         }
         this._selfDataList = null;
         this._otherDataList = null;
         ObjectUtils.disposeObject(this._selfRankList);
         this._selfRankList = null;
         ObjectUtils.disposeObject(this._otherRankList);
         this._otherRankList = null;
         super.dispose();
         this._bg = null;
         this._selfRankBg = null;
         this._otherRankBg = null;
         this._smallBorder = null;
         this._progressBg = null;
         this._progress = null;
         this._progressMask = null;
         this._selfRankSelectedBtn = null;
         this._otherRankSelectedBtn = null;
         this._btnGroup = null;
         this._selfRankSprite = null;
         this._otherRankSprite = null;
         this._normalDecorateBtn = null;
         this._highDecorateBtn = null;
         this._normalBuildBtn = null;
         this._highBuildBtn = null;
         this._scoreExchangeBtn = null;
         this._helpBtn = null;
         this._progressTxt = null;
         this._timeTxt = null;
         this._itemCountTxt = null;
         this._scoreTxt = null;
         this._scoreTxt2 = null;
         this._rankTxt = null;
         this._needTxt = null;
         this._leftBottomTxt = null;
         this._rightBottomTxt = null;
         this._leftDragonBoatSprite = null;
         this._leftPlayerSprite = null;
      }
   }
}

