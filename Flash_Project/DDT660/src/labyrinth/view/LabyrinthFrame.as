package labyrinth.view
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.SelectedCheckButton;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.controls.container.SimpleTileList;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.vo.AlertInfo;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.BagInfo;
   import ddt.data.EquipType;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddtBuried.BuriedManager;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import labyrinth.LabyrinthManager;
   import labyrinth.data.LabyrinthModel;
   import room.model.RoomInfo;
   import roulette.HelpFrame;
   import shop.view.BuySingleGoodsView;
   
   public class LabyrinthFrame extends BaseAlerFrame
   {
      
      private var _bg:ScaleBitmapImage;
      
      private var _rightBg:Bitmap;
      
      private var _leftBg:Bitmap;
      
      private var _startGameBtn:SimpleBitmapButton;
      
      private var _continueBtn:SimpleBitmapButton;
      
      private var _cleanOutBtn:SimpleBitmapButton;
      
      private var _continueCleanOutBtn:SimpleBitmapButton;
      
      private var _resetBtn:SimpleBitmapButton;
      
      private var _rankingBtn:SimpleBitmapButton;
      
      private var _shopBtn:SimpleBitmapButton;
      
      private var _helpBtn:SimpleBitmapButton;
      
      private var _myRanking:Bitmap;
      
      private var _myRankingText:FilterFrameText;
      
      private var _myProgress:Bitmap;
      
      private var _myProgressText:FilterFrameText;
      
      private var _titleList:SimpleTileList;
      
      private var _doubleAward:SelectedCheckButton;
      
      private var _todayNum:Bitmap;
      
      private var _todayNumText:FilterFrameText;
      
      private var _explain:FilterFrameText;
      
      private var _explainII:FilterFrameText;
      
      private var _currentFloor:FilterFrameText;
      
      private var _currentFloorNum:FilterFrameText;
      
      private var _accumulateExp:FilterFrameText;
      
      private var _accumulateExpNum:FilterFrameText;
      
      private var _buySingleGoodsView:BuySingleGoodsView;
      
      private var _isDoubleAward:Boolean = true;
      
      private var _cleanOutContainer:Sprite;
      
      private var _startContainer:Sprite;
      
      private var _serverDoubleIcon:Bitmap;
      
      private var _clickDate:Number = 0;
      
      public function LabyrinthFrame()
      {
         super();
      }
      
      override protected function init() : void
      {
         super.init();
         var alerInfo:AlertInfo = new AlertInfo(LanguageMgr.GetTranslation("ddt.labyrinth.LabyrinthFrame.title"));
         alerInfo.moveEnable = false;
         info = alerInfo;
         this._bg = ComponentFactory.Instance.creatComponentByStylename("ddt.view.labyrinth.ScaleBG");
         addToContent(this._bg);
         this._rightBg = ComponentFactory.Instance.creatBitmap("ddt.labyrinth.rightBG");
         addToContent(this._rightBg);
         this._leftBg = ComponentFactory.Instance.creatBitmap("ddt.labyrinth.leftBG");
         addToContent(this._leftBg);
         this._startGameBtn = ComponentFactory.Instance.creatComponentByStylename("ddt.view.labyrinth.StartGmaeBtn");
         addToContent(this._startGameBtn);
         this._cleanOutBtn = ComponentFactory.Instance.creatComponentByStylename("ddt.view.LabyrinthFrame.CleanOutBtn");
         addToContent(this._cleanOutBtn);
         this._continueBtn = ComponentFactory.Instance.creatComponentByStylename("ddt.view.LabyrinthFrame.continueGameBtn");
         addToContent(this._continueBtn);
         this._continueCleanOutBtn = ComponentFactory.Instance.creatComponentByStylename("ddt.view.LabyrinthFrame.continueCleabOut");
         addToContent(this._continueCleanOutBtn);
         this._resetBtn = ComponentFactory.Instance.creatComponentByStylename("ddt.view.LabyrinthFrame.resetBtn");
         addToContent(this._resetBtn);
         this._cleanOutContainer = ComponentFactory.Instance.creatCustomObject("labyrinth.LabyrinthFrame.cleanOutContainer");
         addToContent(this._cleanOutContainer);
         this._startContainer = ComponentFactory.Instance.creatCustomObject("labyrinth.LabyrinthFrame.startContainer");
         addToContent(this._startContainer);
         this._rankingBtn = ComponentFactory.Instance.creatComponentByStylename("ddt.view.labyrinth.RankingBtn");
         addToContent(this._rankingBtn);
         this._shopBtn = ComponentFactory.Instance.creatComponentByStylename("ddt.view.labyrinth.shopBtn");
         addToContent(this._shopBtn);
         this._helpBtn = ComponentFactory.Instance.creatComponentByStylename("ddt.view.labyrinth.helpBtn");
         addToContent(this._helpBtn);
         this._myProgress = ComponentFactory.Instance.creatBitmap("ddt.labyrinth.myProgress");
         addToContent(this._myProgress);
         this._myProgressText = ComponentFactory.Instance.creatComponentByStylename("ddt.labyrinth.LabyrinthFrame.text1");
         this._myProgressText.text = "0";
         addToContent(this._myProgressText);
         this._myRanking = ComponentFactory.Instance.creatBitmap("ddt.labyrinth.myRankingBG");
         addToContent(this._myRanking);
         this._myRankingText = ComponentFactory.Instance.creatComponentByStylename("ddt.labyrinth.LabyrinthFrame.text2");
         this._myRankingText.text = "0";
         addToContent(this._myRankingText);
         this._todayNum = ComponentFactory.Instance.creatBitmap("ddt.labyrinth.todayNum");
         this._startContainer.addChild(this._todayNum);
         this._todayNumText = ComponentFactory.Instance.creatComponentByStylename("ddt.labyrinth.LabyrinthFrame.text3");
         this._todayNumText.text = "0";
         this._startContainer.addChild(this._todayNumText);
         this._explain = ComponentFactory.Instance.creatComponentByStylename("ddt.labyrinth.LabyrinthFrame.text4");
         this._explain.text = LanguageMgr.GetTranslation("ddt.labyrinth.LabyrinthFrame.text1");
         addToContent(this._explain);
         this._currentFloor = ComponentFactory.Instance.creatComponentByStylename("ddt.labyrinth.LabyrinthFrame.currentFloor");
         this._currentFloor.text = LanguageMgr.GetTranslation("dt.labyrinth.LabyrinthFrame.text4");
         this._cleanOutContainer.addChild(this._currentFloor);
         this._currentFloorNum = ComponentFactory.Instance.creatComponentByStylename("ddt.labyrinth.LabyrinthFrame.currentFloorNum");
         this._cleanOutContainer.addChild(this._currentFloorNum);
         this._accumulateExp = ComponentFactory.Instance.creatComponentByStylename("ddt.labyrinth.LabyrinthFrame.accumulateExp");
         this._accumulateExp.text = LanguageMgr.GetTranslation("dt.labyrinth.LabyrinthFrame.text5");
         this._cleanOutContainer.addChild(this._accumulateExp);
         this._accumulateExpNum = ComponentFactory.Instance.creatComponentByStylename("ddt.labyrinth.LabyrinthFrame.accumulateExpNum");
         this._cleanOutContainer.addChild(this._accumulateExpNum);
         this._doubleAward = ComponentFactory.Instance.creatComponentByStylename("ddt.labyrinth.LabyrinthFrame.CheckButton");
         this._doubleAward.text = LanguageMgr.GetTranslation("ddt.labyrinth.LabyrinthFrame.text2");
         this._doubleAward.selected = true;
         this._startContainer.addChild(this._doubleAward);
         this._titleList = ComponentFactory.Instance.creat("ddt.labyrinth.BoxTextList",[2]);
         addToContent(this._titleList);
         if(LabyrinthManager.Instance.model.serverMultiplyingPower)
         {
            this._serverDoubleIcon = ComponentFactory.Instance.creatBitmap("ddt.labyrinth.doubleAwardIcon");
            addToContent(this._serverDoubleIcon);
         }
         this.creatBox();
         this.initEvent();
         this.btnState = true;
         SocketManager.Instance.out.labyrinthDouble(this._doubleAward.selected);
         SocketManager.Instance.out.labyrinthRequestUpdate();
      }
      
      private function initEvent() : void
      {
         this._startGameBtn.addEventListener(MouseEvent.CLICK,this.__onBtnClick);
         this._rankingBtn.addEventListener(MouseEvent.CLICK,this.__onBtnClick);
         this._shopBtn.addEventListener(MouseEvent.CLICK,this.__onBtnClick);
         this._continueBtn.addEventListener(MouseEvent.CLICK,this.__onBtnClick);
         this._cleanOutBtn.addEventListener(MouseEvent.CLICK,this.__onBtnClick);
         this._continueCleanOutBtn.addEventListener(MouseEvent.CLICK,this.__onBtnClick);
         this._resetBtn.addEventListener(MouseEvent.CLICK,this.__onBtnClick);
         this._helpBtn.addEventListener(MouseEvent.CLICK,this.__onBtnClick);
         this._doubleAward.addEventListener(MouseEvent.CLICK,this.__onBtnClick);
         LabyrinthManager.Instance.addEventListener(LabyrinthManager.UPDATE_INFO,this.__updateInfo);
      }
      
      private function removeEvent() : void
      {
         if(Boolean(this._startGameBtn))
         {
            this._startGameBtn.removeEventListener(MouseEvent.CLICK,this.__onBtnClick);
         }
         if(Boolean(this._rankingBtn))
         {
            this._rankingBtn.removeEventListener(MouseEvent.CLICK,this.__onBtnClick);
         }
         if(Boolean(this._shopBtn))
         {
            this._shopBtn.removeEventListener(MouseEvent.CLICK,this.__onBtnClick);
         }
         if(Boolean(this._continueBtn))
         {
            this._continueBtn.removeEventListener(MouseEvent.CLICK,this.__onBtnClick);
         }
         if(Boolean(this._cleanOutBtn))
         {
            this._cleanOutBtn.removeEventListener(MouseEvent.CLICK,this.__onBtnClick);
         }
         if(Boolean(this._continueCleanOutBtn))
         {
            this._continueCleanOutBtn.removeEventListener(MouseEvent.CLICK,this.__onBtnClick);
         }
         if(Boolean(this._resetBtn))
         {
            this._resetBtn.removeEventListener(MouseEvent.CLICK,this.__onBtnClick);
         }
         if(Boolean(this._helpBtn))
         {
            this._helpBtn.removeEventListener(MouseEvent.CLICK,this.__onBtnClick);
         }
         if(Boolean(this._doubleAward))
         {
            this._doubleAward.removeEventListener(MouseEvent.CLICK,this.__onBtnClick);
         }
         LabyrinthManager.Instance.removeEventListener(LabyrinthManager.UPDATE_INFO,this.__updateInfo);
      }
      
      private function creatBox() : void
      {
         var box:LabyrinthBoxIcon = null;
         for(var i:int = 0; i < 10; i++)
         {
            box = new LabyrinthBoxIcon(i + 1);
            this._titleList.addChild(box);
         }
      }
      
      protected function __updateInfo(event:Event) : void
      {
         this._myProgressText.text = LabyrinthManager.Instance.model.myProgress.toString();
         this._myRankingText.text = LabyrinthManager.Instance.model.myRanking.toString();
         this._todayNumText.text = LabyrinthManager.Instance.model.completeChallenge ? "1/1" : "0/1";
         this._currentFloorNum.text = LabyrinthManager.Instance.model.currentFloor.toString();
         this._accumulateExpNum.text = LabyrinthManager.Instance.model.accumulateExp.toString();
         if(LabyrinthManager.Instance.model.serverMultiplyingPower)
         {
            this._serverDoubleIcon = ComponentFactory.Instance.creatBitmap("ddt.labyrinth.doubleAwardIcon");
            addToContent(this._serverDoubleIcon);
         }
         this.updataState();
      }
      
      private function updataState() : void
      {
         var model:LabyrinthModel = LabyrinthManager.Instance.model;
         this._isDoubleAward = model.isDoubleAward;
         if(!model.isInGame && !model.isCleanOut)
         {
            this.btnState = true;
         }
         else
         {
            this.btnState = false;
         }
         if(model.currentFloor == model.myProgress + 1)
         {
            this._cleanOutBtn.enable = this._continueCleanOutBtn.enable = false;
         }
         else
         {
            this._cleanOutBtn.enable = this._continueCleanOutBtn.enable = true;
         }
      }
      
      protected function openShop() : void
      {
         var frame:LabyrinthShopFrame = ComponentFactory.Instance.creatCustomObject("labyrinth.view.labyrinthShopFrame");
         frame.addEventListener(FrameEvent.RESPONSE,this.__frameEvent);
         frame.show();
      }
      
      protected function openRanking() : void
      {
         var frame:RankingListFrame = ComponentFactory.Instance.creatCustomObject("labyrinth.rankingListFrame");
         frame.addEventListener(FrameEvent.RESPONSE,this.__frameEvent);
         frame.show();
      }
      
      protected function __frameEvent(event:FrameEvent) : void
      {
         SoundManager.instance.playButtonSound();
         var frame:Disposeable = event.target as Disposeable;
         frame.dispose();
         frame = null;
      }
      
      protected function set btnState(value:Boolean) : void
      {
         this._startGameBtn.visible = value;
         this._cleanOutBtn.visible = value;
         this._continueBtn.visible = !value;
         this._continueCleanOutBtn.visible = !value;
         this._resetBtn.visible = !value;
         this._startContainer.visible = value;
         this._cleanOutContainer.visible = !value;
      }
      
      protected function startGame() : void
      {
         if(PlayerManager.Instance.Self.Bag.getItemAt(6) == null)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.room.RoomIIController.weapon"));
            return;
         }
         if(PlayerManager.Instance.Self.getBag(BagInfo.PROPBAG).getItemByTemplateId(EquipType.LABYINTH_DOBLE_AWARD) == null && this._doubleAward.selected && !this._isDoubleAward)
         {
            this.buy();
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.labyrinth.LabyrinthFrame.warningII"));
            return;
         }
         SocketManager.Instance.out.labyrinthDouble(this._doubleAward.selected);
         SocketManager.Instance.out.createUserGuide(RoomInfo.LANBYRINTH_ROOM);
      }
      
      protected function continueGame() : void
      {
         if(PlayerManager.Instance.Self.Bag.getItemAt(6) == null)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.room.RoomIIController.weapon"));
            return;
         }
         SocketManager.Instance.out.createUserGuide(RoomInfo.LANBYRINTH_ROOM);
      }
      
      private function openCleanOutFrame() : void
      {
         var model:LabyrinthModel = LabyrinthManager.Instance.model;
         if(!model.isCleanOut)
         {
            this.cleanOut();
         }
         else
         {
            this.continueCleanOut();
         }
      }
      
      protected function cleanOut() : void
      {
         var model:LabyrinthModel = LabyrinthManager.Instance.model;
         if(!LabyrinthManager.Instance.model.completeChallenge)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.labyrinth.CleanOutFrame.warningI"));
            return;
         }
         if(PlayerManager.Instance.Self.getBag(BagInfo.PROPBAG).getItemByTemplateId(EquipType.LABYINTH_DOBLE_AWARD) == null && this._doubleAward.selected && !this._isDoubleAward && !model.isInGame && !model.isCleanOut)
         {
            this.buy();
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.labyrinth.LabyrinthFrame.warningII"));
            return;
         }
         SocketManager.Instance.out.labyrinthDouble(this._doubleAward.selected);
         var frame:CleanOutFrame = ComponentFactory.Instance.creatCustomObject("labyrinth.view.cleanOutFrame");
         frame.addEventListener(FrameEvent.RESPONSE,this.__frameEvent);
         frame.show();
      }
      
      protected function continueCleanOut() : void
      {
         if(!LabyrinthManager.Instance.model.completeChallenge)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.labyrinth.CleanOutFrame.warningI"));
            return;
         }
         var frame:CleanOutFrame = ComponentFactory.Instance.creatCustomObject("labyrinth.view.cleanOutFrame");
         frame.continueCleanOut();
         frame.addEventListener(FrameEvent.RESPONSE,this.__frameEvent);
         frame.show();
      }
      
      protected function doubleChange() : void
      {
         SocketManager.Instance.out.labyrinthDouble(this._doubleAward.selected);
      }
      
      private function buy() : void
      {
         this._buySingleGoodsView = new BuySingleGoodsView();
         LayerManager.Instance.addToLayer(this._buySingleGoodsView,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
         this._buySingleGoodsView.goodsID = EquipType.LABYINTH_DOBLE_AWARD_GOODS_ID;
      }
      
      protected function openHelpFrame() : void
      {
         var movie:MovieClip = ComponentFactory.Instance.creatCustomObject("ddt.labyrinth.LabyrinthFrame.help");
         var frame:HelpFrame = ComponentFactory.Instance.creat("ddt.labyrinth.LabyrinthFrame.helpFrame");
         frame.setView(movie);
         frame.submitButtonPos = "dt.labyrinth.LabyrinthFrame.helpFrame.submitButtonPos";
         frame.titleText = LanguageMgr.GetTranslation("store.view.HelpButtonText");
         frame.addEventListener(FrameEvent.RESPONSE,this.__frameEvent);
         LayerManager.Instance.addToLayer(frame,LayerManager.GAME_TOP_LAYER,true,LayerManager.BLCAK_BLOCKGOUND,true);
      }
      
      protected function reset() : void
      {
         var frame:BaseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("dt.labyrinth.LabyrinthFrame.text6"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),true,false,false,2);
         frame.addEventListener(FrameEvent.RESPONSE,this.__onAlertResponse);
      }
      
      protected function __onAlertResponse(event:FrameEvent) : void
      {
         event.currentTarget.removeEventListener(FrameEvent.RESPONSE,this.__onAlertResponse);
         ObjectUtils.disposeObject(event.currentTarget);
         if(event.responseCode == FrameEvent.SUBMIT_CLICK || event.responseCode == FrameEvent.ENTER_CLICK)
         {
            SocketManager.Instance.out.labyrinthReset();
         }
      }
      
      protected function __onBtnClick(event:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         BuriedManager.Instance.isOpening = false;
         switch(event.target)
         {
            case this._startGameBtn:
               if(new Date().time - this._clickDate > 1000)
               {
                  this._clickDate = new Date().time;
                  this.startGame();
               }
               break;
            case this._continueBtn:
               if(new Date().time - this._clickDate > 1000)
               {
                  this._clickDate = new Date().time;
                  this.continueGame();
               }
               break;
            case this._shopBtn:
               this.openShop();
               break;
            case this._rankingBtn:
               this.openRanking();
               break;
            case this._resetBtn:
               this.reset();
               break;
            case this._continueCleanOutBtn:
            case this._cleanOutBtn:
               this.openCleanOutFrame();
               break;
            case this._helpBtn:
               this.openHelpFrame();
               break;
            case this._doubleAward:
               this.doubleChange();
         }
      }
      
      public function show() : void
      {
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.ALPHA_BLOCKGOUND);
      }
      
      override public function dispose() : void
      {
         super.dispose();
         this.removeEvent();
         ObjectUtils.disposeObject(this._bg);
         this._bg = null;
         ObjectUtils.disposeObject(this._startGameBtn);
         this._startGameBtn = null;
         ObjectUtils.disposeObject(this._rankingBtn);
         this._rankingBtn = null;
         ObjectUtils.disposeObject(this._shopBtn);
         this._shopBtn = null;
         ObjectUtils.disposeObject(this._rightBg);
         this._rightBg = null;
         ObjectUtils.disposeObject(this._leftBg);
         this._leftBg = null;
         ObjectUtils.disposeObject(this._shopBtn);
         this._shopBtn = null;
         ObjectUtils.disposeObject(this._titleList);
         this._titleList = null;
         ObjectUtils.disposeObject(this._doubleAward);
         this._doubleAward = null;
         ObjectUtils.disposeObject(this._todayNum);
         this._todayNum = null;
         ObjectUtils.disposeObject(this._todayNumText);
         this._todayNumText = null;
         ObjectUtils.disposeObject(this._explain);
         this._explain = null;
         ObjectUtils.disposeObject(this._explainII);
         this._explainII = null;
         ObjectUtils.disposeObject(this._helpBtn);
         this._helpBtn = null;
         ObjectUtils.disposeObject(this._myRanking);
         this._myRanking = null;
         ObjectUtils.disposeObject(this._myRankingText);
         this._myRankingText = null;
         ObjectUtils.disposeObject(this._myProgress);
         this._myProgress = null;
         ObjectUtils.disposeObject(this._myProgressText);
         this._myProgressText = null;
         ObjectUtils.disposeObject(this._resetBtn);
         this._resetBtn = null;
         ObjectUtils.disposeObject(this._continueCleanOutBtn);
         this._continueCleanOutBtn = null;
         ObjectUtils.disposeObject(this._continueBtn);
         this._continueBtn = null;
         ObjectUtils.disposeObject(this._currentFloor);
         this._currentFloor = null;
         ObjectUtils.disposeObject(this._currentFloorNum);
         this._currentFloorNum = null;
         ObjectUtils.disposeObject(this._accumulateExp);
         this._accumulateExp = null;
         ObjectUtils.disposeObject(this._accumulateExpNum);
         this._accumulateExpNum = null;
         ObjectUtils.disposeObject(this._cleanOutContainer);
         this._cleanOutContainer = null;
         ObjectUtils.disposeObject(this._startContainer);
         this._startContainer = null;
         ObjectUtils.disposeObject(this._buySingleGoodsView);
         this._buySingleGoodsView = null;
         ObjectUtils.disposeObject(this._serverDoubleIcon);
         this._serverDoubleIcon = null;
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
   }
}

