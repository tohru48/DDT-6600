package fightLib.view
{
   import com.greensock.TweenLite;
   import com.pickgliss.toplevel.StageReferance;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.fightLib.FightLibInfo;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.events.DungeonInfoEvent;
   import ddt.events.GameEvent;
   import ddt.events.LivingEvent;
   import ddt.manager.ChatManager;
   import ddt.manager.FightLibManager;
   import ddt.manager.GameInSocketOut;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.states.BaseStateView;
   import ddt.states.StateType;
   import fightLib.LessonType;
   import fightLib.script.BaseScript;
   import fightLib.script.HighGap.DifficultHighGap;
   import fightLib.script.HighGap.EasyHighGap;
   import fightLib.script.HighGap.NormalHighGap;
   import fightLib.script.HighThrow.DifficultHighThrow;
   import fightLib.script.HighThrow.EasyHighThrow;
   import fightLib.script.HighThrow.NormalHighThrow;
   import fightLib.script.MeasureScree.DifficultMeasureScreenScript;
   import fightLib.script.MeasureScree.EasyMeasureScreenScript;
   import fightLib.script.MeasureScree.NomalMeasureScreenScript;
   import fightLib.script.SixtyDegree.DifficultSixtyDegreeScript;
   import fightLib.script.SixtyDegree.EasySixtyDegreeScript;
   import fightLib.script.SixtyDegree.NormalSixtyDegreeScript;
   import fightLib.script.TwentyDegree.DifficultTwentyDegree;
   import fightLib.script.TwentyDegree.EasyTwentyDegree;
   import fightLib.script.TwentyDegree.NormalTwentyDegree;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.utils.setTimeout;
   import game.GameManager;
   import game.model.Living;
   import game.model.Player;
   import game.view.DungeonHelpView;
   import game.view.DungeonInfoView;
   import game.view.GameView;
   import game.view.smallMap.SmallLiving;
   import road7th.comm.PackageIn;
   
   public class FightLibGameView extends GameView
   {
      
      private var _script:BaseScript;
      
      private var _frame:FightLibQuestionFrame;
      
      private var _redPoint:Sprite;
      
      private var _shouldShowTurn:Boolean = true;
      
      private var _isWaittingToAttack:Boolean = false;
      
      private var _scriptStarted:Boolean;
      
      private var _powerTable:MovieClip;
      
      private var _guildMc:MovieClip;
      
      private var _lessonLiving:SmallLiving;
      
      public function FightLibGameView()
      {
         super();
      }
      
      override public function getType() : String
      {
         return StateType.FIGHT_LIB_GAMEVIEW;
      }
      
      override public function enter(prev:BaseStateView, data:Object = null) : void
      {
         super.enter(prev,data);
         this.initScript();
         this.closeShowTurn();
         this.blockFly();
         GameManager.Instance.Current.selfGamePlayer.lockProp = true;
         setPropBarClickEnable(false,true);
         arrowHammerEnable = false;
         blockHammer();
         this.pauseGame();
         _map.smallMap.setHardLevel(FightLibManager.Instance.currentInfo.difficulty,1);
         this._powerTable = ComponentFactory.Instance.creat("tank.fightLib.FightLibPowerTableAsset");
         this.initEvents();
      }
      
      private function initEvents() : void
      {
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.POPUP_QUESTION_FRAME,this.__popupQuestionFrame);
      }
      
      private function removeEvents() : void
      {
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.POPUP_QUESTION_FRAME,this.__popupQuestionFrame);
         StageReferance.stage.removeEventListener(MouseEvent.MOUSE_UP,this.__downHandler);
      }
      
      override protected function gameOver() : void
      {
         super.gameOver();
         FightLibManager.Instance.lastFightLibMission = PlayerManager.Instance.Self.fightLibMission;
         FightLibManager.Instance.lastInfo = FightLibManager.Instance.currentInfo;
         FightLibManager.Instance.currentInfo = null;
      }
      
      override public function updateControlBarState(info:Living) : void
      {
         setPropBarClickEnable(false,true);
      }
      
      private function __reAnswer(evt:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         GameInSocketOut.sendFightLibReanswer();
         --FightLibManager.Instance.reAnswerNum;
      }
      
      private function __viewTutorial(evt:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         FightLibManager.Instance.script.restart();
         GameInSocketOut.sendClientScriptStart();
         this.closeShowTurn();
         if(Boolean(this._frame))
         {
            this._frame.close();
         }
      }
      
      private function initScript() : void
      {
         if(FightLibManager.Instance.currentInfo.id == LessonType.Measure)
         {
            if(FightLibManager.Instance.currentInfo.difficulty == FightLibInfo.EASY)
            {
               this._script = new EasyMeasureScreenScript(this);
            }
            else if(FightLibManager.Instance.currentInfo.difficulty == FightLibInfo.NORMAL)
            {
               this._script = new NomalMeasureScreenScript(this);
            }
            else if(FightLibManager.Instance.currentInfo.difficulty == FightLibInfo.DIFFICULT)
            {
               this._script = new DifficultMeasureScreenScript(this);
            }
         }
         else if(FightLibManager.Instance.currentInfo.id == LessonType.Twenty)
         {
            if(FightLibManager.Instance.currentInfo.difficulty == FightLibInfo.EASY)
            {
               this._script = new EasyTwentyDegree(this);
            }
            else if(FightLibManager.Instance.currentInfo.difficulty == FightLibInfo.NORMAL)
            {
               this._script = new NormalTwentyDegree(this);
            }
            else if(FightLibManager.Instance.currentInfo.difficulty == FightLibInfo.DIFFICULT)
            {
               this._script = new DifficultTwentyDegree(this);
            }
         }
         else if(FightLibManager.Instance.currentInfo.id == LessonType.SixtyFive)
         {
            if(FightLibManager.Instance.currentInfo.difficulty == FightLibInfo.EASY)
            {
               this._script = new EasySixtyDegreeScript(this);
            }
            else if(FightLibManager.Instance.currentInfo.difficulty == FightLibInfo.NORMAL)
            {
               this._script = new NormalSixtyDegreeScript(this);
            }
            else if(FightLibManager.Instance.currentInfo.difficulty == FightLibInfo.DIFFICULT)
            {
               this._script = new DifficultSixtyDegreeScript(this);
            }
         }
         else if(FightLibManager.Instance.currentInfo.id == LessonType.HighThrow)
         {
            if(FightLibManager.Instance.currentInfo.difficulty == FightLibInfo.EASY)
            {
               this._script = new EasyHighThrow(this);
            }
            else if(FightLibManager.Instance.currentInfo.difficulty == FightLibInfo.NORMAL)
            {
               this._script = new NormalHighThrow(this);
            }
            else if(FightLibManager.Instance.currentInfo.difficulty == FightLibInfo.DIFFICULT)
            {
               this._script = new DifficultHighThrow(this);
            }
         }
         else if(FightLibManager.Instance.currentInfo.id == LessonType.HighGap)
         {
            if(FightLibManager.Instance.currentInfo.difficulty == FightLibInfo.EASY)
            {
               this._script = new EasyHighGap(this);
            }
            else if(FightLibManager.Instance.currentInfo.difficulty == FightLibInfo.NORMAL)
            {
               this._script = new NormalHighGap(this);
            }
            else if(FightLibManager.Instance.currentInfo.difficulty == FightLibInfo.DIFFICULT)
            {
               this._script = new DifficultHighGap(this);
            }
         }
         FightLibManager.Instance.script = this._script;
      }
      
      public function drawMasks() : void
      {
         if(!_tipLayers)
         {
            _tipLayers = new Sprite();
            addChild(_tipLayers);
         }
         _tipLayers.graphics.clear();
         _tipLayers.graphics.beginFill(0,0.8);
         _tipLayers.graphics.drawRect(-10,-10,828,820);
         _tipLayers.graphics.drawRect(818,122,200,690);
         _tipLayers.graphics.endFill();
      }
      
      public function pauseGame() : void
      {
         this.closeShowTurn();
      }
      
      public function continueGame() : void
      {
         var pos:Point = null;
         _map.smallMap.titleBar.addEventListener(DungeonInfoEvent.DungeonHelpChanged,__dungeonVisibleChanged);
         _barrier = new DungeonInfoView(_map.smallMap.titleBar.turnButton,this);
         _barrier.addEventListener(GameEvent.DungeonHelpVisibleChanged,__dungeonHelpChanged);
         _barrier.addEventListener(GameEvent.UPDATE_SMALLMAPVIEW,__updateSmallMapView);
         _missionHelp = new DungeonHelpView(_map.smallMap.titleBar.turnButton,_barrier,this);
         pos = ComponentFactory.Instance.creatCustomObject("asset.game.DungeonHelpViewPos");
         _missionHelp.x = pos.x;
         _missionHelp.y = pos.y;
         addChild(_missionHelp);
         setTimeout(this.openShowTurn,3000);
         setTimeout(this.enableReanswerBtn,3000);
      }
      
      public function moveToPlayer() : void
      {
         _map.smallMap.moveToPlayer();
      }
      
      public function splitSmallMapDrager() : void
      {
         _map.smallMap.showSpliter();
      }
      
      public function hideSmallMapSplit() : void
      {
         _map.smallMap.hideSpliter();
      }
      
      public function restoreText() : void
      {
         _map.smallMap.restoreText();
         if(getChildIndex(_map.smallMap) > getChildIndex(ChatManager.Instance.view))
         {
            swapChildren(_map.smallMap,ChatManager.Instance.view);
         }
      }
      
      public function shineText() : void
      {
         if(!this._guildMc)
         {
            this._guildMc = ComponentFactory.Instance.creat("tank.fightLib.GuildMc");
            addChild(this._guildMc);
         }
         this._guildMc.gotoAndStop("Stand");
         this._guildMc.scaleX = 0.14;
         this._guildMc.scaleY = 0.14;
         this._guildMc.x = 899;
         this._guildMc.y = 75;
         TweenLite.to(this._guildMc,2,{
            "x":500,
            "y":298,
            "scaleX":1,
            "scaleY":1,
            "onComplete":this.ScaleCompleteHandler
         });
      }
      
      private function ScaleCompleteHandler() : void
      {
         TweenLite.to(this._guildMc,2,{"onComplete":this.StartPlayHandler});
      }
      
      private function StartPlayHandler() : void
      {
         this._guildMc.gotoAndPlay("guild_1");
      }
      
      private function GuildEndHandler() : void
      {
         removeChild(this._guildMc);
         this._guildMc = null;
      }
      
      public function shineText2() : void
      {
         this._guildMc.gotoAndPlay("guild_2");
         addEventListener(Event.ENTER_FRAME,this.onMoviePlay);
      }
      
      private function onMoviePlay(e:Event) : void
      {
         if(this._guildMc.currentLabel == "end")
         {
            this._guildMc.gotoAndStop("end");
            removeEventListener(Event.ENTER_FRAME,this.onMoviePlay);
            TweenLite.to(this._guildMc,1,{
               "x":899,
               "y":75,
               "scaleX":0.14,
               "scaleY":0.14,
               "onComplete":this.GuildEndHandler
            });
         }
      }
      
      public function screanAddEvent() : void
      {
         StageReferance.stage.addEventListener(MouseEvent.MOUSE_UP,this.__downHandler);
      }
      
      private function __downHandler(evt:MouseEvent) : void
      {
         if(!_map.smallMap.__StartDrag)
         {
            return;
         }
         var _x:int = _map.smallMap.screen.x;
         var _X:int = _map.smallMap.screenX;
         var _y:int = _map.smallMap.screen.y;
         var _Y:int = _map.smallMap.screenY;
         if(_x == _X && _y == _Y)
         {
            return;
         }
         StageReferance.stage.removeEventListener(MouseEvent.MOUSE_UP,this.__downHandler);
         this._script.continueScript();
      }
      
      override protected function __playerChange(event:CrazyTankSocketEvent) : void
      {
         if(!this._scriptStarted)
         {
            this._script.start();
            this._scriptStarted = true;
         }
         if(this._shouldShowTurn)
         {
            super.__playerChange(event);
         }
      }
      
      public function clearMask() : void
      {
         _tipLayers.graphics.clear();
      }
      
      public function sendClientScriptStart() : void
      {
         GameInSocketOut.sendClientScriptStart();
      }
      
      public function sendClientScriptEnd() : void
      {
         GameInSocketOut.sendClientScriptEnd();
      }
      
      private function __popupQuestionFrame(evt:CrazyTankSocketEvent) : void
      {
         var id:int = 0;
         var hasAnswered:int = 0;
         var needAnswer:int = 0;
         var questionNumber:int = 0;
         var timeLimit:int = 0;
         var title:String = null;
         var question:String = null;
         var answer1:String = null;
         var answer2:String = null;
         var answer3:String = null;
         var pkg:PackageIn = evt.pkg;
         var pop:Boolean = pkg.readBoolean();
         if(pop)
         {
            id = pkg.readInt();
            hasAnswered = pkg.readInt();
            needAnswer = pkg.readInt();
            questionNumber = pkg.readInt();
            timeLimit = pkg.readInt();
            title = pkg.readUTF();
            question = pkg.readUTF();
            answer1 = pkg.readUTF();
            answer2 = pkg.readUTF();
            answer3 = pkg.readUTF();
            if(Boolean(this._frame))
            {
               this._frame.close();
            }
            this._frame = ComponentFactory.Instance.creatCustomObject("fightLib.view.FightLibQuestionFrame",[id,title,hasAnswered,needAnswer,questionNumber,question,answer1,answer2,answer3,timeLimit]);
            this._frame.show();
         }
         else if(Boolean(this._frame))
         {
            this._frame.close();
         }
      }
      
      public function addRedPointInSmallMap() : void
      {
         this._lessonLiving = new SmallLiving();
         _map.smallMap.addObj(this._lessonLiving);
         _map.smallMap.updatePos(this._lessonLiving,new Point(GameManager.Instance.Current.selfGamePlayer.pos.x + 1000,GameManager.Instance.Current.selfGamePlayer.pos.y));
      }
      
      public function removeRedPointInSmallMap() : void
      {
         if(Boolean(this._lessonLiving))
         {
            _map.smallMap.removeObj(this._lessonLiving);
            this._redPoint = null;
         }
      }
      
      public function leftJustifyWithPlayer() : void
      {
         _map.setCenter(_selfGamePlayer.pos.x + 500,_selfGamePlayer.pos.y,false);
      }
      
      public function leftJustifyWithRedPoint() : void
      {
         _map.setCenter(_selfGamePlayer.pos.x + 1500,_selfGamePlayer.pos.y,false);
      }
      
      override public function addliving(event:CrazyTankSocketEvent) : void
      {
         var living:Living = null;
         super.addliving(event);
         if(this._isWaittingToAttack)
         {
            for each(living in _gameInfo.livings)
            {
               if(!(living is Player))
               {
                  living.addEventListener(LivingEvent.DIE,this.continueScript);
               }
            }
         }
      }
      
      public function waitAttack() : void
      {
         this._isWaittingToAttack = true;
      }
      
      public function continueScript(evt:LivingEvent) : void
      {
         var living:Living = null;
         if(FightLibManager.Instance.isWork == true)
         {
            SocketManager.Instance.out.createMonster();
            return;
         }
         this._isWaittingToAttack = false;
         for each(living in _gameInfo.livings)
         {
            if(!(living is Player))
            {
               living.removeEventListener(LivingEvent.DIE,this.continueScript);
            }
         }
         this._script.continueScript();
      }
      
      public function closeShowTurn() : void
      {
         this._shouldShowTurn = false;
      }
      
      public function openShowTurn() : void
      {
         this._shouldShowTurn = true;
      }
      
      public function enableReanswerBtn() : void
      {
      }
      
      public function blockFly() : void
      {
      }
      
      public function blockSmallMap() : void
      {
         _map.smallMap.allowDrag = false;
      }
      
      public function blockExist() : void
      {
         _map.smallMap.enableExit = false;
      }
      
      public function enableExist() : void
      {
         _map.smallMap.enableExit = true;
      }
      
      public function activeSmallMap() : void
      {
         _map.smallMap.allowDrag = true;
      }
      
      public function skip() : void
      {
         GameInSocketOut.sendGameSkipNext(1);
      }
      
      public function showPowerTable1() : void
      {
         this._powerTable = ComponentFactory.Instance.creat("tank.fightLib.FightLibPowerTableAsset");
         this._powerTable.y = 70;
         this._powerTable.gotoAndStop(1);
         addChild(this._powerTable);
      }
      
      public function showPowerTable2() : void
      {
         this._powerTable = ComponentFactory.Instance.creat("tank.fightLib.FightLibPowerTableAsset");
         this._powerTable.y = 70;
         this._powerTable.gotoAndStop(2);
         addChild(this._powerTable);
      }
      
      public function showPowerTable3() : void
      {
         this._powerTable = ComponentFactory.Instance.creat("tank.fightLib.FightLibPowerTableAsset");
         this._powerTable.y = 70;
         this._powerTable.gotoAndStop(3);
         addChild(this._powerTable);
      }
      
      public function hidePowerTable() : void
      {
         if(Boolean(this._powerTable) && contains(this._powerTable))
         {
            removeChild(this._powerTable);
         }
         this._powerTable = null;
      }
      
      override public function dispose() : void
      {
         super.dispose();
         for(var i:int = LayerManager.Instance.getLayerByType(LayerManager.STAGE_DYANMIC_LAYER).numChildren; i > 0; i--)
         {
            LayerManager.Instance.getLayerByType(LayerManager.STAGE_DYANMIC_LAYER).removeChildAt(0);
         }
         this.removeEvents();
         if(Boolean(this._frame))
         {
            ObjectUtils.disposeObject(this._frame);
            this._frame = null;
         }
         if(Boolean(this._powerTable))
         {
            ObjectUtils.disposeObject(this._powerTable);
            this._powerTable = null;
         }
         if(Boolean(this._redPoint))
         {
            ObjectUtils.disposeObject(this._redPoint);
            this._redPoint = null;
         }
         if(Boolean(this._guildMc))
         {
            TweenLite.killTweensOf(this._guildMc,false);
            ObjectUtils.disposeObject(this._guildMc);
            this._guildMc = null;
         }
      }
      
      override public function leaving(next:BaseStateView) : void
      {
         var living:Living = null;
         this._scriptStarted = false;
         this._isWaittingToAttack = false;
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.POPUP_QUESTION_FRAME,this.__popupQuestionFrame);
         StageReferance.stage.removeEventListener(MouseEvent.MOUSE_UP,this.__downHandler);
         for each(living in _gameInfo.livings)
         {
            if(!(living is Player))
            {
               living.removeEventListener(LivingEvent.DIE,this.continueScript);
            }
         }
         if(Boolean(this._frame))
         {
            if(Boolean(this._frame.parent))
            {
               this._frame.dispose();
            }
            this._frame = null;
         }
         if(Boolean(this._powerTable))
         {
            if(Boolean(this._powerTable.parent))
            {
               this._powerTable.parent.removeChild(this._powerTable);
            }
            this._powerTable = null;
         }
         if(Boolean(this._script))
         {
            this._script.dispose();
            this._script = null;
         }
         super.leaving(next);
         this.dispose();
         GameManager.Instance.reset();
      }
   }
}

