package church.view.menu
{
   import ddt.data.player.PlayerInfo;
   
   public class MenuView
   {
      
      private static var _menu:MenuPanel;
      
      public function MenuView()
      {
         super();
      }
      
      public static function show(info:PlayerInfo) : void
      {
         if(info == null)
         {
            return;
         }
         if(_menu == null)
         {
            _menu = new MenuPanel();
         }
         _menu.playerInfo = info;
         _menu.show();
      }
      
      public static function hide() : void
      {
         if(Boolean(_menu))
         {
            _menu.hide();
         }
      }
      
      public function dispose() : void
      {
         if(Boolean(_menu) && Boolean(_menu.parent))
         {
            _menu.parent.removeChild(_menu);
         }
         if(Boolean(_menu))
         {
            _menu.dispose();
         }
         _menu = null;
      }
   }
}

