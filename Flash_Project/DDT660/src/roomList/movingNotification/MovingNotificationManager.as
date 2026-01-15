package roomList.movingNotification
{
   import ddt.data.analyze.MovingNotificationAnalyzer;
   import flash.display.DisplayObjectContainer;
   
   public class MovingNotificationManager
   {
      
      private static var _instance:MovingNotificationManager;
      
      private var _list:Array;
      
      private var _view:MovingNotificationView;
      
      public function MovingNotificationManager()
      {
         super();
         this._list = [];
      }
      
      public static function get Instance() : MovingNotificationManager
      {
         if(!_instance)
         {
            _instance = new MovingNotificationManager();
         }
         return _instance;
      }
      
      public function setup(analyzer:MovingNotificationAnalyzer) : void
      {
         this._list = analyzer.list;
      }
      
      public function showIn(display:DisplayObjectContainer) : void
      {
         if(!this._view)
         {
            this._view = new MovingNotificationView();
         }
         this._view.list = this._list;
         display.addChild(this._view);
      }
      
      public function get view() : MovingNotificationView
      {
         return this._view;
      }
      
      public function hide() : void
      {
         if(Boolean(this._view))
         {
            this._view.dispose();
         }
         this._view = null;
      }
   }
}

