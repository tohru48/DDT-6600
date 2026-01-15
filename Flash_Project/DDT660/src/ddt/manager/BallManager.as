package ddt.manager
{
   import com.pickgliss.utils.ClassUtils;
   import ddt.data.BallInfo;
   import ddt.data.analyze.BallInfoAnalyzer;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.utils.Dictionary;
   import game.objects.BombAsset;
   
   public class BallManager
   {
      
      private static var _list:Vector.<BallInfo>;
      
      private static var _gameInBombAssets:Dictionary;
      
      public static const CRATER:int = 0;
      
      public static const CREATER_BRINK:int = 1;
      
      public function BallManager()
      {
         super();
      }
      
      public static function setup(analyzer:BallInfoAnalyzer) : void
      {
         _list = analyzer.list;
         _gameInBombAssets = new Dictionary();
      }
      
      public static function addBombAsset(id:int, asset:Bitmap, type:int) : void
      {
         if(_gameInBombAssets[id] == null)
         {
            _gameInBombAssets[id] = new BombAsset();
         }
         if(type == CRATER)
         {
            if(_gameInBombAssets[id].crater == null)
            {
               _gameInBombAssets[id].crater = asset;
            }
         }
         else if(type == CREATER_BRINK)
         {
            if(_gameInBombAssets[id].craterBrink == null)
            {
               _gameInBombAssets[id].craterBrink = asset;
            }
         }
      }
      
      public static function hasBombAsset(id:int) : Boolean
      {
         return _gameInBombAssets[id] != null;
      }
      
      public static function getBombAsset(id:int) : BombAsset
      {
         return _gameInBombAssets[id];
      }
      
      public static function get ready() : Boolean
      {
         return _list != null;
      }
      
      public static function findBall(id:int) : BallInfo
      {
         var result:BallInfo = null;
         var info:BallInfo = null;
         for each(info in _list)
         {
            if(info.ID == id)
            {
               result = info;
               break;
            }
         }
         return result;
      }
      
      public static function solveBallAssetName(bombid:int) : String
      {
         return "tank.resource.bombs.Bomb" + bombid;
      }
      
      public static function solveBallWeaponMovieName(bombid:int) : String
      {
         return "tank.resource.bombs.BombMovie" + bombid;
      }
      
      public static function createBallWeaponMovie(bombid:int) : MovieClip
      {
         return ClassUtils.CreatInstance(solveBallWeaponMovieName(bombid)) as MovieClip;
      }
      
      public static function createBallAsset(bombid:int) : Sprite
      {
         return ClassUtils.CreatInstance(solveBallAssetName(bombid)) as Sprite;
      }
      
      public static function solveBlastOutMovieName(id:int) : String
      {
         return "blastOutMovie" + id;
      }
      
      public static function solveBulletMovieName(id:int) : String
      {
         return "bullet" + id;
      }
      
      public static function solveShootMovieMovieName(id:int) : String
      {
         return "shootMovie" + id;
      }
      
      public static function createBlastOutMovie(id:int) : MovieClip
      {
         return ClassUtils.CreatInstance(solveBlastOutMovieName(id)) as MovieClip;
      }
      
      public static function createBulletMovie(id:int) : MovieClip
      {
         return ClassUtils.CreatInstance(solveBulletMovieName(id)) as MovieClip;
      }
      
      public static function createShootMovieMovie(id:int) : MovieClip
      {
         return ClassUtils.CreatInstance(solveShootMovieMovieName(id)) as MovieClip;
      }
      
      public static function clearAsset() : void
      {
         var id:String = null;
         for(id in _gameInBombAssets)
         {
            _gameInBombAssets[id].dispose();
            delete _gameInBombAssets[id];
         }
      }
   }
}

