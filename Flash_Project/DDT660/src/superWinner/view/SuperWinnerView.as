package superWinner.view
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.ChatManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.StateManager;
   import ddt.manager.TimeManager;
   import ddt.states.StateType;
   import ddt.utils.PositionUtils;
   import ddt.view.chat.ChatView;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   import superWinner.controller.SuperWinnerController;
   import superWinner.data.SuperWinnerAwardsMode;
   import superWinner.event.SuperWinnerEvent;
   import superWinner.manager.SuperWinnerManager;
   import superWinner.model.SuperWinnerModel;
   import superWinner.view.bigAwards.SuperWinnerBigAwardView;
   import superWinner.view.smallAwards.SuperWinnerSmallAwardView;
   
   public class SuperWinnerView extends Sprite implements Disposeable
   {
      
      private var _model:SuperWinnerModel = SuperWinnerController.instance.model;
      
      private var _contro:SuperWinnerController;
      
      private var _dicesbanner:DicesBanner;
      
      private var _championDicesbanner:DicesBanner;
      
      private var _dicesMovie:DicesMovieSprite;
      
      private var _progressBar:SuperWinnerProgressBar;
      
      private var _rollDiceBtn:BaseButton;
      
      private var _playerList:SuperWinnerPlayerListView;
      
      private var _awardView:SuperWinnerBigAwardView;
      
      private var _myAwardView:SuperWinnerSmallAwardView;
      
      private var returnBtn:SuperWinnerReturn;
      
      private var _champion:SuperWinnerPlayerItem;
      
      private var _chatView:ChatView;
      
      private var _endTimeTxt:FilterFrameText;
      
      private var _time:Timer = new Timer(1000);
      
      private var _remainTime:uint = 0;
      
      private var _helpBtn:BaseButton;
      
      private var championBg:Bitmap;
      
      private var noChampionBg:Bitmap;
      
      private var cot:uint;
      
      private var _awardsTip:SuperWinnerAwardsTip;
      
      public function SuperWinnerView($contro:SuperWinnerController)
      {
         this._contro = $contro;
         super();
         this.init();
         this.initEvent();
      }
      
      private function init() : void
      {
         addChild(ComponentFactory.Instance.creatBitmap("superwinner.bg"));
         addChild(ComponentFactory.Instance.creatBitmap("asset.superWinner.translucentArticle"));
         addChild(ComponentFactory.Instance.creatComponentByStylename("superWinner.ChatViewBg"));
         this.noChampionBg = ComponentFactory.Instance.creatBitmap("asset.superWinner.noChampionBg");
         addChild(this.noChampionBg);
         this.championBg = ComponentFactory.Instance.creatBitmap("asset.superWinner.championBg");
         this.championBg.visible = false;
         addChild(this.championBg);
         addChild(ComponentFactory.Instance.creatBitmap("asset.superWinner.championIcon"));
         this.returnBtn = ComponentFactory.Instance.creat("asset.superWinner.returnMenu");
         addChild(ComponentFactory.Instance.creatBitmap("asset.superWinner.myPrizeBg"));
         addChild(ComponentFactory.Instance.creatBitmap("asset.superWinner.lastRound"));
         addChild(ComponentFactory.Instance.creatBitmap("asset.superWinner.rollDiceTxt"));
         addChild(ComponentFactory.Instance.creatBitmap("asset.superWinner.prizeBg"));
         this._dicesMovie = ComponentFactory.Instance.creat("asset.superWinner.DicesMovieSprite");
         this._progressBar = ComponentFactory.Instance.creat("asset.superWinner.progressBar");
         this._progressBar.resetProgressBar();
         this._rollDiceBtn = ComponentFactory.Instance.creat("asset.superWinner.rollDice");
         this._rollDiceBtn.enable = false;
         this._dicesbanner = new DicesBanner();
         PositionUtils.setPos(this._dicesbanner,"asset.superWinner.DicesBanner");
         this._dicesbanner.visible = false;
         this._championDicesbanner = new DicesBanner(34);
         PositionUtils.setPos(this._championDicesbanner,"asset.superWinner.DicesBanner2");
         this._championDicesbanner.visible = false;
         this._endTimeTxt = ComponentFactory.Instance.creatComponentByStylename("superWinner.endTimeTxt");
         this._playerList = new SuperWinnerPlayerListView(this._model.getPlayerList());
         PositionUtils.setPos(this._playerList,"playerList.bg.point");
         this._awardView = ComponentFactory.Instance.creat("asset.superWinner.superWinnerBigAwardView");
         this._myAwardView = ComponentFactory.Instance.creat("asset.superWinner.superWinnerSmallAwardView");
         this._champion = new SuperWinnerPlayerItem();
         this._champion.sexIcon.visible = false;
         this._champion.visible = false;
         PositionUtils.setPos(this._champion,"asset.superWinner.Champion");
         this._helpBtn = ComponentFactory.Instance.creat("superWinner.helpBtn");
         this._awardsTip = new SuperWinnerAwardsTip();
         this._awardsTip.visible = false;
         ChatManager.Instance.state = ChatManager.SUPER_WINNER_ROOM;
         this._chatView = ChatManager.Instance.view;
         ChatManager.Instance.setFocus();
         ChatManager.Instance.lock = false;
         addChild(this._champion);
         addChild(this.returnBtn);
         addChild(this._dicesbanner);
         addChild(this._championDicesbanner);
         addChild(this._dicesMovie);
         addChild(this._progressBar);
         addChild(this._endTimeTxt);
         addChild(this._rollDiceBtn);
         addChild(this._playerList);
         addChild(this._awardView);
         addChild(this._myAwardView);
         addChild(this._chatView);
         addChild(this._helpBtn);
         addChild(this._awardsTip);
         MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.superWinner.waitStart"));
      }
      
      private function count(evt:Event) : void
      {
         if(!this._model.endData)
         {
            return;
         }
         var seconds:int = int(TimeManager.Instance.TotalSecondToNow(this._model.endData));
         this.updateTime(seconds);
      }
      
      public function endGame() : void
      {
         var str:String = null;
         var awardsNum:int = 0;
         for(var i:int = 0; i < 5; i++)
         {
            awardsNum += this._model.awards[i];
         }
         if(awardsNum == 0)
         {
            str = LanguageMgr.GetTranslation("ddt.superWinner.endTxt1");
         }
         else
         {
            str = LanguageMgr.GetTranslation("ddt.superWinner.endTxt2");
         }
         var alertFrame:BaseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),str,LanguageMgr.GetTranslation("ok"),"",false,true,true,LayerManager.ALPHA_BLOCKGOUND);
         alertFrame.cancelButtonEnable = false;
         alertFrame.addEventListener(FrameEvent.RESPONSE,this.outRoom);
         this.count30s(alertFrame);
      }
      
      private function count30s(alertFrame:BaseAlerFrame) : void
      {
         this.cot = setTimeout(function():void
         {
            clearTimeout(cot);
            alertFrame.dispatchEvent(new FrameEvent(1));
         },30000);
      }
      
      private function outRoom(e:FrameEvent) : void
      {
         if(Boolean(this.cot))
         {
            clearTimeout(this.cot);
         }
         var alert:BaseAlerFrame = e.currentTarget as BaseAlerFrame;
         alert.removeEventListener(FrameEvent.RESPONSE,this.outRoom);
         alert.dispose();
         this.returnBtn.dispachReturnEvent();
      }
      
      private function initEvent() : void
      {
         SuperWinnerManager.instance.addEventListener(SuperWinnerEvent.RETURN_HALL,this.__onReturn);
         this._model.addEventListener(SuperWinnerEvent.RETURN_DICES,this.__returnDices);
         this._model.addEventListener(SuperWinnerEvent.START_ROLL_DICES,this.__startRollDices);
         this._model.addEventListener(SuperWinnerEvent.PROGRESS_TIMES_UP,this.__progressTimesUp);
         this._model.addEventListener(SuperWinnerEvent.CHAMPIOM_CHANGE,this.__championChange);
         this._model.addEventListener(SuperWinnerEvent.NOTICE,this.__sendNotice);
         this._awardView.addEventListener(SuperWinnerEvent.SHOW_TIP,this.__showTip);
         this._awardView.addEventListener(SuperWinnerEvent.HIDE_TIP,this.__hideTip);
         this._rollDiceBtn.addEventListener(MouseEvent.CLICK,this.__rollDiceFunc);
         this._helpBtn.addEventListener(MouseEvent.CLICK,this.__openHelpFrame);
         this._time.addEventListener(TimerEvent.TIMER,this.count);
         this._time.start();
      }
      
      public function removeEvent() : void
      {
         SuperWinnerManager.instance.removeEventListener(SuperWinnerEvent.RETURN_HALL,this.__onReturn);
         this._model.removeEventListener(SuperWinnerEvent.RETURN_DICES,this.__returnDices);
         this._model.removeEventListener(SuperWinnerEvent.START_ROLL_DICES,this.__startRollDices);
         this._model.removeEventListener(SuperWinnerEvent.PROGRESS_TIMES_UP,this.__progressTimesUp);
         this._model.removeEventListener(SuperWinnerEvent.CHAMPIOM_CHANGE,this.__championChange);
         this._model.removeEventListener(SuperWinnerEvent.NOTICE,this.__sendNotice);
         this._awardView.removeEventListener(SuperWinnerEvent.SHOW_TIP,this.__showTip);
         this._awardView.removeEventListener(SuperWinnerEvent.HIDE_TIP,this.__hideTip);
         this._rollDiceBtn.removeEventListener(MouseEvent.CLICK,this.__rollDiceFunc);
         this._helpBtn.removeEventListener(MouseEvent.CLICK,this.__openHelpFrame);
         if(Boolean(this._time))
         {
            this._time.removeEventListener(TimerEvent.TIMER,this.count);
         }
      }
      
      private function __showTip(e:SuperWinnerEvent) : void
      {
         var mode:SuperWinnerAwardsMode = null;
         var awardType:uint = e.resultData as uint;
         var awardsArr:Vector.<Object> = SuperWinnerManager.instance.awardsVector;
         var awards:Vector.<SuperWinnerAwardsMode> = awardsArr[awardType - 1] as Vector.<SuperWinnerAwardsMode>;
         var str:String = "";
         for(var i:uint = 0; i < awards.length; i++)
         {
            mode = awards[i];
            str += mode.goodName + " ×" + mode.count;
            if(i < awards.length - 1)
            {
               str += "\r";
            }
         }
         this._awardsTip.tipData = str;
         PositionUtils.setPos(this._awardsTip,"superWinner.awardTip" + awardType);
         this._awardsTip.visible = true;
      }
      
      private function __hideTip(e:SuperWinnerEvent) : void
      {
         this._awardsTip.visible = false;
         this._awardsTip.tipData = "";
      }
      
      private function __startRollDices(e:SuperWinnerEvent) : void
      {
         this._rollDiceBtn.enable = true;
         this._progressBar.playBar();
      }
      
      public function updateTime(second:int) : void
      {
         this._remainTime = Math.abs(second);
         var _hours:int = this._remainTime / 3600;
         var _minute:int = this._remainTime / 60 % 60;
         var _second:int = this._remainTime % 60;
         var str:String = "" + LanguageMgr.GetTranslation("ddt.superWinner.endTimeTxt");
         if(_hours < 10)
         {
            str += "0" + _hours;
         }
         else
         {
            str += _hours;
         }
         str += "：";
         if(_minute < 10)
         {
            str += "0" + _minute;
         }
         else
         {
            str += _minute;
         }
         str += "：";
         if(_second < 10)
         {
            str += "0" + _second;
         }
         else
         {
            str += _second;
         }
         this._endTimeTxt.text = str;
         if(this._remainTime == 0)
         {
            if(Boolean(this._time))
            {
               this._time.stop();
               this._time.removeEventListener(TimerEvent.TIMER,this.count);
               this._time = null;
            }
         }
      }
      
      protected function __openHelpFrame(e:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         var movie:MovieClip = ComponentFactory.Instance.creatCustomObject("asset.superWinner.help");
         var frame:SuperWinnerHelpFrame = ComponentFactory.Instance.creat("ddt.superWinner.helpFrame");
         frame.setView(movie);
         frame.submitButtonPos = "superWinner.helpFrame.submitBtnPos";
         frame.titleText = LanguageMgr.GetTranslation("store.view.HelpButtonText");
         frame.addEventListener(FrameEvent.RESPONSE,this.__frameEvent);
         LayerManager.Instance.addToLayer(frame,LayerManager.GAME_TOP_LAYER,true,LayerManager.BLCAK_BLOCKGOUND,true);
      }
      
      protected function __frameEvent(event:FrameEvent) : void
      {
         SoundManager.instance.playButtonSound();
         var frame:Disposeable = event.target as Disposeable;
         frame.dispose();
         frame = null;
      }
      
      private function __rollDiceFunc(e:MouseEvent) : void
      {
         this._rollDiceBtn.enable = false;
         SoundManager.instance.play("008");
         SocketManager.Instance.out.rollDiceInSuperWinner();
      }
      
      private function __progressTimesUp(e:SuperWinnerEvent) : void
      {
         this._rollDiceBtn.enable = false;
         this.showLastDices();
         this._dicesMovie.resetDice();
         this._progressBar.resetProgressBar();
      }
      
      private function __sendNotice(e:SuperWinnerEvent) : void
      {
         var msg:String = e.resultData as String;
         ChatManager.Instance.sysChatYellow(msg);
      }
      
      private function __championChange(e:SuperWinnerEvent) : void
      {
         if(this._model.isShowChampionMsg)
         {
            this.showChampionMsg(e.resultData as Boolean);
         }
         this.noChampionBg.visible = false;
         this.championBg.visible = true;
         this._champion.visible = true;
         this._champion.setCellValue(this._model.championItem);
         this._championDicesbanner.visible = true;
         this._championDicesbanner.showLastDices(this._model.championDices);
      }
      
      private function __returnDices(e:SuperWinnerEvent) : void
      {
         this.showSystemMsg();
         if(Boolean(this._model.currentDicePoints))
         {
            this._model.lastDicePoints = this._model.currentDicePoints;
         }
         if(this._model.currentAwardLevel > 0)
         {
            this._rollDiceBtn.enable = false;
         }
         this._dicesMovie.playMovie(this._model.currentDicePoints);
      }
      
      private function showLastDices() : void
      {
         if(Boolean(this._model.lastDicePoints))
         {
            this._dicesbanner.visible = true;
            this._dicesbanner.showLastDices(this._model.lastDicePoints);
         }
      }
      
      private function showSystemMsg() : void
      {
         var str:String = null;
         if(!this._model.isCurrentDiceGetAward && this._model.currentAwardLevel > 0)
         {
            if(this._model.currentAwardLevel == 6)
            {
               str = LanguageMgr.GetTranslation("ddt.superWinner.passTheChampion");
            }
            else
            {
               str = LanguageMgr.GetTranslation("ddt.superWinner.rollRightDiceNoAward",this._model.getAwardNameByLevel(this._model.currentAwardLevel));
            }
            ChatManager.Instance.sysChatYellow(str);
         }
      }
      
      private function showChampionMsg(hadChampion:Boolean) : void
      {
         var str:String = null;
         if(hadChampion)
         {
            str = LanguageMgr.GetTranslation("ddt.superWinner.biggerThanLastChampion",this._model.championItem.NickName);
         }
         else
         {
            str = LanguageMgr.GetTranslation("ddt.superWinner.firstChampion",this._model.championItem.NickName);
         }
         ChatManager.Instance.sysChatYellow(str);
      }
      
      private function __onReturn(e:SuperWinnerEvent) : void
      {
         SoundManager.instance.play("008");
         SocketManager.Instance.out.outSuperWinner();
         StateManager.setState(StateType.MAIN);
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         this._contro = null;
         if(Boolean(this._time))
         {
            this._time.stop();
            this._time = null;
         }
         this._model = null;
         this._dicesbanner = null;
         this._championDicesbanner = null;
         this._dicesMovie = null;
         this._progressBar = null;
         this._rollDiceBtn = null;
         this._playerList = null;
         this._awardView = null;
         this._myAwardView = null;
         this._awardsTip = null;
         this.returnBtn = null;
         this._champion = null;
         this._chatView = null;
         this._endTimeTxt = null;
         this._helpBtn = null;
         this.championBg = null;
         this.noChampionBg = null;
         ObjectUtils.disposeAllChildren(this);
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

