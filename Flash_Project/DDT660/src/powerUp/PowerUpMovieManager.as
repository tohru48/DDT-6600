package powerUp
{
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.SocketManager;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   
   public class PowerUpMovieManager extends EventDispatcher
   {
      
      private static var _instance:PowerUpMovieManager;
      
      public static var powerNum:int;
      
      public static var addedPowerNum:int;
      
      public static var isInPlayerInfoView:Boolean;
      
      public static var isCanPlayMovie:Boolean;
      
      public static const POWER_UP:String = "powerUp";
      
      public static const POWER_UP_MOVIE_OVER:String = "powerUpMovieOver";
      
      private var _powerMovie:PowerSprite;
      
      public function PowerUpMovieManager()
      {
         super();
      }
      
      public static function get Instance() : PowerUpMovieManager
      {
         if(_instance == null)
         {
            _instance = new PowerUpMovieManager();
         }
         return _instance;
      }
      
      public function setup() : void
      {
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.UPDATE_LOGIN_FIGHTPOWER,this.__fightPowerHandler);
         addEventListener(POWER_UP,this.__powerUpHandler);
      }
      
      protected function __fightPowerHandler(event:CrazyTankSocketEvent) : void
      {
         powerNum = event.pkg.readInt();
         isCanPlayMovie = true;
      }
      
      protected function __powerUpMovieOverHandler(event:Event) : void
      {
         if(Boolean(this._powerMovie))
         {
            this._powerMovie.removeEventListener(POWER_UP_MOVIE_OVER,this.__powerUpMovieOverHandler);
         }
         if(Boolean(this._powerMovie))
         {
            ObjectUtils.disposeObject(this._powerMovie);
         }
         this._powerMovie = null;
         powerNum += addedPowerNum;
      }
      
      protected function __powerUpHandler(event:Event) : void
      {
         if(Boolean(this._powerMovie))
         {
            return;
         }
         this._powerMovie = new PowerSprite(powerNum,addedPowerNum);
         this._powerMovie.x = 220;
         this._powerMovie.y = 250;
         this._powerMovie.addEventListener(POWER_UP_MOVIE_OVER,this.__powerUpMovieOverHandler);
         LayerManager.Instance.addToLayer(this._powerMovie,LayerManager.STAGE_TOP_LAYER,false,LayerManager.BLCAK_BLOCKGOUND);
      }
   }
}

