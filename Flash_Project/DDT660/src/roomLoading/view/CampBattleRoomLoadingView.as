package roomLoading.view
{
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.LoadResourceManager;
   import ddt.data.BallInfo;
   import ddt.loader.MapLoader;
   import ddt.loader.StartupResourceLoader;
   import ddt.loader.TrainerLoader;
   import ddt.manager.BallManager;
   import ddt.manager.LoadBombManager;
   import ddt.manager.MapManager;
   import ddt.manager.PathManager;
   import ddt.manager.PetSkillManager;
   import ddt.manager.PlayerManager;
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
   import trainer.controller.NewHandGuideManager;
   
   public class CampBattleRoomLoadingView extends RoomLoadingView
   {
      
      public function CampBattleRoomLoadingView($info:GameInfo)
      {
         super($info);
      }
      
      override protected function initLoadingItems() : void
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
         var skillid:int = 0;
         var skill:PetSkillTemplateInfo = null;
         var ball:BallInfo = null;
         var j:int = 0;
         var skillRes:GameNeedPetSkillInfo = null;
         var len:int = int(_gameInfo.roomPlayers.length);
         roomPlayers = _gameInfo.roomPlayers;
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
               item = new RoomLoadingCharacterItem(roomPlayer);
               initRoomItem(item);
               gameplayer = _gameInfo.findLivingByPlayerID(roomPlayer.playerInfo.ID,roomPlayer.playerInfo.ZoneID);
               initCharacter(gameplayer,item);
               currentPet = gameplayer.playerInfo.currentPet;
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
               if(_gameInfo.neededMovies[j].type == 1)
               {
                  _gameInfo.neededMovies[j].startLoad();
               }
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
   }
}

