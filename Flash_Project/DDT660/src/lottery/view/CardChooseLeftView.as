package lottery.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.container.SimpleTileList;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.SoundManager;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import lottery.cell.SmallCardCell;
   import lottery.events.LotteryEvent;
   
   public class CardChooseLeftView extends Sprite implements Disposeable
   {
      
      private static const CARD_LIMIT:int = 24;
      
      private var _cardContainer:SimpleTileList;
      
      public function CardChooseLeftView()
      {
         super();
         this.initView();
         this.addEvent();
      }
      
      private function initView() : void
      {
         var cardCell:SmallCardCell = null;
         this._cardContainer = ComponentFactory.Instance.creatComponentByStylename("lottery.cardChoose.allCardCcontainer",[4]);
         addChild(this._cardContainer);
         for(var i:int = 0; i < CARD_LIMIT; i++)
         {
            cardCell = new SmallCardCell();
            cardCell.cardId = i + 1;
            cardCell.addEventListener(MouseEvent.CLICK,this.__onCardCellClick);
            cardCell.addEventListener(MouseEvent.MOUSE_OVER,this.__cardCellMouseOver);
            cardCell.addEventListener(MouseEvent.MOUSE_OUT,this.__cardCellMouseOut);
            this._cardContainer.addChild(cardCell);
         }
      }
      
      private function addEvent() : void
      {
      }
      
      private function removeEvent() : void
      {
         var cardCell:DisplayObject = null;
         for(var j:int = 0; j < CARD_LIMIT; j++)
         {
            cardCell = this._cardContainer.getChildAt(j);
            cardCell.removeEventListener(MouseEvent.CLICK,this.__onCardCellClick);
            cardCell.removeEventListener(MouseEvent.MOUSE_OVER,this.__cardCellMouseOver);
            cardCell.removeEventListener(MouseEvent.MOUSE_OUT,this.__cardCellMouseOut);
         }
      }
      
      public function resetAllCard() : void
      {
         var cardCell:SmallCardCell = null;
         for(var i:int = 0; i < CARD_LIMIT; i++)
         {
            cardCell = this._cardContainer.getChildAt(i) as SmallCardCell;
            cardCell.enable = true;
         }
      }
      
      public function resetCardById(cardId:int) : void
      {
         SmallCardCell(this._cardContainer.getChildAt(cardId - 1)).enable = true;
      }
      
      private function __cardCellMouseOver(evt:MouseEvent) : void
      {
         SmallCardCell(evt.currentTarget).selected = true;
      }
      
      private function __cardCellMouseOut(evt:MouseEvent) : void
      {
         SmallCardCell(evt.currentTarget).selected = false;
      }
      
      private function __onCardCellClick(evt:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         var selectedCell:SmallCardCell = SmallCardCell(evt.currentTarget);
         dispatchEvent(new LotteryEvent(LotteryEvent.CARD_SELECT,selectedCell));
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         if(Boolean(this._cardContainer))
         {
            ObjectUtils.disposeObject(this._cardContainer);
         }
         this._cardContainer = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

