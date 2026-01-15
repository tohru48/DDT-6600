package pyramid.view
{
   import baglocked.BaglockedManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.SelectedCheckButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.GameInSocketOut;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import pyramid.PyramidManager;
   import pyramid.event.PyramidEvent;
   
   public class PyramidLeftView extends Sprite implements Disposeable
   {
      
      private var _bg:Bitmap;
      
      private var _startBtn:BaseButton;
      
      private var _endBtn:BaseButton;
      
      private var _myLevelTxt:FilterFrameText;
      
      private var _myScoreTxt:FilterFrameText;
      
      private var _scoreAdd:FilterFrameText;
      
      private var _currentGetScore:FilterFrameText;
      
      private var _countMsgTxt:FilterFrameText;
      
      private var _countTxt:FilterFrameText;
      
      private var _pyramidCards:PyramidCards;
      
      private var _selectedAutoOpenCard:SelectedCheckButton;
      
      public function PyramidLeftView()
      {
         super();
         this.initView();
         this.initEvent();
         this.updateData();
         this.__movieLockHandler(null);
      }
      
      private function initView() : void
      {
         this._bg = ComponentFactory.Instance.creatBitmap("assets.pyramid.leftViewBg");
         this._myLevelTxt = ComponentFactory.Instance.creatComponentByStylename("assets.pyramid.myLevelTxt");
         this._myScoreTxt = ComponentFactory.Instance.creatComponentByStylename("assets.pyramid.myScoreTxt");
         this._scoreAdd = ComponentFactory.Instance.creatComponentByStylename("assets.pyramid.scoreAdd");
         this._currentGetScore = ComponentFactory.Instance.creatComponentByStylename("assets.pyramid.currentGetScore");
         this._countMsgTxt = ComponentFactory.Instance.creatComponentByStylename("assets.pyramid.countMsgTxt");
         this._countTxt = ComponentFactory.Instance.creatComponentByStylename("assets.pyramid.countTxt");
         this._startBtn = ComponentFactory.Instance.creatComponentByStylename("asset.pyramid.leftView.startBtn");
         this._endBtn = ComponentFactory.Instance.creatComponentByStylename("asset.pyramid.leftView.endBtn");
         this._pyramidCards = ComponentFactory.Instance.creatCustomObject("pyramid.view.pyramidCards");
         this._selectedAutoOpenCard = ComponentFactory.Instance.creatComponentByStylename("pyramid.selectedCheckAutoOpenCard");
         this._selectedAutoOpenCard.autoSelect = false;
         this._selectedAutoOpenCard.text = LanguageMgr.GetTranslation("ddt.pyramid.selectedCheckAutoOpenCardTxt");
         addChild(this._bg);
         addChild(this._pyramidCards);
         addChild(this._myLevelTxt);
         addChild(this._myScoreTxt);
         addChild(this._scoreAdd);
         addChild(this._currentGetScore);
         addChild(this._countMsgTxt);
         addChild(this._countTxt);
         addChild(this._startBtn);
         addChild(this._endBtn);
         addChild(this._selectedAutoOpenCard);
      }
      
      private function __movieLockHandler(event:PyramidEvent) : void
      {
         if(PyramidManager.instance.movieLock)
         {
            this._startBtn.mouseEnabled = false;
            this._startBtn.mouseChildren = false;
            this._endBtn.mouseEnabled = false;
            this._endBtn.mouseChildren = false;
         }
         else
         {
            this._startBtn.mouseEnabled = true;
            this._startBtn.mouseChildren = true;
            this._endBtn.mouseEnabled = true;
            this._endBtn.mouseChildren = true;
         }
      }
      
      private function initEvent() : void
      {
         this._startBtn.addEventListener(MouseEvent.CLICK,this.__startBtnHanlder);
         this._endBtn.addEventListener(MouseEvent.CLICK,this.__startBtnHanlder);
         PyramidManager.instance.model.addEventListener(PyramidEvent.START_OR_STOP,this.__startOrStopHandler);
         PyramidManager.instance.model.addEventListener(PyramidEvent.CARD_RESULT,this.__cardResultHandler);
         PyramidManager.instance.model.addEventListener(PyramidEvent.DIE_EVENT,this.__DieEventHandler);
         PyramidManager.instance.model.addEventListener(PyramidEvent.SCORE_CONVERT,this.__scoreConvertEventHandler);
         PyramidManager.instance.addEventListener(PyramidEvent.MOVIE_LOCK,this.__movieLockHandler);
         PyramidManager.instance.addEventListener(PyramidEvent.AUTO_OPENCARD,this.__autoOpenCardChangeHandler);
         this._selectedAutoOpenCard.addEventListener(MouseEvent.CLICK,this._selectedAutoOpenCardClickHandler);
      }
      
      private function updateData() : void
      {
         this._myLevelTxt.text = LanguageMgr.GetTranslation("ddt.pyramid.myLevelTxt",PyramidManager.instance.model.maxLayer);
         this._myScoreTxt.text = PyramidManager.instance.model.totalPoint + "";
         this._scoreAdd.text = PyramidManager.instance.model.pointRatio + "%";
         this._currentGetScore.text = PyramidManager.instance.model.turnPoint + "";
         this._countMsgTxt.text = LanguageMgr.GetTranslation("ddt.pyramid.countMsgTxt");
         var freeCount:int = PyramidManager.instance.model.freeCount - PyramidManager.instance.model.currentFreeCount;
         if(freeCount < 0)
         {
            freeCount = 0;
         }
         this._countTxt.text = freeCount + "";
         this.isStart(PyramidManager.instance.model.isPyramidStart);
      }
      
      private function __startOrStopHandler(event:PyramidEvent) : void
      {
         this.updateData();
         this._pyramidCards.updateSelectItems();
         this._pyramidCards.playShuffleFullMovie();
      }
      
      private function __cardResultHandler(event:PyramidEvent) : void
      {
         var revieMoney:int = 0;
         PyramidManager.instance.movieLock = false;
         this.updateData();
         this._pyramidCards.playTurnCardMovie();
         if(PyramidManager.instance.model.currentLayer >= 8)
         {
            this._pyramidCards.topBoxMovieMode(1);
         }
         this._pyramidCards.upClear();
         if(PyramidManager.instance.model.isPyramidDie)
         {
            revieMoney = int(PyramidManager.instance.model.revivePrice[PyramidManager.instance.model.currentReviveCount]);
            if(PyramidManager.instance.model.currentReviveCount == PyramidManager.instance.model.revivePrice.length)
            {
               PyramidManager.instance.showFrame(2);
               PyramidManager.instance.isAutoOpenCard = false;
            }
            else if(PlayerManager.Instance.Self.Money < revieMoney)
            {
               PyramidManager.instance.showFrame(7);
            }
            else if(PyramidManager.instance.isShowReviveBuyFrameSelectedCheck)
            {
               PyramidManager.instance.showFrame(1);
            }
            else
            {
               GameInSocketOut.sendPyramidRevive(true);
            }
         }
      }
      
      private function __DieEventHandler(event:PyramidEvent) : void
      {
         this.updateData();
         this._pyramidCards.updateSelectItems();
         PyramidManager.instance.dispatchEvent(new PyramidEvent(PyramidEvent.AUTO_OPENCARD));
      }
      
      private function __scoreConvertEventHandler(event:PyramidEvent) : void
      {
         this._myScoreTxt.text = PyramidManager.instance.model.totalPoint + "";
      }
      
      private function isStart(bool:Boolean) : void
      {
         this._endBtn.visible = bool;
         this._startBtn.visible = !bool;
      }
      
      public function __startBtnHanlder(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(PyramidManager.instance.clickRateGo)
         {
            return;
         }
         if(PyramidManager.instance.movieLock)
         {
            return;
         }
         if(PyramidManager.instance.model.isScoreExchange)
         {
            PyramidManager.instance.showFrame(6);
         }
         else if(event.currentTarget == this._startBtn)
         {
            GameInSocketOut.sendPyramidStartOrstop(true);
         }
         else
         {
            PyramidManager.instance.showFrame(3);
         }
      }
      
      private function _selectedAutoOpenCardClickHandler(evt:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         if(PyramidManager.instance.isShowAutoOpenFrameSelectedCheck && !this._selectedAutoOpenCard.selected)
         {
            PyramidManager.instance.showFrame(8);
            return;
         }
         this._selectedAutoOpenCard.selected = !this._selectedAutoOpenCard.selected;
         PyramidManager.instance.isAutoOpenCard = this._selectedAutoOpenCard.selected;
      }
      
      private function __autoOpenCardChangeHandler(evt:PyramidEvent) : void
      {
         if(Boolean(this._selectedAutoOpenCard))
         {
            this._selectedAutoOpenCard.selected = PyramidManager.instance.isAutoOpenCard;
            if(PyramidManager.instance.isAutoOpenCard && Boolean(this._pyramidCards))
            {
               this._pyramidCards.checkAutoOpenCard();
            }
         }
      }
      
      private function removeEvent() : void
      {
         this._startBtn.removeEventListener(MouseEvent.CLICK,this.__startBtnHanlder);
         this._endBtn.removeEventListener(MouseEvent.CLICK,this.__startBtnHanlder);
         PyramidManager.instance.model.removeEventListener(PyramidEvent.START_OR_STOP,this.__startOrStopHandler);
         PyramidManager.instance.model.removeEventListener(PyramidEvent.CARD_RESULT,this.__cardResultHandler);
         PyramidManager.instance.model.removeEventListener(PyramidEvent.DIE_EVENT,this.__DieEventHandler);
         PyramidManager.instance.model.removeEventListener(PyramidEvent.SCORE_CONVERT,this.__scoreConvertEventHandler);
         PyramidManager.instance.removeEventListener(PyramidEvent.MOVIE_LOCK,this.__movieLockHandler);
         PyramidManager.instance.removeEventListener(PyramidEvent.AUTO_OPENCARD,this.__autoOpenCardChangeHandler);
         this._selectedAutoOpenCard.addEventListener(MouseEvent.CLICK,this._selectedAutoOpenCardClickHandler);
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         ObjectUtils.disposeObject(this._bg);
         this._bg = null;
         ObjectUtils.disposeObject(this._startBtn);
         this._startBtn = null;
         ObjectUtils.disposeObject(this._endBtn);
         this._endBtn = null;
         ObjectUtils.disposeObject(this._myLevelTxt);
         this._myLevelTxt = null;
         ObjectUtils.disposeObject(this._myScoreTxt);
         this._myScoreTxt = null;
         ObjectUtils.disposeObject(this._scoreAdd);
         this._scoreAdd = null;
         ObjectUtils.disposeObject(this._currentGetScore);
         this._currentGetScore = null;
         ObjectUtils.disposeObject(this._countMsgTxt);
         this._countMsgTxt = null;
         ObjectUtils.disposeObject(this._countTxt);
         this._countTxt = null;
         ObjectUtils.disposeObject(this._pyramidCards);
         this._pyramidCards = null;
         ObjectUtils.disposeObject(this._selectedAutoOpenCard);
         this._selectedAutoOpenCard = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

