package ddt.manager
{
   import ddt.data.BallInfo;
   import ddt.loader.StartupResourceLoader;
   import flash.utils.Dictionary;
   import room.model.RoomPlayer;
   import room.model.WeaponInfo;
   
   public class LoadBombManager
   {
      
      private static var _instance:LoadBombManager;
      
      public static const SpecialBomb:Array = [1,3,4,64,59,97,98,120];
      
      private var _tempWeaponInfos:Dictionary;
      
      private var _tempCraterIDs:Dictionary;
      
      public function LoadBombManager()
      {
         super();
      }
      
      public static function get Instance() : LoadBombManager
      {
         if(_instance == null)
         {
            _instance = new LoadBombManager();
         }
         return _instance;
      }
      
      public function loadFullRoomPlayersBomb(roomPlayers:Array) : void
      {
         this.loadFullWeaponBombMovie(roomPlayers);
         this.loadFullWeaponBombBitMap(roomPlayers);
      }
      
      private function loadFullWeaponBombMovie(roomPlayers:Array) : void
      {
         var player:RoomPlayer = null;
         var weapInfo:WeaponInfo = null;
         this._tempWeaponInfos = null;
         this._tempWeaponInfos = new Dictionary();
         for each(player in roomPlayers)
         {
            if(!player.isViewer && !this._tempWeaponInfos[player.currentWeapInfo.TemplateID])
            {
               this._tempWeaponInfos[player.currentWeapInfo.TemplateID] = player.currentWeapInfo;
            }
         }
         if(!StartupResourceLoader.firstEnterHall)
         {
            for each(weapInfo in this._tempWeaponInfos)
            {
               this.loadBomb(weapInfo);
            }
         }
      }
      
      private function loadFullWeaponBombBitMap(roomPlayers:Array) : void
      {
         var weapInfo:WeaponInfo = null;
         var ballInfo:BallInfo = null;
         var i:int = 0;
         this._tempCraterIDs = null;
         this._tempCraterIDs = new Dictionary();
         for each(weapInfo in this._tempWeaponInfos)
         {
            for(i = 0; i < weapInfo.bombs.length; i++)
            {
               if(!this._tempCraterIDs[BallManager.findBall(weapInfo.bombs[i]).craterID])
               {
                  this._tempCraterIDs[BallManager.findBall(weapInfo.bombs[i]).craterID] = BallManager.findBall(weapInfo.bombs[i]);
               }
            }
         }
         for each(ballInfo in this._tempCraterIDs)
         {
            ballInfo.loadCraterBitmap();
         }
      }
      
      private function loadBomb(info:WeaponInfo) : void
      {
         for(var i:int = 0; i < info.bombs.length; i++)
         {
            BallManager.findBall(info.bombs[i]).loadBombAsset();
         }
      }
      
      public function getLoadBombComplete(info:WeaponInfo) : Boolean
      {
         for(var i:int = 0; i < info.bombs.length; i++)
         {
            if(!BallManager.findBall(info.bombs[i]).isComplete())
            {
               return false;
            }
         }
         return true;
      }
      
      public function getUnloadedBombString(info:WeaponInfo) : String
      {
         var result:String = "";
         for(var i:int = 0; i < info.bombs.length; i++)
         {
            if(!BallManager.findBall(info.bombs[i]).isComplete())
            {
               result += info.bombs[i] + ",";
            }
         }
         return result;
      }
      
      public function loadLivingBomb(id:int) : void
      {
         BallManager.findBall(id).loadBombAsset();
         BallManager.findBall(id).loadCraterBitmap();
      }
      
      public function getLivingBombComplete(id:int) : Boolean
      {
         return BallManager.findBall(id).isComplete();
      }
      
      public function loadSpecialBomb() : void
      {
         for(var i:int = 0; i < SpecialBomb.length; i++)
         {
            BallManager.findBall(SpecialBomb[i]).loadBombAsset();
            BallManager.findBall(SpecialBomb[i]).loadCraterBitmap();
         }
      }
      
      public function getUnloadedSpecialBombString() : String
      {
         var result:String = "";
         for(var i:int = 0; i < SpecialBomb.length; i++)
         {
            if(!BallManager.findBall(SpecialBomb[i]).isComplete())
            {
               result += SpecialBomb[i] + ",";
            }
         }
         return result;
      }
      
      public function getLoadSpecialBombComplete() : Boolean
      {
         for(var i:int = 0; i < SpecialBomb.length; i++)
         {
            if(!BallManager.findBall(SpecialBomb[i]).isComplete())
            {
               return false;
            }
         }
         return true;
      }
   }
}

