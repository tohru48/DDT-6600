package game.view.experience
{
   import com.greensock.TweenMax;
   import com.greensock.easing.Quint;
   import com.greensock.plugins.MotionBlurPlugin;
   import com.greensock.plugins.TweenPlugin;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.player.SelfInfo;
   import ddt.events.GameEvent;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import fightFootballTime.manager.FightFootballTimeManager;
   import fightFootballTime.view.FightFootballTimeExpLeftView;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.filters.BlurFilter;
   import game.GameManager;
   import game.model.GameInfo;
   import game.model.Living;
   import game.model.Player;
   import game.view.card.LargeCardsView;
   import game.view.card.SmallCardsView;
   import game.view.card.TakeOutCardController;
   import room.RoomManager;
   import room.model.RoomInfo;
   
   [Event(name="expshowed",type="ddt.events.GameEvent")]
   public class ExpView extends Sprite implements Disposeable
   {
      
      public static const GAME_OVER_TYPE_0:uint = 0;
      
      public static const GAME_OVER_TYPE_1:uint = 1;
      
      public static const GAME_OVER_TYPE_2:uint = 2;
      
      public static const GAME_OVER_TYPE_3:uint = 3;
      
      public static const GAME_OVER_TYPE_4:uint = 4;
      
      public static const GAME_OVER_TYPE_5:uint = 5;
      
      public static const GAME_OVER_TYPE_6:uint = 6;
      
      private var _bg:Bitmap;
      
      private var _leftView:ExpLeftView;
      
      private var _rightView:Sprite;
      
      private var _shape:Shape;
      
      private var _resultSeal:ExpResultSeal;
      
      private var _titleBitmap:Bitmap;
      
      private var _fightView:ExpFightExpItem;
      
      private var _attatchView:ExpAttatchExpItem;
      
      private var _exploitView:ExpExploitItem;
      
      private var _totalView:ExpTotalItem;
      
      private var _cardController:TakeOutCardController;
      
      private var _smallCardsView:SmallCardsView;
      
      private var _largeCardsView:LargeCardsView;
      
      private var _blurStep:int;
      
      private var _blurFilter:BlurFilter;
      
      private var _totalExploit:int;
      
      private var _fightNums:Array;
      
      private var _attatchNums:Array;
      
      private var _exploitNums:Array;
      
      private var _gameInfo:GameInfo;
      
      private var _isOnlyLeftOut:Boolean;
      
      private var _isNoCardView:Boolean;
      
      private var _luckyExp:Boolean = false;
      
      private var _luckyOffer:Boolean = false;
      
      private var _expObj:Object;
      
      public function ExpView(bg:Bitmap = null)
      {
         super();
         this._bg = bg;
      }
      
      public function show() : void
      {
         this._gameInfo = GameManager.Instance.Current;
         var selfInfo:SelfInfo = PlayerManager.Instance.Self;
         this._cardController = new TakeOutCardController();
         var player:Player = this._gameInfo.findPlayerByPlayerID(selfInfo.ID);
         if(RoomManager.Instance.current.selfRoomPlayer.isViewer || !player)
         {
            this.onAllComplete();
            return;
         }
         ExpTweenManager.Instance.isPlaying = true;
         LayerManager.Instance.clearnGameDynamic();
         LayerManager.Instance.clearnStageDynamic();
         var obj:Object = this._expObj = this._gameInfo.selfGamePlayer.expObj;
         if(obj && obj.hasOwnProperty("luckyExp") && obj.luckyExp > 0)
         {
            this._luckyExp = true;
         }
         if(obj && obj.hasOwnProperty("luckyOffer") && obj.luckyOffer > 0)
         {
            this._luckyOffer = true;
         }
         if(this._gameInfo.roomType == FightFootballTimeManager.FIGHTFOOTBALLTIME_ROOM && Boolean(obj))
         {
            obj.gameOverType = GAME_OVER_TYPE_2;
            SoundManager.instance.play(this._gameInfo.selfGamePlayer.isWin ? "063" : "064");
            this._isOnlyLeftOut = true;
         }
         switch(obj && obj.gameOverType)
         {
            case GAME_OVER_TYPE_0:
               this.onAllComplete();
               return;
            case GAME_OVER_TYPE_1:
               SoundManager.instance.play(this._gameInfo.selfGamePlayer.isWin ? "063" : "064");
               this._fightNums = [obj.killGP,obj.hertGP,obj.fightGP,obj.ghostGP];
               this._attatchNums = [obj.gpForVIP,obj.gpForConsortia,obj.gpForSpouse,obj.gpForServer,obj.gpForApprenticeOnline,obj.gpForApprenticeTeam,obj.gpForDoubleCard,obj.gpForPower,obj.consortiaSkill];
               this._exploitNums = [obj.offerFight,obj.offerDoubleCard,obj.offerVIP,obj.offerService,obj.offerBuff,obj.offerConsortia];
               this.setDefyInfo();
               break;
            case GAME_OVER_TYPE_2:
               SoundManager.instance.play(this._gameInfo.selfGamePlayer.isWin ? "063" : "064");
               this._isOnlyLeftOut = true;
               break;
            case GAME_OVER_TYPE_3:
               SoundManager.instance.play(this._gameInfo.selfGamePlayer.isWin ? "063" : "064");
               if(Boolean(this._bg))
               {
                  addChild(this._bg);
               }
               this.changeDark();
               this.onAllComplete();
               return;
            case GAME_OVER_TYPE_4:
               SoundManager.instance.play(this._gameInfo.selfGamePlayer.isWin ? "063" : "064");
               this._fightNums = [obj.killGP,obj.hertGP,obj.fightGP,obj.ghostGP];
               this._attatchNums = [obj.gpForVIP,obj.gpForSpouse,obj.gpForServer,obj.gpForApprenticeOnline,obj.gpForApprenticeTeam,obj.gpForDoubleCard,obj.consortiaSkill];
               break;
            case GAME_OVER_TYPE_5:
               if(this._gameInfo.roomType == RoomInfo.FIGHT_LIB_ROOM)
               {
                  this.onAllComplete();
                  return;
               }
               this._isNoCardView = true;
               SoundManager.instance.play(this._gameInfo.selfGamePlayer.isWin ? "063" : "064");
               this._fightNums = [obj.killGP,obj.hertGP,obj.fightGP,obj.ghostGP];
               this._attatchNums = [obj.gpForVIP,obj.gpForSpouse,obj.gpForServer,obj.gpForApprenticeOnline,obj.gpForApprenticeTeam,obj.gpForDoubleCard,obj.consortiaSkill];
               break;
            case GAME_OVER_TYPE_6:
               this._fightNums = [obj.killGP,obj.hertGP,obj.fightGP,obj.ghostGP];
               SoundManager.instance.play(this._gameInfo.selfGamePlayer.isWin ? "063" : "064");
               this._attatchNums = [obj.gpForVIP,obj.gpForConsortia,obj.gpForSpouse,obj.gpForServer,obj.gpForApprenticeOnline,obj.gpForApprenticeTeam,obj.gpForDoubleCard,obj.consortiaSkill];
         }
         this.validateData(this._fightNums);
         this.validateData(this._attatchNums);
         this._blurFilter = new BlurFilter();
         TweenPlugin.activate([MotionBlurPlugin]);
         this._rightView = new Sprite();
         PositionUtils.setPos(this._rightView,"experience.RightViewPos");
         if(Boolean(this._bg))
         {
            addChild(this._bg);
         }
         this.changeDark();
         addChild(this._rightView);
         this.leftView();
         if(this._isOnlyLeftOut)
         {
            ExpTweenManager.Instance.appendTween(TweenMax.to(this,0.5,{
               "onComplete":this.onAllComplete,
               "onStart":this.fastComplete
            }));
         }
         else
         {
            this.resultSealView();
            this.titleView();
            this.fightView();
            this.attatchView();
            this.exploitView();
            ExpTweenManager.Instance.appendTween(TweenMax.to(this,2,{
               "onComplete":this.onAllComplete,
               "onStart":this.fastComplete
            }));
         }
         ExpTweenManager.Instance.startTweens();
      }
      
      protected function __clickHandler(event:MouseEvent) : void
      {
         this.showCard();
      }
      
      private function validateData(arr:Array) : void
      {
         if(arr == null)
         {
            return;
         }
         for(var i:int = 0; i < arr.length; i++)
         {
            if(isNaN(arr[i]))
            {
               arr[i] = 0;
            }
         }
      }
      
      private function fastComplete() : void
      {
         if(Boolean(this._totalView))
         {
            this._totalView.playGreenLight();
         }
         ExpTweenManager.Instance.speedRecover();
      }
      
      private function changeDark() : void
      {
         this._shape = new Shape();
         this._shape.graphics.beginFill(0,1);
         this._shape.graphics.drawRect(-2,-2,1002,602);
         this._shape.graphics.endFill();
         this._shape.alpha = 0;
         TweenMax.to(this._shape,0.5,{"alpha":0.8});
         addChild(this._shape);
      }
      
      private function leftView() : void
      {
         var shuoming:Bitmap = null;
         if(this._gameInfo.roomType == FightFootballTimeManager.FIGHTFOOTBALLTIME_ROOM)
         {
            this._leftView = new FightFootballTimeExpLeftView();
            this._leftView.alpha = 0;
            shuoming = ComponentFactory.Instance.creatBitmap("fightFootballTime.expView.shuoming");
            addChild(this._leftView);
            addChild(shuoming);
            ExpTweenManager.Instance.appendTween(TweenMax.to(this._leftView,0.5,{
               "alpha":1,
               "x":8,
               "y":32
            }));
         }
         else
         {
            this._leftView = new ExpLeftView();
            this._leftView.alpha = 0;
            addChild(this._leftView);
            ExpTweenManager.Instance.appendTween(TweenMax.to(this._leftView,0.5,{
               "alpha":1,
               "x":8,
               "y":9
            }));
         }
      }
      
      private function resultSealView() : void
      {
         var result:String = this._gameInfo.selfGamePlayer.isWin ? ExpResultSeal.WIN : ExpResultSeal.LOSE;
         this._resultSeal = new ExpResultSeal(result,this._luckyExp,this._luckyOffer);
         this._rightView.addChild(this._resultSeal);
         ExpTweenManager.Instance.appendTween(TweenMax.from(this._resultSeal,0.5,{
            "x":1000,
            "ease":Quint.easeIn,
            "motionBlur":{
               "strength":2,
               "quality":1
            },
            "onComplete":this.blurTween
         }),-0.4);
      }
      
      private function titleView() : void
      {
         this._titleBitmap = ComponentFactory.Instance.creatBitmap("asset.experience.rightViewTitleBg");
         this._rightView.addChildAt(this._titleBitmap,0);
         ExpTweenManager.Instance.appendTween(TweenMax.from(this._titleBitmap,0.5,{
            "x":1000,
            "ease":Quint.easeIn,
            "motionBlur":{
               "strength":2,
               "quality":1
            }
         }));
      }
      
      private function fightView() : void
      {
         var checkZero:Function = null;
         checkZero = function():void
         {
            if(_fightNums.every(equalsZero))
            {
               _totalView.updateTotalExp(0);
            }
         };
         this._fightView = new ExpFightExpItem(this._fightNums);
         this._fightView.addEventListener(Event.CHANGE,this.__updateTotalExp);
         ExpTweenManager.Instance.appendTween(TweenMax.from(this._fightView,0.5,{
            "x":1000,
            "ease":Quint.easeIn,
            "motionBlur":{
               "strength":2,
               "quality":1
            }
         }));
         this._fightView.createView();
         this._rightView.addChildAt(this._fightView,0);
         this._totalView = new ExpTotalItem();
         this._rightView.addChild(this._totalView);
         ExpTweenManager.Instance.appendTween(TweenMax.from(this._totalView,0.5,{
            "x":1000,
            "ease":Quint.easeIn,
            "motionBlur":{
               "strength":2,
               "quality":1
            },
            "onComplete":checkZero
         }),-1);
      }
      
      private function attatchView() : void
      {
         this._attatchView = new ExpAttatchExpItem(this._attatchNums);
         this._attatchView.addEventListener(Event.CHANGE,this.__updateTotalExp);
         ExpTweenManager.Instance.appendTween(TweenMax.from(this._attatchView,0.5,{
            "x":1000,
            "ease":Quint.easeIn,
            "motionBlur":{
               "strength":2,
               "quality":1
            },
            "onStart":this._totalView.playRedLight
         }));
         this._attatchView.createView();
         this._rightView.addChild(this._attatchView);
      }
      
      private function exploitView() : void
      {
         var checkZero:Function = null;
         checkZero = function():void
         {
            if(_exploitNums.every(equalsZero))
            {
               _totalView.updateTotalExploit(0);
            }
         };
         if(!this._exploitNums || this._exploitNums.length == 0)
         {
            return;
         }
         this._exploitView = new ExpExploitItem(this._exploitNums);
         this._exploitView.addEventListener(Event.CHANGE,this.__updateTotalExploit);
         ExpTweenManager.Instance.appendTween(TweenMax.from(this._exploitView,0.5,{
            "x":1000,
            "ease":Quint.easeIn,
            "motionBlur":{
               "strength":2,
               "quality":1
            },
            "onStart":this._totalView.playRedLight,
            "onComplete":checkZero
         }));
         this._exploitView.createView();
         this._rightView.addChild(this._exploitView);
      }
      
      private function __updateTotalExp(event:Event) : void
      {
         var gainGP:int = int(GameManager.Instance.Current.selfGamePlayer.expObj.gainGP);
         this._totalView.updateTotalExp(gainGP);
      }
      
      private function equalsZero(element:*, index:int, arr:Array) : Boolean
      {
         return element == 0;
      }
      
      private function __updateTotalExploit(event:Event) : void
      {
         this._totalExploit += event.currentTarget.targetValue;
         if(Boolean(this._expObj) && Boolean(this._expObj.hasOwnProperty("luckyOffer")))
         {
            this._totalView.updateTotalExploit(event.currentTarget.targetValue + this._expObj.luckyOffer);
         }
         else
         {
            this._totalView.updateTotalExploit(event.currentTarget.targetValue);
         }
      }
      
      public function close() : void
      {
         this._cardController.setState();
      }
      
      public function showCard() : void
      {
         this._cardController.showSmallCardView = this.showSmallCardView;
         this._cardController.showLargeCardView = this.showLargeCardView;
         this._cardController.tryShowCard();
      }
      
      private function onAllComplete() : void
      {
         ExpTweenManager.Instance.completeTweens();
         ExpTweenManager.Instance.deleteTweens();
         this._cardController.setup(this._gameInfo,RoomManager.Instance.current);
         this._cardController.disposeFunc = this.dispose;
         dispatchEvent(new GameEvent(GameEvent.EXPSHOWED,null));
      }
      
      private function showSmallCardView(view:DisplayObject) : void
      {
         var addCardView:Function = null;
         addCardView = function():void
         {
            TweenMax.killTweensOf(_rightView);
            addChild(view);
         };
         if(Boolean(this._rightView))
         {
            TweenMax.to(this._rightView,0.4,{
               "x":"1000",
               "ease":Quint.easeOut,
               "onComplete":addCardView
            });
         }
         else
         {
            addCardView();
         }
      }
      
      private function showLargeCardView(view:DisplayObject) : void
      {
         var addCardView:Function = null;
         addCardView = function():void
         {
            TweenMax.killTweensOf(_rightView);
            TweenMax.killTweensOf(_leftView);
            addChild(view);
         };
         if(Boolean(this._rightView))
         {
            TweenMax.to(this._rightView,0.4,{
               "x":"1000",
               "ease":Quint.easeOut,
               "onComplete":addCardView
            });
         }
         else
         {
            addCardView();
         }
         if(Boolean(this._leftView))
         {
            TweenMax.to(this._leftView,0.4,{
               "x":"-1000",
               "ease":Quint.easeOut
            });
         }
      }
      
      private function blurTween(e:Event = null) : void
      {
         if(this._blurStep == 0)
         {
            addEventListener(Event.ENTER_FRAME,this.blurTween);
         }
         switch(this._blurStep)
         {
            case 0:
               this._blurFilter.blurX = this._blurFilter.blurY = 10;
               filters = [this._blurFilter];
               x -= 10;
               y -= 6;
               scaleY = scaleX = 1.01;
               break;
            case 1:
               this._blurFilter.blurY = 5;
               filters = [this._blurFilter];
               y += 6;
               scaleY = 1.005;
               break;
            default:
               filters = [];
               x += 10;
               scaleY = scaleX = 1;
               removeEventListener(Event.ENTER_FRAME,this.blurTween);
         }
         ++this._blurStep;
      }
      
      private function setDefyInfo() : void
      {
         var i:Living = null;
         var player:Player = null;
         var winDefy:Array = [];
         var failDefy:Array = [];
         var defy:Array = [];
         for each(i in this._gameInfo.livings)
         {
            player = i as Player;
            if(player == null)
            {
               return;
            }
            if(player.isWin)
            {
               winDefy.unshift(player.playerInfo.NickName);
            }
            else
            {
               failDefy.unshift(player.playerInfo.NickName);
            }
         }
         defy[0] = winDefy;
         defy[1] = failDefy;
         RoomManager.Instance.setRoomDefyInfo(defy);
      }
      
      public function dispose() : void
      {
         removeEventListener(Event.ENTER_FRAME,this.blurTween);
         if(Boolean(this._fightView))
         {
            this._fightView.removeEventListener(Event.CHANGE,this.__updateTotalExp);
         }
         if(Boolean(this._attatchView))
         {
            this._attatchView.removeEventListener(Event.CHANGE,this.__updateTotalExp);
         }
         if(Boolean(this._exploitView))
         {
            this._exploitView.removeEventListener(Event.CHANGE,this.__updateTotalExploit);
         }
         if(Boolean(this._bg))
         {
            ObjectUtils.disposeObject(this._bg);
            this._bg = null;
         }
         if(Boolean(this._leftView))
         {
            this._leftView.dispose();
            this._leftView = null;
         }
         if(Boolean(this._resultSeal))
         {
            this._resultSeal.dispose();
            this._resultSeal = null;
         }
         if(Boolean(this._titleBitmap))
         {
            this._titleBitmap.parent.removeChild(this._titleBitmap);
            this._titleBitmap.bitmapData.dispose();
            this._titleBitmap = null;
         }
         if(Boolean(this._fightView))
         {
            this._fightView.dispose();
            this._fightView = null;
         }
         if(Boolean(this._attatchView))
         {
            this._attatchView.dispose();
            this._attatchView = null;
         }
         if(Boolean(this._exploitView))
         {
            this._exploitView.dispose();
            this._exploitView = null;
         }
         if(Boolean(this._totalView))
         {
            this._totalView.dispose();
            this._totalView = null;
         }
         if(Boolean(this._smallCardsView))
         {
            this._smallCardsView.dispose();
            this._smallCardsView = null;
         }
         if(Boolean(this._rightView))
         {
            removeChild(this._rightView);
         }
         this._cardController = null;
         this._rightView = null;
         this._blurFilter = null;
         this._fightNums = null;
         this._attatchNums = null;
         this._exploitNums = null;
         this._shape = null;
         this._gameInfo = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

