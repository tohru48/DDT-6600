package ddt.data
{
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.LoadResourceManager;
   import com.pickgliss.loader.LoaderEvent;
   import com.pickgliss.loader.ModuleLoader;
   import ddt.manager.BallManager;
   import ddt.manager.PathManager;
   import flash.geom.Point;
   
   public class BallInfo
   {
      
      public var ID:int = 2;
      
      public var Name:String;
      
      public var Mass:Number = 1;
      
      public var Power:Number;
      
      public var Radii:Number;
      
      public var SpinV:Number = 1000;
      
      public var SpinVA:Number = 1;
      
      public var Amount:Number = 1;
      
      public var Wind:int;
      
      public var Weight:int;
      
      public var DragIndex:int;
      
      public var Shake:Boolean;
      
      public var ShootSound:String;
      
      public var BombSound:String;
      
      public var ActionType:int;
      
      public var blastOutID:int;
      
      public var craterID:int;
      
      public var FlyingPartical:int;
      
      public function BallInfo()
      {
         super();
      }
      
      public function getCarrayBall() : Point
      {
         return new Point(0,90);
      }
      
      public function loadBombAsset() : void
      {
         if(!ModuleLoader.hasDefinition(BallManager.solveBulletMovieName(this.ID)) && !ModuleLoader.hasDefinition(BallManager.solveShootMovieMovieName(this.ID)))
         {
            LoadResourceManager.Instance.creatAndStartLoad(PathManager.solveBlastOut(this.ID),BaseLoader.MODULE_LOADER);
         }
         if(!ModuleLoader.hasDefinition(BallManager.solveBlastOutMovieName(this.blastOutID)))
         {
            LoadResourceManager.Instance.creatAndStartLoad(PathManager.solveBullet(this.blastOutID),BaseLoader.MODULE_LOADER);
         }
      }
      
      public function loadCraterBitmap() : void
      {
         var craterILoader:BaseLoader = null;
         var craterBrinkLoader:BaseLoader = null;
         if(!BallManager.hasBombAsset(this.craterID))
         {
            if(this.craterID != 0)
            {
               craterILoader = LoadResourceManager.Instance.createLoader(PathManager.solveCrater(this.craterID),BaseLoader.BITMAP_LOADER);
               craterILoader.addEventListener(LoaderEvent.COMPLETE,this.__craterComplete);
               LoadResourceManager.Instance.startLoad(craterILoader);
               craterBrinkLoader = LoadResourceManager.Instance.createLoader(PathManager.solveCraterBrink(this.craterID),BaseLoader.BITMAP_LOADER);
               craterBrinkLoader.addEventListener(LoaderEvent.COMPLETE,this.__craterBrinkComplete);
               LoadResourceManager.Instance.startLoad(craterBrinkLoader);
            }
         }
      }
      
      private function __craterComplete(event:LoaderEvent) : void
      {
         (event.currentTarget as BaseLoader).removeEventListener(LoaderEvent.COMPLETE,this.__craterComplete);
         BallManager.addBombAsset(this.craterID,event.loader.content,BallManager.CRATER);
      }
      
      private function __craterBrinkComplete(event:LoaderEvent) : void
      {
         (event.currentTarget as BaseLoader).removeEventListener(LoaderEvent.COMPLETE,this.__craterBrinkComplete);
         BallManager.addBombAsset(this.craterID,event.loader.content,BallManager.CREATER_BRINK);
      }
      
      public function isComplete() : Boolean
      {
         if(BallManager.hasBombAsset(this.craterID) && this.getHasDefinition(this))
         {
            return true;
         }
         if(this.craterID == 0 && this.getHasDefinition(this))
         {
            return true;
         }
         return false;
      }
      
      public function getHasDefinition(info:BallInfo) : Boolean
      {
         if(ModuleLoader.hasDefinition(BallManager.solveBlastOutMovieName(info.blastOutID)))
         {
         }
         if(ModuleLoader.hasDefinition(BallManager.solveBulletMovieName(info.ID)))
         {
         }
         if(ModuleLoader.hasDefinition(BallManager.solveShootMovieMovieName(info.ID)))
         {
         }
         return ModuleLoader.hasDefinition(BallManager.solveBlastOutMovieName(info.blastOutID)) && ModuleLoader.hasDefinition(BallManager.solveBulletMovieName(info.ID));
      }
   }
}

