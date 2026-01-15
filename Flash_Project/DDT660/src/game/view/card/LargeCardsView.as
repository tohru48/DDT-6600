package game.view.card
{
   import com.greensock.TweenLite;
   import com.greensock.easing.Quint;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.image.Image;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.GameInSocketOut;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SocketManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.geom.Point;
   import game.model.Player;
   import road7th.comm.PackageIn;
   import room.RoomManager;
   
   public class LargeCardsView extends SmallCardsView
   {
      
      public static const LARGE_CARD_TIME:uint = 15;
      
      public static const LARGE_CARD_CNT:uint = 21;
      
      public static const LARGE_CARD_COLUMNS:uint = 7;
      
      public static const LARGE_CARD_VIEW_TIME:uint = 1;
      
      private var _systemToken:Boolean;
      
      private var _showCardInfos:Array;
      
      private var _instructionTxt:Bitmap;
      
      private var _vipDiscountBg:Image;
      
      private var _vipIcon:Image;
      
      private var _vipDescTxt:FilterFrameText;
      
      protected var _cardGetNote:DisplayObject;
      
      public function LargeCardsView()
      {
         super();
      }
      
      override protected function init() : void
      {
         _countDownTime = LARGE_CARD_TIME;
         _cardCnt = LARGE_CARD_CNT;
         _cardColumns = LARGE_CARD_COLUMNS;
         _viewTime = LARGE_CARD_VIEW_TIME;
         super.init();
         PositionUtils.setPos(_title,"takeoutCard.LargeCardViewTitlePos");
         PositionUtils.setPos(_countDownView,"takeoutCard.LargeCardViewCountDownPos");
         this._instructionTxt = ComponentFactory.Instance.creatBitmap("asset.takeoutCard.InstructionBitmap");
         addChild(this._instructionTxt);
         this._vipDiscountBg = ComponentFactory.Instance.creatComponentByStylename("gameOver.VipDiscountBg");
         this._vipIcon = ComponentFactory.Instance.creatComponentByStylename("gameOver.VipIcon");
         this._vipDescTxt = ComponentFactory.Instance.creatComponentByStylename("gameOver.VipDescTxt");
         this._vipDescTxt.text = LanguageMgr.GetTranslation("tank.gameover.VipDescTxt");
         addChild(this._vipDiscountBg);
         addChild(this._vipIcon);
         addChild(this._vipDescTxt);
         if(_gameInfo.selfGamePlayer.hasGardGet)
         {
            this.drawCardGetNote();
         }
      }
      
      private function drawCardGetNote() : void
      {
         this._cardGetNote = addChild(ComponentFactory.Instance.creat("asset.core.payBuffAsset73.note"));
         PositionUtils.setPos(this._cardGetNote,"takeoutCard.LargeCardView.CardGetNotePos");
      }
      
      override protected function initEvent() : void
      {
         super.initEvent();
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.SHOW_CARDS,this.__showAllCard);
         RoomManager.Instance.addEventListener(RoomManager.PAYMENT_TAKE_CARD,__disabledAllCards);
      }
      
      override protected function __takeOut(e:CrazyTankSocketEvent) : void
      {
         var pkg:PackageIn = null;
         var isSysTake:Boolean = false;
         var place:Number = NaN;
         var templateID:int = 0;
         var count:int = 0;
         var isVip:Boolean = false;
         var info:Player = null;
         if(_cards.length > 0)
         {
            pkg = e.pkg;
            isSysTake = pkg.readBoolean();
            if(!this._systemToken && isSysTake)
            {
               this._systemToken = true;
               __disabledAllCards();
            }
            place = pkg.readByte();
            if(place == 50)
            {
               return;
            }
            templateID = pkg.readInt();
            count = pkg.readInt();
            isVip = pkg.readBoolean();
            info = _gameInfo.findPlayer(pkg.extend1);
            if(pkg.clientId == _gameInfo.selfGamePlayer.playerInfo.ID)
            {
               info = _gameInfo.selfGamePlayer;
            }
            if(Boolean(info))
            {
               _cards[place].play(info,templateID,count,isVip);
               if(info.isSelf)
               {
                  ++_selectedCnt;
                  _selectCompleted = _selectedCnt >= info.GetCardCount;
                  if(_selectedCnt == 2)
                  {
                     this.changeCardsToPayType();
                  }
                  if(_selectedCnt >= 3)
                  {
                     __disabledAllCards();
                     return;
                  }
               }
            }
            if(isSysTake)
            {
               this.showAllCard();
            }
         }
         else
         {
            _resultCards.push(e);
         }
      }
      
      private function changeCardsToPayType() : void
      {
         for(var i:int = 0; i < _cards.length; i++)
         {
            _cards[i].isPayed = true;
         }
      }
      
      private function __showAllCard(e:CrazyTankSocketEvent) : void
      {
         var obj:Object = null;
         var pkg:PackageIn = e.pkg;
         var count:int = pkg.readInt();
         this._showCardInfos = [];
         for(var i:uint = 0; i < count; i++)
         {
            obj = new Object();
            obj.index = pkg.readByte();
            obj.templateID = pkg.readInt();
            obj.count = pkg.readInt();
            this._showCardInfos.push(obj);
         }
         this.showAllCard();
      }
      
      override protected function __timerForViewComplete(event:* = null) : void
      {
         _timerForView.removeEventListener(TimerEvent.TIMER_COMPLETE,this.__timerForViewComplete);
         if(Boolean(_gameInfo))
         {
            _gameInfo.resetResultCard();
         }
         _resultCards = null;
         dispatchEvent(new Event(Event.COMPLETE));
      }
      
      private function showAllCard() : void
      {
         var i:uint = 0;
         LayerManager.Instance.clearnGameDynamic();
         if(Boolean(this._showCardInfos) && this._showCardInfos.length > 0)
         {
            for(i = 0; i < this._showCardInfos.length; i++)
            {
               _cards[uint(this._showCardInfos[i].index)].play(null,int(this._showCardInfos[i].templateID),this._showCardInfos[i].count,false);
            }
         }
         _timerForView.reset();
         _timerForView.start();
      }
      
      override protected function createCards() : void
      {
         var point:Point = null;
         var item:LuckyCard = null;
         var offset:Point = new Point(26,25);
         for(var i:int = 0; i < _cardCnt; i++)
         {
            point = new Point();
            item = new LuckyCard(i,LuckyCard.AFTER_GAME_CARD);
            point.x = i % _cardColumns * (offset.x + item.width);
            point.y = int(i / _cardColumns) * (offset.y + item.height);
            item.x = (offset.x + item.width) * 3;
            item.y = offset.y + item.height;
            item.allowClick = _gameInfo.selfGamePlayer.GetCardCount > 0;
            item.msg = LanguageMgr.GetTranslation("tank.gameover.DisableGetCard");
            addChild(item);
            _posArr.push(point);
            _cards.push(item);
         }
      }
      
      override protected function startTween(e:Event = null) : void
      {
         removeEventListener(Event.ADDED_TO_STAGE,this.startTween);
         for(var i:int = 0; i < LARGE_CARD_CNT; i++)
         {
            TweenLite.to(_cards[i],0.8,{
               "startAt":{
                  "x":_posArr[10].x,
                  "y":_posArr[10].y
               },
               "x":_posArr[i].x,
               "y":_posArr[i].y,
               "ease":Quint.easeOut,
               "onComplete":cardTweenComplete,
               "onCompleteParams":[_cards[i]]
            });
         }
      }
      
      override protected function __countDownComplete(event:Event) : void
      {
         _countDownView.removeEventListener(Event.COMPLETE,this.__countDownComplete);
         GameInSocketOut.sendGameTakeOut(100);
         __disabledAllCards();
      }
      
      override public function dispose() : void
      {
         ObjectUtils.disposeObject(this._cardGetNote);
         this._cardGetNote = null;
         this._showCardInfos = null;
         ObjectUtils.disposeObject(this._instructionTxt);
         this._instructionTxt = null;
         ObjectUtils.disposeObject(this._vipDiscountBg);
         this._vipDiscountBg = null;
         ObjectUtils.disposeObject(this._vipIcon);
         this._vipIcon = null;
         ObjectUtils.disposeObject(this._vipDescTxt);
         this._vipDescTxt = null;
         super.dispose();
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.SHOW_CARDS,this.__showAllCard);
         RoomManager.Instance.removeEventListener(RoomManager.PAYMENT_TAKE_CARD,__disabledAllCards);
      }
   }
}

