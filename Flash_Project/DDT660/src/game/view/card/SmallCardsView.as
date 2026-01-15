package game.view.card
{
   import com.greensock.TweenLite;
   import com.greensock.easing.Quint;
   import com.pickgliss.manager.NoviceDataManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.GameInSocketOut;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PathManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.utils.PositionUtils;
   import fightFootballTime.manager.FightFootballTimeManager;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.geom.Point;
   import flash.utils.Timer;
   import game.GameManager;
   import game.model.GameInfo;
   import game.model.Player;
   import road7th.comm.PackageIn;
   import room.RoomManager;
   import room.model.RoomInfo;
   import trainer.TrainStep;
   import trainer.data.ArrowType;
   import trainer.data.Step;
   import trainer.view.NewHandContainer;
   
   public class SmallCardsView extends Sprite implements Disposeable
   {
      
      public static const SMALL_CARD_TIME:uint = 5;
      
      public static const SMALL_CARD_CNT:uint = 9;
      
      public static const SMALL_CARD_COLUMNS:uint = 3;
      
      public static const SMALL_CARD_MAX_SELECTED_CNT:uint = 1;
      
      public static const SMALL_CARD_REQUEST_CARD:uint = 100;
      
      public static const SMALL_CARD_VIEW_TIME:uint = 1;
      
      public static const ON_ALL_COMPLETE_CNT:uint = 2;
      
      protected var _cards:Vector.<LuckyCard>;
      
      protected var _posArr:Vector.<Point>;
      
      protected var _gameInfo:GameInfo;
      
      protected var _roomInfo:RoomInfo;
      
      protected var _resultCards:Array;
      
      protected var _selectedCnt:int;
      
      protected var _selectCompleted:Boolean;
      
      protected var _countDownView:CardCountDown;
      
      protected var _countDownTime:int = 5;
      
      protected var _cardCnt:int = 9;
      
      protected var _cardColumns:int = 3;
      
      protected var _viewTime:int = 1;
      
      protected var _timerForView:Timer;
      
      protected var _title:Bitmap;
      
      protected var _onAllComplete:int;
      
      protected var _canTakeOut:Boolean;
      
      private var _fightFootballcountDownTime:int = 10;
      
      private var _takeoutNum:int;
      
      private var _iscountDown:Boolean = false;
      
      private var _isshowAll:Boolean;
      
      private var showAllTimer:Timer;
      
      private var otherItem:Array = [];
      
      public function SmallCardsView()
      {
         super();
         this.init();
      }
      
      protected function init() : void
      {
         this._selectedCnt = 0;
         this._selectCompleted = false;
         this._gameInfo = GameManager.Instance.Current;
         this._roomInfo = RoomManager.Instance.current;
         this._resultCards = this._gameInfo.resultCard.concat();
         this._takeoutNum = this._gameInfo.selfGamePlayer.GetCardCount;
         if(this._gameInfo.roomType == FightFootballTimeManager.FIGHTFOOTBALLTIME_ROOM)
         {
            this._timerForView = new Timer(3000,this._viewTime);
         }
         else
         {
            this._timerForView = new Timer(1000,this._viewTime);
         }
         this._timerForView.addEventListener(TimerEvent.TIMER_COMPLETE,this.__timerForViewComplete);
         this._cards = new Vector.<LuckyCard>();
         this._posArr = new Vector.<Point>();
         if(Boolean(GameManager.Instance.Current) && GameManager.Instance.Current.roomType == FightFootballTimeManager.FIGHTFOOTBALLTIME_ROOM)
         {
            this._title = ComponentFactory.Instance.creatBitmap("fightFootballTime.expView.rewardTxtBg");
         }
         else
         {
            this._title = ComponentFactory.Instance.creatBitmap("asset.takeoutCard.TitleBitmap");
         }
         this._countDownView = new CardCountDown();
         if(Boolean(GameManager.Instance.Current) && GameManager.Instance.Current.roomType == FightFootballTimeManager.FIGHTFOOTBALLTIME_ROOM)
         {
            PositionUtils.setPos(this._countDownView,"fightFootballTime.expView.SmallCardViewCountDownPos");
         }
         else
         {
            PositionUtils.setPos(this._countDownView,"takeoutCard.SmallCardViewCountDownPos");
         }
         addChild(this._countDownView);
         if(this._gameInfo.roomType == FightFootballTimeManager.FIGHTFOOTBALLTIME_ROOM)
         {
            this._countDownView.tick(this._fightFootballcountDownTime);
         }
         else
         {
            this._countDownView.tick(this._countDownTime);
         }
         addChild(this._title);
         this.createCards();
         for(var i:int = 0; i < this._resultCards.length; i++)
         {
            this.__takeOut(this._resultCards[i]);
         }
         this.initEvent();
         if(!PlayerManager.Instance.Self.IsWeakGuildFinish(Step.GET_CARD_GUILD))
         {
            TrainStep.send(TrainStep.Step.FIGHT_COMPLETE);
            SocketManager.Instance.out.syncWeakStep(Step.GET_CARD_GUILD);
            NewHandContainer.Instance.showArrow(ArrowType.GET_CARD,-45,"trainer.getCardArrowPos","asset.trainer.getCardTipAsset","trainer.getCardTipPos");
            NoviceDataManager.instance.saveNoviceData(400,PathManager.userName(),PathManager.solveRequestPath());
         }
      }
      
      protected function initEvent() : void
      {
         addEventListener(Event.ADDED_TO_STAGE,this.startTween);
         if(Boolean(this._countDownView))
         {
            this._countDownView.addEventListener(Event.COMPLETE,this.__countDownComplete);
         }
         if(this._gameInfo.roomType == FightFootballTimeManager.FIGHTFOOTBALLTIME_ROOM)
         {
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.FIGHTFOOTBALLTIME_CMD,this.__fightFootballTimetakeOut);
         }
         else
         {
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.GAME_TAKE_OUT,this.__takeOut);
         }
      }
      
      protected function removeEvents() : void
      {
         removeEventListener(Event.ADDED_TO_STAGE,this.startTween);
         if(Boolean(this._countDownView))
         {
            this._countDownView.removeEventListener(Event.COMPLETE,this.__countDownComplete);
         }
         if(this._gameInfo.roomType == FightFootballTimeManager.FIGHTFOOTBALLTIME_ROOM)
         {
            SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.FIGHTFOOTBALLTIME_CMD,this.__fightFootballTimetakeOut);
         }
         else
         {
            SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.GAME_TAKE_OUT,this.__takeOut);
         }
         this._timerForView.removeEventListener(TimerEvent.TIMER_COMPLETE,this.__timerForViewComplete);
      }
      
      protected function __countDownComplete(event:Event) : void
      {
         this._iscountDown = true;
         if(this._gameInfo.roomType == FightFootballTimeManager.FIGHTFOOTBALLTIME_ROOM)
         {
            if(Boolean(this._countDownView))
            {
               this._countDownView.removeEventListener(Event.COMPLETE,this.__countDownComplete);
            }
            if(this._selectCompleted)
            {
               GameInSocketOut.sendFightFootballTimeTakeOut(99);
               return;
            }
            if(!this._selectCompleted)
            {
               GameInSocketOut.sendFightFootballTimeTakeOut(99);
               return;
            }
         }
         else
         {
            ++this._onAllComplete;
            if(Boolean(this._countDownView))
            {
               this._countDownView.removeEventListener(Event.COMPLETE,this.__countDownComplete);
            }
            if(!this._canTakeOut)
            {
               this._timerForView.start();
               return;
            }
            if(!this._selectCompleted && this._canTakeOut)
            {
               GameInSocketOut.sendBossTakeOut(SMALL_CARD_REQUEST_CARD);
               return;
            }
            if(this._onAllComplete >= ON_ALL_COMPLETE_CNT)
            {
               this._timerForView.start();
            }
         }
      }
      
      protected function __timerForViewComplete(event:* = null) : void
      {
         if(Boolean(this._gameInfo))
         {
            this._gameInfo.resetResultCard();
         }
         this._resultCards = null;
         this._timerForView.removeEventListener(TimerEvent.TIMER_COMPLETE,this.__timerForViewComplete);
         if(!this._canTakeOut)
         {
            dispatchEvent(new Event(Event.COMPLETE));
         }
         if(this._onAllComplete >= ON_ALL_COMPLETE_CNT)
         {
            dispatchEvent(new Event(Event.COMPLETE));
         }
         if(this._gameInfo == null)
         {
            return;
         }
         if(this._gameInfo.roomType == FightFootballTimeManager.FIGHTFOOTBALLTIME_ROOM)
         {
            PlayerManager.Instance.Self.Style = PlayerManager.Instance.fightFootballStyle;
            dispatchEvent(new Event(Event.COMPLETE));
         }
      }
      
      private function __fightFootballTimetakeOut(e:CrazyTankSocketEvent) : void
      {
         var showAllCard:Function = null;
         var pkg:PackageIn = null;
         var type:int = 0;
         var info:Player = null;
         var templateID:int = 0;
         var count:int = 0;
         var place:int = 0;
         var canTakeoutCount:int = 0;
         var k:int = 0;
         var itemCount:int = 0;
         var i:int = 0;
         var obj:Object = null;
         showAllCard = function(e:TimerEvent):void
         {
            var timer:Timer = e.currentTarget as Timer;
            timer.removeEventListener(TimerEvent.TIMER_COMPLETE,showAllCard);
            timer = null;
            for(var j:int = 0; j < otherItem.length; j++)
            {
               place = otherItem[j].place;
               templateID = otherItem[j].templateID;
               count = otherItem[j].count;
               _cards[place].play(null,templateID,count,false);
            }
            if(_iscountDown)
            {
               _iscountDown = false;
               _timerForView.start();
            }
         };
         if(!this._cards)
         {
            return;
         }
         if(this._cards.length > 0)
         {
            pkg = e.pkg;
            type = pkg.readInt();
            info = this._gameInfo.selfGamePlayer;
            if(type == 1)
            {
               templateID = pkg.readInt();
               place = pkg.readInt();
               count = pkg.readInt();
               this._cards[place].play(info,templateID,count,false);
               ++this._selectedCnt;
               this._selectCompleted = this._selectedCnt >= this._gameInfo.selfGamePlayer.GetCardCount;
               if(this._selectCompleted)
               {
                  this.__disabledAllCards();
               }
            }
            else if(type == 2)
            {
               this._isshowAll = true;
               canTakeoutCount = pkg.readInt();
               for(k = 0; k < canTakeoutCount; k++)
               {
                  templateID = pkg.readInt();
                  place = pkg.readInt();
                  count = pkg.readInt();
                  this._cards[place].play(info,templateID,count,false);
               }
               itemCount = pkg.readInt();
               for(i = 0; i < itemCount; i++)
               {
                  obj = {};
                  obj.templateID = pkg.readInt();
                  obj.place = pkg.readInt();
                  obj.count = pkg.readInt();
                  this.otherItem.push(obj);
               }
               this.showAllTimer = new Timer(2000,1);
               this.showAllTimer.addEventListener(TimerEvent.TIMER_COMPLETE,showAllCard);
               this.showAllTimer.start();
            }
         }
         else
         {
            this._resultCards.push(e);
         }
      }
      
      protected function __takeOut(e:CrazyTankSocketEvent) : void
      {
         var pkg:PackageIn = null;
         var isSysTake:Boolean = false;
         var place:Number = NaN;
         var templateID:int = 0;
         var count:int = 0;
         var info:Player = null;
         if(!this._cards)
         {
            return;
         }
         if(this._cards.length > 0)
         {
            pkg = e.pkg;
            isSysTake = pkg.readBoolean();
            place = pkg.readByte();
            if(place == 50)
            {
               return;
            }
            templateID = pkg.readInt();
            count = pkg.readInt();
            info = this._gameInfo.findPlayer(pkg.extend1);
            if(Boolean(info))
            {
               if(templateID != -1)
               {
                  this._cards[place].play(info,templateID,count,false);
               }
               if(info.isSelf)
               {
                  ++this._onAllComplete;
                  ++this._selectedCnt;
                  this._selectCompleted = this._selectedCnt >= SMALL_CARD_MAX_SELECTED_CNT;
                  if(this._selectCompleted)
                  {
                     this.__disabledAllCards();
                  }
                  if(this._onAllComplete >= ON_ALL_COMPLETE_CNT)
                  {
                     this._timerForView.start();
                  }
               }
            }
         }
         else
         {
            this._resultCards.push(e);
         }
      }
      
      protected function createCards() : void
      {
         var point:Point = null;
         var item:LuckyCard = null;
         var offset:Point = new Point(26,25);
         for(var i:int = 0; i < this._cardCnt; i++)
         {
            point = new Point();
            if(this._roomInfo.type == RoomInfo.DUNGEON_ROOM || this._roomInfo.type == RoomInfo.FRESHMAN_ROOM || this._roomInfo.type == RoomInfo.ACADEMY_DUNGEON_ROOM)
            {
               item = new LuckyCard(i,LuckyCard.WITHIN_GAME_CARD);
               item.allowClick = this._canTakeOut = this._gameInfo.selfGamePlayer.BossCardCount > 0;
            }
            else if(this._roomInfo.type == RoomInfo.FIGHT_LIB_ROOM)
            {
               item = new LuckyCard(i,LuckyCard.AFTER_GAME_CARD);
               item.allowClick = this._canTakeOut = true;
            }
            else
            {
               item = new LuckyCard(i,LuckyCard.AFTER_GAME_CARD);
               item.allowClick = this._canTakeOut = this._gameInfo.selfGamePlayer.GetCardCount > 0;
            }
            point.x = i % this._cardColumns * (offset.x + item.width) + 87;
            point.y = int(i / this._cardColumns) * (offset.y + item.height) + 32;
            item.x = offset.x + item.width + 87;
            item.y = offset.y + item.height + 32;
            item.msg = LanguageMgr.GetTranslation("tank.gameover.DisableGetCard");
            addChild(item);
            this._posArr.push(point);
            this._cards.push(item);
         }
      }
      
      protected function __disabledAllCards(e:Event = null) : void
      {
         for(var i:int = 0; i < this._cards.length; i++)
         {
            this._cards[i].enabled = false;
         }
      }
      
      protected function startTween(e:Event = null) : void
      {
         removeEventListener(Event.ADDED_TO_STAGE,this.startTween);
         for(var i:int = 0; i < SMALL_CARD_CNT; i++)
         {
            TweenLite.to(this._cards[i],0.8,{
               "startAt":{
                  "x":this._posArr[4].x,
                  "y":this._posArr[4].y
               },
               "x":this._posArr[i].x,
               "y":this._posArr[i].y,
               "ease":Quint.easeOut,
               "onComplete":this.cardTweenComplete,
               "onCompleteParams":[this._cards[i]]
            });
         }
      }
      
      protected function cardTweenComplete(card:LuckyCard) : void
      {
         TweenLite.killTweensOf(card);
         card.enabled = true;
      }
      
      public function dispose() : void
      {
         var card:LuckyCard = null;
         this.removeEvents();
         for each(card in this._cards)
         {
            card.dispose();
         }
         ObjectUtils.disposeObject(this._countDownView);
         ObjectUtils.disposeObject(this._title);
         if(Boolean(this._timerForView))
         {
            this._timerForView.stop();
            this._timerForView = null;
         }
         this._title = null;
         this._cards = null;
         this._posArr = null;
         this._gameInfo = null;
         this._roomInfo = null;
         this._resultCards = null;
         this._countDownView = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

