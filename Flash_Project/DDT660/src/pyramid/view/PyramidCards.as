package pyramid.view
{
   import baglocked.BaglockedManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.GameInSocketOut;
   import ddt.manager.LeavePageManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.geom.Point;
   import flash.utils.Dictionary;
   import flash.utils.Timer;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   import pyramid.PyramidManager;
   import pyramid.data.PyramidSystemItemsInfo;
   import pyramid.event.PyramidEvent;
   
   public class PyramidCards extends Sprite implements Disposeable
   {
      
      public static const SHUFFLE:String = "shuffle";
      
      public static const OPEN:String = "open";
      
      public static const CLOSE:String = "close";
      
      public static const BG:String = "bg";
      
      private var _topBox:PyramidTopBox;
      
      private var _cards:Dictionary;
      
      private var _cardsSprite:Sprite;
      
      private var _currentCard:PyramidCard;
      
      private var _shuffleMovie:MovieClip;
      
      private var _movieCountArr:Array;
      
      private var _playLevel:int;
      
      private var _shuffleWaitTimer:Timer;
      
      private var _timerCurrentCount:int;
      
      private var _playLevelMovieStep:int = 0;
      
      private var _timerOutNum:uint;
      
      public function PyramidCards()
      {
         super();
         this.initView();
         this.initEvent();
         this.initData();
      }
      
      private function initView() : void
      {
         this._shuffleMovie = ComponentFactory.Instance.creat("assets.pyramid.shuffle");
         this._shuffleMovie.gotoAndStop(1);
         PositionUtils.setPos(this._shuffleMovie,"pyramid.view.shufflePos");
         this._shuffleMovie.visible = false;
         addChild(this._shuffleMovie);
         this._cardsSprite = new Sprite();
         addChild(this._cardsSprite);
         this._topBox = ComponentFactory.Instance.creatCustomObject("pyramid.topBox");
         this._topBox.addTopBoxMovie(this);
         addChild(this._topBox);
         if(PyramidManager.instance.model.currentLayer >= 8)
         {
            this.topBoxMovieMode(1);
         }
         else
         {
            this.topBoxMovieMode();
         }
         this._shuffleWaitTimer = new Timer(800,1);
      }
      
      private function initEvent() : void
      {
         this._topBox.addEventListener(MouseEvent.CLICK,this.__cardClickHandler);
         this._shuffleWaitTimer.addEventListener(TimerEvent.TIMER,this.__shuffleWaitTimerHandler);
      }
      
      private function initData() : void
      {
         var j:int = 0;
         this._cards = new Dictionary();
         for(var i:int = 7; i >= 1; i--)
         {
            this._cards[i] = new Dictionary();
            for(j = 8; j >= i; j--)
            {
               this.createCard(i,9 - j);
            }
         }
         this.updateSelectItems();
         this.playShuffleFullMovie();
      }
      
      private function createCard(i:int, j:int) : void
      {
         var cardSp:PyramidCard = null;
         var cardPosition:Point = null;
         cardSp = new PyramidCard();
         cardSp.index = i + "_" + j;
         cardPosition = PositionUtils.creatPoint("pyramid.view.cardPos" + cardSp.index);
         cardSp.x = cardPosition.x;
         cardSp.y = cardPosition.y;
         this._cards[i][j] = cardSp;
         cardSp.addEventListener(MouseEvent.CLICK,this.__cardClickHandler);
         cardSp.addEventListener(PyramidEvent.OPENANDCLOSE_MOVIE,this.__cardOpenMovieHandler);
         this._cardsSprite.addChild(cardSp);
      }
      
      public function topBoxMovieMode(modeType:int = 0) : void
      {
         this._topBox.topBoxMovieMode(modeType);
      }
      
      private function __cardClickHandler(event:MouseEvent) : void
      {
         var card:PyramidCard = null;
         SoundManager.instance.play("008");
         if(PyramidManager.instance.clickRateGo)
         {
            return;
         }
         if(PyramidManager.instance.movieLock)
         {
            return;
         }
         if(!PyramidManager.instance.model.isOpen)
         {
            return;
         }
         if(event.currentTarget == this._topBox && this._topBox.state == 1)
         {
            this.openTopBox();
         }
         else if(event.currentTarget is PyramidCard && !PyramidManager.instance.isAutoOpenCard)
         {
            card = PyramidCard(event.currentTarget);
            this.openCurrendCard(card);
         }
      }
      
      private function openTopBox() : void
      {
         this._currentCard = null;
         this.topBoxMovieMode(2);
         GameInSocketOut.sendPyramidTurnCard(8,1);
      }
      
      private function openCurrendCard($card:PyramidCard) : void
      {
         this._currentCard = $card;
         if(this._currentCard.state != 3)
         {
            return;
         }
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         var freeCount:int = PyramidManager.instance.model.freeCount - PyramidManager.instance.model.currentFreeCount;
         if(freeCount <= 0)
         {
            if(PlayerManager.Instance.Self.Money < PyramidManager.instance.model.turnCardPrice)
            {
               LeavePageManager.showFillFrame();
               PyramidManager.instance.isAutoOpenCard = false;
               return;
            }
         }
         var arr:Array = this._currentCard.index.split("_");
         if(freeCount <= 0 && PyramidManager.instance.isShowBuyFrameSelectedCheck)
         {
            PyramidManager.instance.showFrame(5,arr);
            return;
         }
         PyramidManager.instance.movieLock = true;
         GameInSocketOut.sendPyramidTurnCard(arr[0],arr[1]);
      }
      
      public function playTurnCardMovie() : void
      {
         PyramidManager.instance.movieLock = true;
         this._movieCountArr = [1,0];
         var level:int = PyramidManager.instance.model.currentLayer;
         var templateID:int = PyramidManager.instance.model.templateID;
         var tempItem:PyramidSystemItemsInfo = PyramidManager.instance.model.getLevelCardItem(level,templateID);
         this._currentCard.cardState(2,tempItem);
         this.checkAutoOpenCard();
      }
      
      private function __cardOpenMovieHandler(event:PyramidEvent) : void
      {
         var arr:Array = null;
         var currentLevelNum:int = 0;
         var repeatCount:int = 0;
         if(!this._movieCountArr)
         {
            return;
         }
         var count1:int = int(this._movieCountArr[0]);
         var count2:int = int(this._movieCountArr[1]);
         count2++;
         this._movieCountArr[1] = count2;
         if(count1 == count2)
         {
            this._movieCountArr = null;
            if(this._playLevelMovieStep == 1)
            {
               arr = PyramidManager.instance.model.getLevelCardItems(this._playLevel);
               currentLevelNum = 9 - this._playLevel;
               repeatCount = arr.length / (9 - this._playLevel);
               if(arr.length % currentLevelNum > 0)
               {
                  repeatCount++;
               }
               this._shuffleWaitTimer.repeatCount = repeatCount;
               this._timerCurrentCount = 0;
               this._shuffleWaitTimer.reset();
               this._shuffleWaitTimer.start();
            }
            else if(this._playLevelMovieStep == 2)
            {
               this.playShuffleMovie();
            }
            else
            {
               PyramidManager.instance.movieLock = false;
               this.playShuffleFullMovie();
            }
         }
      }
      
      public function playShuffleFullMovie() : void
      {
         if(PyramidManager.instance.model.isShuffleMovie)
         {
            PyramidManager.instance.movieLock = true;
            this.playLevelMovie(PyramidManager.instance.model.currentLayer,BG);
            this.playLevelMovie(PyramidManager.instance.model.currentLayer,OPEN);
            this._playLevelMovieStep = 1;
         }
      }
      
      private function __shuffleWaitTimerHandler(event:TimerEvent) : void
      {
         ++this._timerCurrentCount;
         if(this._timerCurrentCount >= this._shuffleWaitTimer.repeatCount)
         {
            this.playLevelMovie(this._playLevel,CLOSE);
            this._shuffleWaitTimer.stop();
            this._playLevelMovieStep = 2;
         }
         else
         {
            this.cardLevelTimerDataUpdate(this._playLevel,this._timerCurrentCount);
         }
      }
      
      private function playShuffleMovie() : void
      {
         this.cardLevelVisible(this._playLevel,false);
         this.playLevelMovie(this._playLevel,SHUFFLE);
         this._playLevelMovieStep = 3;
      }
      
      private function shuffleFrameScript() : void
      {
         if(Boolean(this._cards))
         {
            this.cardLevelState(this._playLevel,3);
            this.cardLevelVisible(this._playLevel,true);
         }
         this._playLevelMovieStep = 0;
         PyramidManager.instance.movieLock = false;
         this.checkAutoOpenCard();
      }
      
      public function checkAutoOpenCard() : void
      {
         if(this._timerOutNum != 0)
         {
            clearTimeout(this._timerOutNum);
         }
         this._timerOutNum = setTimeout(this.exeAutoOpenCard,1000);
      }
      
      private function exeAutoOpenCard() : void
      {
         var tempArr:Array = null;
         var dic1:Dictionary = null;
         var i:int = 0;
         var tempNum:int = 0;
         var tempCard:PyramidCard = null;
         if(PyramidManager.instance.model.isPyramidStart && PyramidManager.instance.isAutoOpenCard)
         {
            if(PyramidManager.instance.model.currentLayer >= 8)
            {
               this.openTopBox();
               --PyramidManager.instance.autoCount;
               if(PyramidManager.instance.autoCount > 0)
               {
                  PyramidManager.instance.isAutoOpenCard = true;
               }
               else
               {
                  PyramidManager.instance.isAutoOpenCard = false;
               }
            }
            else
            {
               tempArr = [];
               dic1 = Dictionary(this._cards[this._playLevel]);
               for(i = 1; i <= 9 - this._playLevel; i++)
               {
                  if(dic1[i].state == 3)
                  {
                     tempArr.push(i);
                  }
               }
               if(tempArr.length > 0)
               {
                  tempNum = int(Math.random() * tempArr.length);
                  tempCard = this._cards[this._playLevel][tempArr[tempNum]];
                  this.openCurrendCard(tempCard);
               }
            }
         }
      }
      
      public function playLevelMovie(level:int, action:String) : void
      {
         var tempMovie:MovieClip = null;
         var arr:Array = null;
         var dic1:Dictionary = null;
         var i:int = 0;
         var itemInfo:PyramidSystemItemsInfo = null;
         var dic2:Dictionary = null;
         var card2:PyramidCard = null;
         this._playLevel = level;
         if(action == SHUFFLE || action == BG)
         {
            this._shuffleMovie.visible = true;
            this._shuffleMovie.gotoAndStop(this._playLevel);
            tempMovie = MovieClip(this._shuffleMovie["level" + this._playLevel]);
            if(Boolean(tempMovie))
            {
               if(action == SHUFFLE)
               {
                  tempMovie.addFrameScript(tempMovie.totalFrames - 2,this.shuffleFrameScript);
                  tempMovie.gotoAndPlay(action);
               }
               else
               {
                  tempMovie.gotoAndStop(action);
               }
            }
         }
         else if(action == OPEN)
         {
            arr = PyramidManager.instance.model.getLevelCardItems(this._playLevel);
            dic1 = Dictionary(this._cards[this._playLevel]);
            for(i = 1; i <= 9 - this._playLevel; i++)
            {
               itemInfo = arr[i - 1];
               dic1[i].cardState(2,itemInfo);
            }
            this._movieCountArr = [9 - this._playLevel,0];
            PyramidManager.instance.movieLock = true;
         }
         else if(action == CLOSE)
         {
            dic2 = Dictionary(this._cards[this._playLevel]);
            for each(card2 in dic2)
            {
               card2.cardState(4);
            }
            this._movieCountArr = [9 - this._playLevel,0];
            PyramidManager.instance.movieLock = true;
         }
      }
      
      private function cardLevelVisible(level:int, bool:Boolean) : void
      {
         var card:PyramidCard = null;
         var dic:Dictionary = Dictionary(this._cards[level]);
         for each(card in dic)
         {
            card.visible = bool;
         }
      }
      
      private function cardLevelState(level:int, state:int) : void
      {
         var card:PyramidCard = null;
         var dic:Dictionary = Dictionary(this._cards[level]);
         for each(card in dic)
         {
            card.cardState(state);
         }
      }
      
      private function cardLevelTimerDataUpdate(level:int, repeatCount:int) : void
      {
         var itemInfo:PyramidSystemItemsInfo = null;
         var index:int = 0;
         if(repeatCount > 0)
         {
            index = repeatCount * (9 - level);
         }
         var arr:Array = PyramidManager.instance.model.getLevelCardItems(level);
         var dic:Dictionary = Dictionary(this._cards[level]);
         for(var i:int = 1; i <= 9 - level; i++)
         {
            if(arr.length <= index)
            {
               break;
            }
            itemInfo = arr[index];
            dic[i].cardState(5,itemInfo);
            index++;
         }
      }
      
      public function updateSelectItems() : void
      {
         var dic1:Dictionary = null;
         var key1:String = null;
         var dic2:Dictionary = null;
         var key2:String = null;
         var tempId:int = 0;
         var level:int = 0;
         var item:PyramidSystemItemsInfo = null;
         var dic3:Dictionary = null;
         var card1:PyramidCard = null;
         if(PyramidManager.instance.model.isPyramidStart)
         {
            dic1 = PyramidManager.instance.model.selectLayerItems;
            for(key1 in dic1)
            {
               dic2 = dic1[key1];
               for(key2 in dic2)
               {
                  tempId = int(dic2[key2]);
                  level = int(key1);
                  item = PyramidManager.instance.model.getLevelCardItem(level,tempId);
                  PyramidCard(this._cards[key1][key2]).cardState(1,item);
               }
            }
            if(!PyramidManager.instance.model.isShuffleMovie && PyramidManager.instance.model.isPyramidStart && PyramidManager.instance.model.currentLayer < 8)
            {
               this.playLevelMovie(PyramidManager.instance.model.currentLayer,BG);
               dic3 = Dictionary(this._cards[PyramidManager.instance.model.currentLayer]);
               for each(card1 in dic3)
               {
                  if(card1.state == 0)
                  {
                     card1.cardState(3);
                  }
               }
            }
         }
         else if(PyramidManager.instance.movieLock && Boolean(this._cardsSprite))
         {
            if(!this._cardsSprite.hasEventListener(Event.ENTER_FRAME))
            {
               this._cardsSprite.addEventListener(Event.ENTER_FRAME,this.__delayReset);
            }
         }
         else
         {
            this.reset();
         }
      }
      
      private function __delayReset(event:Event) : void
      {
         if(!PyramidManager.instance.movieLock)
         {
            this.reset();
            this._cardsSprite.removeEventListener(Event.ENTER_FRAME,this.__delayReset);
         }
      }
      
      public function upClear() : void
      {
         var dic1:Dictionary = null;
         var card1:PyramidCard = null;
         if(!PyramidManager.instance.model.isUp)
         {
            return;
         }
         var level:int = PyramidManager.instance.model.currentLayer;
         if(level - 1 > 0)
         {
            dic1 = Dictionary(this._cards[level - 1]);
            for each(card1 in dic1)
            {
               if(card1.state == 3)
               {
                  card1.cardState(0);
               }
            }
         }
      }
      
      public function reset() : void
      {
         var obj1:Dictionary = null;
         var obj2:PyramidCard = null;
         for each(obj1 in this._cards)
         {
            for each(obj2 in obj1)
            {
               obj2.reset();
            }
         }
         this._playLevelMovieStep = 0;
         this._timerCurrentCount = 0;
         this._shuffleMovie.gotoAndStop(1);
         this._shuffleMovie.visible = false;
         this.topBoxMovieMode();
      }
      
      public function dispose() : void
      {
         var obj1:Dictionary = null;
         var obj2:PyramidCard = null;
         if(this._timerOutNum != 0)
         {
            clearTimeout(this._timerOutNum);
         }
         PyramidManager.instance.isAutoOpenCard = false;
         this._topBox.removeEventListener(MouseEvent.CLICK,this.__cardClickHandler);
         this._shuffleWaitTimer.stop();
         this._shuffleWaitTimer.removeEventListener(TimerEvent.TIMER,this.__shuffleWaitTimerHandler);
         this._shuffleWaitTimer = null;
         for each(obj1 in this._cards)
         {
            for each(obj2 in obj1)
            {
               obj2.removeEventListener(MouseEvent.CLICK,this.__cardClickHandler);
               obj2.removeEventListener(PyramidEvent.OPENANDCLOSE_MOVIE,this.__cardOpenMovieHandler);
               obj2.dispose();
            }
         }
         this._cards = null;
         this._currentCard = null;
         this._movieCountArr = null;
         if(Boolean(this._cardsSprite))
         {
            this._cardsSprite.removeEventListener(Event.ENTER_FRAME,this.__delayReset);
            ObjectUtils.disposeAllChildren(this._cardsSprite);
            ObjectUtils.disposeObject(this._cardsSprite);
            this._cardsSprite = null;
         }
         ObjectUtils.disposeObject(this._topBox);
         this._topBox = null;
         ObjectUtils.disposeObject(this._shuffleMovie);
         this._shuffleMovie = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

