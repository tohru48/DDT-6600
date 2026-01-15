package game.objects
{
   import com.pickgliss.loader.ModuleLoader;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.utils.PositionUtils;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.geom.Point;
   import pet.date.PetInfo;
   import road.game.resource.ActionMovie;
   
   public class GamePetMovie extends Sprite implements Disposeable
   {
      
      public static const PlayEffect:String = "PlayEffect";
      
      private var _petInfo:PetInfo;
      
      private var _player:GamePlayer;
      
      private var _petMovie:ActionMovie;
      
      public function GamePetMovie(info:PetInfo, player:GamePlayer)
      {
         super();
         this._petInfo = info;
         this._player = player;
         this.init();
         this.initEvent();
      }
      
      private function initEvent() : void
      {
         if(Boolean(this._petMovie))
         {
            this._petMovie.addEventListener("effect",this.__playPlayerEffect);
         }
      }
      
      protected function __playPlayerEffect(event:Event) : void
      {
         dispatchEvent(new Event(PlayEffect));
      }
      
      public function init() : void
      {
         var movieClass:Class = null;
         if(this._petInfo.assetReady)
         {
            movieClass = ModuleLoader.getDefinition(this._petInfo.actionMovieName) as Class;
            this._petMovie = new movieClass();
            addChild(this._petMovie);
         }
      }
      
      public function show(x:int = 0, y:int = 0) : void
      {
         this._player.map.addToPhyLayer(this);
         PositionUtils.setPos(this,new Point(x,y));
      }
      
      public function hide() : void
      {
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
      
      public function get info() : PetInfo
      {
         return this._petInfo;
      }
      
      public function set direction(val:int) : void
      {
         if(Boolean(this._petMovie))
         {
            this._petMovie.scaleX = -val;
         }
      }
      
      public function doAction(type:String, callBack:Function = null, args:Array = null) : void
      {
         if(Boolean(this._petMovie))
         {
            this._petMovie.doAction(type,callBack,args);
         }
      }
      
      public function dispose() : void
      {
         if(Boolean(this._petMovie))
         {
            this._petMovie.removeEventListener("effect",this.__playPlayerEffect);
         }
         ObjectUtils.disposeObject(this._petMovie);
         this._petMovie = null;
      }
   }
}

