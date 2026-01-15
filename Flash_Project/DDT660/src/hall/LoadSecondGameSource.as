package hall
{
   import ddt.manager.BallManager;
   import game.model.GameNeedMovieInfo;
   
   public class LoadSecondGameSource
   {
      
      private var needMovieInfos:Vector.<GameNeedMovieInfo>;
      
      private var bombIDs:Array = [121,1212,1211,131,891];
      
      public function LoadSecondGameSource()
      {
         super();
         this.needMovieInfos = new Vector.<GameNeedMovieInfo>();
         this.addGameNeedMovieInfo(1,"bombs/61.swf","tank.resource.bombs.Bomb61");
         this.addGameNeedMovieInfo(2,"image/game/thing/BossBornBgAsset.swf","game.asset.living.BossBgAsset");
         this.addGameNeedMovieInfo(2,"image/game/thing/BossBornBgAsset.swf","game.asset.living.boguoLeaderAsset");
         this.addGameNeedMovieInfo(2,"image/game/living/Living002.swf","game.living.Living002");
         this.addGameNeedMovieInfo(2,"image/game/living/Living003.swf","game.living.Living003");
      }
      
      public function startLoad() : void
      {
         for(var i:int = 0; i < this.bombIDs.length; i++)
         {
            BallManager.findBall(this.bombIDs[i]).loadBombAsset();
         }
         for(var j:int = 0; j < this.needMovieInfos.length; j++)
         {
            this.needMovieInfos[j].startLoad();
         }
      }
      
      private function addGameNeedMovieInfo(type:int, path:String, classPath:String) : void
      {
         var movieInfo:GameNeedMovieInfo = new GameNeedMovieInfo();
         movieInfo.type = type;
         movieInfo.path = path;
         movieInfo.classPath = classPath;
         this.needMovieInfos.push(movieInfo);
      }
   }
}

