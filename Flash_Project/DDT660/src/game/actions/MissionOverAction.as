package game.actions
{
   import com.pickgliss.manager.NoviceDataManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.utils.ClassUtils;
   import ddt.data.map.MissionInfo;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.FightLibManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PathManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.StateManager;
   import ddt.states.StateType;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import game.GameManager;
   import game.model.BaseSettleInfo;
   import game.model.GameInfo;
   import game.model.Player;
   import game.view.MissionOverInfoPanel;
   import game.view.experience.ExpView;
   import game.view.map.MapView;
   import road7th.comm.PackageIn;
   import road7th.utils.MovieClipWrapper;
   import room.RoomManager;
   import trainer.TrainStep;
   import trainer.controller.NewHandGuideManager;
   import trainer.controller.NewHandQueue;
   import trainer.controller.WeakGuildManager;
   import trainer.data.Step;
   import trainer.view.BaseExplainFrame;
   import trainer.view.ExplainOne;
   import trainer.view.ExplainPlane;
   import trainer.view.ExplainPowerThree;
   import trainer.view.ExplainTen;
   import trainer.view.ExplainThreeFourFive;
   import trainer.view.ExplainTwoTwenty;
   import trainer.view.NewHandContainer;
   import worldboss.WorldBossRoomController;
   
   public class MissionOverAction extends BaseAction
   {
      
      private var _event:CrazyTankSocketEvent;
      
      private var _executed:Boolean;
      
      private var _count:int;
      
      private var _map:MapView;
      
      private var _func:Function;
      
      private var infoPane:MissionOverInfoPanel;
      
      private var _clicked:Boolean;
      
      private var _c:int;
      
      private var _one:ExplainOne;
      
      private var _win:MovieClipWrapper;
      
      private var _ten:ExplainTen;
      
      private var _powerThree:ExplainPowerThree;
      
      private var _plane:ExplainPlane;
      
      private var _twoTwenty:ExplainTwoTwenty;
      
      private var _threeFourFive:ExplainThreeFourFive;
      
      private var _lost:MovieClipWrapper;
      
      public function MissionOverAction(map:MapView, event:CrazyTankSocketEvent, func:Function, waitTime:Number = 3000)
      {
         super();
         this._event = event;
         this._map = map;
         this._func = func;
         this._count = waitTime / 40;
         this.readInfo(this._event);
      }
      
      public static function getGradedStr(grade:int) : String
      {
         if(grade >= 3)
         {
            return "S";
         }
         if(grade >= 2)
         {
            return "A";
         }
         if(grade == 0)
         {
            return "C";
         }
         if(grade < 2)
         {
            return "B";
         }
         return "C";
      }
      
      private function readInfo(event:CrazyTankSocketEvent) : void
      {
         var obj:Object = null;
         var playerGainInfo:BaseSettleInfo = null;
         var player:Player = null;
         var cardCount:int = 0;
         var playerCanGetCardCount:int = 0;
         var count:int = 0;
         var j:uint = 0;
         var pkg:PackageIn = event.pkg;
         var current:GameInfo = GameManager.Instance.Current;
         current.missionInfo.missionOverPlayer = [];
         current.missionInfo.tackCardType = pkg.readInt();
         current.hasNextMission = pkg.readBoolean();
         if(current.hasNextMission)
         {
            current.missionInfo.pic = pkg.readUTF();
         }
         current.missionInfo.canEnterFinall = pkg.readBoolean();
         var playerCount:int = pkg.readInt();
         for(var i:int = 0; i < playerCount; i++)
         {
            obj = new Object();
            playerGainInfo = new BaseSettleInfo();
            playerGainInfo.playerid = pkg.readInt();
            playerGainInfo.level = pkg.readInt();
            playerGainInfo.treatment = pkg.readInt();
            player = current.findGamerbyPlayerId(playerGainInfo.playerid);
            obj.gainGP = pkg.readInt();
            player.isWin = pkg.readBoolean();
            cardCount = pkg.readInt();
            playerCanGetCardCount = pkg.readInt();
            player.GetCardCount = playerCanGetCardCount;
            player.BossCardCount = playerCanGetCardCount;
            player.hasLevelAgain = pkg.readBoolean();
            player.hasGardGet = pkg.readBoolean();
            if(player.isWin)
            {
               if(cardCount == 0)
               {
                  obj.gameOverType = ExpView.GAME_OVER_TYPE_0;
               }
               else if(cardCount == 1 && !current.hasNextMission)
               {
                  obj.gameOverType = ExpView.GAME_OVER_TYPE_6;
               }
               else if(cardCount == 1 && current.hasNextMission)
               {
                  obj.gameOverType = ExpView.GAME_OVER_TYPE_2;
               }
               else if(cardCount == 2 && current.hasNextMission)
               {
                  obj.gameOverType = ExpView.GAME_OVER_TYPE_3;
               }
               else if(cardCount == 2 && !current.hasNextMission)
               {
                  obj.gameOverType = ExpView.GAME_OVER_TYPE_4;
               }
               else
               {
                  obj.gameOverType = ExpView.GAME_OVER_TYPE_0;
               }
            }
            else
            {
               obj.gameOverType = ExpView.GAME_OVER_TYPE_5;
               if(RoomManager.Instance.current.type == 14)
               {
                  SocketManager.Instance.out.sendWorldBossRoomStauts(3);
                  WorldBossRoomController.Instance.setSelfStatus(3);
               }
            }
            player.expObj = obj;
            if(player.playerInfo.ID == current.selfGamePlayer.playerInfo.ID)
            {
               current.selfGamePlayer.BossCardCount = player.BossCardCount;
            }
            current.missionInfo.missionOverPlayer.push(playerGainInfo);
         }
         if(current.selfGamePlayer.BossCardCount > 0)
         {
            count = pkg.readInt();
            current.missionInfo.missionOverNPCMovies = [];
            for(j = 0; j < count; j++)
            {
               current.missionInfo.missionOverNPCMovies.push(pkg.readUTF());
            }
         }
         current.missionInfo.nextMissionIndex = current.missionInfo.missionIndex + 1;
      }
      
      override public function cancel() : void
      {
         this._event.executed = true;
      }
      
      override public function execute() : void
      {
         var movie:MovieClipWrapper = null;
         var mc:MovieClip = null;
         if(RoomManager.Instance.current.selfRoomPlayer.isViewer)
         {
            this._executed = true;
         }
         if(WeakGuildManager.Instance.switchUserGuide)
         {
            if(GameManager.Instance.Current.selfGamePlayer.isWin)
            {
               if(NewHandGuideManager.Instance.mapID == 111)
               {
                  NewHandQueue.Instance.push(new Step(Step.POP_EXPLAIN_ONE,this.exeExplainOne,this.preExplainOne,this.finExplainOne,0,true));
                  NewHandQueue.Instance.push(new Step(Step.POP_WIN,this.exeWin,this.preWin,this.finWin));
                  _isFinished = true;
                  return;
               }
               if(NewHandGuideManager.Instance.mapID == 112)
               {
                  NewHandQueue.Instance.push(new Step(Step.POP_EXPLAIN_TEN,this.exeExplainTen,this.preExplainTen,this.finExplainTen));
                  NewHandQueue.Instance.push(new Step(Step.POP_WIN_I,this.exeWin,this.preWin,this.finWinI));
                  NoviceDataManager.instance.saveNoviceData(390,PathManager.userName(),PathManager.solveRequestPath());
                  _isFinished = true;
                  return;
               }
               if(NewHandGuideManager.Instance.mapID == 113)
               {
                  NewHandQueue.Instance.push(new Step(Step.POP_POWER_THREE,this.exePowerThree,this.prePowerThree,this.finPowerThree));
                  NewHandQueue.Instance.push(new Step(Step.POP_WIN_II,this.exeWin,this.preWin,this.finWinI));
                  NoviceDataManager.instance.saveNoviceData(480,PathManager.userName(),PathManager.solveRequestPath());
                  _isFinished = true;
                  return;
               }
               if(NewHandGuideManager.Instance.mapID == 114)
               {
                  NewHandQueue.Instance.push(new Step(Step.POP_PLANE,this.exePlane,this.prePlane,this.finPlane));
                  NewHandQueue.Instance.push(new Step(Step.POP_WIN_III,this.exeWin,this.preWin,this.finWinI));
                  _isFinished = true;
                  return;
               }
               if(NewHandGuideManager.Instance.mapID == 115)
               {
                  NewHandQueue.Instance.push(new Step(Step.POP_TWO_TWENTY,this.exeTwoTwenty,this.preTwoTwenty,this.finTwoTwenty));
                  NewHandQueue.Instance.push(new Step(Step.POP_WIN_IV,this.exeWin,this.preWin,this.finWinI));
                  NoviceDataManager.instance.saveNoviceData(570,PathManager.userName(),PathManager.solveRequestPath());
                  _isFinished = true;
                  return;
               }
               if(NewHandGuideManager.Instance.mapID == 116)
               {
                  NewHandQueue.Instance.push(new Step(Step.POP_THREE_FOUR_FIVE,this.exeThreeFourFive,this.preThreeFourFive,this.finThreeFourFive));
                  NewHandQueue.Instance.push(new Step(Step.POP_WIN_V,this.exeWin,this.preWin,this.finWinI));
                  _isFinished = true;
                  return;
               }
            }
            else
            {
               switch(NewHandGuideManager.Instance.mapID)
               {
                  case 111:
                  case 112:
                  case 113:
                  case 114:
                  case 115:
                  case 116:
                     NewHandQueue.Instance.push(new Step(Step.POP_LOST,this.exeLost,this.preLost,this.finLost));
                     _isFinished = true;
                     return;
               }
            }
         }
         if(!this._executed)
         {
            if(this._map.hasSomethingMoving() == false && (this._map.currentPlayer == null || this._map.currentPlayer.actionCount == 0))
            {
               this._executed = true;
               this._event.executed = true;
               if(Boolean(this._map.currentPlayer))
               {
                  this._map.currentPlayer.beginNewTurn();
               }
               this.infoPane = new MissionOverInfoPanel();
               this.upContextView(this.infoPane);
               if(StateManager.currentStateType == StateType.FIGHT_LIB_GAMEVIEW)
               {
                  FightLibManager.Instance.lastWin = GameManager.Instance.Current.selfGamePlayer.isWin;
               }
               if(GameManager.Instance.Current.selfGamePlayer.isWin)
               {
                  mc = ClassUtils.CreatInstance("asset.game.winAsset");
               }
               else
               {
                  mc = ClassUtils.CreatInstance("asset.game.lostAsset");
               }
               this.infoPane.x = 77;
               mc.addChild(this.infoPane);
               movie = new MovieClipWrapper(mc,true,true);
               SoundManager.instance.play("040");
               movie.movie.x = 500;
               movie.movie.y = 360;
               movie.addEventListener(Event.COMPLETE,this.__complete);
               this._map.gameView.addChild(movie.movie);
            }
         }
         else
         {
            --this._count;
            if(this._count <= 0)
            {
               this._func();
               _isFinished = true;
            }
         }
      }
      
      private function __explainEnter(evt:Event) : void
      {
         (evt.currentTarget as EventDispatcher).removeEventListener(BaseExplainFrame.EXPLAIN_ENTER,this.__explainEnter);
         this._clicked = true;
      }
      
      private function preExplainOne() : void
      {
         NewHandContainer.Instance.showMovie("asset.trainer.pickOneMove");
      }
      
      private function exeExplainOne() : Boolean
      {
         ++this._c;
         if(this._c == 51)
         {
            this._one = ComponentFactory.Instance.creatCustomObject("trainer.ExplainOne");
            this._one.addEventListener(BaseExplainFrame.EXPLAIN_ENTER,this.__explainEnter);
            this._one.show();
         }
         else if(this._c == 55)
         {
            NewHandContainer.Instance.hideMovie("asset.trainer.pickOneMove");
         }
         return this._clicked;
      }
      
      private function finExplainOne() : void
      {
         this._one.dispose();
         this._one = null;
      }
      
      private function preWin() : void
      {
         SoundManager.instance.stopMusic();
         SoundManager.instance.setMusicVolumeByRatio(2);
         this._win = new MovieClipWrapper(ClassUtils.CreatInstance("asset.game.winAsset"),true,true);
         this._win.movie.x = 500;
         this._win.movie.y = 360;
         this._map.gameView.addChild(this._win.movie);
         SoundManager.instance.play("040");
      }
      
      private function exeWin() : Boolean
      {
         return this._win.movie.currentFrame == this._win.movie.totalFrames;
      }
      
      private function finWin() : void
      {
         StateManager.setState(StateType.MAIN);
         this._win = null;
         NewHandQueue.Instance.dispose();
      }
      
      private function preExplainTen() : void
      {
         this._c = 0;
         this._clicked = false;
         NewHandContainer.Instance.showMovie("asset.trainer.pickTenMove");
      }
      
      private function exeExplainTen() : Boolean
      {
         ++this._c;
         if(this._c == 51)
         {
            this._ten = ComponentFactory.Instance.creatCustomObject("trainer.ExplainTen");
            this._ten.addEventListener(BaseExplainFrame.EXPLAIN_ENTER,this.__explainEnter);
            this._ten.show();
            TrainStep.send(TrainStep.Step.BOSS_BEAT);
            TrainStep.send(TrainStep.Step.GET_ADD_HARM);
         }
         else if(this._c == 55)
         {
            NewHandContainer.Instance.hideMovie("asset.trainer.pickTenMove");
         }
         return this._clicked;
      }
      
      private function finExplainTen() : void
      {
         this._ten.dispose();
         this._ten = null;
      }
      
      private function finWinI() : void
      {
         this._win = null;
         NewHandQueue.Instance.dispose();
         this._func();
      }
      
      private function prePowerThree() : void
      {
         this._c = 0;
         this._clicked = false;
         NewHandContainer.Instance.showMovie("asset.trainer.getPowerThreeMove");
      }
      
      private function exePowerThree() : Boolean
      {
         ++this._c;
         if(this._c == 51)
         {
            this._powerThree = ComponentFactory.Instance.creatCustomObject("trainer.ExplainPowerThree");
            this._powerThree.addEventListener(BaseExplainFrame.EXPLAIN_ENTER,this.__explainEnter);
            this._powerThree.show();
         }
         else if(this._c == 55)
         {
            NewHandContainer.Instance.hideMovie("asset.trainer.getPowerThreeMove");
         }
         return this._clicked;
      }
      
      private function finPowerThree() : void
      {
         this._powerThree.dispose();
         this._powerThree = null;
      }
      
      private function prePlane() : void
      {
         this._c = 0;
         this._clicked = false;
         NewHandContainer.Instance.showMovie("asset.trainer.pickPlaneMove");
      }
      
      private function exePlane() : Boolean
      {
         ++this._c;
         if(this._c == 64)
         {
            NewHandContainer.Instance.hideMovie("asset.trainer.pickPlaneMove");
            this._plane = ComponentFactory.Instance.creatCustomObject("trainer.ExplainPlane");
            this._plane.addEventListener(BaseExplainFrame.EXPLAIN_ENTER,this.__explainEnter);
            this._plane.show();
         }
         return this._clicked;
      }
      
      private function finPlane() : void
      {
         this._plane.dispose();
         this._plane = null;
      }
      
      private function preTwoTwenty() : void
      {
         this._c = 0;
         this._clicked = false;
         NewHandContainer.Instance.showMovie("asset.trainer.getTwoTwentyMove");
      }
      
      private function exeTwoTwenty() : Boolean
      {
         ++this._c;
         if(this._c == 51)
         {
            this._twoTwenty = ComponentFactory.Instance.creatCustomObject("trainer.ExplainTwoTwenty");
            this._twoTwenty.addEventListener(BaseExplainFrame.EXPLAIN_ENTER,this.__explainEnter);
            this._twoTwenty.show();
         }
         else if(this._c == 55)
         {
            NewHandContainer.Instance.hideMovie("asset.trainer.getTwoTwentyMove");
         }
         return this._clicked;
      }
      
      private function finTwoTwenty() : void
      {
         this._twoTwenty.dispose();
         this._twoTwenty = null;
      }
      
      private function preThreeFourFive() : void
      {
         this._c = 0;
         this._clicked = false;
         NewHandContainer.Instance.showMovie("asset.trainer.getThreeFourFiveMove");
      }
      
      private function exeThreeFourFive() : Boolean
      {
         ++this._c;
         if(this._c == 51)
         {
            this._threeFourFive = ComponentFactory.Instance.creatCustomObject("trainer.ExplainThreeFourFive");
            this._threeFourFive.addEventListener(BaseExplainFrame.EXPLAIN_ENTER,this.__explainEnter);
            this._threeFourFive.show();
         }
         else if(this._c == 55)
         {
            NewHandContainer.Instance.hideMovie("asset.trainer.getThreeFourFiveMove");
         }
         return this._clicked;
      }
      
      private function finThreeFourFive() : void
      {
         this._threeFourFive.dispose();
         this._threeFourFive = null;
      }
      
      private function preLost() : void
      {
         this._lost = new MovieClipWrapper(ClassUtils.CreatInstance("asset.game.lostAsset"),true,true);
         this._lost.movie.x = 500;
         this._lost.movie.y = 360;
         this._map.gameView.addChild(this._lost.movie);
         SoundManager.instance.play("040");
      }
      
      private function exeLost() : Boolean
      {
         return this._lost.movie.currentFrame == this._lost.movie.totalFrames;
      }
      
      private function finLost() : void
      {
         this._lost = null;
         NewHandQueue.Instance.dispose();
         this._func();
      }
      
      private function __complete(event:Event) : void
      {
         MovieClipWrapper(event.target).removeEventListener(Event.COMPLETE,this.__complete);
         this.infoPane.dispose();
         this.infoPane = null;
      }
      
      private function upContextView(mc:MissionOverInfoPanel) : void
      {
         var info:MissionInfo = GameManager.Instance.Current.missionInfo;
         var gameOverInfo:BaseSettleInfo = GameManager.Instance.Current.missionInfo.findMissionOverInfo(PlayerManager.Instance.Self.ID);
         mc.titleTxt1.text = LanguageMgr.GetTranslation("tank.game.actions.kill");
         mc.valueTxt1.text = String(info.currentValue2);
         mc.titleTxt2.text = LanguageMgr.GetTranslation("tank.game.actions.turn");
         mc.valueTxt2.text = String(info.currentValue1);
         mc.titleTxt3.text = LanguageMgr.GetTranslation("tank.game.BloodStrip.HP");
         mc.valueTxt3.text = String(gameOverInfo.treatment);
      }
   }
}

