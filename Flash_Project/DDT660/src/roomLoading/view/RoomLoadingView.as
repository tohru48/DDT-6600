package roomLoading.view
{
   import bombKing.BombKingManager;
   import com.greensock.TweenMax;
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.LoadResourceManager;
   import com.pickgliss.loader.ModuleLoader;
   import com.pickgliss.manager.NoviceDataManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.Image;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import consortion.ConsortionModelControl;
   import ddt.data.BallInfo;
   import ddt.loader.MapLoader;
   import ddt.loader.StartupResourceLoader;
   import ddt.loader.TrainerLoader;
   import ddt.manager.BallManager;
   import ddt.manager.GameInSocketOut;
   import ddt.manager.KeyboardShortcutsManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LoadBombManager;
   import ddt.manager.MapManager;
   import ddt.manager.PathManager;
   import ddt.manager.PetSkillManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.StateManager;
   import ddt.manager.TimeManager;
   import ddt.states.StateType;
   import ddt.utils.PositionUtils;
   import drgnBoat.DrgnBoatManager;
   import escort.EscortManager;
   import fightFootballTime.manager.FightFootballTimeManager;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.TextEvent;
   import flash.events.TimerEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.utils.Timer;
   import game.GameManager;
   import game.model.GameInfo;
   import game.model.GameNeedPetSkillInfo;
   import game.model.Player;
   import horse.HorseManager;
   import horse.data.HorseSkillVo;
   import im.IMController;
   import labyrinth.LabyrinthManager;
   import pet.date.PetInfo;
   import pet.date.PetSkillTemplateInfo;
   import road7th.data.DictionaryData;
   import room.RoomManager;
   import room.events.RoomPlayerEvent;
   import room.model.RoomInfo;
   import room.model.RoomPlayer;
   import room.transnational.RoomLoadingTransnationalFieldItem;
   import sevenDouble.SevenDoubleManager;
   import trainer.controller.LevelRewardManager;
   import trainer.controller.NewHandGuideManager;
   import trainer.controller.WeakGuildManager;
   import worldboss.WorldBossManager;
   
   public class RoomLoadingView extends Sprite implements Disposeable
   {
      
      protected static const DELAY_TIME:int = 1000;
      
      protected var _bg:Bitmap;
      
      protected var _gameInfo:GameInfo;
      
      protected var _versus:RoomLoadingVersusItem;
      
      protected var _countDownTxt:RoomLoadingCountDownNum;
      
      protected var _battleField:RoomLoadingBattleFieldItem;
      
      protected var _tipsItem:RoomLoadingTipsItem;
      
      protected var _viewerItem:RoomLoadingViewerItem;
      
      protected var _dungeonMapItem:RoomLoadingDungeonMapItem;
      
      protected var _characterItems:Vector.<RoomLoadingCharacterItem>;
      
      protected var _countDownTimer:Timer;
      
      protected var _selfFinish:Boolean;
      
      protected var _trainerLoad:TrainerLoader;
      
      protected var _startTime:Number;
      
      protected var _chatViewBg:Image;
      
      protected var blueIdx:int = 1;
      
      protected var redIdx:int = 1;
      
      protected var blueCharacterIndex:int = 1;
      
      protected var redCharacterIndex:int = 1;
      
      protected var blueBig:RoomLoadingCharacterItem;
      
      protected var redBig:RoomLoadingCharacterItem;
      
      protected var blueFlag:RoomLoadingTransnationalFieldItem;
      
      protected var redFlag:RoomLoadingTransnationalFieldItem;
      
      protected var _leaving:Boolean = false;
      
      protected var _amountOfFinishedPlayer:int = 0;
      
      protected var _hasLoadedFinished:DictionaryData = new DictionaryData();
      
      protected var _delayBeginTime:Number = 0;
      
      private var _cancelLink:FilterFrameText;
      
      protected var _unloadedmsg:String = "";
      
      public function RoomLoadingView($info:GameInfo)
      {
         super();
         this._gameInfo = $info;
         this.init();
      }
      
      protected function init() : void
      {
         if(NewHandGuideManager.Instance.mapID == 111)
         {
            this._startTime = new Date().getTime();
         }
         TimeManager.Instance.enterFightTime = new Date().getTime();
         LevelRewardManager.Instance.hide();
         this.blueFlag = new RoomLoadingTransnationalFieldItem();
         this.redFlag = new RoomLoadingTransnationalFieldItem();
         this._characterItems = new Vector.<RoomLoadingCharacterItem>();
         KeyboardShortcutsManager.Instance.forbiddenFull();
         this._bg = ComponentFactory.Instance.creatBitmap("asset.roomloading.vsBg");
         var mode:int = RoomManager.Instance.current.gameMode;
         this._versus = ComponentFactory.Instance.creatCustomObject("roomLoading.VersusItem",[RoomManager.Instance.current.gameMode]);
         this._countDownTxt = ComponentFactory.Instance.creatCustomObject("roomLoading.CountDownItem");
         this._battleField = ComponentFactory.Instance.creatCustomObject("roomLoading.BattleFieldItem",[this._gameInfo.mapIndex]);
         this._tipsItem = ComponentFactory.Instance.creatCustomObject("roomLoading.TipsItem");
         this._viewerItem = ComponentFactory.Instance.creatCustomObject("roomLoading.ViewerItem");
         this._chatViewBg = ComponentFactory.Instance.creatComponentByStylename("roomloading.ChatViewBg");
         this._selfFinish = false;
         if(RoomManager.Instance.current.type != RoomInfo.FIGHTFOOTBALLTIME_ROOM)
         {
            addChild(this._bg);
            addChild(this._chatViewBg);
            addChild(this._versus);
            addChild(this._countDownTxt);
            addChild(this._battleField);
            addChild(this._tipsItem);
         }
         this.initLoadingItems();
         if(this._gameInfo.gameMode == 7 || this._gameInfo.gameMode == 31 || this._gameInfo.gameMode == 4 || this._gameInfo.gameMode == 8 || this._gameInfo.gameMode == 10 || this._gameInfo.gameMode == 17 || this._gameInfo.gameMode == 19 || this._gameInfo.gameMode == GameManager.CAMP_BATTLE_MODEL_PVE || this._gameInfo.gameMode == 25 || this._gameInfo.gameMode == 40 || this._gameInfo.gameMode == GameManager.FARM_BOSS_MODEL || this._gameInfo.gameMode == GameManager.RESCUE_MODEL || this._gameInfo.gameMode == GameManager.CATCH_INSECT_MODEL || this._gameInfo.gameMode == GameManager.TREASURELOST || this._gameInfo.gameMode == GameManager.TREASURELOST)
         {
            if(!this.redBig)
            {
               this._dungeonMapItem = ComponentFactory.Instance.creatCustomObject("roomLoading.DungeonMapItem");
            }
         }
         if(Boolean(this._dungeonMapItem))
         {
            addChild(this._dungeonMapItem);
         }
         var time:int = RoomManager.Instance.current.type == RoomInfo.DUNGEON_ROOM || RoomManager.Instance.current.type == RoomInfo.ACADEMY_DUNGEON_ROOM || RoomManager.Instance.current.type == RoomInfo.SINGLE_BATTLE || RoomManager.Instance.current.type == RoomInfo.CONSORTIA_MATCH_SCORE ? 94 : 64;
         this._countDownTimer = new Timer(1000,time);
         this._countDownTimer.addEventListener(TimerEvent.TIMER,this.__countDownTick);
         this._countDownTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.__countDownComplete);
         this._countDownTimer.start();
         StateManager.currentStateType = StateType.GAME_LOADING;
         if(NewHandGuideManager.Instance.mapID == 112)
         {
            NoviceDataManager.instance.saveNoviceData(360,PathManager.userName(),PathManager.solveRequestPath());
         }
         if(BombKingManager.instance.Recording)
         {
            this.addCancelLink();
         }
      }
      
      private function addCancelLink() : void
      {
         this._cancelLink = ComponentFactory.Instance.creatComponentByStylename("room.roomLoading.cancelLook");
         this._cancelLink.htmlText = LanguageMgr.GetTranslation("bombKing.roomLoading.cancelLookTxt");
         this._cancelLink.mouseEnabled = true;
         addChild(this._cancelLink);
         this._cancelLink.addEventListener(TextEvent.LINK,this.__onCancelLinkClick);
      }
      
      private function deleteCancelLink() : void
      {
         if(Boolean(this._cancelLink))
         {
            this._cancelLink.removeEventListener(TextEvent.LINK,this.__onCancelLinkClick);
            this._cancelLink.dispose();
            this._cancelLink = null;
         }
      }
      
      private function __onCancelLinkClick(event:TextEvent) : void
      {
         BombKingManager.instance.reset();
         StateManager.setState(StateType.MAIN);
      }
      
      protected function initLoadingItems() : void
      {
         var blueLen:int = 0;
         var redLen:int = 0;
         var roomPlayers:Array = null;
         var team:int = 0;
         var rp1:RoomPlayer = null;
         var rp:RoomPlayer = null;
         var i:int = 0;
         var roomPlayer:RoomPlayer = null;
         var item:RoomLoadingCharacterItem = null;
         var gameplayer:Player = null;
         var currentPet:PetInfo = null;
         var horseSkillEquipList:Array = null;
         var horseSkillId:int = 0;
         var skillid:int = 0;
         var skill:PetSkillTemplateInfo = null;
         var ball:BallInfo = null;
         var horseSkillInfo:HorseSkillVo = null;
         var ball2:BallInfo = null;
         var j:int = 0;
         var skillRes:GameNeedPetSkillInfo = null;
         var len:int = int(this._gameInfo.roomPlayers.length);
         roomPlayers = this._gameInfo.roomPlayers;
         if(this._gameInfo.roomType == 20)
         {
         }
         LoadBombManager.Instance.loadFullRoomPlayersBomb(roomPlayers);
         if(!StartupResourceLoader.firstEnterHall)
         {
            LoadBombManager.Instance.loadSpecialBomb();
         }
         for each(rp1 in roomPlayers)
         {
            if(PlayerManager.Instance.Self.ID == rp1.playerInfo.ID)
            {
               team = rp1.team;
            }
         }
         for each(rp in roomPlayers)
         {
            if(!rp.isViewer)
            {
               if(rp.team == RoomPlayer.BLUE_TEAM)
               {
                  blueLen++;
               }
               else
               {
                  redLen++;
               }
               if(!(RoomManager.Instance.current.type == RoomInfo.FREE_MODE && rp.team != team))
               {
                  IMController.Instance.saveRecentContactsID(rp.playerInfo.ID);
               }
            }
         }
         for(i = 0; i < len; i++)
         {
            roomPlayer = this._gameInfo.roomPlayers[i];
            roomPlayer.addEventListener(RoomPlayerEvent.PROGRESS_CHANGE,this.__onLoadingFinished);
            if(roomPlayer.isViewer)
            {
               if(contains(this._tipsItem))
               {
                  removeChild(this._tipsItem);
               }
               addChild(this._viewerItem);
            }
            else
            {
               item = new RoomLoadingCharacterItem(roomPlayer);
               this.initRoomItem(item);
               gameplayer = this._gameInfo.findLivingByPlayerID(roomPlayer.playerInfo.ID,roomPlayer.playerInfo.ZoneID);
               this.initCharacter(gameplayer,item);
               if(RoomManager.Instance.isTransnationalFight() && gameplayer.isSelf)
               {
                  currentPet = gameplayer.playerInfo.snapPet;
               }
               else
               {
                  currentPet = gameplayer.playerInfo.currentPet;
               }
               if(Boolean(currentPet))
               {
                  LoadResourceManager.Instance.creatAndStartLoad(PathManager.solvePetGameAssetUrl(currentPet.GameAssetUrl),BaseLoader.MODULE_LOADER);
                  for each(skillid in currentPet.equipdSkills)
                  {
                     if(skillid > 0)
                     {
                        skill = PetSkillManager.getSkillByID(skillid);
                        if(Boolean(skill.EffectPic))
                        {
                           LoadResourceManager.Instance.creatAndStartLoad(PathManager.solvePetSkillEffect(skill.EffectPic),BaseLoader.MODULE_LOADER);
                        }
                        if(skill.NewBallID != -1)
                        {
                           ball = BallManager.findBall(skill.NewBallID);
                           ball.loadBombAsset();
                           ball.loadCraterBitmap();
                        }
                     }
                  }
               }
               horseSkillEquipList = roomPlayer.horseSkillEquipList;
               for each(horseSkillId in horseSkillEquipList)
               {
                  if(horseSkillId > 0)
                  {
                     horseSkillInfo = HorseManager.instance.getHorseSkillInfoById(horseSkillId);
                     if(Boolean(horseSkillInfo.EffectPic))
                     {
                        LoadResourceManager.Instance.creatAndStartLoad(PathManager.solvePetSkillEffect(horseSkillInfo.EffectPic),BaseLoader.MODULE_LOADER);
                     }
                     if(horseSkillInfo.NewBallID != -1)
                     {
                        ball2 = BallManager.findBall(horseSkillInfo.NewBallID);
                        ball2.loadBombAsset();
                        ball2.loadCraterBitmap();
                     }
                  }
               }
            }
         }
         if(Boolean(this.blueBig))
         {
            addChild(this.blueBig);
         }
         if(Boolean(this.redBig))
         {
            addChild(this.redBig);
         }
         if(!StartupResourceLoader.firstEnterHall)
         {
            for(j = 0; j < this._gameInfo.neededMovies.length; j++)
            {
               if(this._gameInfo.neededMovies[j].type == 1)
               {
                  this._gameInfo.neededMovies[j].startLoad();
               }
            }
            for each(skillRes in this._gameInfo.neededPetSkillResource)
            {
               skillRes.startLoad();
            }
         }
         this._gameInfo.loaderMap = new MapLoader(MapManager.getMapInfo(this._gameInfo.mapIndex));
         this._gameInfo.loaderMap.load();
         switch(NewHandGuideManager.Instance.mapID)
         {
            case 111:
               this._trainerLoad = new TrainerLoader("1");
               break;
            case 112:
               this._trainerLoad = new TrainerLoader("2");
               break;
            case 113:
               this._trainerLoad = new TrainerLoader("3");
               break;
            case 114:
               this._trainerLoad = new TrainerLoader("4");
               break;
            case 115:
               this._trainerLoad = new TrainerLoader("5");
               break;
            case 116:
               this._trainerLoad = new TrainerLoader("6");
         }
         if(Boolean(this._trainerLoad))
         {
            this._trainerLoad.load();
         }
      }
      
      protected function __onLoadingFinished(event:Event) : void
      {
         var player:RoomPlayer = event.currentTarget as RoomPlayer;
         if(player.progress < 100 || this._hasLoadedFinished.hasKey(player))
         {
            return;
         }
         ++this._amountOfFinishedPlayer;
         this._hasLoadedFinished.add(player,player);
         if(this._amountOfFinishedPlayer == this._gameInfo.roomPlayers.length)
         {
            this.leave();
         }
      }
      
      protected function initCharacter(gameplayer:Player, item:RoomLoadingCharacterItem) : void
      {
         var size:Rectangle = ComponentFactory.Instance.creatCustomObject("asset.roomloading.BigCharacterSize");
         var suitSize:Rectangle = ComponentFactory.Instance.creatCustomObject("asset.roomloading.SuitCharacterSize");
         gameplayer.movie = item.info.movie;
         gameplayer.character = item.info.character;
         gameplayer.character.showGun = false;
         gameplayer.character.showWing = false;
         if(item.info.team == RoomPlayer.BLUE_TEAM)
         {
            if(gameplayer.isSelf || this.blueCharacterIndex == 1 && this._gameInfo.selfGamePlayer.team != RoomPlayer.BLUE_TEAM)
            {
               PositionUtils.setPos(item.displayMc,"asset.roomloading.BigCharacterBluePos");
               gameplayer.character.showWithSize(false,-1,size.width,size.height);
            }
            else
            {
               PositionUtils.setPos(item.displayMc,"asset.roomloading.SmallCharacterBluePos");
               gameplayer.character.show(false,-1);
            }
            item.appear(this.blueCharacterIndex.toString());
            item.index = this.blueCharacterIndex;
            ++this.blueCharacterIndex;
         }
         else
         {
            if(gameplayer.isSelf || this.redCharacterIndex == 1 && this._gameInfo.selfGamePlayer.team != RoomPlayer.RED_TEAM)
            {
               gameplayer.character.showWithSize(false,-1,size.width,size.height);
               PositionUtils.setPos(item.displayMc,"asset.roomloading.BigCharacterRedPos");
            }
            else
            {
               PositionUtils.setPos(item.displayMc,"asset.roomloading.SmallCharacterRedPos");
               gameplayer.character.show(false,-1);
            }
            item.appear(this.redCharacterIndex.toString());
            item.index = this.redCharacterIndex;
            ++this.redCharacterIndex;
         }
         gameplayer.movie.show(true,-1);
      }
      
      protected function initRoomItem(item:RoomLoadingCharacterItem) : void
      {
         var fromPos:Point = null;
         if(item.info.team == RoomPlayer.BLUE_TEAM)
         {
            if(item.info.isSelf || this.blueIdx == 1 && this._gameInfo.selfGamePlayer.team != RoomPlayer.BLUE_TEAM)
            {
               PositionUtils.setPos(item,"asset.roomLoading.CharacterItemBluePos_1");
               fromPos = ComponentFactory.Instance.creatCustomObject("asset.roomLoading.CharacterItemBlueFromPos_1");
               this.blueBig = item;
               if(RoomManager.Instance.isTransnationalFight())
               {
                  this.blueFlag.FlagID = item.info.playerInfo.flagID;
                  PositionUtils.setPos(this.blueFlag,"asset.roomLoading.flagItemBluePos");
                  addChild(this.blueFlag);
               }
               item.addWeapon(false,-1);
               if(this._gameInfo.selfGamePlayer.team != RoomPlayer.BLUE_TEAM)
               {
                  ++this.blueIdx;
               }
            }
            else
            {
               if(this.blueIdx == 1)
               {
                  ++this.blueIdx;
               }
               PositionUtils.setPos(item,"asset.roomLoading.CharacterItemBluePos_" + this.blueIdx.toString());
               fromPos = ComponentFactory.Instance.creatCustomObject("asset.roomLoading.CharacterItemBlueFromPos_" + this.blueIdx.toString());
               ++this.blueIdx;
               item.addWeapon(true,-1);
            }
         }
         else if(item.info.isSelf || this.redIdx == 1 && this._gameInfo.selfGamePlayer.team != RoomPlayer.RED_TEAM)
         {
            PositionUtils.setPos(item,"asset.roomLoading.CharacterItemRedPos_1");
            fromPos = ComponentFactory.Instance.creatCustomObject("asset.roomLoading.CharacterItemRedFromPos_1");
            this.redBig = item;
            if(RoomManager.Instance.isTransnationalFight())
            {
               this.redFlag.FlagID = item.info.playerInfo.flagID;
               PositionUtils.setPos(this.redFlag,"asset.roomLoading.flagItemRedPos");
               addChild(this.redFlag);
            }
            item.addWeapon(false,1);
            if(this._gameInfo.selfGamePlayer.team != RoomPlayer.RED_TEAM)
            {
               ++this.redIdx;
            }
         }
         else
         {
            if(this.redIdx == 1)
            {
               ++this.redIdx;
            }
            PositionUtils.setPos(item,"asset.roomLoading.CharacterItemRedPos_" + this.redIdx.toString());
            fromPos = ComponentFactory.Instance.creatCustomObject("asset.roomLoading.CharacterItemRedFromPos_" + this.redIdx.toString());
            ++this.redIdx;
            item.addWeapon(true,1);
         }
         this._characterItems.push(item);
         if(RoomManager.Instance.current.type != RoomInfo.FIGHTFOOTBALLTIME_ROOM)
         {
            addChild(item);
         }
      }
      
      protected function leave() : void
      {
         if(!this._leaving)
         {
            this._characterItems.forEach(function(item:RoomLoadingCharacterItem, index:int, array:Vector.<RoomLoadingCharacterItem>):void
            {
               item.disappear(item.index.toString());
            });
            if(Boolean(this._dungeonMapItem))
            {
               this._dungeonMapItem.disappear();
            }
            this._leaving = true;
         }
      }
      
      protected function __countDownTick(evt:TimerEvent) : void
      {
         this._selfFinish = this.checkProgress();
         this._countDownTxt.updateNum();
         if(this._selfFinish)
         {
            dispatchEvent(new Event(Event.COMPLETE));
            if(NewHandGuideManager.Instance.mapID == 111)
            {
               WeakGuildManager.Instance.timeStatistics(1,this._startTime);
            }
         }
      }
      
      protected function __countDownComplete(event:TimerEvent) : void
      {
         var tempTime:int = RoomManager.Instance.current.type == RoomInfo.DUNGEON_ROOM || RoomManager.Instance.current.type == RoomInfo.ACADEMY_DUNGEON_ROOM ? 94 : 64;
         if(this._countDownTimer.currentCount == tempTime && RoomManager.Instance.current.type == RoomInfo.WORLD_BOSS_FIGHT)
         {
            WorldBossManager.IsSuccessStartGame = false;
            StateManager.setState(StateType.MAIN);
            return;
         }
         if(!this._selfFinish)
         {
            if(RoomManager.Instance.current.type == RoomInfo.MATCH_ROOM || RoomManager.Instance.current.type == RoomInfo.CHALLENGE_ROOM || RoomManager.Instance.current.type == RoomInfo.ENCOUNTER_ROOM || RoomManager.Instance.current.type == RoomInfo.SINGLE_BATTLE)
            {
               StateManager.setState(StateType.ROOM_LIST);
            }
            else if(RoomManager.Instance.current.type == RoomInfo.FRESHMAN_ROOM)
            {
               StateManager.setState(StateType.MAIN);
            }
            else if(RoomManager.Instance.current.type == RoomInfo.FIGHT_LIB_ROOM || GameManager.Instance.Current.roomType == FightFootballTimeManager.FIGHTFOOTBALLTIME_ROOM)
            {
               StateManager.setState(StateType.MAIN);
            }
            else if(RoomManager.Instance.current.type == RoomInfo.WORLD_BOSS_FIGHT)
            {
               WorldBossManager.IsSuccessStartGame = false;
               StateManager.setState(StateType.WORLDBOSS_ROOM);
            }
            else if(RoomManager.Instance.current.type == RoomInfo.LANBYRINTH_ROOM)
            {
               StateManager.setState(StateType.MAIN,LabyrinthManager.Instance.show);
            }
            else if(RoomManager.Instance.current.type == RoomInfo.CONSORTIA_BOSS)
            {
               StateManager.setState(StateType.CONSORTIA,ConsortionModelControl.Instance.openBossFrame);
            }
            else if(RoomManager.Instance.current.type == RoomInfo.CONSORTIA_BATTLE)
            {
               StateManager.setState(StateType.MAIN);
            }
            else if(RoomManager.Instance.current.type == RoomInfo.CAMPBATTLE_BATTLE)
            {
               GameInSocketOut.sendSingleRoomBegin(RoomManager.CAMP_BATTLE_ROOM);
            }
            else if(RoomManager.Instance.current.type == RoomInfo.TRANSNATIONALFIGHT_ROOM)
            {
               StateManager.setState(StateType.MAIN);
            }
            else if(RoomManager.Instance.current.type == RoomInfo.SEVEN_DOUBLE)
            {
               if(SevenDoubleManager.instance.isStart)
               {
                  StateManager.setState(StateType.SEVEN_DOUBLE_SCENE);
               }
               else if(EscortManager.instance.isStart)
               {
                  StateManager.setState(StateType.ESCORT);
               }
               else if(DrgnBoatManager.instance.isStart)
               {
                  StateManager.setState(StateType.DRGN_BOAT);
               }
               else
               {
                  StateManager.setState(StateType.MAIN);
               }
            }
            else if(RoomManager.Instance.current.type == RoomInfo.CONSORTIA_MATCH_SCORE || RoomManager.Instance.current.type == RoomInfo.CONSORTIA_MATCH_RANK || RoomManager.Instance.current.type == RoomInfo.CONSORTIA_MATCH_SCORE_WHOLE || RoomManager.Instance.current.type == RoomInfo.CONSORTIA_MATCH_RANK_WHOLE)
            {
               StateManager.setState(StateType.MAIN);
            }
            else if(RoomManager.Instance.current.type == RoomInfo.CRYPTBOSS_ROOM)
            {
               StateManager.setState(StateType.MAIN);
            }
            else
            {
               StateManager.setState(StateType.DUNGEON_LIST);
            }
            SocketManager.Instance.out.sendErrorMsg(this._unloadedmsg);
         }
         else if(BombKingManager.instance.Recording)
         {
            StateManager.setState(StateType.MAIN);
         }
      }
      
      protected function checkAnimationIsFinished() : Boolean
      {
         var item:RoomLoadingCharacterItem = null;
         for each(item in this._characterItems)
         {
            if(!item.isAnimationFinished)
            {
               return false;
            }
         }
         if(this._delayBeginTime <= 0)
         {
            this._delayBeginTime = new Date().time;
         }
         return true;
      }
      
      protected function checkProgress() : Boolean
      {
         var info:RoomPlayer = null;
         var skillRes:GameNeedPetSkillInfo = null;
         var i:int = 0;
         var gameInfoTest:GameInfo = null;
         var gameplayer:Player = null;
         var currentPet:PetInfo = null;
         var horseSkillEquipList:Array = null;
         var horseSkillId:int = 0;
         var skillid:int = 0;
         var skill:PetSkillTemplateInfo = null;
         var ball:BallInfo = null;
         var horseSkillInfo:HorseSkillVo = null;
         var ball2:BallInfo = null;
         this._unloadedmsg = "";
         var total:int = 0;
         var finished:int = 0;
         if(this._gameInfo == null)
         {
            this._gameInfo = GameManager.Instance.Current;
         }
         for each(info in this._gameInfo.roomPlayers)
         {
            if(!info.isViewer)
            {
               gameInfoTest = GameManager.Instance.Current;
               gameplayer = this._gameInfo.findLivingByPlayerID(info.playerInfo.ID,info.playerInfo.ZoneID);
               if(LoadBombManager.Instance.getLoadBombComplete(info.currentWeapInfo))
               {
                  finished++;
               }
               else
               {
                  this._unloadedmsg += "LoadBombManager.getLoadBombComplete(info.currentWeapInfo) false" + LoadBombManager.Instance.getUnloadedBombString(info.currentWeapInfo) + "\n";
               }
               total++;
               if(RoomManager.Instance.isTransnationalFight() && gameplayer.isSelf)
               {
                  currentPet = gameplayer.playerInfo.snapPet;
               }
               else
               {
                  currentPet = gameplayer.playerInfo.currentPet;
               }
               if(Boolean(currentPet))
               {
                  if(currentPet.assetReady)
                  {
                     finished++;
                  }
                  total++;
                  for each(skillid in currentPet.equipdSkills)
                  {
                     if(skillid > 0)
                     {
                        skill = PetSkillManager.getSkillByID(skillid);
                        if(Boolean(skill.EffectPic))
                        {
                           if(ModuleLoader.hasDefinition(skill.EffectClassLink))
                           {
                              finished++;
                           }
                           else
                           {
                              this._unloadedmsg += "ModuleLoader.hasDefinition(skill.EffectClassLink):" + skill.EffectClassLink + " false\n";
                           }
                           total++;
                        }
                        if(skill.NewBallID != -1)
                        {
                           ball = BallManager.findBall(skill.NewBallID);
                           if(ball.isComplete())
                           {
                              finished++;
                           }
                           else
                           {
                              this._unloadedmsg += "BallManager.findBall(skill.NewBallID):" + skill.NewBallID + "false\n";
                           }
                           total++;
                        }
                     }
                  }
               }
               horseSkillEquipList = info.horseSkillEquipList;
               for each(horseSkillId in horseSkillEquipList)
               {
                  if(horseSkillId > 0)
                  {
                     horseSkillInfo = HorseManager.instance.getHorseSkillInfoById(horseSkillId);
                     if(Boolean(horseSkillInfo.EffectPic))
                     {
                        if(ModuleLoader.hasDefinition(horseSkillInfo.EffectClassLink))
                        {
                           finished++;
                        }
                        else
                        {
                           this._unloadedmsg += "ModuleLoader.hasDefinition(horseSkillInfo.EffectClassLink):" + horseSkillInfo.EffectClassLink + " false\n";
                        }
                        total++;
                     }
                     if(horseSkillInfo.NewBallID != -1)
                     {
                        ball2 = BallManager.findBall(horseSkillInfo.NewBallID);
                        if(ball2.isComplete())
                        {
                           finished++;
                        }
                        else
                        {
                           this._unloadedmsg += "BallManager.findBall(horseSkillInfo.NewBallID):" + horseSkillInfo.NewBallID + "false\n";
                        }
                        total++;
                     }
                  }
               }
            }
         }
         for each(skillRes in this._gameInfo.neededPetSkillResource)
         {
            if(skillRes.effect)
            {
               if(ModuleLoader.hasDefinition(skillRes.effectClassLink))
               {
                  finished++;
               }
               else
               {
                  this._unloadedmsg += "ModuleLoader.hasDefinition(" + skillRes.effectClassLink + ") false\n";
               }
               total++;
            }
         }
         for(i = 0; i < this._gameInfo.neededMovies.length; i++)
         {
            if(this._gameInfo.neededMovies[i].type == 1)
            {
               if(LoadBombManager.Instance.getLivingBombComplete(this._gameInfo.neededMovies[i].bombId))
               {
                  finished++;
               }
               else
               {
                  this._unloadedmsg += "LoadBombManager.getLivingBombComplete(_gameInfo.neededMovies[i].bombId):" + this._gameInfo.neededMovies[i].bombId + " false\n";
               }
               total++;
            }
         }
         if(this._gameInfo.loaderMap.completed)
         {
            finished++;
         }
         else
         {
            this._unloadedmsg += "_gameInfo.loaderMap.completed false,pic: " + this._gameInfo.loaderMap.info.Pic + "id:" + this._gameInfo.loaderMap.info.ID + "\n";
         }
         total++;
         if(!StartupResourceLoader.firstEnterHall)
         {
            if(LoadBombManager.Instance.getLoadSpecialBombComplete())
            {
               finished++;
            }
            else
            {
               this._unloadedmsg += "LoadBombManager.getLoadSpecialBombComplete() false  " + LoadBombManager.Instance.getUnloadedSpecialBombString() + "\n";
            }
            total++;
         }
         if(Boolean(this._trainerLoad))
         {
            if(this._trainerLoad.completed)
            {
               finished++;
            }
            else
            {
               this._unloadedmsg += "_trainerLoad.completed false\n";
            }
            total++;
         }
         var pro:Number = int(finished / total * 100);
         var res:Boolean = total == finished;
         if(res && (!this.checkAnimationIsFinished() || !this.checkIsEnoughDelayTime()))
         {
            pro = 99;
            res = false;
         }
         GameInSocketOut.sendLoadingProgress(pro);
         RoomManager.Instance.current.selfRoomPlayer.progress = pro;
         return res;
      }
      
      protected function checkIsEnoughDelayTime() : Boolean
      {
         var time:Number = new Date().time;
         return time - this._delayBeginTime >= DELAY_TIME;
      }
      
      public function dispose() : void
      {
         var rp:RoomPlayer = null;
         var i:int = 0;
         KeyboardShortcutsManager.Instance.cancelForbidden();
         this._countDownTimer.removeEventListener(TimerEvent.TIMER,this.__countDownTick);
         this._countDownTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.__countDownComplete);
         this._countDownTimer.stop();
         this._countDownTimer = null;
         ObjectUtils.disposeObject(this._trainerLoad);
         ObjectUtils.disposeObject(this._bg);
         ObjectUtils.disposeObject(this._chatViewBg);
         ObjectUtils.disposeObject(this._versus);
         ObjectUtils.disposeObject(this._countDownTxt);
         ObjectUtils.disposeObject(this._battleField);
         ObjectUtils.disposeObject(this._tipsItem);
         ObjectUtils.disposeObject(this._viewerItem);
         ObjectUtils.disposeObject(this._cancelLink);
         for each(rp in this._gameInfo.roomPlayers)
         {
            rp.removeEventListener(RoomPlayerEvent.PROGRESS_CHANGE,this.__onLoadingFinished);
         }
         for(i = 0; i < this._characterItems.length; i++)
         {
            TweenMax.killTweensOf(this._characterItems[i]);
            this._characterItems[i].dispose();
            this._characterItems[i] = null;
         }
         if(Boolean(this._dungeonMapItem))
         {
            ObjectUtils.disposeObject(this._dungeonMapItem);
            this._dungeonMapItem = null;
         }
         this.deleteCancelLink();
         this._characterItems = null;
         this._trainerLoad = null;
         this._bg = null;
         this._chatViewBg = null;
         this._cancelLink = null;
         this._gameInfo = null;
         this._versus = null;
         this._countDownTxt = null;
         this._battleField = null;
         this._tipsItem = null;
         this._countDownTimer = null;
         this._viewerItem = null;
         if(Boolean(this.blueFlag))
         {
            this.blueFlag.dispose();
            this.blueFlag = null;
         }
         if(Boolean(this.redFlag))
         {
            this.redFlag.dispose();
            this.redFlag = null;
         }
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

