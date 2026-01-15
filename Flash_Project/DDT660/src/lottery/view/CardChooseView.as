package lottery.view
{
   import com.greensock.TimelineLite;
   import com.greensock.TweenLite;
   import com.greensock.TweenProxy;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.DisplayUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.geom.Point;
   import lottery.cell.SmallCardCell;
   import lottery.events.LotteryEvent;
   
   public class CardChooseView extends Sprite implements Disposeable
   {
      
      private static const LOTTERY_MONEY:Number = 2000;
      
      private static const CARD_LIMIT:int = 24;
      
      private static const SELECTED_LIMIT:int = 5;
      
      private var _selectedCount:int;
      
      private var _bg:Bitmap;
      
      private var _leftView:CardChooseLeftView;
      
      private var _rightView:CardChooseRightView;
      
      private var _isEffectComplete:Boolean = true;
      
      public function CardChooseView()
      {
         super();
         this.initView();
         this.addEvent();
      }
      
      private function initView() : void
      {
         this._bg = ComponentFactory.Instance.creatBitmap("asset.lottery.cardChooseViewbg");
         addChild(this._bg);
         this._leftView = new CardChooseLeftView();
         addChild(this._leftView);
         this._rightView = new CardChooseRightView();
         addChild(this._rightView);
      }
      
      private function addEvent() : void
      {
         this._leftView.addEventListener(LotteryEvent.CARD_SELECT,this.__cardSelect);
         this._rightView.addEventListener(LotteryEvent.CARD_CANCEL,this.__cardCancel);
         this._rightView.addEventListener(LotteryEvent.CARD_CANCEL_ALL,this.__cardCancelAll);
      }
      
      private function __cardSelect(evt:LotteryEvent) : void
      {
         if(!this._isEffectComplete)
         {
            return;
         }
         if(this._rightView.isSelectFull)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.lottery.cardLottery.chosenLimit",SELECTED_LIMIT));
            return;
         }
         var selectedCell:SmallCardCell = SmallCardCell(evt.paras[0]);
         if(selectedCell.enable == false)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.lottery.cardLottery.haveChosen"));
            return;
         }
         var itemCell:DisplayObject = this._rightView.getEmptyCardCell();
         var pos:Point = DisplayUtils.localizePoint(parent,itemCell);
         pos.offset(50,40);
         ++this._selectedCount;
         this.addCardEffects(selectedCell,pos);
         selectedCell.enable = false;
         this._rightView.enable = false;
      }
      
      private function __cardCancel(evt:LotteryEvent) : void
      {
         this._leftView.resetCardById(evt.paras[0]);
      }
      
      private function __cardCancelAll(evt:LotteryEvent) : void
      {
         this._leftView.resetAllCard();
      }
      
      private function addCardEffects($item:SmallCardCell, toPos:Point) : void
      {
         var tp:TweenProxy = null;
         var timeline:TimelineLite = null;
         var twBig:TweenLite = null;
         var tw:TweenLite = null;
         var tw1:TweenLite = null;
         if(!$item)
         {
            return;
         }
         var tempBitmapD:BitmapData = new BitmapData($item.width,$item.height,true,0);
         tempBitmapD.draw($item.asDisplayObject());
         var bitmap:Bitmap = new Bitmap(tempBitmapD,"auto",true);
         parent.addChild(bitmap);
         tp = TweenProxy.create(bitmap);
         tp.registrationX = tp.width / 2;
         tp.registrationY = tp.height / 2;
         var pos:Point = DisplayUtils.localizePoint(parent,$item);
         tp.x = pos.x + tp.width / 2;
         tp.y = pos.y + tp.height / 2;
         timeline = new TimelineLite();
         timeline.vars.onComplete = this.twComplete;
         timeline.vars.onCompleteParams = [timeline,tp,bitmap,$item.cardId];
         twBig = new TweenLite(tp,0.3,{
            "scaleX":1.8,
            "scaleY":1.8
         });
         tw = new TweenLite(tp,0.3,{
            "x":toPos.x,
            "y":toPos.y
         });
         tw1 = new TweenLite(tp,0.3,{
            "scaleX":0.1,
            "scaleY":0.1
         });
         timeline.append(twBig,0.2);
         timeline.append(tw);
         timeline.append(tw1,-0.2);
         this._isEffectComplete = false;
      }
      
      private function twComplete(timeline:TimelineLite, tp:TweenProxy, bitmap:Bitmap, cardId:int) : void
      {
         if(Boolean(timeline))
         {
            timeline.kill();
         }
         if(Boolean(tp))
         {
            tp.destroy();
         }
         if(Boolean(bitmap.parent))
         {
            bitmap.parent.removeChild(bitmap);
            bitmap.bitmapData.dispose();
         }
         tp = null;
         bitmap = null;
         timeline = null;
         this._rightView.setLastEmptyCardId(cardId);
         this._rightView.enable = true;
         this._isEffectComplete = true;
      }
      
      private function removeEvent() : void
      {
         this._leftView.removeEventListener(LotteryEvent.CARD_SELECT,this.__cardSelect);
         this._rightView.removeEventListener(LotteryEvent.CARD_CANCEL,this.__cardCancel);
         this._rightView.removeEventListener(LotteryEvent.CARD_CANCEL_ALL,this.__cardCancelAll);
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         if(Boolean(this._bg))
         {
            ObjectUtils.disposeObject(this._bg);
         }
         this._bg = null;
         if(Boolean(this._leftView))
         {
            ObjectUtils.disposeObject(this._leftView);
         }
         this._leftView = null;
         if(Boolean(this._rightView))
         {
            ObjectUtils.disposeObject(this._rightView);
         }
         this._rightView = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

