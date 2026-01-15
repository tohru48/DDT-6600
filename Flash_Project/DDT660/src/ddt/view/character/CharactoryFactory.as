package ddt.view.character
{
   import ddt.data.player.PlayerInfo;
   
   public class CharactoryFactory
   {
      
      public static const SHOW:String = "show";
      
      public static const GAME:String = "game";
      
      public static const CONSORTIA:String = "consortia";
      
      public static const ROOM:String = "room";
      
      private static var _characterloaderfactory:ICharacterLoaderFactory = new CharacterLoaderFactory();
      
      public function CharactoryFactory()
      {
         super();
      }
      
      public static function createCharacter(info:PlayerInfo, type:String = "show", multiFrame:Boolean = false, showLightn:Boolean = true) : ICharacter
      {
         var _character:ICharacter = null;
         switch(type)
         {
            case SHOW:
               _character = new ShowCharacter(info,true,showLightn,multiFrame);
               break;
            case GAME:
               _character = new GameCharacter(info);
               break;
            case ROOM:
               _character = new RoomCharacter(info);
         }
         if(_character != null)
         {
            _character.setFactory(_characterloaderfactory);
         }
         return _character;
      }
   }
}

