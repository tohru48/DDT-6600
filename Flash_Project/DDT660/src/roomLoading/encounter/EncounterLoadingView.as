package roomLoading.encounter
{
   import com.greensock.TweenMax;
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.LoadResourceManager;
   import com.pickgliss.loader.ModuleLoader;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.UICreatShortcut;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.BallInfo;
   import ddt.events.GameEvent;
   import ddt.loader.MapLoader;
   import ddt.loader.StartupResourceLoader;
   import ddt.loader.TrainerLoader;
   import ddt.manager.BallManager;
   import ddt.manager.GameInSocketOut;
   import ddt.manager.KeyboardShortcutsManager;
   import ddt.manager.LoadBombManager;
   import ddt.manager.MapManager;
   import ddt.manager.PathManager;
   import ddt.manager.PetSkillManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.StateManager;
   import ddt.manager.TimeManager;
   import ddt.states.StateType;
   import ddt.utils.PositionUtils;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.utils.Timer;
   import game.GameManager;
   import game.model.GameInfo;
   import game.model.GameNeedPetSkillInfo;
   import game.model.Player;
   import im.IMController;
   import pet.date.PetInfo;
   import pet.date.PetSkillTemplateInfo;
   import room.RoomManager;
   import room.events.RoomPlayerEvent;
   import room.model.RoomInfo;
   import room.model.RoomPlayer;
   import roomLoading.view.RoomLoadingCharacterItem;
   import roomLoading.view.RoomLoadingView;
   import trainer.controller.LevelRewardManager;
   import trainer.controller.NewHandGuideManager;
   
   public class EncounterLoadingView extends RoomLoadingView
   {
      
      protected var _playerItems:Vector.<EncounterLoadingCharacterItem>;
      
      protected var _love:MovieClip;
      
      protected var _loveII:MovieClip;
      
      protected var _selfItem:EncounterLoadingCharacterItem;
      
      protected var _showArrowComplete:Boolean = false;
      
      protected var _pairingComplete:Boolean = false;
      
      protected var boyIdx:int = 1;
      
      protected var girlIdx:int = 1;
      
      public function EncounterLoadingView($info:GameInfo)
      {
         super($info);
      }
      
      override protected function init() : void
      {
         if(NewHandGuideManager.Instance.mapID == 111)
         {
            _startTime = new Date().getTime();
         }
         TimeManager.Instance.enterFightTime = new Date().getTime();
         LevelRewardManager.Instance.hide();
         this._playerItems = new Vector.<EncounterLoadingCharacterItem>();
         KeyboardShortcutsManager.Instance.forbiddenFull();
         _bg = UICreatShortcut.creatAndAdd("asset.EncounterLoadingView.Bg",this);
         _countDownTxt = ComponentFactory.Instance.creatCustomObject("roomLoading.CountDownItem");
         _battleField = ComponentFactory.Instance.creatCustomObject("roomLoading.BattleFieldItem",[_gameInfo.mapIndex]);
         _tipsItem = ComponentFactory.Instance.creatCustomObject("roomLoading.TipsItem");
         _viewerItem = ComponentFactory.Instance.creatCustomObject("roomLoading.ViewerItem");
         _chatViewBg = ComponentFactory.Instance.creatComponentByStylename("roomloading.ChatViewBg");
         this._love = UICreatShortcut.creatAndAdd("ddtroomLoading.EncounterLoadingView.love",this);
         this._loveII = UICreatShortcut.creatAndAdd("ddtroomLoading.EncounterLoadingView.loveII",this);
         this._loveII.visible = false;
         if(_gameInfo.gameMode == 7 || _gameInfo.gameMode == 8 || _gameInfo.gameMode == 10 || _gameInfo.gameMode == 17)
         {
            _dungeonMapItem = ComponentFactory.Instance.creatCustomObject("roomLoading.DungeonMapItem");
         }
         _selfFinish = false;
         addChild(_chatViewBg);
         addChild(_countDownTxt);
         addChild(_battleField);
         addChild(_tipsItem);
         this.initLoadingItems();
         if(Boolean(_dungeonMapItem))
         {
            addChild(_dungeonMapItem);
         }
         var time:int = RoomManager.Instance.current.type == RoomInfo.DUNGEON_ROOM || RoomManager.Instance.current.type == RoomInfo.ACADEMY_DUNGEON_ROOM ? 94 : 64;
         _countDownTimer = new Timer(1000,time);
         _countDownTimer.addEventListener(TimerEvent.TIMER,__countDownTick);
         _countDownTimer.addEventListener(TimerEvent.TIMER_COMPLETE,__countDownComplete);
         _countDownTimer.start();
         StateManager.currentStateType = StateType.GAME_LOADING;
         GameManager.Instance.addEventListener(GameEvent.SELECT_COMPLETE,this.__pairingComplete);
      }
      
      protected function __pairingComplete(event:GameEvent) : void
      {
         var timer:Timer = null;
         if(!this._showArrowComplete)
         {
            this.showArrow();
            timer = new Timer(1000,2);
            timer.start();
            timer.addEventListener(TimerEvent.TIMER_COMPLETE,this.__showPairing);
            this._showArrowComplete = true;
         }
      }
      
      protected function __showPairing(event:TimerEvent) : void
      {
         this.hideArrow();
         var boyItem1:EncounterLoadingCharacterItem = this.getItemByTeam(1,true);
         var grilItem1:EncounterLoadingCharacterItem = this.getItemByTeam(1,false);
         var boyItem2:EncounterLoadingCharacterItem = this.getItemByTeam(2,true);
         var grilItem2:EncounterLoadingCharacterItem = this.getItemByTeam(2,false);
         var pos1:Point = PositionUtils.creatPoint("asset.roomLoading.EncounterLoadingCharacterItemBoyPos_1");
         var pos2:Point = PositionUtils.creatPoint("asset.roomLoading.EncounterLoadingCharacterItemGirlPos_1");
         var pos3:Point = PositionUtils.creatPoint("asset.roomLoading.EncounterLoadingCharacterItemBoyToPos_1");
         var pos4:Point = PositionUtils.creatPoint("asset.roomLoading.EncounterLoadingCharacterItemBoyToPos_2");
         var pos5:Point = PositionUtils.creatPoint("ddtroomLoading.EncounterLoadingView.lovePos");
         var pos6:Point = PositionUtils.creatPoint("ddtroomLoading.EncounterLoadingView.lovePos1");
         if(Boolean(boyItem1))
         {
            TweenMax.to(boyItem1,2,{
               "x":pos1.x,
               "y":pos1.y
            });
         }
         if(Boolean(grilItem1))
         {
            TweenMax.to(grilItem1,2,{
               "x":pos3.x,
               "y":pos3.y
            });
         }
         if(Boolean(boyItem2))
         {
            TweenMax.to(boyItem2,2,{
               "x":pos4.x,
               "y":pos4.y
            });
         }
         if(Boolean(grilItem2))
         {
            TweenMax.to(grilItem2,2,{
               "x":pos2.x,
               "y":pos2.y,
               "onComplete":this.pairingComplete
            });
         }
         if(this._selfItem.info.team == 1)
         {
            TweenMax.to(this._love,2,{
               "x":pos5.x,
               "y":pos5.y
            });
            this._loveII.x = pos5.x;
            this._loveII.y = pos5.y;
         }
         else
         {
            TweenMax.to(this._love,2,{
               "x":pos6.x,
               "y":pos6.y
            });
            this._loveII.x = pos6.x;
            this._loveII.y = pos6.y;
         }
         this._loveII.visible = true;
      }
      
      protected function pairingComplete() : void
      {
         this._pairingComplete = true;
      }
      
      protected function hideArrow() : void
      {
         var i:EncounterLoadingCharacterItem = null;
         for each(i in this._playerItems)
         {
            if(Boolean(i))
            {
               i.arrowVisible = false;
               i.buttonMode = false;
            }
         }
      }
      
      protected function showArrow() : void
      {
         var i:Object = null;
         var item1:EncounterLoadingCharacterItem = null;
         var item2:EncounterLoadingCharacterItem = null;
         var pos1:int = 0;
         var pos2:int = 0;
         var selectList:Array = GameManager.Instance.selectList;
         for each(i in selectList)
         {
            if(i["selectID"] != -1)
            {
               item1 = this.getItem(i["id"],i["zoneID"]);
               item2 = this.getItem(i["selectID"],i["selectZoneID"]);
               pos1 = this.getPosition(i["id"],i["zoneID"]);
               pos2 = this.getPosition(i["selectID"],i["selectZoneID"]);
            }
            else
            {
               item1 = this.getItem(i["id"],i["zoneID"]);
               item2 = this.getItem(this.getTeammateID(item1),this.getTeammateZoneID(item1));
               pos1 = this.getPosition(i["id"],i["zoneID"]);
               pos2 = this.getPosition(this.getTeammateID(item1),this.getTeammateZoneID(item1));
            }
            item1.selectObject = this.getArrowType(pos1,pos2);
         }
      }
      
      protected function getTeammateID(item:RoomLoadingCharacterItem) : int
      {
         var players:Array = GameManager.Instance.Current.roomPlayers;
         for(var i:int = 0; i < players.length; i++)
         {
            if(players[i].team == item.info.team && players[i].playerInfo.ID != item.info.playerInfo.ID)
            {
               return players[i].playerInfo.ID;
            }
         }
         return -1;
      }
      
      protected function getTeammateZoneID(item:RoomLoadingCharacterItem) : int
      {
         var players:Array = GameManager.Instance.Current.roomPlayers;
         for(var i:int = 0; i < players.length; i++)
         {
            if(players[i].team == item.info.team && players[i].playerInfo.ID != item.info.playerInfo.ID && players[i].playerInfo.ZoneID != item.info.playerInfo.ZoneID)
            {
               return players[i].playerInfo.ZoneID;
            }
         }
         return -1;
      }
      
      protected function getArrowType(pos1:int, pos2:int) : int
      {
         if(Math.abs(pos1 - pos2) == 2)
         {
            return 1;
         }
         if(pos1 - pos2 == 3)
         {
            return 2;
         }
         if(pos1 - pos2 == 1)
         {
            return 3;
         }
         if(pos1 - pos2 == -3)
         {
            return 3;
         }
         if(pos1 - pos2 == -1)
         {
            return 2;
         }
         return -1;
      }
      
      protected function getPosition(id:int, zoneID:int) : int
      {
         var item:RoomLoadingCharacterItem = this.getItem(id,zoneID);
         if(Boolean(item) && item.info.playerInfo.Sex)
         {
            if(item.index == 1)
            {
               return 1;
            }
            return 2;
         }
         if(Boolean(item) && !item.info.playerInfo.Sex)
         {
            if(item.index == 1)
            {
               return 3;
            }
            return 4;
         }
         return -1;
      }
      
      protected function getItemByTeam(team:int, sex:Boolean) : EncounterLoadingCharacterItem
      {
         for(var i:int = 0; i < this._playerItems.length; i++)
         {
            if(this._playerItems[i].info.team == team && this._playerItems[i].info.playerInfo.Sex == sex)
            {
               return this._playerItems[i];
            }
         }
         return null;
      }
      
      protected function getItem(id:int, zoneID:int) : EncounterLoadingCharacterItem
      {
         for(var i:int = 0; i < this._playerItems.length; i++)
         {
            if(this._playerItems[i].info.playerInfo.ID == id && this._playerItems[i].info.playerInfo.ZoneID == zoneID)
            {
               return this._playerItems[i];
            }
         }
         return null;
      }
      
      override protected function initLoadingItems() : void
      {
         var blueLen:int = 0;
         var redLen:int = 0;
         var team:int = 0;
         var rp1:RoomPlayer = null;
         var rp:RoomPlayer = null;
         var i:int = 0;
         var roomPlayer:RoomPlayer = null;
         var item:EncounterLoadingCharacterItem = null;
         var gameplayer:Player = null;
         var currentPet:PetInfo = null;
         var skillid:int = 0;
         var skill:PetSkillTemplateInfo = null;
         var ball:BallInfo = null;
         var j:int = 0;
         var skillRes:GameNeedPetSkillInfo = null;
         var len:int = int(_gameInfo.roomPlayers.length);
         var roomPlayers:Array = _gameInfo.roomPlayers;
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
            roomPlayer = _gameInfo.roomPlayers[i];
            roomPlayer.addEventListener(RoomPlayerEvent.PROGRESS_CHANGE,__onLoadingFinished);
            if(roomPlayer.isViewer)
            {
               if(contains(_tipsItem))
               {
                  removeChild(_tipsItem);
               }
               addChild(_viewerItem);
            }
            else
            {
               item = new EncounterLoadingCharacterItem(roomPlayer);
               this.initRoomItem(item);
               gameplayer = _gameInfo.findLivingByPlayerID(roomPlayer.playerInfo.ID,roomPlayer.playerInfo.ZoneID);
               this.initCharacter(gameplayer,item);
               if(RoomManager.Instance.current.type == RoomInfo.TRANSNATIONALFIGHT_ROOM)
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
            }
         }
         if(Boolean(blueBig))
         {
            addChild(blueBig);
         }
         if(Boolean(redBig))
         {
            addChild(redBig);
         }
         if(!StartupResourceLoader.firstEnterHall)
         {
            for(j = 0; j < _gameInfo.neededMovies.length; j++)
            {
               _gameInfo.neededMovies[j].startLoad();
            }
            for each(skillRes in _gameInfo.neededPetSkillResource)
            {
               skillRes.startLoad();
            }
         }
         _gameInfo.loaderMap = new MapLoader(MapManager.getMapInfo(_gameInfo.mapIndex));
         _gameInfo.loaderMap.load();
         switch(NewHandGuideManager.Instance.mapID)
         {
            case 111:
               _trainerLoad = new TrainerLoader("1");
               break;
            case 112:
               _trainerLoad = new TrainerLoader("2");
               break;
            case 113:
               _trainerLoad = new TrainerLoader("3");
               break;
            case 114:
               _trainerLoad = new TrainerLoader("4");
               break;
            case 115:
               _trainerLoad = new TrainerLoader("5");
               break;
            case 116:
               _trainerLoad = new TrainerLoader("6");
         }
         if(Boolean(_trainerLoad))
         {
            _trainerLoad.load();
         }
      }
      
      override protected function initRoomItem(item:RoomLoadingCharacterItem) : void
      {
         var fromPos:Point = null;
         if(item.info.playerInfo.Sex)
         {
            if(this.boyIdx == 1)
            {
               PositionUtils.setPos(item,"asset.roomLoading.EncounterLoadingCharacterItemBoyPos_" + this.boyIdx.toString());
               fromPos = ComponentFactory.Instance.creatCustomObject("asset.roomLoading.EncounterLoadingCharacterItemBoyToPos_" + this.boyIdx.toString());
               blueBig = item;
               ++this.boyIdx;
            }
            else
            {
               PositionUtils.setPos(item,"asset.roomLoading.EncounterLoadingCharacterItemBoyPos_" + this.boyIdx.toString());
               fromPos = ComponentFactory.Instance.creatCustomObject("asset.roomLoading.EncounterLoadingCharacterItemBoyToPos_" + this.boyIdx.toString());
            }
         }
         else if(this.girlIdx == 1)
         {
            PositionUtils.setPos(item,"asset.roomLoading.EncounterLoadingCharacterItemGirlPos_" + this.girlIdx.toString());
            fromPos = ComponentFactory.Instance.creatCustomObject("asset.roomLoading.EncounterLoadingCharacterItemGirlToPos_" + this.girlIdx.toString());
            redBig = item;
            ++this.girlIdx;
         }
         else
         {
            PositionUtils.setPos(item,"asset.roomLoading.EncounterLoadingCharacterItemGirlPos_" + this.girlIdx.toString());
            fromPos = ComponentFactory.Instance.creatCustomObject("asset.roomLoading.EncounterLoadingCharacterItemGirlToPos_" + this.girlIdx.toString());
         }
         this._playerItems.push(item);
         addChild(item);
         if(!item.info.playerInfo.isSelf && item.info.playerInfo.Sex != PlayerManager.Instance.Self.Sex)
         {
            item.buttonMode = true;
            item.addEventListener(MouseEvent.CLICK,this.__onSelectObject);
         }
         if(item.info.playerInfo.isSelf)
         {
            this._selfItem = item as EncounterLoadingCharacterItem;
         }
      }
      
      protected function __onSelectObject(event:MouseEvent) : void
      {
         var i:EncounterLoadingCharacterItem = null;
         var item:EncounterLoadingCharacterItem = event.currentTarget as EncounterLoadingCharacterItem;
         item.buttonMode = false;
         item.removeEventListener(MouseEvent.CLICK,this.__onSelectObject);
         item.bubbleVisible = false;
         GameInSocketOut.sendSelectObject(item.info.playerInfo.ID,item.info.playerInfo.ZoneID);
         for each(i in this._playerItems)
         {
            if(Boolean(i))
            {
               i.buttonMode = false;
               i.bubbleVisible = false;
            }
         }
      }
      
      override protected function initCharacter(gameplayer:Player, item:RoomLoadingCharacterItem) : void
      {
         var size:Rectangle = ComponentFactory.Instance.creatCustomObject("asset.roomloading.BigCharacterSize");
         var suitSize:Rectangle = ComponentFactory.Instance.creatCustomObject("asset.roomloading.SuitCharacterSize");
         gameplayer.movie = item.info.movie;
         gameplayer.character = item.info.character;
         if(item.info.playerInfo.Sex)
         {
            gameplayer.character.showWithSize(false,-1,size.width,size.height);
            PositionUtils.setPos(gameplayer.character,"roomLoading.encounter.characterPos");
            item.index = blueCharacterIndex;
            ++blueCharacterIndex;
         }
         else
         {
            gameplayer.character.showWithSize(false,1,size.width,size.height);
            PositionUtils.setPos(gameplayer.character,"roomLoading.encounter.characterPos1");
            item.index = redCharacterIndex;
            ++redCharacterIndex;
         }
         gameplayer.movie.show(true,-1);
      }
      
      override protected function checkProgress() : Boolean
      {
         var info:RoomPlayer = null;
         var i:int = 0;
         var skillRes:GameNeedPetSkillInfo = null;
         var gameplayer:Player = null;
         var currentPet:PetInfo = null;
         var skillid:int = 0;
         var skill:PetSkillTemplateInfo = null;
         var ball:BallInfo = null;
         _unloadedmsg = "";
         var total:int = 0;
         var finished:int = 0;
         for each(info in _gameInfo.roomPlayers)
         {
            if(!info.isViewer)
            {
               if(!this._pairingComplete)
               {
                  total++;
               }
               gameplayer = _gameInfo.findLivingByPlayerID(info.playerInfo.ID,info.playerInfo.ZoneID);
               if(gameplayer.character.completed)
               {
                  finished++;
               }
               else
               {
                  _unloadedmsg += info.playerInfo.NickName + "gameplayer.character.completed false\n";
                  _unloadedmsg += gameplayer.character.getCharacterLoadLog();
               }
               total++;
               if(gameplayer.movie.completed)
               {
                  finished++;
               }
               else
               {
                  _unloadedmsg += info.playerInfo.NickName + "gameplayer.movie.completed false\n";
               }
               total++;
               if(LoadBombManager.Instance.getLoadBombComplete(info.currentWeapInfo))
               {
                  finished++;
               }
               else
               {
                  _unloadedmsg += "LoadBombManager.getLoadBombComplete(info.currentWeapInfo) false" + LoadBombManager.Instance.getUnloadedBombString(info.currentWeapInfo) + "\n";
               }
               total++;
               currentPet = gameplayer.playerInfo.currentPet;
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
                              _unloadedmsg += "ModuleLoader.hasDefinition(skill.EffectClassLink):" + skill.EffectClassLink + " false\n";
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
                              _unloadedmsg += "BallManager.findBall(skill.NewBallID):" + skill.NewBallID + "false\n";
                           }
                           total++;
                        }
                     }
                  }
               }
            }
         }
         for(i = 0; i < _gameInfo.neededMovies.length; i++)
         {
            if(_gameInfo.neededMovies[i].type == 2)
            {
               if(ModuleLoader.hasDefinition(_gameInfo.neededMovies[i].classPath))
               {
                  finished++;
               }
               else
               {
                  _unloadedmsg += "ModuleLoader.hasDefinition(_gameInfo.neededMovies[i].classPath):" + _gameInfo.neededMovies[i].classPath + " false\n";
               }
               total++;
            }
            else if(_gameInfo.neededMovies[i].type == 1)
            {
               if(LoadBombManager.Instance.getLivingBombComplete(_gameInfo.neededMovies[i].bombId))
               {
                  finished++;
               }
               else
               {
                  _unloadedmsg += "LoadBombManager.getLivingBombComplete(_gameInfo.neededMovies[i].bombId):" + _gameInfo.neededMovies[i].bombId + " false\n";
               }
               total++;
            }
         }
         for each(skillRes in _gameInfo.neededPetSkillResource)
         {
            if(skillRes.effect)
            {
               if(ModuleLoader.hasDefinition(skillRes.effectClassLink))
               {
                  finished++;
               }
               else
               {
                  _unloadedmsg += "ModuleLoader.hasDefinition(" + skillRes.effectClassLink + ") false\n";
               }
               total++;
            }
         }
         if(_gameInfo.loaderMap.completed)
         {
            finished++;
         }
         else
         {
            _unloadedmsg += "_gameInfo.loaderMap.completed false,pic: " + _gameInfo.loaderMap.info.Pic + "id:" + _gameInfo.loaderMap.info.ID + "\n";
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
               _unloadedmsg += "LoadBombManager.getLoadSpecialBombComplete() false  " + LoadBombManager.Instance.getUnloadedSpecialBombString() + "\n";
            }
            total++;
         }
         if(Boolean(_trainerLoad))
         {
            if(_trainerLoad.completed)
            {
               finished++;
            }
            else
            {
               _unloadedmsg += "_trainerLoad.completed false\n";
            }
            total++;
         }
         var pro:Number = int(finished / total * 100);
         var res:Boolean = total == finished;
         if(res && (!this.checkAnimationIsFinished() || !checkIsEnoughDelayTime()))
         {
            pro = 99;
            res = false;
         }
         GameInSocketOut.sendLoadingProgress(pro);
         RoomManager.Instance.current.selfRoomPlayer.progress = pro;
         return res;
      }
      
      override protected function leave() : void
      {
      }
      
      override protected function checkAnimationIsFinished() : Boolean
      {
         var item:EncounterLoadingCharacterItem = null;
         for each(item in _characterItems)
         {
            if(!item.isAnimationFinished)
            {
               return false;
            }
         }
         if(_delayBeginTime <= 0)
         {
            _delayBeginTime = new Date().time;
         }
         return true;
      }
      
      override public function dispose() : void
      {
         var rp:RoomPlayer = null;
         var i:int = 0;
         GameManager.Instance.removeEventListener(GameEvent.SELECT_COMPLETE,this.__pairingComplete);
         KeyboardShortcutsManager.Instance.cancelForbidden();
         _countDownTimer.removeEventListener(TimerEvent.TIMER,__countDownTick);
         _countDownTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,__countDownComplete);
         _countDownTimer.stop();
         _countDownTimer = null;
         ObjectUtils.disposeObject(_trainerLoad);
         ObjectUtils.disposeObject(_bg);
         ObjectUtils.disposeObject(_chatViewBg);
         ObjectUtils.disposeObject(_versus);
         ObjectUtils.disposeObject(_countDownTxt);
         ObjectUtils.disposeObject(_battleField);
         ObjectUtils.disposeObject(_tipsItem);
         ObjectUtils.disposeObject(_viewerItem);
         for each(rp in _gameInfo.roomPlayers)
         {
            rp.removeEventListener(RoomPlayerEvent.PROGRESS_CHANGE,__onLoadingFinished);
         }
         TweenMax.killAll(false,false,false);
         for(i = 0; i < this._playerItems.length; i++)
         {
            TweenMax.killTweensOf(this._playerItems[i]);
            this._playerItems[i].removeEventListener(MouseEvent.CLICK,this.__onSelectObject);
            this._playerItems[i].dispose();
            this._playerItems[i] = null;
         }
         if(Boolean(this._love))
         {
            TweenMax.killTweensOf(this._love);
            ObjectUtils.disposeObject(this._love);
            this._love = null;
         }
         ObjectUtils.disposeObject(_dungeonMapItem);
         _dungeonMapItem = null;
         _characterItems = null;
         _trainerLoad = null;
         _bg = null;
         _chatViewBg = null;
         _gameInfo = null;
         _versus = null;
         _countDownTxt = null;
         _battleField = null;
         _tipsItem = null;
         _countDownTimer = null;
         _viewerItem = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

