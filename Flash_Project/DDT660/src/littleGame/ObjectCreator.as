package littleGame
{
   import littleGame.data.LittleObjectType;
   import littleGame.interfaces.ILittleObject;
   import littleGame.object.BigBoguInhaled;
   import littleGame.object.BoguGiveUp;
   import littleGame.object.NormalBoguInhaled;
   import road7th.comm.PackageIn;
   
   public class ObjectCreator
   {
      
      public function ObjectCreator()
      {
         super();
      }
      
      public static function CreatObject(type:String, pkg:PackageIn = null) : ILittleObject
      {
         var object:ILittleObject = null;
         switch(type)
         {
            case LittleObjectType.NormalBoguInhaled:
               object = new littleGame.object.NormalBoguInhaled();
               break;
            case LittleObjectType.BigBoguInhaled:
               object = new littleGame.object.BigBoguInhaled();
               break;
            case LittleObjectType.BoguGiveup:
               object = new BoguGiveUp();
         }
         return object;
      }
   }
}

