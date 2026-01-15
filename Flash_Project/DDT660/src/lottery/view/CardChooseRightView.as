package lottery.view
{
   import baglocked.BaglockedManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.container.SimpleTileList;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.StateManager;
   import ddt.states.StateType;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import lottery.cell.ChoosedCardCell;
   import lottery.data.LotteryModel;
   import lottery.events.LotteryEvent;
   
   public class CardChooseRightView extends Sprite implements Disposeable
   {
      
      private static const SELECTED_LIMIT:int = 5;
      
      private var _selectedContainer:SimpleTileList;
      
      private var _btnReset:BaseButton;
      
      private var _btnSure:BaseButton;
      
      private var _selectedCount:int;
      
      private var _enable:Boolean;
      
      public function CardChooseRightView()
      {
         super();
         this.initView();
         this.addEvent();
      }
      
      public function set enable(value:Boolean) : void
      {
         this._enable = value;
      }
      
      public function get enable() : Boolean
      {
         return this._enable;
      }
      
      public function get selectedCount() : int
      {
         return this._selectedCount;
      }
      
      private function initView() : void
      {
         var itemCell:ChoosedCardCell = null;
         this._selectedContainer = ComponentFactory.Instance.creatComponentByStylename("lottery.cardChoose.selectedContainer",[3]);
         addChild(this._selectedContainer);
         while(this._selectedContainer.numChildren < SELECTED_LIMIT)
         {
            itemCell = new ChoosedCardCell();
            itemCell.addEventListener(MouseEvent.CLICK,this.__choosedClick);
            this._selectedContainer.addChild(itemCell);
         }
         this._btnReset = ComponentFactory.Instance.creatComponentByStylename("lottery.cardChoose.btnReset");
         addChild(this._btnReset);
         this._btnSure = ComponentFactory.Instance.creatComponentByStylename("lottery.cardChoose.btnSure");
         addChild(this._btnSure);
         this._btnSure.enable = false;
         this._btnReset.enable = false;
         this._enable = true;
      }
      
      private function addEvent() : void
      {
         this._btnReset.addEventListener(MouseEvent.CLICK,this.__resetClick);
         this._btnSure.addEventListener(MouseEvent.CLICK,this.__sureClick);
      }
      
      private function removeEvent() : void
      {
         this._btnReset.removeEventListener(MouseEvent.CLICK,this.__resetClick);
         this._btnSure.removeEventListener(MouseEvent.CLICK,this.__sureClick);
         for(var i:int = 0; i < this._selectedContainer.numChildren; i++)
         {
            this._selectedContainer.getChildAt(i).removeEventListener(MouseEvent.CLICK,this.__choosedClick);
         }
      }
      
      public function get isSelectFull() : Boolean
      {
         return this._selectedCount >= SELECTED_LIMIT;
      }
      
      private function __resetClick(evt:MouseEvent) : void
      {
         var itemCell:ChoosedCardCell = null;
         if(!this._enable)
         {
            return;
         }
         SoundManager.instance.play("008");
         for(var j:int = 0; j < SELECTED_LIMIT; j++)
         {
            itemCell = this._selectedContainer.getChildAt(j) as ChoosedCardCell;
            itemCell.hide();
         }
         this._selectedCount = 0;
         this._btnSure.enable = false;
         this._btnReset.enable = false;
         dispatchEvent(new LotteryEvent(LotteryEvent.CARD_CANCEL_ALL));
      }
      
      private function __sureClick(evt:MouseEvent) : void
      {
         if(!this._enable)
         {
            return;
         }
         SoundManager.instance.play("008");
         if(this._selectedCount < SELECTED_LIMIT)
         {
            return;
         }
         if(PlayerManager.Instance.Self.Money >= LotteryModel.cardLotteryMoney)
         {
            if(PlayerManager.Instance.Self.bagLocked)
            {
               BaglockedManager.Instance.show();
               return;
            }
            this.cardLottery();
         }
         else
         {
            LeavePageManager.showFillFrame();
         }
      }
      
      public function setLastEmptyCardId(cardId:int) : void
      {
         ++this._selectedCount;
         ChoosedCardCell(this.getEmptyCardCell()).show(cardId);
         this._btnSure.enable = this._selectedCount >= SELECTED_LIMIT ? true : false;
         this._btnReset.enable = true;
      }
      
      public function getEmptyCardCell() : DisplayObject
      {
         for(var i:int = 0; i < this._selectedContainer.numChildren; i++)
         {
            if(ChoosedCardCell(this._selectedContainer.getChildAt(i)).isEmptyCard)
            {
               return this._selectedContainer.getChildAt(i);
            }
         }
         return this._selectedContainer.getChildAt(this._selectedCount - 1);
      }
      
      private function cardLottery() : void
      {
         var cardCell:ChoosedCardCell = null;
         if(this._selectedCount < SELECTED_LIMIT)
         {
            return;
         }
         var lotteryIds:Array = [];
         for(var i:int = 0; i < SELECTED_LIMIT; i++)
         {
            cardCell = this._selectedContainer.getChildAt(i) as ChoosedCardCell;
            if(cardCell.cardId < 1)
            {
               return;
            }
            lotteryIds.push(cardCell.cardId);
         }
         MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.lottery.cardLottery.wagerSuccess"));
         SocketManager.Instance.out.sendCardLotteryIds(lotteryIds);
         StateManager.setState(StateType.LOTTERY_HALL);
      }
      
      private function __choosedClick(evt:MouseEvent) : void
      {
         if(!this._enable)
         {
            return;
         }
         if(ChoosedCardCell(evt.currentTarget).isEmptyCard)
         {
            return;
         }
         SoundManager.instance.play("008");
         --this._selectedCount;
         ChoosedCardCell(evt.currentTarget).hide();
         this._btnSure.enable = false;
         this._btnReset.enable = this._selectedCount > 0;
         dispatchEvent(new LotteryEvent(LotteryEvent.CARD_CANCEL,ChoosedCardCell(evt.currentTarget).cardId));
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         if(Boolean(this._selectedContainer))
         {
            ObjectUtils.disposeAllChildren(this._selectedContainer);
         }
         this._selectedContainer = null;
         if(Boolean(this._btnReset))
         {
            ObjectUtils.disposeObject(this._btnReset);
         }
         this._btnReset = null;
         if(Boolean(this._btnSure))
         {
            ObjectUtils.disposeObject(this._btnSure);
         }
         this._btnSure = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

