package ddt.data
{
   import ddt.manager.PlayerManager;
   
   public class OpitionEnum
   {
      
      public static const RefusedBeFriend:int = 1;
      
      public static const RefusedPrivateChat:int = 4;
      
      public static const IsSetGuide:int = 32;
      
      public static const IsShowPetSprite:int = 64;
      
      public static const IsShowNewVersionGuide:int = 128;
      
      public function OpitionEnum()
      {
         super();
      }
      
      public static function setOpitionState(value:Boolean, type:int) : int
      {
         var onOff:int = PlayerManager.Instance.Self.OptionOnOff;
         if(value)
         {
            onOff |= type;
         }
         else
         {
            onOff = ~type & onOff;
         }
         return onOff;
      }
   }
}

