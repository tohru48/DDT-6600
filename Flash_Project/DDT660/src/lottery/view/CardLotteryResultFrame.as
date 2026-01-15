package lottery.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.controls.container.HBox;
   import com.pickgliss.ui.controls.container.SimpleTileList;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import lottery.cell.BigCardCell;
   import lottery.data.LotteryCardResultVO;
   
   public class CardLotteryResultFrame extends LotteryPopupFrame
   {
      
      private var _lotteryResultList:Vector.<LotteryCardResultVO>;
      
      private var _frameAsset:Bitmap;
      
      private var _panel:ScrollPanel;
      
      private var _cardContainerAll:SimpleTileList;
      
      private var _resutlContainer:HBox;
      
      private var _btnPrev:SimpleBitmapButton;
      
      private var _btnNext:SimpleBitmapButton;
      
      private var _currentPhase:int = 0;
      
      public function CardLotteryResultFrame(lotteryResultList:Vector.<LotteryCardResultVO> = null)
      {
         this._lotteryResultList = lotteryResultList;
         super();
         this.addEvent();
      }
      
      override protected function initFrame() : void
      {
         var cell:BigCardCell = null;
         this._frameAsset = ComponentFactory.Instance.creatBitmap("asset.cardLottery.resultFrameAsset");
         addChild(this._frameAsset);
         this._resutlContainer = ComponentFactory.Instance.creatComponentByStylename("lottery.resultFrame.resutlContainer");
         addChild(this._resutlContainer);
         for(var j:int = 0; j < 5; j++)
         {
            cell = new BigCardCell();
            cell.cardId = 25;
            cell.tipDirctions = "0,1,2";
            this._resutlContainer.addChild(cell);
         }
         this._panel = ComponentFactory.Instance.creatComponentByStylename("lottery.resultFrame.previewPanel");
         this._cardContainerAll = new SimpleTileList(5);
         this._cardContainerAll.startPos = new Point(0,5);
         this._panel.setView(this._cardContainerAll);
         addChild(this._panel);
         this._btnPrev = ComponentFactory.Instance.creatComponentByStylename("lottery.cardResultFrame.btnPrev");
         addChild(this._btnPrev);
         this._btnNext = ComponentFactory.Instance.creatComponentByStylename("lottery.cardResultFrame.btnNext");
         addChild(this._btnNext);
         this._btnNext.enable = false;
         _btnOk = ComponentFactory.Instance.creatComponentByStylename("lottery.cardResultFrame.btnOk");
         addChild(_btnOk);
         this.viewResult();
      }
      
      private function addEvent() : void
      {
         this._btnNext.addEventListener(MouseEvent.CLICK,this.__phaseBtnClick);
         this._btnPrev.addEventListener(MouseEvent.CLICK,this.__phaseBtnClick);
         _btnOk.addEventListener(MouseEvent.CLICK,__btnClick);
      }
      
      private function removeEvent() : void
      {
         this._btnNext.removeEventListener(MouseEvent.CLICK,this.__phaseBtnClick);
         this._btnPrev.removeEventListener(MouseEvent.CLICK,this.__phaseBtnClick);
         _btnOk.removeEventListener(MouseEvent.CLICK,__btnClick);
      }
      
      public function setCardId(resultIds:Array, selfChooseIds:Array) : void
      {
         var j:int = 0;
         var m:int = 0;
         var cardCell:BigCardCell = null;
         if(resultIds.length != 0)
         {
            for(j = 0; j < resultIds.length; j++)
            {
               BigCardCell(this._resutlContainer.getChildAt(j)).cardId = resultIds[j];
            }
         }
         else if(resultIds.length == 0)
         {
            for(m = 0; m < 5; m++)
            {
               BigCardCell(this._resutlContainer.getChildAt(m)).cardId = 25;
            }
         }
         while(this._cardContainerAll.numChildren > 0)
         {
            this._cardContainerAll.removeChildAt(0);
         }
         for(var i:int = 0; i < selfChooseIds.length; i++)
         {
            cardCell = new BigCardCell();
            cardCell.tipDirctions = "0,1,2";
            cardCell.cardId = selfChooseIds[i];
            cardCell.selected = resultIds.indexOf(selfChooseIds[i]) > -1;
            this._cardContainerAll.addChild(cardCell);
         }
      }
      
      private function __phaseBtnClick(evt:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         switch(evt.currentTarget)
         {
            case this._btnNext:
               --this._currentPhase;
               break;
            case this._btnPrev:
               ++this._currentPhase;
         }
         this.viewResult();
      }
      
      private function viewResult() : void
      {
         if(this._currentPhase >= this._lotteryResultList.length)
         {
            this._currentPhase = 0;
         }
         if(this._currentPhase < 0)
         {
            this._currentPhase = this._lotteryResultList.length - 1;
         }
         this._btnNext.enable = this._currentPhase > 0;
         this._btnPrev.enable = this._currentPhase < this._lotteryResultList.length - 1;
         this.setCardId(this._lotteryResultList[this._currentPhase].resultIds,this._lotteryResultList[this._currentPhase].selfChooseIds);
      }
      
      override public function dispose() : void
      {
         if(Boolean(this._frameAsset))
         {
            ObjectUtils.disposeObject(this._frameAsset);
         }
         this._frameAsset = null;
         if(Boolean(this._panel))
         {
            ObjectUtils.disposeObject(this._panel);
         }
         this._panel = null;
         if(Boolean(this._cardContainerAll))
         {
            ObjectUtils.disposeObject(this._cardContainerAll);
         }
         this._cardContainerAll = null;
         if(Boolean(this._resutlContainer))
         {
            ObjectUtils.disposeObject(this._resutlContainer);
         }
         this._resutlContainer = null;
         super.dispose();
      }
   }
}

