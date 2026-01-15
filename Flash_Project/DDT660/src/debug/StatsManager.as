package debug
{
   import com.pickgliss.toplevel.StageReferance;
   import ddt.manager.PathManager;
   import flash.events.KeyboardEvent;
   
   public class StatsManager
   {
      
      private static var _instance:StatsManager;
      
      private var _statsView:Stats;
      
      public function StatsManager()
      {
         super();
      }
      
      public static function get instance() : StatsManager
      {
         if(_instance == null)
         {
            _instance = new StatsManager();
         }
         return _instance;
      }
      
      public function setup() : void
      {
         if(PathManager.gameStatsEnable)
         {
            this._statsView = new Stats();
            this._statsView.visible = false;
            StageReferance.stage.addChild(this._statsView);
            StageReferance.stage.addEventListener(KeyboardEvent.KEY_DOWN,this.__keyDownHandler);
         }
      }
      
      private function __keyDownHandler(evt:KeyboardEvent) : void
      {
         if(evt.keyCode == 36 && this._statsView && this._statsView.parent && this._statsView.parent.numChildren > 0)
         {
            this._statsView.visible = !this._statsView.visible;
            this._statsView.parent.setChildIndex(this._statsView,this._statsView.parent.numChildren - 1);
         }
      }
   }
}

