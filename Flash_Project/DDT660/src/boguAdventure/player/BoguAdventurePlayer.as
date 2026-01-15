package boguAdventure.player
{
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.BitmapLoader;
   import com.pickgliss.loader.LoaderEvent;
   import com.pickgliss.loader.LoaderManager;
   import ddt.manager.PathManager;
   import ddt.view.sceneCharacter.SceneCharacterActionItem;
   import ddt.view.sceneCharacter.SceneCharacterActionSet;
   import ddt.view.sceneCharacter.SceneCharacterDirection;
   import ddt.view.sceneCharacter.SceneCharacterItem;
   import ddt.view.sceneCharacter.SceneCharacterPlayerBase;
   import ddt.view.sceneCharacter.SceneCharacterSet;
   import ddt.view.sceneCharacter.SceneCharacterStateItem;
   import ddt.view.sceneCharacter.SceneCharacterStateSet;
   import flash.display.BitmapData;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class BoguAdventurePlayer extends SceneCharacterPlayerBase
   {
      
      public static const STOP:String = "bogustop";
      
      public static const WALK:String = "boguwalk";
      
      public static const WEEP:String = "boguweep";
      
      public static const LAUGH:String = "bogulaugh";
      
      private var _playerStateSet:SceneCharacterStateSet;
      
      private var _playerSetNatural:SceneCharacterSet;
      
      private var _playerActionSetNatural:SceneCharacterActionSet;
      
      public var playerWitdh:Number = 114;
      
      public var playerHeight:Number = 95;
      
      private var _callBack:Function;
      
      private var _dir:SceneCharacterDirection = SceneCharacterDirection.RB;
      
      private var _focusArr:Array;
      
      private var _focus:Point;
      
      public function BoguAdventurePlayer(callBack:Function = null)
      {
         super(callBack);
         this._callBack = callBack;
         this.initialize();
      }
      
      private function initialize() : void
      {
         this._playerStateSet = new SceneCharacterStateSet();
         this._playerSetNatural = new SceneCharacterSet();
         this._playerActionSetNatural = new SceneCharacterActionSet();
         this.sceneCharacterStateNatural();
         this._focusArr = [new Point(68,82),new Point(-73,82)];
         this._focus = this._focusArr[0];
      }
      
      private function sceneCharacterStateNatural() : void
      {
         var image:BitmapLoader = LoaderManager.Instance.creatLoader(PathManager.solveBoguAdventurePath(),BaseLoader.BITMAP_LOADER);
         image.addEventListener(LoaderEvent.COMPLETE,this.__onLoaderPlayerStateImageComplete);
         LoaderManager.Instance.startLoad(image);
      }
      
      private function __onLoaderPlayerStateImageComplete(e:LoaderEvent) : void
      {
         var actionBmp:BitmapData = null;
         e.loader.removeEventListener(LoaderEvent.COMPLETE,this.__onLoaderPlayerStateImageComplete);
         var playerImage:BitmapData = (e.loader as BitmapLoader).bitmapData;
         if(!playerImage)
         {
            if(this._callBack != null)
            {
               this._callBack(this,false);
            }
            return;
         }
         var _rectangle:Rectangle = new Rectangle(0,0,playerImage.width,playerImage.height);
         actionBmp = new BitmapData(_rectangle.width,_rectangle.height,true,0);
         actionBmp.copyPixels(playerImage,_rectangle,new Point(0,0));
         this._playerSetNatural.push(new SceneCharacterItem("NaturalBody","NaturalAction",actionBmp,3,11,this.playerWitdh,this.playerHeight,3));
         var sceneCharacterActionItem1:SceneCharacterActionItem = new SceneCharacterActionItem(STOP,[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,10,10,10,10,10,10,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,6,6,7,7,8,8,9,9,9,9,8,8,7,7,6,6,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,10,10,10,10,10,10,0,0,0,0],true);
         this._playerActionSetNatural.push(sceneCharacterActionItem1);
         var sceneCharacterActionItem2:SceneCharacterActionItem = new SceneCharacterActionItem(WALK,[1,1,1,2,2,2,3,3,3,4,4,4,5,5,5,6,6,6],true);
         this._playerActionSetNatural.push(sceneCharacterActionItem2);
         var sceneCharacterActionItem3:SceneCharacterActionItem = new SceneCharacterActionItem(WEEP,[14,14,14,15,15,15,16,16,16],true);
         this._playerActionSetNatural.push(sceneCharacterActionItem3);
         var sceneCharacterActionItem4:SceneCharacterActionItem = new SceneCharacterActionItem(LAUGH,[11,11,12,12,13,13],true);
         this._playerActionSetNatural.push(sceneCharacterActionItem4);
         var _sceneCharacterStateItemNatural:SceneCharacterStateItem = new SceneCharacterStateItem("natural",this._playerSetNatural,this._playerActionSetNatural);
         this._playerStateSet.push(_sceneCharacterStateItemNatural);
         super.sceneCharacterStateSet = this._playerStateSet;
      }
      
      public function set dir(value:SceneCharacterDirection) : void
      {
         if(value == null || this._dir == value)
         {
            return;
         }
         this._dir = value;
         if(this._dir == SceneCharacterDirection.LB)
         {
            if(this.scaleX == -1)
            {
               return;
            }
            this.scaleX = -1;
            this.x += this.width;
            this._focus = this._focusArr[1];
         }
         else
         {
            if(this.scaleX == 1)
            {
               return;
            }
            this.scaleX = 1;
            this.x -= this.width;
            this._focus = this._focusArr[0];
         }
      }
      
      public function get dir() : SceneCharacterDirection
      {
         return this._dir;
      }
      
      public function get focusPos() : Point
      {
         return this._focus;
      }
      
      override public function dispose() : void
      {
         if(Boolean(this._playerSetNatural))
         {
            this._playerSetNatural.dispose();
         }
         this._playerSetNatural = null;
         if(Boolean(this._playerActionSetNatural))
         {
            this._playerActionSetNatural.dispose();
         }
         this._playerActionSetNatural = null;
         if(Boolean(this._playerStateSet))
         {
            this._playerStateSet.dispose();
         }
         this._playerStateSet = null;
         this._dir = null;
         this._focusArr = null;
         this._focus = null;
         super.dispose();
      }
   }
}

